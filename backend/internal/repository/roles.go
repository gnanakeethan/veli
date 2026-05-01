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
	"github.com/stephenafamo/bob/dialect/psql/dm"
	"github.com/stephenafamo/bob/dialect/psql/sm"

	"github.com/cloudparallax/veli/internal/database/models"
	"github.com/cloudparallax/veli/internal/domain"
)

// ErrRoleNotFound is returned when a role can't be located by id or code.
var ErrRoleNotFound = errors.New("role not found")

// ErrUserRoleNotFound is returned when a (user_id, role_id) grant
// doesn't exist on revoke.
var ErrUserRoleNotFound = errors.New("user role assignment not found")

// RolesRepository is the data-access contract for roles, permissions,
// and the user-role assignment table.
type RolesRepository interface {
	GetByCode(ctx context.Context, code string) (domain.Role, error)
	ListByUserID(ctx context.Context, userID string) ([]domain.Role, error)
	HasPermission(ctx context.Context, userID, permissionCode string) (bool, error)
	AssignRole(ctx context.Context, userID, roleID string, grantedByUserID string) error
	RevokeRole(ctx context.Context, userID, roleID string) error
}

func NewRolesRepository(exec bob.Executor) RolesRepository {
	return &bobRolesRepository{exec: exec}
}

type bobRolesRepository struct {
	exec bob.Executor
}

func (r *bobRolesRepository) GetByCode(ctx context.Context, code string) (domain.Role, error) {
	role, err := models.Roles.Query(
		sm.Where(models.Roles.Columns.Code.EQ(psql.Arg(code))),
	).One(ctx, r.exec)
	if errors.Is(err, sql.ErrNoRows) {
		return domain.Role{}, ErrRoleNotFound
	}
	if err != nil {
		return domain.Role{}, fmt.Errorf("get role by code: %w", err)
	}
	return roleModelToDomain(role), nil
}

const listRolesByUserQuery = `
SELECT r.id, r.code, r.display_name, r.description, r.is_system_role, r.created_at, r.updated_at
FROM roles r
JOIN user_roles ur ON ur.role_id = r.id
WHERE ur.user_id = $1
ORDER BY r.display_name
`

func (r *bobRolesRepository) ListByUserID(ctx context.Context, userID string) ([]domain.Role, error) {
	rows, err := r.exec.QueryContext(ctx, listRolesByUserQuery, userID)
	if err != nil {
		return nil, fmt.Errorf("query user roles: %w", err)
	}
	defer func() { _ = rows.Close() }()

	var out []domain.Role
	for rows.Next() {
		var role domain.Role
		if err := rows.Scan(
			&role.ID,
			&role.Code,
			&role.DisplayName,
			&role.Description,
			&role.IsSystemRole,
			&role.CreatedAt,
			&role.UpdatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan user role: %w", err)
		}
		out = append(out, role)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate user roles: %w", err)
	}
	return out, nil
}

const hasPermissionQuery = `
SELECT EXISTS (
    SELECT 1
    FROM user_roles ur
    JOIN role_permissions rp ON rp.role_id = ur.role_id
    JOIN permissions p ON p.id = rp.permission_id
    WHERE ur.user_id = $1 AND p.code = $2
)
`

func (r *bobRolesRepository) HasPermission(ctx context.Context, userID, permissionCode string) (bool, error) {
	rows, err := r.exec.QueryContext(ctx, hasPermissionQuery, userID, permissionCode)
	if err != nil {
		return false, fmt.Errorf("query has permission: %w", err)
	}
	defer func() { _ = rows.Close() }()

	if !rows.Next() {
		return false, nil
	}
	var exists bool
	if err := rows.Scan(&exists); err != nil {
		return false, fmt.Errorf("scan has permission: %w", err)
	}
	return exists, nil
}

func (r *bobRolesRepository) AssignRole(ctx context.Context, userID, roleID, grantedByUserID string) error {
	setter := &models.UserRoleSetter{
		UserID: omit.From(userID),
		RoleID: omit.From(roleID),
	}
	if grantedByUserID != "" {
		setter.GrantedBy = omitnull.From(grantedByUserID)
	}
	if _, err := models.UserRoles.Insert(setter).One(ctx, r.exec); err != nil {
		return fmt.Errorf("insert user_role: %w", err)
	}
	return nil
}

func (r *bobRolesRepository) RevokeRole(ctx context.Context, userID, roleID string) error {
	affected, err := models.UserRoles.Delete(
		dm.Where(models.UserRoles.Columns.UserID.EQ(psql.Arg(userID))),
		dm.Where(models.UserRoles.Columns.RoleID.EQ(psql.Arg(roleID))),
	).Exec(ctx, r.exec)
	if err != nil {
		return fmt.Errorf("delete user_role: %w", err)
	}
	if affected == 0 {
		return ErrUserRoleNotFound
	}
	return nil
}

func roleModelToDomain(m *models.Role) domain.Role {
	return domain.Role{
		ID:           m.ID,
		Code:         m.Code,
		DisplayName:  m.DisplayName,
		Description:  m.Description,
		IsSystemRole: m.IsSystemRole,
		CreatedAt:    m.CreatedAt,
		UpdatedAt:    m.UpdatedAt,
	}
}
