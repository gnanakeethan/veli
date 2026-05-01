// Package domain holds the protocol-agnostic Veḷi domain model.
// It defines the shared identity, document, and verification types
// from §Phase 0 of the implementation plan and has zero imports
// from other internal packages.
package domain

import "time"

// VerificationTier captures the three-tier verification model
// described in the plan: self-asserted, community-witnessed,
// authority-verified. Every document carries its tier explicitly;
// the platform never inflates a self-asserted artifact into
// something it is not.
type VerificationTier string

const (
	TierSelfAsserted        VerificationTier = "self_asserted"
	TierCommunityWitnessed  VerificationTier = "community_witnessed"
	TierAuthorityVerified   VerificationTier = "authority_verified"
)

// User is the phone-anchored identity shared across all three
// product lines. NIC linkage is optional and added during
// authority-verified flows.
type User struct {
	ID           string
	Phone        string
	NICNumber    string
	DisplayName  string
	Locale       string
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// Document is a per-user artifact (a photo, a scan, a witness
// statement, a notarial PDF) carried in the user's encrypted store.
type Document struct {
	ID         string
	UserID     string
	Kind       string
	StorageURI string
	CapturedAt time.Time
	GPSLat     *float64
	GPSLng     *float64
	DeviceID   string
	CreatedAt  time.Time
}

// Verification attaches a tier and an attesting party to a document.
// A document may have multiple verifications (e.g. self-asserted at
// upload, community-witnessed later by neighbours, authority-verified
// when a notary signs off).
type Verification struct {
	ID          string
	DocumentID  string
	Tier        VerificationTier
	AttesterID  string
	Notes       string
	VerifiedAt  time.Time
}
