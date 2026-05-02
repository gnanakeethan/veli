// Veḷi — Phased Implementation Plan
// Multi-file entry point. Per-section content lives in `docs/plan/`; edit
// the section files there, not this file (unless changing structure).
// Build with: typst compile veli_implementation_plan.typ
//
// Source of truth as of 2026-05-02: v1.6 (AI agents on Vertex AI MaaS under a
// Google Cloud Data Processing Addendum; Gemma 4 model selection; Phase 0
// evaluation gate; de-identification at the application boundary). Builds on
// v1.5 (bottom-up budgets, phase gates and scope compression, expanded
// protocol specs for identity recovery and trained helpers, larger team
// sizing, Thesawalamai legal partner requirement), v1.4 (Polly Neural TTS +
// Jaffna pronunciation lexicon), and v1.3 (self-hosted Tier III colocation;
// PWA + IVR/USSD/SMS via Ideamart and hSenid; Notaries Ordinance posture).
// Frozen single-file snapshots are kept under `docs/snapshots/` as `vN.M.typ`.

#set document(
  title: "Veḷi — Phased Implementation Plan",
  author: "Cloud Parallax (Pvt) Ltd",
)

#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  numbering: "1",
  number-align: center,
  header: context {
    if counter(page).get().first() > 1 [
      #set text(8pt, fill: gray)
      Veḷi — Phased Implementation Plan
      #h(1fr)
      Cloud Parallax (Pvt) Ltd
    ]
  },
)

#set text(
  font: ("Libertinus Serif", "New Computer Modern"),
  size: 10.5pt,
  lang: "en",
)

#set par(
  justify: true,
  leading: 0.65em,
  spacing: 1.1em,
)

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  set text(size: 18pt, weight: "bold")
  block(above: 0.5em, below: 0.8em, it)
}
#show heading.where(level: 2): set text(size: 13pt, weight: "bold")
#show heading.where(level: 3): set text(size: 11pt, weight: "bold", style: "italic")
#show heading: set block(above: 1.2em, below: 0.6em)

#show link: set text(fill: rgb("#1a5490"))
#show raw: set text(font: "DejaVu Sans Mono", size: 9pt)

// ============ TITLE PAGE ============

#align(center)[
  #v(3.5cm)
  #text(36pt, weight: "bold")[
    வெளி
  ]
  #v(0.2em)
  #text(28pt, weight: "bold")[
    Veḷi
  ]
  #v(0.6em)
  #text(13pt, style: "italic", fill: rgb("#555555"))[
    Open. Clear. Civic.
  ]
  #v(1.8cm)
  #text(15pt)[
    A Phased Implementation Plan
  ]
  #v(0.3em)
  #text(12pt, fill: rgb("#555555"))[
    Civic infrastructure for Jaffna and the Northern Province
  ]
  #v(1.2cm)
  #text(11pt)[
    Government Service Navigation #sym.dot.c
    Land Documentation #sym.dot.c
    Agricultural Traceability
  ]
  #v(1.2cm)
  #line(length: 40%, stroke: 0.5pt)
  #v(0.5em)
  #text(11pt)[
    Cloud Parallax (Pvt) Ltd \
    Jaffna, Sri Lanka
  ]
  #v(1.5cm)
  #text(10pt, fill: gray)[
    Version 1.6 #sym.dot.c May 2026 \
    #text(8pt, style: "italic")[AI agents on Vertex AI MaaS; Gemma 4]
  ]
]

#pagebreak()

// ============ EXECUTIVE SUMMARY ============

#include "docs/plan/_executive_summary.typ"

// ============ NUMBERED SECTIONS ============

#include "docs/plan/01_strategic_context.typ"
#include "docs/plan/02_phase0_foundations.typ"
#include "docs/plan/03_phase1_govnav.typ"
#include "docs/plan/04_phase2_land_docs.typ"
#include "docs/plan/05_phase3_agri.typ"
#include "docs/plan/06_phase4_consolidation.typ"
#include "docs/plan/07_cross_cutting.typ"
#include "docs/plan/08_ai_agents.typ"
#include "docs/plan/09_organization.typ"
#include "docs/plan/10_funding.typ"
#include "docs/plan/11_risk_register.typ"
#include "docs/plan/12_phase_gates.typ"
#include "docs/plan/13_conclusion.typ"
