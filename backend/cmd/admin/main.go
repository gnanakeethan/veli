// Command admin is a small operator CLI for actions that don't yet
// have a UI surface. The first action is `grant`, which creates a
// super-admin user and is the bootstrap escape hatch for "we just
// stood up the platform — how does the first human get in?"
//
// The CLI shares config + repository + service code with cmd/api so
// validation, auditing, and ULID generation stay consistent. It is
// intentionally not a long-running daemon: it opens a pool, does its
// work, and exits.
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/oklog/ulid/v2"
	"go.uber.org/zap"

	"github.com/cloudparallax/veli/internal/config"
	"github.com/cloudparallax/veli/internal/db"
	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
	"github.com/cloudparallax/veli/internal/service"
)

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(2)
	}
	switch os.Args[1] {
	case "grant":
		if err := runGrant(os.Args[2:]); err != nil {
			fmt.Fprintf(os.Stderr, "grant: %v\n", err)
			os.Exit(1)
		}
	case "-h", "--help", "help":
		usage()
	default:
		fmt.Fprintf(os.Stderr, "unknown subcommand %q\n\n", os.Args[1])
		usage()
		os.Exit(2)
	}
}

func usage() {
	fmt.Fprintln(os.Stderr, `veli-admin — operator CLI

Usage:
  go run ./cmd/admin <subcommand> [flags]

Subcommands:
  grant   Provision an admin user by email + assign a role.

Run 'go run ./cmd/admin grant -h' for grant-specific flags.`)
}

func runGrant(args []string) error {
	fs := flag.NewFlagSet("grant", flag.ContinueOnError)
	configPath := fs.String("config", "configs/veli.yaml", "path to YAML config")
	email := fs.String("email", "", "Google email of the admin (required)")
	name := fs.String("name", "", "display name (default: email local-part)")
	phone := fs.String("phone", "", "phone (default: synthetic 'admin:<email>')")
	locale := fs.String("locale", "ta", "preferred locale (ta | en | si)")
	roleCode := fs.String("role", "super_admin", "role to grant")
	if err := fs.Parse(args); err != nil {
		return err
	}
	if strings.TrimSpace(*email) == "" {
		fs.Usage()
		return errors.New("--email is required")
	}
	if !isPlausibleEmail(*email) {
		return fmt.Errorf("not a plausible email: %q", *email)
	}

	cfg, err := config.Load(*configPath)
	if err != nil {
		return fmt.Errorf("load config: %w", err)
	}

	logger, _ := zap.NewDevelopment()
	defer func() { _ = logger.Sync() }()

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	pool, err := db.Open(ctx, cfg.Database)
	if err != nil {
		return fmt.Errorf("open database: %w", err)
	}
	defer pool.Close()

	bobDB := db.NewBobDB(pool)
	usersRepo := repository.NewUsersRepository(bobDB)
	rolesRepo := repository.NewRolesRepository(bobDB)
	rbacSvc := service.NewRBACService(rolesRepo)

	resolvedName := strings.TrimSpace(*name)
	if resolvedName == "" {
		resolvedName = emailLocalPart(*email)
	}
	resolvedPhone := strings.TrimSpace(*phone)
	if resolvedPhone == "" {
		resolvedPhone = "admin:" + *email
	}

	user, created, err := upsertAdminUser(ctx, usersRepo, *email, resolvedName, resolvedPhone, *locale)
	if err != nil {
		return err
	}
	if created {
		fmt.Printf("created user %s (id=%s, phone=%s)\n", user.Email, user.ID, user.Phone)
	} else {
		fmt.Printf("found existing user %s (id=%s)\n", user.Email, user.ID)
	}

	roles, err := rbacSvc.ListUserRoles(ctx, user.ID)
	if err != nil {
		return fmt.Errorf("list user roles: %w", err)
	}
	for _, r := range roles {
		if r.Code == *roleCode {
			fmt.Printf("user already holds role %q — nothing to do\n", *roleCode)
			return nil
		}
	}

	// granted_by is empty — system grant. The audit row records the
	// user_id only; operators reading the audit log will see no actor.
	if err := rbacSvc.AssignRoleByCode(ctx, user.ID, *roleCode, ""); err != nil {
		if errors.Is(err, service.ErrRoleNotFound) {
			return fmt.Errorf("role %q not seeded — check assets/migrations/00002_phase0_rbac.sql", *roleCode)
		}
		return fmt.Errorf("assign role: %w", err)
	}
	fmt.Printf("granted role %q to %s\n", *roleCode, user.Email)
	return nil
}

// upsertAdminUser returns the user with the given email, creating one
// if it doesn't exist. The created bool tells the caller whether the
// row was freshly inserted (for log clarity).
//
// We bypass service.UsersService.Create because that path enforces an
// E.164 phone format which admins (Google-anchored, not phone-anchored)
// don't necessarily have. The repository layer does no format check —
// only NOT NULL UNIQUE — so a synthetic 'admin:<email>' value is fine.
func upsertAdminUser(
	ctx context.Context,
	repo repository.UsersRepository,
	email, displayName, phone, locale string,
) (domain.User, bool, error) {
	existing, err := repo.GetByEmail(ctx, email)
	if err == nil {
		return existing, false, nil
	}
	if !errors.Is(err, repository.ErrUserNotFound) {
		return domain.User{}, false, fmt.Errorf("get user by email: %w", err)
	}

	u := domain.User{
		ID:          ulid.Make().String(),
		Phone:       phone,
		Email:       email,
		DisplayName: displayName,
		Locale:      locale,
	}
	if err := repo.Create(ctx, &u); err != nil {
		return domain.User{}, false, fmt.Errorf("create user: %w", err)
	}
	return u, true, nil
}

func isPlausibleEmail(s string) bool {
	at := strings.IndexByte(s, '@')
	if at <= 0 || at == len(s)-1 {
		return false
	}
	if strings.IndexByte(s[at+1:], '.') < 0 {
		return false
	}
	return true
}

func emailLocalPart(email string) string {
	if at := strings.IndexByte(email, '@'); at > 0 {
		return email[:at]
	}
	return email
}
