<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import LRow from '$lib/components/ui/LRow.svelte';
	import StateCard from '$lib/components/ui/StateCard.svelte';
	import Button from '$lib/components/ui/Button.svelte';
	import Badge from '$lib/components/ui/Badge.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	function shortId(id: string): string {
		return id.length > 10 ? id.slice(0, 10) + '…' : id;
	}

	function formatCaptured(iso: string): string {
		try {
			return new Date(iso).toISOString().slice(0, 16).replace('T', ' ') + ' UTC';
		} catch {
			return iso;
		}
	}

	const hasPrev = $derived(data.offset > 0);
	const hasNext = $derived(data.documents.length === data.pageSize);
	const prevHref = $derived(buildPageHref(Math.max(0, data.offset - data.pageSize), data.userIdFilter));
	const nextHref = $derived(buildPageHref(data.offset + data.pageSize, data.userIdFilter));

	function buildPageHref(offset: number, userId?: string): string {
		const params = new URLSearchParams();
		if (offset > 0) params.set('offset', String(offset));
		if (userId) params.set('user_id', userId);
		const qs = params.toString();
		return qs ? `?${qs}` : '?';
	}
</script>

<div class="flex flex-col gap-6">
	<header class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-3">
		<div>
			<div class="font-mono text-xs uppercase tracking-wider text-ink-3">
				ADMIN · {m.admin_documents_list_subtitle()}
			</div>
			<h1 class="text-[28px] font-bold mt-1">{m.admin_documents_list_title()}</h1>
			<p class="font-latin text-[14px] text-ink-3 mt-1 max-w-prose">
				{m.admin_documents_list_intro()}
			</p>
		</div>
		{#if data.canModerate}
			<a href="/admin/documents/new">
				<Button kind="primary" size="md">{m.admin_documents_create_cta_en()}</Button>
			</a>
		{/if}
	</header>

	{#if data.userIdFilter}
		<div class="rounded border border-rule bg-paper px-3 py-2 text-[13px] flex items-center justify-between gap-3">
			<span class="font-mono text-ink-3">
				filter · user_id = <span class="text-ink">{shortId(data.userIdFilter)}</span>
			</span>
			<a href="/admin/documents" class="font-mono text-[12px] text-ink-3 hover:text-ink">
				clear
			</a>
		</div>
	{/if}

	{#if data.documents.length === 0}
		<StateCard
			kind="empty"
			title={m.admin_documents_empty_title()}
			body={m.admin_documents_empty_body()}
		/>
	{:else}
		<div class="rounded-md border border-rule bg-paper overflow-hidden">
			{#each data.documents as doc (doc.id)}
				<LRow
					href={`/admin/documents/${doc.id}`}
					icon="file"
					title={doc.kind}
					meta={`${shortId(doc.id)} · captured ${formatCaptured(doc.captured_at)}`}
					bilingual={true}
					en={`owner ${shortId(doc.user_id)}`}
				>
					{#snippet trail()}
						{#if doc.gps_lat !== undefined}
							<Badge kind="info">GPS</Badge>
						{/if}
					{/snippet}
				</LRow>
			{/each}
		</div>

		<nav class="flex items-center justify-between gap-4 mt-2">
			<a
				href={prevHref}
				class="btn btn-ghost btn-sm"
				class:opacity-30={!hasPrev}
				class:pointer-events-none={!hasPrev}
				aria-disabled={!hasPrev}
			>
				← முந்தைய
			</a>
			<div class="font-mono text-[11px] text-ink-3">
				offset {data.offset} · limit {data.limit}
			</div>
			<a
				href={nextHref}
				class="btn btn-ghost btn-sm"
				class:opacity-30={!hasNext}
				class:pointer-events-none={!hasNext}
				aria-disabled={!hasNext}
			>
				அடுத்தது →
			</a>
		</nav>
	{/if}
</div>
