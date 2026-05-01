// Package config loads Veḷi backend configuration from YAML files
// with environment-variable overrides (VELI_*).
package config

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"gopkg.in/yaml.v3"
)

type Config struct {
	Server        ServerConfig        `yaml:"server"`
	Database      DatabaseConfig      `yaml:"database"`
	Auth          AuthConfig          `yaml:"auth"`
	Observability ObservabilityConfig `yaml:"observability"`
}

type ServerConfig struct {
	Listen          string        `yaml:"listen"`
	ReadTimeout     time.Duration `yaml:"read_timeout"`
	WriteTimeout    time.Duration `yaml:"write_timeout"`
	ShutdownTimeout time.Duration `yaml:"shutdown_timeout"`
}

type DatabaseConfig struct {
	DSN             string        `yaml:"dsn"`
	MaxOpenConns    int           `yaml:"max_open_conns"`
	MaxIdleConns    int           `yaml:"max_idle_conns"`
	ConnMaxLifetime time.Duration `yaml:"conn_max_lifetime"`
	AutoMigrate     bool          `yaml:"auto_migrate"`
}

type AuthConfig struct {
	JWTSecret      string        `yaml:"jwt_secret"`
	TokenExpiry    time.Duration `yaml:"token_expiry"`
	AllowedOrigins []string      `yaml:"allowed_origins"`
	FrontendURL    string        `yaml:"frontend_url"`
	// DevMode trusts the X-User-ID header as the request actor.
	// Local development only; never enable in any deploy.
	DevMode bool `yaml:"dev_mode"`
}

type ObservabilityConfig struct {
	LogLevel  string `yaml:"log_level"`
	LogFormat string `yaml:"log_format"`
}

func DefaultConfig() *Config {
	cfg := &Config{}

	cfg.Server.Listen = ":8080"
	cfg.Server.ReadTimeout = 30 * time.Second
	cfg.Server.WriteTimeout = 30 * time.Second
	cfg.Server.ShutdownTimeout = 15 * time.Second

	cfg.Database.DSN = "postgres://veli:veli@localhost:5432/veli?sslmode=disable"
	cfg.Database.MaxOpenConns = 25
	cfg.Database.MaxIdleConns = 5
	cfg.Database.ConnMaxLifetime = 5 * time.Minute
	cfg.Database.AutoMigrate = false

	cfg.Auth.JWTSecret = "CHANGE-ME-IN-PRODUCTION"
	cfg.Auth.TokenExpiry = 24 * time.Hour
	cfg.Auth.AllowedOrigins = []string{"http://localhost:5173"}
	cfg.Auth.FrontendURL = "http://localhost:5173"

	cfg.Observability.LogLevel = "info"
	cfg.Observability.LogFormat = "json"

	return cfg
}

// Load reads a YAML config file and applies VELI_* environment overrides.
// A missing file is not fatal — defaults plus env vars are still usable.
func Load(path string) (*Config, error) {
	cfg := DefaultConfig()

	data, err := os.ReadFile(path)
	switch {
	case err == nil:
		if err := yaml.Unmarshal(data, cfg); err != nil {
			return nil, fmt.Errorf("parse config file: %w", err)
		}
	case os.IsNotExist(err):
		// fall through with defaults
	default:
		return nil, fmt.Errorf("read config file: %w", err)
	}

	applyEnvOverrides(cfg)
	return cfg, nil
}

func applyEnvOverrides(cfg *Config) {
	if v := os.Getenv("VELI_LISTEN"); v != "" {
		cfg.Server.Listen = v
	}
	if v := os.Getenv("VELI_DATABASE_DSN"); v != "" {
		cfg.Database.DSN = v
	}
	if v := os.Getenv("VELI_DATABASE_AUTOMIGRATE"); v != "" {
		cfg.Database.AutoMigrate = parseBool(v)
	}
	if v := os.Getenv("VELI_AUTH_JWT_SECRET"); v != "" {
		cfg.Auth.JWTSecret = v
	}
	if v := os.Getenv("VELI_AUTH_ALLOWED_ORIGINS"); v != "" {
		cfg.Auth.AllowedOrigins = strings.Split(v, ",")
	}
	if v := os.Getenv("VELI_AUTH_FRONTEND_URL"); v != "" {
		cfg.Auth.FrontendURL = v
	}
	if v := os.Getenv("VELI_AUTH_DEVMODE"); v != "" {
		cfg.Auth.DevMode = parseBool(v)
	}
	if v := os.Getenv("VELI_LOG_LEVEL"); v != "" {
		cfg.Observability.LogLevel = v
	}
	if v := os.Getenv("VELI_LOG_FORMAT"); v != "" {
		cfg.Observability.LogFormat = v
	}
}

func parseBool(s string) bool {
	v, err := strconv.ParseBool(strings.TrimSpace(s))
	if err != nil {
		return false
	}
	return v
}
