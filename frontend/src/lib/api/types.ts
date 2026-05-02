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
 * email is populated for admin users (linked via Google OIDC sign-in)
 * and absent for ordinary phone-anchored users.
 */
export interface User {
	id: string;
	phone: string;
	email?: string;
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

/**
 * Role mirrors backend domain.Role. The id is a ULID; code is the
 * stable handle (`super_admin`, `manager`, `user`) used everywhere
 * in policy checks. `permissions` is populated by RBACService.ListUserRoles
 * — when it appears on the wire it carries the role's grants.
 */
export interface Role {
	id: string;
	code: string;
	display_name: string;
	created_at: string;
	permissions?: Permission[];
}

/** Permission mirrors backend domain.Permission. */
export interface Permission {
	id: string;
	code: string;
	display_name: string;
	created_at: string;
}

/**
 * Response shape from GET /api/v1/auth/me. user is the cookie-resolved
 * actor; roles is the flat list of roles they hold (each carrying its
 * grants). 401 from this endpoint means no session — handled at the
 * SvelteKit layer by redirecting to /admin/login.
 */
export interface MeResponse {
	user: User;
	roles: Role[];
}

/**
 * Response shape from GET /api/v1/admin/me. Lighter than auth/me —
 * only carries the actor's id + roles (no full user record).
 */
export interface AdminMeResponse {
	user_id: string;
	roles: Role[];
}

/** Response shape from GET /api/v1/admin/users. */
export interface UsersListResponse {
	users: User[];
	limit: number;
	offset: number;
}

/** Response shape from GET /api/v1/admin/users/{id}/roles. */
export interface UserRolesResponse {
	roles: Role[];
}

/**
 * Document mirrors backend domain.Document. gps_lat/gps_lng are
 * present only when the device shared location at capture time;
 * absence is *distinct* from "0,0" and matters for chain-of-custody.
 */
export interface Document {
	id: string;
	user_id: string;
	kind: string;
	storage_uri: string;
	captured_at: string;
	gps_lat?: number;
	gps_lng?: number;
	device_id?: string;
	created_at: string;
}

/** Body for POST /api/v1/admin/documents. */
export interface CreateDocumentRequest {
	user_id: string;
	kind: string;
	storage_uri: string;
	captured_at: string;
	gps_lat?: number;
	gps_lng?: number;
	device_id?: string;
}

/** Response shape from GET /api/v1/admin/documents. */
export interface DocumentsListResponse {
	documents: Document[];
	limit: number;
	offset: number;
	user_id?: string;
}

/**
 * Verification mirrors backend domain.Verification. tier is the
 * normative three-tier value; the platform never inflates a lower
 * tier to a higher one.
 */
export interface Verification {
	id: string;
	document_id: string;
	tier: VerificationTier;
	attester_id: string;
	notes?: string;
	verified_at: string;
}

/** Body for POST /api/v1/admin/verifications. */
export interface CreateVerificationRequest {
	document_id: string;
	tier: VerificationTier;
	attester_id: string;
	notes?: string;
}

/** Response shape from GET /api/v1/admin/documents/{id}/verifications. */
export interface VerificationsListResponse {
	verifications: Verification[];
	document_id: string;
}

/**
 * ProcedureStatus mirrors backend domain.ProcedureStatus. Citizens
 * never see anything but `published` via the public API; admin views
 * surface drafts and archived too.
 */
export type ProcedureStatus = 'draft' | 'published' | 'archived';

/**
 * Procedure mirrors backend domain.Procedure. fee_lkr_cents is in
 * integer cents (LKR × 100) — divide by 100 for the display value;
 * absence means the fee is not fixed at this verification level.
 * last_verified_at is the citation timestamp shown in the trust card.
 */
export interface Procedure {
	id: string;
	slug: string;
	title_ta: string;
	title_en?: string;
	summary_ta?: string;
	summary_en?: string;
	body_ta?: string;
	body_en?: string;
	fee_lkr_cents?: number;
	source_url?: string;
	last_verified_at?: string;
	status: ProcedureStatus;
	created_at: string;
	updated_at: string;
}

/** Body for POST/PUT /api/v1/admin/procedures. */
export interface ProcedureRequest {
	slug: string;
	title_ta: string;
	title_en?: string;
	summary_ta?: string;
	summary_en?: string;
	body_ta?: string;
	body_en?: string;
	fee_lkr_cents?: number | null;
	source_url?: string;
	last_verified_at?: string;
	status?: ProcedureStatus;
}

/** Response shape from GET /api/v1/procedures (and admin variant). */
export interface ProceduresListResponse {
	procedures: Procedure[];
	limit: number;
	offset: number;
}
