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
    Version 1.3 #sym.dot.c May 2026 \
    #text(8pt, style: "italic")[Self-hosted infra; PWA + IVR/USSD multi-channel]
  ]
]

#pagebreak()

// ============ EXECUTIVE SUMMARY ============

#align(center)[
  #text(16pt, weight: "bold")[Executive Summary]
]
#v(0.5em)

This document outlines a five-year phased plan to build *Veḷi*, a civic technology platform serving households and small producers in Sri Lanka's Northern Province. *Veḷi* (வெளி) is Tamil for "openness, clarity, the open" — a name that signals what the platform stands for across all three of its product lines: clarity in navigating government, openness in documenting land, and transparency in agricultural supply chains.

Veḷi addresses three interconnected problems that currently consume disproportionate time, money, and dignity from ordinary residents: navigating government services, documenting land and property, and bringing local agricultural produce to verified markets.

The unifying thesis is that the Northern Province has a structural deficit of *trust and verification infrastructure* — a legacy of war, displacement, and underinvestment — and that a Tamil-first, mobile-first, community-anchored platform can build a parallel evidence layer to unlock real economic and civic activity.

Rather than launching all three products at once, the plan sequences them deliberately. Phase 1 delivers a Tamil-language government services assistant — low risk, high daily utility, and a vehicle for building trust and operational maturity. Phase 2 layers community-driven land documentation onto the same user base. Phase 3 extends the identity and verification layer into agricultural supply chains, opening export and diaspora revenue channels. Phase 4 consolidates the three into a coherent civic infrastructure platform.

The plan assumes a small founding team, blended grant and revenue funding, and deep partnerships with local NGOs, cooperatives, and government bodies. It is written for execution, not pitching.

#v(1em)

// ============ SECTION 1 ============

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

- A small team of three to six people through Phase 1, growing to roughly fifteen to twenty by end of Phase 3. The team includes a dedicated infrastructure / site-reliability function from Phase 0 because the platform self-hosts on private infrastructure (see Section 7).
- A blended funding model combining grant capital (NGO, diaspora, multilateral), modest local revenue, and eventually B2B contract revenue from exporters and cooperatives.
- Tamil as the primary working language for product, with Sinhala and English as secondary.
- A Tamil-first Progressive Web App (PWA) is the primary delivery surface for users with smartphones, accessible from any browser on low-end Android devices. The PWA installs to the home screen, works offline, and is wrapped as a native Android app where install conversion justifies it. In parallel, a Tamil-language IVR, a USSD application, and an SMS short-code service deliver the same content base to feature-phone users and to smartphone users without browser comfort, via Ideamart (Dialog Axiata) and hSenid Mobile multi-operator APIs covering Dialog, Mobitel, and Hutch. The platform does not deliver via WhatsApp or any other third-party messaging surface in Phase 1.
- Deep partnerships with at least two local NGOs and one diaspora foundation from Phase 1 onward.

// ============ SECTION 2 ============

= Phase 0 — Foundations (Months 0 to 3)

Phase 0 is a discovery and setup quarter that precedes any product launch. Skipping it is the most common failure mode for civic technology projects.

== Objectives

- Validate the three problem statements through structured field research, not assumption.
- Establish the legal, regulatory, governance, and partnership scaffolding the platform will rest on, including PDPA compliance, Online Safety Act exposure, and corporate form decision.
- Recruit the founding team and define operating cadence.
- Specify the shared identity and document architecture that all phases will reuse, including honest infrastructure residency, layered encryption, and identity recovery protocol.
- Run a demand-side baseline survey to set realistic adoption targets.

== Field Research

A six-week research sprint covering at least four Divisional Secretariat divisions across Jaffna District, with supplementary visits to Kilinochchi and Mullaitivu. The research must cover:

- Twenty to thirty in-depth household interviews, oversampling elderly residents, women heads of household, and returnees.
- Shadowing of at least ten government service journeys end-to-end, from initial intent to final document collection.
- Interviews with Grama Niladhari officers, Divisional Secretaries, and frontline clerks to understand process variation, informal practice, and pain points from the inside.
- Conversations with three to five exporters of palmyra, dried fish, mango, and onion to understand current procurement and verification practice.
- Conversations with two to three legal aid organizations active on land issues.

== Partnership Scaffolding

By the end of Phase 0, the following partnerships must be in writing or near it:

- *Local NGO partner* with field operations across at least two Divisional Secretariat divisions, willing to co-host community meetings and host field staff.
- *Legal partner* — a Jaffna-based law firm or legal aid organization willing to advise on land documentation scope and limits.
- *Diaspora foundation partner* willing to co-fund Phase 1 and serve as a credibility bridge to Tamil diaspora communities in Canada, the UK, and Australia.
- *Academic partner* — University of Jaffna's Faculty of Engineering or Computing, for student involvement, internships, and credibility.

== Shared Architecture Specification

The defining technical decision of Phase 0 is the specification of the shared identity and document layer. This layer must be designed once, correctly, because all three product lines will reuse it.

#v(0.4em)

