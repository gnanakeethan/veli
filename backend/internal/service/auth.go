package service

import (
	"context"
	"errors"
	"fmt"

	"github.com/coreos/go-oidc/v3/oidc"
	"golang.org/x/oauth2"

	"github.com/cloudparallax/veli/internal/repository"
)

// Sentinel errors for the Google OIDC flow.
var (
	ErrAdminNotProvisioned = errors.New("admin not provisioned: no veli user matches the google email")
	ErrInvalidIDToken      = errors.New("invalid google id token")
)

// GoogleAuthConfig is the subset of config the AuthService needs.
type GoogleAuthConfig struct {
	ClientID     string
	ClientSecret string
	RedirectURL  string // absolute URL the Google callback redirects to
}

// AuthService runs the Google OIDC handshake and the find-or-link
// logic that maps a Google subject onto an existing Veḷi user. End
// users register via the phone path; this service refuses sign-in
// for an unknown email.
type AuthService struct {
	provider     *oidc.Provider
	oauth2Config *oauth2.Config
	verifier     *oidc.IDTokenVerifier
	external     repository.ExternalIdentitiesRepository
}

// NewAuthService creates the service. Returns nil + nil error when
// cfg.ClientID is empty (auth disabled, useful for local dev), so
// callers can safely defer mounting the routes.
func NewAuthService(ctx context.Context, cfg GoogleAuthConfig, externalRepo repository.ExternalIdentitiesRepository) (*AuthService, error) {
	if cfg.ClientID == "" {
		return nil, nil
	}
	provider, err := oidc.NewProvider(ctx, "https://accounts.google.com")
	if err != nil {
		return nil, fmt.Errorf("oidc provider: %w", err)
	}
	return &AuthService{
		provider: provider,
		oauth2Config: &oauth2.Config{
			ClientID:     cfg.ClientID,
			ClientSecret: cfg.ClientSecret,
			Endpoint:     provider.Endpoint(),
			RedirectURL:  cfg.RedirectURL,
			Scopes:       []string{oidc.ScopeOpenID, "email", "profile"},
		},
		verifier: provider.Verifier(&oidc.Config{ClientID: cfg.ClientID}),
		external: externalRepo,
	}, nil
}

// AuthorizeURL returns the URL to redirect the user agent to. state
// must be a freshly minted random string the handler also stores in
// a short-lived cookie for CSRF protection.
func (s *AuthService) AuthorizeURL(state string) string {
	return s.oauth2Config.AuthCodeURL(state)
}

// HandleCallback exchanges the authorization code, validates the ID
// token, and finds-or-links the Google subject to a Veḷi user. The
// user must already exist (matched by email); we do not auto-create
// users from Google sign-in. Returns the user_id on success.
func (s *AuthService) HandleCallback(ctx context.Context, code string) (string, error) {
	token, err := s.oauth2Config.Exchange(ctx, code)
	if err != nil {
		return "", fmt.Errorf("exchange code: %w", err)
	}
	rawIDToken, ok := token.Extra("id_token").(string)
	if !ok || rawIDToken == "" {
		return "", ErrInvalidIDToken
	}
	idToken, err := s.verifier.Verify(ctx, rawIDToken)
	if err != nil {
		return "", fmt.Errorf("verify id token: %w", err)
	}

	var claims struct {
		Subject       string `json:"sub"`
		Email         string `json:"email"`
		EmailVerified bool   `json:"email_verified"`
	}
	if err := idToken.Claims(&claims); err != nil {
		return "", fmt.Errorf("decode id token claims: %w", err)
	}
	if claims.Subject == "" || claims.Email == "" {
		return "", ErrInvalidIDToken
	}

	// Already-linked subject: refresh last_seen_at and return the user.
	if existing, err := s.external.FindByProviderSubject(ctx, "google", claims.Subject); err == nil {
		if err := s.external.Touch(ctx, "google", claims.Subject); err != nil {
			return "", fmt.Errorf("touch external identity: %w", err)
		}
		return existing.UserID, nil
	} else if !errors.Is(err, repository.ErrExternalIdentityNotFound) {
		return "", fmt.Errorf("find external identity: %w", err)
	}

	// First-time sign-in: must match an existing user by email.
	userID, err := s.external.FindUserIDByEmail(ctx, claims.Email)
	if err != nil {
		if errors.Is(err, repository.ErrUserNotFound) {
			return "", ErrAdminNotProvisioned
		}
		return "", fmt.Errorf("find user by email: %w", err)
	}
	if err := s.external.Link(ctx, "google", claims.Subject, userID, claims.Email); err != nil {
		return "", fmt.Errorf("link external identity: %w", err)
	}
	return userID, nil
}
