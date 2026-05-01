package middleware

import (
	"net/http"

	"github.com/cloudparallax/veli/internal/auth"
)

// SessionCookieName is the name of the session cookie set by the
// auth handler and read by SessionAuth.
const SessionCookieName = "veli_session"

// SessionAuth reads the session cookie, verifies its HMAC signature
// against secret, and stuffs the resolved user_id into the request
// context. Invalid or expired cookies are silently ignored — the
// downstream RequirePermission renders the 401.
//
// Mount this globally in the router; it's complementary to the
// dev-mode AuthDevHeader (which trusts X-User-ID). When both are
// active and a cookie is present, the cookie wins because it runs
// first in the chain (configure mount order accordingly).
func SessionAuth(secret []byte) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			cookie, err := r.Cookie(SessionCookieName)
			if err == nil && cookie.Value != "" {
				if userID, _, err := auth.VerifySession(secret, cookie.Value); err == nil {
					r = r.WithContext(WithUserID(r.Context(), userID))
				}
			}
			next.ServeHTTP(w, r)
		})
	}
}
