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

- A small team of five to seven people through Phase 0 and early Phase 1, growing to roughly fourteen to seventeen by end of Phase 2 and thirty to forty by end of Phase 3. The team includes a dedicated infrastructure / site-reliability function from Phase 0 because the platform self-hosts on private infrastructure (see Section 7). Earlier internal drafts of this plan understated team size; the figures above are what the plan as currently scoped actually requires.
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
- *Legal partner* — a Jaffna-based law firm or legal aid organisation willing to advise on land documentation scope and limits. The partner panel must include practitioners with active Thesawalamai practice, since most Jaffna Tamil families' inheritance and property arrangements are governed by Thesawalamai customary law rather than Roman-Dutch general law alone (see Phase 2 product definition).
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
  [Static asset delivery], [PWA static assets (HTML, CSS, JS, fonts, IVR audio shared with the in-PWA preview) are served via a Sri Lankan CDN edge (SLT, Dialog, or LankaSettle equivalent) for low-latency delivery to Northern Province connections. Static assets contain no personal data, so this does not violate the in-country residency commitment. API calls and document storage remain on the self-hosted backend in colocation.],
  [Load testing], [Quarterly load tests in Phase 1 against representative seasonal patterns (school admission peaks in February, NIC drives, Samurdhi enrollment windows). Load tests target 10× current MAU. Phase 2 land-documentation drives generate seasonal upload spikes that must be load-tested before each campaign.],
)

== Deliverables

+ Field research report with prioritised findings.
+ Signed memoranda of understanding with two NGO partners and one diaspora foundation; written commitment from the legal partner and the academic partner.
+ Architectural specification document for the shared identity and document layer, including the self-hosted infrastructure design (two-site Tier III colocation, HA PostgreSQL, Ceph or MinIO object storage, network architecture), the multi-channel access design (PWA + IVR + USSD + SMS), the three-layer encryption model, and the identity recovery protocol.
+ Colocation provider selection and signed contracts with a primary and secondary in-country site; baseline hardware procurement plan and order placed.
+ Telco aggregator setup: Ideamart shortcode and USSD code allocated against Cloud Parallax's existing developer account; hSenid Mobile commercial agreement signed for Mobitel and Hutch coverage; PDPA controller-processor agreement in place; commercial discussion opened with operators on civic-content zero-rated billing.
+ Tamil IVR voice generation pipeline: Amazon Polly Neural TTS configured. Before any lexicon build for the top-20 procedures, a *TTS validation gate* renders ten representative prompts (covering high-frequency phonemes, place names, common procedure terms, and Jaffna-specific vocabulary) and tests them with a panel of seven Northern Province native speakers across age and education profiles. The panel rates each prompt for intelligibility and dialect appropriateness on a documented rubric. The lexicon build for top-20 procedures proceeds only if at least five of seven panellists rate the validation prompts as acceptable; if not, the fallback is a small set of human-recorded prompts for highest-traffic procedures, with TTS reserved for less critical content. Codec compatibility validated against Ideamart's IVR pipeline (8 kHz mu-law).
+ AI agents and hosted inference: Google Cloud project provisioned for Vertex AI; Cloud Data Processing Addendum (CDPA) executed as the PDPA §26 instrument; de-identification service designed, implemented, and tested against representative Tamil payloads; AI agents architecture document signed off by the founder (Section 8); Phase 0 evaluation gate executed against `gemma4:e4b`, `gemma4:26b`, and `gemma4:31b` on a Jaffna Tamil eval set of at least 100 utterances, with documented Outcome A/B/C recommendation. The AI Studio API key is used for evaluation only; no production traffic flows during Phase 0.
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
- *Voice and messaging surface (feature phone):* A Tamil-language IVR, a USSD application, and an SMS short-code service delivered through Ideamart by Dialog Axiata and hSenid Mobile multi-operator APIs (covering Dialog, Mobitel, and Hutch). Cloud Parallax already holds an active Ideamart developer account; Phase 0 needs only shortcode and USSD code allocation, plus the hSenid commercial agreement for Mobitel and Hutch coverage. The aim is zero-rated billing for civic content (no charge to the user) where the operator commercial framework permits; otherwise a sponsored-session model.
- *Voice prompt generation:* IVR prompts are generated using Amazon Polly Neural TTS with SSML phoneme overrides. Polly's default Tamil voice is trained on Indian Tamil; a maintained Jaffna Tamil pronunciation lexicon (a versioned mapping of Tamil words and phrases to IPA / x-sampa phoneme sequences via SSML `<phoneme>` tags) corrects pronunciation to colloquial Jaffna register on a word-by-word basis. The lexicon is a first-class content artifact owned by the Tamil content lead, reviewed by Northern Province natives, and versioned alongside the procedure content. Prompts are pre-rendered offline as 8 kHz mu-law audio files (the standard IVR codec, natively supported by Polly), hashed by content and lexicon version, and cached in self-hosted object storage. Polly is therefore an offline content-authoring tool only — at call time the IVR plays cached audio served from Sri Lanka, and no user data ever flows to AWS.
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

The Phase 1 operational budget includes an explicit line for IVR, USSD, and SMS shortcode costs payable to Ideamart and hSenid Mobile, modelled bottom-up as follows.

#table(
  columns: (1fr, auto, auto, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right, right, right),
  table.header(
    [*Channel*], [*Sessions/MAU/month*], [*LKR/session*], [*Annual cost at 5k MAU base case*],
  ),
  [USSD], [4], [≈ 0.50], [120,000],
  [IVR (90s avg)], [2], [≈ 8.00], [960,000],
  [SMS (in + out)], [3], [≈ 1.20], [216,000],
  [Aggregator monthly platform fee], [—], [—], [600,000],
  [*Annual Phase 1 telco cost (prudent case, no zero-rating)*], [], [], [*1,896,000*],
)

