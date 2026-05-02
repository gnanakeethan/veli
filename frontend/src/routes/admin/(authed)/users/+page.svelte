<script lang="ts">
	import LRow from '$lib/components/ui/LRow.svelte';
	import StateCard from '$lib/components/ui/StateCard.svelte';
	import Button from '$lib/components/ui/Button.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	function shortId(id: string): string {
		return id.length > 8 ? id.slice(0, 8) + '…' : id;
	}

	const hasPrev = $derived(data.offset > 0);
	const hasNext = $derived(data.users.length === data.pageSize);

	const prevHref = $derived(`?offset=${Math.max(0, data.offset - data.pageSize)}`);
	const nextHref = $derived(`?offset=${data.offset + data.pageSize}`);
</script>

<div class="flex flex-col gap-6">
	<header class="flex items-end justify-between gap-4">
		<div>
			<div class="font-mono text-xs uppercase tracking-wider text-ink-3">
				ADMIN · பயனர்கள் / USERS
			</div>
			<h1 class="text-[28px] font-bold mt-1">பயனர் பட்டியல்</h1>
			<p class="font-latin text-[14px] text-ink-3 mt-1">
				All registered users · {data.users.length} on this page
			</p>
		</div>
	</header>

	{#if data.users.length === 0}
		<StateCard
			kind="empty"
			title="இங்கே பயனர் இல்லை"
			body="No users yet. Phone-OTP registration creates them."
		/>
	{:else}
		<div class="rounded-md border border-rule bg-paper overflow-hidden">
			{#each data.users as user (user.id)}
				<LRow
					href={`/admin/users/${user.id}`}
					icon="doc"
					title={user.display_name}
					meta={user.phone}
					bilingual={true}
					en={user.email ? user.email + ' · ' + shortId(user.id) : shortId(user.id)}
				/>
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
