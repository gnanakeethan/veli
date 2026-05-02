package service_test

import (
	"context"
	"errors"
	"strings"
	"testing"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
	"github.com/cloudparallax/veli/internal/service"
)

type stubUsersRepo struct {
	user domain.User
	err  error

	gotID      string
	gotCreated *domain.User
}

func (s *stubUsersRepo) GetByID(_ context.Context, id string) (domain.User, error) {
	s.gotID = id
	return s.user, s.err
}

// Create echoes whatever input the service produced so the test can
// assert ULID generation and trimming. Returns s.err to let tests
// simulate repository failures.
func (s *stubUsersRepo) Create(_ context.Context, user *domain.User) error {
	if s.err != nil {
		return s.err
	}
	s.gotCreated = user
	return nil
}

// List satisfies the UsersRepository interface; service-level List
// tests live separately and the GetByID/Create tests don't exercise
// this method, so an empty result is fine.
func (s *stubUsersRepo) List(_ context.Context, _, _ int) ([]domain.User, error) {
	return nil, s.err
}

// GetByEmail satisfies the UsersRepository interface; the email path
// is exercised by the admin bootstrap CLI, not by the service-level
// tests in this file.
func (s *stubUsersRepo) GetByEmail(_ context.Context, _ string) (domain.User, error) {
	return s.user, s.err
}

