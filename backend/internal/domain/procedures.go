package domain

import "time"

// ProcedureStatus is the publication state of a procedure record.
// Status transitions are linear: draft → published → archived. We
// don't model un-archive — restoration involves human review and
// is an explicit re-publish via the admin UI.
type ProcedureStatus string

const (
	ProcedureStatusDraft     ProcedureStatus = "draft"
	ProcedureStatusPublished ProcedureStatus = "published"
	ProcedureStatusArchived  ProcedureStatus = "archived"
)

// Procedure is a single citizen-facing government errand record:
// what the procedure is, who runs it, what it costs, where the
// information was last verified. Bilingual columns are normative —
// title_ta is required, title_en is secondary. The fee is in
// integer cents to avoid float precision issues; nil means the fee
// varies or is unspecified at this verification level.
//
// last_verified_at is the citation timestamp (when a Veḷi verifier
// last walked through the procedure against the actual office),
// distinct from updated_at (when the row last changed). For citizens
// reading the page, last_verified_at is the trust signal.
type Procedure struct {
	ID             string          `json:"id"`
	Slug           string          `json:"slug"`
	TitleTa        string          `json:"title_ta"`
	TitleEn        string          `json:"title_en,omitempty"`
	SummaryTa      string          `json:"summary_ta,omitempty"`
	SummaryEn      string          `json:"summary_en,omitempty"`
	FeeLKRCents    *int64          `json:"fee_lkr_cents,omitempty"`
	SourceURL      string          `json:"source_url,omitempty"`
	LastVerifiedAt *time.Time      `json:"last_verified_at,omitempty"`
	Status         ProcedureStatus `json:"status"`
	CreatedAt      time.Time       `json:"created_at"`
	UpdatedAt      time.Time       `json:"updated_at"`
}
