package handler

import (
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/service"
)

// ProceduresHandler exposes the public read routes (citizens) and
// the admin write routes for procedure content.
type ProceduresHandler struct {
	Service *service.ProceduresService
	Logger  *zap.Logger
}

// procedureRequest is the JSON body for POST/PUT admin endpoints.
// We accept the same shape for create and update so the frontend
// only needs one form schema.
type procedureRequest struct {
	Slug           string                  `json:"slug"`
	TitleTa        string                  `json:"title_ta"`
	TitleEn        string                  `json:"title_en,omitempty"`
	SummaryTa      string                  `json:"summary_ta,omitempty"`
	SummaryEn      string                  `json:"summary_en,omitempty"`
	FeeLKRCents    *int64                  `json:"fee_lkr_cents,omitempty"`
	SourceURL      string                  `json:"source_url,omitempty"`
	LastVerifiedAt *time.Time              `json:"last_verified_at,omitempty"`
	Status         domain.ProcedureStatus  `json:"status,omitempty"`
}

// PublicList serves GET /api/v1/procedures. Citizens see only the
// published rows; drafts and archived stay hidden. No auth.
func (h *ProceduresHandler) PublicList(w http.ResponseWriter, r *http.Request) {
	limit := atoiDefault(r.URL.Query().Get("limit"), 50)
	offset := atoiDefault(r.URL.Query().Get("offset"), 0)
	ps, err := h.Service.ListPublished(r.Context(), limit, offset)
	if err != nil {
		h.Logger.Error("list published procedures", zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"procedures": ps,
		"limit":      limit,
		"offset":     offset,
	})
}

// PublicGetBySlug serves GET /api/v1/procedures/{slug}. Citizens
// can only see published procedures via this route — drafts and
// archived return 404 to avoid leaking unpublished content.
func (h *ProceduresHandler) PublicGetBySlug(w http.ResponseWriter, r *http.Request) {
	slug := chi.URLParam(r, "slug")
	p, err := h.Service.GetBySlug(r.Context(), slug)
	if err != nil {
		mapProcedureError(w, h.Logger, "get procedure by slug", err, slug)
		return
	}
	if p.Status != domain.ProcedureStatusPublished {
		writeJSON(w, http.StatusNotFound, map[string]string{"error": "procedure not found"})
		return
	}
	writeJSON(w, http.StatusOK, p)
}

// AdminList serves GET /api/v1/admin/procedures. Returns every
// status. Gated by procedures:read upstream.
func (h *ProceduresHandler) AdminList(w http.ResponseWriter, r *http.Request) {
	limit := atoiDefault(r.URL.Query().Get("limit"), 50)
	offset := atoiDefault(r.URL.Query().Get("offset"), 0)
	ps, err := h.Service.List(r.Context(), limit, offset)
	if err != nil {
		h.Logger.Error("admin list procedures", zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"procedures": ps,
		"limit":      limit,
		"offset":     offset,
	})
}

// AdminGet serves GET /api/v1/admin/procedures/{id}. Returns the
// procedure regardless of status. Gated by procedures:read.
func (h *ProceduresHandler) AdminGet(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	p, err := h.Service.GetByID(r.Context(), id)
	if err != nil {
		mapProcedureError(w, h.Logger, "admin get procedure", err, id)
		return
	}
	writeJSON(w, http.StatusOK, p)
}

// AdminCreate serves POST /api/v1/admin/procedures. Gated by
// procedures:write.
func (h *ProceduresHandler) AdminCreate(w http.ResponseWriter, r *http.Request) {
	var req procedureRequest
	dec := json.NewDecoder(r.Body)
	dec.DisallowUnknownFields()
	if err := dec.Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid json"})
		return
	}

	p, err := h.Service.Create(r.Context(), service.CreateProcedureInput{
		Slug:           req.Slug,
		TitleTa:        req.TitleTa,
		TitleEn:        req.TitleEn,
		SummaryTa:      req.SummaryTa,
		SummaryEn:      req.SummaryEn,
		FeeLKRCents:    req.FeeLKRCents,
		SourceURL:      req.SourceURL,
		LastVerifiedAt: req.LastVerifiedAt,
		Status:         req.Status,
	})
	if err != nil {
		mapProcedureError(w, h.Logger, "create procedure", err, req.Slug)
		return
	}
	writeJSON(w, http.StatusCreated, p)
}

// AdminUpdate serves PUT /api/v1/admin/procedures/{id}. Gated by
// procedures:write.
func (h *ProceduresHandler) AdminUpdate(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	var req procedureRequest
	dec := json.NewDecoder(r.Body)
	dec.DisallowUnknownFields()
	if err := dec.Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid json"})
		return
	}

	p, err := h.Service.Update(r.Context(), service.UpdateProcedureInput{
		ID:             id,
		Slug:           req.Slug,
		TitleTa:        req.TitleTa,
		TitleEn:        req.TitleEn,
		SummaryTa:      req.SummaryTa,
		SummaryEn:      req.SummaryEn,
		FeeLKRCents:    req.FeeLKRCents,
		SourceURL:      req.SourceURL,
		LastVerifiedAt: req.LastVerifiedAt,
		Status:         req.Status,
	})
	if err != nil {
		mapProcedureError(w, h.Logger, "update procedure", err, id)
		return
	}
	writeJSON(w, http.StatusOK, p)
}

func mapProcedureError(
	w http.ResponseWriter, logger *zap.Logger, op string, err error, key string,
) {
	switch {
	case errors.Is(err, service.ErrInvalidID):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid id"})
	case errors.Is(err, service.ErrInvalidSlug):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid slug (lowercase letters, digits, hyphens; not leading/trailing)"})
	case errors.Is(err, service.ErrInvalidTitle):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid title (Tamil required, max 200 chars)"})
	case errors.Is(err, service.ErrInvalidSummary):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "summary too long"})
	case errors.Is(err, service.ErrInvalidSourceURL):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid source_url"})
	case errors.Is(err, service.ErrInvalidFee):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid fee_lkr_cents"})
	case errors.Is(err, service.ErrInvalidStatus):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid status"})
	case errors.Is(err, service.ErrSlugConflict):
		writeJSON(w, http.StatusConflict, map[string]string{"error": "slug already in use"})
	case errors.Is(err, service.ErrIllegalStatusChange):
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "illegal status transition (draft → published → archived only)"})
	case errors.Is(err, service.ErrProcedureNotFound):
		writeJSON(w, http.StatusNotFound, map[string]string{"error": "procedure not found"})
	default:
		logger.Error(op, zap.String("key", key), zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
	}
}
