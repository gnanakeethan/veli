package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/service"
)

// VerificationsHandler exposes admin-facing routes for reading and
// recording three-tier attestations against documents.
type VerificationsHandler struct {
	Service *service.VerificationsService
	Logger  *zap.Logger
}

// createVerificationRequest is the JSON body POST /api/v1/admin/
// verifications accepts. tier must be one of the three normative
// values; attester_id is a ULID for self_asserted and
// community_corroborated, free-form for authority_attested (notary
// registration number, government office reference, etc.).
type createVerificationRequest struct {
	DocumentID string                  `json:"document_id"`
	Tier       domain.VerificationTier `json:"tier"`
	AttesterID string                  `json:"attester_id"`
	Notes      string                  `json:"notes,omitempty"`
}

// Create serves POST /api/v1/admin/verifications.
func (h *VerificationsHandler) Create(w http.ResponseWriter, r *http.Request) {
	var req createVerificationRequest
	dec := json.NewDecoder(r.Body)
	dec.DisallowUnknownFields()
	if err := dec.Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid json"})
		return
	}

	v, err := h.Service.Create(r.Context(), service.CreateVerificationInput{
		DocumentID: req.DocumentID,
		Tier:       req.Tier,
		AttesterID: req.AttesterID,
		Notes:      req.Notes,
	})
	if err != nil {
		mapVerificationError(w, h.Logger, "create verification", err, req.DocumentID)
		return
	}
	writeJSON(w, http.StatusCreated, v)
}

// Get serves GET /api/v1/admin/verifications/{id}.
func (h *VerificationsHandler) Get(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	v, err := h.Service.GetByID(r.Context(), id)
	if err != nil {
		mapVerificationError(w, h.Logger, "get verification", err, id)
		return
	}
	writeJSON(w, http.StatusOK, v)
}

// ListForDocument serves GET /api/v1/admin/documents/{id}/verifications.
// Returns the chain-of-custody for one document, oldest first.
func (h *VerificationsHandler) ListForDocument(w http.ResponseWriter, r *http.Request) {
	docID := chi.URLParam(r, "id")
	vs, err := h.Service.ListByDocumentID(r.Context(), docID)
	if err != nil {
		mapVerificationError(w, h.Logger, "list verifications", err, docID)
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"verifications": vs,
		"document_id":   docID,
	})
}

// mapVerificationError maps service-layer errors to HTTP status codes.
func mapVerificationError(
	w http.ResponseWriter, logger *zap.Logger, op string, err error, key string,
) {
	switch {
	case errors.Is(err, service.ErrInvalidID):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid id"})
	case errors.Is(err, service.ErrInvalidDocumentID):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid document_id"})
	case errors.Is(err, service.ErrInvalidAttesterID):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid attester_id"})
	case errors.Is(err, service.ErrInvalidTier):
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "invalid tier (must be self_asserted, community_corroborated, or authority_attested)",
		})
	case errors.Is(err, service.ErrInvalidNotes):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "notes too long"})
	case errors.Is(err, service.ErrSelfAssertedByOther):
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "self_asserted requires attester == document owner",
		})
	case errors.Is(err, service.ErrCommunityByOwner):
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "community_corroborated requires attester != document owner",
		})
	case errors.Is(err, service.ErrAuthorityByOwner):
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "authority_attested requires attester != document owner",
		})
	case errors.Is(err, service.ErrDocumentNotFound):
		writeJSON(w, http.StatusNotFound, map[string]string{"error": "document not found"})
	case errors.Is(err, service.ErrVerificationNotFound):
		writeJSON(w, http.StatusNotFound, map[string]string{"error": "verification not found"})
	default:
		logger.Error(op, zap.String("key", key), zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
	}
}
