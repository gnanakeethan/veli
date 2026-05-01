// Veḷi — Frontend Design System
// Canonical reference for the SvelteKit frontend: tokens, components,
// patterns, and authoring rules. Update this file when the system
// changes; the components under frontend/src/lib/components/ui/ are
// the implementation, and CLAUDE.md points contributors here first.
//
// Build with: typst compile docs/design-system.typ

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
  #text(10pt, fill: gray)[Cloud Parallax (Pvt) Ltd · v0.1 · 2026-05-01]
]

#v(1em)

= Purpose and audience

This document is the canonical reference for visual and interaction
patterns used in the Veḷi smartphone surface (Tamil-first PWA, Android
wrap via Capacitor). It is read by every contributor adding a page or
component, and it is binding: pages must reach for the primitives
defined here rather than inline raw Tailwind classes for things the
primitives already cover.

Veḷi is operated by Cloud Parallax (Pvt) Ltd for users in Sri Lanka's
Northern Province. Three constraints shape every decision:

- *Tamil first.* The display register is colloquial Jaffna Tamil, not
  literary Tamil and not Indian Tamil. Tamil messages are authored
  first; English and Sinhala follow as translations.
- *Mobile first, low-end Android.* The PWA targets intermittent 3G,
  modest CPUs, and small screens. Touch targets must be reachable
  one-handed; transitions must not be the only signal.
- *Honest tier labelling.* Every document or claim shows its
  verification tier explicitly in both English and Tamil. The
  platform never inflates a self-asserted artifact into something it
  is not. The tier values `self_asserted`, `community_corroborated`,
  `authority_attested` are normative and never paraphrased.

= Tokens

== Colour

The base palette is the shadcn-svelte zinc scale in OKLCH, declared
in `frontend/src/app.css`. Tailwind utility classes resolve to these
CSS custom properties; *never* hex-code colours in templates.

#table(
  columns: (1.2fr, 2fr, 2.4fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Token*], [*Tailwind class*], [*Use*]),
  [`background`], [`bg-background`], [Page canvas behind everything.],
  [`foreground`], [`text-foreground`], [Default body text.],
  [`primary`], [`bg-primary` / `text-primary`], [Headlines, key actions, the Tamil hero word.],
  [`secondary`], [`bg-secondary` / `text-secondary-foreground`], [Inactive toggles, neutral pills.],
  [`muted`], [`bg-muted` / `text-muted-foreground`], [De-emphasised supporting text and surfaces.],
  [`accent`], [`bg-accent`], [Hover and focus surfaces.],
  [`destructive`], [`bg-destructive`], [Error states, "backend unreachable", invalid input.],
  [`card`], [`bg-card`], [Raised surfaces (cards, dialogs, status strips).],
  [`border`], [`border` / `border-border`], [Default 1 px hairline.],
  [`ring`], [`ring-ring`], [Focus halos at 2 px width with 2 px offset.],
)

Dark mode swaps the same tokens; never hard-code light-mode values.

== Typography

Display register is Tamil. The system font stack must include a
Northern Province–suitable Tamil font (Inter, Noto Sans Tamil, or the
device default). The Tailwind type scale collapses to four levels:

#table(
  columns: (1fr, 1fr, 2.6fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Role*], [*Class*], [*Notes*]),
  [Hero], [`text-7xl sm:text-8xl font-bold`], [Reserved for the Tamil wordmark "வெளி" on the landing surface only.],
  [Page title], [`text-xl font-semibold`], [`<h1>` on every page below the layout.],
  [Section], [`text-lg font-semibold`], [`<h2>` inside cards.],
  [Body], [`text-sm` or `text-base`], [Default copy. Use `text-base sm:text-lg` for long-form prose.],
  [Caption], [`text-xs text-muted-foreground`], [Tier labels, badges, footnotes.],
)

Always pair Tamil and English: never replace a Tamil label with an
English-only one in user-facing surfaces. The IVR/USSD/SMS surfaces
follow their own register rules and are out of scope here.

== Spacing and radius

Tailwind's default scale; preferred increments are `2 / 3 / 4 / 6 / 8 / 12 / 16`
(0.5 rem multiples). Never invent custom pixel values when a token will do.

Radius tokens come from `--radius: 0.625rem`:

