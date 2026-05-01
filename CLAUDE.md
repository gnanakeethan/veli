# Veḷi — Project Instructions

வெளி (*Veḷi*, "the open") is a civic-technology platform for Sri Lanka's Northern Province, operated by Cloud Parallax (Pvt) Ltd. The platform serves three product lines, sequenced over five years:

1. **Phase 1** — Government Service Navigation (Tamil-first PWA + IVR/USSD/SMS shortcode)
2. **Phase 2** — Land & Property Documentation (notary-assisted "deed-ready bundles")
3. **Phase 3** — Agricultural Supply Chain Traceability (producer ↔ exporter ↔ diaspora)
4. **Phase 4** — Platform Consolidation (unified civic infrastructure)

The strategic plan is the source of truth. Plan version: **v1.5** (May 2026). The plan compiles from a Typst entrypoint and is split into per-section files under `docs/plan/`. Frozen single-file snapshots are kept under `docs/snapshots/` as `vN.M.typ`.

## Repository layout

```
.
├── veli_implementation_plan.typ   # Typst entrypoint (preamble + title + #include of section files)
├── docs/
│   ├── design-system.typ          # Frontend design system — canonical reference for UI tokens, primitives, patterns
│   ├── plan/                      # Per-section plan files; edit these, not the entrypoint
│   │   ├── _executive_summary.typ
│   │   ├── 01_strategic_context.typ
│   │   ├── 02_phase0_foundations.typ
│   │   ├── 03_phase1_govnav.typ
│   │   ├── 04_phase2_land_docs.typ
│   │   ├── 05_phase3_agri.typ
│   │   ├── 06_phase4_consolidation.typ
│   │   ├── 07_cross_cutting.typ
│   │   ├── 08_organization.typ
│   │   ├── 09_funding.typ
│   │   ├── 10_risk_register.typ
│   │   ├── 11_phase_gates.typ        # Gate criteria + compression options + pre-mortem (NEW in v1.5)
│   │   └── 12_conclusion.typ
│   └── snapshots/
│       ├── v1.3.typ               # Frozen snapshot
│       ├── v1.4.typ               # Frozen snapshot
│       └── v1.5.typ               # Frozen snapshot of v1.5 (current)
├── backend/                       # Go 1.26 single-binary REST API
│   ├── cmd/api/main.go
│   ├── internal/                  # config, domain, handler, middleware, repository, service
│   ├── assets/migrations/         # goose SQL migrations
│   ├── configs/veli.yaml.example
│   ├── Makefile, .air.toml, .golangci.yml, tools.go
│   └── go.mod, go.sum
└── frontend/                      # SvelteKit 2 + Svelte 5 + Tailwind v4 + Capacitor (Android first)
    ├── src/
    │   ├── routes/                # +page, +layout, +server, file-based routing
    │   ├── lib/
    │   │   ├── api/               # Typed REST client (fetch-injected, framework-agnostic)
    │   │   ├── components/ui/     # Design-system primitives — see docs/design-system.typ
    │   │   ├── server/            # Server-only code; never import from a .svelte component
    │   │   └── utils.ts           # cn() helper, prop-stripping types
    │   ├── hooks.ts               # reroute via paraglide deLocalizeUrl
    │   ├── hooks.server.ts        # paraglideMiddleware (locale resolution)
    │   └── app.css                # zinc OKLCH theme tokens
    ├── messages/{en,ta,si}.json   # Paraglide i18n catalogs (Tamil first)
    ├── project.inlang/settings.json
    ├── capacitor.config.ts        # appId lk.cloudparallax.veli
    └── svelte.config.js           # @sveltejs/adapter-node
```

## Stack (alignment with the plan)

