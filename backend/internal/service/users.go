// Package service contains business logic that sits between handlers
// and repositories. Services validate inputs, enforce invariants, and
// return typed errors handlers can map to HTTP statuses.
package service

import (
	"context"
	"errors"
	"fmt"
	"regexp"
	"strings"
	"unicode/utf8"

	"github.com/oklog/ulid/v2"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
)

// Sentinel errors. Each maps to a specific HTTP status in the handler;
// extend the set rather than reusing one for two distinct cases.
var (
	ErrInvalidID          = errors.New("invalid user id")
	ErrInvalidPhone       = errors.New("invalid phone")
	ErrInvalidLocale      = errors.New("invalid locale")
	ErrInvalidDisplayName = errors.New("invalid display_name")
	ErrUserNotFound       = repository.ErrUserNotFound
)

// CreateUserInput is the validated set of fields a caller may supply
// to register a new user. ULID generation, timestamps, and the
// repository call are owned by the service.
type CreateUserInput struct {
	Phone       string
	DisplayName string
	Locale      string
	NICNumber   string // empty means "not provided"; stored as NULL
}

// UsersService coordinates user-related business logic.
type UsersService struct {
	repo repository.UsersRepository
}

// NewUsersService wires the service to a repository.
func NewUsersService(repo repository.UsersRepository) *UsersService {
	return &UsersService{repo: repo}
}

// GetByID validates the ID and returns the user. ErrInvalidID for
// malformed IDs, ErrUserNotFound when the row is absent.
func (s *UsersService) GetByID(ctx context.Context, id string) (domain.User, error) {
	if !isWellFormedULID(id) {
		return domain.User{}, ErrInvalidID
	}
	u, err := s.repo.GetByID(ctx, id)
	if err != nil {
		if errors.Is(err, repository.ErrUserNotFound) {
			return domain.User{}, ErrUserNotFound
		}
		return domain.User{}, fmt.Errorf("get user: %w", err)
	}
	return u, nil
}

// List returns a paginated list of users for the admin UI. Page size
// is clamped to [1, 200]. Authorisation is enforced upstream by the
// admin route's RequirePermission("users:list") middleware.
func (s *UsersService) List(ctx context.Context, limit, offset int) ([]domain.User, error) {
	if limit <= 0 {
		limit = 50
	}
	if limit > 200 {
		limit = 200
	}
	if offset < 0 {
		offset = 0
	}
	users, err := s.repo.List(ctx, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("list users: %w", err)
	}
	return users, nil
}

// Create validates the input, mints a ULID, and persists a new user.
// On success the returned domain.User has the ID, timestamps, and
// trimmed display_name and nic_number applied.
func (s *UsersService) Create(ctx context.Context, in CreateUserInput) (domain.User, error) {
	if !isValidE164(in.Phone) {
		return domain.User{}, ErrInvalidPhone
	}
	if !isSupportedLocale(in.Locale) {
		return domain.User{}, ErrInvalidLocale
	}
	displayName := strings.TrimSpace(in.DisplayName)
	if displayName == "" || utf8.RuneCountInString(displayName) > 200 {
		return domain.User{}, ErrInvalidDisplayName
	}

	user := domain.User{
		ID:          ulid.Make().String(),
		Phone:       in.Phone,
		DisplayName: displayName,
		Locale:      in.Locale,
		NICNumber:   strings.TrimSpace(in.NICNumber),
	}

	if err := s.repo.Create(ctx, &user); err != nil {
		return domain.User{}, fmt.Errorf("create user: %w", err)
	}
	return user, nil
}

// e164Pattern is the surface check we apply to phone numbers at the
// service boundary: a leading '+' (no country prefix omission), a
// leading non-zero digit, then 6–14 more digits, total 7–15 digits.
// Mirrors ITU-T E.164 max length of 15 digits including country code.
var e164Pattern = regexp.MustCompile(`^\+[1-9]\d{6,14}$`)

func isValidE164(s string) bool {
	return e164Pattern.MatchString(s)
}

func isSupportedLocale(s string) bool {
	switch s {
	case "en", "ta", "si":
		return true
	default:
		return false
	}
}

// isWellFormedULID surface-checks the canonical ULID encoding: 26
// characters in Crockford base32 (digits plus uppercase letters minus
// I, L, O, U). Generation uses oklog/ulid; this validator stays
// because we receive IDs from URL params at the handler boundary.
func isWellFormedULID(id string) bool {
	if len(id) != 26 {
		return false
	}
	for _, c := range id {
		if !isCrockfordBase32(c) {
			return false
		}
	}
	return true
}

func isCrockfordBase32(r rune) bool {
	switch {
	case r >= '0' && r <= '9':
		return true
	case r >= 'A' && r <= 'Z':
		return r != 'I' && r != 'L' && r != 'O' && r != 'U'
	default:
		return false
	}
}
