-- +goose Up
-- +goose StatementBegin

-- Phase 0 RBAC layer.
-- Three system roles (super_admin, manager, user); fine-grained
-- permission codes; M:N role-permission grants and user-role
-- assignments. See docs/plan/02_phase0_foundations.typ §Identity
-- Architecture and CLAUDE.md.
-- The seeded ULIDs are deterministic so future migrations and tests
-- can refer to them by literal value.

CREATE TABLE roles (
    id              TEXT PRIMARY KEY,                                       -- ULID
    code            TEXT NOT NULL UNIQUE,                                   -- 'super_admin' | 'manager' | 'user' | future codes
    display_name    TEXT NOT NULL,
    description     TEXT NOT NULL DEFAULT '',
    is_system_role  BOOLEAN NOT NULL DEFAULT FALSE,                         -- TRUE => seeded; cannot be deleted via API
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX roles_code_idx ON roles (code);

CREATE TABLE permissions (
    id           TEXT PRIMARY KEY,                                          -- ULID
    code         TEXT NOT NULL UNIQUE,                                      -- 'users:list', 'documents:moderate', etc.
    description  TEXT NOT NULL DEFAULT '',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX permissions_code_idx ON permissions (code);

CREATE TABLE role_permissions (
    role_id        TEXT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id  TEXT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE user_roles (
    user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id     TEXT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    granted_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    granted_by  TEXT REFERENCES users(id),                                  -- nullable: seeded grants carry NULL
    PRIMARY KEY (user_id, role_id)
);

CREATE INDEX user_roles_user_id_idx ON user_roles (user_id);
CREATE INDEX user_roles_role_id_idx ON user_roles (role_id);

-- Seed: three system roles.
INSERT INTO roles (id, code, display_name, description, is_system_role) VALUES
    ('01KQHE341VR4YK4C5CERP3P11Y', 'super_admin', 'Super Administrator',
     'Cloud Parallax core team. All capabilities. Seeded.', TRUE),
    ('01KQHE341WVP85MY3DS5C78HYV', 'manager', 'Manager',
     'Operations manager. User and content management; no auth/security primitives. Seeded.', TRUE),
    ('01KQHE341WVP85MY3DS5DM59E4', 'user', 'User',
     'Default role for any registered user. Read access to own records. Seeded.', TRUE);

-- Seed: ten fine-grained permissions in namespace:action form.
INSERT INTO permissions (id, code, description) VALUES
    ('01KQHE341WVP85MY3DS81H8RQ4', 'users:list',          'List all users in the platform'),
    ('01KQHE341WVP85MY3DSBDGDYX1', 'users:read',          'Read any user record'),
    ('01KQHE341WVP85MY3DSCGE5QHJ', 'users:write',         'Create or modify any user'),
    ('01KQHE341WVP85MY3DSFM8QKKK', 'users:delete',        'Delete any user'),
    ('01KQHE341WVP85MY3DSGBY0XF3', 'roles:list',          'List role definitions'),
    ('01KQHE341WVP85MY3DSKHFCM81', 'roles:assign',        'Assign or revoke roles on users'),
    ('01KQHE341WVP85MY3DSQC48WJZ', 'roles:write',         'Create or modify role definitions'),
    ('01KQHE341WVP85MY3DSQJNCBZA', 'documents:read',      'Read any document'),
    ('01KQHE341WVP85MY3DSVFT9QQK', 'documents:moderate',  'Moderate documents (review, take down)'),
    ('01KQHE341WVP85MY3DSXN9MVQ3', 'audit:read',          'Read audit logs');

-- Super admin: every permission.
INSERT INTO role_permissions (role_id, permission_id)
SELECT '01KQHE341VR4YK4C5CERP3P11Y', id FROM permissions;

-- Manager: users (full) + roles:list (no assign) + documents (full) + audit (read).
INSERT INTO role_permissions (role_id, permission_id) VALUES
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQHE341WVP85MY3DS81H8RQ4'),  -- users:list
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQHE341WVP85MY3DSBDGDYX1'),  -- users:read
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQHE341WVP85MY3DSCGE5QHJ'),  -- users:write
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQHE341WVP85MY3DSGBY0XF3'),  -- roles:list
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQHE341WVP85MY3DSQJNCBZA'),  -- documents:read
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQHE341WVP85MY3DSVFT9QQK'),  -- documents:moderate
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQHE341WVP85MY3DSXN9MVQ3');  -- audit:read

-- 'user' role: no platform-wide permissions; read access to own
-- records is enforced at the service layer via subject scoping.

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS role_permissions;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS roles;
-- +goose StatementEnd