- **Backend** Go 1.26 + chi v5 + pgx/v5 + Bob ORM (DB-first codegen) + goose migrations + zap. Module: `github.com/cloudparallax/veli`. Self-hosted Go services on Kubernetes at the Tier III colocation site (per §2 architecture spec).
- **Frontend (smartphone surface)** SvelteKit 2 + Svelte 5 runes + Tailwind v4 + shadcn-svelte + Paraglide JS, deployed as a Tamil-first **Progressive Web App** with service-worker offline caching. `adapter-node` for SSR; Capacitor wraps the same build as a native Android app where install conversion justifies it (per §3 Phase 1 product definition). The PWA is the only surface that supports document upload, GPS capture, witness-statement signing, and lot creation.
- **Frontend (feature-phone surface)** Tamil-language **IVR + USSD + SMS short code** delivered via **Ideamart by Dialog Axiata** (Cloud Parallax already holds an active Ideamart developer account; Phase 0 only needs new shortcode + USSD code allocation) and **hSenid Mobile** multi-operator APIs (Dialog, Mobitel, Hutch). hSenid is treated as a PDPA data processor under a written processing agreement. Read-only for Phase 1 procedure information; sensitive flows stay PWA-only. **No WhatsApp, no third-party messaging intermediary.**
- **IVR voice prompts** Generated with **Amazon Polly Neural TTS** + a maintained **Jaffna Tamil pronunciation lexicon** (SSML `<phoneme>` overrides in IPA / x-sampa) so the spoken register matches Northern Province colloquial Tamil rather than Polly's default Indian Tamil. The lexicon is a first-class content artifact owned by the Tamil content lead, reviewed by Northern Province natives, and versioned alongside procedure content. Prompts are pre-rendered offline as 8 kHz mu-law audio files, hashed by content + lexicon version, and cached in self-hosted object storage. **Polly is an offline content-authoring tool only — no user data flows to AWS at call time.**
- **Database** PostgreSQL 16 with streaming replication; HA across two Sri Lankan colocation sites. Object storage on-premises (Ceph or MinIO). All primary data in Sri Lanka; encrypted offsite backup at the secondary in-country site. Tertiary encrypted backup outside Sri Lanka is permitted only with a documented PDPA §26 instrument and only for disaster recovery.
- **VCS** Jujutsu (`jj git init` at root). Use the `jj` skill for any version-control task — never raw `git`.
- **Hosting** Self-hosted on Sri Lanka–located Tier III colocation infrastructure (Dialog IDC, SLT IDC, Hayleys Solar Power IDC, or equivalent). Two physically separated in-country sites. **AWS, GCP, and Azure are excluded from the primary path.** Cloudflare for edge-only services (DNS / CDN / DDoS) is fine because edge holds no primary state.

## Documentation format

All docs are **Typst (`.typ`)**, never Markdown. Use the `typst-creator` skill if you need a syntax refresher. CLAUDE.md is the only Markdown the repo carries.

Compile the plan with `typst compile veli_implementation_plan.typ` (output: `veli_implementation_plan.pdf`).

## Plan editing protocol

The strategic plan is multi-file by design so different topics evolve independently:

1. **Edit per-section files** in `docs/plan/NN_<topic>.typ`. Don't edit `veli_implementation_plan.typ` (the entrypoint) unless adding a new section, removing one, or changing global page setup.
2. **Don't edit files in `docs/snapshots/`** — they are frozen single-file references. New revisions go through the multi-file structure; each new vN.M release gets its own snapshot dropped in alongside.
3. **Add new sections** by creating `docs/plan/NN_<topic>.typ` and adding an `#include` line in `veli_implementation_plan.typ`.
4. The plan does **not** use inline `[GAP]` callouts. Open items are denoted in prose where they appear (e.g. "Decision to be made in Phase 0"). Don't reintroduce the gap-callout style.

## Backend conventions

- Layering: `domain/` (interfaces only, no internal imports) → `repository/` → `service/` → `handler/`. `cmd/api/main.go` wires them.
- Errors are wrapped with context (`fmt.Errorf("...: %w", err)`); never `fmt.Println` or `log.Print` — use `zap`.
- Migrations are append-only goose files in `assets/migrations/`. Never edit a merged migration; add a new one.
- Bob ORM models are generated; `internal/database/{models,factory,dbinfo,dberrors}/` are gitignored. Regenerate via `make models/regenerate` when schema changes.
- Tools (`govulncheck`, `staticcheck`, `goose`) are pinned in `tools.go` + Makefile. Never `go install <tool>@latest`.
- Run after any Go change: `make tidy && go vet ./... && make lint`.

## Frontend conventions

