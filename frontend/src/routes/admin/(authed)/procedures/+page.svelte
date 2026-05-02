<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import LRow from '$lib/components/ui/LRow.svelte';
	import StateCard from '$lib/components/ui/StateCard.svelte';
	import Button from '$lib/components/ui/Button.svelte';
	import Badge from '$lib/components/ui/Badge.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	function statusBadgeKind(status: string) {
		switch (status) {
			case 'published':
				return 'primary' as const;
			case 'archived':
				return 'mute' as const;
			default:
				return 'accent' as const; // draft
		}
	}

	function feeShort(cents: number | null | undefined): string {
		if (cents === undefined || cents === null) return '—';
		return `LKR ${(cents / 100).toLocaleString('en-LK')}`;
	}
</script>

<div class="flex flex-col gap-6">
	<header class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-3">
		<div>
			<div class="font-mono text-xs uppercase tracking-wider text-ink-3">
				ADMIN · {m.admin_procedures_list_subtitle()}
			</div>
			<h1 class="text-[28px] font-bold mt-1">{m.admin_procedures_list_title()}</h1>
			<p class="font-latin text-[14px] text-ink-3 mt-1 max-w-prose">
				{m.admin_procedures_list_intro()}
			</p>
		</div>
		{#if data.canWrite}
			<a href="/admin/procedures/new">
				<Button kind="primary" size="md">{m.admin_procedures_create_cta_en()}</Button>
			</a>
		{/if}
	</header>

	{#if data.procedures.length === 0}
		<StateCard
			kind="empty"
			title={m.admin_procedures_empty_title()}
			body={m.admin_procedures_empty_body()}
		/>
	{:else}
		<div class="rounded-md border border-rule bg-paper overflow-hidden">
			{#each data.procedures as proc (proc.id)}
				<LRow
					href={`/admin/procedures/${proc.id}`}
					icon="check"
					title={proc.title_ta}
					meta={proc.slug}
					bilingual={true}
					en={proc.title_en ?? ''}
				>
					{#snippet trail()}
						<div class="flex items-center gap-2">
							<span class="font-mono text-[11px] text-ink-3">
								{feeShort(proc.fee_lkr_cents)}
							</span>
							<Badge kind={statusBadgeKind(proc.status)}>{proc.status}</Badge>
						</div>
					{/snippet}
				</LRow>
			{/each}
		</div>
	{/if}
</div>
