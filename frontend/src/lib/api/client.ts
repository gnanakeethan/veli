import type {
	ApiErrorEnvelope,
	HealthResponse,
	HelloResponse,
	User
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
		getUser: (id: string) => request<User>(`/api/v1/users/${encodeURIComponent(id)}`)
	};
}
