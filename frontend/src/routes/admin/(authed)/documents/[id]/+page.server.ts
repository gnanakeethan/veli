import { error, fail, redirect } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { VerificationTier } from '$lib/api';
import type { Actions, PageServerLoad } from './$types';

const TIER_VALUES: ReadonlySet<VerificationTier> = new Set([
	'self_asserted',
	'community_corroborated',
	'authority_attested'
]);

export const load: PageServerLoad = async ({ fetch, request, params }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const cookie = request.headers.get('cookie') ?? '';
	const client = createApiClient({ fetch, baseUrl });

	try {
		const [doc, verifsResp] = await Promise.all([
			client.getDocument(params.id, { headers: { cookie } }),
			client.listDocumentVerifications(params.id, { headers: { cookie } })
		]);
		return {
			doc,
			verifications: verifsResp.verifications
		};
	} catch (err) {
		if (err instanceof ApiError) {
			if (err.status === 404) throw error(404, 'Document not found');
			if (err.status === 403) throw error(403, err.message);
			throw error(err.status, err.message);
		}
		throw err;
	}
};

export const actions: Actions = {
	attest: async ({ fetch, request, params }) => {
		const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
		const cookie = request.headers.get('cookie') ?? '';
		const client = createApiClient({ fetch, baseUrl });

		const form = await request.formData();
		const tierRaw = String(form.get('tier') ?? '').trim();
		const attesterId = String(form.get('attester_id') ?? '').trim();
		const notes = String(form.get('notes') ?? '').trim();

		if (!TIER_VALUES.has(tierRaw as VerificationTier)) {
			return fail(400, {
				action: 'attest',
				error: 'invalid tier',
				values: { tier: tierRaw, attester_id: attesterId, notes }
			});
		}

		try {
			await client.createVerification(
				{
					document_id: params.id,
					tier: tierRaw as VerificationTier,
					attester_id: attesterId,
					...(notes ? { notes } : {})
				},
				{ headers: { cookie } }
			);
		} catch (err) {
			if (err instanceof ApiError) {
				return fail(err.status, {
					action: 'attest',
					error: err.envelope?.error ?? err.message,
					values: { tier: tierRaw, attester_id: attesterId, notes }
				});
			}
			throw err;
		}
		throw redirect(303, `/admin/documents/${params.id}`);
	}
};