#table(
  columns: (1fr, 2fr),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Component*], [*Specification*],
  ),
  [Identity], [Phone-number-anchored, with optional NIC linkage. Tamil-first profile. Identity recovery follows a documented protocol: at least two named guardians designated at registration; recovery requires #raw("m-of-n") guardian approval (default 2-of-3); a 72-hour cooling-off period before any identity change takes effect; an in-person partner-lawyer attestation as an alternative path; and a full audit log surfaced to the user. SIM reassignment by a mobile operator does not transfer the Veḷi identity. Account-takeover incident response is part of the formal incident response process from Phase 1 onward.],
  [Document store], [Per-user encrypted store with provenance metadata: capture device, GPS, timestamp, witnesses. Versioned.],
  [Verification], [Three-tier model, with legal effect made explicit in tier names: _self-asserted_ (no legal effect), _community-corroborated_ (no legal effect; supports later notarisation), _authority-attested_ (notary, lawyer, or government office, carries legal effect). Each document carries its tier explicitly in the UI in both English and Tamil.],
  [Access surface], [Multi-channel by design. (1) A Tamil-first Progressive Web App (PWA) is the primary surface for smartphone users and is the only surface that supports document upload, GPS capture, witness-statement signing, and lot creation. The PWA is installable, works offline, and is wrapped as a native Android app where install conversion justifies it. (2) For feature-phone users and users without browser comfort, a Tamil-language IVR, a USSD application, and an SMS short-code service deliver information-lookup flows (Phase 1 government-service procedures) via Ideamart by Dialog and hSenid Mobile multi-operator APIs (covering Dialog, Mobitel, and Hutch). The IVR, USSD, and SMS surfaces are read-only for procedure information; sensitive flows (Phases 2 and 3 document upload, witness signing) remain PWA-only. (3) A trained-helper telephone hotline routes to the same content base for cases the automated channels cannot handle. All channels share one backend content store; answers do not diverge across surfaces.],
  [Backend], [Self-hosted on private infrastructure at a Tier III colocation facility in Sri Lanka (Dialog IDC, SLT IDC, Hayleys Solar Power IDC, or equivalent), with primary and secondary sites in two physically separated locations within the country. Go services on managed Kubernetes; high-availability PostgreSQL with streaming replication; on-premises object storage (Ceph or MinIO) for documents. All primary data remains in Sri Lanka. Encrypted offsite backup is held at the secondary in-country site; a tertiary encrypted backup outside Sri Lanka is permitted only with an explicit PDPA §26 instrument and only for disaster recovery, not for live read.],
  [Encryption], [Three layers, named explicitly. (1) _Transport_: TLS 1.3 between PWA and backend. (2) _At-rest_: full-disk encryption on storage hardware plus per-record encryption for personal data in PostgreSQL. (3) _True end-to-end_ for sensitive land and identity documents: per-user keys derived on-device, wrapped with the user's recovery scheme, and never held in clear by the backend. Because the platform does not route through any third-party messaging service, true E2E is achievable for every sensitive content path.],
  [Offline], [All capture flows must work offline and sync on reconnect. Northern Province connectivity is uneven; the PWA caches the active session locally and reconciles on next connection. Service-worker design assumes intermittent 3G as the baseline.],
)

== Deliverables

+ Field research report with prioritised findings.
+ Signed memoranda of understanding with two NGO partners and one diaspora foundation; written commitment from the legal partner and the academic partner.
+ Architectural specification document for the shared identity and document layer, including the self-hosted infrastructure design (two-site Tier III colocation, HA PostgreSQL, Ceph or MinIO object storage, network architecture), the multi-channel access design (PWA + IVR + USSD + SMS), the three-layer encryption model, and the identity recovery protocol.
+ Colocation provider selection and signed contracts with a primary and secondary in-country site; baseline hardware procurement plan and order placed.
+ Telco aggregator agreements: Ideamart (Dialog) developer registration with shortcode and USSD code allocation; hSenid Mobile commercial agreement for Mobitel and Hutch coverage; PDPA controller-processor agreement signed; commercial discussion opened on civic-content zero-rated billing.
+ Tamil IVR voice prompts recorded for the top-20 procedures by a Northern Province native voice talent, reviewed by the Tamil content lead.
+ PDPA compliance package: appointed Data Protection Officer (fractional acceptable), draft Data Protection Impact Assessment, documented lawful basis per processing activity, draft data-subject-request workflow.
+ Online Safety Act exposure register and takedown SLA, with named on-call moderation responders.
+ Corporate form decision and conflict-of-interest policy (see Section 8 governance).
+ Data trust deed naming the institutional successor for the data store, colocation contracts, and operational runbooks on dissolution (see Section 7 custodianship).
+ Insurance package: indicative quotes for E&O, cyber, and media liability.
+ Founding team in place: technical lead, site-reliability lead, field operations lead, Tamil content lead, partnerships lead.
+ Twelve-month budget and grant pipeline, including a bottoms-up Phase 3 commodity-revenue model for at least one commodity, and an explicit hardware CAPEX line.
+ Demand-side baseline survey (400–600 households across at least three GN divisions) on smartphone ownership, browser comfort, Tamil-text comfort, and preferred channel.
+ Trademark clearance search at NIPO and at IP offices in Canada, the UK, and Australia.

== Risks for Phase 0

- *Premature commitment* to a product specification before research completes. Mitigation: enforce the six-week research sprint as a hard gate.
- *Partnership fragility* — verbal agreements that evaporate. Mitigation: written MOUs with clear scope and exit terms.
- *Talent gap* in Tamil content and field operations. Mitigation: recruit from local civil society and journalism, not only from the tech sector.

// ============ SECTION 3 ============

= Phase 1 — Government Service Navigation (Months 3 to 15)

== Product Definition

A Tamil-first task assistant, delivered through a Progressive Web App (PWA) for smartphone users and through a Tamil-language IVR, USSD, and SMS short code for feature-phone users, that helps Northern Province residents navigate government services. For a stated need — replacing a lost birth certificate, applying for Samurdhi, claiming a pension, obtaining a Grama Niladhari certificate — the assistant produces a clear, current, locally accurate procedure: which office, which forms, which supporting documents, which fees, which days and hours, and which clerk or section to ask for.

The IVR, USSD, and SMS surfaces are delivered via Ideamart by Dialog Axiata and hSenid Mobile multi-operator APIs, which between them give coverage across Dialog, Mobitel, and Hutch. This multi-channel posture is a deliberate accessibility choice: a meaningful share of the Northern Province population — particularly elderly users, women heads of household, and returnees — does not own a smartphone or is not comfortable navigating to a URL. A short USSD code or a memorised SMS shortcode requires zero installation, zero literacy in URL bars, and works on any phone.

The assistant is architected as a *structured task router* rather than a general-purpose conversational agent. The user's free-text or voice input is classified into one of the documented procedures; the assistant then walks the user through a structured flow (menus, buttons, forms in the PWA; numbered IVR options; SMS keyword replies). Free-form generative responses are restricted to a small set of carefully bounded interactions (clarifying a procedure step, summarising a document checklist) with a hard fallback to human-operated handoff for low-confidence intents. This architecture is deliberate: Jaffna Tamil differs materially from Indian Tamil in morphology, phonology, and colloquial register, and Tamil LLMs available in 2026 are predominantly trained on Indian Tamil corpora; structured task routing produces auditable, accurate behaviour where free-form generation does not, and translates cleanly across PWA, IVR, USSD, and SMS surfaces.

The product is information arbitrage. It does not file forms on behalf of users. It does not promise outcomes. It tells residents, in their language, what they would otherwise learn only after several wasted trips.

== Why This Is the Right Wedge

- *Daily utility:* Every household has at least one pending or recurring government errand.
- *Low trust cost:* The platform is giving information, not holding sensitive documents yet.
- *Cheap to operate:* The marginal cost of serving an additional user is small once self-hosted infrastructure is in place.
- *Funding-friendly:* Aligns with the mandates of NGOs, diaspora foundations, and multilateral agencies that fund civic-tech and access-to-services work.
- *Operational learning:* Builds Tamil NLP capability, content operations, field distribution, and self-hosted infrastructure operations — all of which are prerequisites for later phases.

== Scope at Launch

Launch covers the twenty most-requested government services in Jaffna District, identified during Phase 0. Indicative list:

- Birth, marriage, and death certificate replacement.
- National Identity Card issuance, replacement, and correction.
- Grama Niladhari certificates (residence, character, income).
- Samurdhi enrollment and grievance.
- Pension claims (public sector, EPF, ETF).
- School admission and scholarship applications.
- Driving license issuance and renewal.
- Land transfer and deed registration intake.
- Business registration for sole proprietorships.
- Voter registration corrections.

Each service is documented as a structured procedure with versioned content, last-verified date, and a named content owner.

== Content Operations

Content freshness is the product's lifeblood. Office hours, fees, forms, and informal practice change frequently. The plan invests heavily in content operations from the start.

- A content team of two full-time Tamil writers, plus a roster of part-time field verifiers across Divisional Secretariat divisions.
- A monthly verification cycle: every procedure is re-verified at least once per quarter, with high-traffic procedures re-verified monthly.
- A user feedback loop: every conversation ends with a "did this match what you found?" prompt, and discrepancies trigger content review within 72 hours.
- A clear public statement on the platform that procedures may change and that the platform is a guide, not an authority.

== Technical Build

The technical build is intentionally modest in Phase 1.

- *Frontend (smartphone):* A Tamil-first Progressive Web App built mobile-first for low-end Android (Chrome/WebView). Service worker for offline caching of the active session and the procedure content; installable to home screen; no third-party messaging integration. A native Android wrapper is published once install conversion justifies it.
- *Voice and messaging surface (feature phone):* A Tamil-language IVR, a USSD application, and an SMS short-code service delivered through Ideamart by Dialog Axiata and hSenid Mobile multi-operator APIs (covering Dialog, Mobitel, and Hutch). Voice prompts are recorded by a Northern Province native voice talent. The aim is zero-rated billing for civic content (no charge to the user) where the operator commercial framework permits; otherwise a sponsored-session model.
- *Conversational layer:* A Tamil-first task router that classifies user intent into one of the documented procedures, with strict fallback to human-operated handoff for unrecognised queries. Intent classification runs on a small, self-hosted model fine-tuned on a Phase 0 Jaffna-Tamil intent corpus; free-form generation is reserved for a narrow set of bounded interactions and is never used for procedural facts. The same router serves PWA, IVR, USSD, and SMS surfaces, so the answer is consistent regardless of channel.
- *Content store:* Structured procedure definitions in a versioned content management system, queryable by intent and division. The content schema is channel-agnostic: each procedure has a long-form rendering for the PWA, a numbered-options rendering for IVR, and a short-keyword rendering for SMS, all generated from one source.
- *Tamil language handling:* Mixed-script (Tamil script and Tanglish) on the PWA; spoken Jaffna Tamil on the IVR; numeric keys on USSD with Tamil prompts. Voice (TTS plus closed-vocabulary ASR) is used for high-traffic flows.
- *Backend:* Go services on self-hosted Kubernetes at the Tier III colocation site (see Section 7). High-availability PostgreSQL with streaming replication; Ceph or MinIO for object storage. All data resident in Sri Lanka.
- *Telco data flow:* IVR/USSD/SMS sessions terminate at hSenid Mobile (the underlying VAS platform), which forwards request payloads to the Veḷi backend over an authenticated API. hSenid is treated as a data processor under the PDPA controller-processor model; a written processing agreement is in place from launch. No payload data is stored at hSenid beyond what their telco-billing audit obligations require, and all telco-side data is local to Sri Lanka.
- *Analytics:* Per-procedure usage, completion, and discrepancy tracking, segmented by channel (PWA / IVR / USSD / SMS). No personally identifying analytics.

== Distribution

Distribution combines two complementary channels: a smartphone PWA and a zero-install IVR/USSD/SMS shortcode reachable from any feature phone. The shortcode reach is the discoverability backbone, because it requires no app, no URL typing, and no internet connection. Both channels are launched together in Phase 1; printed materials carry both the short URL and the shortcode so users self-select.

- A short, memorable Tamil-script URL (e.g., `வெளி.lk` via internationalised domain, or a short `.lk` ASCII fallback) and a per-division QR code printed on every poster, sticker, and printed card.
- A short, memorable USSD code and SMS shortcode procured through Ideamart and hSenid, advertised on every poster alongside the URL.
- Community launches in partnership with the NGO partner, in at least eight Grama Niladhari divisions in the first six months of operation.
- Posters, stickers, and printed cards distributed at Divisional Secretariat waiting areas, libraries, post offices, and pharmacies, each carrying the URL+QR for smartphone users and the USSD/SMS code for feature-phone users.
- A "trained helper" programme: training community volunteers, librarians, and shopkeepers to install the PWA on residents' phones, dial the USSD code, and use the assistant on residents' behalf.
- Tamil-language radio spots on local stations advertising the shortcode and URL.
- SEO and Tamil-keyword search presence (Google Search and YouTube) for high-traffic procedure queries.
- An optional outbound notification channel via SMS for procedure follow-ups that the user has opted into; the platform does not send unsolicited messages.

== Funding for Phase 1

Phase 1 is grant-funded. Indicative funding mix:

- One anchor grant from a diaspora foundation, covering 12 months of core operations.
- Project grants from one or two multilateral or bilateral programs (UNDP access-to-services, GIZ digital governance, similar) covering specific deliverables.
- Modest in-kind support from the academic partner for student labor.
- No user fees in Phase 1.

The Phase 1 operational budget includes an explicit line for IVR, USSD, and SMS shortcode costs payable to Ideamart and hSenid Mobile. The base case assumes commercial negotiation succeeds in zero-rating civic content (no charge to user, no charge to platform); the prudent case assumes per-session and per-SMS fees apply, in which case channel cost monitoring and gating are activated and the IVR path is throttled to budget while the PWA channel remains free.

== Success Metrics

Targets are stated as a base-case / stretch / heroic ladder. Funder reporting and internal go/no-go decisions are anchored on the base case; stretch and heroic are aspirational and are not used in funder commitments.

#table(
  columns: (auto, auto, auto, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right, right, right),
  table.header(
    [*Metric*], [*Base*], [*Stretch*], [*Heroic*],
  ),
  [Monthly active users by end of Phase 1], [5,000], [12,000], [20,000],
  [Trained helper volunteers], [80], [150], [250],
  [Top-20 services with content freshness < 90 days], [20], [20], [20],
)

