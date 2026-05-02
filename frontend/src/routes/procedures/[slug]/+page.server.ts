import { error } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ fetch, params }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const client = createApiClient({ fetch, baseUrl });

	try {
		const proc = await client.getPublicProcedure(params.slug);
		return { proc };
	} catch (err) {
		if (err instanceof ApiError) {
			if (err.status === 404) throw error(404, 'Procedure not found');
			throw error(err.status, err.message);
		}
		throw err;
	}
};