These numbers are indicative and are anchored to publicly observable Ideamart and hSenid pricing as of mid-2025; final numbers depend on the commercial conversation with operators in Phase 0. The base case assumes commercial negotiation succeeds in zero-rating civic content (no charge to user, no charge to platform) at least for Dialog, the largest operator — which would reduce the table above by approximately 60%. The prudent case assumes per-session and per-SMS fees apply, in which case channel cost monitoring and gating are activated and the IVR path is throttled to budget while the PWA channel remains free. At Phase 4 stretch (50k MAU), the prudent-case telco line scales to roughly LKR 19M/year and zero-rating becomes commercially material rather than nice-to-have.

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
- *TTS pronunciation quality on the IVR.* Polly's default Tamil voice renders Indian Tamil; Jaffna register requires manual phonetic overrides via SSML, and some phonemes or prosody patterns may not be reproducible to native-listener satisfaction. Mitigation: maintained Jaffna pronunciation lexicon owned by the Tamil content lead; native-listener review panel signs off every prompt before publication; per-prompt user-feedback survey on the IVR ("வழங்கல் தெளிவாக இருந்ததா?" / "Was the message clear?"); fallback to a small set of human-recorded prompts for the highest-traffic procedures if TTS quality is consistently rated below threshold.
- *Telco platform policy or pricing change.* Ideamart or hSenid changes its commercial terms, withdraws zero-rated billing for civic content, or imposes new content rules. Mitigation: agreements with both Ideamart and hSenid (vendor diversity); SMS shortcode and USSD code retained as fallback paths; ability to relocate IVR to an alternative VAS aggregator within 90 days; PWA channel remains under full Veḷi control regardless.
- *IVR/USSD operational cost overrun.* Per-session and per-SMS costs scale linearly with adoption; if zero-rated billing is not granted by operators, costs to the platform grow rapidly. Mitigation: explicit per-channel cost monitoring from Day 1; ability to throttle or gate the IVR path if costs exceed budget while the PWA remains free; early commercial negotiation with operators for civic-content zero-rating.
- *Self-hosted infrastructure load on a small team* — the engineering team is consumed by infrastructure work rather than product. Mitigation: dedicated site-reliability lead from Phase 0; budget tracking of SRE versus product engineering hours; willingness to relocate workloads to a managed Sri Lankan provider if operational burden becomes unsustainable.
- *Funding lumpiness* — grants are unpredictable. Mitigation: diversified grant pipeline; modest run-rate.

// ============ SECTION 4 ============

= Phase 2 — Land and Property Documentation (Months 15 to 33)

== Product Definition

A community-driven, notary-assisted platform that helps Northern Province households assemble and preserve evidence relevant to land and property ownership. The platform does not adjudicate ownership, does not replace the formal land registry, and does not create legal title. Under Sri Lankan law (Prevention of Frauds Ordinance No. 7 of 1840 §2, Notaries Ordinance), the only attestation that creates legal effect for transferring or mortgaging immovable property is a deed attested by a notary public before two witnesses present at the same time. Veḷi's role is therefore to produce a structured "deed-ready bundle" — photographs, GPS coordinates, witness statements, scanned deeds and notarial documents, oral history, version history — that a partner notary can use to draft a notarial instrument or that a household, lawyer, or court can reference. The bundle alone is not title evidence and is never marketed as such.

Most Jaffna Tamil families' inheritance and property arrangements are governed by *Thesawalamai*, the customary personal law applied to Tamils of the Northern Province under the Thesawalamai Code of 1707 and subsequent legislation. The platform's documentation flows are designed for Thesawalamai realities, not Roman-Dutch general law alone. This means support for Thesawalamai-specific evidence types — joint family property (*muthusam*), property acquired during marriage (*thediathettam*), dowry property (*chidenam*), and the spousal-consent requirements of the Jaffna Matrimonial Rights and Inheritance Ordinance — and a legal partner panel that includes practising Thesawalamai practitioners. Households following Roman-Dutch general law (a minority in the Northern Province but not negligible) are also supported with the appropriate evidence flows.

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

Phase 2 field operations are heavier than Phase 1 and serve a critical accessibility role. Households without smartphones — a meaningful share of the Phase 2 target population, including elderly users, returnees, and women heads of household — cannot upload documents, capture GPS, or sign witness statements through the PWA on their own. Field operations close that gap.

- A network of trained community documentation officers — resident officers in five priority Divisional Secretariat divisions and mobile officers covering remaining divisions — who help households assemble evidence packages. Officers carry rugged Android tablets running the PWA in proxy mode: the officer authenticates with their own identity, captures the household's documents and GPS data on their tablet, and the resulting upload is attributed to the household with the officer recorded as the capture intermediary. This is a documented, audited flow with explicit household consent at each step.
- A panel of partner lawyers and notaries (including Thesawalamai practitioners) willing to provide first-consultation advice at reduced rates.
- Mobile documentation drives in returnee communities, in partnership with NGO partners.
- A telephone-mediated path for households who cannot travel to a documentation officer or be visited by one: the household calls the trained-helper hotline, the helper schedules an officer visit, and the household receives a printed appointment slip via the GN office.

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

Phase 3 is the first phase with substantive commercial revenue, modelled bottom-up rather than asserted. Three commodity verticals, each with conservative volume and pricing assumptions, produce the following indicative annualised revenue ladder by end of Phase 3:

