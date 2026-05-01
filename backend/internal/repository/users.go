// Package repository holds data-access implementations. Repositories
// take a context and primitive arguments and return domain types (or
// errors). They never leak Bob, pgx, or database/sql types into the
// service or handler layers.
package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/aarondl/opt/omit"
	"github.com/aarondl/opt/omitnull"
	"github.com/stephenafamo/bob"

	"github.com/cloudparallax/veli/internal/database/models"
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
	Create(ctx context.Context, user *domain.User) error
}

// NewUsersRepository returns a Bob-backed UsersRepository. exec may
// be a connection-pool wrapper or a transaction; both satisfy
// bob.Executor.
func NewUsersRepository(exec bob.Executor) UsersRepository {
	return &bobUsersRepository{exec: exec}
}

type bobUsersRepository struct {
	exec bob.Executor
}

func (r *bobUsersRepository) GetByID(ctx context.Context, id string) (domain.User, error) {
	user, err := models.FindUser(ctx, r.exec, id)
	if errors.Is(err, sql.ErrNoRows) {
		return domain.User{}, ErrUserNotFound
	}
	if err != nil {
		return domain.User{}, fmt.Errorf("find user: %w", err)
	}
	return modelToDomain(user), nil
}

// Create inserts user. The caller is responsible for setting user.ID
// (typically a freshly minted ULID from the service layer); the
// database supplies created_at and updated_at, which are copied back
// onto user before return so the caller has the final record.
func (r *bobUsersRepository) Create(ctx context.Context, user *domain.User) error {
	setter := &models.UserSetter{
		ID:          omit.From(user.ID),
		Phone:       omit.From(user.Phone),
		DisplayName: omit.From(user.DisplayName),
		Locale:      omit.From(user.Locale),
	}
	if user.NICNumber != "" {
		setter.NicNumber = omitnull.From(user.NICNumber)
	}

	inserted, err := models.Users.Insert(setter).One(ctx, r.exec)
	if err != nil {
		return fmt.Errorf("insert user: %w", err)
	}

	user.CreatedAt = inserted.CreatedAt
	user.UpdatedAt = inserted.UpdatedAt
	return nil
}

// modelToDomain projects a Bob-generated *models.User onto the
// repository-internal domain.User. The nullable nic_number column
// collapses from null.Val[string] to a plain string ("" when absent).
func modelToDomain(u *models.User) domain.User {
	out := domain.User{
		ID:          u.ID,
		Phone:       u.Phone,
		DisplayName: u.DisplayName,
		Locale:      u.Locale,
		CreatedAt:   u.CreatedAt,
		UpdatedAt:   u.UpdatedAt,
	}
	if u.NicNumber.IsValue() {
		out.NICNumber = u.NicNumber.MustGet()
	}
	return out
}