In addition: every user reports avoiding at least one wasted office trip per service used (qualitative survey, no numeric target). MAU is defined as a unique phone number that has completed at least one full procedure flow on any channel (PWA, IVR, USSD, or SMS) in the trailing 30 days. Channel-segmented metrics are reported separately so PWA install rate is never flattered by IVR session counts: PWA-MAU, IVR-MAU, USSD-MAU, and SMS-MAU are each tracked. "Registered users" is reported separately and is never substituted for MAU.

== Risks for Phase 1

- *Content rot* — procedures become stale, users lose trust. Mitigation: aggressive verification cycle, public last-verified dates.
- *Government pushback* — officials may perceive the platform as exposing inefficiency. Mitigation: early, respectful engagement with Divisional Secretaries; framing the platform as a service that reduces their walk-in load.
- *Tamil NLP failure modes* — the assistant misclassifies intent in colloquial Tamil. Mitigation: human handoff for low-confidence intents, conservative auto-response thresholds.
- *Telco platform policy or pricing change.* Ideamart or hSenid changes its commercial terms, withdraws zero-rated billing for civic content, or imposes new content rules. Mitigation: agreements with both Ideamart and hSenid (vendor diversity); SMS shortcode and USSD code retained as fallback paths; ability to relocate IVR to an alternative VAS aggregator within 90 days; PWA channel remains under full Veḷi control regardless.
- *IVR/USSD operational cost overrun.* Per-session and per-SMS costs scale linearly with adoption; if zero-rated billing is not granted by operators, costs to the platform grow rapidly. Mitigation: explicit per-channel cost monitoring from Day 1; ability to throttle or gate the IVR path if costs exceed budget while the PWA remains free; early commercial negotiation with operators for civic-content zero-rating.
- *Self-hosted infrastructure load on a small team* — the engineering team is consumed by infrastructure work rather than product. Mitigation: dedicated site-reliability lead from Phase 0; budget tracking of SRE versus product engineering hours; willingness to relocate workloads to a managed Sri Lankan provider if operational burden becomes unsustainable.
- *Funding lumpiness* — grants are unpredictable. Mitigation: diversified grant pipeline; modest run-rate.

// ============ SECTION 4 ============

= Phase 2 — Land and Property Documentation (Months 15 to 33)

== Product Definition

A community-driven, notary-assisted platform that helps Northern Province households assemble and preserve evidence relevant to land and property ownership. The platform does not adjudicate ownership, does not replace the formal land registry, and does not create legal title. Under Sri Lankan law (Prevention of Frauds Ordinance No. 7 of 1840 §2, Notaries Ordinance), the only attestation that creates legal effect for transferring or mortgaging immovable property is a deed attested by a notary public before two witnesses present at the same time. Veḷi's role is therefore to produce a structured "deed-ready bundle" — photographs, GPS coordinates, witness statements, scanned deeds and notarial documents, oral history, version history — that a partner notary can use to draft a notarial instrument or that a household, lawyer, or court can reference. The bundle alone is not title evidence and is never marketed as such.