#table(
  columns: (1fr, auto, auto, auto, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right, right, right, right),
  table.header(
    [*Vertical*], [*Lots/season*], [*USD GMV/lot*], [*Platform fee*], [*Annual revenue (USD)*],
  ),
  [Jaffna mango — 1 exporter, 1 diaspora retailer], [120], [800], [4% per-lot subscription + success fee], [3,840],
  [Palmyra — 1 cooperative, diaspora-direct], [200], [400], [5%], [4,000],
  [Dried fish — 1 cooperative, domestic premium], [300], [250], [3%], [2,250],
  [Exporter platform subscriptions (3 exporters)], [—], [—], [USD 200/month each], [7,200],
  [Diaspora-direct premium share], [—], [—], [—], [3,000],
  [*Phase 3 base-case annual revenue*], [], [], [], [*≈ 20,300*],
)

This is approximately USD 20k per year, not USD 200k. The plan does not pretend otherwise. At base case, commercial revenue covers roughly 10–15% of Phase 3 operating costs, not the 40% cited in earlier internal drafts. The Phase 4 funding-mix target was revised in v1.1 to a glide-path commitment ("≤40% from any single funder by end of Phase 4") rather than a hard 40/40/20 split, which this bottom-up model supports.

The path to materially higher commercial revenue is not more commodities or higher fees but more exporters and more diaspora retailers per vertical. The stretch case (5 exporters per vertical, 5 diaspora retailers, 3× the base-case lot volume) lands at roughly USD 75–100k per year, which begins to materially reshape the funding mix. That stretch case is a Phase 4 ambition, not a Phase 3 commitment.

Funding sources accordingly:

- *Per-lot subscription* with a small success fee on platform-mediated payments (where the platform mediates payments at all; default is *not* to handle funds — see below).
- *Exporter subscription* of approximately USD 200/month per exporter for compliance documentation tooling.
- *Co-funding* from agricultural development programs and trade promotion bodies; this remains the largest commercial funding source through Phase 3, not transaction fees.
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
- *Cross-border transfers.* User-identifying data does not transfer outside Sri Lanka. The permitted cross-border flows are: (a) the encrypted tertiary disaster-recovery backup, governed by a documented §26 instrument; (b) offline content-authoring calls to Amazon Polly to render Tamil IVR prompts from procedure text (no personal data); and (c) live AI-agent inference calls to Vertex AI Model-as-a-Service under the Google Cloud Data Processing Addendum, where every payload is de-identified at the application boundary before transmission (NIC, phone numbers, GPS, witness names, and payment identifiers are stripped; only de-identified Tamil text and OCR images flow to the inference region). All three flows are described in the privacy notice. The full architecture and guardrails for the inference flow are specified in Section 8 (AI Agents and Hosted Inference).
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

== Identity Recovery Protocol

Phone-anchored identity in Sri Lanka faces a real attack surface: SIM swap fraud, mobile-operator number reassignment after 90–180 days of inactivity, and lost or stolen handsets. The recovery protocol is specified in detail rather than left as policy intent.

*Guardian designation.* At registration, every user designates two guardians from their existing platform contacts (typically family members or community members already on the platform). A user may add or remove guardians at any time, with a 7-day delay before changes take effect. Guardians receive a notification when designated and may decline.

*Recovery initiation.* When a user loses access to their identity-anchored phone, they initiate recovery from any device by entering their NIC number (if linked) or a recovery passphrase set at registration. The platform verifies the request via out-of-band confirmation to both designated guardians.

*m-of-n approval.* Both guardians must independently approve the recovery within a 96-hour window using their own platform identity. Approval is not automatic; the platform presents the requesting party's information (new phone number, geographic area, time of request) for the guardian to review.

*Cooling-off and notification.* Once both guardians approve, the platform enters a 72-hour cooling-off period during which the recovery is reversible by the original account holder if they regain access to their phone. The original phone number receives daily notifications of the pending recovery; the new device is informed that recovery will complete on a specified date.

*Alternative path: notary attestation.* Users without two reachable guardians (e.g., elderly users, recent returnees) can recover via a partner-lawyer or notary attestation. The user attends in person with NIC and any supporting documents; the partner submits a signed attestation through their platform credential. The 72-hour cooling-off applies equally.

*Audit and dispute.* Every recovery action is logged to a user-visible audit trail with timestamps, guardian identities, and method (m-of-n or notary). A dispute window of 30 days from completion allows the original account holder to flag a recovery as fraudulent; flagged disputes trigger an account freeze and human review by the incident response function.

*Anti-collusion.* Guardians cannot be a single household by default (the platform warns at designation time). The platform monitors for suspicious patterns — clusters of guardian relationships, repeated guardian-pair recoveries — and surfaces these to the security function.

This protocol is implemented and exercised before Phase 2 launch, when the platform begins holding sensitive land documents.
- A site-reliability function staffed from Phase 0 (see Section 8 team), responsible for the operational integrity of the self-hosted stack.

== Trained-Helper Programme

The trained-helper network is operationally significant — it drives PWA install on smartphones, mediates IVR/USSD adoption, and in Phase 2 provides the documentation-officer-mediated capture path for households without smartphones. Treating it as a free volunteer pool is the failure mode of comparable civic-tech programmes; the platform invests in it as a managed function from Phase 1.

*Recruitment criteria.* Helpers are recruited via the NGO partner from existing volunteer networks (community centres, libraries, GN office staff, religious-community volunteers, returnee community leaders). Each helper must be a Tamil-speaking resident of the GN division they serve, must have basic smartphone literacy, must pass a 90-minute orientation, and must commit to a minimum of four hours per week.

*Training curriculum.* A two-day initial training covers the platform's purpose and limits, the procedure content for the top-20 services, the PWA install flow, the IVR/USSD flows, the documented identity recovery protocol, and the political-neutrality and procedural-rigour stance. A monthly half-day refresher covers content updates, common discrepancies, and feedback from the previous month. Training is delivered by the field operations lead and the helper-programme coordinator.

*Supervision and quality.* Each cluster of approximately five helpers is supervised by a trained-helper supervisor (typically an NGO field officer or a senior helper). Supervisors review a sample of helper-mediated interactions monthly and surface issues to the helper-programme coordinator. Helpers maintain a simple paper log of interactions, cross-checked against platform analytics.

