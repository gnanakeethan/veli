import { env } from '$env/dynamic/private';
import { ApiError, createApiClient } from '$lib/api';
import type { RequestHandler } from './$types';

const STATIC_PATHS = [
	{ path: '/', priority: '1.0', changefreq: 'weekly' },
	{ path: '/procedures', priority: '0.9', changefreq: 'daily' }
];

const LOCALES = ['ta', 'en', 'si'] as const;

/**
 * Dynamic sitemap.xml. Lists every published procedure plus the
 * static citizen-facing pages, with hreflang alternates so search /
 * answer engines can link Tamil, English, and Sinhala siblings.
 *
 * Drafts and archived procedures are excluded — listPublicProcedures
 * already filters server-side. last_verified_at is used as
 * <lastmod> when present; we fall back to updated_at otherwise.
 */
export const GET: RequestHandler = async ({ fetch, url }) => {
	const baseUrl = env.VELI_API_BASE_URL ?? 'http://localhost:8080';
	const client = createApiClient({ fetch, baseUrl });
	const origin = url.origin;

	let procedures: Awaited<ReturnType<typeof client.listPublicProcedures>>['procedures'] = [];
	try {
		// Bump the limit deliberately — sitemap consumers expect a complete
		// list and 50 is the API default. 1000 gives us ample headroom for
		// Phase 1 procedure content (we expect <300 procedures total).
		const result = await client.listPublicProcedures({ limit: 1000 });
		procedures = result.procedures;
	} catch (err) {
		if (!(err instanceof ApiError)) throw err;
		// On backend unreachable, ship a sitemap with just the static
		// surfaces rather than 5xx-ing the crawler.
	}

	const urls: string[] = [];
	for (const { path, priority, changefreq } of STATIC_PATHS) {
		urls.push(buildUrlEntry(origin, path, priority, changefreq, undefined));
	}
	for (const proc of procedures) {
		const lastmod = proc.last_verified_at ?? proc.updated_at;
		urls.push(
			buildUrlEntry(origin, `/procedures/${proc.slug}`, '0.7', 'monthly', lastmod)
		);
	}

	const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
${urls.join('\n')}
</urlset>`;

	return new Response(xml, {
		headers: {
			'Content-Type': 'application/xml; charset=utf-8',
			'Cache-Control': 'public, max-age=600'
		}
	});
};

function buildUrlEntry(
	origin: string,
	path: string,
	priority: string,
	changefreq: string,
	lastmod: string | undefined
): string {
	const alternates = LOCALES.map(
		(loc) =>
			`\t\t<xhtml:link rel="alternate" hreflang="${loc}" href="${origin}${path}" />`
	).join('\n');
	const lastmodLine = lastmod ? `\n\t\t<lastmod>${lastmod.slice(0, 10)}</lastmod>` : '';
	return `\t<url>
		<loc>${origin}${path}</loc>${lastmodLine}
		<changefreq>${changefreq}</changefreq>
		<priority>${priority}</priority>
${alternates}
	</url>`;
}