The Title Registration Act No. 21 of 1998 (Bim Saviya) coverage in Northern Province remains low after 27 years of national rollout, and the operative legal substrate for most Northern Province households continues to be the Roman-Dutch / Thesawalamai system mediated by notaries. Veḷi is built for that reality.

== Why Phase 2 Comes Second

Land documentation requires deep trust. Households are being asked to upload some of their most sensitive documents to an external platform. Phase 1 builds that trust by serving the same households reliably for a year on lower-stakes problems. By the time Phase 2 launches, the platform is a recognized civic actor with NGO and legal partnerships in place.

== Scope

The product covers three primary use cases:

+ *Inheritance documentation* — assembling the evidence a family needs to clearly establish ownership across generations, particularly where original deeds are lost or the original owner is deceased.
+ *Displacement and return documentation* — assembling evidence for households returning to land they were displaced from, including pre-displacement photographs, witness statements from neighbors, and historical records.
+ *Boundary and use documentation* — recording current physical boundaries, structures, cultivation, and use, with GPS and photographic evidence, as a baseline against future disputes.

The product explicitly does not cover military-occupied land disputes, contested ancestral claims, or any case currently in active litigation. Those require legal counsel and are out of scope for the platform.

== Verification Model

The platform's three-tier verification model becomes critical in Phase 2. The legal-effect column is the most important addition — it is shown to every user in both English and Tamil so no household over-relies on a tier that has no force in court.

#v(0.4em)

#table(
  columns: (auto, 1fr, 1fr, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Tier*], [*What it means*], [*Use case*], [*Legal effect*],
  ),
  [Self-asserted], [The household uploaded the document. The platform records who, when, and from which device.], [Personal records, photographs, family memory.], [None],
  [Community-corroborated], [Two or more named community members — typically neighbours or Grama Niladhari — have signed a witness statement, recorded by the platform.], [Boundary statements, residence history, oral history. Supports later notarisation; not a substitute for it.], [None],
  [Authority-attested], [A document has been attested by a notary public before two witnesses (per the Notaries Ordinance), or verified by a lawyer or government office.], [Notarial deeds, attested affidavits, surveyor reports, registered deeds.], [Yes, per the Notaries Ordinance and Prevention of Frauds Ordinance],
)

Each document in the system carries its tier explicitly. The platform never inflates a self-asserted or community-corroborated document into something it is not. The platform actively avoids language that suggests its evidence has legal force where it does not.

== Technical Build

Phase 2 reuses the identity and document layer from Phase 0. New capabilities required:

- *Structured evidence collection* — guided flows that walk a household through assembling a complete evidence package for a given use case.
- *Witness statement capture* — a workflow that brings two named witnesses through a structured statement, signed digitally with phone-anchored identity.
- *Surveyor and lawyer integration* — a workflow for licensed surveyors and notaries to add authority-attested documents to a household's package.
- *Export* — the ability to produce a clean, paginated PDF package of all evidence, ready for a lawyer or court.

== Field Operations

Phase 2 field operations are heavier than Phase 1.

- A network of trained community documentation officers — one per Divisional Secretariat division — who help households assemble evidence packages.
- A panel of partner lawyers willing to provide first-consultation advice at reduced rates.
- Mobile documentation drives in returnee communities, in partnership with NGO partners.

== Funding for Phase 2

Phase 2 funding is mixed.

- Continued grant funding for the household-facing service.
- Modest paid services for authority-attested documents (notary fees, surveyor fees), with the platform retaining a small operational margin.
- Diaspora-funded sponsorship of documentation drives in specific communities.

== Success Metrics

- Five thousand households with at least one complete evidence package by end of Phase 2.
- A panel of at least twenty partner lawyers and ten partner surveyors.
- At least one demonstrated case where a platform-produced evidence package materially helped a household resolve a land issue (with the household's consent to publicize).

== Risks for Phase 2

- *Political sensitivity.* Anything touching land in the North-East intersects with ethnicity, displacement, and military presence. Mitigation: strict scope discipline; legal partner review of platform statements; refusal to take politically charged cases.
- *Misuse.* The platform's evidence could be used adversarially. Mitigation: clear terms of use; tier transparency; legal partner advisory.
- *Document security.* Households are uploading sensitive material. Mitigation: layered encryption per the architecture spec — true end-to-end for sensitive documents uploaded via the PWA or app, with per-user keys not held by Veḷi; transport and at-rest encryption otherwise; access logging; explicit user-controlled sharing.
- *Scope creep* into adjudication. Mitigation: explicit, repeated framing — the platform documents, it does not decide.

// ============ SECTION 5 ============

= Phase 3 — Agricultural Supply Chain Traceability (Months 24 to 42)

== Product Definition

A traceability and verification platform connecting Northern Province small producers — Jaffna mango orchards, palmyra craftspeople, dried fish processors, onion farmers — to exporters, retailers, and diaspora buyers. Each lot of produce carries a verifiable provenance trail from harvest or capture through processing to point of sale, anchored in the same identity and document layer as Phases 1 and 2.

== Why Phase 3 Overlaps Phase 2

Phase 3 begins before Phase 2 ends because the customer is different — exporters and cooperatives, not households — and because the agricultural calendar is unforgiving. Mango harvest, palmyra tapping season, and the fishing calendar dictate when pilots can run. Waiting for Phase 2 to fully close would cost a full agricultural year.

== Scope

Commodity inclusion in Phase 3 is decided against three explicit criteria, applied transparently to each candidate:

+ *Diaspora pull demand* — is there an identifiable retail buyer base in Canada, the UK, or Australia willing to pay a verifiable-provenance premium?
+ *Single-origin storyability* — does the commodity have a credible Geographical Indication, varietal identity, or cooperative identity that the platform's metadata can carry?
+ *Producer-side cooperative density* — is there at least one cooperative or aggregator capable of running a season-long pilot?

A commodity is included only if it scores positively on all three. Phase 3 launches with three commodity verticals selected on this basis:

+ *Jaffna mango* (varieties: Karthakolomban, Velleikolomban) — harvest-to-export traceability. Diaspora pull and varietal identity are strong; cooperative density is moderate.
+ *Palmyra products* (jaggery, palm sugar, fibre crafts) — craftsperson-to-buyer traceability with cooperative integration. Diaspora pull and cooperative density are strong; varietal identity is regional rather than single-origin.
+ *Dried fish* — landing-to-processor-to-buyer traceability with attention to species and method. Domestic premium pull is strong; diaspora pull and storyability require validation in the pilot before scaling.

Onions, despite their economic importance to the Northern Province, are deferred. The honest reason — applied consistently with the criteria above — is that onion supply chains in Sri Lanka rely heavily on Dambulla and Colombo wholesale intermediaries with long-standing credit relationships, and there is no cooperative or aggregator in the North currently positioned to run a season-long traceability pilot independent of those intermediaries. Mango and dried fish supply chains have similar intermediary structures but, unlike onions, have at least one diaspora-pull buyer per vertical willing to pre-commit to a pilot. If that pre-commitment cannot be secured during the Phase 3 pilot window, the commodity is dropped, not promoted.

Each pilot runs for one full season before scaling. A commodity that fails its pilot is dropped from Phase 3 scope rather than carried into Phase 4.

== Value Proposition by Stakeholder

#v(0.4em)

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Stakeholder*], [*Value*],
  ),
  [Small producer], [Verified provenance commands a price premium. Platform-mediated payment reduces middleman shrinkage. Identity layer enables future credit access.],
  [Cooperative], [Aggregated provenance for member produce. Quality grading data. Buyer matching.],
  [Exporter], [Defensible supply chain claims for international buyers, particularly diaspora retailers in Canada, the UK, and Australia. Reduced compliance risk.],
  [Diaspora buyer], [Confidence that the Jaffna mango or palmyra jaggery is genuinely from the named cooperative or family. Direct support to producers.],
  [Retailer abroad], [A defensible marketing claim and a reduced audit burden.],
)

