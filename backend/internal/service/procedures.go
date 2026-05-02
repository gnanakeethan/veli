package service

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/oklog/ulid/v2"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
)

// Sentinel errors for the procedures layer.
var (
	ErrInvalidSlug         = errors.New("invalid slug")
	ErrInvalidTitle        = errors.New("invalid title")
	ErrInvalidSummary      = errors.New("invalid summary")
	ErrInvalidFee          = errors.New("invalid fee")
	ErrInvalidSourceURL    = errors.New("invalid source_url")
	ErrInvalidStatus       = errors.New("invalid status")
	ErrSlugConflict        = errors.New("slug already in use")
	ErrProcedureNotFound   = repository.ErrProcedureNotFound
	ErrIllegalStatusChange = errors.New("illegal status transition")
)

const (
	slugMaxLen      = 64
	titleMaxLen     = 200
	summaryMaxRunes = 1000
	sourceURLMaxLen = 1024
	feeMaxCents     = int64(100_000_000) // LKR 1,000,000 sanity ceiling
)

// CreateProcedureInput is the validated set of fields a caller may
// supply to create a procedure. Status defaults to draft if empty.
type CreateProcedureInput struct {
	Slug           string
	TitleTa        string
	TitleEn        string
	SummaryTa      string
	SummaryEn      string
	FeeLKRCents    *int64
	SourceURL      string
	LastVerifiedAt *time.Time
	Status         domain.ProcedureStatus
}

// UpdateProcedureInput covers the same fields plus the ID. Slug
// changes are allowed but trigger a uniqueness check against the
// existing record's slug.
type UpdateProcedureInput struct {
	ID             string
	Slug           string
	TitleTa        string
	TitleEn        string
	SummaryTa      string
	SummaryEn      string
	FeeLKRCents    *int64
	SourceURL      string
	LastVerifiedAt *time.Time
	Status         domain.ProcedureStatus
}

// ProceduresService coordinates procedure CRUD and enforces the
// content-validation invariants. It depends only on the procedures
// repository — no cross-aggregate joins live here.
type ProceduresService struct {
	repo repository.ProceduresRepository
}

func NewProceduresService(repo repository.ProceduresRepository) *ProceduresService {
	return &ProceduresService{repo: repo}
}

// GetByID returns the procedure or ErrInvalidID / ErrProcedureNotFound.
func (s *ProceduresService) GetByID(
	ctx context.Context, id string,
) (domain.Procedure, error) {
	if !isWellFormedULID(id) {
		return domain.Procedure{}, ErrInvalidID
	}
	p, err := s.repo.GetByID(ctx, id)
	if err != nil {
		if errors.Is(err, repository.ErrProcedureNotFound) {
			return domain.Procedure{}, ErrProcedureNotFound
		}
		return domain.Procedure{}, fmt.Errorf("get procedure: %w", err)
	}
	return p, nil
}

// GetBySlug returns the procedure addressed by its citizen-facing
// slug. The unauthenticated handler hides drafts/archived from
// citizens by checking status here.
func (s *ProceduresService) GetBySlug(
	ctx context.Context, slug string,
) (domain.Procedure, error) {
	if err := validateSlug(slug); err != nil {
		return domain.Procedure{}, err
	}
	p, err := s.repo.GetBySlug(ctx, slug)
	if err != nil {
		if errors.Is(err, repository.ErrProcedureNotFound) {
			return domain.Procedure{}, ErrProcedureNotFound
		}
		return domain.Procedure{}, fmt.Errorf("get procedure by slug: %w", err)
	}
	return p, nil
}

// List returns procedures for the admin view (all statuses).
func (s *ProceduresService) List(
	ctx context.Context, limit, offset int,
) ([]domain.Procedure, error) {
	limit, offset = clampPage(limit, offset)
	ps, err := s.repo.List(ctx, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("list procedures: %w", err)
	}
	return ps, nil
}

