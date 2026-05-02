// Veḷi — Frontend Design System (v0.3)
// Canonical reference for the SvelteKit frontend: tokens, principles,
// components, patterns, and authoring rules. This file is the source
// of truth. The components under frontend/src/lib/components/ui/ are
// the implementation; CLAUDE.md points contributors here first.
//
// Compile: typst compile docs/design-system.typ
//
// Versions:
// v0.1 — zinc OKLCH, shadcn-svelte default. Superseded.
// v0.2 (2026-05-01) — civic palette, utilitarian aesthetic from the
//                     first claude.ai/design handoff bundle.
// v0.3 (2026-05-02) — adds motion tokens (5 easings + 5 durations),
//                     state-card / steps / stats / timeline /
//                     sync-queue primitives, and the supporting
//                     guidance sections (motion, states, forms,
//                     data, accessibility).

#set document(
  title: "Veḷi — Frontend Design System",
  author: "Cloud Parallax (Pvt) Ltd",
)

#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  numbering: "1",
  number-align: center,
)

#set text(
  font: ("Libertinus Serif", "New Computer Modern"),
  size: 10.5pt,
  lang: "en",
)

#set par(justify: true, leading: 0.65em, spacing: 1.1em)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => {
  set text(size: 18pt, weight: "bold")
  block(above: 0.6em, below: 0.8em, it)
}
#show heading.where(level: 2): set text(size: 13pt, weight: "bold")
#show heading.where(level: 3): set text(size: 11pt, weight: "bold", style: "italic")
#show heading: set block(above: 1.2em, below: 0.6em)
#show raw: set text(font: "DejaVu Sans Mono", size: 9pt)

#align(center)[
  #text(20pt, weight: "bold")[Veḷi — Frontend Design System]
  #v(0.3em)
  #text(10pt, fill: gray)[Cloud Parallax (Pvt) Ltd · v0.3 · 2026-05-02]
]

#v(1em)

= Purpose

Canonical reference for visual and interaction patterns used in the
Veḷi smartphone surface (Tamil-first PWA, Android wrap via Capacitor).
Read before adding any UI. Pages reach for the primitives defined here
rather than inline raw Tailwind classes for things the primitives
already cover.

This is v0.2 — a civic-utilitarian system that replaces the prior
shadcn-svelte zinc base. The shift was driven by a design exploration
on `claude.ai/design`; the chosen aesthetic is "modern utilitarian /
government-grade", calibrated for rural Northern Province households
on mid-range Android.

= Four commitments

These are non-negotiable. Every design decision is judged against them.

#table(
  columns: (1fr, 1.2fr, 2.4fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Tamil*], [*English*], [*Detail*]),
  [தமிழ் முதன்மை], [Tamil-first], [Designed in Tamil. English follows when it must, never as default. Display register: colloquial Jaffna Tamil, never literary, never Indian Tamil.],
  [நம்பிக்கை], [Trust by citation], [Every claim links back to a government source or an audit trail. The platform never inflates a self-asserted artefact into something it is not.],
  [குறை வளம்], [Low-bandwidth], [Works on a Rs. 18,000 Android with one bar of signal — or no signal at all. Service-worker offline cache is part of the contract.],
  [மதிப்பு], [Dignified], [No condescension. Big targets, plain words, real receipts. No marketing language; no decorative SVGs.],
)

= Tokens

== Colour palette

Three theme variants share the same token names; only the values
change. The default theme is *civic*; *paper* is a warmer alternate;
*ink* is the dark variant. Set on `<html>` via `data-theme`.

