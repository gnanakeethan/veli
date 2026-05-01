-- +goose Up
-- +goose StatementBegin

-- Phase 0 admin auth groundwork.
-- Adds an optional email channel on users plus an external_identities
-- table that links external auth subjects (Google now; Apple/etc. later)
-- to existing veli users. The platform stays phone-anchored for end
-- users; this layer is for staff / admins who authenticate via Google
-- Workspace, per the assumption logged in assumptions.md.

ALTER TABLE users ADD COLUMN email TEXT;

-- Partial unique index: enforce uniqueness only when email is present.
-- Existing rows (created via phone-only flow) carry NULL and stay valid.
CREATE UNIQUE INDEX users_email_unique ON users (email) WHERE email IS NOT NULL;

CREATE TABLE external_identities (
    provider      TEXT NOT NULL,                                          -- 'google' for now
    subject       TEXT NOT NULL,                                          -- provider's stable subject id (Google sub)
    user_id       TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    email         TEXT NOT NULL DEFAULT '',                               -- email at link time (provider-asserted)
    linked_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (provider, subject)
);

CREATE INDEX external_identities_user_id_idx ON external_identities (user_id);
CREATE INDEX external_identities_email_idx   ON external_identities (email);

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS external_identities;
DROP INDEX IF EXISTS users_email_unique;
ALTER TABLE users DROP COLUMN IF EXISTS email;
-- +goose StatementEnd
