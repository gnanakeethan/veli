// Package auth provides session-cookie sign/verify for the Veḷi admin
// auth path. The cookie format is base64url(payload) "." base64url(sig)
// where sig is HMAC-SHA256 over the encoded payload using a shared
// secret. Stateless — no DB roundtrip per request.
package auth

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Errors returned by VerifySession. Both are non-fatal — the caller
// (the SessionAuth middleware) treats either as "no actor" and lets
// the downstream RequirePermission render a 401.
var (
	ErrInvalidSession = errors.New("invalid session")
	ErrExpiredSession = errors.New("expired session")
)

// SessionPayload is the cookie body. sub is the user_id; exp is a
// Unix timestamp in seconds.
type SessionPayload struct {
	UserID    string `json:"sub"`
	ExpiresAt int64  `json:"exp"`
}

// SignSession returns the cookie value encoding userID with an
// expiry. The secret must be at least 16 bytes; the function does
// not validate that — pass a configured-checked value.
func SignSession(secret []byte, userID string, expiresAt time.Time) (string, error) {
	body, err := json.Marshal(SessionPayload{UserID: userID, ExpiresAt: expiresAt.Unix()})
	if err != nil {
		return "", fmt.Errorf("marshal session payload: %w", err)
	}
	encoded := base64.RawURLEncoding.EncodeToString(body)
	mac := hmac.New(sha256.New, secret)
	mac.Write([]byte(encoded))
	sig := base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
	return encoded + "." + sig, nil
}

// VerifySession returns the user_id and expiry encoded in cookieValue,
// or an error if the signature, format, or expiry is invalid.
func VerifySession(secret []byte, cookieValue string) (string, time.Time, error) {
	parts := strings.SplitN(cookieValue, ".", 2)
	if len(parts) != 2 || parts[0] == "" || parts[1] == "" {
		return "", time.Time{}, ErrInvalidSession
	}
	mac := hmac.New(sha256.New, secret)
	mac.Write([]byte(parts[0]))
	expected := base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
	if !hmac.Equal([]byte(parts[1]), []byte(expected)) {
		return "", time.Time{}, ErrInvalidSession
	}
	body, err := base64.RawURLEncoding.DecodeString(parts[0])
	if err != nil {
		return "", time.Time{}, ErrInvalidSession
	}
	var payload SessionPayload
	if err := json.Unmarshal(body, &payload); err != nil {
		return "", time.Time{}, ErrInvalidSession
	}
	expires := time.Unix(payload.ExpiresAt, 0)
	if time.Now().After(expires) {
		return "", time.Time{}, ErrExpiredSession
	}
	if payload.UserID == "" {
		return "", time.Time{}, ErrInvalidSession
	}
	return payload.UserID, expires, nil
}
