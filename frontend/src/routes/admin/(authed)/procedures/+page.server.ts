import { error } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { PageServerLoad } from './$types';

const PAGE_SIZE = 50;

export const load: PageServerLoad = async ({ fetch, request, url, parent }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	const { permissions } = await parent();
	const offsetParam = url.searchParams.get('offset');
	const offset = Math.max(0, Number.isFinite(Number(offsetParam)) ? Number(offsetParam) : 0);

	try {
		const result = await client.listAdminProcedures({
			limit: PAGE_SIZE,
			offset,
			headers: { cookie }
		});
		return {
			procedures: result.procedures,
			limit: result.limit,
			offset: result.offset,
			pageSize: PAGE_SIZE,
			canWrite: permissions.includes('procedures:write')
		};
	} catch (err) {
		if (err instanceof ApiError && err.status === 403) {
			throw error(403, 'You do not have permission to view procedures.');
		}
		if (err instanceof ApiError) {
			throw error(err.status, err.message);
		}
		throw err;
	}
};