// ListPublished returns published procedures for the citizen view.
func (s *ProceduresService) ListPublished(
	ctx context.Context, limit, offset int,
) ([]domain.Procedure, error) {
	limit, offset = clampPage(limit, offset)
	ps, err := s.repo.ListPublished(ctx, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("list published procedures: %w", err)
	}
	return ps, nil
}

// Create validates input, mints a ULID, and persists a new
// procedure. Slug uniqueness is enforced by the database; on
// conflict we surface ErrSlugConflict for a clean handler mapping.
func (s *ProceduresService) Create(
	ctx context.Context, in CreateProcedureInput,
) (domain.Procedure, error) {
	if err := validateProcedureInputs(in.Slug, in.TitleTa, in.TitleEn, in.SummaryTa, in.SummaryEn, in.SourceURL, in.FeeLKRCents); err != nil {
		return domain.Procedure{}, err
	}
	status := in.Status
	if status == "" {
		status = domain.ProcedureStatusDraft
	}
	if err := validateStatus(status); err != nil {
		return domain.Procedure{}, err
	}

	if _, err := s.repo.GetBySlug(ctx, strings.ToLower(strings.TrimSpace(in.Slug))); err == nil {
		return domain.Procedure{}, ErrSlugConflict
	} else if !errors.Is(err, repository.ErrProcedureNotFound) {
		return domain.Procedure{}, fmt.Errorf("check slug uniqueness: %w", err)
	}

	p := domain.Procedure{
		ID:             ulid.Make().String(),
		Slug:           strings.ToLower(strings.TrimSpace(in.Slug)),
		TitleTa:        strings.TrimSpace(in.TitleTa),
		TitleEn:        strings.TrimSpace(in.TitleEn),
		SummaryTa:      strings.TrimSpace(in.SummaryTa),
		SummaryEn:      strings.TrimSpace(in.SummaryEn),
		FeeLKRCents:    in.FeeLKRCents,
		SourceURL:      strings.TrimSpace(in.SourceURL),
		LastVerifiedAt: in.LastVerifiedAt,
		Status:         status,
	}
	if err := s.repo.Create(ctx, &p); err != nil {
		return domain.Procedure{}, fmt.Errorf("create procedure: %w", err)
	}
	return p, nil
}

// Update validates the input and persists. Status transitions are
// enforced (draft → published → archived; never backwards).
func (s *ProceduresService) Update(
	ctx context.Context, in UpdateProcedureInput,
) (domain.Procedure, error) {
	if !isWellFormedULID(in.ID) {
		return domain.Procedure{}, ErrInvalidID
	}
	if err := validateProcedureInputs(in.Slug, in.TitleTa, in.TitleEn, in.SummaryTa, in.SummaryEn, in.SourceURL, in.FeeLKRCents); err != nil {
		return domain.Procedure{}, err
	}
	if err := validateStatus(in.Status); err != nil {
		return domain.Procedure{}, err
	}

	current, err := s.repo.GetByID(ctx, in.ID)
	if err != nil {
		if errors.Is(err, repository.ErrProcedureNotFound) {
			return domain.Procedure{}, ErrProcedureNotFound
		}
		return domain.Procedure{}, fmt.Errorf("load current procedure: %w", err)
	}

	if !canTransition(current.Status, in.Status) {
		return domain.Procedure{}, ErrIllegalStatusChange
	}

	desiredSlug := strings.ToLower(strings.TrimSpace(in.Slug))
	if desiredSlug != current.Slug {
		if existing, err := s.repo.GetBySlug(ctx, desiredSlug); err == nil && existing.ID != in.ID {
			return domain.Procedure{}, ErrSlugConflict
		} else if err != nil && !errors.Is(err, repository.ErrProcedureNotFound) {
			return domain.Procedure{}, fmt.Errorf("check slug uniqueness: %w", err)
		}
	}

	p := domain.Procedure{
		ID:             in.ID,
		Slug:           desiredSlug,
		TitleTa:        strings.TrimSpace(in.TitleTa),
		TitleEn:        strings.TrimSpace(in.TitleEn),
		SummaryTa:      strings.TrimSpace(in.SummaryTa),
		SummaryEn:      strings.TrimSpace(in.SummaryEn),
		FeeLKRCents:    in.FeeLKRCents,
		SourceURL:      strings.TrimSpace(in.SourceURL),
		LastVerifiedAt: in.LastVerifiedAt,
		Status:         in.Status,
	}
	if err := s.repo.Update(ctx, &p); err != nil {
		return domain.Procedure{}, fmt.Errorf("update procedure: %w", err)
	}

	updated, err := s.repo.GetByID(ctx, in.ID)
	if err != nil {
		return domain.Procedure{}, fmt.Errorf("reload after update: %w", err)
	}
	return updated, nil
}

