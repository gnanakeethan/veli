<script lang="ts">
	import { page } from '$app/stores';
	import * as m from '$lib/paraglide/messages';
	import Trust from '$lib/components/ui/Trust.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const origin = $derived($page.url.origin);
	const canonical = $derived(`${origin}/procedures/${data.proc.slug}`);

	const lastVerifiedISO = $derived(
		data.proc.last_verified_at ? data.proc.last_verified_at.slice(0, 10) : null
	);

	function feeDisplay(): { ta: string; en: string } {
		const cents = data.proc.fee_lkr_cents;
		if (cents === undefined || cents === null) {
			return {
				ta: m.procedures_fee_unspecified(),
				en: m.procedures_fee_unspecified_en()
			};
		}
		const lkr = (cents / 100).toLocaleString('en-LK', { maximumFractionDigits: 2 });
		return { ta: `${m.procedures_fee_lkr()} ${lkr}`, en: `LKR ${lkr}` };
	}
	const fee = $derived(feeDisplay());

	// Meta description blends the bilingual summary so engines that
	// match Tamil OR English queries both find this page. Capped at
	// ~250 chars so OG/Twitter previews don't truncate awkwardly.
	const metaDescription = $derived.by(() => {
		const parts: string[] = [];
		if (data.proc.summary_en) parts.push(data.proc.summary_en);
		if (data.proc.summary_ta) parts.push(data.proc.summary_ta);
		const joined = parts.join(' · ');
		return joined.length > 250 ? joined.slice(0, 247) + '...' : joined;
	});

	// Pull host out of source_url so the citation reads
	// "rgd.gov.lk" rather than the full URL.
	const sourceHost = $derived.by(() => {
		if (!data.proc.source_url) return null;
		try {
			return new URL(data.proc.source_url).host.replace(/^www\./, '');
		} catch {
			return data.proc.source_url;
		}
	});

	// Schema.org JSON-LD: GovernmentService is the most specific type
	// for a procedure record (a service provided by a government
	// authority). We wrap it in a graph with BreadcrumbList so the
	// "Veḷi → Procedures → <this>" trail is machine-readable.
	const jsonLd = $derived(
		JSON.stringify({
			'@context': 'https://schema.org',
			'@graph': [
				{
					'@type': 'GovernmentService',
					'@id': `${canonical}#service`,
					name: data.proc.title_ta,
					alternateName: data.proc.title_en ?? undefined,
					description: metaDescription || undefined,
					url: canonical,
					inLanguage: ['ta', 'en'],
					provider: {
						'@type': 'GovernmentOrganization',
						name: data.proc.source_url
							? new URL(data.proc.source_url).host.replace(/^www\./, '')
							: 'Government of Sri Lanka',
						areaServed: {
							'@type': 'AdministrativeArea',
							name: 'Northern Province',
							containedInPlace: { '@type': 'Country', name: 'Sri Lanka' }
						}
					},
					...(data.proc.fee_lkr_cents !== undefined &&
					data.proc.fee_lkr_cents !== null
						? {
								offers: {
									'@type': 'Offer',
									price: (data.proc.fee_lkr_cents / 100).toFixed(2),
									priceCurrency: 'LKR'
								}
							}
						: {}),
					...(data.proc.source_url
						? {
								isBasedOn: {
									'@type': 'CreativeWork',
									url: data.proc.source_url
								}
							}
						: {}),
					...(lastVerifiedISO
						? {
								dateModified: lastVerifiedISO
							}
						: {})
				},
				{
					'@type': 'BreadcrumbList',
					itemListElement: [
						{
							'@type': 'ListItem',
							position: 1,
							name: 'Veḷi',
							item: origin
						},
						{
							'@type': 'ListItem',
							position: 2,
							name: m.procedures_index_title(),
							item: `${origin}/procedures`
						},
						{
							'@type': 'ListItem',
							position: 3,
							name: data.proc.title_ta
						}
					]
				}
			]
		})
	);
</script>

