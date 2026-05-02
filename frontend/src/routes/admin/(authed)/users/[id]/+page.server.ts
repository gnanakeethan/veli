import { error, fail, redirect } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { Actions, PageServerLoad } from './$types';

const ASSIGNABLE_ROLES = ['super_admin', 'manager', 'user'] as const;

export const load: PageServerLoad = async ({ fetch, request, params }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	try {
		const [user, rolesResp] = await Promise.all([
			client.getAdminUser(params.id, { headers: { cookie } }),
			client.listUserRoles(params.id, { headers: { cookie } })
		]);
		return {
			user,
			roles: rolesResp.roles,
			assignableRoles: ASSIGNABLE_ROLES as readonly string[]
		};
	} catch (err) {
		if (err instanceof ApiError) {
			if (err.status === 404) throw error(404, 'User not found');
			if (err.status === 403) throw error(403, err.message);
			throw error(err.status, err.message);
		}
		throw err;
	}
};

export const actions: Actions = {
	assign: async ({ fetch, request, params }) => {
		const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
		const cookie = request.headers.get('cookie') ?? '';
		const client = createApiClient({ fetch, baseUrl });

		const form = await request.formData();
		const code = String(form.get('code') ?? '').trim();
		if (!code) {
			return fail(400, { action: 'assign', error: 'missing role code' });
		}

		try {
			await client.assignRole(params.id, code, { headers: { cookie } });
		} catch (err) {
			if (err instanceof ApiError) {
				return fail(err.status, { action: 'assign', error: err.message });
			}
			throw err;
		}
		throw redirect(303, `/admin/users/${params.id}`);
	},
	revoke: async ({ fetch, request, params }) => {
		const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
		const cookie = request.headers.get('cookie') ?? '';
		const client = createApiClient({ fetch, baseUrl });

		const form = await request.formData();
		const code = String(form.get('code') ?? '').trim();
		if (!code) {
			return fail(400, { action: 'revoke', error: 'missing role code' });
		}

		try {
			await client.revokeRole(params.id, code, { headers: { cookie } });
		} catch (err) {
			if (err instanceof ApiError) {
				return fail(err.status, { action: 'revoke', error: err.message });
			}
			throw err;
		}
		throw redirect(303, `/admin/users/${params.id}`);
	}
};
