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
