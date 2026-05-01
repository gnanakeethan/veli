// Package service contains business logic that sits between handlers
// and repositories. Services validate inputs, enforce invariants, and
// return typed errors handlers can map to HTTP statuses.
package service

import (
	"context"
	"errors"
	"fmt"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
)

// ErrInvalidID is returned when the caller-supplied user ID is not a
// syntactically valid ULID. It is distinct from ErrUserNotFound: a
// malformed ID should produce HTTP 400, not 404.
var ErrInvalidID = errors.New("invalid user id")

// ErrUserNotFound is re-exported from the repository so handlers
// import a single package boundary.
var ErrUserNotFound = repository.ErrUserNotFound

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

// isWellFormedULID surface-checks the canonical ULID encoding: 26
// characters in Crockford base32 (digits plus uppercase letters minus
// I, L, O, U). It does not parse the timestamp half or assert
// uniqueness — generation will eventually use oklog/ulid; this is the
// defensive validator at the service boundary.
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
