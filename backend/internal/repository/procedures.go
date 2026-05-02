package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/aarondl/opt/omit"
	"github.com/aarondl/opt/omitnull"
	"github.com/stephenafamo/bob"
	"github.com/stephenafamo/bob/dialect/psql"
	"github.com/stephenafamo/bob/dialect/psql/sm"
	"github.com/stephenafamo/bob/dialect/psql/um"

	"github.com/cloudparallax/veli/internal/database/models"
	"github.com/cloudparallax/veli/internal/domain"
)

// ErrProcedureNotFound is returned by GetByID/GetBySlug when no row
// matches.
var ErrProcedureNotFound = errors.New("procedure not found")

// ProceduresRepository persists procedure content. Reads are split:
// ListPublished is the citizen-facing path (only `published` status);
// List is the admin path that returns every status. Update is
// supported for status transitions and content edits — chain-of-
// custody for procedure content lives in updated_at + future
// edit-history table.
type ProceduresRepository interface {
	GetByID(ctx context.Context, id string) (domain.Procedure, error)
	GetBySlug(ctx context.Context, slug string) (domain.Procedure, error)
	Create(ctx context.Context, p *domain.Procedure) error
	Update(ctx context.Context, p *domain.Procedure) error
	List(ctx context.Context, limit, offset int) ([]domain.Procedure, error)
	ListPublished(ctx context.Context, limit, offset int) ([]domain.Procedure, error)
}

func NewProceduresRepository(exec bob.Executor) ProceduresRepository {
	return &bobProceduresRepository{exec: exec}
}

type bobProceduresRepository struct {
	exec bob.Executor
}

func (r *bobProceduresRepository) GetByID(
	ctx context.Context, id string,
) (domain.Procedure, error) {
	p, err := models.FindProcedure(ctx, r.exec, id)
	if errors.Is(err, sql.ErrNoRows) {
		return domain.Procedure{}, ErrProcedureNotFound
	}
	if err != nil {
		return domain.Procedure{}, fmt.Errorf("find procedure: %w", err)
	}
	return procedureToDomain(p), nil
}

// GetBySlug looks up a procedure by its slug. Slug is the
// citizen-facing URL key (`birth-certificate-replacement`) and is
// unique per the schema.
func (r *bobProceduresRepository) GetBySlug(
	ctx context.Context, slug string,
) (domain.Procedure, error) {
	p, err := models.Procedures.Query(
		sm.Where(models.Procedures.Columns.Slug.EQ(psql.Arg(slug))),
	).One(ctx, r.exec)
	if errors.Is(err, sql.ErrNoRows) {
		return domain.Procedure{}, ErrProcedureNotFound
	}
	if err != nil {
		return domain.Procedure{}, fmt.Errorf("find procedure by slug: %w", err)
	}
	return procedureToDomain(p), nil
}

// Create inserts p. Caller mints ID; database supplies created_at +
// updated_at, which are copied back.
func (r *bobProceduresRepository) Create(
	ctx context.Context, p *domain.Procedure,
) error {
	setter := procedureSetter(p, true)
	inserted, err := models.Procedures.Insert(setter).One(ctx, r.exec)
	if err != nil {
		return fmt.Errorf("insert procedure: %w", err)
	}
	p.CreatedAt = inserted.CreatedAt
	p.UpdatedAt = inserted.UpdatedAt
	return nil
}

// Update writes the full row (idempotent for fields the caller
// touched). updated_at is bumped server-side via NOW() so we never
// trust client clocks for the audit timestamp.
func (r *bobProceduresRepository) Update(
	ctx context.Context, p *domain.Procedure,
) error {
	q := models.Procedures.Update(
		um.SetCol("slug").ToArg(p.Slug),
		um.SetCol("title_ta").ToArg(p.TitleTa),
		um.SetCol("title_en").ToArg(p.TitleEn),
		um.SetCol("summary_ta").ToArg(p.SummaryTa),
		um.SetCol("summary_en").ToArg(p.SummaryEn),
		um.SetCol("source_url").ToArg(p.SourceURL),
		um.SetCol("status").ToArg(string(p.Status)),
		um.SetCol("updated_at").ToArg(psql.Raw("NOW()")),
		um.Where(models.Procedures.Columns.ID.EQ(psql.Arg(p.ID))),
	)
	if p.FeeLKRCents != nil {
		q.Apply(um.SetCol("fee_lkr_cents").ToArg(*p.FeeLKRCents))
	} else {
		q.Apply(um.SetCol("fee_lkr_cents").ToArg(psql.Raw("NULL")))
	}
	if p.LastVerifiedAt != nil {
		q.Apply(um.SetCol("last_verified_at").ToArg(*p.LastVerifiedAt))
	} else {
		q.Apply(um.SetCol("last_verified_at").ToArg(psql.Raw("NULL")))
	}

	rows, err := q.Exec(ctx, r.exec)
	if err != nil {
		return fmt.Errorf("update procedure: %w", err)
	}
	if rows == 0 {
		return ErrProcedureNotFound
	}
	return nil
}

