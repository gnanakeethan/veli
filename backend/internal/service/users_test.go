package service_test

import (
	"context"
	"errors"
	"testing"

	"github.com/cloudparallax/veli/internal/domain"
	"github.com/cloudparallax/veli/internal/repository"
	"github.com/cloudparallax/veli/internal/service"
)

type stubUsersRepo struct {
	user domain.User
	err  error

	gotID string
}

func (s *stubUsersRepo) GetByID(_ context.Context, id string) (domain.User, error) {
	s.gotID = id
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
