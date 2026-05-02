-- +goose Up
-- +goose StatementBegin

-- Phase 1 GovNav: procedure content schema.
-- A "procedure" is a single citizen-facing government errand
-- (birth-certificate replacement, NIC application, Samurdhi
-- enrolment, etc.). Bilingual columns are normative: Tamil-first
-- with English as a secondary surface. last_verified_at is the
-- citation timestamp — when the content was last walked through
-- by a Veḷi verifier against the actual office, not when the row
-- was edited (which is updated_at).
--
-- Citizens read 'published' rows via the public REST endpoint;
-- admins read all statuses including 'draft' / 'archived' through
-- the gated admin endpoint. Status transitions are linear:
-- draft → published → archived.

CREATE TABLE procedures (
    id                TEXT PRIMARY KEY,                                                            -- ULID
    slug              TEXT NOT NULL UNIQUE,                                                        -- 'birth-certificate-replacement'
    title_ta          TEXT NOT NULL,                                                               -- Tamil title (primary, required)
    title_en          TEXT NOT NULL DEFAULT '',                                                    -- English title (secondary)
    summary_ta        TEXT NOT NULL DEFAULT '',                                                    -- short Tamil description
    summary_en        TEXT NOT NULL DEFAULT '',                                                    -- short English description
    fee_lkr_cents     BIGINT,                                                                      -- nullable: not all procedures have a fixed fee
    source_url        TEXT NOT NULL DEFAULT '',                                                    -- citation: government circular / gazette / departmental URL
    last_verified_at  TIMESTAMPTZ,                                                                 -- when content was last walked through against the actual office
    status            TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX procedures_status_idx ON procedures (status);

-- Add procedures permissions. Citizens hit the unauthenticated
-- /api/v1/procedures and only see 'published' rows; the read-all
-- (including draft/archived) endpoint is admin-only.
INSERT INTO permissions (id, code, description) VALUES
    ('01KQKN4ZTQR1M4TBRZND8X2XS6', 'procedures:read',   'Read all procedures (including drafts and archived)'),
    ('01KQKN4ZTQR1M4TBRZNFERJ68C', 'procedures:write',  'Create, update, or archive procedures');

-- Super admin: full procedures access.
INSERT INTO role_permissions (role_id, permission_id) VALUES
    ('01KQHE341VR4YK4C5CERP3P11Y', '01KQKN4ZTQR1M4TBRZND8X2XS6'),
    ('01KQHE341VR4YK4C5CERP3P11Y', '01KQKN4ZTQR1M4TBRZNFERJ68C');

-- Manager: read drafts + write. Procedures content lifecycle is the
-- core of the manager role's day-to-day work, per the role description
-- in 00002_phase0_rbac.sql.
INSERT INTO role_permissions (role_id, permission_id) VALUES
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQKN4ZTQR1M4TBRZND8X2XS6'),
    ('01KQHE341WVP85MY3DS5C78HYV', '01KQKN4ZTQR1M4TBRZNFERJ68C');

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DELETE FROM role_permissions WHERE permission_id IN (
    '01KQKN4ZTQR1M4TBRZND8X2XS6',
    '01KQKN4ZTQR1M4TBRZNFERJ68C'
);
DELETE FROM permissions WHERE id IN (
    '01KQKN4ZTQR1M4TBRZND8X2XS6',
    '01KQKN4ZTQR1M4TBRZNFERJ68C'
);
DROP TABLE IF EXISTS procedures;
-- +goose StatementEnd
