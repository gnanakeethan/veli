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
- *Cross-border transfers.* Live operations do not transfer user data outside Sri Lanka. The only permitted cross-border flows are: (a) the encrypted tertiary disaster-recovery backup, governed by a documented §26 instrument; and (b) offline content-authoring calls to Amazon Polly to render Tamil IVR prompts from procedure text. Polly receives only Tamil procedure content (not personal data) during offline render, and the resulting audio files are cached and served from in-country object storage. The user is informed of both flows in the privacy notice.
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
