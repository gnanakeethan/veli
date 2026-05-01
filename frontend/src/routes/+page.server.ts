import { env } from '$env/dynamic/private';
import { createApiClient, ApiError } from '$lib/api';
import type { HealthResponse, HelloResponse } from '$lib/api';

export interface BackendStatus {
	reachable: boolean;
	hello?: HelloResponse;
	health?: HealthResponse;
	error?: string;
}

export interface PageData {
	backend: BackendStatus;
}

export const load = async ({ fetch }): Promise<PageData> => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const client = createApiClient({ fetch, baseUrl });

	let hello: HelloResponse | undefined;
	let health: HealthResponse | undefined;
	let loadError: string | undefined;

	try {
		hello = await client.hello();
	} catch (err) {
		if (err instanceof ApiError) {
			loadError = `HTTP ${err.status}: ${err.message}`;
		} else if (err instanceof Error) {
			loadError = err.message;
		} else {
			loadError = 'unknown error';
		}
	}

	try {
		health = await client.health();
	} catch {
		// health probe failure is non-fatal; hello already captured the error
	}

	const reachable = hello !== undefined || health !== undefined;

	return {
		backend: {
			reachable,
			hello,
			health,
			error: reachable ? undefined : loadError
		}
	};
};