func TestUsersService_GetByID(t *testing.T) {
	const validULID = "01ARZ3NDEKTSV4RRFFQ69G5FAV"

	happyUser := domain.User{
		ID:          validULID,
		Phone:       "+94771234567",
		DisplayName: "Test User",
		Locale:      "ta",
	}

	boom := errors.New("connection refused")

	cases := []struct {
		name     string
		id       string
		repoUser domain.User
		repoErr  error
		wantUser domain.User
		wantErr  error
	}{
		{
			name:     "happy path",
			id:       validULID,
			repoUser: happyUser,
			wantUser: happyUser,
		},
		{
			name:    "empty id",
			id:      "",
			wantErr: service.ErrInvalidID,
		},
		{
			name:    "wrong length",
			id:      "01ARZ3NDEKTSV4RRFFQ69G5FA",
			wantErr: service.ErrInvalidID,
		},
		{
			name:    "lowercase letters",
			id:      "01arz3ndektsv4rrffq69g5fav",
			wantErr: service.ErrInvalidID,
		},
		{
			name:    "contains disallowed I",
			id:      "01IRZ3NDEKTSV4RRFFQ69G5FAV",
			wantErr: service.ErrInvalidID,
		},
		{
			name:    "contains disallowed O",
			id:      "01ORZ3NDEKTSV4RRFFQ69G5FAV",
			wantErr: service.ErrInvalidID,
		},
		{
			name:    "user not found passthrough",
			id:      validULID,
			repoErr: repository.ErrUserNotFound,
			wantErr: service.ErrUserNotFound,
		},
		{
			name:    "unexpected repo error wrapped",
			id:      validULID,
			repoErr: boom,
			wantErr: boom,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			repo := &stubUsersRepo{user: tc.repoUser, err: tc.repoErr}
			svc := service.NewUsersService(repo)

			got, err := svc.GetByID(context.Background(), tc.id)

			if tc.wantErr != nil {
				if err == nil {
					t.Fatalf("expected error %v, got nil", tc.wantErr)
				}
				if !errors.Is(err, tc.wantErr) {
					t.Fatalf("expected errors.Is(err, %v); got %v", tc.wantErr, err)
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if got != tc.wantUser {
				t.Fatalf("user mismatch:\n got  %+v\n want %+v", got, tc.wantUser)
			}
		})
	}
}

func TestUsersService_Create(t *testing.T) {
	boom := errors.New("constraint violation")
	const longName = // 201 characters, must fail validation
	"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuv" +
		"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvw"

	cases := []struct {
		name             string
		input            service.CreateUserInput
		repoErr          error
		wantErr          error
		wantTrimmedName  string
		wantTrimmedNIC   string
	}{
		{
			name: "happy path",
			input: service.CreateUserInput{
				Phone:       "+94771234567",
				DisplayName: "  Karuppiah Mahalingam  ",
				Locale:      "ta",
				NICNumber:   " 199012345678 ",
			},
			wantTrimmedName: "Karuppiah Mahalingam",
			wantTrimmedNIC:  "199012345678",
		},
		{
			name: "happy path no nic",
			input: service.CreateUserInput{
				Phone:       "+447911123456",
				DisplayName: "Diaspora Donor",
				Locale:      "en",
			},
			wantTrimmedName: "Diaspora Donor",
		},
		{
			name: "missing leading plus",
			input: service.CreateUserInput{
				Phone:       "94771234567",
				DisplayName: "X",
				Locale:      "ta",
			},
			wantErr: service.ErrInvalidPhone,
		},
		{
			name: "phone leading zero",
			input: service.CreateUserInput{
				Phone:       "+0771234567",
				DisplayName: "X",
				Locale:      "ta",
			},
			wantErr: service.ErrInvalidPhone,
		},
		{
			name: "phone too short",
			input: service.CreateUserInput{
				Phone:       "+94123",
				DisplayName: "X",
				Locale:      "ta",
			},
			wantErr: service.ErrInvalidPhone,
		},
		{
			name: "phone non-digit",
			input: service.CreateUserInput{
				Phone:       "+9477abc4567",
				DisplayName: "X",
				Locale:      "ta",
			},
			wantErr: service.ErrInvalidPhone,
		},
		{
			name: "unsupported locale",
			input: service.CreateUserInput{
				Phone:       "+94771234567",
				DisplayName: "X",
				Locale:      "fr",
			},
			wantErr: service.ErrInvalidLocale,
		},
		{
			name: "empty display name",
			input: service.CreateUserInput{
				Phone:       "+94771234567",
				DisplayName: "   ",
				Locale:      "ta",
			},
			wantErr: service.ErrInvalidDisplayName,
		},
		{
			name: "display name too long",
			input: service.CreateUserInput{
				Phone:       "+94771234567",
				DisplayName: longName,
				Locale:      "ta",
			},
			wantErr: service.ErrInvalidDisplayName,
		},
		{
			name: "repository failure wrapped",
			input: service.CreateUserInput{
				Phone:       "+94771234567",
				DisplayName: "X",
				Locale:      "ta",
			},
			repoErr: boom,
			wantErr: boom,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			repo := &stubUsersRepo{err: tc.repoErr}
			svc := service.NewUsersService(repo)

			got, err := svc.Create(context.Background(), tc.input)

			if tc.wantErr != nil {
				if err == nil {
					t.Fatalf("expected error %v, got nil", tc.wantErr)
				}
				if !errors.Is(err, tc.wantErr) {
					t.Fatalf("expected errors.Is(err, %v); got %v", tc.wantErr, err)
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}

			if !isWellFormedULID(got.ID) {
				t.Fatalf("expected service to mint a well-formed ULID, got %q", got.ID)
			}
			if got.DisplayName != tc.wantTrimmedName {
				t.Fatalf("display name not trimmed: got %q want %q", got.DisplayName, tc.wantTrimmedName)
			}
			if got.NICNumber != tc.wantTrimmedNIC {
				t.Fatalf("nic not trimmed: got %q want %q", got.NICNumber, tc.wantTrimmedNIC)
			}
			if got.Phone != tc.input.Phone {
				t.Fatalf("phone mismatch: got %q want %q", got.Phone, tc.input.Phone)
			}
			if got.Locale != tc.input.Locale {
				t.Fatalf("locale mismatch: got %q want %q", got.Locale, tc.input.Locale)
			}
			if repo.gotCreated == nil {
				t.Fatalf("repository.Create was not called")
			}
		})
	}
}

// isWellFormedULID is a private mirror of the service-internal check
// so the test can assert ULID generation without exporting the
// validator from the service package.
func isWellFormedULID(s string) bool {
	if len(s) != 26 {
		return false
	}
	const alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"
	for _, c := range s {
		if !strings.ContainsRune(alphabet, c) {
			return false
		}
	}
	return true
}
