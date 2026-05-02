-- +goose Up
-- +goose StatementBegin

-- Phase 1 GovNav: procedure body content.
-- The original procedures table stored only summary text. For the
-- citizen-facing flow to be actually useful — "tell me step by step
-- how to get a birth certificate" — we need long-form content.
-- body_ta / body_en hold plain-text instructions with paragraph
-- breaks (rendered as <p> blocks on the citizen detail page). We
-- deliberately don't model individual steps as relational rows
-- yet: the plan §3 calls for that eventually but the editorial
-- workflow at this phase is still "the verifier walks through the
-- procedure and writes it up", which is more naturally a single
-- text blob than a rigid 1..N step table.

ALTER TABLE procedures ADD COLUMN body_ta TEXT NOT NULL DEFAULT '';
ALTER TABLE procedures ADD COLUMN body_en TEXT NOT NULL DEFAULT '';

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE procedures DROP COLUMN IF EXISTS body_en;
ALTER TABLE procedures DROP COLUMN IF EXISTS body_ta;
-- +goose StatementEnd
