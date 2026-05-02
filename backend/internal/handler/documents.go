package handler

import (
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"

	"github.com/cloudparallax/veli/internal/service"
)

// DocumentsHandler exposes admin-facing document routes. Until the
// end-user phone-OTP layer lands, all document creation and listing
// flows through here. End users will get their own routes (gated by
// session-owner identity rather than RBAC permission codes) once we
// have a way for them to authenticate.
type DocumentsHandler struct {
	Service *service.DocumentsService
	Logger  *zap.Logger
}

// createDocumentRequest is the JSON body POST /api/v1/admin/documents
// accepts. Field names mirror domain.Document so the same TS client
// type can be reused on the frontend.
type createDocumentRequest struct {
	UserID     string    `json:"user_id"`
	Kind       string    `json:"kind"`
	StorageURI string    `json:"storage_uri"`
	CapturedAt time.Time `json:"captured_at"`
	GPSLat     *float64  `json:"gps_lat,omitempty"`
	GPSLng     *float64  `json:"gps_lng,omitempty"`
	DeviceID   string    `json:"device_id,omitempty"`
}

// Create serves POST /api/v1/admin/documents.
func (h *DocumentsHandler) Create(w http.ResponseWriter, r *http.Request) {
	var req createDocumentRequest
	dec := json.NewDecoder(r.Body)
	dec.DisallowUnknownFields()
	if err := dec.Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid json"})
		return
	}

	doc, err := h.Service.Create(r.Context(), service.CreateDocumentInput{
		UserID:     req.UserID,
		Kind:       req.Kind,
		StorageURI: req.StorageURI,
		CapturedAt: req.CapturedAt,
		GPSLat:     req.GPSLat,
		GPSLng:     req.GPSLng,
		DeviceID:   req.DeviceID,
	})
	if err != nil {
		mapDocumentError(w, h.Logger, "create document", err, req.UserID)
		return
	}
	writeJSON(w, http.StatusCreated, doc)
}

// Get serves GET /api/v1/admin/documents/{id}.
func (h *DocumentsHandler) Get(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	doc, err := h.Service.GetByID(r.Context(), id)
	if err != nil {
		mapDocumentError(w, h.Logger, "get document", err, id)
		return
	}
	writeJSON(w, http.StatusOK, doc)
}

// List serves GET /api/v1/admin/documents?user_id=&limit=&offset=.
// When user_id is provided, results are scoped to that user.
func (h *DocumentsHandler) List(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	limit := atoiDefault(q.Get("limit"), 50)
	offset := atoiDefault(q.Get("offset"), 0)
	userID := q.Get("user_id")

	if userID != "" {
		docs, err := h.Service.ListByUserID(r.Context(), userID, limit, offset)
		if err != nil {
			mapDocumentError(w, h.Logger, "list documents by user", err, userID)
			return
		}
		writeJSON(w, http.StatusOK, map[string]any{
			"documents": docs,
			"limit":     limit,
			"offset":    offset,
			"user_id":   userID,
		})
		return
	}

	docs, err := h.Service.List(r.Context(), limit, offset)
	if err != nil {
		mapDocumentError(w, h.Logger, "list documents", err, "")
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"documents": docs,
		"limit":     limit,
		"offset":    offset,
	})
}

// mapDocumentError translates service-layer errors to HTTP responses.
// Logs unexpected errors at error level with a short context.
func mapDocumentError(
	w http.ResponseWriter, logger *zap.Logger, op string, err error, key string,
) {
	switch {
	case errors.Is(err, service.ErrInvalidID):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid id"})
	case errors.Is(err, service.ErrInvalidUserID):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid user_id"})
	case errors.Is(err, service.ErrUserNotFound):
		writeJSON(w, http.StatusNotFound, map[string]string{"error": "user not found"})
	case errors.Is(err, service.ErrInvalidKind):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid kind"})
	case errors.Is(err, service.ErrInvalidStorageURI):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid storage_uri"})
	case errors.Is(err, service.ErrInvalidCapturedAt):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid captured_at"})
	case errors.Is(err, service.ErrDocumentNotFound):
		writeJSON(w, http.StatusNotFound, map[string]string{"error": "document not found"})
	default:
		logger.Error(op, zap.String("key", key), zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
	}
}
