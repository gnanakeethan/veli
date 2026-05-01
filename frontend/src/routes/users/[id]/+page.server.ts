import { env } from '$env/dynamic/private';
import { createApiClient, ApiError } from '$lib/api';
import type { User } from '$lib/api';

type UserError = 'invalid_id' | 'not_found' | 'server';

export interface PageData {
	user?: User;
	error?: UserError;
}

export const load = async ({ fetch, params }): Promise<PageData> => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const client = createApiClient({ fetch, baseUrl });

	try {
		const user = await client.getUser(params.id);
		return { user };
	} catch (err) {
		if (err instanceof ApiError) {
			if (err.status === 400) {
				return { error: 'invalid_id' };
			}
			if (err.status === 404) {
				return { error: 'not_found' };
			}
			return { error: 'server' };
		}
		return { error: 'server' };
	}
};
