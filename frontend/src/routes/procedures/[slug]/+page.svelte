<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Trust from '$lib/components/ui/Trust.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

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
</script>

<svelte:head>
	<title>{data.proc.title_ta} · {m.app_name()}</title>
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
