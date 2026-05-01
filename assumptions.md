# Veḷi — session assumptions (2026-05-01)

## Assumption: Edit the verification-tier names in place in the unmerged migration

**Decision:** Renamed `community_witnessed` → `community_corroborated` and `authority_verified` → `authority_attested` directly inside `00001_phase0_identity_layer.sql` rather than adding a follow-on rename migration.

**Why:** CLAUDE.md mandates the v1.5 names exactly, and the migration was unapplied + the change unmerged, so editing in place was safer than carrying the wrong CHECK values into history. See commit `80abd031`.

**Revisit when:** before any branch carrying this migration is merged into a release branch or applied against a shared/staging database. Once merged, the append-only rule applies and the next change must be a new migration.

**Files:** `backend/assets/migrations/00001_phase0_identity_layer.sql`, `backend/internal/domain/identity.go`

## Assumption: Paraglide `baseLocale` stays `"en"` even though the product is Tamil-first

**Decision:** Left `project.inlang/settings.json` with `"baseLocale": "en"`; locales array is `["en", "ta", "si"]`.

**Why:** No explicit user direction on this; the inlang scaffold defaulted to `en` and a base-locale change has knock-on effects (which keys are authoritative for the message extractor, fallback chain, machine-translation source).

**Revisit when:** the user confirms intent — likely should be `ta` so Tamil is the source-of-truth catalog and `en`/`si` are translations. Ties into the CLAUDE.md rule "Author Tamil first; never translate Tamil from English."

**Files:** `frontend/project.inlang/settings.json`, `frontend/messages/{en,ta,si}.json`

## Assumption: Repository layer uses raw pgx; Bob ORM is configured but not wired

**Decision:** `internal/repository/users.go` uses `pgxpool` + `database/sql` adapters directly. Bob ORM is scaffolded (tools.go, bobgen.yaml, Makefile target) but no generated package is imported anywhere.

**Why:** Bob codegen needs a live Postgres to run against, and none was available in this session — see `427e720b`. Wiring up a hand-written repository proves the layering and lets the GET-user slice compile end-to-end.

**Revisit when:** `make models/regenerate` runs successfully against a local Postgres for the first time. Rewrite `pgxUsersRepository.GetByID` to use Bob's typed query DSL and delete the hand-written SQL string.

**Files:** `backend/internal/repository/users.go`, `backend/bobgen.yaml`, `backend/tools.go`, `backend/Makefile`

## Assumption: Inline ULID validator instead of pulling in `oklog/ulid/v2`

**Decision:** `service.isWellFormedULID` is a hand-rolled length + Crockford-base32 alphabet check inside `internal/service/users.go`.

**Why:** CLAUDE.md says "Ask before adding a new dependency." Read-only validation only needs a surface check, no parsing or generation, so a stdlib loop is sufficient and avoids a dep request the user didn't approve.

**Revisit when:** the create-user flow lands and we need real ULID generation (timestamp half + monotonic entropy). At that point, ask the user to approve `github.com/oklog/ulid/v2` and replace the inlined check with `ulid.Parse`.

**Files:** `backend/internal/service/users.go`, `backend/internal/service/users_test.go`

## Assumption: DB auto-migrate is a config-flag escape hatch, off by default

**Decision:** `cfg.Database.AutoMigrate` defaults to `false`; when `true`, `cmd/api/main.go` calls `db.MigrateUp` at startup. Toggleable via `VELI_DATABASE_AUTOMIGRATE`.

**Why:** Keeps local dev frictionless without committing to running migrations in production process startup, which is fragile for HA Postgres. Production should run `make migrations/up` from CI/deploy. See commit `f7ef49db`.

**Revisit when:** a deploy pipeline exists. Decide explicitly whether prod uses the goose CLI step (recommended) or the embedded path; document that in CLAUDE.md if the latter.

**Files:** `backend/internal/config/config.go`, `backend/cmd/api/main.go`, `backend/internal/db/migrations.go`

