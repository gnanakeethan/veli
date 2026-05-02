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
