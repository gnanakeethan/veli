package service_test

import (
	"context"
	"errors"
	"testing"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
	"github.com/cloudparallax/veli/internal/service"
)

// stubRolesRepo is a minimal in-memory RolesRepository used by the
// RBACService tests. Field naming mirrors stubUsersRepo.
type stubRolesRepo struct {
	roleByCode    map[string]domain.Role
	rolesByUserID map[string][]domain.Role
	hasPerm       map[string]bool // key: userID + "|" + permissionCode

	getByCodeErr  error
	listByUserErr error
	hasPermErr    error
	assignErr     error
	revokeErr     error

	gotAssign struct {
		userID, roleID, grantedBy string
		called                    bool
	}
	gotRevoke struct {
		userID, roleID string
		called         bool
	}
}

func (s *stubRolesRepo) GetByCode(_ context.Context, code string) (domain.Role, error) {
	if s.getByCodeErr != nil {
		return domain.Role{}, s.getByCodeErr
	}
	r, ok := s.roleByCode[code]
	if !ok {
		return domain.Role{}, repository.ErrRoleNotFound
	}
	return r, nil
}

func (s *stubRolesRepo) ListByUserID(_ context.Context, userID string) ([]domain.Role, error) {
	if s.listByUserErr != nil {
		return nil, s.listByUserErr
	}
	return s.rolesByUserID[userID], nil
}

func (s *stubRolesRepo) HasPermission(_ context.Context, userID, code string) (bool, error) {
	if s.hasPermErr != nil {
		return false, s.hasPermErr
	}
	return s.hasPerm[userID+"|"+code], nil
}

func (s *stubRolesRepo) AssignRole(_ context.Context, userID, roleID, grantedBy string) error {
	s.gotAssign.userID, s.gotAssign.roleID, s.gotAssign.grantedBy = userID, roleID, grantedBy
	s.gotAssign.called = true
	return s.assignErr
}

func (s *stubRolesRepo) RevokeRole(_ context.Context, userID, roleID string) error {
	s.gotRevoke.userID, s.gotRevoke.roleID = userID, roleID
	s.gotRevoke.called = true
	return s.revokeErr
}

func TestRBACService_RequirePermission(t *testing.T) {
	const (
		userID = "01ARZ3NDEKTSV4RRFFQ69G5FAV"
		perm   = "users:list"
	)
	boom := errors.New("db down")

	cases := []struct {
		name      string
		actor     string
		hasPerm   bool
		hasErr    error
		wantErr   error
		wantUnder error // when wantErr is wrapped, the underlying sentinel
	}{
		{
			name:    "no actor — unauthenticated",
			actor:   "",
			wantErr: service.ErrUnauthenticated,
		},
		{
			name:    "actor lacks permission — forbidden",
			actor:   userID,
			hasPerm: false,
			wantErr: service.ErrForbidden,
		},
		{
			name:    "actor has permission — allowed",
			actor:   userID,
			hasPerm: true,
			wantErr: nil,
		},
		{
			name:      "lookup error wrapped",
			actor:     userID,
			hasErr:    boom,
			wantErr:   boom,
			wantUnder: boom,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			repo := &stubRolesRepo{
				hasPerm: map[string]bool{userID + "|" + perm: tc.hasPerm},
				hasPermErr: tc.hasErr,
			}
			svc := service.NewRBACService(repo)

			err := svc.RequirePermission(context.Background(), tc.actor, perm)

			if tc.wantErr == nil {
				if err != nil {
					t.Fatalf("expected nil error, got %v", err)
				}
				return
			}
			if err == nil {
				t.Fatalf("expected error %v, got nil", tc.wantErr)
			}
			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("expected errors.Is(err, %v); got %v", tc.wantErr, err)
			}
		})
	}
}

