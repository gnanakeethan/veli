<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import type { PageData } from './+page.server';
	import Card from '$lib/components/ui/Card.svelte';
	import CardHeader from '$lib/components/ui/CardHeader.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import Badge from '$lib/components/ui/Badge.svelte';

	let { data }: { data: PageData } = $props();
</script>

<div class="flex min-h-screen flex-col bg-background text-foreground">
	<main class="mx-auto w-full max-w-2xl px-6 py-12">
		{#if data.error === 'not_found'}
			<Card class="text-center">
				<CardContent>
					<p class="text-lg font-medium text-muted-foreground">{m.user_not_found()}</p>
				</CardContent>
			</Card>
		{:else if data.error === 'invalid_id'}
			<Card class="text-center">
				<CardContent>
					<p class="text-lg font-medium text-muted-foreground">{m.invalid_user_id()}</p>
				</CardContent>
			</Card>
		{:else if data.error === 'server'}
			<Card class="border-destructive/30 bg-destructive/10 text-center">
				<CardContent>
					<p class="text-lg font-medium">{m.server_error()}</p>
				</CardContent>
			</Card>
		{:else if data.user}
			{@const user = data.user}
			<Card>
				<CardHeader>
					<h1 class="text-xl font-semibold text-primary">{user.display_name}</h1>
					<div class="mt-1">
						<Badge variant="secondary">{user.locale}</Badge>
					</div>
				</CardHeader>
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
							<Badge variant="secondary">{user.locale}</Badge>
						</dd>
					</div>
					<div class="flex items-baseline gap-4 px-6 py-3">
						<dt class="w-36 shrink-0 text-sm font-medium text-muted-foreground">
							{m.user_field_created_at()}
						</dt>
						<dd class="text-sm">{new Date(user.created_at).toLocaleString()}</dd>
					</div>
				</dl>
			</Card>
		{/if}
	</main>
</div>
