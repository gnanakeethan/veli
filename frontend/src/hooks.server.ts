import type { Handle } from '@sveltejs/kit';
import { sequence } from '@sveltejs/kit/hooks';
import { paraglideMiddleware } from '$lib/paraglide/server';

const handleParaglide: Handle = ({ event, resolve }) =>
	paraglideMiddleware(event.request, ({ request, locale }) => {
		event.request = request;

		return resolve(event, {
			transformPageChunk: ({ html }) => html.replace('%paraglide.lang%', locale)
		});
	});

/**
 * Cache-control policy by route family.
 *
 *   - /admin/**           : private, no-store. Admin responses contain
 *                           per-actor data and must never be cached.
 *   - /api/**             : pass-through; SvelteKit doesn't proxy
 *                           the backend API, but if any route ever
 *                           does, default to no-store.
 *   - /procedures/**      : public-cacheable for ~5 min at the edge,
 *                           ~1 min in the browser. Procedures change
 *                           infrequently, and stale-while-revalidate
 *                           keeps the citizen surface snappy.
 *   - /sitemap.xml,
 *     /robots.txt,
 *     /llms.txt           : already cached by their own routes.
 *   - everything else     : default browser caching, max-age=0 to
 *                           force revalidation on each visit (the
 *                           home page summary changes when phase
 *                           progress updates).
 *
 * Static assets (JS/CSS bundles) bypass this hook entirely — Vite /
 * the adapter set immutable hashes and long max-age automatically.
 * Skips paths that already set their own Cache-Control header.
 */
const cacheControl: Handle = async ({ event, resolve }) => {
	const response = await resolve(event);
	if (response.headers.has('cache-control')) return response;

	const path = event.url.pathname;
	if (path.startsWith('/admin') || path.startsWith('/api')) {
		response.headers.set('Cache-Control', 'private, no-store');
	} else if (path.startsWith('/procedures')) {
		response.headers.set(
			'Cache-Control',
			'public, max-age=60, s-maxage=300, stale-while-revalidate=600'
		);
	} else {
		response.headers.set('Cache-Control', 'public, max-age=0, must-revalidate');
	}
	return response;
};

export const handle: Handle = sequence(handleParaglide, cacheControl);
