import { error, redirect } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { MeResponse } from '$lib/api';
import type { LayoutServerLoad } from './$types';

/**
 * Auth gate for every route under /admin/(authed)/. Calls the backend's
 * /api/v1/auth/me with the user's request cookies forwarded; on 401
 * we send the user to /admin/login. The /admin/login route is *not*
 * inside this layout group, so the redirect is safe (no loop).
 */
export const load: LayoutServerLoad = async ({ fetch, request, url }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	let me: MeResponse;
	try {
		me = await client.getMe({ headers: { cookie } });
	} catch (err) {
		if (err instanceof ApiError && err.status === 401) {
			const next = encodeURIComponent(url.pathname + url.search);
			throw redirect(303, `/admin/login?next=${next}`);
		}
		if (err instanceof ApiError) {
			throw error(err.status, err.message);
		}
		throw err;
	}

	return {
		me,
		permissions: collectPermissions(me)
	};
};

/**
 * Flattens the nested role.permissions arrays into a single Set of
 * permission codes. The frontend uses this to conditionally render
 * destructive UI; the backend remains the source of truth via
 * RequirePermission middleware on every privileged route.
 */
function collectPermissions(me: MeResponse): string[] {
	const out = new Set<string>();
	for (const role of me.roles) {
		for (const p of role.permissions ?? []) {
			out.add(p.code);
		}
	}
	return Array.from(out).sort();
}
