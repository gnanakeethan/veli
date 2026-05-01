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
