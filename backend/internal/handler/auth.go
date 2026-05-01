package handler

import (
	"crypto/rand"
	"encoding/base64"
	"errors"
	"net/http"
	"time"

	"go.uber.org/zap"

	"github.com/cloudparallax/veli/internal/auth"
	velimw "github.com/cloudparallax/veli/internal/middleware"
	"github.com/cloudparallax/veli/internal/service"
)

// AuthHandler exposes the Google OIDC start/callback routes plus
// /me and /logout. AuthService may be nil when Google credentials
// aren't configured; in that case GoogleStart and GoogleCallback
// return 503 (the routes are still registered so the frontend can
// render a clear error).
type AuthHandler struct {
	Auth          *service.AuthService
	RBAC          *service.RBACService
	Users         *service.UsersService
	SessionSecret []byte
	FrontendURL   string
	Logger        *zap.Logger
}

const (
	stateCookieName    = "veli_oauth_state"
	stateCookieMaxAge  = 10 * 60        // 10 minutes
	sessionCookieTTL   = 12 * time.Hour // re-authenticate twice a day
	stateRandomBytes   = 32
	defaultRedirectURL = "/admin"
)

// GoogleStart redirects the user to Google's authorisation endpoint.
// It generates a random state, stamps it into a short-lived
// HttpOnly cookie, and sends the agent on its way.
func (h *AuthHandler) GoogleStart(w http.ResponseWriter, r *http.Request) {
	if h.Auth == nil {
		writeJSON(w, http.StatusServiceUnavailable, map[string]string{
			"error": "google auth not configured",
		})
		return
	}
	state, err := randomState()
	if err != nil {
		h.Logger.Error("generate oauth state", zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	http.SetCookie(w, &http.Cookie{
		Name:     stateCookieName,
		Value:    state,
		Path:     "/",
		HttpOnly: true,
		Secure:   isHTTPS(r),
		SameSite: http.SameSiteLaxMode,
		MaxAge:   stateCookieMaxAge,
	})
	http.Redirect(w, r, h.Auth.AuthorizeURL(state), http.StatusFound)
}

// GoogleCallback validates the state cookie, exchanges the code,
// and (on success) sets the session cookie and redirects to the
// frontend's admin landing.
func (h *AuthHandler) GoogleCallback(w http.ResponseWriter, r *http.Request) {
	if h.Auth == nil {
		writeJSON(w, http.StatusServiceUnavailable, map[string]string{
			"error": "google auth not configured",
		})
		return
	}

	stateCookie, err := r.Cookie(stateCookieName)
	if err != nil || stateCookie.Value == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "missing state cookie"})
		return
	}
	if r.URL.Query().Get("state") != stateCookie.Value {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "state mismatch"})
		return
	}

	// Clear the state cookie regardless of outcome — single-use.
	http.SetCookie(w, &http.Cookie{
		Name:     stateCookieName,
		Value:    "",
		Path:     "/",
		HttpOnly: true,
		Secure:   isHTTPS(r),
		SameSite: http.SameSiteLaxMode,
		MaxAge:   -1,
	})

	code := r.URL.Query().Get("code")
	if code == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "missing code"})
		return
	}

	userID, err := h.Auth.HandleCallback(r.Context(), code)
	if err != nil {
		switch {
		case errors.Is(err, service.ErrAdminNotProvisioned):
			writeJSON(w, http.StatusForbidden, map[string]string{
				"error": "admin not provisioned",
			})
		case errors.Is(err, service.ErrInvalidIDToken):
			writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid id token"})
		default:
			h.Logger.Error("google callback", zap.Error(err))
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		}
		return
	}

	expiresAt := time.Now().Add(sessionCookieTTL)
	cookieValue, err := auth.SignSession(h.SessionSecret, userID, expiresAt)
	if err != nil {
		h.Logger.Error("sign session", zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	http.SetCookie(w, &http.Cookie{
		Name:     velimw.SessionCookieName,
		Value:    cookieValue,
		Path:     "/",
		HttpOnly: true,
		Secure:   isHTTPS(r),
		SameSite: http.SameSiteLaxMode,
		Expires:  expiresAt,
	})

	dest := h.FrontendURL
	if dest == "" {
		dest = defaultRedirectURL
	} else {
		dest += defaultRedirectURL
	}
	http.Redirect(w, r, dest, http.StatusFound)
}

// Me returns the cookie-resolved user plus their roles. 401 when no
// session is present.
func (h *AuthHandler) Me(w http.ResponseWriter, r *http.Request) {
	userID, ok := velimw.UserIDFromContext(r.Context())
	if !ok {
		writeJSON(w, http.StatusUnauthorized, map[string]string{"error": "unauthenticated"})
		return
	}
	user, err := h.Users.GetByID(r.Context(), userID)
	if err != nil {
		h.Logger.Error("auth/me get user", zap.String("user_id", userID), zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	roles, err := h.RBAC.ListUserRoles(r.Context(), userID)
	if err != nil {
		h.Logger.Error("auth/me list roles", zap.String("user_id", userID), zap.Error(err))
		writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal error"})
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{
		"user":  user,
		"roles": roles,
	})
}

// Logout clears the session cookie. Always returns 200 — clearing
// is idempotent.
func (h *AuthHandler) Logout(w http.ResponseWriter, r *http.Request) {
	http.SetCookie(w, &http.Cookie{
		Name:     velimw.SessionCookieName,
		Value:    "",
		Path:     "/",
		HttpOnly: true,
		Secure:   isHTTPS(r),
		SameSite: http.SameSiteLaxMode,
		MaxAge:   -1,
	})
	writeJSON(w, http.StatusOK, map[string]string{"status": "logged out"})
}

func randomState() (string, error) {
	buf := make([]byte, stateRandomBytes)
	if _, err := rand.Read(buf); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(buf), nil
}

func isHTTPS(r *http.Request) bool {
	if r.TLS != nil {
		return true
	}
	if r.Header.Get("X-Forwarded-Proto") == "https" {
		return true
	}
	return false
}