== Technical Build

Phase 3 introduces several new technical components.

- *Lot tracking* — a structured representation of a production lot from origin through stages, with handoffs recorded by the participating party.
- *QR provenance pages* — a public-facing page per lot showing origin, journey, and verification tier of each claim.
- *Payment integration* — direct payments to producer accounts, with transparent fee structure.
- *Cooperative tools* — aggregation, grading, and member-payout workflows for cooperatives.
- *Exporter dashboard* — bulk lot creation, compliance documentation, buyer-facing reports.

== Pilots

Phase 3 launches with three pilots:

+ A single-orchard mango pilot with one exporter and one Canadian diaspora retailer, covering one harvest cycle.
+ A palmyra cooperative pilot with one cooperative of 20 to 50 craftspeople, with diaspora-direct sales.
+ A dried fish pilot with one fishing cooperative and one domestic premium retailer.

Each pilot runs for one full season before scaling.

== Funding for Phase 3

Phase 3 is the first phase with substantive commercial revenue.

- *Transaction fees* on platform-mediated payments (where the platform mediates payments at all — see below), in the range of one to two percent.
- *Subscription fees* from exporters using the platform for compliance documentation. A per-lot subscription with a variable success fee is preferred over a flat percentage, to align incentives with successful landed export rather than gross volume.
- *Co-funding* from agricultural development programs and trade promotion bodies.
- *Diaspora-direct premium* — a small premium on diaspora sales returned to producers and to platform operations.

== Payments, AML/KYC, and Foreign Exchange Posture

The decision of whether the platform handles funds at all is taken in Phase 0, with a strong default of *not* handling funds directly. The cleanest architecture is for Veḷi to provide traceability metadata and routing instructions, with payments executed through a licensed Sri Lankan payment-service provider (a licensed bank API, a licensed PSP such as Frimi or Genie) on the producer side and a licensed money-services business on the diaspora side. If the platform must handle funds itself, the following stack applies:

- *Financial Transactions Reporting Act No. 6 of 2006* registration and Financial Intelligence Unit (FIU) reporting obligations are documented and resourced before any payment functionality ships.
- *Know-Your-Customer* on every producer and exporter onboarded; sanctions screening against Sri Lankan, OFAC, EU, and UN lists; suspicious-transaction reporting per FIU rules.
- *Foreign Exchange Act* compliance for diaspora inward remittances; Central Bank of Sri Lanka inward-remittance reporting where applicable.
- *Counter-Terrorism Financing.* The platform operates in a post-conflict region with diaspora payment flows. CTF controls are pre-emptively designed in: source-of-funds checks on diaspora-side counterparties, transaction-size thresholds, and a relationship with a Sri Lankan AML/CTF lawyer engaged from Phase 0.
- *Tax.* VAT, withholding on payments to non-corporate producers, transfer-pricing if any offshore fundraising vehicle is used, and SVAT phase-out implications are mapped in a one-page tax memo by a Sri Lankan tax advisor in Phase 0.

== Anti-Collusion Controls

Once a platform-traced lot carries a price premium, lot creation becomes a target for collusion (mixing non-Jaffna mango into a "Jaffna mango" lot, mis-attributing produce between cooperative members, double-claiming). The platform implements:

- Random spot audits of lots, at a documented sampling rate per commodity per season.
- Time-and-location-attested photo capture at lot creation, anchored in the device-and-GPS provenance metadata of the shared identity layer.
- Public commodity-by-commodity lot-volume reconciliation against EDB export figures, published quarterly.
- A clear sanctions ladder for cooperatives or producers found to have falsified lot data, up to and including permanent removal from the platform.

== Success Metrics

- At least three exporters using the platform as primary traceability infrastructure.
- At least one diaspora retail partner per commodity vertical.
- Demonstrated price premium for platform-traced produce, of at least ten percent over comparable non-traced produce.
- Producer payout transparency: every participating producer can see their per-lot earnings.

== Risks for Phase 3

- *Cold-chain and logistics complexity.* The QR code is the easy part; the hard part is convincing logistics partners to scan and update. Mitigation: start with simple supply chains; invest in field operations to support handoffs.
- *Exporter resistance.* Some exporters benefit from supply chain opacity. Mitigation: target the exporters competing on quality and provenance, not the ones competing on price.
- *Producer onboarding overhead.* Small producers need support to participate. Mitigation: cooperative-mediated onboarding; field officers.
- *Counterfeit risk.* As the platform's provenance becomes valuable, counterfeit attempts will follow. Mitigation: tamper-evident packaging partnerships; spot audits.

// ============ SECTION 6 ============

= Phase 4 — Platform Consolidation (Months 42 to 60)

== Objectives

By Phase 4, the platform has three operating product lines, a household user base in the tens of thousands, an exporter and cooperative customer base, and a content and field operations team across the Northern Province. Phase 4 consolidates these into a coherent civic infrastructure platform with durable funding and governance.

== Consolidation Tracks

=== Unified Identity and Account

A household that uses the government navigation assistant, has documented its land, and sells palmyra jaggery through the platform should experience this as a single account, not three. Phase 4 invests in the unified household experience.

=== Cross-Product Insight

Anonymized aggregate data from the platform — which government services are most painful, which Divisional Secretariat divisions have the most land documentation activity, which agricultural commodities are commanding the highest premiums — becomes a public good in its own right. Phase 4 establishes a research and reporting function that publishes regular state-of-the-North reports.

=== Government Partnership Maturation

By Phase 4, the platform has earned standing with Divisional Secretariats and at least some line ministries. Phase 4 formalizes this through a small number of carefully scoped public partnerships — for example, a formal feedback channel to the Department of Registrar General, or co-development of a digital Grama Niladhari workflow.

=== Diaspora Engagement Maturation

Diaspora engagement evolves from one-off funding to a structured contribution model: diaspora members can sponsor specific Grama Niladhari divisions, fund documentation drives, or buy directly from named cooperatives. Phase 4 builds the diaspora portal and reporting infrastructure to make this credible.

=== Sustainability and Governance

The organisation transitions over Phases 3 and 4 from primarily grant-funded to a more balanced mix. The headline target for Phase 4 is a documented sustainability ratio rather than a hard percentage: grant funding declines as a share of total revenue while remaining the primary support for the household-facing services, commercial revenue from agricultural traceability and exporter services grows to at least 25% of total revenue, and paid services (legal partner referrals, surveyor fees, premium documentation) supplement the mix.

The single-funder concentration target is also stated honestly. A diaspora-foundation anchor is necessary for Phase 1, and that anchor will plausibly account for more than 30% of revenue through Phase 2. The Phase 4 commitment is therefore: by end of Phase 4, no single funder accounts for more than 40% of operational revenue, with a documented glide path from the Phase 1 anchor share toward that target. The exact percentages are reset annually based on the actual funding mix and published in the annual report.

