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
    Version 1.0 #sym.dot.c May 2026
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

- A small team of three to six people through Phase 1, growing to roughly fifteen to twenty by end of Phase 3.
- A blended funding model combining grant capital (NGO, diaspora, multilateral), modest local revenue, and eventually B2B contract revenue from exporters and cooperatives.
- Tamil as the primary working language for product, with Sinhala and English as secondary.
- WhatsApp and low-end Android as the primary delivery surface for Phase 1, with progressive enhancement to native apps where justified.
- Deep partnerships with at least two local NGOs and one diaspora foundation from Phase 1 onward.

// ============ SECTION 2 ============

= Phase 0 — Foundations (Months 0 to 3)

Phase 0 is a discovery and setup quarter that precedes any product launch. Skipping it is the most common failure mode for civic technology projects.

== Objectives

- Validate the three problem statements through structured field research, not assumption.
- Establish the legal, governance, and partnership scaffolding the platform will rest on.
- Recruit the founding team and define operating cadence.
- Specify the shared identity and document architecture that all phases will reuse.

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
  [Identity], [Phone-number-anchored, with optional NIC linkage. Tamil-first profile. Recovery via community vouching, not just SMS.],
  [Document store], [Per-user encrypted store with provenance metadata: capture device, GPS, timestamp, witnesses. Versioned.],
  [Verification], [Three-tier model: self-asserted, community-witnessed, authority-verified. Each document carries its tier explicitly.],
  [Access surface], [WhatsApp Business API as primary surface; lightweight Android app as secondary; voice interface in Tamil for low-literacy users.],
  [Backend], [Go services on managed infrastructure (AWS Colombo region). PostgreSQL primary store. Object storage for documents with client-side encryption.],
  [Offline], [All capture flows must work offline and sync on reconnect. Northern Province connectivity is uneven.],
)

== Deliverables

+ Field research report with prioritized findings.
+ Signed memoranda of understanding with two NGO partners and one diaspora foundation.
+ Architectural specification document for the shared identity and document layer.
+ Founding team in place: technical lead, field operations lead, Tamil content lead, partnerships lead.
+ Twelve-month budget and grant pipeline.

== Risks for Phase 0

- *Premature commitment* to a product specification before research completes. Mitigation: enforce the six-week research sprint as a hard gate.
- *Partnership fragility* — verbal agreements that evaporate. Mitigation: written MOUs with clear scope and exit terms.
- *Talent gap* in Tamil content and field operations. Mitigation: recruit from local civil society and journalism, not only from the tech sector.

// ============ SECTION 3 ============

= Phase 1 — Government Service Navigation (Months 3 to 15)

== Product Definition

A Tamil-first conversational assistant, delivered primarily through WhatsApp, that helps Northern Province residents navigate government services. For a stated need — replacing a lost birth certificate, applying for Samurdhi, claiming a pension, obtaining a Grama Niladhari certificate — the assistant produces a clear, current, locally accurate procedure: which office, which forms, which supporting documents, which fees, which days and hours, and which clerk or section to ask for.

The product is information arbitrage. It does not file forms on behalf of users. It does not promise outcomes. It tells residents, in their language, what they would otherwise learn only after several wasted trips.

== Why This Is the Right Wedge

- *Daily utility:* Every household has at least one pending or recurring government errand.
- *Low trust cost:* The platform is giving information, not holding sensitive documents yet.
- *Cheap to operate:* The marginal cost of serving an additional user is small.
- *Funding-friendly:* Aligns with the mandates of NGOs, diaspora foundations, and multilateral agencies that fund civic-tech and access-to-services work.
- *Operational learning:* Builds Tamil NLP capability, WhatsApp ops, content operations, and field distribution — all of which are prerequisites for later phases.

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

- *Frontend:* WhatsApp Business API as primary surface; a lightweight web view for richer content (forms, maps, document checklists).
- *Conversational layer:* A small-language-model-powered router that classifies user intent into one of the documented procedures, with strict fallback to human-operated handoff for unrecognized queries.
- *Content store:* Structured procedure definitions in a versioned content management system, queryable by intent and division.
- *Tamil language handling:* Mixed-script handling (Tamil script and Tanglish), with attention to colloquial Jaffna Tamil rather than literary Tamil.
- *Analytics:* Per-procedure usage, completion, and discrepancy tracking. No personally identifying analytics.

