// Package repository holds data-access implementations. Repositories
// take a context and primitive arguments and return domain types (or
// errors). They never leak pgx-specific types into the service or
// handler layers.
package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/cloudparallax/veli/internal/domain"
)

// ErrUserNotFound is returned by GetByID when no row matches the id.
// Callers (typically the service layer) translate this to a domain
// error and ultimately HTTP 404.
var ErrUserNotFound = errors.New("user not found")

// UsersRepository is the data-access contract for users. The service
// layer depends on this interface so it can be stubbed in tests.
type UsersRepository interface {
	GetByID(ctx context.Context, id string) (domain.User, error)
}

// NewUsersRepository returns a Postgres-backed UsersRepository.
func NewUsersRepository(pool *pgxpool.Pool) UsersRepository {
	return &pgxUsersRepository{pool: pool}
}

type pgxUsersRepository struct {
	pool *pgxpool.Pool
}

const usersGetByIDQuery = `
SELECT id, phone, nic_number, display_name, locale, created_at, updated_at
FROM users
WHERE id = $1
`

func (r *pgxUsersRepository) GetByID(ctx context.Context, id string) (domain.User, error) {
	var (
		u   domain.User
		nic sql.NullString
	)
	err := r.pool.QueryRow(ctx, usersGetByIDQuery, id).Scan(
		&u.ID,
		&u.Phone,
		&nic,
		&u.DisplayName,
		&u.Locale,
		&u.CreatedAt,
		&u.UpdatedAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.User{}, ErrUserNotFound
	}
	if err != nil {
		return domain.User{}, fmt.Errorf("query user by id: %w", err)
	}
	if nic.Valid {
		u.NICNumber = nic.String
	}
	return u, nil
}
