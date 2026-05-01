<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import type { PageData } from './+page.server';

	let { data }: { data: PageData } = $props();
</script>

<div class="flex min-h-screen flex-col bg-background text-foreground">
	<main class="mx-auto w-full max-w-2xl px-6 py-12">
		{#if data.error === 'not_found'}
			<div class="rounded-lg border bg-card p-8 text-center text-card-foreground shadow-sm">
				<p class="text-lg font-medium text-muted-foreground">{m.user_not_found()}</p>
			</div>
		{:else if data.error === 'invalid_id'}
			<div class="rounded-lg border bg-card p-8 text-center text-card-foreground shadow-sm">
				<p class="text-lg font-medium text-muted-foreground">{m.invalid_user_id()}</p>
			</div>
		{:else if data.error === 'server'}
			<div
				class="rounded-lg border border-destructive/30 bg-destructive/10 p-8 text-center text-foreground shadow-sm"
			>
				<p class="text-lg font-medium">{m.server_error()}</p>
			</div>
		{:else if data.user}
			{@const user = data.user}
			<article class="rounded-lg border bg-card text-card-foreground shadow-sm">
				<header class="border-b px-6 py-4">
					<h1 class="text-xl font-semibold text-primary">{user.display_name}</h1>
					<span
						class="mt-1 inline-block rounded bg-secondary px-2 py-0.5 text-xs text-secondary-foreground"
					>
						{user.locale}
					</span>
				</header>
				<dl class="divide-y">
					<div class="flex items-baseline gap-4 px-6 py-3">
						<dt class="w-36 shrink-0 text-sm font-medium text-muted-foreground">
							{m.user_field_id()}
						</dt>
						<dd class="break-all font-mono text-sm">{user.id}</dd>
					</div>
					<div class="flex items-baseline gap-4 px-6 py-3">
						<dt class="w-36 shrink-0 text-sm font-medium text-muted-foreground">
							{m.user_field_phone()}
						</dt>
						<dd class="text-sm">{user.phone}</dd>
					</div>
					<div class="flex items-baseline gap-4 px-6 py-3">
						<dt class="w-36 shrink-0 text-sm font-medium text-muted-foreground">
							{m.user_field_display_name()}
						</dt>
						<dd class="text-sm">{user.display_name}</dd>
					</div>
					{#if user.nic_number}
						<div class="flex items-baseline gap-4 px-6 py-3">
							<dt class="w-36 shrink-0 text-sm font-medium text-muted-foreground">
								{m.user_field_nic()}
							</dt>
							<dd class="font-mono text-sm">{user.nic_number}</dd>
						</div>
					{/if}
					<div class="flex items-baseline gap-4 px-6 py-3">
						<dt class="w-36 shrink-0 text-sm font-medium text-muted-foreground">
							{m.user_field_locale()}
						</dt>
						<dd class="text-sm">
							<span
								class="rounded bg-secondary px-2 py-0.5 text-xs text-secondary-foreground"
							>
								{user.locale}
							</span>
						</dd>
					</div>
					<div class="flex items-baseline gap-4 px-6 py-3">
						<dt class="w-36 shrink-0 text-sm font-medium text-muted-foreground">
							{m.user_field_created_at()}
						</dt>
						<dd class="text-sm">{new Date(user.created_at).toLocaleString()}</dd>
					</div>
				</dl>
			</article>
		{/if}
	</main>
</div>
