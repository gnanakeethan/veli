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

The hardware BOM in Section 10 (Funding Plan) does not include GPU servers, because inference is hosted. This saves approximately LKR 5–9M of CAPEX relative to a self-hosted-inference design, at the cost of the recurring Vertex AI OPEX above.

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
