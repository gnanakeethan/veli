<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Field from '$lib/components/ui/Field.svelte';
	import Button from '$lib/components/ui/Button.svelte';
	import { cn } from '$lib/utils';

	export interface ProcedureFormValues {
		slug?: string;
		title_ta?: string;
		title_en?: string;
		summary_ta?: string;
		summary_en?: string;
		fee_lkr?: string;
		source_url?: string;
		last_verified_at?: string;
		status?: string;
	}

	interface Props {
		values?: ProcedureFormValues;
		error?: string | null;
		isEdit?: boolean;
		// Status transitions are linear: draft → published → archived.
		// When editing, we restrict the select to legal next-states so
		// the user can't try a backwards transition that the backend
		// will reject (and which would land them with an unhelpful
		// error response after a round trip).
		allowedStatuses?: string[];
	}

	let {
		values = {},
		error = null,
		isEdit = false,
		allowedStatuses = ['draft', 'published', 'archived']
	}: Props = $props();
</script>

{#if error}
	<div
		role="alert"
		class={cn(
			'rounded border px-4 py-3 text-[13px] mb-4',
			'border-alert/40 bg-alert-soft text-alert-ink'
		)}
	>
		{error}
	</div>
{/if}

<form method="POST" class="grid gap-5 md:grid-cols-2">
	<div class="md:col-span-2">
		<Field label="slug" hint={m.admin_procedures_field_slug_help()}>
			<input
				type="text"
				name="slug"
				class="field-input font-mono"
				required
				readonly={isEdit}
				placeholder="birth-certificate-replacement"
				value={values.slug ?? ''}
			/>
		</Field>
	</div>

	<Field label="title (ta)" hint={m.admin_procedures_field_title_ta_help()}>
		<input
			type="text"
			name="title_ta"
			class="field-input"
			required
			value={values.title_ta ?? ''}
		/>
	</Field>

	<Field label="title (en)" hint={m.admin_procedures_field_title_en_help()}>
		<input type="text" name="title_en" class="field-input" value={values.title_en ?? ''} />
	</Field>

	<div class="md:col-span-2">
		<Field label="summary (ta)" hint={m.admin_procedures_field_summary_ta_help()}>
			<textarea name="summary_ta" class="field-input" rows="4">{values.summary_ta ?? ''}</textarea>
		</Field>
	</div>

	<div class="md:col-span-2">
		<Field label="summary (en)" hint={m.admin_procedures_field_summary_en_help()}>
			<textarea name="summary_en" class="field-input" rows="3">{values.summary_en ?? ''}</textarea>
		</Field>
	</div>

	<Field label="fee (LKR)" hint={m.admin_procedures_field_fee_help()}>
		<input
			type="text"
			name="fee_lkr"
			class="field-input font-mono"
			placeholder="100"
			inputmode="decimal"
			value={values.fee_lkr ?? ''}
		/>
	</Field>

	<Field label="status" hint={m.admin_procedures_field_status_help()}>
		<select name="status" class="field-input" required>
			{#each allowedStatuses as code (code)}
				<option value={code} selected={values.status === code}>{code}</option>
			{/each}
		</select>
	</Field>

	<div class="md:col-span-2">
		<Field label="source_url" hint={m.admin_procedures_field_source_help()}>
			<input
				type="url"
				name="source_url"
				class="field-input font-mono text-[13px]"
				placeholder="https://www.rgd.gov.lk/birth.html"
				value={values.source_url ?? ''}
			/>
		</Field>
	</div>

	<Field
		label="last_verified_at"
		hint={m.admin_procedures_field_last_verified_help()}
	>
		<input
			type="datetime-local"
			name="last_verified_at"
			class="field-input"
			value={values.last_verified_at ?? ''}
		/>
	</Field>

	<div class="md:col-span-2 flex justify-end gap-3 pt-2 border-t border-rule">
		<Button kind="primary" size="md" type="submit">
			{m.admin_procedures_form_save()}
		</Button>
	</div>
</form>
