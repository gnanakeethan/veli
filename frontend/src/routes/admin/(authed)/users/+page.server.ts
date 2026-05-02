import { error } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { PageServerLoad } from './$types';

const PAGE_SIZE = 50;

/**
 * Loads the paginated user list. The backend's /api/v1/admin/users
 * endpoint is gated by `users:list`; if the actor lacks it, the
 * service returns 403 and we surface it as a SvelteKit error so
 * the user gets a coherent page rather than a blank list.
 */
export const load: PageServerLoad = async ({ fetch, request, url }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	const offsetParam = url.searchParams.get('offset');
	const offset = Math.max(0, Number.isFinite(Number(offsetParam)) ? Number(offsetParam) : 0);

	try {
		const result = await client.listUsers({
			limit: PAGE_SIZE,
			offset,
			headers: { cookie }
		});
		return {
			users: result.users,
			limit: result.limit,
			offset: result.offset,
			pageSize: PAGE_SIZE
		};
	} catch (err) {
		if (err instanceof ApiError && err.status === 403) {
			throw error(403, 'You do not have permission to list users.');
		}
		if (err instanceof ApiError) {
			throw error(err.status, err.message);
		}
		throw err;
	}
};
