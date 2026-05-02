<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import StateCard from '$lib/components/ui/StateCard.svelte';
	import LRow from '$lib/components/ui/LRow.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	function feeDisplay(cents: number | undefined): string {
		if (cents === undefined || cents === null) return m.procedures_fee_unspecified();
		const lkr = (cents / 100).toLocaleString('en-LK', { maximumFractionDigits: 2 });
		return `${m.procedures_fee_lkr()} ${lkr}`;
	}

	function lastVerifiedDisplay(iso: string | undefined): string | null {
		if (!iso) return null;
		try {
			return new Date(iso).toISOString().slice(0, 10);
		} catch {
			return null;
		}
	}
</script>

<svelte:head>
	<title>{m.procedures_index_title()} · {m.app_name()}</title>
</svelte:head>

<div class="flex min-h-screen flex-col bg-paper-2 text-ink">
	<main class="flex-1 px-6 py-12 max-w-4xl mx-auto w-full">
		<a
			href="/"
			class="font-mono text-[12px] text-ink-3 hover:text-ink"
		>
			{m.procedures_back_to_home()}
		</a>

		<header class="mt-3 mb-8">
			<div class="font-mono text-xs uppercase tracking-wider text-ink-3">
				{m.procedures_index_subtitle()}
			</div>
			<h1 class="text-[32px] font-bold mt-1 leading-tight">
				{m.procedures_index_title()}
			</h1>
			<p class="font-latin text-[14.5px] text-ink-3 mt-2 max-w-prose">
				{m.procedures_index_intro()}
			</p>
		</header>

		{#if data.unreachable}
			<StateCard
				kind="error"
				title={m.backend_unreachable()}
				body=""
			/>
		{:else if data.procedures.length === 0}
			<StateCard
				kind="empty"
				title={m.procedures_index_empty_title()}
				body={m.procedures_index_empty_body()}
			/>
		{:else}
			<div class="rounded-md border border-rule bg-paper overflow-hidden">
				{#each data.procedures as proc (proc.id)}
					{@const verified = lastVerifiedDisplay(proc.last_verified_at)}
					<LRow
						href={`/procedures/${proc.slug}`}
						icon="check"
						title={proc.title_ta}
						meta={proc.summary_ta || proc.summary_en || ''}
						bilingual={true}
						en={proc.title_en
							? `${proc.title_en}${verified ? ' · verified ' + verified : ''}`
							: verified
								? `verified ${verified}`
								: ''}
					>
						{#snippet trail()}
							<span class="font-mono text-[11px] text-ink-3">
								{feeDisplay(proc.fee_lkr_cents)}
							</span>
						{/snippet}
					</LRow>
				{/each}
			</div>
		{/if}
	</main>

	<footer class="border-t border-rule px-6 py-6 text-center text-sm text-ink-3">
		{m.footer()}
	</footer>
</div>