- Svelte 5 runes only (`$state`, `$derived`, `$effect`, `$props`). No legacy stores.
- Tamil is the primary user-facing locale; the dialect target is **colloquial Jaffna Tamil**, not literary Tamil and not Indian Tamil. English and Sinhala are secondary surfaces.
- Author Tamil first; never translate Tamil from English in user-facing copy.
- The PWA is built mobile-first for low-end Android (Chrome/WebView). Service worker caches the active session and procedure content for offline use.
- Tailwind v4 zinc OKLCH theme is in `src/app.css` — use theme tokens (`bg-background`, `text-foreground`, `text-primary`, etc.), not hex colors.
- Server-only code lives in `src/lib/server/`. Never import from `$lib/server/` in a `.svelte` component.
- API calls go through `+page.server.ts` `load()` using the typed client at `$lib/api`. Never `fetch()` the backend directly from a `.svelte` component.
- Run after any Svelte change: `pnpm check && pnpm build`. Paraglide files (`src/lib/paraglide/`) are generated at build — gitignored.
- **No third-party messaging integration** (no WhatsApp, no Telegram, no Discord). The plan deliberately routes only through the PWA, the Veḷi-controlled IVR/USSD/SMS surfaces, and the trained-helper telephone hotline.

## Frontend design system

The canonical reference is `docs/design-system.typ` — read it before adding any UI. It defines the colour, typography, spacing, and radius tokens, the component catalogue, the page-shell pattern, the three-tier verification visual contract (with normative dual-language tier labels), the accessibility checklist, and the i18n authoring rules.

The implementation lives at `frontend/src/lib/components/ui/`. Available primitives:

| Primitive | Purpose |
|---|---|
| `Button` | Variants `primary`/`secondary`/`ghost`/`destructive`; sizes `sm`/`md`/`lg`. 44 px min touch target at `md`. |
| `Card` + `CardHeader` + `CardContent` + `CardFooter` | Composable surface. The phase cards on the landing page are the canonical example. |
| `Badge` | Inline pill for short generic state. |
| `TierBadge` | Specialised pill for the three verification tiers — always renders **both** EN and TA labels, with visual hierarchy reflecting legal effect. Never substitute or invent tiers. |
| `StatusStrip` | Thin bar reporting backend reachability + phase number. |
| `LocaleSwitcher` | Three-button group calling Paraglide `setLocale`. Mounted in the layout. |

Rules of engagement:

- **Reach for the primitive first.** Before writing `class="rounded-lg border bg-card p-6 ..."` for a card-shaped thing, use `<Card>`. Same for buttons, badges, status indicators.
- **Compose classes with `cn(...)` from `$lib/utils`** — never string-concatenate Tailwind classes.
- **Tier labels are normative.** Use `<TierBadge tier="self_asserted" />` etc. with the exact tier values; do not paraphrase the labels rendered inside.
- **Update `docs/design-system.typ` when the system changes** — the doc is the source of truth, the components implement it. If they drift, the doc wins and the components get fixed.
- **Tamil-first authoring** for every string (including `aria-label`); add to all three of `messages/{en,ta,si}.json`.

Compile the doc with `typst compile docs/design-system.typ` (output: `docs/design-system.pdf`).

## Three-tier verification model

Every document, statement, or piece of evidence in the platform carries an explicit tier (per Phase 0 architecture spec, Phase 2 verification model):

| Tier | Meaning | Legal effect |
|---|---|---|
| `self_asserted` | The user uploaded it. Platform records who/when/where. | None |
| `community_corroborated` | Two or more named community members signed a witness statement. | None — supports later notarisation |
| `authority_attested` | Notary public (per Notaries Ordinance, Prevention of Frauds Ordinance), lawyer, or government office. | Yes |

Tier is shown to the user in both English and Tamil on every surface. The platform never inflates a self-asserted or community-corroborated document into something it is not.

## Testing

- **Go**: `make test` (race detector on). Integration tests require Postgres — `make migrations/up` first.
- **Svelte**: `pnpm test:unit` (Vitest).

## What this codebase does NOT have (and we do not pretend it does)

