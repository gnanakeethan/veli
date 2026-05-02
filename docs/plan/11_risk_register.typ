= Risk Register

== Strategic Risks

- *Mission drift.* The organisation, under funding pressure, drifts from civic mission into pure commercial work. Mitigation: governance structure with civil society representation; published mission and annual mission audit.
- *Political capture.* A funder or partner with a political agenda gains disproportionate influence. Mitigation: funder diversification; refusal of conditional grants; published funder-name and amount-band register.
- *Founder dependency.* Loss of a founder collapses the organisation. Mitigation: documented operating playbooks; deputy roles from Phase 2; written leadership succession plan.
- *Conflict of interest.* Cloud Parallax commercial interests bleed into Veḷi decisions. Mitigation: corporate form decision in Phase 0 (see Section 9); written conflict-of-interest policy and related-party-transactions register.

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
