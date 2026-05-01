package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"

	"github.com/cloudparallax/veli/internal/service"
)

// UsersHandler exposes user-related HTTP routes. The service is
// constructed once at startup and shared across requests.
type UsersHandler struct {
	Service *service.UsersService
	Logger  *zap.Logger
}

// Get serves GET /api/v1/users/{id}.
func (h *UsersHandler) Get(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	user, err := h.Service.GetByID(r.Context(), id)
	if err != nil {
		switch {
		case errors.Is(err, service.ErrInvalidID):
			writeJSON(w, http.StatusBadRequest, map[string]string{
				"error": "invalid user id",
			})
		case errors.Is(err, service.ErrUserNotFound):
			writeJSON(w, http.StatusNotFound, map[string]string{
				"error": "user not found",
			})
		default:
			h.Logger.Error("get user", zap.String("id", id), zap.Error(err))
			writeJSON(w, http.StatusInternalServerError, map[string]string{
				"error": "internal error",
			})
		}
		return
	}
	writeJSON(w, http.StatusOK, user)
}

// createUserRequest is the JSON envelope POST /api/v1/users accepts.
// Field names mirror domain.User wire format so the same client type
// can be reused on the frontend.
type createUserRequest struct {
	Phone       string `json:"phone"`
	DisplayName string `json:"display_name"`
	Locale      string `json:"locale"`
	NICNumber   string `json:"nic_number,omitempty"`
}

// Create serves POST /api/v1/users. Returns 201 with the persisted
// user on success; 400 with a typed error envelope on validation
// failure; 500 (logged) on unexpected repository failure.
func (h *UsersHandler) Create(w http.ResponseWriter, r *http.Request) {
	var req createUserRequest
	dec := json.NewDecoder(r.Body)
	dec.DisallowUnknownFields()
	if err := dec.Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "invalid json",
		})
		return
	}

	user, err := h.Service.Create(r.Context(), service.CreateUserInput{
		Phone:       req.Phone,
		DisplayName: req.DisplayName,
		Locale:      req.Locale,
		NICNumber:   req.NICNumber,
	})
	if err != nil {
		switch {
		case errors.Is(err, service.ErrInvalidPhone):
			writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid phone"})
		case errors.Is(err, service.ErrInvalidLocale):
			writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid locale"})
		case errors.Is(err, service.ErrInvalidDisplayName):
			writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid display_name"})
		default:
			h.Logger.Error("create user", zap.Error(err))
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		}
		return
	}
	writeJSON(w, http.StatusCreated, user)
}
