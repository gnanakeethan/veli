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
