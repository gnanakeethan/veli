<script lang="ts">
	import * as m from '$lib/paraglide/messages'
	import type { PageData } from './+page.server'
	import Card from '$lib/components/ui/Card.svelte'
	import CardHeader from '$lib/components/ui/CardHeader.svelte'
	import CardContent from '$lib/components/ui/CardContent.svelte'
	import Badge from '$lib/components/ui/Badge.svelte'
	import LRow from '$lib/components/ui/LRow.svelte'

	let { data }: { data: PageData } = $props()
</script>

<div class="flex min-h-screen flex-col bg-paper-2 text-ink">
	<main class="mx-auto w-full max-w-2xl px-6 py-12">
		{#if data.error === 'not_found'}
			<Card class="text-center">
				<CardContent>
					<p class="text-lg font-medium text-ink-3">{m.user_not_found()}</p>
				</CardContent>
			</Card>
		{:else if data.error === 'invalid_id'}
			<Card class="text-center">
				<CardContent>
					<p class="text-lg font-medium text-ink-3">{m.invalid_user_id()}</p>
				</CardContent>
			</Card>
		{:else if data.error === 'server'}
			<Card class="border-alert/30 bg-alert-soft text-center">
				<CardContent>
					<p class="text-lg font-medium text-alert-ink">{m.server_error()}</p>
				</CardContent>
			</Card>
		{:else if data.user}
			{@const user = data.user}
			<Card>
				<CardHeader>
					<h1 class="text-xl font-semibold text-primary">{user.display_name}</h1>
					<div class="mt-1">
						<Badge kind="mute">{user.locale}</Badge>
					</div>
				</CardHeader>
				<div>
					<LRow
						icon="chip"
						title={m.user_field_id()}
						meta={user.id}
					/>
					<LRow
						icon="phone"
						title={m.user_field_phone()}
						meta={user.phone}
					/>
					<LRow
						icon="user"
						title={m.user_field_display_name()}
						meta={user.display_name}
					/>
					{#if user.nic_number}
						<LRow
							icon="id-card"
							title={m.user_field_nic()}
							meta={user.nic_number}
						/>
					{/if}
					<LRow
						icon="search"
						title={m.user_field_locale()}
					>
						{#snippet trail()}
							<Badge kind="mute">{user.locale}</Badge>
						{/snippet}
					</LRow>
					<LRow
						icon="check"
						title={m.user_field_created_at()}
						meta={new Date(user.created_at).toLocaleString()}
					/>
				</div>
			</Card>
		{/if}
	</main>
</div>
