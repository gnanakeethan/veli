package service

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/oklog/ulid/v2"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
)

// Sentinel errors for the verifications layer.
var (
	ErrInvalidDocumentID    = errors.New("invalid document_id")
	ErrInvalidAttesterID    = errors.New("invalid attester_id")
	ErrInvalidTier          = errors.New("invalid tier")
	ErrInvalidNotes         = errors.New("invalid notes")
	ErrSelfAssertedByOther  = errors.New("self_asserted attestations require attester to be the document owner")
	ErrCommunityByOwner     = errors.New("community_corroborated attestations require an attester other than the owner")
	ErrAuthorityByOwner     = errors.New("authority_attested attestations require an external attester")
	ErrVerificationNotFound = repository.ErrVerificationNotFound
)

// notesMaxLen bounds the free-text notes field. 2 KiB is generous
// for a witness statement summary; longer evidence belongs in a
// document, not a verification note.
const notesMaxLen = 2048

// attesterIDMaxLen bounds the attester_id field. ULIDs are 26 chars;
// notary registration numbers and external authority refs are short.
// 256 is plenty.
const attesterIDMaxLen = 256

// CreateVerificationInput is the validated set of fields needed to
// record a tier attestation. The service mints ID + VerifiedAt.
type CreateVerificationInput struct {
	DocumentID string
	Tier       domain.VerificationTier
	AttesterID string
	Notes      string
}

// VerificationsService coordinates verification creation. It depends
// on the verifications repo plus the documents repo (so we can fetch
// the owning user and enforce tier-vs-owner rules).
type VerificationsService struct {
	verifications repository.VerificationsRepository
	documents     repository.DocumentsRepository
}

func NewVerificationsService(
	v repository.VerificationsRepository, d repository.DocumentsRepository,
) *VerificationsService {
	return &VerificationsService{verifications: v, documents: d}
}

// GetByID validates id and returns the verification.
func (s *VerificationsService) GetByID(
	ctx context.Context, id string,
) (domain.Verification, error) {
	if !isWellFormedULID(id) {
		return domain.Verification{}, ErrInvalidID
	}
	v, err := s.verifications.GetByID(ctx, id)
	if err != nil {
		if errors.Is(err, repository.ErrVerificationNotFound) {
			return domain.Verification{}, ErrVerificationNotFound
		}
		return domain.Verification{}, fmt.Errorf("get verification: %w", err)
	}
	return v, nil
}

// ListByDocumentID returns all attestations attached to a document,
// oldest-first, so the chain-of-custody is rendered in the order it
// was built. The document must exist; ErrDocumentNotFound otherwise.
func (s *VerificationsService) ListByDocumentID(
	ctx context.Context, documentID string,
) ([]domain.Verification, error) {
	if !isWellFormedULID(documentID) {
		return nil, ErrInvalidDocumentID
	}
	if _, err := s.documents.GetByID(ctx, documentID); err != nil {
		if errors.Is(err, repository.ErrDocumentNotFound) {
			return nil, ErrDocumentNotFound
		}
		return nil, fmt.Errorf("verify document exists: %w", err)
	}
	vs, err := s.verifications.ListByDocumentID(ctx, documentID)
	if err != nil {
		return nil, fmt.Errorf("list verifications: %w", err)
	}
	return vs, nil
}

// Create validates input, enforces tier-vs-owner rules, mints a
// ULID, and persists a new verification. The "two-witness rule"
// for community_corroborated (≥2 distinct neighbours signed) is a
// derived view computed at read time, not enforced here — that lets
// us record each witness statement individually as it arrives, then
// promote the document's *displayed* tier when the count reaches
// two. See README §three-tier verification for the full rationale.
func (s *VerificationsService) Create(
	ctx context.Context, in CreateVerificationInput,
) (domain.Verification, error) {
	if !isWellFormedULID(in.DocumentID) {
		return domain.Verification{}, ErrInvalidDocumentID
	}
	if err := validateTier(in.Tier); err != nil {
		return domain.Verification{}, err
	}
	if err := validateAttesterID(in.AttesterID, in.Tier); err != nil {
		return domain.Verification{}, err
	}
	if err := validateNotes(in.Notes); err != nil {
		return domain.Verification{}, err
	}

	doc, err := s.documents.GetByID(ctx, in.DocumentID)
	if err != nil {
		if errors.Is(err, repository.ErrDocumentNotFound) {
			return domain.Verification{}, ErrDocumentNotFound
		}
		return domain.Verification{}, fmt.Errorf("load document: %w", err)
	}

	if err := enforceTierOwnerRule(in.Tier, in.AttesterID, doc.UserID); err != nil {
		return domain.Verification{}, err
	}

	v := domain.Verification{
		ID:         ulid.Make().String(),
		DocumentID: in.DocumentID,
		Tier:       in.Tier,
		AttesterID: strings.TrimSpace(in.AttesterID),
		Notes:      strings.TrimSpace(in.Notes),
		VerifiedAt: time.Now().UTC(),
	}
	if err := s.verifications.Create(ctx, &v); err != nil {
		return domain.Verification{}, fmt.Errorf("create verification: %w", err)
	}
	return v, nil
}

func validateTier(t domain.VerificationTier) error {
	switch t {
	case domain.TierSelfAsserted,
		domain.TierCommunityCorroborated,
		domain.TierAuthorityAttested:
		return nil
	default:
		return ErrInvalidTier
	}
}

func validateAttesterID(s string, tier domain.VerificationTier) error {
	t := strings.TrimSpace(s)
	if t == "" || len(t) > attesterIDMaxLen {
		return ErrInvalidAttesterID
	}
	// For self_asserted and community_corroborated, the attester is a
	// platform user (ULID). authority_attested allows arbitrary
	// external references (notary registration numbers, government
	// office IDs) so we relax to "non-empty + length-bounded".
	if tier == domain.TierSelfAsserted || tier == domain.TierCommunityCorroborated {
		if !isWellFormedULID(t) {
			return ErrInvalidAttesterID
		}
	}
	return nil
}

func validateNotes(s string) error {
	if utf8.RuneCountInString(s) > notesMaxLen {
		return ErrInvalidNotes
	}
	return nil
}

// enforceTierOwnerRule encodes the relationship between attester and
// document owner that each tier requires. These are normative per the
// plan §three-tier verification:
//   - self_asserted: the user attests their own upload — attester
//     must equal the owner.
//   - community_corroborated: a *named neighbour* signs — attester
//     must differ from the owner (so the user can't witness for
//     themselves and inflate the tier).
//   - authority_attested: a notary or government office attests —
//     attester must differ from the owner (the owner can't attest as
//     the authority).
func enforceTierOwnerRule(
	tier domain.VerificationTier, attesterID, ownerID string,
) error {
	switch tier {
	case domain.TierSelfAsserted:
		if attesterID != ownerID {
			return ErrSelfAssertedByOther
		}
	case domain.TierCommunityCorroborated:
		if attesterID == ownerID {
			return ErrCommunityByOwner
		}
	case domain.TierAuthorityAttested:
		if attesterID == ownerID {
			return ErrAuthorityByOwner
		}
	}
	return nil
}