A formal governance structure is in place from Phase 2 (not deferred to Phase 4): a board with local civil society, diaspora, and academic representation, meeting at least quarterly, with published minutes.

== Success Metrics

Phase 4 metrics also use a base / stretch / heroic ladder. The base case represents commitment to funders; stretch and heroic are aspirational.

#table(
  columns: (auto, auto, auto, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right, right, right),
  table.header(
    [*Metric*], [*Base*], [*Stretch*], [*Heroic*],
  ),
  [Monthly active household users], [25,000], [50,000], [100,000],
  [Documented land evidence packages], [5,000], [12,000], [20,000],
  [Exporter customers using the traceability platform], [3], [5], [8],
  [Cooperative customers], [5], [10], [15],
)

In addition: a balanced funding mix with no single funder providing more than a documented threshold of revenue (see Section 9 funding plan); a published, peer-reviewed annual report on Northern civic infrastructure.

// ============ SECTION 7 ============

= Cross-Cutting Concerns

Several concerns cut across all phases and require sustained attention rather than phase-specific treatment.

== Language and Cultural Fit

Tamil-first means more than translation. It means colloquial Jaffna Tamil rather than literary or Indian Tamil; it means voice interfaces for elderly users; it means content review by people who grew up in the Northern Province; it means cultural awareness in iconography, examples, and tone. The platform invests in a Tamil content lead from Phase 0 onward.

== Privacy, Data Protection, and Data Sovereignty

The platform holds increasingly sensitive data: government service queries, land documents, agricultural payment flows. Compliance with the Personal Data Protection Act No. 9 of 2022 (as amended by Act No. 22 of 2025) is the floor, not the ceiling. Three principles govern this:

+ *User-controlled access.* The household, not the platform, decides who sees their documents. The platform is a custodian, not an owner.
+ *In-country data residency.* The platform self-hosts on private infrastructure at Tier III Colombo colocation facilities. All primary data (PostgreSQL, object storage) and live read replicas are in Sri Lanka. Encrypted offsite backup is held at a secondary in-country site. A tertiary encrypted backup outside Sri Lanka is permitted only with an explicit PDPA §26 cross-border-transfer instrument, only for disaster recovery, and never for live read.
+ *Minimal collection.* The platform collects what it needs to deliver the service and no more. Analytics are aggregated and anonymised.

PDPA-specific commitments, which become operational obligations from Phase 0:

- *Data Protection Officer.* A DPO is appointed (fractional outside counsel acceptable in Phase 0; in-house from Phase 2). The DPO is named publicly with a contact address.
- *Registration.* The platform registers with the Data Protection Authority once the registration regime is operational, and updates the registration on every material change to processing.
- *Lawful basis.* Each processing activity has a documented lawful basis under the PDPA. Special categories (political opinions, religious belief, biometric, children's data) are processed only where explicitly justified and consented.
- *Data Protection Impact Assessment.* A DPIA is completed before each phase launch and updated annually thereafter.
- *Data subject requests.* The platform commits to the PDPA §17 21-working-day response window for access, correction, erasure, and objection requests.
- *Cross-border transfers.* Live operations do not transfer data outside Sri Lanka. The only permitted cross-border flow is the encrypted tertiary disaster-recovery backup, governed by a documented §26 instrument; the user is informed of this in the privacy notice.
- *Processor relationships.* The IVR, USSD, and SMS surfaces route through hSenid Mobile (the underlying VAS platform behind Ideamart by Dialog and the multi-operator services). hSenid is treated as a data processor under the PDPA controller-processor framework. A written processing agreement is in place from launch covering purpose limitation, sub-processor consent, security obligations, breach notification, and end-of-engagement data return or destruction. All processing is on Sri Lankan infrastructure.
- *Children's data.* School admission, scholarship, and any minor-related service flows include a parental-consent gate, and the data is processed under elevated lawful-basis controls.
- *Breach notification.* The platform commits to notification timelines required by the Authority, with a documented incident-response process and a named on-call function.

== Online Safety Act Exposure

The platform's user-generated content surfaces (witness statements, government-service summaries, public QR provenance pages) create exposure under the Online Safety Act No. 9 of 2024. Because the platform does not route through any third-party messaging intermediary, all content moderation responsibility falls on Veḷi directly; there is no Meta or other intermediary to share that responsibility. The platform maintains an OSA exposure register listing every such surface, the takedown SLA (24 hours from a valid Online Safety Commission directive), the legal partner escalation path, named on-call moderation responders, and a public archive of every removal action for transparency. The corporate structure for content liability is decided in Phase 0 (see Section 8 governance).

== Procedural Rigour and Public Accountability

The platform operates in a politically charged region in which strict "neutrality" — taking no position on any contested matter — is not a stance a civic platform working on land, government services, and supply chains can credibly hold. The discipline the platform commits to instead is *procedural rigour* and *public accountability*:

- Decisions about scope inclusion and exclusion (e.g., which land cases the platform will and will not document) are made against published written criteria, not case-by-case discretion.
- An anonymised public log of every excluded case is published quarterly, with the criteria invoked.
- The platform does not partner with explicitly partisan organisations.
- The platform is transparent about every funder, including funder name, amount band, and any restrictions.
- Where neutrality cannot be maintained on a specific case, the platform recuses itself with a written statement and refers the household to its legal partners.

This discipline is not optional. The platform's standing across communities, government counterparts, and diaspora funders rests on the belief that its rules are knowable in advance and applied consistently.

== Security

The platform is a high-value target by Phase 2 due to the sensitivity of land documents. Because the platform self-hosts, the entire security stack — from physical hardware to network perimeter to application — is the team's responsibility. There is no managed-cloud security baseline to inherit. Security investment scales accordingly:

- Encryption is implemented in three explicitly named layers (transport, at-rest, true end-to-end) per the architecture specification in Phase 0. True end-to-end encryption is used for all sensitive land and identity documents, with per-user keys derived on-device and never held in clear by the backend.
- Physical and network security at the colocation site: locked cages, biometric access logs, segmented private networking, hardware firewall, intrusion detection, and a documented patch-management cadence.
- An independent security audit before Phase 2 launch and annually thereafter, scoped to cover physical, network, application, and data-handling controls.
- A formal incident response process from Phase 1 onward, with named on-call responders and a documented breach-notification SLA aligned with PDPA Authority requirements.
- Bug bounty programme from Phase 3 onward.
- Account-takeover response and identity-recovery audit are part of incident response from Phase 1.
- A site-reliability function staffed from Phase 0 (see Section 8 team), responsible for the operational integrity of the self-hosted stack.

== Custodianship and Exit

The platform is a custodian of evidence packages that, for many households, are the only digital record of land claims, displacement history, and oral history. The platform's failure or pivot must not destroy that record. Because the platform self-hosts, custodianship is not just a data-handover problem — it is a physical-hardware-handover problem. The following commitments are designed in from Phase 0:

- *User self-export.* Every user can export their complete evidence package, in a documented open format (PDF + JSON metadata), at any time, without payment.
- *Data trust deed.* Cloud Parallax executes a written trust deed in Phase 0 naming an institutional successor (e.g., the Jaffna Bar Association, the University of Jaffna, or a Sri Lankan charitable trust under the Trusts Ordinance) that contractually inherits the data store, the colocation contract, and operational responsibility on dissolution or material pivot. The trust deed is structured so the successor can take over the running self-hosted stack without service interruption, including transfer of colocation contracts, hardware ownership, and operational runbooks.
- *Operational continuity package.* A documented runbook covering hardware inventory, network topology, vendor contracts, encryption-key custody, and on-call rotation is held in escrow with the legal partner from Phase 1, so the institutional successor can operate the platform from day one of any transition.
- *No silent shutdown.* If the platform is wound down, users receive at least 180 days written notice in Tamil and English, with active assistance to export and migrate their packages.

== Insurance and Liability

The platform documents land evidence that households may rely on, processes payments to producers, and surfaces government-service information that may be wrong. Liability exposure is addressed explicitly:

- *Professional indemnity / errors and omissions* coverage for content errors and platform-mediated advice, in place from Phase 1.
- *Cyber liability* coverage from Phase 1, scaled at Phase 2 launch when document volume becomes material.
- *Media liability* coverage from Phase 1 to address Online Safety Act and defamation exposure on user-generated content.
- *User Agreement* with a defined liability cap, an explicit warranty disclaimer that does not exclude statutory rights under the PDPA, and a clear arbitration clause.
- *Indemnity.* The platform does not indemnify users against third-party legal action arising from content they themselves uploaded.

== Openness and Licensing

The Veḷi name and the "Open. Clear. Civic." tagline commit the platform to an explicit licensing posture:

- *Code:* Apache-2.0 for client and SDK code; AGPL-3.0 for server code, with a documented closed-source carve-out for KYC, AML, and payments modules where regulatory or partner constraints require it.
- *Content templates and procedure schemas:* Creative Commons Attribution-ShareAlike (CC-BY-SA-4.0).
- *Aggregated, anonymised data:* published as open data under a defined licence, with re-identification controls.
- *User documents and personal data:* never open. Always private to the user.

== Accessibility

The Northern Province population the platform serves includes elderly residents, low-literacy users, and people without smartphones. Accessibility is not a compliance checkbox but a primary design constraint:

- A Tamil-language IVR, a USSD application, and an SMS short-code service deliver Phase 1 information lookups via Ideamart and hSenid Mobile multi-operator APIs (Dialog, Mobitel, Hutch). These channels work on any feature phone, require no installation, no internet, and no URL typing, and are the primary accessibility surface for users without smartphones. IVR voice prompts are recorded by a Northern Province native voice talent.
- A trained-helper telephone hotline routes any case the automated channels cannot handle to a human, using the same content base as the PWA and IVR so the answer is consistent regardless of channel.
- Trained helper programmes in every operational division install the PWA on residents' phones, dial the USSD code with them, and operate the assistant on their behalf where needed.
- Print and radio companion materials advertise both the URL and the shortcode for non-digital reach.
- Explicit support for low-end Android devices and intermittent connectivity (the PWA caches and reconciles offline).
- WCAG 2.1 AA conformance as an internal target for the PWA, including Tamil-screen-reader testing.

// ============ SECTION 8 ============

= Organization, Team, and Governance

== Corporate Form and Conflict of Interest

Cloud Parallax (Pvt) Ltd is a private commercial entity. Veḷi is a civic platform with grant-funded components and household custodianship obligations. The relationship between the two must be settled before Phase 0 capital is committed. The default options under consideration are:

+ *Separate Veḷi Foundation.* Veḷi is incorporated as a guarantee company under the Companies Act No. 7 of 2007 (a "company limited by guarantee"), or as a charitable trust under the Trusts Ordinance. Cloud Parallax licenses the underlying IP to the foundation under a perpetual, royalty-free, public-benefit licence. This is the cleanest answer for funder due diligence and for the custodianship deed (see Section 7).
+ *Cloud Parallax operating division with firewall.* Veḷi remains a product line of Cloud Parallax, with a written conflict-of-interest policy, a related-party-transactions register, and a contractual firewall between Veḷi and other Cloud Parallax commercial activities (notably the EV / OCPP / CSMS line). This is faster but exposes Veḷi to commercial-side risk.
+ *Hybrid.* Cloud Parallax operates Veḷi initially under option 2, with a written commitment and a target date to transition to option 1 once funding scale justifies the structural cost.

The decision is made in Phase 0 in consultation with the legal partner and the anchor diaspora foundation funder. Whichever option is chosen, a written conflict-of-interest policy and related-party-transactions register are in place from Phase 0.

== Founding Team (Phase 0 to early Phase 1)

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Role*], [*Responsibilities*],
  ),
  [Executive lead], [Strategy, partnerships, funding. Cloud Parallax leadership role.],
  [Technical lead], [Architecture, engineering team, application development. Go background.],
  [Site reliability / infrastructure lead], [Self-hosted private infrastructure, colocation operations, PostgreSQL HA, security hardening, incident response. This role is non-optional given the self-hosted posture.],
  [Field operations lead], [Community engagement, trained helper network, NGO partnerships. Northern Province native.],
  [Tamil content lead], [Content strategy, content operations team. Journalism or civil society background.],
  [Partnerships and funding lead], [Grant pipeline, diaspora engagement, government relations.],
)

== Mid-stage Team (Phase 1 to Phase 2)

Adds two to three Tamil content writers, two field verifiers, two engineers, one designer, and a second site-reliability engineer (the self-hosted stack cannot run on a single SRE indefinitely; on-call rotation requires at least two). Total team approximately ten to thirteen.

== Mature Team (Phase 3 to Phase 4)

Adds an agricultural supply chain lead, a legal partnerships coordinator, a research and reporting lead, additional engineers, and field officers in each operational Divisional Secretariat division. Total team approximately twenty to twenty-five.

== Operating Cadence

- Weekly leadership operations review.
- Monthly content freshness audit.
- Quarterly strategic review with board.
- Annual public report.

// ============ SECTION 9 ============

= Funding Plan

== Phase 0 Funding (Months 0 to 3)

Phase 0 is funded by a combination of Cloud Parallax internal investment and a small seed grant from a diaspora foundation. Indicative budget covers field research, partnership development, founding team for one quarter, and initial hardware capital expenditure for the self-hosted infrastructure (rack space at the primary Tier III colocation site, baseline compute and storage, network equipment). Hardware CAPEX is non-trivial — typical lower-bound for a redundant two-site PostgreSQL + Ceph baseline is in the order of LKR 8–15M (USD 25–50k) for entry-grade hardware, before colocation rental and network bandwidth — and is budgeted explicitly rather than absorbed into operations.

== Phase 1 Funding (Months 3 to 15)

Phase 1 is grant-funded. The plan targets:

- One anchor multi-year grant from a diaspora foundation, covering core operations.
- One or two project grants from multilateral or bilateral programs.
- Modest in-kind support from academic and NGO partners.

== Phase 2 Funding (Months 15 to 33)

Phase 2 funding is mixed: continued grant funding for the household service, plus modest paid services for authority-attested documents.

== Phase 3 Funding (Months 24 to 42)

Phase 3 introduces commercial revenue: transaction fees on platform-mediated payments, exporter subscription fees, diaspora-direct premiums. Grant funding continues for the household-facing services.

== Phase 4 Funding (Months 42 to 60)

Phase 4 establishes a balanced funding mix targeting durable independence from any single funder.

== Funder Map