## Assumption: `domain.User` carries snake_case JSON tags; no separate presentation type

**Decision:** Added `json:"snake_case"` tags directly on `domain.User`. The wire format mirrors the SQL columns 1:1 — no DTO layer between domain and HTTP.

**Why:** Frontend type (`frontend/src/lib/api/types.ts`) and Tamil-first audit-log displays read more cleanly when frontend, backend, and SQL agree on field names. Avoids a transform layer for every payload.

**Revisit when:** a domain field needs a different external name (e.g. a redacted/derived field), or when responses need polymorphism per role. At that point introduce a `handler/dto/` package rather than tagging `domain` further.

**Files:** `backend/internal/domain/identity.go`, `frontend/src/lib/api/types.ts`

## Assumption: `internal/db/` (hand-written) is intentionally separate from `internal/database/` (Bob output)

**Decision:** Connection pool, embedded migrations, and migrate-up live under `internal/db/`. Bob's generated packages (models, factory, dbinfo, dberrors) are configured to land under `internal/database/` and are gitignored.

**Why:** Keeps generated code in a clearly-marked sibling so a `git status` always shows whether codegen ran without spurious diffs in hand-written plumbing. CLAUDE.md already names `internal/database/` as the gitignored Bob target.

**Revisit when:** if the dual-tree layout confuses contributors, consider renaming `internal/db/` → `internal/dbconn/` to make the distinction more obvious by name.

**Files:** `backend/internal/db/db.go`, `backend/internal/db/migrations.go`, `backend/.gitignore`, `backend/bobgen.yaml`

## Assumption: Frontend API client is fetch-injected, framework-agnostic

**Decision:** `createApiClient({ fetch, baseUrl })` takes its `fetch` from the caller. SvelteKit `load()` passes its context-aware fetch; tests pass a stub.

**Why:** Decouples the client from SvelteKit so it works in `+server.ts`, hooks, tests, and future Capacitor contexts equally. The trade-off is that callers must remember to pass SvelteKit's fetch in `+page.server.ts` for SSR-time request dedup and cookie forwarding to work.

**Revisit when:** if multiple call sites end up with the same boilerplate `createApiClient({ fetch, baseUrl })`, factor a SvelteKit-specific helper at `src/lib/server/api.ts` that resolves both from the load event.

**Files:** `frontend/src/lib/api/client.ts`, `frontend/src/lib/api/types.ts`, `frontend/src/lib/api/index.ts`

## Assumption: `VELI_API_BASE_URL` is server-only (`$env/dynamic/private`)

**Decision:** Documented in `frontend/.env.example` as server-only; no `PUBLIC_` prefix. Browser code never sees the backend URL directly.

**Why:** Keeps the SSR boundary load-bearing — browser cannot bypass server load functions, so there is one place to add auth, audit logging, and rate limits. Aligns with CLAUDE.md's "server-only code lives in `src/lib/server/`" rule.

**Revisit when:** if a feature genuinely needs direct browser → backend calls (e.g. websocket or file upload to object store), introduce a separate `PUBLIC_VELI_*` variable for that specific surface, don't widen this one.

**Files:** `frontend/.env.example`, `frontend/src/lib/api/client.ts`

## Assumption: `pgx/v5` promoted to a direct dependency in go.mod

**Decision:** When repository code started importing `github.com/jackc/pgx/v5` and `github.com/jackc/pgx/v5/pgxpool`, `go mod tidy` lifted pgx from indirect to direct.

**Why:** Mechanical consequence of `internal/db/db.go` and `internal/repository/users.go` importing the package. Listed for the record; no decision required, but the user should know pgx is now a load-bearing direct dep.

**Revisit when:** if Bob's generated repositories fully replace hand-written pgx code, pgxpool may stay direct (Bob uses it under the hood) but pgx core packages may go back to indirect.

**Files:** `backend/go.mod`