#table(
  columns: (1fr, 1.4fr, 2.4fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Token*], [*Civic value*], [*Use*]),
  [`--paper`],     [#raw("#FFFFFF")], [Card surface.],
  [`--paper-2`],   [#raw("#F7F4EE")], [Page background — warm off-white.],
  [`--paper-3`],   [#raw("#EFEAE0")], [Inset / chip / panel.],
  [`--rule`],      [#raw("#DCD5C7")], [Hairline borders, dividers.],
  [`--ink`],       [#raw("#14140F")], [Primary text. 17.8:1 against `--paper-2` (AAA).],
  [`--ink-2`],     [#raw("#3B3A33")], [Secondary text.],
  [`--ink-3`],     [#raw("#6B6859")], [Metadata, captions.],
  [`--primary`],   [#raw("#0E4D3F")], [Civic green. CTAs, OK status, primary actions. 11.2:1 (AAA).],
  [`--accent`],    [#raw("#D9A441")], [Saffron-gold. Verification, official seals, hero dot. 3.1:1 (AA-large).],
  [`--alert`],     [#raw("#A6363D")], [Deep red. Alerts, destructive actions, rejected. 6.8:1 (AAA).],
  [`--info`],      [#raw("#2B4A6B")], [Ink slate. Information, secondary status. 9.4:1 (AAA).],
)

Each non-neutral colour has a `-soft` companion (light tint, used as
badge background) and an `-ink` companion (dark variant, used as
badge text). Example: `--accent-soft: #F8EDD3`, `--accent-ink: #6B4F14`.

The full token set (including `--rule-strong`, `--ink-mute`,
`--primary-soft`, `--primary-ink`, `--alert-soft`, `--alert-ink`,
`--info-soft`) is declared in `frontend/src/app.css`. Tailwind v4
`@theme inline` exposes them as utility tokens (`bg-paper-2`,
`text-ink-3`, `bg-accent-soft`, etc.).

*Rule:* never hex-code colours in templates. Always use the token,
either as a CSS variable (`color: var(--ink)`) or a Tailwind utility
(`text-ink`).

== Typography

Three font families, each with a clear role:

#table(
  columns: (1fr, 2fr, 2.6fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Family*], [*Token*], [*Used for*]),
  [Noto Sans Tamil], [`--f-tamil`], [Body, headings, all user-facing copy. Primary face. Weights 300–800.],
  [Inter], [`--f-latin`], [Latin numerals, English transliterations, EN sub-labels.],
  [JetBrains Mono], [`--f-mono`], [Section tags, metadata captions, IDs, receipts, SMS bodies, technical labels. Conveys "auditable / transparent".],
)

Type scale (display → caption):

#table(
  columns: (1fr, 1fr, 1fr, 2fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: (left, right, right, left),
  table.header([*Role*], [*Size*], [*Weight*], [*Use*]),
  [Display],     [72px], [700], [Hero only. The "வெளி." mark on the landing page.],
  [Heading 1],   [36px], [600], [Page titles. Section titles in the design-system page.],
  [Heading 2],   [24px], [600], [Card titles, sub-section headings.],
  [Title],       [18px], [600], [In-card titles, list-row titles.],
  [Body],        [16px], [400], [Default copy.],
  [Caption],     [13px], [500], [Helper text, hints, errors.],
  [Mono · meta], [11px], [500], [Section tags, metadata, IDs, technical labels.],
)

== Spacing and radius

Spacing scale (for components and layout): xs 4 · sm 8 · md 14 ·
lg 20 · xl 32 · 2xl 48 · 3xl 72. Density is variable: `data-density`
on `<html>` toggles compact / regular / comfy, which scales the row
heights and paddings of list rows and similar components.

Radius scale: xs 4 · sm 6 · md 10 · lg 14 · xl 20 · pill 999. Cards
use `--r-md`; pills use `--r-pill`; inputs use `--r-sm`; large CTAs
use `--r-md`.

== Elevation

Three shadow tiers, very restrained — paper-feeling, never floating.
`--sh-1` is a hairline. `--sh-2` adds a 1px y-offset. `--sh-3` is the
raised state for popovers. Avoid heavier shadows.

== Motion

Civic interfaces should not vibrate or shimmer. Motion is reserved
for status changes, verification feedback, and transitions the user
explicitly asked for. Five easings and five durations cover everything;
*never* hard-code a cubic-bezier or a millisecond literal.

#table(
  columns: (1fr, 2fr, 2fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Easing*], [*Curve*], [*Use*]),
  [`--ease-standard`], [`cubic-bezier(.4,0,.2,1)`],     [Default — between two known places.],
  [`--ease-entrance`], [`cubic-bezier(0,0,.2,1)`],      [Things arriving · acknowledgements.],
  [`--ease-exit`],     [`cubic-bezier(.4,0,1,1)`],      [Things leaving · dismissals.],
  [`--ease-linear`],   [`linear`],                       [Loading · indeterminate progress.],
  [`--ease-spring`],   [`cubic-bezier(.34,1.56,.64,1)`],[Receipts · success seal · saffron stamp.],
)

#table(
  columns: (1fr, 1fr, 2fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: (left, right, left),
  table.header([*Duration*], [*ms*], [*Use*]),
  [`--dur-instant`],  [80],   [Micro feedback · press.],
  [`--dur-fast`],     [140],  [Tooltip · chip selection.],
  [`--dur-base`],     [220],  [Most transitions.],
  [`--dur-slow`],     [360],  [Sheets · drawers · pages.],
  [`--dur-ceremony`], [680],  [Verification seal · receipt fold.],
)

`prefers-reduced-motion: reduce` collapses every duration to ~1ms
(easings stay intact) and disables the skeleton shimmer + sync
spinner animations. Critical state changes never depend on motion
alone — every animated state has a static affordance.

= Components

Every primitive lives at `frontend/src/lib/components/ui/<Name>.svelte`
and is re-exported from the barrel `frontend/src/lib/components/ui/index.ts`.
Pages import the primitive, never the underlying CSS classes when a
primitive applies.

#table(
  columns: (1.4fr, 3.2fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Primitive*], [*Purpose*]),
  [`Button`], [Variants `primary` / `secondary` / `ghost` / `alert`; sizes `sm` / `md` / `lg`; `block`. 48 px min height (≥ 44 WCAG) at `md`. Composes the `.btn` class family.],
  [`Card` + `CardHeader` + `CardContent` + `CardFooter`], [Raised paper surface with hairline border, optional header / content / footer. Composes `.card`.],
  [`Badge`], [Inline pill for short generic state. Variants `primary` / `accent` / `alert` / `info` / `mute`. Optional dot.],
  [`TierBadge`], [Three-tier verification visual. Always renders *both* the EN and TA tier labels — never one without the other. Visual hierarchy follows legal effect: `self_asserted` → bronze, `community_corroborated` → silver, `authority_attested` → gold.],
  [`StatusStrip`], [Thin bar reporting backend reachability and phase number. Civic green when reachable; alert-soft when unreachable.],
  [`LocaleSwitcher`], [Three-button segmented control (`தமிழ் / English / සිංහල`) calling Paraglide `setLocale`. Composes `.seg`.],
  [`Field`], [Label + input + (hint or error) wrapper. The `<input>`/`<select>`/`<textarea>` is supplied by the consumer with `class="field-input"`.],
  [`LRow`], [The workhorse list row. Optional leading icon, title, meta, optional EN sub-label, optional trail (snippet). Used for procedure lists, document evidence, buyer offers, user fields.],
  [`Icon`], [Line icon (lucide-svelte under the hood). 24 px viewBox, 1.6 px stroke, `currentColor`. Filled variant available via `filled` prop.],
  [`OfflinePill`], [Saffron pill that reads "இணையமில்லை · OFFLINE". Always-visible signal when the service worker is serving cached content.],
  [`Progress`], [Slim progress bar in civic green on a paper-3 track. Used for evidence completeness, sync progress.],
  [`Segmented`], [Generic segmented-control primitive (the same `.seg` used by `LocaleSwitcher`).],
  [`Trust`], [Citation card. Mark + title + body + optional `↳ cite`. Used wherever a claim points to a government source or audit trail.],
  [`Receipt`], [Confirmation receipt with mono header, line items, and a centred receipt number. Designed to survive screenshots and printers.],
  [`SMS`], [Terminal-style SMS preview for the IVR/USSD/SMS fallback surface previews.],
  [`Phone`], [Mobile mockup frame for product-preview compositions in the docs.],
  [`Steps`], [Multi-step form indicator. 4–6 steps; each step has one decision. `done` / `active` / pending visual states; consumers pass `{ ta, en }` per step.],
  [`StateCard`], [Empty / loading / error card with localized title + body and an optional footer snippet for an action button. The skeleton lines for loading state are passed in via children, not baked in.],
  [`Skeleton`], [Shimmer placeholder. `lines={n}` renders n staggered text-row skeletons; otherwise a single `width × height` block. Animation respects `prefers-reduced-motion`.],
  [`Stats` + `Stat`], [Counter grid for dashboards. Each `Stat` carries a value, optional inline unit, Tamil label, and optional English sub-label. 4-column on desktop, 2-column on mobile.],
  [`Timeline` + `TimelineRow`], [Vertical status timeline. Each row has a mono time, a dot (`done` / `active` / `fail` / `pending`), a Tamil title, and an optional desc.],
  [`SyncQueue` + `SyncRow`], [Offline sync queue display. Header with localized title + signal indicator; rows carry one of four states (queued / running / ok / error) with the appropriate glyph and animation.],
)

== TierBadge contract

The three tiers are normative. Their values, English labels, Tamil
labels, and visual treatment are listed below. Never substitute,
paraphrase, or invent a fourth.

#table(
  columns: (1.6fr, 1.4fr, 1.6fr, 1.6fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Tier value*], [*EN*], [*TA*], [*Visual*]),
  [`self_asserted`], [Self-asserted], [சுய அறிவிப்பு], [Bronze (`tier-bronze`) — visibly lowest-effort.],
  [`community_corroborated`], [Community-corroborated], [சமூக சாட்சியம்], [Silver (`tier-silver`) — neutral, no claim of legal effect.],
  [`authority_attested`], [Authority-attested], [அதிகாரப்பூர்வ உறுதி], [Gold (`tier-gold`) — saffron-soft tones, used only when the tier carries legal effect.],
)

The dual-language label is the architectural contract from
`docs/plan/02_phase0_foundations.typ`. A surface that needs to express
a *derived* state (e.g. "expired attestation") does so with a separate
adjacent badge — never by changing the tier label.

= Patterns

== Hero

The landing page uses the giant Tamil wordmark with a saffron dot
accent: `<h1 class="hero-mark">வெளி<span class="dot">.</span></h1>`.
`clamp(72px, 12vw, 168px)` so it scales from phone to desktop.
Bilingual metadata (`<dl class="hero-meta">`) sits beside or below
the mark with `dt` in mono uppercase and `dd` in body.

== Page shell

Every page wraps content in:

#raw("<div class=\"flex min-h-screen flex-col bg-background text-foreground\">
  <main class=\"mx-auto w-full max-w-2xl px-6 py-12\">
    <!-- page body -->
  </main>
</div>")

Landing widens to `max-w-5xl`. User detail uses `max-w-2xl`. Avoid
full-bleed on phones.

== Section header

#raw("<div class=\"sec-tag\">06 · கூறுகள் / Components</div>
<h2 class=\"text-[36px] font-semibold leading-tight tracking-tight\">…</h2>
<p class=\"text-ink-2 max-w-[64ch]\">…</p>")

The mono section tag with the civic-green dot is the recurring section
marker. Use bilingual `NN · தமிழ் / English` form when the section
has a Tamil concept name.

== List of properties

`LRow` rows inside a `Card` are the canonical way to display record
fields (user details, document metadata, agricultural batch detail).
Lead icon (40 px tile, paper-3 background) + title + meta + optional
trail. Don't use `<dl>` for record displays in v0.2 — `LRow` is the
dignified pattern.

== Trust / citation

Civic claims that come from a government source render as a `Trust`
component (when added — currently in the design-system catalogue but
not yet a primitive in this codebase). Until it lands, follow the
markup directly: `.trust` wrapper + `.trust-mark` (32 px primary
circle with shield icon) + title + body + `.trust-cite` (mono caption
prefixed with `↳`). Cite the source URL or the in-platform
audit-trail reference, never an unverifiable claim.

== Receipt

Confirmation numbers and submission receipts use the `Receipt`
component (CSS class `.receipt`). Mono font, dashed top/bottom
borders, the receipt-num as the centred final line. The user can
screenshot it; SMS fallback delivers the same number.

== SMS / USSD fallback

When bandwidth dies, surfaces fall back to SMS over the Veḷi-controlled
shortcode (Ideamart). The `SMS` component shows the message as it
will appear on a feature phone. Mono everywhere; preserves whitespace.

== Form inputs

Every input is wrapped in a `Field` primitive: label above (never
placeholder-only), `.field-input` for the control (full-width on
mobile, 48 px tall, 1.5 px border), helper text below in `.field-help`,
errors in `.field-error` (with the auto-rendered `!` icon). Required
fields show a red `*` in the label.

== Empty + error states

Localised, never English-only. Prefer the `StateCard` primitive over
a generic `Card` for empty / loading / error states:

#raw("<StateCard kind=\"empty\" title={m.user_not_found_title()}
                 body={m.user_not_found_body()}>
  {#snippet children()}<Button kind=\"primary\" size=\"sm\">…</Button>{/snippet}
</StateCard>")

Loading state shows skeleton lines via `<Skeleton lines={3} />` —
they should match the real layout that's loading, never generic
spinners. Errors *name the office* and offer a concrete next step
("Call 0212 222 555" or "Try again in 10 minutes"), never a stack
trace and never a generic "something went wrong". Never expose raw
backend error envelopes to the user; log them.

== Multi-step forms

Long government forms split across 4–6 screens, one decision per
screen. Use the `Steps` primitive at the top to show progress;
`active` is the current 0-based index. Each step has a Tamil
`ta` label and an optional `en` sub-line in mono.

Local-first storage is the contract: every step's data persists to
IndexedDB before the network is touched. The `SyncQueue` primitive
shows the user what's pending: queued (`q`), uploading (`r`), ok
(`k`), or errored (`e`). The queue is editable — users can cancel
or retry rows.

== Status timelines

Every government action gets a `Timeline` view. Citizens can
subscribe to a request and see exactly which row is `active`. Past
rows are `done` (civic green); failed steps are `fail` (alert red);
future rows stay `pending` (default ring). Each row carries a mono
time/relative-time on the left, a dot in the centre rail, and the
Tamil title plus optional EN/meta description on the right.

= Accessibility

A floor, not a ceiling. Six load-bearing rules; if a control fails
any of them, it does not ship.

#table(
  columns: (1fr, 3fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Rule*], [*Detail*]),
  [Contrast], [Every text-on-background pair tested at 4.5:1 (body) or 3.0:1 (≥ 24px or 16px-bold). Civic green on paper hits 11.2:1. Saffron is reserved for ≥ 24px or 16px-bold — *never* small body text. Dark mode swaps softs and inks together.],
  [Targets], [No tap target below 48×48 dp. Spacing tokens enforce this — buttons (48 px at `md`), list rows (`--d-row-h: 56px`), and chips inherit a minimum height. Mid-range Android, sweat-on-glass, harvest gloves.],
  [Input], [No keyboard traps. IME-aware Tamil entry. Every form supports Tamil phonetic, English, and bilingual modes. Tab order matches reading order. Submit-on-enter is opt-in only.],
  [Motion], [`prefers-reduced-motion: reduce` is respected end-to-end. Saffron seal stamps, sheet animations, and skeleton shimmers fall back to instant cross-fades. Critical state changes never depend on motion alone.],
  [Audio], [Critical confirmations carry an *optional* Tamil voice line plus a single haptic pulse (`navigator.vibrate(40)`). Off by default in noisy/quiet zones. `aria-live="polite"` for status updates.],
  [Literacy], [Plain Tamil. Every step in a government flow has a recorded (not synthetic) voice-over button. Forms never depend on a citizen reading anything longer than 8 words.],
)