== Distribution

A WhatsApp number alone will not reach the population that needs the service most. Distribution is a field operation:

- Community launches in partnership with the NGO partner, in at least eight Grama Niladhari divisions in the first six months of operation.
- Posters, stickers, and printed cards distributed at Divisional Secretariat waiting areas, libraries, post offices, and pharmacies.
- A "trained helper" program: training community volunteers, librarians, and shopkeepers to use the assistant on behalf of less digitally literate residents.
- Tamil-language radio spots on local stations.

== Funding for Phase 1

Phase 1 is grant-funded. Indicative funding mix:

- One anchor grant from a diaspora foundation, covering 12 months of core operations.
- Project grants from one or two multilateral or bilateral programs (UNDP access-to-services, GIZ digital governance, similar) covering specific deliverables.
- Modest in-kind support from the academic partner for student labor.
- No user fees in Phase 1.

== Success Metrics

- Twenty thousand monthly active users by end of Phase 1.
- Coverage of the top twenty services with content freshness under 90 days.
- Demonstrated time savings: average user reports avoiding at least one wasted office trip per service used.
- Trained helper network of at least 200 volunteers across Northern Province.

== Risks for Phase 1

- *Content rot* — procedures become stale, users lose trust. Mitigation: aggressive verification cycle, public last-verified dates.
- *Government pushback* — officials may perceive the platform as exposing inefficiency. Mitigation: early, respectful engagement with Divisional Secretaries; framing the platform as a service that reduces their walk-in load.
- *Tamil NLP failure modes* — the assistant misclassifies intent in colloquial Tamil. Mitigation: human handoff for low-confidence intents, conservative auto-response thresholds.
- *Funding lumpiness* — grants are unpredictable. Mitigation: diversified grant pipeline; modest run-rate.

// ============ SECTION 4 ============

= Phase 2 — Land and Property Documentation (Months 15 to 33)

== Product Definition

A community-driven platform that helps Northern Province households assemble and preserve evidence of land and property ownership. The platform does not adjudicate ownership and does not replace the formal land registry. It produces a structured, defensible evidence trail — photographs, GPS coordinates, witness affidavits, scanned deeds and notarial documents, oral history, and version history — that can be used by the household, lawyers, courts, and successor generations.

== Why Phase 2 Comes Second

Land documentation requires deep trust. Households are being asked to upload some of their most sensitive documents to an external platform. Phase 1 builds that trust by serving the same households reliably for a year on lower-stakes problems. By the time Phase 2 launches, the platform is a recognized civic actor with NGO and legal partnerships in place.

== Scope

The product covers three primary use cases:

+ *Inheritance documentation* — assembling the evidence a family needs to clearly establish ownership across generations, particularly where original deeds are lost or the original owner is deceased.
+ *Displacement and return documentation* — assembling evidence for households returning to land they were displaced from, including pre-displacement photographs, witness statements from neighbors, and historical records.
+ *Boundary and use documentation* — recording current physical boundaries, structures, cultivation, and use, with GPS and photographic evidence, as a baseline against future disputes.

The product explicitly does not cover military-occupied land disputes, contested ancestral claims, or any case currently in active litigation. Those require legal counsel and are out of scope for the platform.

== Verification Model

The platform's three-tier verification model becomes critical in Phase 2.

#v(0.4em)

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt + gray,
  inset: 8pt,
  align: left,
  table.header(
    [*Tier*], [*What it means*], [*Use case*],
  ),
  [Self-asserted], [The household uploaded the document. The platform records who, when, and from which device.], [Personal records, photographs, family memory.],
  [Community-witnessed], [Two or more named community members — typically neighbors or Grama Niladhari — have signed a witness statement, recorded by the platform.], [Boundary statements, residence history, oral history.],
  [Authority-verified], [A document has been verified or notarized by an external authority, such as a lawyer, notary, or government office.], [Notarized affidavits, surveyor reports, registered deeds.],
)

Each document in the system carries its tier explicitly. The platform never inflates a self-asserted document into something it is not.

== Technical Build

Phase 2 reuses the identity and document layer from Phase 0. New capabilities required:

