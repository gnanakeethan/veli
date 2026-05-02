package service

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"strings"
	"time"

	"github.com/oklog/ulid/v2"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
)

// Sentinel errors for the documents layer. Each maps to a specific
// HTTP status; reuse before defining a new one.
var (
	ErrInvalidUserID     = errors.New("invalid user id")
	ErrInvalidKind       = errors.New("invalid kind")
	ErrInvalidStorageURI = errors.New("invalid storage uri")
	ErrInvalidCapturedAt = errors.New("invalid captured_at")
	ErrDocumentNotFound  = repository.ErrDocumentNotFound
)

// kindMaxLen bounds the document kind so a malicious or buggy client
// can't fill the column with megabytes. The current taxonomy
// (birth_cert, deed, witness_statement, …) is well under 64.
const kindMaxLen = 64

// storageURIMaxLen bounds the storage URI. Object-store keys can be
// long but 1 KiB is plenty.
const storageURIMaxLen = 1024

// capturedAtFutureSkew is the leeway granted to client clocks before
// we reject "in the future" timestamps. Phone clocks drift; a small
// window keeps real uploads from failing without letting clients
// fabricate timestamps far ahead.
const capturedAtFutureSkew = 5 * time.Minute

// CreateDocumentInput is the validated set of fields a caller may
// supply to create a document. The service mints ID + CreatedAt.
type CreateDocumentInput struct {
	UserID     string
	Kind       string
	StorageURI string
	CapturedAt time.Time
	GPSLat     *float64
	GPSLng     *float64
	DeviceID   string
}

// DocumentsService coordinates document creation and retrieval. It
// depends on the documents repo for persistence and the users repo
// for owner-existence checks (so we return ErrUserNotFound rather
// than a foreign-key violation that's harder to interpret).
type DocumentsService struct {
	docs  repository.DocumentsRepository
	users repository.UsersRepository
}

// NewDocumentsService wires the service to its repositories.
func NewDocumentsService(
	docs repository.DocumentsRepository, users repository.UsersRepository,
) *DocumentsService {
	return &DocumentsService{docs: docs, users: users}
}

// GetByID validates the id and returns the document, or
// ErrInvalidID / ErrDocumentNotFound.
func (s *DocumentsService) GetByID(ctx context.Context, id string) (domain.Document, error) {
	if !isWellFormedULID(id) {
		return domain.Document{}, ErrInvalidID
	}
	d, err := s.docs.GetByID(ctx, id)
	if err != nil {
		if errors.Is(err, repository.ErrDocumentNotFound) {
			return domain.Document{}, ErrDocumentNotFound
		}
		return domain.Document{}, fmt.Errorf("get document: %w", err)
	}
	return d, nil
}

// List returns the global document list (admin moderation view).
func (s *DocumentsService) List(ctx context.Context, limit, offset int) ([]domain.Document, error) {
	limit, offset = clampPage(limit, offset)
	docs, err := s.docs.List(ctx, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("list documents: %w", err)
	}
	return docs, nil
}

// ListByUserID returns documents owned by userID. The user must
// exist; ErrUserNotFound when they don't, ErrInvalidUserID for
// malformed ids.
func (s *DocumentsService) ListByUserID(
	ctx context.Context, userID string, limit, offset int,
) ([]domain.Document, error) {
	if !isWellFormedULID(userID) {
		return nil, ErrInvalidUserID
	}
	if _, err := s.users.GetByID(ctx, userID); err != nil {
		if errors.Is(err, repository.ErrUserNotFound) {
			return nil, ErrUserNotFound
		}
		return nil, fmt.Errorf("verify user: %w", err)
	}
	limit, offset = clampPage(limit, offset)
	docs, err := s.docs.ListByUserID(ctx, userID, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("list documents by user: %w", err)
	}
	return docs, nil
}

// Create validates input, mints a ULID, and persists a new document.
// Returns the persisted document with ID + CreatedAt populated.
func (s *DocumentsService) Create(
	ctx context.Context, in CreateDocumentInput,
) (domain.Document, error) {
	if !isWellFormedULID(in.UserID) {
		return domain.Document{}, ErrInvalidUserID
	}
	if _, err := s.users.GetByID(ctx, in.UserID); err != nil {
		if errors.Is(err, repository.ErrUserNotFound) {
			return domain.Document{}, ErrUserNotFound
		}
		return domain.Document{}, fmt.Errorf("verify user: %w", err)
	}
	if err := validateKind(in.Kind); err != nil {
		return domain.Document{}, err
	}
	if err := validateStorageURI(in.StorageURI); err != nil {
		return domain.Document{}, err
	}
	if err := validateCapturedAt(in.CapturedAt); err != nil {
		return domain.Document{}, err
	}

	doc := domain.Document{
		ID:         ulid.Make().String(),
		UserID:     in.UserID,
		Kind:       strings.TrimSpace(in.Kind),
		StorageURI: strings.TrimSpace(in.StorageURI),
		CapturedAt: in.CapturedAt.UTC(),
		GPSLat:     in.GPSLat,
		GPSLng:     in.GPSLng,
		DeviceID:   strings.TrimSpace(in.DeviceID),
	}
	if err := s.docs.Create(ctx, &doc); err != nil {
		return domain.Document{}, fmt.Errorf("create document: %w", err)
	}
	return doc, nil
}

func validateKind(s string) error {
	t := strings.TrimSpace(s)
	if t == "" {
		return ErrInvalidKind
	}
	if len(t) > kindMaxLen {
		return ErrInvalidKind
	}
	for _, r := range t {
		switch {
		case r >= 'a' && r <= 'z',
			r >= 'A' && r <= 'Z',
			r >= '0' && r <= '9',
			r == '_', r == '-':
			continue
		default:
			return ErrInvalidKind
		}
	}
	return nil
}

func validateStorageURI(s string) error {
	t := strings.TrimSpace(s)
	if t == "" || len(t) > storageURIMaxLen {
		return ErrInvalidStorageURI
	}
	u, err := url.Parse(t)
	if err != nil || u.Scheme == "" {
		return ErrInvalidStorageURI
	}
	return nil
}

func validateCapturedAt(t time.Time) error {
	if t.IsZero() {
		return ErrInvalidCapturedAt
	}
	if t.After(time.Now().Add(capturedAtFutureSkew)) {
		return ErrInvalidCapturedAt
	}
	return nil
}

// clampPage applies the same defaults the repository would, but
// here so the handler doesn't accept absurd values from the wire.
func clampPage(limit, offset int) (int, int) {
	if limit <= 0 {
		limit = 50
	}
	if limit > 200 {
		limit = 200
	}
	if offset < 0 {
		offset = 0
	}
	return limit, offset
}
