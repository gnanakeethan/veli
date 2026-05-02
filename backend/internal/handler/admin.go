package handler

import (
	"encoding/json"
	"errors"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"

	velimw "github.com/cloudparallax/veli/internal/middleware"
	"github.com/cloudparallax/veli/internal/repository"
	"github.com/cloudparallax/veli/internal/service"
)

// AdminHandler exposes administrative routes guarded by RBAC
// permission checks. Construction is mechanical — wire it once at
// startup; no per-request state.
type AdminHandler struct {
	Users  *service.UsersService
	RBAC   *service.RBACService
	Logger *zap.Logger
}

// Me returns the authenticated actor's user_id and the roles they
// hold. No additional permission gate beyond the auth requirement
// at the chi route level (every authenticated user can read their
// own roster).
func (h *AdminHandler) Me(w http.ResponseWriter, r *http.Request) {
	userID, ok := velimw.UserIDFromContext(r.Context())
	if !ok {
		writeJSON(w, http.StatusUnauthorized, map[string]string{"error": "unauthenticated"})
		return
	}
	roles, err := h.RBAC.ListUserRoles(r.Context(), userID)
	if err != nil {
		h.Logger.Error("admin/me list roles", zap.String("user_id", userID), zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"user_id": userID,
		"roles":   roles,
	})
}

// GetUser serves GET /api/v1/admin/users/{id}. Returns 404 when the
// id is unknown; 400 when the id isn't a valid ULID. Requires
// permission `users:read` (gated upstream).
func (h *AdminHandler) GetUser(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	user, err := h.Users.GetByID(r.Context(), id)
	if err != nil {
		switch {
		case errors.Is(err, service.ErrInvalidID):
			writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid user id"})
		case errors.Is(err, service.ErrUserNotFound):
			writeJSON(w, http.StatusNotFound, map[string]string{"error": "user not found"})
		default:
			h.Logger.Error("admin get user", zap.String("user_id", id), zap.Error(err))
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		}
		return
	}
	writeJSON(w, http.StatusOK, user)
}

// ListUsers serves GET /api/v1/admin/users?limit=&offset=. Both
// query params are optional; defaults are applied by the service.
// Requires permission `users:list` (gated upstream).
func (h *AdminHandler) ListUsers(w http.ResponseWriter, r *http.Request) {
	limit := atoiDefault(r.URL.Query().Get("limit"), 50)
	offset := atoiDefault(r.URL.Query().Get("offset"), 0)

	users, err := h.Users.List(r.Context(), limit, offset)
	if err != nil {
		h.Logger.Error("admin list users", zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"users":  users,
		"limit":  limit,
		"offset": offset,
	})
}

// ListUserRoles serves GET /api/v1/admin/users/{id}/roles. Requires
// permission `roles:list` (gated upstream).
func (h *AdminHandler) ListUserRoles(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "id")
	roles, err := h.RBAC.ListUserRoles(r.Context(), userID)
	if err != nil {
		h.Logger.Error("admin list user roles", zap.String("user_id", userID), zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{"roles": roles})
}

type assignRoleRequest struct {
	Code string `json:"code"`
}

// AssignRole serves POST /api/v1/admin/users/{id}/roles. Body:
// {"code":"manager"}. Requires permission `roles:assign` (gated
// upstream).
func (h *AdminHandler) AssignRole(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "id")
	actorID, _ := velimw.UserIDFromContext(r.Context())

	var req assignRoleRequest
	dec := json.NewDecoder(r.Body)
	dec.DisallowUnknownFields()
	if err := dec.Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid json"})
		return
	}
	if req.Code == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "missing role code"})
		return
	}

	if err := h.RBAC.AssignRoleByCode(r.Context(), userID, req.Code, actorID); err != nil {
		switch {
		case errors.Is(err, service.ErrRoleNotFound):
			writeJSON(w, http.StatusNotFound, map[string]string{"error": "role not found"})
		default:
			h.Logger.Error("assign role", zap.String("user_id", userID), zap.String("role_code", req.Code), zap.Error(err))
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		}
		return
	}
	writeJSON(w, http.StatusCreated, map[string]string{"status": "assigned"})
}

// RevokeRole serves DELETE /api/v1/admin/users/{id}/roles/{code}.
// Requires permission `roles:assign` (gated upstream).
func (h *AdminHandler) RevokeRole(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "id")
	roleCode := chi.URLParam(r, "code")

	if err := h.RBAC.RevokeRoleByCode(r.Context(), userID, roleCode); err != nil {
		switch {
		case errors.Is(err, service.ErrRoleNotFound):
			writeJSON(w, http.StatusNotFound, map[string]string{"error": "role not found"})
		case errors.Is(err, repository.ErrUserRoleNotFound):
			writeJSON(w, http.StatusNotFound, map[string]string{"error": "user does not hold role"})
		default:
			h.Logger.Error("revoke role", zap.String("user_id", userID), zap.String("role_code", roleCode), zap.Error(err))
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		}
		return
	}
	writeJSON(w, http.StatusOK, map[string]string{"status": "revoked"})
}

func atoiDefault(s string, def int) int {
	if s == "" {
		return def
	}
	v, err := strconv.Atoi(s)
	if err != nil {
		return def
	}
	return v
}