- No CI pipeline. No production deployment. No real users.
- No named NGO partner, no named diaspora foundation, no named legal/academic partner. Phase 0 work. (Per v1.5 §2, the legal-partner panel must include practitioners with active **Thesawalamai** practice — Northern Province family inheritance and property arrangements are governed by Thesawalamai customary law, not Roman-Dutch general law alone.)
- No hosting contract. No colocation site selected. No hardware procured (Phase 0 hardware CAPEX line: ~LKR 8–15M / USD 25–50k for redundant two-site PostgreSQL + Ceph baseline).
- Ideamart developer account exists (Cloud Parallax holds it from prior work), but no Veḷi-specific shortcode/USSD code allocated yet; no hSenid Mobile commercial agreement.
- No AWS account with Polly access provisioned; no Jaffna Tamil pronunciation lexicon drafted; no IVR audio rendered.
- No DPO appointed, no PDPA registration, no DPIA performed.
- No corporate form decision (Veḷi Foundation vs. Cloud Parallax operating division — see plan §8).
- No data trust deed, no successor institution named.
- No demand-side baseline survey conducted.

The plan's deliverables list (`docs/plan/02_phase0_foundations.typ`) is the canonical Phase 0 to-do.

## What Claude should always do

- Use `jj` for VCS, never `git`.
- Use Typst (`.typ`) for new docs, never Markdown (except CLAUDE.md).
- When the plan names a Sri Lankan statute (PDPA No. 9 of 2022 as amended by Act No. 22 of 2025; Online Safety Act No. 9 of 2024; Notaries Ordinance; Prevention of Frauds Ordinance No. 7 of 1840 §2; Companies Act No. 7 of 2007; Title Registration Act No. 21 of 1998; Trusts Ordinance; Financial Transactions Reporting Act No. 6 of 2006; Foreign Exchange Act), preserve the citation exactly. Do not paraphrase or modernize.
- Match the plan's measured, executable voice — no marketing language.
- Preserve the three-tier verification labels exactly: `self_asserted`, `community_corroborated`, `authority_attested`. Do not revert to earlier draft names like `community_witnessed` or `authority_verified`.
- Use v1.5 team-size figures (five to seven through Phase 0 / early Phase 1; fourteen to seventeen by end of Phase 2; thirty to forty by end of Phase 3). Earlier drafts of this plan understated team size; do not revert to those numbers.
- Treat the Identity Recovery Protocol (`docs/plan/07_cross_cutting.typ` §Identity Recovery Protocol) and the Trained-Helper Programme (same file §Trained-Helper Programme) as **first-class protocol specs**, not Phase 0 deliverables to be sketched later. They are normative and any product change must conform.
- Treat `docs/plan/11_phase_gates.typ` as binding: the gate criteria are go/no-go decisions for each phase boundary, and the two compression options (two-product variant, sequenced-only variant) are pre-approved fallbacks. Choosing one of them at a gate is a normal outcome, not a failure mode.
- Wrap Go errors with context; never silence them.
- Keep Tamil colloquial Jaffna register for user-facing copy.
- For any new frontend UI, consult `docs/design-system.typ` and the primitives at `frontend/src/lib/components/ui/` before writing raw Tailwind. Add to the design system rather than around it.

## What Claude should never do

- Suggest AWS, GCP, or Azure for primary infrastructure. (One narrow exception, called out in the plan: Amazon Polly is permitted for **offline** Tamil IVR prompt rendering, governed by a documented PDPA §26 instrument; Polly never sees user data and never serves audio at call time.)
- Suggest WhatsApp, Telegram, Signal, or any third-party messaging service. The plan deliberately excludes these in favour of PWA + Veḷi-controlled IVR/USSD/SMS.
- Translate Tamil from English machine-translation; commission proper localization.
- Commit `.env`, `.claude/settings.local.json`, or anything under `secrets/`.
- Bypass the procedural-rigour discipline in `docs/plan/07_cross_cutting.typ`. If you find yourself wanting to take a position on a contested matter, write a recusal statement instead.
- Reintroduce the `#gap()` callout style — v1.3 deliberately handles open items in prose.
- Promise that any Veḷi-produced bundle has legal force unless it is `authority_attested`. Tier labelling is a hard architectural constraint.
- Add a feature, vendor, or partner without a corresponding plan-section update.
