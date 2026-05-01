package handler

import (
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
