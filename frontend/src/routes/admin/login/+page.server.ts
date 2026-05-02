import type { PageServerLoad } from './$types';

type LoginErrorCode =
	| 'unconfigured'
	| 'not_provisioned'
	| 'state_mismatch'
	| 'missing_code'
	| 'invalid_id_token'
	| 'generic';

const known: ReadonlySet<LoginErrorCode> = new Set([
	'unconfigured',
	'not_provisioned',
	'state_mismatch',
	'missing_code',
	'invalid_id_token',
	'generic'
]);

export const load: PageServerLoad = async ({ url }) => {
	const raw = url.searchParams.get('error');
	const error: LoginErrorCode | null =
		raw && (known as Set<string>).has(raw) ? (raw as LoginErrorCode) : null;
	return { error };
};
