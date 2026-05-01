package service

import (
	"context"
	"errors"
	"fmt"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
)

// Sentinel errors for the RBAC layer. Each maps to a specific HTTP
// status in the middleware: 401 / 403 / 404 / 500.
var (
	ErrUnauthenticated = errors.New("unauthenticated")
	ErrForbidden       = errors.New("forbidden")
	ErrRoleNotFound    = repository.ErrRoleNotFound
)

// RBACService coordinates permission checks and role assignments.
type RBACService struct {
	repo repository.RolesRepository
}

func NewRBACService(repo repository.RolesRepository) *RBACService {
	return &RBACService{repo: repo}
}

// RequirePermission returns nil iff userID is non-empty AND the user
// holds at least one role that grants permissionCode. Returns
// ErrUnauthenticated when userID is empty, ErrForbidden when the
// user lacks the permission, or a wrapped error when the lookup
// fails.
func (s *RBACService) RequirePermission(ctx context.Context, userID, permissionCode string) error {
	if userID == "" {
		return ErrUnauthenticated
	}
	ok, err := s.repo.HasPermission(ctx, userID, permissionCode)
	if err != nil {
		return fmt.Errorf("check permission: %w", err)
	}
	if !ok {
		return ErrForbidden
	}
	return nil
}

// ListUserRoles returns the roles a user holds, ordered by display
// name. An empty slice is returned when the user has no role
// assignments (which is normal for newly-registered users).
func (s *RBACService) ListUserRoles(ctx context.Context, userID string) ([]domain.Role, error) {
	roles, err := s.repo.ListByUserID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("list user roles: %w", err)
	}
	return roles, nil
}

// AssignRoleByCode resolves the role code to its ID, then grants it
// to userID. grantedByUserID may be empty for system / seed grants.
// Returns ErrRoleNotFound when the role code doesn't exist.
func (s *RBACService) AssignRoleByCode(ctx context.Context, userID, roleCode, grantedByUserID string) error {
	role, err := s.repo.GetByCode(ctx, roleCode)
	if err != nil {
		if errors.Is(err, repository.ErrRoleNotFound) {
			return ErrRoleNotFound
		}
		return fmt.Errorf("resolve role code: %w", err)
	}
	if err := s.repo.AssignRole(ctx, userID, role.ID, grantedByUserID); err != nil {
		return fmt.Errorf("assign role: %w", err)
	}
	return nil
}

// RevokeRoleByCode resolves the role code to its ID, then revokes it
// from userID. Returns ErrRoleNotFound when the role code doesn't
// exist; the underlying repository.ErrUserRoleNotFound is wrapped
// when the user doesn't currently hold the role.
func (s *RBACService) RevokeRoleByCode(ctx context.Context, userID, roleCode string) error {
	role, err := s.repo.GetByCode(ctx, roleCode)
	if err != nil {
		if errors.Is(err, repository.ErrRoleNotFound) {
			return ErrRoleNotFound
		}
		return fmt.Errorf("resolve role code: %w", err)
	}
	if err := s.repo.RevokeRole(ctx, userID, role.ID); err != nil {
		return fmt.Errorf("revoke role: %w", err)
	}
	return nil
}
