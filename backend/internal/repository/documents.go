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

	"github.com/cloudparallax/veli/internal/database/models"
	"github.com/cloudparallax/veli/internal/domain"
)

// ErrDocumentNotFound is returned by GetByID when no row matches the
// id. The service layer translates this to a domain error and the
// handler layer to HTTP 404.
var ErrDocumentNotFound = errors.New("document not found")

// DocumentsRepository is the data-access contract for the documents
// table. The shape mirrors UsersRepository: lookup by id, list by
// owner or globally, and create. Mutation of an existing row is not
// modelled — chain-of-custody for civic evidence is append-only.
type DocumentsRepository interface {
	GetByID(ctx context.Context, id string) (domain.Document, error)
	Create(ctx context.Context, doc *domain.Document) error
	ListByUserID(ctx context.Context, userID string, limit, offset int) ([]domain.Document, error)
	List(ctx context.Context, limit, offset int) ([]domain.Document, error)
}

// NewDocumentsRepository returns a Bob-backed implementation. exec
// may be a pgx pool wrapper or a transaction.
func NewDocumentsRepository(exec bob.Executor) DocumentsRepository {
	return &bobDocumentsRepository{exec: exec}
}

type bobDocumentsRepository struct {
	exec bob.Executor
}

func (r *bobDocumentsRepository) GetByID(ctx context.Context, id string) (domain.Document, error) {
	doc, err := models.FindDocument(ctx, r.exec, id)
	if errors.Is(err, sql.ErrNoRows) {
		return domain.Document{}, ErrDocumentNotFound
	}
	if err != nil {
		return domain.Document{}, fmt.Errorf("find document: %w", err)
	}
	return documentToDomain(doc), nil
}

// Create inserts doc. The caller must set doc.ID (typically a fresh
// ULID from the service layer) and CapturedAt. CreatedAt is supplied
// by the database and copied back onto doc.
func (r *bobDocumentsRepository) Create(ctx context.Context, doc *domain.Document) error {
	setter := &models.DocumentSetter{
		ID:         omit.From(doc.ID),
		UserID:     omit.From(doc.UserID),
		Kind:       omit.From(doc.Kind),
		StorageURI: omit.From(doc.StorageURI),
		CapturedAt: omit.From(doc.CapturedAt),
	}
	if doc.GPSLat != nil {
		setter.GPSLat = omitnull.From(*doc.GPSLat)
	}
	if doc.GPSLng != nil {
		setter.GPSLNG = omitnull.From(*doc.GPSLng)
	}
	if doc.DeviceID != "" {
		setter.DeviceID = omitnull.From(doc.DeviceID)
	}

	inserted, err := models.Documents.Insert(setter).One(ctx, r.exec)
	if err != nil {
		return fmt.Errorf("insert document: %w", err)
	}
	doc.CreatedAt = inserted.CreatedAt
	return nil
}

// ListByUserID returns documents owned by a single user, newest
// first. limit ≤ 0 is treated as 50; offset < 0 as 0.
func (r *bobDocumentsRepository) ListByUserID(
	ctx context.Context, userID string, limit, offset int,
) ([]domain.Document, error) {
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}
	docs, err := models.Documents.Query(
		sm.Where(models.Documents.Columns.UserID.EQ(psql.Arg(userID))),
		sm.OrderBy(models.Documents.Columns.CreatedAt).Desc(),
		sm.Limit(limit),
		sm.Offset(offset),
	).All(ctx, r.exec)
	if err != nil {
		return nil, fmt.Errorf("list documents by user: %w", err)
	}
	out := make([]domain.Document, 0, len(docs))
	for _, d := range docs {
		out = append(out, documentToDomain(d))
	}
	return out, nil
}

// List returns the global document list for admin moderation views.
// Newest first.
func (r *bobDocumentsRepository) List(
	ctx context.Context, limit, offset int,
) ([]domain.Document, error) {
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}
	docs, err := models.Documents.Query(
		sm.OrderBy(models.Documents.Columns.CreatedAt).Desc(),
		sm.Limit(limit),
		sm.Offset(offset),
	).All(ctx, r.exec)
	if err != nil {
		return nil, fmt.Errorf("list documents: %w", err)
	}
	out := make([]domain.Document, 0, len(docs))
	for _, d := range docs {
		out = append(out, documentToDomain(d))
	}
	return out, nil
}

func documentToDomain(d *models.Document) domain.Document {
	out := domain.Document{
		ID:         d.ID,
		UserID:     d.UserID,
		Kind:       d.Kind,
		StorageURI: d.StorageURI,
		CapturedAt: d.CapturedAt,
		CreatedAt:  d.CreatedAt,
	}
	if d.GPSLat.IsValue() {
		v := d.GPSLat.MustGet()
		out.GPSLat = &v
	}
	if d.GPSLNG.IsValue() {
		v := d.GPSLNG.MustGet()
		out.GPSLng = &v
	}
	if d.DeviceID.IsValue() {
		out.DeviceID = d.DeviceID.MustGet()
	}
	return out
}