func TestRBACService_AssignRoleByCode(t *testing.T) {
	const (
		actorID  = "01ARZ3NDEKTSV4RRFFQ69G5FAV"
		targetID = "01HZ0YBKMNPQRSTV0TARGET001"
	)
	managerRole := domain.Role{
		ID:           "01KQHE341WVP85MY3DS5C78HYV",
		Code:         "manager",
		DisplayName:  "Manager",
		IsSystemRole: true,
	}
	boom := errors.New("constraint violation")

	cases := []struct {
		name        string
		roleCode    string
		assignErr   error
		wantErr     error
		wantInsert  bool
	}{
		{
			name:       "happy path",
			roleCode:   "manager",
			wantInsert: true,
		},
		{
			name:     "role code not found",
			roleCode: "missing",
			wantErr:  service.ErrRoleNotFound,
		},
		{
			name:       "repository assign error wrapped",
			roleCode:   "manager",
			assignErr:  boom,
			wantErr:    boom,
			wantInsert: true,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			repo := &stubRolesRepo{
				roleByCode: map[string]domain.Role{"manager": managerRole},
				assignErr:  tc.assignErr,
			}
			svc := service.NewRBACService(repo)

			err := svc.AssignRoleByCode(context.Background(), targetID, tc.roleCode, actorID)

			if tc.wantErr == nil {
				if err != nil {
					t.Fatalf("unexpected error: %v", err)
				}
			} else {
				if err == nil {
					t.Fatalf("expected error %v, got nil", tc.wantErr)
				}
				if !errors.Is(err, tc.wantErr) {
					t.Fatalf("expected errors.Is(err, %v); got %v", tc.wantErr, err)
				}
			}

			if repo.gotAssign.called != tc.wantInsert {
				t.Fatalf("expected wantInsert=%v, got called=%v", tc.wantInsert, repo.gotAssign.called)
			}
			if tc.wantInsert {
				if repo.gotAssign.userID != targetID {
					t.Fatalf("assign target: got %q want %q", repo.gotAssign.userID, targetID)
				}
				if repo.gotAssign.roleID != managerRole.ID {
					t.Fatalf("assign role id: got %q want %q", repo.gotAssign.roleID, managerRole.ID)
				}
				if repo.gotAssign.grantedBy != actorID {
					t.Fatalf("granted_by: got %q want %q", repo.gotAssign.grantedBy, actorID)
				}
			}
		})
	}
}

func TestRBACService_RevokeRoleByCode(t *testing.T) {
	const (
		userID = "01ARZ3NDEKTSV4RRFFQ69G5FAV"
	)
	managerRole := domain.Role{
		ID:           "01KQHE341WVP85MY3DS5C78HYV",
		Code:         "manager",
		DisplayName:  "Manager",
		IsSystemRole: true,
	}

	cases := []struct {
		name        string
		roleCode    string
		revokeErr   error
		wantErr     error
		wantRevoked bool
	}{
		{
			name:        "happy path",
			roleCode:    "manager",
			wantRevoked: true,
		},
		{
			name:     "role code not found",
			roleCode: "missing",
			wantErr:  service.ErrRoleNotFound,
		},
		{
			name:        "user does not hold role",
			roleCode:    "manager",
			revokeErr:   repository.ErrUserRoleNotFound,
			wantErr:     repository.ErrUserRoleNotFound,
			wantRevoked: true,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			repo := &stubRolesRepo{
				roleByCode: map[string]domain.Role{"manager": managerRole},
				revokeErr:  tc.revokeErr,
			}
			svc := service.NewRBACService(repo)

			err := svc.RevokeRoleByCode(context.Background(), userID, tc.roleCode)

			if tc.wantErr == nil {
				if err != nil {
					t.Fatalf("unexpected error: %v", err)
				}
			} else {
				if err == nil {
					t.Fatalf("expected error %v, got nil", tc.wantErr)
				}
				if !errors.Is(err, tc.wantErr) {
					t.Fatalf("expected errors.Is(err, %v); got %v", tc.wantErr, err)
				}
			}

			if repo.gotRevoke.called != tc.wantRevoked {
				t.Fatalf("expected wantRevoked=%v, got called=%v", tc.wantRevoked, repo.gotRevoke.called)
			}
		})
	}
}
