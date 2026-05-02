import type { RequestHandler } from './$types';

/**
 * Dynamic robots.txt that points crawlers at the sitemap. Hosting on
 * a route (rather than the static folder) lets the sitemap URL adapt
 * to the deployment origin.
 */
export const GET: RequestHandler = async ({ url }) => {
	const body = `# Veḷi — Tamil-first civic-tech platform for Sri Lanka's Northern Province.
User-agent: *
Allow: /
Disallow: /admin/

Sitemap: ${url.origin}/sitemap.xml
`;
	return new Response(body, {
		headers: {
			'Content-Type': 'text/plain; charset=utf-8',
			'Cache-Control': 'public, max-age=3600'
		}
	});
};
