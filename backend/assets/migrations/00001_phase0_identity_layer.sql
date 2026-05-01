-- +goose Up
-- +goose StatementBegin

-- Phase 0 shared identity & document layer.
-- Reused by Phase 1 (govnav), Phase 2 (land docs), Phase 3 (agri traceability).
-- See veli_implementation_plan.typ §Phase 0 — Shared Architecture Specification.

CREATE TABLE users (
    id            TEXT PRIMARY KEY,                              -- ULID
    phone         TEXT NOT NULL UNIQUE,                          -- E.164
    nic_number    TEXT UNIQUE,                                   -- optional NIC linkage
    display_name  TEXT NOT NULL DEFAULT '',
    locale        TEXT NOT NULL DEFAULT 'ta',                    -- 'ta' | 'en' | 'si'
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX users_phone_idx ON users (phone);

CREATE TABLE documents (
    id           TEXT PRIMARY KEY,                               -- ULID
    user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    kind         TEXT NOT NULL,                                  -- e.g. 'birth_cert', 'deed', 'witness_statement'
    storage_uri  TEXT NOT NULL,                                  -- object-store URI (client-side encrypted)
    captured_at  TIMESTAMPTZ NOT NULL,
    gps_lat      DOUBLE PRECISION,
    gps_lng      DOUBLE PRECISION,
    device_id    TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX documents_user_id_idx ON documents (user_id);
CREATE INDEX documents_kind_idx ON documents (kind);

CREATE TABLE verifications (
    id           TEXT PRIMARY KEY,                               -- ULID
    document_id  TEXT NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    tier         TEXT NOT NULL CHECK (tier IN (
        'self_asserted',
        'community_corroborated',
        'authority_attested'
    )),
    attester_id  TEXT NOT NULL,                                  -- user_id or external authority ref
    notes        TEXT NOT NULL DEFAULT '',
    verified_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX verifications_document_id_idx ON verifications (document_id);
CREATE INDEX verifications_tier_idx ON verifications (tier);

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS verifications;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS users;
-- +goose StatementEnd