<svelte:head>
	<title>{data.proc.title_ta} · {m.app_name()}</title>
	{#if metaDescription}
		<meta name="description" content={metaDescription} />
	{/if}
	<link rel="canonical" href={canonical} />
	<meta property="og:type" content="article" />
	<meta property="og:title" content={`${data.proc.title_ta} · ${m.app_name()}`} />
	{#if metaDescription}
		<meta property="og:description" content={metaDescription} />
	{/if}
	<meta property="og:url" content={canonical} />
	{#if lastVerifiedISO}
		<meta property="article:modified_time" content={lastVerifiedISO} />
	{/if}
	{@html `<script type="application/ld+json">${jsonLd}</script>`}
</svelte:head>

<div class="flex min-h-screen flex-col bg-paper-2 text-ink">
	<main class="flex-1 px-6 py-10 max-w-3xl mx-auto w-full">
		<a
			href="/procedures"
			class="font-mono text-[12px] text-ink-3 hover:text-ink"
		>
			{m.procedures_back_to_list()}
		</a>

		<header class="mt-3 mb-6">
			<div class="font-mono text-xs uppercase tracking-wider text-ink-3">
				{m.procedures_index_subtitle()}
			</div>
			<h1 class="text-[30px] font-bold mt-1 leading-tight">
				{data.proc.title_ta}
			</h1>
			{#if data.proc.title_en}
				<p class="font-latin text-[14.5px] text-ink-3 mt-1">
					{data.proc.title_en}
				</p>
			{/if}
		</header>

		<section class="mb-8 grid sm:grid-cols-3 gap-4">
			<div class="rounded border border-rule bg-paper px-4 py-3">
				<div class="font-mono text-[10.5px] uppercase tracking-wider text-ink-3 mb-1">
					{m.procedures_fee_label()}
				</div>
				<div class="text-[18px] font-semibold leading-tight">{fee.ta}</div>
				<div class="font-latin text-[12px] text-ink-3 mt-0.5">{fee.en}</div>
			</div>
			{#if lastVerifiedISO}
				<div class="rounded border border-rule bg-paper px-4 py-3">
					<div class="font-mono text-[10.5px] uppercase tracking-wider text-ink-3 mb-1">
						{m.procedures_last_verified()}
					</div>
					<div class="font-mono text-[14px]">{lastVerifiedISO}</div>
					<div class="font-latin text-[12px] text-ink-3 mt-0.5">
						{m.procedures_last_verified_en()}
					</div>
				</div>
			{/if}
			{#if sourceHost}
				<div class="rounded border border-rule bg-paper px-4 py-3">
					<div class="font-mono text-[10.5px] uppercase tracking-wider text-ink-3 mb-1">
						{m.procedures_source_label()}
					</div>
					<a
						href={data.proc.source_url}
						class="font-mono text-[13px] hover:underline break-all"
						target="_blank"
						rel="noopener noreferrer"
					>
						{sourceHost} ↗
					</a>
				</div>
			{/if}
		</section>

		<section class="mb-8">
			{#if data.proc.summary_ta}
				<p class="text-[16px] leading-relaxed">{data.proc.summary_ta}</p>
			{:else}
				<p class="text-[14px] text-ink-3 italic">{m.procedures_no_summary()}</p>
			{/if}
			{#if data.proc.summary_en}
				<p class="font-latin text-[13.5px] text-ink-3 leading-relaxed mt-3 pl-3 border-l-2 border-rule">
					{data.proc.summary_en}
				</p>
			{/if}
		</section>

		{#if data.proc.body_ta}
			<section class="mb-8">
				{#each data.proc.body_ta.split(/\n{2,}/) as para, i (i)}
					<p class="text-[15.5px] leading-relaxed mb-4 last:mb-0">{para}</p>
				{/each}
			</section>
		{/if}

		{#if data.proc.body_en}
			<section class="mb-8 pl-4 border-l-2 border-rule">
				<div class="font-mono text-[10.5px] uppercase tracking-wider text-ink-3 mb-2">
					English version
				</div>
				{#each data.proc.body_en.split(/\n{2,}/) as para, i (i)}
					<p class="font-latin text-[13.5px] text-ink-3 leading-relaxed mb-3 last:mb-0">{para}</p>
				{/each}
			</section>
		{/if}

		<Trust
			title={m.procedures_legal_disclaimer()}
			body={m.procedures_legal_disclaimer_en()}
			cite={lastVerifiedISO
				? `${m.procedures_last_verified_en()} · ${lastVerifiedISO}`
				: undefined}
		/>
	</main>

	<footer class="border-t border-rule px-6 py-6 text-center text-sm text-ink-3">
		{m.footer()}
	</footer>
</div>