func validateProcedureInputs(
	slug, titleTa, titleEn, summaryTa, summaryEn, sourceURL string, feeLKRCents *int64,
) error {
	if err := validateSlug(slug); err != nil {
		return err
	}
	if err := validateTitle(titleTa, true); err != nil {
		return err
	}
	if err := validateTitle(titleEn, false); err != nil {
		return err
	}
	if err := validateSummary(summaryTa); err != nil {
		return err
	}
	if err := validateSummary(summaryEn); err != nil {
		return err
	}
	if err := validateSourceURL(sourceURL); err != nil {
		return err
	}
	if err := validateFee(feeLKRCents); err != nil {
		return err
	}
	return nil
}

func validateSlug(s string) error {
	t := strings.ToLower(strings.TrimSpace(s))
	if t == "" || len(t) > slugMaxLen {
		return ErrInvalidSlug
	}
	for i, r := range t {
		switch {
		case r >= 'a' && r <= 'z',
			r >= '0' && r <= '9':
			continue
		case r == '-':
			if i == 0 || i == len(t)-1 {
				return ErrInvalidSlug
			}
			continue
		default:
			return ErrInvalidSlug
		}
	}
	return nil
}

func validateTitle(s string, required bool) error {
	t := strings.TrimSpace(s)
	if t == "" {
		if required {
			return ErrInvalidTitle
		}
		return nil
	}
	if utf8.RuneCountInString(t) > titleMaxLen {
		return ErrInvalidTitle
	}
	return nil
}

func validateSummary(s string) error {
	if utf8.RuneCountInString(s) > summaryMaxRunes {
		return ErrInvalidSummary
	}
	return nil
}

func validateSourceURL(s string) error {
	t := strings.TrimSpace(s)
	if t == "" {
		return nil
	}
	if len(t) > sourceURLMaxLen {
		return ErrInvalidSourceURL
	}
	u, err := url.Parse(t)
	if err != nil || u.Scheme == "" || u.Host == "" {
		return ErrInvalidSourceURL
	}
	return nil
}

func validateFee(p *int64) error {
	if p == nil {
		return nil
	}
	if *p < 0 || *p > feeMaxCents {
		return ErrInvalidFee
	}
	return nil
}

func validateStatus(s domain.ProcedureStatus) error {
	switch s {
	case domain.ProcedureStatusDraft,
		domain.ProcedureStatusPublished,
		domain.ProcedureStatusArchived:
		return nil
	default:
		return ErrInvalidStatus
	}
}

// canTransition encodes the linear lifecycle: draft → published →
// archived. Reflexive transitions (draft → draft, etc.) are allowed
// for content-only edits without status change.
func canTransition(from, to domain.ProcedureStatus) bool {
	if from == to {
		return true
	}
	switch from {
	case domain.ProcedureStatusDraft:
		return to == domain.ProcedureStatusPublished
	case domain.ProcedureStatusPublished:
		return to == domain.ProcedureStatusArchived
	case domain.ProcedureStatusArchived:
		return false
	default:
		return false
	}
}