// List returns all procedures including drafts and archived,
// newest-updated first. Admin view.
func (r *bobProceduresRepository) List(
	ctx context.Context, limit, offset int,
) ([]domain.Procedure, error) {
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}
	ps, err := models.Procedures.Query(
		sm.OrderBy(models.Procedures.Columns.UpdatedAt).Desc(),
		sm.Limit(limit),
		sm.Offset(offset),
	).All(ctx, r.exec)
	if err != nil {
		return nil, fmt.Errorf("list procedures: %w", err)
	}
	return mapProcedures(ps), nil
}

// ListPublished returns only `published` procedures. Citizen view.
func (r *bobProceduresRepository) ListPublished(
	ctx context.Context, limit, offset int,
) ([]domain.Procedure, error) {
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}
	ps, err := models.Procedures.Query(
		sm.Where(
			models.Procedures.Columns.Status.EQ(psql.Arg(string(domain.ProcedureStatusPublished))),
		),
		sm.OrderBy(models.Procedures.Columns.UpdatedAt).Desc(),
		sm.Limit(limit),
		sm.Offset(offset),
	).All(ctx, r.exec)
	if err != nil {
		return nil, fmt.Errorf("list published procedures: %w", err)
	}
	return mapProcedures(ps), nil
}

// procedureSetter builds a Bob setter from a domain procedure.
// withDefaults=true sets status when empty so freshly-created rows
// land in 'draft' explicitly rather than relying on column default.
func procedureSetter(p *domain.Procedure, withDefaults bool) *models.ProcedureSetter {
	status := string(p.Status)
	if withDefaults && status == "" {
		status = string(domain.ProcedureStatusDraft)
	}
	setter := &models.ProcedureSetter{
		ID:        omit.From(p.ID),
		Slug:      omit.From(p.Slug),
		TitleTa:   omit.From(p.TitleTa),
		TitleEn:   omit.From(p.TitleEn),
		SummaryTa: omit.From(p.SummaryTa),
		SummaryEn: omit.From(p.SummaryEn),
		SourceURL: omit.From(p.SourceURL),
		Status:    omit.From(status),
	}
	if p.FeeLKRCents != nil {
		setter.FeeLKRCents = omitnull.From(*p.FeeLKRCents)
	}
	if p.LastVerifiedAt != nil {
		setter.LastVerifiedAt = omitnull.From(*p.LastVerifiedAt)
	}
	return setter
}

func mapProcedures(ps []*models.Procedure) []domain.Procedure {
	out := make([]domain.Procedure, 0, len(ps))
	for _, p := range ps {
		out = append(out, procedureToDomain(p))
	}
	return out
}

func procedureToDomain(p *models.Procedure) domain.Procedure {
	out := domain.Procedure{
		ID:        p.ID,
		Slug:      p.Slug,
		TitleTa:   p.TitleTa,
		TitleEn:   p.TitleEn,
		SummaryTa: p.SummaryTa,
		SummaryEn: p.SummaryEn,
		SourceURL: p.SourceURL,
		Status:    domain.ProcedureStatus(p.Status),
		CreatedAt: p.CreatedAt,
		UpdatedAt: p.UpdatedAt,
	}
	if p.FeeLKRCents.IsValue() {
		v := p.FeeLKRCents.MustGet()
		out.FeeLKRCents = &v
	}
	if p.LastVerifiedAt.IsValue() {
		v := p.LastVerifiedAt.MustGet()
		out.LastVerifiedAt = &v
	}
	return out
}