- `rounded-sm` — pills, badges
- `rounded-md` — buttons, inputs, status strips
- `rounded-lg` — cards, dialog surfaces
- `rounded-xl` — modal overlays, hero containers

Borders are 1 px (`border`) on `border-border`. Avoid heavier weights
unless you are crossing a destructive or focus boundary.

= Components

Every primitive lives at `frontend/src/lib/components/ui/<name>.svelte`
and is re-exported from `frontend/src/lib/components/ui/index.ts`. Pages
import the primitive, never the underlying Tailwind elements when a
primitive applies.

Primitives use Svelte 5 runes (`$props`, `$state`, `$derived`, `$effect`)
and the `cn(...)` helper from `$lib/utils` for class composition with
`tailwind-merge`.

== Button

#raw("import Button from '$lib/components/ui/Button.svelte'")

Variants: `primary` (default), `secondary`, `ghost`, `destructive`.
Sizes: `sm`, `md` (default), `lg`. Touch target is 44 px minimum at
`md` to satisfy WCAG 2.5.5 on phones.

#raw("<Button variant=\"primary\" onclick={handleSubmit}>{m.submit()}</Button>")

== Card

Surface for grouped content: a header (title + optional badge), an
optional content body, and an optional footer. The current landing
page's three-phase strip is the canonical example.

#raw("<Card>
  <CardHeader title={m.phase1_title()} />
  <CardContent>{m.phase1_blurb()}</CardContent>
</Card>")

== Badge

Inline pill for short states (locale, role, count). Variants:
`default`, `secondary`, `destructive`. Use `Badge` for generic state;
use `TierBadge` (below) for verification tiers — never mix them.

== TierBadge

A specialised `Badge` for the three-tier verification model. It
*always* renders both English and Tamil labels per the architectural
contract in the strategic plan §Phase 0. Visual treatment makes the
hierarchy of legal effect obvious without saying so:

#table(
  columns: (1.4fr, 1.4fr, 1.6fr, 2fr),
  stroke: 0.5pt + gray,
  inset: 6pt,
  align: left,
  table.header([*Tier value*], [*EN label*], [*TA label*], [*Visual*]),
  [`self_asserted`], [Self-asserted], [சுய அறிவிப்பு], [`bg-muted text-muted-foreground` — visibly the lightest.],
  [`community_corroborated`], [Community-corroborated], [சமூக சாட்சியம்], [`bg-secondary text-secondary-foreground` — neutral, no claim of legal effect.],
  [`authority_attested`], [Authority-attested], [அதிகாரப்பூர்வ உறுதி], [`bg-primary text-primary-foreground` — the most confident treatment, used only when the tier carries legal effect.],
)

