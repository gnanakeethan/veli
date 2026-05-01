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