*Recognition and retention.* Helpers receive a transport reimbursement (a fixed LKR amount per supervised interaction or per shift), a phone-credit allowance for outbound calls and data, an annual recognition event, and named credit on the platform's annual public report. Helpers are not paid wages; the role is volunteer with reimbursement, deliberately, to keep the programme aligned with civic mission rather than employment.

*Complaint handling and exit.* A documented complaint process covers helpers misrepresenting the platform, mishandling household data, or charging households for mediation. Confirmed violations result in immediate removal from the programme and notification to the household concerned. Helpers can exit at any time; an exit interview captures lessons.

*Indicative annual cost (200-helper network, mid-stage).*

#table(
  columns: (1fr, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right),
  table.header(
    [*Line item*], [*Annual LKR*],
  ),
  [Helper-programme coordinator (1 FTE, mid-stage hire)], [2,400,000],
  [Cluster supervisors (≈ 8, fractional, NGO-hosted)], [1,800,000],
  [Initial training (2 days × 200 helpers)], [600,000],
  [Monthly refreshers (12 × 200 helpers)], [720,000],
  [Transport reimbursement (200 helpers × LKR 2,000/month)], [4,800,000],
  [Phone-credit allowance (200 helpers × LKR 800/month)], [1,920,000],
  [Annual recognition event], [400,000],
  [Materials (printed guides, tablets for cluster supervisors)], [600,000],
  [*Total annual helper-programme cost*], [*13,240,000*],
)

This is roughly LKR 13M per year (≈ USD 42k) — material, not negligible. It is budgeted explicitly in Phase 1 and Phase 2 funding pipelines, with a smaller initial Phase 1 outlay as the network ramps from zero to 80 (base case) or 200 (heroic) helpers.

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

- A Tamil-language IVR, a USSD application, and an SMS short-code service deliver Phase 1 information lookups via Ideamart and hSenid Mobile multi-operator APIs (Dialog, Mobitel, and Hutch). These channels work on any feature phone, require no installation, no internet, and no URL typing, and are the primary accessibility surface for users without smartphones. IVR voice prompts are generated using Amazon Polly Neural TTS with a maintained Jaffna Tamil pronunciation lexicon (SSML phoneme overrides) so the spoken register matches Northern Province colloquial Tamil rather than Indian Tamil.
- *Native-listener review panel.* Pronunciation accuracy is reviewed by a standing panel of seven Northern Province native speakers spanning age and education profiles, recruited via the NGO partner and paid a per-prompt review fee (LKR 200/prompt). Each new or changed prompt is rated by at least three panellists on a documented rubric (intelligibility, dialect appropriateness, naturalness). Prompts that score below threshold are returned for lexicon refinement or, for the highest-traffic procedures, swapped to human recordings. The panel review SLA is 72 hours from prompt submission. The panel coordinator is the Tamil content lead.
- A trained-helper telephone hotline routes any case the automated channels cannot handle to a human, using the same content base as the PWA and IVR so the answer is consistent regardless of channel.
- Trained helper programmes in every operational division install the PWA on residents' phones, dial the USSD code with them, and operate the assistant on their behalf where needed.
- Print and radio companion materials advertise both the URL and the shortcode for non-digital reach.
- Explicit support for low-end Android devices and intermittent connectivity (the PWA caches and reconciles offline).
- WCAG 2.1 AA conformance as an internal target for the PWA, including Tamil-screen-reader testing.

// ============ SECTION 8 ============

= AI Agents and Hosted Inference

The platform uses small language models to deliver capability that would otherwise require either much larger teams (manual intent triage, hand-written content updates, person-by-person evidence assembly) or unmanageable accuracy ceilings (rule-based intent matching against colloquial Jaffna Tamil). Agents are scoped narrowly, run against hosted inference under a documented data-protection instrument, and operate behind strict guardrails. This section specifies the architecture, the agents themselves, the model selection and evaluation methodology, and the production guardrails.

== Architectural Pattern

The pattern is *hosted small-model inference for routine work, with a strict de-identification boundary at the application edge and human-in-the-loop confirmation for any consequential action*. No agent acts autonomously on user data. Every agent output is either advisory (presented to the user for confirmation) or internal (presented to a Veḷi staff member for review). The hosted inference path is governed by a documented PDPA §26 cross-border-transfer instrument with the inference provider as a data processor.

The flow for any agent invocation is:

+ User input (free text or voice transcription) arrives via PWA or IVR.
+ The Veḷi backend strips identifiers from the payload at the application edge: NIC numbers, phone numbers, GPS coordinates, witness names, payment information, and any document content classified as special category. The de-identification step is a documented, audited service.
+ The de-identified payload is sent to the hosted inference endpoint.
+ A self-hosted intent router classifies the input. Below a confidence threshold, the input is handed off to a human (trained helper or content team).
+ Above threshold, the relevant task agent runs against the hosted endpoint, retrieving facts from the structured content store rather than generating them where procedural accuracy matters.
+ The agent returns a result with an explicit confidence score and a citation to the source content.
+ The user (or staff member) reviews and confirms before any action is taken.
+ Every step is written to the audit log with timestamps, model identifier, request ID, input hash, output, and confidence. The audit log is held in Sri Lanka.

== Model Selection

Self-hosted inference uses the Gemma 4 family (released April 2026 under Apache 2.0), accessed through Vertex AI Model-as-a-Service. The licence composes cleanly with the platform's Apache-2.0 / AGPL-3.0 stance, the multilingual training covers Tamil at acceptable baseline quality, and the size lineup matches the platform's traffic profile. The candidate models and their intended roles:

