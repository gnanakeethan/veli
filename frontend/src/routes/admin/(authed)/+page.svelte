<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import Stats from '$lib/components/ui/Stats.svelte';
	import Stat from '$lib/components/ui/Stat.svelte';
	import StateCard from '$lib/components/ui/StateCard.svelte';
	import Icon from '$lib/components/ui/Icon.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const greetingTa = $derived(`வணக்கம், ${data.me.user.display_name}`);
	const roleCount = $derived(data.me.roles.length);
</script>

<div class="flex flex-col gap-8">
	<header>
		<div class="font-mono text-xs uppercase tracking-wider text-ink-3">
			ADMIN · மேலோட்டம் / DASHBOARD
		</div>
		<h1 class="text-[28px] font-bold mt-1">{greetingTa}</h1>
		<p class="font-latin text-[14px] text-ink-3 mt-1">
			{m.admin_login_subtitle_ta()} · signed in as
			<span class="font-mono">{data.me.user.email ?? data.me.user.phone}</span>
		</p>
	</header>

	<section>
		<Stats>
			<Stat
				value={data.totalUsers ?? '—'}
				label="மொத்த பயனர்கள்"
				en="Total users"
			/>
			<Stat value={roleCount} label="உங்கள் பாத்திரங்கள்" en="Your roles" />
			<Stat
				value={data.canListUsers ? 'YES' : 'NO'}
				label="பயனர் பட்டியல் அணுகல்"
				en="Can list users"
			/>
		</Stats>
	</section>

	<section class="grid grid-cols-1 md:grid-cols-2 gap-6">
		<Card>
			<CardContent>
				<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-2">
					பாத்திரங்கள் · ROLES
				</div>
				<h2 class="text-[18px] font-semibold mb-3">
					உங்கள் அனுமதிகள்
				</h2>
				{#if data.me.roles.length === 0}
					<StateCard
						kind="empty"
						title="பாத்திரம் இல்லை"
						body="No roles assigned. Contact a super admin."
					/>
				{:else}
					<div class="flex flex-col gap-2">
						{#each data.me.roles as role (role.id)}
							<div
								class="flex items-baseline justify-between rounded border border-rule bg-paper px-3 py-2"
							>
								<div>
									<div class="text-[14.5px] font-semibold">{role.display_name}</div>
									<div class="font-mono text-[11px] text-ink-3">{role.code}</div>
								</div>
								<div class="font-mono text-[11px] text-ink-3">
									{role.permissions?.length ?? 0} perm
								</div>
							</div>
						{/each}
					</div>
				{/if}
			</CardContent>
		</Card>

		<Card>
			<CardContent>
				<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-2">
					விரைவு செயல்கள் · QUICK ACTIONS
				</div>
				<div class="flex flex-col gap-2">
					{#if data.canListUsers}
						<a
							href="/admin/users"
							class="flex items-center justify-between rounded border border-rule bg-paper px-3 py-3 hover:bg-paper-3 transition-colors"
						>
							<div>
								<div class="text-[14.5px] font-semibold">பயனர்களைப் பார்க்க</div>
								<div class="font-mono text-[11px] text-ink-3">View users · /admin/users</div>
							</div>
							<Icon name="chevron-right" size={18} />
						</a>
					{:else}
						<div class="rounded border border-dashed border-rule px-3 py-3 text-ink-3 text-[13px]">
							No actions available with your current roles.
						</div>
					{/if}
				</div>
			</CardContent>
		</Card>
	</section>
</div>