- *Structured evidence collection* — guided flows that walk a household through assembling a complete evidence package for a given use case.
- *Witness statement capture* — a workflow that brings two named witnesses through a structured statement, signed digitally with phone-anchored identity.
- *Surveyor and lawyer integration* — a workflow for licensed surveyors and lawyers to add authority-verified documents to a household's package.
- *Export* — the ability to produce a clean, paginated PDF package of all evidence, ready for a lawyer or court.

== Field Operations

Phase 2 field operations are heavier than Phase 1.

- A network of trained community documentation officers — one per Divisional Secretariat division — who help households assemble evidence packages.
- A panel of partner lawyers willing to provide first-consultation advice at reduced rates.
- Mobile documentation drives in returnee communities, in partnership with NGO partners.

== Funding for Phase 2

Phase 2 funding is mixed.

- Continued grant funding for the household-facing service.
- Modest paid services for authority-verified documents (notary fees, surveyor fees), with the platform retaining a small operational margin.
- Diaspora-funded sponsorship of documentation drives in specific communities.

== Success Metrics

- Five thousand households with at least one complete evidence package by end of Phase 2.
- A panel of at least twenty partner lawyers and ten partner surveyors.
- At least one demonstrated case where a platform-produced evidence package materially helped a household resolve a land issue (with the household's consent to publicize).

== Risks for Phase 2

- *Political sensitivity.* Anything touching land in the North-East intersects with ethnicity, displacement, and military presence. Mitigation: strict scope discipline; legal partner review of platform statements; refusal to take politically charged cases.
- *Misuse.* The platform's evidence could be used adversarially. Mitigation: clear terms of use; tier transparency; legal partner advisory.
- *Document security.* Households are uploading sensitive material. Mitigation: client-side encryption; access logging; explicit user-controlled sharing.
- *Scope creep* into adjudication. Mitigation: explicit, repeated framing — the platform documents, it does not decide.

// ============ SECTION 5 ============

= Phase 3 — Agricultural Supply Chain Traceability (Months 24 to 42)

== Product Definition

A traceability and verification platform connecting Northern Province small producers — Jaffna mango orchards, palmyra craftspeople, dried fish processors, onion farmers — to exporters, retailers, and diaspora buyers. Each lot of produce carries a verifiable provenance trail from harvest or capture through processing to point of sale, anchored in the same identity and document layer as Phases 1 and 2.

== Why Phase 3 Overlaps Phase 2

Phase 3 begins before Phase 2 ends because the customer is different — exporters and cooperatives, not households — and because the agricultural calendar is unforgiving. Mango harvest, palmyra tapping season, and the fishing calendar dictate when pilots can run. Waiting for Phase 2 to fully close would cost a full agricultural year.

== Scope

Phase 3 launches with three commodity verticals:

+ *Jaffna mango* (varieties: Karthakolomban, Velleikolomban) — harvest-to-export traceability.
+ *Palmyra products* (jaggery, palm sugar, fibre crafts) — craftsperson-to-buyer traceability with cooperative integration.
+ *Dried fish* — landing-to-processor-to-buyer traceability with attention to species and method.

Onions, despite their economic importance, are deferred to a later phase because the supply chain is dominated by intermediary traders whose participation requires separate negotiation.

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

- *Transaction fees* on platform-mediated payments, in the range of one to two percent.
- *Subscription fees* from exporters using the platform for compliance documentation.
- *Co-funding* from agricultural development programs and trade promotion bodies.
- *Diaspora-direct premium* — a small premium on diaspora sales returned to producers and to platform operations.

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

The organization transitions from primarily grant-funded to a balanced mix:

- Roughly forty percent grant and philanthropic funding for the household-facing services.
- Roughly forty percent commercial revenue from agricultural traceability and exporter services.
- Roughly twenty percent paid services (legal partner referrals, surveyor fees, premium documentation).

A formal governance structure is in place: a board with local civil society, diaspora, and academic representation.

== Success Metrics

- One hundred thousand monthly active household users.
- Twenty thousand documented land evidence packages.
- Five exporter customers and ten cooperative customers using the traceability platform.
- A balanced funding mix with no single funder providing more than thirty percent of revenue.
- A published, peer-reviewed annual report on Northern civic infrastructure.

// ============ SECTION 7 ============

= Cross-Cutting Concerns

Several concerns cut across all phases and require sustained attention rather than phase-specific treatment.

== Language and Cultural Fit

Tamil-first means more than translation. It means colloquial Jaffna Tamil rather than literary or Indian Tamil; it means voice interfaces for elderly users; it means content review by people who grew up in the Northern Province; it means cultural awareness in iconography, examples, and tone. The platform invests in a Tamil content lead from Phase 0 onward.

== Privacy and Data Sovereignty

The platform holds increasingly sensitive data: government service queries, land documents, agricultural payment flows. Three principles govern this:

+ *User-controlled access.* The household, not the platform, decides who sees their documents. The platform is a custodian, not an owner.
+ *Local data residency.* Primary data stores are in regional infrastructure (AWS Colombo region or equivalent). No data is transferred outside Sri Lanka without explicit user action.
+ *Minimal collection.* The platform collects what it needs to deliver the service and no more. Analytics are aggregated and anonymized.

== Accessibility

The Northern Province population the platform serves includes elderly residents, low-literacy users, and people without smartphones. Accessibility is not a compliance checkbox but a primary design constraint:

- Voice interfaces in Tamil for low-literacy users.
- Trained helper programs in every operational division.
- Print and radio companion materials for non-digital channels.
- Explicit support for low-end Android devices and intermittent connectivity.

== Political Neutrality

The platform operates in a politically charged region. It maintains strict neutrality:

- It does not take positions on contested political questions.
- It does not partner with explicitly partisan organizations.
- It is transparent about its funders.
- It refuses to handle cases where neutrality cannot be maintained.

This discipline is not optional. A single perceived political alignment would compromise the platform's standing across communities.

== Security

The platform is a high-value target by Phase 2 due to the sensitivity of land documents. Security investment scales accordingly:

- Client-side encryption for documents from Phase 0.
- Independent security audit before Phase 2 launch and annually thereafter.
- A formal incident response process from Phase 2 onward.
- Bug bounty program from Phase 3 onward.

// ============ SECTION 8 ============

= Organization and Team

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
  [Technical lead], [Architecture, engineering team, infrastructure. Go and cloud background.],
  [Field operations lead], [Community engagement, trained helper network, NGO partnerships. Northern Province native.],
  [Tamil content lead], [Content strategy, content operations team. Journalism or civil society background.],
  [Partnerships and funding lead], [Grant pipeline, diaspora engagement, government relations.],
)