#table(
  columns: (auto, auto, auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right, right, left),
  table.header(
    [*Model*], [*On-disk (Q4)*], [*Context*], [*Intended role*],
  ),
  [`gemma4:e2b`], [7.2 GB], [128K], [Edge tier; reserved for any future on-device PWA inference. Not used in Phase 1 production.],
  [`gemma4:e4b`], [9.6 GB], [128K], [Production intent classifier and structured task router on the IVR and PWA. The platform's primary inference workhorse for high-volume, low-complexity calls.],
  [`gemma4:26b`], [18 GB], [256K], [Generation-quality work: procedure-walking dialogue, OCR cleanup, evidence-package drafting in Phase 2, exporter compliance assistance in Phase 3. Mixture-of-experts architecture means inference cost is closer to a 4B model than a 26B model.],
  [`gemma4:31b`], [20 GB], [256K], [Quality reference and fallback for tasks where the 26B variant is demonstrably insufficient. Not the production default; only enabled where Phase 0 evaluation justifies it.],
)

The choice between `gemma4:e4b` only, `gemma4:26b` only, or a hybrid `e4b` + `26b` deployment is decided in Phase 0 against measured performance on a Jaffna Tamil evaluation set (see below). The default expectation is a hybrid deployment: `e4b` handles classification and simple Q&A (the majority of traffic), `26b` handles generation tasks (lower volume, higher quality requirement).

== Inference Provider and Data Protection Instrument

Production inference uses *Vertex AI Model-as-a-Service* under a Google Cloud project owned by Cloud Parallax. Vertex AI MaaS is chosen over the Gemini Developer API (AI Studio) for production because the Vertex AI commercial framework supports the standard Google Cloud Data Processing Addendum (CDPA), which serves as the PDPA §26 cross-border-transfer instrument. The CDPA establishes Google Cloud as a data processor, defines purpose limitation, sub-processor consent, security obligations, and breach notification, and is reviewable by the Sri Lankan Data Protection Authority.

The Gemini Developer API (AI Studio) key issued during early development is used only for Phase 0 evaluation experiments, against synthetic Jaffna Tamil eval sets containing no real user data. It is not used in production.

Region selection. Vertex AI Gemma serverless availability for the 26B and 31B variants is concentrated in `us-central1` and a small number of other regions; the closest serverless availability to Sri Lanka at time of writing is not Mumbai (`asia-south1`) but typically `asia-southeast1` (Singapore) or US-based regions. The platform discloses this honestly in the privacy notice: live inference may be processed in Singapore or the United States, under the CDPA. Identifying data does not leave Sri Lanka because of the de-identification boundary; only de-identified Tamil text and OCR images flow to the inference region.

Local Ollama, running on developer hardware (96 GB unified memory class), is retained as: (a) the development sandbox for prompt iteration without API spend; (b) the disaster-recovery fallback if Vertex AI is unreachable for an extended period (degraded but operational mode); (c) the validation harness for any change to the production model that requires benchmark comparison against a known baseline.

== Phase 0 Evaluation Gate

No agent ships into production without measured performance on Jaffna Tamil. The Phase 0 evaluation gate is a documented experiment, executed before any production traffic flows to Vertex AI and before the lexicon build for the IVR. The evaluation produces an evidence-based recommendation between three architectural outcomes:

- *Outcome A — small models are sufficient.* `gemma4:e4b` achieves at least 85% top-1 accuracy on the Jaffna Tamil intent classification eval set. Production inference is `e4b` only, with the 26B variant reserved for occasional generation tasks.
- *Outcome B — hybrid is required.* `gemma4:e4b` handles classification adequately but generation requires `gemma4:26b`. Production inference is hybrid, routing classification calls to `e4b` and generation calls to `26b`.
- *Outcome C — fine-tuning is required.* No off-the-shelf Gemma 4 variant clears the quality bar. Phase 0 closes with a fine-tuning workplan in partnership with the University of Jaffna; any production agent shipping in Phase 1 is restricted to intent classification on the best available model, and generation tasks are deferred to Phase 2.

The evaluation comprises three documented experiments:

+ *Intent classification baseline.* A hand-labelled evaluation set of at least 100 Jaffna Tamil utterances (mixed Tamil script and Tanglish, sourced from real conversations via NGO partner interviews and from synthetic seed data corrected by Northern Province natives) mapped to the top-20 intents. Evaluated against `gemma4:e4b`, `gemma4:26b`, and `gemma4:31b` using the same system prompt and few-shot examples. Reports top-1 and top-3 accuracy, confusion matrix, and per-intent breakdown.
+ *Generation register quality.* Ten procedure descriptions rendered in colloquial Jaffna Tamil by `gemma4:26b` and `gemma4:31b`. The seven-person native-listener panel (the same panel that reviews TTS prompts) rates each output for register, naturalness, and accuracy on the documented rubric.
+ *Multimodal OCR cleanup.* Five scanned deed pages run through both paths: (a) Tesseract Tamil → `gemma4:e4b` cleanup; (b) page image → `gemma4:e4b` direct multimodal reading. Compared against ground truth. Tests whether multimodal Gemma 4 collapses the OCR-cleanup pipeline into a single model call, which would be a meaningful Phase 2 architecture simplification.

The evaluation is run by the technical lead with support from the Tamil content lead. The output is a written recommendation document signed off by the founder before any production traffic flows.

== Agents in Scope

The platform ships ten distinct agents across the four phases. Each agent has a defined input boundary, a defined output, an explicit confidence threshold, an explicit failure mode, and an audit-log signature.

