package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/aarondl/opt/omit"
	"github.com/stephenafamo/bob"
	"github.com/stephenafamo/bob/dialect/psql"
	"github.com/stephenafamo/bob/dialect/psql/sm"

	"github.com/cloudparallax/veli/internal/database/models"
	"github.com/cloudparallax/veli/internal/domain"
)

// ErrVerificationNotFound is returned by GetByID when no row matches.
var ErrVerificationNotFound = errors.New("verification not found")

// VerificationsRepository persists three-tier verification records.
// Like DocumentsRepository, mutation isn't modelled — chain-of-custody
// is append-only.
type VerificationsRepository interface {
	GetByID(ctx context.Context, id string) (domain.Verification, error)
	Create(ctx context.Context, v *domain.Verification) error
	ListByDocumentID(ctx context.Context, documentID string) ([]domain.Verification, error)
}

func NewVerificationsRepository(exec bob.Executor) VerificationsRepository {
	return &bobVerificationsRepository{exec: exec}
}

type bobVerificationsRepository struct {
	exec bob.Executor
}

func (r *bobVerificationsRepository) GetByID(
	ctx context.Context, id string,
) (domain.Verification, error) {
	v, err := models.FindVerification(ctx, r.exec, id)
	if errors.Is(err, sql.ErrNoRows) {
		return domain.Verification{}, ErrVerificationNotFound
	}
	if err != nil {
		return domain.Verification{}, fmt.Errorf("find verification: %w", err)
	}
	return verificationToDomain(v), nil
}

// Create inserts v. The caller sets ID, DocumentID, Tier, AttesterID,
// optionally Notes, and VerifiedAt. Database default for VerifiedAt
// is now() but the service layer always sets it explicitly so audit
// timestamps come from a single source of truth.
func (r *bobVerificationsRepository) Create(
	ctx context.Context, v *domain.Verification,
) error {
	setter := &models.VerificationSetter{
		ID:         omit.From(v.ID),
		DocumentID: omit.From(v.DocumentID),
		Tier:       omit.From(string(v.Tier)),
		AttesterID: omit.From(v.AttesterID),
		Notes:      omit.From(v.Notes),
		VerifiedAt: omit.From(v.VerifiedAt),
	}
	inserted, err := models.Verifications.Insert(setter).One(ctx, r.exec)
	if err != nil {
		return fmt.Errorf("insert verification: %w", err)
	}
	v.VerifiedAt = inserted.VerifiedAt
	return nil
}

// ListByDocumentID returns all verifications attached to a single
// document, ordered oldest-to-newest so the chain-of-custody reads
// in the order it was built up.
func (r *bobVerificationsRepository) ListByDocumentID(
	ctx context.Context, documentID string,
) ([]domain.Verification, error) {
	vs, err := models.Verifications.Query(
		sm.Where(models.Verifications.Columns.DocumentID.EQ(psql.Arg(documentID))),
		sm.OrderBy(models.Verifications.Columns.VerifiedAt).Asc(),
	).All(ctx, r.exec)
	if err != nil {
		return nil, fmt.Errorf("list verifications: %w", err)
	}
	out := make([]domain.Verification, 0, len(vs))
	for _, v := range vs {
		out = append(out, verificationToDomain(v))
	}
	return out, nil
}

func verificationToDomain(v *models.Verification) domain.Verification {
	return domain.Verification{
		ID:         v.ID,
		DocumentID: v.DocumentID,
		Tier:       domain.VerificationTier(v.Tier),
		AttesterID: v.AttesterID,
		Notes:      v.Notes,
		VerifiedAt: v.VerifiedAt,
	}
}
