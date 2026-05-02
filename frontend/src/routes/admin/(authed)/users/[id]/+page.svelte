<script lang="ts">
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import Button from '$lib/components/ui/Button.svelte';
	import Field from '$lib/components/ui/Field.svelte';
	import StateCard from '$lib/components/ui/StateCard.svelte';
	import Badge from '$lib/components/ui/Badge.svelte';
	import { cn } from '$lib/utils';
	import type { ActionData, PageData } from './$types';

	let { data, form }: { data: PageData; form: ActionData } = $props();

	const heldCodes = $derived(new Set(data.roles.map((r) => r.code)));
	const assignable = $derived(
		data.assignableRoles.filter((code) => !heldCodes.has(code))
	);
	const canAssign = $derived(data.permissions.includes('roles:assign'));
</script>

<div class="flex flex-col gap-6">
	<header>
		<a
			href="/admin/users"
			class="font-mono text-[12px] text-ink-3 hover:text-ink"
			aria-label="Back to users"
		>
			← பயனர் பட்டியல்க்கு திரும்பு
		</a>
		<h1 class="text-[26px] font-bold mt-2">{data.user.display_name}</h1>
		<p class="font-mono text-[11px] text-ink-3 break-all">{data.user.id}</p>
	</header>

	{#if form?.error}
		<div
			role="alert"
			class={cn(
				'rounded border px-4 py-3 text-[13px]',
				'border-alert/40 bg-alert-soft text-alert-ink'
			)}
		>
			{form.action === 'assign' ? 'Assign failed' : 'Revoke failed'}: {form.error}
		</div>
	{/if}

	<section class="grid grid-cols-1 md:grid-cols-2 gap-6">
		<Card>
			<CardContent>
				<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-2">
					பயனர் விவரம் · USER
				</div>
				<dl class="grid grid-cols-3 gap-y-3 text-[13.5px]">
					<dt class="font-mono text-[11px] text-ink-3 uppercase">தொலைபேசி</dt>
					<dd class="col-span-2">{data.user.phone}</dd>
					{#if data.user.email}
						<dt class="font-mono text-[11px] text-ink-3 uppercase">Email</dt>
						<dd class="col-span-2 break-all">{data.user.email}</dd>
					{/if}
					{#if data.user.nic_number}
						<dt class="font-mono text-[11px] text-ink-3 uppercase">NIC</dt>
						<dd class="col-span-2">{data.user.nic_number}</dd>
					{/if}
					<dt class="font-mono text-[11px] text-ink-3 uppercase">மொழி</dt>
					<dd class="col-span-2">{data.user.locale}</dd>
					<dt class="font-mono text-[11px] text-ink-3 uppercase">பதிவு</dt>
					<dd class="col-span-2 font-mono text-[12px]">
						{new Date(data.user.created_at).toISOString()}
					</dd>
				</dl>
			</CardContent>
		</Card>

		<Card>
			<CardContent>
				<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-2">
					பாத்திரங்கள் · ROLES
				</div>
				{#if data.roles.length === 0}
					<StateCard
						kind="empty"
						title="பாத்திரம் இல்லை"
						body="No roles assigned. Use the form below to assign one."
					/>
				{:else}
					<div class="flex flex-col gap-2">
						{#each data.roles as role (role.id)}
							<div
								class="flex items-baseline justify-between rounded border border-rule bg-paper px-3 py-2"
							>
								<div>
									<div class="text-[14px] font-semibold">{role.display_name}</div>
									<div class="font-mono text-[11px] text-ink-3">
										{role.code} · {role.permissions?.length ?? 0} permissions
									</div>
								</div>
								{#if canAssign}
									<form method="POST" action="?/revoke">
										<input type="hidden" name="code" value={role.code} />
										<Button kind="alert" size="sm" type="submit">நீக்கு</Button>
									</form>
								{:else}
									<Badge kind="mute">held</Badge>
								{/if}
							</div>
						{/each}
					</div>
				{/if}
			</CardContent>
		</Card>
	</section>

	{#if canAssign}
		<section>
			<Card>
				<CardContent>
					<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-2">
						பாத்திரம் சேர் · ASSIGN ROLE
					</div>
					{#if assignable.length === 0}
						<p class="text-[13px] text-ink-3">
							This user already holds all assignable roles.
						</p>
					{:else}
						<form method="POST" action="?/assign" class="flex items-end gap-3">
							<div class="flex-1 max-w-xs">
								<Field label="பாத்திரம்">
									<select name="code" class="field-input" required>
										{#each assignable as code (code)}
											<option value={code}>{code}</option>
										{/each}
									</select>
								</Field>
							</div>
							<Button kind="primary" size="md" type="submit">சேர்</Button>
						</form>
					{/if}
				</CardContent>
			</Card>
		</section>
	{/if}
</div>