Never substitute tier names. Never add a fourth tier, even visually.
If a UI surface needs to express a derived state (e.g. "expired
attestation"), do it with a separate adjacent badge, not by changing
the tier label.

== StatusStrip

Thin bar at the bottom of a page (or pinned to the layout) reporting
system reachability. Two states:

- `reachable` — `bg-card text-muted-foreground`, with an optional
  phase-number `Badge` from the backend `hello` payload.
- `unreachable` — `bg-destructive text-destructive-foreground`, plus
  the parsed error string at reduced opacity for dev visibility.

The current landing page's status strip is the reference; primitives
should preserve its exact visual.

== LocaleSwitcher

Three-button group (`தமிழ் / English / සිංහල`) calling Paraglide's
`setLocale`. Active locale uses `bg-primary text-primary-foreground`;
inactive uses `bg-secondary text-secondary-foreground`. Mounted at
`fixed top-4 right-4 z-50` in the layout. Buttons are 44 px tall.

= Patterns

== Page shell

Every page wraps content in:

#raw("<div class=\"flex min-h-screen flex-col bg-background text-foreground\">
  <main class=\"mx-auto w-full max-w-2xl px-6 py-12\">
    <!-- page body -->
  </main>
</div>")

The landing page widens to `max-w-5xl`. The user-detail page uses the
default `max-w-2xl`. Avoid full-bleed layouts on phones.

== List of properties

Definition list (`<dl>` / `<dt>` / `<dd>`) divided by hairlines is the
canonical pattern for displaying record fields (e.g. user details).
Each row is `flex items-baseline gap-4 px-6 py-3`; the `<dt>` is
`w-36 shrink-0 text-sm font-medium text-muted-foreground`; the `<dd>`
is `text-sm`. Monospace (`font-mono`) for IDs and NIC numbers.

== Error and empty states

Localised, never English-only. Use a `Card` with centred copy:

#raw("<Card class=\"text-center\">
  <CardContent>{m.user_not_found()}</CardContent>
</Card>")

Server errors get `border-destructive/30 bg-destructive/10` plus a
single line of guidance ("please try again later" — never a stack
trace). Never expose raw backend error envelopes to the user; log them.

== Form inputs

All inputs are full-width on mobile, 44 px tall, with a label above
(never placeholder-only — accessibility regression on iOS Safari and
some Tamil IMEs). Validation errors surface below the input in
`text-sm text-destructive`.

= Accessibility

- *Touch targets:* 44 px × 44 px minimum. Buttons at `size="md"`
  satisfy this; never go below `size="sm"` for primary actions.
- *Focus rings:* never disable. The `ring-ring` token gives a 2 px
  halo at 2 px offset; tab order must be logical.
- *Contrast:* zinc OKLCH already meets AA at body sizes; verify
  manually for tier-coloured backgrounds.
- *aria-label:* every interactive control needs one, *and it must be
  localised through Paraglide*. Never hard-code English `aria-label`
  strings.
- *Language tag:* the `<html lang>` is set by Paraglide via the
  `%paraglide.lang%` placeholder; do not override it manually.
- *Right-to-left:* not currently in scope. Tamil and Sinhala are LTR.

= Internationalisation rules

- *Tamil first.* Author the Tamil string before any other language.
  Never translate Tamil from English in user-facing copy.
- *Register.* Northern Province colloquial (Jaffna). Avoid literary
  Tamil. Have a Northern Province native speaker review new strings
  before merge.
- *Catalogue layout.* All keys in `frontend/messages/{en,ta,si}.json`,
  one key per UI string. No string concatenation across keys —
  pluralisation and parameter substitution use Paraglide's parameter
  syntax.
- *Numerals.* Use European numerals (0–9) by default; the platform
  shows Tamil numerals only when explicitly requested by content.
- *Quoting.* Tamil uses straight quotes. Sinhala uses standard
  punctuation. English may use curly quotes in long-form copy but
  not in UI labels.

= Mobile-first defaults

- Default breakpoints follow Tailwind: `sm` 640 px, `md` 768 px,
  `lg` 1024 px. The smartphone surface targets `< sm`; widen up
  from there.
- Never assume hover. Every interactive state must work on touch.
- Service worker caches the active session; pages should render
  meaningful content with cached data plus a small banner when
  offline. Avoid spinner-only offline states.
- Capacitor Android wrap: status-bar colour is `bg-background`; the
  splash screen is hidden on layout mount.

= Code conventions

- *Svelte 5 runes only.* `$state`, `$derived`, `$effect`, `$props`.
  No legacy `writable` or `readable` stores.
- *Server-only code* lives in `src/lib/server/`. Never import from
  `$lib/server/` inside a `.svelte` component.
- *API calls* go through `+page.server.ts` `load()` using the typed
  client at `$lib/api`. Never `fetch()` the backend directly from a
  component.
- *Primitive imports.* Reach for `$lib/components/ui/<name>.svelte`
  before writing new Tailwind classes for buttons, cards, badges, or
  status strips.
- *cn() helper.* Compose classes with `cn(...)` from `$lib/utils`.
  Never string-concatenate Tailwind classes.
- *Props.* Type props with TypeScript `interface`s; default values
  set via destructuring at the `$props()` site. Forward `class` and
  `ref` through `WithoutChildrenOrChild<T>` from `$lib/utils` when
  wrapping native elements.
- *No inline `<style>`* unless scoped and unavoidable. Tailwind
  utilities first; CSS custom properties when a token is needed.

= Boundaries

This design system is for the smartphone surface (PWA + Capacitor
Android wrap). It does *not* cover:

- The IVR / USSD / SMS surfaces (governed by Tamil voice prompt
  authoring rules, see strategic plan §Phase 0 architecture).
- Internal admin or back-office tooling (out of scope for v1.x).
- Print or PDF artefacts (deed-ready bundles in Phase 2 use a
  separate Typst template).

When in doubt, defer to `CLAUDE.md` for project-wide rules and the
strategic plan in `docs/plan/` for product policy.