#table(
  columns: (auto, 1fr, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, left, center),
  table.header(
    [*Agent*], [*Function*], [*Phase*],
  ),
  [Intent classifier], [Classifies free-text or voice-transcribed Tamil input into one of the documented procedures. Below confidence threshold, hands off to a human.], [1],
  [Procedure walker], [Once intent is classified, walks the user conversationally through the documented procedure, asking clarifying questions and branching on answers. Retrieves all procedural facts from the content store; never generates them.], [1],
  [Content freshness watchdog], [Internal scheduled agent that periodically checks government websites and gazettes for procedure changes (fees, forms, office hours) and surfaces candidate edits to the Tamil content team. Reduces content rot.], [1 late],
  [Evidence-package assembly assistant], [Walks a household (PWA-direct or via documentation officer) through the structured evidence-collection flow: what photos to take, what GPS points to capture, which witnesses to call, in what order. Bounded, advisory, no legal claims.], [2],
  [Document OCR + classifier], [Extracts text from uploaded deeds, identifies document type (title deed, mortgage, survey plan, notarial extract), flags Thesawalamai-specific document types. Output is treated as suggestion; the household confirms the classification.], [2],
  [Lot anomaly detector], [Internal-only. Flags suspicious lot patterns: volume mismatches against historical norms, geographically improbable harvests, unusually rapid lot creation. Supports the anti-collusion controls.], [3],
  [Diaspora retailer compliance assistant], [Helps an exporter assemble the documentation package for a specific destination market (Canada CFIA, UK FSA, Australia DAFF). Reduces compliance burden.], [3],
  [Form pre-fill assistant], [User uploads an old document (e.g., faded birth certificate); agent extracts what it can read and pre-fills an application form for the user to verify. The agent never submits; the user always submits.], [4],
  [DPO assistant], [Drafts data-subject-request responses within the §17 21-working-day window, classifies incoming PDPA requests, surfaces gaps. Internal compliance tooling; human DPO signs off every response.], [4],
  [OSA moderation triage], [Categorises incoming Online Safety Act complaints, suggests removal or retention, escalates to a human reviewer. The decision is always human; the agent only triages.], [4],
)

The witness-statement composer briefly considered in earlier internal drafts is *not* shipped. The cultural-sensitivity risk of generated witness language outweighs the marginal benefit over a structured form.

== Production Guardrails

The following guardrails are implemented before any agent ships to users, and are non-negotiable:

+ *Confidence thresholds.* Every agent output carries a confidence score. Below the per-agent threshold, the output is suppressed and the input is handed off to a human. Thresholds are tuned against the Phase 0 evaluation set and reviewed quarterly.
+ *User-in-the-loop for every consequential action.* The agent drafts; the user confirms. The agent never submits forms, transmits messages, or executes payments without explicit per-action consent. This is enforced at the API layer, not just the UI.
+ *Audit log for every agent decision.* Persisted in the same audit infrastructure as identity recovery: model identifier, model version, request ID (returned by Vertex AI), input hash (or de-identified input where compact), output, confidence, user action. The audit log is held in Sri Lanka and is queryable by the user for their own account.
+ *De-identification at the API boundary.* The Veḷi backend runs every payload through the de-identification service before it leaves the country. NIC numbers, phone numbers, GPS coordinates within five decimal places, witness names, payment identifiers, and any field tagged "personal data" in the platform schema are stripped or replaced with placeholders. Re-identification happens locally after the agent returns. The de-identification service is a first-class component with its own tests, audit log, and quarterly external review.
+ *Hallucination-rejection for procedural facts.* Agents are forbidden from generating procedural facts (fees, office hours, document requirements). They must retrieve from the structured content store. The integration uses retrieval-augmented generation with strict citation enforcement: any procedural claim in the agent output must be accompanied by a content-store reference, and the validator rejects outputs without citations.
+ *Bias and dialect testing.* The native-listener panel reviews a sample of agent outputs quarterly for cultural appropriateness, gender bias, religious sensitivity, and dialect register. The same panel that reviews TTS prompts.
+ *Adversarial testing for prompt injection.* Phase 2 uploads (deed scans, witness-statement text) can contain content that tries to manipulate the agent. Standard prompt-injection mitigations apply: input sanitisation, system-prompt reinforcement, output validation, and a per-agent allowlist of permissible response shapes.
+ *Per-agent kill switch.* Each agent can be disabled independently. If the OCR classifier starts hallucinating Thesawalamai document types, the platform disables it without taking down the rest of the system. The kill switch is operationally a feature flag held in Sri Lanka and toggleable by the technical lead within five minutes.
+ *Fallback to local Ollama on provider outage.* If Vertex AI is unreachable for more than fifteen minutes, the platform falls back to local-Ollama inference on developer hardware (degraded mode, lower quality, slower response). The fallback is exercised quarterly. Users are informed of degraded mode via a status banner in both Tamil and English.

== Inference Cost Model

Vertex AI MaaS pricing is per-token. Indicative annualised cost at the base-case Phase 1 traffic (5,000 MAU, ≈ four PWA sessions and three IVR sessions per MAU per month, average 2,000 input + 500 output tokens per agent invocation) is modelled bottom-up:

#table(
  columns: (1fr, auto, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right, right),
  table.header(
    [*Line item*], [*Annual tokens (M)*], [*Indicative LKR*],
  ),
  [Intent classifier (`gemma4:e4b`), 5k MAU × 7 sessions/month × 12], [≈ 105], [180,000],
  [Procedure walker (`gemma4:e4b`), 5k MAU × 4 sessions/month × 12 × 3 turns], [≈ 180], [310,000],
  [Document OCR + classifier (`gemma4:26b`), 1k Phase 2 packages × 5 docs], [≈ 25], [200,000],
  [Evidence-package assembly (`gemma4:e4b`), 5k Phase 2 sessions], [≈ 50], [85,000],
  [Headroom for Phase 3 agents and burst traffic], [—], [400,000],
  [*Annual Vertex AI inference cost, base case*], [], [*≈ 1,175,000*],
)

