import { fail, redirect } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { CreateDocumentRequest } from '$lib/api';
import type { Actions } from './$types';

export const actions: Actions = {
	default: async ({ fetch, request }) => {
		const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
		const cookie = request.headers.get('cookie') ?? '';
		const client = createApiClient({ fetch, baseUrl });

		const form = await request.formData();
		const userID = String(form.get('user_id') ?? '').trim();
		const kind = String(form.get('kind') ?? '').trim();
		const storageURI = String(form.get('storage_uri') ?? '').trim();
		const capturedAtRaw = String(form.get('captured_at') ?? '').trim();
		const gpsLatRaw = String(form.get('gps_lat') ?? '').trim();
		const gpsLngRaw = String(form.get('gps_lng') ?? '').trim();
		const deviceID = String(form.get('device_id') ?? '').trim();

		const values = {
			user_id: userID,
			kind,
			storage_uri: storageURI,
			captured_at: capturedAtRaw,
			gps_lat: gpsLatRaw,
			gps_lng: gpsLngRaw,
			device_id: deviceID
		};

		// Convert datetime-local (yyyy-MM-ddTHH:mm) to RFC 3339.
		// Browsers submit local time without timezone; we treat the
		// value as UTC for simplicity (admins entering in their head).
		let capturedAt: string;
		try {
			capturedAt = new Date(capturedAtRaw + 'Z').toISOString();
		} catch {
			return fail(400, { error: 'invalid captured_at', values });
		}

		const body: CreateDocumentRequest = {
			user_id: userID,
			kind,
			storage_uri: storageURI,
			captured_at: capturedAt
		};
		if (gpsLatRaw && gpsLngRaw) {
			const lat = Number(gpsLatRaw);
			const lng = Number(gpsLngRaw);
			if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
				return fail(400, { error: 'invalid gps coordinates', values });
			}
			body.gps_lat = lat;
			body.gps_lng = lng;
		}
		if (deviceID) body.device_id = deviceID;

		try {
			const doc = await client.createDocument(body, { headers: { cookie } });
			throw redirect(303, `/admin/documents/${doc.id}`);
		} catch (err) {
			if (err instanceof ApiError) {
				return fail(err.status, {
					error: err.envelope?.error ?? err.message,
					values
				});
			}
			throw err;
		}
	}
};
