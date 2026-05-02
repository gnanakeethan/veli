<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import Button from '$lib/components/ui/Button.svelte';
	import Field from '$lib/components/ui/Field.svelte';
	import StateCard from '$lib/components/ui/StateCard.svelte';
	import TierBadge from '$lib/components/ui/TierBadge.svelte';
	import Timeline from '$lib/components/ui/Timeline.svelte';
	import TimelineRow from '$lib/components/ui/TimelineRow.svelte';
	import { cn } from '$lib/utils';
	import type { ActionData, PageData } from './$types';

	let { data, form }: { data: PageData; form: ActionData } = $props();

	// Highest tier achieved on this document. Order is normative:
	// authority_attested > community_corroborated > self_asserted.
	const tierRank = { self_asserted: 1, community_corroborated: 2, authority_attested: 3 };
	const highestTier = $derived.by(() => {
		if (data.verifications.length === 0) return null;
		return data.verifications.reduce(
			(best, v) => (tierRank[v.tier] > tierRank[best.tier] ? v : best),
			data.verifications[0]
		).tier;
	});

	const canAttest = $derived(data.permissions.includes('documents:moderate'));

	function shortId(id: string): string {
		return id.length > 12 ? id.slice(0, 12) + '…' : id;
	}

	function fmtTime(iso: string): string {
		try {
			return new Date(iso).toISOString().replace('T', ' ').slice(0, 19) + ' UTC';
		} catch {
			return iso;
		}
	}

	const formValues = $derived(form?.values ?? { tier: 'self_asserted', attester_id: '', notes: '' });
</script>

<div class="flex flex-col gap-6">
	<header>
		<a
			href="/admin/documents"
			class="font-mono text-[12px] text-ink-3 hover:text-ink"
		>
			{m.admin_documents_back()}
		</a>
		<div class="flex flex-wrap items-baseline gap-3 mt-2">
			<h1 class="text-[26px] font-bold">{data.doc.kind}</h1>
			{#if highestTier}
				<TierBadge tier={highestTier} />
			{/if}
		</div>
		<p class="font-mono text-[11px] text-ink-3 break-all mt-1">{data.doc.id}</p>
	</header>

	{#if form?.error}
		<div
			role="alert"
			class={cn(
				'rounded border px-4 py-3 text-[13px]',
				'border-alert/40 bg-alert-soft text-alert-ink'
			)}
		>
			Attest failed: {form.error}
		</div>
	{/if}

	<section class="grid grid-cols-1 md:grid-cols-2 gap-6">
		<Card>
			<CardContent>
				<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-2">
					ஆவண விவரம் · DOCUMENT
				</div>
				<dl class="grid grid-cols-3 gap-y-3 text-[13.5px]">
					<dt class="font-mono text-[11px] text-ink-3 uppercase">{m.admin_documents_field_kind()}</dt>
					<dd class="col-span-2 font-mono">{data.doc.kind}</dd>

					<dt class="font-mono text-[11px] text-ink-3 uppercase">{m.admin_documents_field_user()}</dt>
					<dd class="col-span-2">
						<a
							href={`/admin/users/${data.doc.user_id}`}
							class="font-mono text-[12px] hover:underline"
						>
							{shortId(data.doc.user_id)}
						</a>
					</dd>

					<dt class="font-mono text-[11px] text-ink-3 uppercase">{m.admin_documents_field_storage()}</dt>
					<dd class="col-span-2 font-mono text-[12px] break-all">{data.doc.storage_uri}</dd>

					<dt class="font-mono text-[11px] text-ink-3 uppercase">{m.admin_documents_field_captured()}</dt>
					<dd class="col-span-2 font-mono text-[12px]">{fmtTime(data.doc.captured_at)}</dd>

					{#if data.doc.gps_lat !== undefined && data.doc.gps_lng !== undefined}
						<dt class="font-mono text-[11px] text-ink-3 uppercase">{m.admin_documents_field_gps()}</dt>
						<dd class="col-span-2 font-mono text-[12px]">
							{data.doc.gps_lat.toFixed(5)}, {data.doc.gps_lng.toFixed(5)}
						</dd>
					{/if}

					{#if data.doc.device_id}
						<dt class="font-mono text-[11px] text-ink-3 uppercase">{m.admin_documents_field_device()}</dt>
						<dd class="col-span-2 font-mono text-[12px]">{data.doc.device_id}</dd>
					{/if}

					<dt class="font-mono text-[11px] text-ink-3 uppercase">{m.admin_documents_field_created()}</dt>
					<dd class="col-span-2 font-mono text-[12px]">{fmtTime(data.doc.created_at)}</dd>
				</dl>
			</CardContent>
		</Card>

		<Card>
			<CardContent>
				<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-1">
					{m.admin_documents_verifications_subtitle()}
				</div>
				<h2 class="text-[18px] font-semibold mb-4">{m.admin_documents_verifications_title()}</h2>
				{#if data.verifications.length === 0}
					<StateCard
						kind="empty"
						title={m.admin_documents_verifications_empty()}
						body=""
					/>
				{:else}
					<Timeline>
						{#each data.verifications as v (v.id)}
							<TimelineRow
								state="done"
								time={fmtTime(v.verified_at).slice(0, 10)}
								title={v.tier}
								desc={`attester ${shortId(v.attester_id)}${v.notes ? ' · ' + v.notes : ''}`}
							/>
						{/each}
					</Timeline>
				{/if}
			</CardContent>
		</Card>
	</section>

	{#if canAttest}
		<section>
			<Card>
				<CardContent>
					<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mb-1">
						{m.admin_documents_attest_subtitle()}
					</div>
					<h2 class="text-[18px] font-semibold mb-4">{m.admin_documents_attest_title()}</h2>
					<form method="POST" action="?/attest" class="grid gap-4 md:grid-cols-3">
						<Field label={m.admin_documents_attest_tier()}>
							<select name="tier" class="field-input" required>
								<option
									value="self_asserted"
									selected={formValues.tier === 'self_asserted'}
								>self_asserted</option>
								<option
									value="community_corroborated"
									selected={formValues.tier === 'community_corroborated'}
								>community_corroborated</option>
								<option
									value="authority_attested"
									selected={formValues.tier === 'authority_attested'}
								>authority_attested</option>
							</select>
						</Field>
						<Field
							label={m.admin_documents_attest_attester()}
							hint={m.admin_documents_attest_attester_help_ulid()}
						>
							<input
								type="text"
								name="attester_id"
								class="field-input font-mono text-[13px]"
								required
								placeholder={data.doc.user_id}
								value={formValues.attester_id}
							/>
						</Field>
						<Field
							label={m.admin_documents_attest_notes()}
							hint={m.admin_documents_attest_notes_help()}
						>
							<input
								type="text"
								name="notes"
								class="field-input"
								value={formValues.notes}
							/>
						</Field>
						<div class="md:col-span-3 flex justify-end">
							<Button kind="primary" size="md" type="submit">
								{m.admin_documents_attest_submit()}
							</Button>
						</div>
					</form>
				</CardContent>
			</Card>
		</section>
	{/if}
</div>
