package domain

import "time"

// Role is a named bundle of permissions a user can hold. The system
// roles (super_admin, manager, user) are seeded in migration 00002
// and carry IsSystemRole = true; user-defined roles (when we allow
// them) carry false.
type Role struct {
	ID           string    `json:"id"`
	Code         string    `json:"code"`
	DisplayName  string    `json:"display_name"`
	Description  string    `json:"description,omitempty"`
	IsSystemRole bool      `json:"is_system_role"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

// Permission is a fine-grained capability code in namespace:action
// form (e.g. "users:list", "documents:moderate"). The set is fixed
// at migration time; we don't yet allow runtime permission creation.
type Permission struct {
	ID          string    `json:"id"`
	Code        string    `json:"code"`
	Description string    `json:"description,omitempty"`
	CreatedAt   time.Time `json:"created_at"`
}

// UserRoleGrant records that a user holds a role. GrantedBy is the
// actor who made the assignment (nil for seeded grants).
type UserRoleGrant struct {
	UserID    string    `json:"user_id"`
	RoleID    string    `json:"role_id"`
	RoleCode  string    `json:"role_code"`
	GrantedAt time.Time `json:"granted_at"`
	GrantedBy *string   `json:"granted_by,omitempty"`
}
