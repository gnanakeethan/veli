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
