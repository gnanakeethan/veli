/**
 * Wire-format types mirroring the Go domain types served by the
 * backend at /api/v1/*. Field names match the backend JSON tags
 * (snake_case); we don't re-shape into camelCase because doing so
 * would require a transform layer for every payload, and Tamil-first
 * audit log displays read more cleanly when frontend and backend
 * agree on field names.
 *
 * Source of truth: github.com/cloudparallax/veli/internal/domain.
 * If a field is added or removed there, mirror the change here.
 */

/**
 * Verification tier as labelled in the v1.5 plan. The values must
 * match the backend's domain.VerificationTier constants exactly,
 * which are also the SQL CHECK constraint values.
 */
export type VerificationTier = 'self_asserted' | 'community_corroborated' | 'authority_attested';

/**
 * User mirrors backend domain.User. nic_number is omitted when the
 * user has not had their NIC linked (authority-attested flows only).
 */
export interface User {
	id: string;
	phone: string;
	nic_number?: string;
	display_name: string;
	locale: string;
	created_at: string;
	updated_at: string;
}

/** Response shape from GET /api/v1/hello. */
export interface HelloResponse {
	message: string;
	phase: number;
}

/** Response shape from /healthz and /readyz. */
export interface HealthResponse {
	status: string;
	reason?: string;
}

/** Standard error envelope returned by the backend on 4xx/5xx. */
export interface ApiErrorEnvelope {
	error: string;
}

/** Body for POST /api/v1/users. */
export interface CreateUserRequest {
	phone: string;
	display_name: string;
	locale: string;
	nic_number?: string;
}
