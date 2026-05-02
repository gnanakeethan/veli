<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import Badge from '$lib/components/ui/Badge.svelte';
	import ProcedureForm from '$lib/components/admin/ProcedureForm.svelte';
	import type { ActionData, PageData } from './$types';

	let { data, form }: { data: PageData; form: ActionData } = $props();

	// Status transitions are linear; offer only legal next states +
	// the current value. Backend enforces this too — this just
	// avoids a UI that lets the user pick something the server will
	// reject.
	const allowedStatuses = $derived.by(() => {
		switch (data.proc.status) {
			case 'draft':
				return ['draft', 'published'];
			case 'published':
				return ['published', 'archived'];
			case 'archived':
				return ['archived'];
			default:
				return ['draft'];
		}
	});

	function statusBadgeKind(status: string) {
		switch (status) {
			case 'published':
				return 'primary' as const;
			case 'archived':
				return 'mute' as const;
			default:
				return 'accent' as const;
		}
	}

	// datetime-local format: yyyy-MM-ddTHH:mm (no timezone).
	const lastVerifiedDefault = $derived(
		data.proc.last_verified_at ? data.proc.last_verified_at.slice(0, 16) : ''
	);

	// Pre-fill form values from the loaded procedure unless the
	// previous submission failed and form.values is set (which
	// preserves the user's in-progress edits).
	const initialValues = $derived(
		form?.values ?? {
			slug: data.proc.slug,
			title_ta: data.proc.title_ta,
			title_en: data.proc.title_en ?? '',
			summary_ta: data.proc.summary_ta ?? '',
			summary_en: data.proc.summary_en ?? '',
			fee_lkr:
				data.proc.fee_lkr_cents !== undefined && data.proc.fee_lkr_cents !== null
					? String(data.proc.fee_lkr_cents / 100)
					: '',
			source_url: data.proc.source_url ?? '',
			last_verified_at: lastVerifiedDefault,
			status: data.proc.status
		}
	);
</script>

<div class="flex flex-col gap-6 max-w-3xl">
	<header>
		<a
			href="/admin/procedures"
			class="font-mono text-[12px] text-ink-3 hover:text-ink"
		>
			{m.admin_procedures_back()}
		</a>
		<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mt-2">
			ADMIN · {m.admin_procedures_list_subtitle()}
		</div>
		<div class="flex flex-wrap items-baseline gap-3 mt-1">
			<h1 class="text-[26px] font-bold">{m.admin_procedures_edit_title()}</h1>
			<Badge kind={statusBadgeKind(data.proc.status)}>{data.proc.status}</Badge>
		</div>
		<p class="font-mono text-[11px] text-ink-3 mt-1">
			{data.proc.id}
		</p>
	</header>

	<Card>
		<CardContent>
			<ProcedureForm
				values={initialValues}
				error={form?.error ?? null}
				isEdit={true}
				{allowedStatuses}
			/>
		</CardContent>
	</Card>
</div>
