package middleware

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"

	"go.uber.org/zap"

	"github.com/cloudparallax/veli/internal/service"
)

type contextKey string

const userIDKey contextKey = "veli/user-id"

// AuthDevHeader is a development-only authentication shim. When the
// VELI_AUTH_DEVMODE config flag is set, mount this middleware so the
// request context picks up the actor's user_id from the X-User-ID
// header. Production MUST replace this with a real auth middleware
// (phone-OTP, OIDC, etc.) before any deploy.
//
// The middleware never short-circuits — a missing header just means
// no actor is recorded, which RequirePermission will translate to
// 401 Unauthenticated downstream.
func AuthDevHeader(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if userID := r.Header.Get("X-User-ID"); userID != "" {
			r = r.WithContext(WithUserID(r.Context(), userID))
		}
		next.ServeHTTP(w, r)
	})
}

// WithUserID returns a new context with userID stamped in. Other
// authentication middlewares (the Google OIDC flow, eventually) will
// call this with the resolved subject after validating the session.
func WithUserID(ctx context.Context, userID string) context.Context {
	return context.WithValue(ctx, userIDKey, userID)
}

// UserIDFromContext returns the actor's user_id and a flag indicating
// whether one was present. Callers that require an authenticated
// actor should treat ok=false as a 401.
func UserIDFromContext(ctx context.Context) (string, bool) {
	id, ok := ctx.Value(userIDKey).(string)
	return id, ok && id != ""
}

// RequirePermission produces a chi-compatible middleware that blocks
// the request unless the context-resolved actor holds permissionCode.
// It returns 401 with {"error":"unauthenticated"} when no actor is
// present, 403 with {"error":"forbidden"} when the actor lacks the
// permission, and 500 (logged) on lookup failure.
func RequirePermission(rbac *service.RBACService, logger *zap.Logger, permissionCode string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			userID, _ := UserIDFromContext(r.Context())
			if err := rbac.RequirePermission(r.Context(), userID, permissionCode); err != nil {
				switch {
				case errors.Is(err, service.ErrUnauthenticated):
					writeJSONError(w, http.StatusUnauthorized, "unauthenticated")
				case errors.Is(err, service.ErrForbidden):
					writeJSONError(w, http.StatusForbidden, "forbidden")
				default:
					logger.Error("permission check",
						zap.String("permission", permissionCode),
						zap.String("user_id", userID),
						zap.Error(err))
					writeJSONError(w, http.StatusInternalServerError, "internal error")
				}
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}

func writeJSONError(w http.ResponseWriter, status int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(map[string]string{"error": message})
}