#table(
  columns: (auto, 1fr, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Funder type*], [*Examples and scope*], [*Phase*],
  ),
  [Diaspora foundations], [Tamil community foundations in Canada, the UK, Australia. Anchor funders.], [0 to 4],
  [Multilateral programs], [UNDP access-to-services, UN Women, World Bank social protection.], [1 to 3],
  [Bilateral programs], [GIZ digital governance, FCDO, USAID where relevant.], [1 to 3],
  [Sri Lankan government], [Carefully scoped partnerships; not core funding.], [2 onward],
  [Commercial revenue], [Transaction fees, exporter subscriptions, paid services.], [2 onward],
  [Academic and CSR], [University of Jaffna; Sri Lankan corporate CSR for specific drives.], [1 onward],
)

// ============ SECTION 10 ============

= Risk Register

== Strategic Risks

- *Mission drift.* The organisation, under funding pressure, drifts from civic mission into pure commercial work. Mitigation: governance structure with civil society representation; published mission and annual mission audit.
- *Political capture.* A funder or partner with a political agenda gains disproportionate influence. Mitigation: funder diversification; refusal of conditional grants; published funder-name and amount-band register.
- *Founder dependency.* Loss of a founder collapses the organisation. Mitigation: documented operating playbooks; deputy roles from Phase 2; written leadership succession plan.
- *Conflict of interest.* Cloud Parallax commercial interests bleed into Veḷi decisions. Mitigation: corporate form decision in Phase 0 (see Section 8); written conflict-of-interest policy and related-party-transactions register.

== Regulatory Risks

- *Online Safety Act exposure.* User-generated content (witness statements, government-service summaries, QR provenance pages) draws an OSC removal directive or "false statement" complaint. Mitigation: OSA exposure register; 24-hour takedown SLA; legal partner escalation; corporate-structure separation of content infrastructure.
- *PDPA non-compliance.* Failure to register, appoint a DPO, or honour data-subject requests within the §17 21-working-day window. Mitigation: PDPA compliance scaffolding from Phase 0; annual DPIA; named DPO.
- *Cross-border-transfer breach* of the encrypted DR backup. Live operations remain in Sri Lanka; only the encrypted tertiary disaster-recovery backup may sit outside the country. Mitigation: documented §26 instrument; encryption at rest with keys held in-country; access logged and audited.
- *AML/CTF or FX violation* in Phase 3. Mitigation: prefer not to handle funds; if funds handled, full AML/KYC stack and AML/CTF lawyer engaged from Phase 0.

== Operational Risks

- *Content rot* in the government-navigation product. Mitigation: aggressive verification cycle; public last-verified dates; user-feedback discrepancy loop.
- *Field officer turnover* in remote divisions. Mitigation: deputy roles; documented playbooks; community-anchored hiring.
- *Translation and cultural-fit failures* in Tamil content. Mitigation: Jaffna-Tamil content lead from Phase 0; multi-faith content review board; structured intent corpus rather than free-form generation.
- *Connectivity and infrastructure failures* in the Northern Province. Mitigation: offline-first capture flows in the PWA; trained-helper-mediated telephone hotline as alternative path for users without smartphones; documented disaster recovery (RPO ≤ 24h, RTO ≤ 4h) from Phase 1.
- *Custodianship failure.* Platform shuts down without successor in place. Mitigation: data trust deed executed in Phase 0; user self-export from day one; 180-day notice commitment.

== Technical Risks

- *Document security incidents.* Mitigation: layered encryption per architecture spec; annual independent security audit from Phase 2; bug bounty from Phase 3; named on-call incident responder.
- *Identity takeover* via SIM swap or number reassignment. Mitigation: m-of-n guardian recovery protocol; 72-hour cooling-off; in-person partner-lawyer attestation as alternative path; user-visible audit log.
- *Tamil NLP failures and embarrassing misclassifications.* Mitigation: structured task router architecture; conservative confidence thresholds; human handoff for low-confidence intents.
- *Scaling failures during seasonal agricultural peaks.* Mitigation: seasonal load testing; commodity-specific runbooks; cooperative-mediated onboarding to smooth load.
- *Self-hosted infrastructure failure.* Hardware failure, colocation provider default, network outage, or operational incident takes the platform down. The team carries the full operational load that a managed cloud would otherwise provide. Mitigation: two-site HA architecture from Phase 0; named site-reliability function staffed from Phase 0 and doubled for Phase 2 on-call; documented runbooks; annual disaster-recovery exercise; vendor diversity in colocation, network, and hardware where feasible.
- *Operational-burden creep.* The team underestimates the ongoing operational cost of self-hosting (patching, monitoring, on-call, capacity planning) and engineering capacity is consumed by infrastructure rather than product. Mitigation: explicit budget tracking of SRE versus product engineering hours; willingness to colocate-with-managed services (e.g., a managed-Postgres provider operating in a Sri Lankan colocation) if the burden becomes unsustainable.

== Reputational and Legal Risks

- *Misuse of the platform's evidence in legal disputes.* Mitigation: tier-explicit legal-effect labelling; user agreement liability cap; legal partner advisory.
- *Perceived political alignment.* Mitigation: procedural-rigour stance with published criteria and exclusion log; transparent funder register; recusal protocol.
- *Failure to deliver on a high-profile pilot.* Mitigation: base/stretch/heroic target ladder reported to funders; pilots dropped rather than scaled if criteria not met.
- *Adoption shortfall on smartphone PWA channel specifically.* The IVR and USSD channels via Ideamart and hSenid largely mitigate the broader discoverability risk by reaching feature-phone users with no install. The remaining risk is that smartphone PWA adoption underperforms — limiting Phase 2 (which is PWA-only) reach. Mitigation: trained-helper programme drives PWA install on smartphones encountered in the field; printed-QR distribution; Tamil-keyword SEO; PWA install rate is tracked separately from total channel usage so funder-facing metrics are not flattered by IVR session counts.
- *Telco platform dependency.* The IVR/USSD/SMS channel depends on Ideamart and hSenid commercial relationships continuing on workable terms. Mitigation: dual-aggregator engagement (Ideamart for Dialog, hSenid for Mobitel and Hutch); written agreements with documented commercial-change notice periods; PWA channel under full Veḷi control as an independent fallback.
- *Supply-chain rejection* (Phase 3 commodity rejected at destination, e.g., mango stem-end rot, dried fish histamine). Mitigation: platform's role narrowly scoped to provenance metadata, never quality guarantee; per-lot subscription rather than flat percentage; exporter holds all phytosanitary, SLSI, and Department of Fisheries licences.

Each risk has an owner in the leadership team and is reviewed at the quarterly strategic review. The full register is maintained in a versioned document and updated at every quarterly review.

// ============ SECTION 11 ============

= Conclusion

The plan outlined here is a long, patient bet on the proposition that Sri Lanka's Northern Province deserves civic infrastructure built for and with its residents — in their language, on their terms, and at their pace. The technical work is real but tractable. The operational and institutional work is harder and is where most of the team's energy will go.

Sequenced correctly, the platform delivers daily utility from Phase 1, becomes durable civic infrastructure by Phase 2, generates commercial revenue from Phase 3, and consolidates into a self-sustaining institution by Phase 4. Sequenced incorrectly, it dilutes into a collection of half-built features.

The first decision is the smallest one: commit to Phase 0. Six weeks of field research and three months of foundation-building will tell the team, and its funders, whether the rest of this plan deserves to be built.

#v(2em)

#align(center)[
  #line(length: 30%, stroke: 0.5pt)
  #v(0.5em)
  #text(9pt, fill: gray, style: "italic")[
    End of plan.
  ]
]
