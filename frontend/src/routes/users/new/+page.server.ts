import { fail, redirect } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { createApiClient, ApiError } from '$lib/api';
import type { User } from '$lib/api';
import type { Actions } from './$types';

export const actions: Actions = {
	default: async ({ fetch, request }) => {
		const form = await request.formData();
		const phone = String(form.get('phone') ?? '').trim();
		const display_name = String(form.get('display_name') ?? '');
		const locale = String(form.get('locale') ?? '');
		const nic_raw = String(form.get('nic_number') ?? '').trim();

		const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
		const client = createApiClient({ fetch, baseUrl });

		let user: User;
		try {
			user = await client.createUser({
				phone,
				display_name,
				locale,
				...(nic_raw ? { nic_number: nic_raw } : {})
			});
		} catch (err) {
			if (err instanceof ApiError) {
				return fail(err.status, {
					error: err.envelope?.error ?? 'server',
					values: { phone, display_name, locale, nic_number: nic_raw }
				});
			}
			throw err;
		}
		throw redirect(303, `/users/${user.id}`);
	}
};
