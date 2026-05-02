import type {
	AdminMeResponse,
	ApiErrorEnvelope,
	CreateUserRequest,
	HealthResponse,
	HelloResponse,
	MeResponse,
	User,
	UserRolesResponse,
	UsersListResponse
} from './types';

/**
 * ApiError is thrown by the client when the backend returns a non-2xx
 * status. status carries the HTTP status code; message is the parsed
 * envelope's `error` field when present, or a generic fallback.
 */
export class ApiError extends Error {
	readonly status: number;
	readonly envelope?: ApiErrorEnvelope;

	constructor(status: number, message: string, envelope?: ApiErrorEnvelope) {
		super(message);
		this.name = 'ApiError';
		this.status = status;
		this.envelope = envelope;
	}
}

export interface ApiClient {
	health(): Promise<HealthResponse>;
	ready(): Promise<HealthResponse>;
	hello(): Promise<HelloResponse>;
	getUser(id: string): Promise<User>;
	createUser(input: CreateUserRequest): Promise<User>;

	/** GET /api/v1/auth/me — returns 401 (ApiError) when no session. */
	getMe(opts?: { headers?: HeadersInit }): Promise<MeResponse>;
	/** POST /api/v1/auth/logout — clears the session cookie. */
	logout(opts?: { headers?: HeadersInit }): Promise<void>;

	/** GET /api/v1/admin/me — actor's user_id + roles. */
	getAdminMe(opts?: { headers?: HeadersInit }): Promise<AdminMeResponse>;
	/** GET /api/v1/admin/users — gated by `users:list`. */
	listUsers(opts?: {
		limit?: number;
		offset?: number;
		headers?: HeadersInit;
	}): Promise<UsersListResponse>;
	/** GET /api/v1/admin/users/{id} — gated by `users:read`. */
	getAdminUser(id: string, opts?: { headers?: HeadersInit }): Promise<User>;
	/** GET /api/v1/admin/users/{id}/roles — gated by `roles:list`. */
	listUserRoles(id: string, opts?: { headers?: HeadersInit }): Promise<UserRolesResponse>;
	/** POST /api/v1/admin/users/{id}/roles — gated by `roles:assign`. */
	assignRole(id: string, code: string, opts?: { headers?: HeadersInit }): Promise<void>;
	/** DELETE /api/v1/admin/users/{id}/roles/{code} — gated by `roles:assign`. */
	revokeRole(id: string, code: string, opts?: { headers?: HeadersInit }): Promise<void>;
}

export interface ApiClientOptions {
	/**
	 * Fetch implementation. SvelteKit's load() exposes a context-aware
	 * fetch — pass that in for SSR-time request dedup and cookie
	 * forwarding. Outside SvelteKit, pass globalThis.fetch.
	 */
	fetch: typeof fetch;
	/**
	 * Base URL of the Veḷi backend API. In SvelteKit, comes from
	 * $env/dynamic/private VELI_API_BASE_URL (server-only).
	 */
	baseUrl: string;
}

/**
 * createApiClient returns a typed view of the Veḷi backend. The
 * client is intentionally framework-agnostic so it can be used from
 * +page.server.ts, +server.ts endpoints, hooks, and test code.
 */
export function createApiClient({ fetch, baseUrl }: ApiClientOptions): ApiClient {
	const root = baseUrl.replace(/\/$/, '');

	async function request<T>(path: string, init?: RequestInit): Promise<T> {
		const res = await fetch(`${root}${path}`, {
			...init,
			headers: {
				Accept: 'application/json',
				...(init?.headers ?? {})
			}
		});

		if (!res.ok) {
			let envelope: ApiErrorEnvelope | undefined;
			try {
				envelope = (await res.json()) as ApiErrorEnvelope;
			} catch {
				/* response was not JSON; fall through to generic message */
			}
			throw new ApiError(res.status, envelope?.error ?? `HTTP ${res.status}`, envelope);
		}

		return (await res.json()) as T;
	}

	return {
		health: () => request<HealthResponse>('/healthz'),
		ready: () => request<HealthResponse>('/readyz'),
		hello: () => request<HelloResponse>('/api/v1/hello'),
		getUser: (id: string) => request<User>(`/api/v1/users/${encodeURIComponent(id)}`),
		createUser: (input: CreateUserRequest) =>
			request<User>('/api/v1/users', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(input)
			}),

		getMe: (opts) => request<MeResponse>('/api/v1/auth/me', { headers: opts?.headers }),
		logout: async (opts) => {
			await request<unknown>('/api/v1/auth/logout', {
				method: 'POST',
				headers: opts?.headers
			});
		},

		getAdminMe: (opts) =>
			request<AdminMeResponse>('/api/v1/admin/me', { headers: opts?.headers }),
		listUsers: (opts) => {
			const params = new URLSearchParams();
			if (opts?.limit !== undefined) params.set('limit', String(opts.limit));
			if (opts?.offset !== undefined) params.set('offset', String(opts.offset));
			const qs = params.toString();
			return request<UsersListResponse>(
				`/api/v1/admin/users${qs ? `?${qs}` : ''}`,
				{ headers: opts?.headers }
			);
		},
		getAdminUser: (id, opts) =>
			request<User>(`/api/v1/admin/users/${encodeURIComponent(id)}`, {
				headers: opts?.headers
			}),
		listUserRoles: (id, opts) =>
			request<UserRolesResponse>(
				`/api/v1/admin/users/${encodeURIComponent(id)}/roles`,
				{ headers: opts?.headers }
			),
		assignRole: async (id, code, opts) => {
			await request<unknown>(`/api/v1/admin/users/${encodeURIComponent(id)}/roles`, {
				method: 'POST',
				headers: { 'Content-Type': 'application/json', ...(opts?.headers ?? {}) },
				body: JSON.stringify({ code })
			});
		},
		revokeRole: async (id, code, opts) => {
			await request<unknown>(
				`/api/v1/admin/users/${encodeURIComponent(id)}/roles/${encodeURIComponent(code)}`,
				{ method: 'DELETE', headers: opts?.headers }
			);
		}
	};
}
