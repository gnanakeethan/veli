import { redirect } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { createApiClient } from '$lib/api';
import type { RequestHandler } from './$types';

/**
 * Logout endpoint. Posts to backend /api/v1/auth/logout to clear the
 * server-side notion of the session, then redirects the browser to
 * /admin/login. We deliberately use POST (not GET) so a stray browser
 * prefetch or link-rot crawler can't accidentally end your session.
 */
export const POST: RequestHandler = async ({ fetch, request }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	try {
		await client.logout({ headers: { cookie } });
	} catch {
		// Logout failures are non-fatal — clearing client cookie is
		// the more important half. Continue to redirect.
	}

	throw redirect(303, '/admin/login');
};