Implementation specifics:
- *Focus rings* never disable. The `--ring` token is `--primary`; a
  2 px ring at 2 px offset is the default focus halo.
- *aria-label* every interactive control needs one, *and it must be
  localised through Paraglide*. Never hard-code English.
- *Language tag* `<html lang>` is set by Paraglide via the
  `%paraglide.lang%` placeholder. Don't override.

= Internationalisation

- *Tamil first.* Author the Tamil string before any other language.
  Never machine-translate Tamil from English in user-facing copy.
- *Register.* Northern Province colloquial (Jaffna). Native review
  is in the loop and authoritative.
- *Catalogue.* All keys in `frontend/messages/{en,ta,si}.json`, one
  key per UI string. Pluralisation and parameter substitution use
  Paraglide's parameter syntax — no string concatenation across keys.
- *Numerals.* Use European numerals (0–9) by default; Tamil numerals
  only when explicitly requested by content.

= Voice and copy

Civic interfaces fail when they sound like government. Veḷi writes
the way a careful neighbour would explain something: short
sentences, real numbers, no jargon. Every error names the next
action.

Sample tone (write / avoid):

#table(
  columns: (1fr, 2fr, 2fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Context*], [*Write*], [*Avoid*]),
  [Confirmation], [பிறப்பு சான்றிதழ் தயாராகி உள்ளது.\ #text(fill: gray)[Your birth certificate is ready.]], [Your requested document has been successfully processed.],
  [Error], [இந்தத் தொலைபேசி எண் வேறொருவரால் பயன்படுத்தப்படுகிறது. சரிசெய்ய அலுவலகத்தை அழைக்கவும் — 0212 222 555.\ #text(fill: gray)[That number is already in use. Call the office to fix it — 0212 222 555.]], [Error 0x4F2: Invalid input.],
  [Wait], [அலுவலர் இப்போது பார்க்கிறார். வழக்கமாக இது 2 நாட்கள் ஆகும்.\ #text(fill: gray)[An officer is reviewing this now. It usually takes 2 days.]], [Your request is queued.],
  [Empty], [இங்கே இன்னும் எதுவும் இல்லை. முதல் நிலத்தைச் சேர்க்கவும்.\ #text(fill: gray)[Nothing here yet. Add your first land.]], [No record found.],
)

Lexicon — words we standardise across every product:

#table(
  columns: (1fr, 1fr, 1fr, 2fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Concept*], [*Tamil*], [*English fallback*], [*Note*]),
  [Submit], [சமர்ப்பிக்க], [Submit], [Not "Send" — submission implies record.],
  [Verify], [சரிபார்], [Verify], [Pairs with the saffron seal.],
  [Officer], [அலுவலர்], [Officer], [Always name the office, not "the system".],
  [Receipt], [பெறுசீட்டு], [Receipt], [Mandatory after every action that costs money or creates a record.],
  [Pending], [நிலுவையில்], [Pending], [Always pair with the working-day count.],
  [Sync], [பதிவேற்று], [Upload], [Tamil avoids "sync" — frame as "upload when signal returns".],
)

= Mobile-first defaults

- Default breakpoints follow Tailwind: `sm` 640 px, `md` 768 px,
  `lg` 1024 px. The smartphone surface targets `< sm`; widen up
  from there.
- Never assume hover. Every interactive state must work on touch.
- Service worker caches the active session; pages render meaningful
  content with cached data plus a small banner when offline. Avoid
  spinner-only offline states.
- Capacitor Android wrap: status-bar colour is `bg-paper-2`; splash
  hidden on layout mount.

= Code conventions

- *Svelte 5 runes only.* `$state`, `$derived`, `$effect`, `$props`.
- *Server-only* code lives in `src/lib/server/`. Never import in a
  `.svelte` component.
- *API calls* go through `+page.server.ts` `load()` (or form actions),
  using the typed client at `$lib/api`. Never direct browser fetch.
- *Primitive imports.* Reach for `$lib/components/ui/<Name>.svelte`
  before writing raw Tailwind for buttons, cards, badges, list rows,
  tier badges, status strips, fields, locale switchers, segmented
  controls, progress bars, offline pills, or icons.
- *cn() helper.* Compose classes with `cn(...)` from `$lib/utils`.
- *Props.* Type with TypeScript `interface`s; default values via
  destructuring at the `$props()` site.
- *No inline `<style>`* unless scoped and unavoidable. Tailwind
  utilities first; CSS classes from `app.css` for composed components;
  CSS variables when a token is needed.

= Boundaries

This design system covers the smartphone surface (PWA + Capacitor
Android wrap). It does *not* cover:

- The IVR / USSD / SMS surfaces (governed by Tamil voice-prompt
  authoring rules, see strategic plan §Phase 0 architecture).
- Internal admin or back-office tooling (out of scope for v1.x).
- Print or PDF artefacts (deed-ready bundles in Phase 2 use a
  separate Typst template).

When in doubt, defer to `CLAUDE.md` for project-wide rules and the
strategic plan in `docs/plan/` for product policy.