This is approximately LKR 1.2M per year (≈ USD 4k) — well within the operational budget. At Phase 4 stretch (50k MAU and full agent suite), the line scales to roughly LKR 8–12M per year, which becomes a budget-shaping constraint and warrants a fresh look at self-deployed Vertex AI endpoints versus MaaS at that scale. The pricing assumption is anchored to Vertex AI Gemma serverless rates as observed in mid-2026 and is reviewed at every quarterly strategic review.

The hardware BOM in Section 9 (Funding Plan) does not include GPU servers, because inference is hosted. This saves approximately LKR 5–9M of CAPEX relative to a self-hosted-inference design, at the cost of the recurring Vertex AI OPEX above.

== Phasing Summary

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Phase*], [*Agents shipped*],
  ),
  [Phase 0 (Months 0–3)], [Architecture spec; Phase 0 evaluation gate; CDPA executed; de-identification service designed and tested. No production agents.],
  [Phase 1 (Months 3–15)], [Intent classifier; procedure walker; content freshness watchdog (internal). Hosted on Vertex AI MaaS under CDPA.],
  [Phase 2 (Months 15–33)], [Evidence-package assembly assistant; document OCR + classifier. Multimodal Gemma 4 path validated.],
  [Phase 3 (Months 24–42)], [Lot anomaly detector (internal); diaspora retailer compliance assistant.],
  [Phase 4 (Months 42–60)], [Form pre-fill assistant; DPO assistant; OSA moderation triage. Cross-product agent unification.],
)

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
  [Site reliability / infrastructure lead], [Self-hosted private infrastructure, colocation operations, PostgreSQL HA, security hardening, incident response. This role is non-optional given the self-hosted posture. From Phase 0, a written backup arrangement covers single-person-of-failure risk: either a contracted on-call relationship with Cloud Parallax's existing infrastructure function (the team that runs Cloud Parallax's other production workloads), or a managed-Postgres fallback contract with a Sri Lankan provider that can take over PostgreSQL operations within 24 hours of a primary-SRE outage. The backup arrangement is exercised twice a year.],
  [Field operations lead], [Community engagement, trained helper network, NGO partnerships. Northern Province native.],
  [Tamil content lead], [Content strategy, content operations team, and ownership of the Jaffna Tamil pronunciation lexicon used to drive Polly Neural TTS for the IVR. Journalism or civil society background; working knowledge of IPA / x-sampa or willingness to learn.],
  [Partnerships and funding lead], [Grant pipeline, diaspora engagement, government relations.],
)

== Mid-stage Team (Phase 1 to Phase 2)

Adds two to three Tamil content writers, two field verifiers, two engineers, one designer, a second site-reliability engineer (the self-hosted stack cannot run on a single SRE indefinitely; on-call rotation requires at least two), a helper-programme coordinator (the trained-helper network is operationally significant and needs an owner), and a dedicated DPO / compliance officer at the point land documents start being held in volume. Total team approximately fourteen to seventeen.

== Mature Team (Phase 3 to Phase 4)

The mature team is honestly sized against the actual operational footprint, which earlier iterations of this plan understated. Beyond the mid-stage core, Phase 3 adds an agricultural supply chain lead, a legal partnerships coordinator, a research and reporting lead, additional engineers, a payments and AML/KYC operations lead (only if the platform handles funds directly; otherwise this role is filled by the partner PSP), and field officers covering the operational divisions.

Field officer staffing is rescoped from "one per Divisional Secretariat division" to a tiered model:

- *Resident officers* in five priority divisions selected during Phase 0 based on land-documentation density and partner NGO field presence.
- *Mobile officers* (typically three) covering remaining divisions on a rotating schedule, hosted by the local NGO partner where possible.
- *Trained-helper supervisors* (one per cluster of five GN divisions) supporting the volunteer network without replacing it.

Total team at end of Phase 4 is approximately thirty to forty, not the twenty to twenty-five quoted in earlier drafts. This number is what the plan as currently scoped actually requires; the alternative is to compress scope (see Section 12 Phase Gates).

== Operating Cadence

- Weekly leadership operations review.
- Monthly content freshness audit.
- Quarterly strategic review with board.
- Annual public report.

// ============ SECTION 9 ============

= Funding Plan

== Phase 0 Funding (Months 0 to 3)

Phase 0 is funded by a combination of Cloud Parallax internal investment and a small seed grant from a diaspora foundation. Indicative budget covers field research, partnership development, founding team for one quarter, and initial hardware capital expenditure for the self-hosted infrastructure.

Hardware CAPEX is modelled bottom-up as follows. Two-site (primary + secondary) Tier III colocation deployment, sized for Phase 1 traffic with headroom for Phase 2:

#table(
  columns: (1fr, auto, auto),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: (left, right, right),
  table.header(
    [*Component*], [*Qty*], [*Indicative LKR (CIF)*],
  ),
  [Application servers, mid-tier dual-socket, 256 GB RAM, mixed NVMe], [4], [3,200,000],
  [Database servers, dual-socket, 512 GB RAM, NVMe-heavy], [4], [4,800,000],
  [Object storage nodes for Ceph or MinIO, JBOD-heavy], [6], [4,500,000],
  [Network: enterprise switches and routers per site], [2 sites], [1,800,000],
  [Hardware firewall and IDS appliances per site], [2 sites], [1,200,000],
  [UPS and rack PDUs per site], [2 sites], [600,000],
  [Cabling, KVM, miscellaneous], [—], [400,000],
  [Subtotal hardware], [], [16,500,000],
  [Sri Lanka import duty cascade (PAL, SSCL, VAT) on HS 8471/8517], [≈ 25%], [4,125,000],
  [Logistics, freight forwarding, customs clearance], [—], [800,000],
  [Vendor support / warranty (3-year, where available)], [≈ 12%], [1,980,000],
  [*Total hardware CAPEX*], [], [*23,400,000*],
)