== Mid-stage Team (Phase 1 to Phase 2)

Adds two to three Tamil content writers, two field verifiers, two engineers, and one designer. Total team approximately ten to twelve.

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

Phase 0 is funded by a combination of Cloud Parallax internal investment and a small seed grant from a diaspora foundation. Indicative budget covers field research, partnership development, and founding team for one quarter.

== Phase 1 Funding (Months 3 to 15)

Phase 1 is grant-funded. The plan targets:

- One anchor multi-year grant from a diaspora foundation, covering core operations.
- One or two project grants from multilateral or bilateral programs.
- Modest in-kind support from academic and NGO partners.

== Phase 2 Funding (Months 15 to 33)

Phase 2 funding is mixed: continued grant funding for the household service, plus modest paid services for authority-verified documents.

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

- *Mission drift.* The organization, under funding pressure, drifts from civic mission into pure commercial work. Mitigation: governance structure with civil society representation; published mission and annual mission audit.
- *Political capture.* A funder or partner with a political agenda gains disproportionate influence. Mitigation: funder diversification; refusal of conditional grants.
- *Founder dependency.* Loss of a founder collapses the organization. Mitigation: documented operating playbooks; deputy roles from Phase 2.

== Operational Risks

- *Content rot* in the government navigation product.
- *Field officer turnover* in remote divisions.
- *Translation and cultural-fit failures* in Tamil content.
- *Connectivity and infrastructure failures* in the Northern Province.

== Technical Risks

- *Document security incidents.*
- *Tamil NLP failures and embarrassing misclassifications.*
- *Scaling failures during seasonal agricultural peaks.*

== Reputational Risks

- *Misuse of the platform's evidence in legal disputes.*
- *Perceived political alignment.*
- *Failure to deliver on a high-profile pilot.*

Each risk has an owner in the leadership team and is reviewed at the quarterly strategic review.

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
