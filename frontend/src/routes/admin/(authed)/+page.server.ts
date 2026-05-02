import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { PageServerLoad } from './$types';

/**
 * Dashboard data. We pull a small slice of users (limit=10) so we
 * can show a "total + recent" view; if the actor lacks `users:list`,
 * we degrade silently to null rather than failing the page. The
 * authoritative permission check is at the backend.
 */
export const load: PageServerLoad = async ({ fetch, request, parent }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	const { permissions } = await parent();
	const canListUsers = permissions.includes('users:list');

	let totalUsers: number | null = null;
	if (canListUsers) {
		try {
			const result = await client.listUsers({ limit: 1000, headers: { cookie } });
			totalUsers = result.users.length;
		} catch (err) {
			if (!(err instanceof ApiError && err.status === 403)) {
				throw err;
			}
		}
	}

	return {
		totalUsers,
		canListUsers
	};
};