The total lands around LKR 23M (≈ USD 75k at prevailing rate), well above the LKR 8–15M cited in earlier internal drafts. The honest range is LKR 20–28M depending on vendor selection, refurbished-versus-new mix, and whether Cloud Parallax can leverage existing colocation contracts. Annual operating costs (colocation rental for two racks across two facilities, network bandwidth, hardware support contracts, replacement provisioning) land at approximately LKR 6–9M per year on top of CAPEX.

This is the single largest discretionary line item in Phase 0 and warrants explicit funder commitment before hardware is ordered. Three risk-reduction options are available: (1) start with a single-site deployment and add the secondary site at end of Phase 1, accepting a documented period of single-site risk; (2) lease rather than purchase, converting CAPEX to OPEX at a ~25% premium over three years; (3) qualify for one of the Sri Lankan ICT-sector duty concessions (subject to Board of Investment status) that would reduce the duty cascade. The Phase 0 deliverable is a vendor-quoted, founder-signed BOM, not the indicative table above.

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
- *Cross-border-transfer breach.* Risk applies to two distinct flows: the encrypted DR backup, and the live AI-agent inference path to Vertex AI. Mitigation for the DR backup: documented §26 instrument; encryption at rest with keys held in-country; access logged and audited. Mitigation for the inference path: de-identification at the application boundary (no NIC, phone, GPS, witness name, or payment identifier in any outbound payload); CDPA executed with Google Cloud as data processor; per-agent kill switch; quarterly external review of the de-identification service.
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

= Phase Gates and Scope Compression

Earlier drafts of this plan assumed three product lines could be delivered concurrently on a small team. The honest accounting in Section 8 (mature team of thirty to forty, not twenty to twenty-five) and Section 5 (Phase 3 base-case revenue of ≈ USD 20k per year, not the heroic figure earlier drafts implied) reveals the structural tension: the plan's scope, even with every other fix in place, requires more capacity than a Cloud Parallax-led civic-tech effort plausibly assembles in 60 months. Rather than disguise this with optimism, the plan installs explicit go/no-go gates between phases and a documented scope-compression option at each gate.

== Gate Criteria

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Gate*], [*Pass criteria; failure triggers compression*],
  ),
  [End of Phase 0 (Month 3)], [(a) Anchor diaspora funder soft-committed; (b) corporate form decided and conflict-of-interest policy in place; (c) signed MOUs with NGO, legal, and academic partners; (d) TTS validation panel passes ≥ 5/7; (e) AI agents Phase 0 evaluation gate produces a documented Outcome A/B/C recommendation; (f) hardware BOM finalised and within 25% of indicative budget; (g) baseline survey supports the base-case MAU ladder; (h) CDPA executed and de-identification service tested. Failing any of (a), (b), or (c): pause, do not proceed to Phase 1.],
  [Mid-Phase 1 (Month 9)], [Base-case MAU trajectory (≥ 2,500 channel-blended MAU at Month 9 to remain on track for 5,000 by Month 15); content freshness < 90 days on top 20 services; helper network ≥ 40. Failing trajectory: extend Phase 1 by six months before starting Phase 2.],
  [End of Phase 1 / start of Phase 2 (Month 15)], [(a) PDPA compliance package operational; (b) OSA exposure register and takedown SLA exercised; (c) notary panel ≥ 5 with Thesawalamai practitioners; (d) custodianship trust deed executed; (e) Phase 1 base case (5,000 MAU) achieved or close. Failing (a)–(d): hold Phase 2 until resolved. Failing (e): proceed to Phase 2 with reduced ambition.],
  [Mid-Phase 2 (Month 24) / start of Phase 3 (concurrent window)], [Phase 2 evidence-package volume on trajectory; ≥ 1 demonstrated successful land case (with consent to publicise); identity-recovery protocol exercised. Failing trajectory: defer Phase 3 by six months and continue Phase 2 to completion.],
  [End of Phase 2 (Month 33)], [Phase 2 base case (5,000 households with ≥ 1 evidence package); Thesawalamai-specific evidence flows operational; payment-handling decision finalised for Phase 3.],
  [Mid-Phase 3 (Month 36)], [At least one commodity pilot has run a full season with documented outcome; exporter and diaspora-retailer commitments in writing; bottoms-up revenue model tracking within 30% of base case. Failing: drop the underperforming commodity rather than carry it.],
)

== Scope Compression Options

If the gates indicate the plan as scoped is unachievable on the actual team and funding, two compression options are pre-documented so the founder is not making them under pressure mid-phase:

+ *Two-product variant.* Drop Phase 3 (agricultural traceability) entirely. Phase 1 and Phase 2 remain. The platform becomes a civic-tech access and land-documentation organisation, not a commercial-revenue civic-tech hybrid. Funding mix shifts to ≥ 80% grant and philanthropic; team end-state is fifteen to twenty rather than thirty to forty. This is the lowest-risk path and the one most aligned with civic mission.
+ *Sequenced-only variant.* Keep all three product lines but extend the timeline: Phase 0–1 unchanged (Months 0–15), Phase 2 extended to Months 15–36, Phase 3 deferred to Months 36–60, Phase 4 deferred to Months 60–72. Total programme length 72 months. Team grows more slowly; funding raised in tranches. Lower risk than concurrent execution but requires longer funder commitment.

The default (all three concurrent, 60 months, mature team thirty to forty) remains the plan of record. The compression options are pre-approved fallbacks, not failure modes — choosing one of them at a gate is a normal outcome, not a defeat.

== Pre-Mortem Commitment

Before Phase 0 closes, the founder writes a one-page pre-mortem ("It is Month 30 and Veḷi has failed. Why?") and circulates it to the leadership team and the anchor funder. The pre-mortem surfaces which of the gate criteria the founder is most worried about and which compression option is most likely to be invoked. This document is revisited at every quarterly strategic review.

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
