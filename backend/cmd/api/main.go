package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"

	"github.com/go-chi/chi/v5"
	chimw "github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"

	"github.com/cloudparallax/veli/internal/config"
	"github.com/cloudparallax/veli/internal/db"
	"github.com/cloudparallax/veli/internal/handler"
	velimw "github.com/cloudparallax/veli/internal/middleware"
	"github.com/cloudparallax/veli/internal/repository"
	"github.com/cloudparallax/veli/internal/service"
)

func main() {
	configPath := flag.String("config", "configs/veli.yaml", "path to YAML config file")
	flag.Parse()

	cfg, err := config.Load(*configPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "fatal: load config: %v\n", err)
		os.Exit(1)
	}

	logger, err := buildLogger(cfg.Observability)
	if err != nil {
		fmt.Fprintf(os.Stderr, "fatal: build logger: %v\n", err)
		os.Exit(1)
	}
	defer func() { _ = logger.Sync() }()

	rootCtx := context.Background()

	pool, err := db.Open(rootCtx, cfg.Database)
	if err != nil {
		logger.Fatal("open database", zap.Error(err))
	}
	defer pool.Close()
	logger.Info("database connected",
		zap.Int32("max_conns", pool.Config().MaxConns),
		zap.Int32("min_conns", pool.Config().MinConns),
	)

	if cfg.Database.AutoMigrate {
		logger.Info("running goose migrations")
		if err := db.MigrateUp(rootCtx, pool); err != nil {
			logger.Fatal("migrate up", zap.Error(err))
		}
	}

	bobDB := db.NewBobDB(pool)
	usersRepo := repository.NewUsersRepository(bobDB)
	usersSvc := service.NewUsersService(usersRepo)
	usersHandler := &handler.UsersHandler{Service: usersSvc, Logger: logger}

	rolesRepo := repository.NewRolesRepository(bobDB)
	rbacSvc := service.NewRBACService(rolesRepo)
	adminHandler := &handler.AdminHandler{Users: usersSvc, RBAC: rbacSvc, Logger: logger}

	externalRepo := repository.NewExternalIdentitiesRepository(bobDB)
	authSvc, err := service.NewAuthService(rootCtx, service.GoogleAuthConfig{
		ClientID:     cfg.Auth.GoogleClientID,
		ClientSecret: cfg.Auth.GoogleClientSecret,
		RedirectURL:  cfg.Auth.GoogleRedirectURL,
	}, externalRepo)
	if err != nil {
		logger.Fatal("init auth service", zap.Error(err))
	}
	if authSvc != nil {
		logger.Info("google sign-in configured",
			zap.String("redirect_url", cfg.Auth.GoogleRedirectURL))
	} else {
		logger.Info("google sign-in disabled (no VELI_AUTH_GOOGLE_CLIENT_ID)")
	}
	authHandler := &handler.AuthHandler{
		Auth:          authSvc,
		RBAC:          rbacSvc,
		Users:         usersSvc,
		SessionSecret: []byte(cfg.Auth.SessionSecret),
		FrontendURL:   cfg.Auth.FrontendURL,
		Logger:        logger,
	}

	r := chi.NewRouter()
	r.Use(chimw.RequestID)
	r.Use(chimw.Recoverer)
	r.Use(velimw.RequestLogger(logger))
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   cfg.Auth.AllowedOrigins,
		AllowedMethods:   []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	if len(cfg.Auth.SessionSecret) > 0 {
		r.Use(velimw.SessionAuth([]byte(cfg.Auth.SessionSecret)))
	}
	if cfg.Auth.DevMode {
		logger.Warn("dev-mode auth enabled — X-User-ID header is trusted; never run this in production")
		r.Use(velimw.AuthDevHeader)
	}

	r.Get("/healthz", handler.Health)
	r.Get("/readyz", handler.Ready(pool))

	r.Route("/api/v1", func(r chi.Router) {
		r.Get("/hello", handler.Hello)
		r.Post("/users", usersHandler.Create)
		r.Get("/users/{id}", usersHandler.Get)

		r.Route("/auth", func(r chi.Router) {
			r.Get("/google/start", authHandler.GoogleStart)
			r.Get("/google/callback", authHandler.GoogleCallback)
			r.Get("/me", authHandler.Me)
			r.Post("/logout", authHandler.Logout)
		})

		r.Route("/admin", func(r chi.Router) {
			r.Get("/me", adminHandler.Me)

			r.With(velimw.RequirePermission(rbacSvc, logger, "users:list")).
				Get("/users", adminHandler.ListUsers)
			r.With(velimw.RequirePermission(rbacSvc, logger, "users:read")).
				Get("/users/{id}", adminHandler.GetUser)
			r.With(velimw.RequirePermission(rbacSvc, logger, "roles:list")).
				Get("/users/{id}/roles", adminHandler.ListUserRoles)
			r.With(velimw.RequirePermission(rbacSvc, logger, "roles:assign")).
				Post("/users/{id}/roles", adminHandler.AssignRole)
			r.With(velimw.RequirePermission(rbacSvc, logger, "roles:assign")).
				Delete("/users/{id}/roles/{code}", adminHandler.RevokeRole)
		})
	})

	r.NotFound(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusNotFound)
		_ = json.NewEncoder(w).Encode(map[string]string{"error": "not found"})
	})

	server := &http.Server{
		Addr:         cfg.Server.Listen,
		Handler:      r,
		ReadTimeout:  cfg.Server.ReadTimeout,
		WriteTimeout: cfg.Server.WriteTimeout,
	}

	go func() {
		sigCh := make(chan os.Signal, 1)
		signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
		<-sigCh
		logger.Info("shutting down")
		ctx, cancel := context.WithTimeout(context.Background(), cfg.Server.ShutdownTimeout)
		defer cancel()
		if err := server.Shutdown(ctx); err != nil {
			logger.Error("shutdown error", zap.Error(err))
		}
	}()

	logger.Info("veli api starting", zap.String("listen", cfg.Server.Listen))
	if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		logger.Error("server error", zap.Error(err))
		os.Exit(1)
	}
	logger.Info("server stopped")
}

func buildLogger(obs config.ObservabilityConfig) (*zap.Logger, error) {
	level := zap.NewAtomicLevelAt(parseLevel(obs.LogLevel))
	var zcfg zap.Config
	if strings.EqualFold(obs.LogFormat, "json") {
		zcfg = zap.NewProductionConfig()
	} else {
		zcfg = zap.NewDevelopmentConfig()
	}
	zcfg.Level = level
	logger, err := zcfg.Build()
	if err != nil {
		return nil, fmt.Errorf("zap build: %w", err)
	}
	return logger, nil
}

func parseLevel(s string) zapcore.Level {
	switch strings.ToLower(s) {
	case "debug":
		return zapcore.DebugLevel
	case "warn", "warning":
		return zapcore.WarnLevel
	case "error":
		return zapcore.ErrorLevel
	default:
		return zapcore.InfoLevel
	}
}
