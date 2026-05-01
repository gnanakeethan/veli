package db

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/jackc/pgx/v5/stdlib"
	"github.com/pressly/goose/v3"

	"github.com/cloudparallax/veli/assets/migrations"
)

// MigrateUp runs every up-migration in the embedded migrations FS
// against the supplied pool. It opens a *sql.DB view of the pool via
// pgx's stdlib adapter so goose (which expects database/sql) can drive
// the underlying connections without us having to dial a second time.
//
// Intended for local development and ephemeral environments. Production
// should run `make migrations/up` (or its CI equivalent) before the
// API binary starts; this function exists so VELI_DATABASE_AUTOMIGRATE
// works for hands-on iteration.
func MigrateUp(ctx context.Context, pool *pgxpool.Pool) error {
	sqlDB := stdlib.OpenDBFromPool(pool)
	defer func() { _ = sqlDB.Close() }()

	goose.SetBaseFS(migrations.FS)
	if err := goose.SetDialect("postgres"); err != nil {
		return fmt.Errorf("goose set dialect: %w", err)
	}
	if err := goose.UpContext(ctx, sqlDB, "."); err != nil {
		return fmt.Errorf("goose up: %w", err)
	}
	return nil
}