## Assumption: `github.com/jaswdr/faker/v2` is a direct dep, pulled in for Bob factories

**Decision:** Added `github.com/jaswdr/faker/v2 v2.9.1` to `go.mod` via `go get` from inside the backend module.

**Why:** Bob's factory plugin emits code that imports `faker/v2` for randomized fixtures. The first `make models/regenerate` failed `go vet` until the dep was added. It's a runtime dep of generated factory code, not a tooling entry, so `tools.go` is the wrong home for it.

**Revisit when:** if we ever stop using Bob factories (e.g. all tests switch to integration-only with seeded fixtures), faker can come back out. Otherwise treat as load-bearing.

**Files:** `backend/go.mod`, `backend/go.sum`

## Assumption: Bob's `enums` plugin is enabled even though we have no Postgres enums

**Decision:** `bobgen.yaml` keeps the enums plugin enabled (`destination: internal/database/enums`). The generated enums package is empty because the schema has no `CREATE TYPE … AS ENUM`.

**Why:** The factory plugin imports from the enums package; disabling enums causes `bobgen-psql` to fail with `the enums output needs to be present and enabled`. The empty package is the price of keeping factories. The verification tier remains a CHECK-on-TEXT constraint, not a Postgres ENUM.

**Revisit when:** the schema introduces an actual `CREATE TYPE … AS ENUM` (e.g. tier becomes a real enum), or if Bob makes the enums plugin truly optional.

**Files:** `backend/bobgen.yaml`, `backend/.gitignore`

## Assumption: `bobgen-psql` is pinned via `tools.go`, not `go install ...@latest`

**Decision:** `tools.go` lists `_ "github.com/stephenafamo/bob/gen/bobgen-psql"`; `make models/regenerate` runs it via `go run github.com/stephenafamo/bob/gen/bobgen-psql -c ./bobgen.yaml`, picking up the version from go.mod.

**Why:** CLAUDE.md is explicit: "Tools (govulncheck, staticcheck, goose) are pinned in tools.go + Makefile. Never `go install <tool>@latest`." Same pattern applied to bobgen-psql so its version moves only when go.mod moves.

**Revisit when:** never, unless the policy itself changes. Just keep the pattern when adding the next codegen tool.

**Files:** `backend/tools.go`, `backend/Makefile`, `backend/go.mod`

## Assumption: Bob ORM codegen has run; generated packages live (gitignored) on disk

**Decision:** After the local DB came up (`postgres://gnanakeethan@localhost:5432/veli`), `make migrations/up` then `make models/regenerate` succeeded. The generated tree lives at `internal/database/{models,factory,dbinfo,dberrors,enums}/` and is fully gitignored. `go test ./...` exercises the generated tests cleanly.

**Why:** Recorded for the next contributor. Once codegen has run, every schema change must be followed by `make migrations/up && make models/regenerate` so the generated code stays in sync; CI should fail if `git status` (jj st) is dirty after regenerate.

**Revisit when:** schema changes land. Always regenerate before opening a PR. Also when the repository layer migrates from raw pgx to Bob's typed DSL — that's the moment the generated `models` package starts being imported by hand-written code.

**Files:** `backend/bobgen.yaml`, `backend/Makefile`, `backend/.gitignore`

## Assumption: `golangci-lint` is pinned in the Makefile but not installed

**Decision:** Makefile sets `GOLANGCI_LINT_VERSION := v1.64.5` and `make lint` invokes `golangci-lint run`, but the binary is not installed locally and not pulled in by `tools.go`.

**Why:** `golangci-lint` is the recommended install path per its upstream docs (binary release rather than `go install`), so it stays out of `tools.go`. Result: `make lint` fails until the user runs `go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.64.5` or installs via the project-recommended script.

**Revisit when:** before the first PR review where lint is a gate. Document the install command in `backend/README.md` (when one exists), or add a `make lint/install` target that runs the official installer.

**Files:** `backend/Makefile`, `backend/.golangci.yml`
