package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/aarondl/opt/omit"
	"github.com/stephenafamo/bob"
	"github.com/stephenafamo/bob/dialect/psql"
	"github.com/stephenafamo/bob/dialect/psql/sm"
	"github.com/stephenafamo/bob/dialect/psql/um"

	"github.com/cloudparallax/veli/internal/database/models"
)

// ErrExternalIdentityNotFound is returned when a (provider, subject)
// pair has no row.
var ErrExternalIdentityNotFound = errors.New("external identity not found")

// ExternalIdentity represents a (provider, subject) link to a Veḷi
// user. The repository returns this directly rather than going
// through the domain layer because it's an internal auth implementation
// detail, not a user-facing domain concept.
type ExternalIdentity struct {
	Provider   string
	Subject    string
	UserID     string
	Email      string
	LinkedAt   time.Time
	LastSeenAt time.Time
}

// ExternalIdentitiesRepository is the data-access contract for the
// external_identities table.
type ExternalIdentitiesRepository interface {
	FindByProviderSubject(ctx context.Context, provider, subject string) (ExternalIdentity, error)
	FindUserIDByEmail(ctx context.Context, email string) (string, error)
	Link(ctx context.Context, provider, subject, userID, email string) error
	Touch(ctx context.Context, provider, subject string) error
}

func NewExternalIdentitiesRepository(exec bob.Executor) ExternalIdentitiesRepository {
	return &bobExternalIdentitiesRepository{exec: exec}
}

type bobExternalIdentitiesRepository struct {
	exec bob.Executor
}

func (r *bobExternalIdentitiesRepository) FindByProviderSubject(ctx context.Context, provider, subject string) (ExternalIdentity, error) {
	row, err := models.ExternalIdentities.Query(
		sm.Where(models.ExternalIdentities.Columns.Provider.EQ(psql.Arg(provider))),
		sm.Where(models.ExternalIdentities.Columns.Subject.EQ(psql.Arg(subject))),
	).One(ctx, r.exec)
	if errors.Is(err, sql.ErrNoRows) {
		return ExternalIdentity{}, ErrExternalIdentityNotFound
	}
	if err != nil {
		return ExternalIdentity{}, fmt.Errorf("find external identity: %w", err)
	}
	return ExternalIdentity{
		Provider:   row.Provider,
		Subject:    row.Subject,
		UserID:     row.UserID,
		Email:      row.Email,
		LinkedAt:   row.LinkedAt,
		LastSeenAt: row.LastSeenAt,
	}, nil
}

const findUserByEmailQuery = `SELECT id FROM users WHERE email = $1`

func (r *bobExternalIdentitiesRepository) FindUserIDByEmail(ctx context.Context, email string) (string, error) {
	rows, err := r.exec.QueryContext(ctx, findUserByEmailQuery, email)
	if err != nil {
		return "", fmt.Errorf("query user by email: %w", err)
	}
	defer func() { _ = rows.Close() }()
	if !rows.Next() {
		return "", ErrUserNotFound
	}
	var id string
	if err := rows.Scan(&id); err != nil {
		return "", fmt.Errorf("scan user id: %w", err)
	}
	return id, nil
}

func (r *bobExternalIdentitiesRepository) Link(ctx context.Context, provider, subject, userID, email string) error {
	setter := &models.ExternalIdentitySetter{
		Provider: omit.From(provider),
		Subject:  omit.From(subject),
		UserID:   omit.From(userID),
		Email:    omit.From(email),
	}
	if _, err := models.ExternalIdentities.Insert(setter).One(ctx, r.exec); err != nil {
		return fmt.Errorf("insert external identity: %w", err)
	}
	return nil
}

func (r *bobExternalIdentitiesRepository) Touch(ctx context.Context, provider, subject string) error {
	_, err := models.ExternalIdentities.Update(
		um.SetCol("last_seen_at").ToArg(time.Now()),
		um.Where(models.ExternalIdentities.Columns.Provider.EQ(psql.Arg(provider))),
		um.Where(models.ExternalIdentities.Columns.Subject.EQ(psql.Arg(subject))),
	).Exec(ctx, r.exec)
	if err != nil {
		return fmt.Errorf("update external identity last_seen_at: %w", err)
	}
	return nil
}
