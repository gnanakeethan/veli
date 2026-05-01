= Strategic Context

== The Problem We Are Addressing

The Northern Province carries forward an institutional and infrastructural deficit that the post-war reconstruction effort has only partially closed. For ordinary residents, this manifests as a daily friction tax:

- Fragmented and paper-bound government service delivery, requiring repeated visits to Divisional Secretariat offices, Grama Niladhari offices, and line-ministry branches, often without clear information about what is needed.
- Contested or undocumented land ownership stemming from displacement, lost deeds, military occupation, and decades-old paper records held across multiple offices.
- Weak market access for small agricultural producers and palmyra craftspeople, whose products lose value at every handoff because there is no credible provenance, grading, or buyer-trust mechanism.

These are not separate problems. They share a common root: the absence of a low-cost, trusted layer for identity, document provenance, and verification in a region where the state's coverage is thin and historical records are unreliable.

== Why IT Is the Right Lever

Information technology cannot substitute for the legal system, the land registry, or formal export certification. It can, however, build a parallel evidence layer that is cheap, accessible in Tamil, mobile-first, and structured well enough to be useful to lawyers, exporters, NGOs, and government officials when those formal systems are eventually engaged.

The technology stack required is not exotic. The hard problems are linguistic, operational, and institutional: working in Tamil, building local field operations, and earning the trust of communities, government counterparts, and diaspora funders.

== Strategic Sequencing Principle

The platform is sequenced from low-stakes daily utility toward high-stakes economic infrastructure. Each phase generates the trust, user base, and operational capacity needed for the next. Building all three pillars simultaneously would dilute focus and overrun the operational capacity of a small team.

#v(0.5em)

#block(
  fill: rgb("#f4f1e8"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  *Sequencing rationale at a glance*
  - *Phase 1 — Government Navigation:* Lowest trust cost, highest daily utility. Establishes the user base, Tamil NLP capability, and field operations.
  - *Phase 2 — Land Documentation:* High social stakes, requires established trust. Reuses identity and document layer from Phase 1.
  - *Phase 3 — Agricultural Traceability:* B2B revenue arm. Reuses identity layer; sells to exporters and cooperatives.
  - *Phase 4 — Platform Consolidation:* Unified civic infrastructure across all three pillars.
]

== Founding Constraints and Assumptions

The plan assumes the founding team will operate under realistic Sri Lankan conditions:

- A small team of five to seven people through Phase 0 and early Phase 1, growing to roughly fourteen to seventeen by end of Phase 2 and thirty to forty by end of Phase 3. The team includes a dedicated infrastructure / site-reliability function from Phase 0 because the platform self-hosts on private infrastructure (see Section 7). Earlier internal drafts of this plan understated team size; the figures above are what the plan as currently scoped actually requires.
- A blended funding model combining grant capital (NGO, diaspora, multilateral), modest local revenue, and eventually B2B contract revenue from exporters and cooperatives.
- Tamil as the primary working language for product, with Sinhala and English as secondary.
- A Tamil-first Progressive Web App (PWA) is the primary delivery surface for users with smartphones, accessible from any browser on low-end Android devices. The PWA installs to the home screen, works offline, and is wrapped as a native Android app where install conversion justifies it. In parallel, a Tamil-language IVR, a USSD application, and an SMS short-code service deliver the same content base to feature-phone users and to smartphone users without browser comfort, via Ideamart (Dialog Axiata) and hSenid Mobile multi-operator APIs covering Dialog, Mobitel, and Hutch. The platform does not deliver via WhatsApp or any other third-party messaging surface in Phase 1.
- Deep partnerships with at least two local NGOs and one diaspora foundation from Phase 1 onward.
