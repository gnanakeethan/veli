import { error, fail, redirect } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { ProcedureRequest, ProcedureStatus } from '$lib/api';
import type { Actions, PageServerLoad } from './$types';

const VALID_STATUS: ReadonlySet<ProcedureStatus> = new Set([
	'draft',
	'published',
	'archived'
]);

export const load: PageServerLoad = async ({ fetch, request, params }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	try {
		const proc = await client.getAdminProcedure(params.id, { headers: { cookie } });
		return { proc };
	} catch (err) {
		if (err instanceof ApiError) {
			if (err.status === 404) throw error(404, 'Procedure not found');
			if (err.status === 403) throw error(403, err.message);
			throw error(err.status, err.message);
		}
		throw err;
	}
};

export const actions: Actions = {
	default: async ({ fetch, request, params }) => {
		const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
		const cookie = request.headers.get('cookie') ?? '';
		const client = createApiClient({ fetch, baseUrl });

		const form = await request.formData();
		const values = readFormValues(form);

		const body: ProcedureRequest = {
			slug: values.slug,
			title_ta: values.title_ta,
			title_en: values.title_en || undefined,
			summary_ta: values.summary_ta || undefined,
			summary_en: values.summary_en || undefined,
			body_ta: values.body_ta || undefined,
			body_en: values.body_en || undefined,
			source_url: values.source_url || undefined,
			status: values.status as ProcedureStatus
		};
		if (values.fee_lkr) {
			const lkr = Number(values.fee_lkr);
			if (!Number.isFinite(lkr) || lkr < 0) {
				return fail(400, { error: 'invalid fee', values });
			}
			body.fee_lkr_cents = Math.round(lkr * 100);
		}
		if (values.last_verified_at) {
			try {
				body.last_verified_at = new Date(values.last_verified_at + 'Z').toISOString();
			} catch {
				return fail(400, { error: 'invalid last_verified_at', values });
			}
		}

		try {
			await client.updateProcedure(params.id, body, { headers: { cookie } });
		} catch (err) {
			if (err instanceof ApiError) {
				return fail(err.status, {
					error: err.envelope?.error ?? err.message,
					values
				});
			}
			throw err;
		}
		throw redirect(303, `/admin/procedures/${params.id}`);
	}
};

function readFormValues(form: FormData) {
	const status = String(form.get('status') ?? 'draft');
	return {
		slug: String(form.get('slug') ?? '').trim(),
		title_ta: String(form.get('title_ta') ?? '').trim(),
		title_en: String(form.get('title_en') ?? '').trim(),
		summary_ta: String(form.get('summary_ta') ?? ''),
		summary_en: String(form.get('summary_en') ?? ''),
		body_ta: String(form.get('body_ta') ?? ''),
		body_en: String(form.get('body_en') ?? ''),
		fee_lkr: String(form.get('fee_lkr') ?? '').trim(),
		source_url: String(form.get('source_url') ?? '').trim(),
		last_verified_at: String(form.get('last_verified_at') ?? '').trim(),
		status: VALID_STATUS.has(status as ProcedureStatus) ? status : 'draft'
	};
}
