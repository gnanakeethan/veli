import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { PageServerLoad } from './$types';

const PAGE_SIZE = 50;

/**
 * Public procedures index. No auth — citizens read this directly.
 * The backend's /api/v1/procedures already filters to `published`,
 * so we don't need to repeat the check here.
 */
export const load: PageServerLoad = async ({ fetch, url }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const client = createApiClient({ fetch, baseUrl });

	const offsetParam = url.searchParams.get('offset');
	const offset = Math.max(0, Number.isFinite(Number(offsetParam)) ? Number(offsetParam) : 0);

	let procedures: ReturnType<typeof Array.prototype.slice> = [];
	let unreachable = false;
	try {
		const result = await client.listPublicProcedures({ limit: PAGE_SIZE, offset });
		procedures = result.procedures;
	} catch (err) {
		// Soft-fail on backend unreachable — render an empty list with
		// a banner rather than a hard 500. Phase 0 backends are still
		// flaky and we don't want a citizen visit to look broken.
		if (err instanceof ApiError) {
			unreachable = true;
		} else {
			unreachable = true;
		}
	}

	return {
		procedures,
		offset,
		pageSize: PAGE_SIZE,
		unreachable
	};
};
