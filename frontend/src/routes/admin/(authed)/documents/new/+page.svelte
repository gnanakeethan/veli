<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import Button from '$lib/components/ui/Button.svelte';
	import Field from '$lib/components/ui/Field.svelte';
	import { cn } from '$lib/utils';
	import type { ActionData } from './$types';

	let { form }: { form: ActionData } = $props();

	const v = $derived(
		form?.values ?? {
			user_id: '',
			kind: '',
			storage_uri: '',
			captured_at: '',
			gps_lat: '',
			gps_lng: '',
			device_id: ''
		}
	);
</script>

<div class="flex flex-col gap-6 max-w-3xl">
	<header>
		<a
			href="/admin/documents"
			class="font-mono text-[12px] text-ink-3 hover:text-ink"
		>
			{m.admin_documents_back()}
		</a>
		<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mt-2">
			ADMIN · {m.admin_documents_create_subtitle()}
		</div>
		<h1 class="text-[26px] font-bold mt-1">{m.admin_documents_create_title()}</h1>
	</header>

	{#if form?.error}
		<div
			role="alert"
			class={cn(
				'rounded border px-4 py-3 text-[13px]',
				'border-alert/40 bg-alert-soft text-alert-ink'
			)}
		>
			{form.error}
		</div>
	{/if}

	<Card>
		<CardContent>
			<form method="POST" class="grid gap-5 md:grid-cols-2">
				<div class="md:col-span-2">
					<Field
						label={m.admin_documents_field_user()}
						hint={m.admin_documents_form_user_help()}
					>
						<input
							type="text"
							name="user_id"
							class="field-input font-mono text-[13px]"
							required
							placeholder="01ARZ3NDEKTSV4RRFFQ69G5FAV"
							value={v.user_id}
						/>
					</Field>
				</div>

				<Field
					label={m.admin_documents_field_kind()}
					hint={m.admin_documents_form_kind_help()}
				>
					<input
						type="text"
						name="kind"
						class="field-input font-mono"
						required
						placeholder="birth_cert"
						value={v.kind}
					/>
				</Field>

				<Field
					label={m.admin_documents_field_captured()}
					hint={m.admin_documents_form_captured_help()}
				>
					<input
						type="datetime-local"
						name="captured_at"
						class="field-input"
						required
						value={v.captured_at}
					/>
				</Field>

				<div class="md:col-span-2">
					<Field
						label={m.admin_documents_field_storage()}
						hint={m.admin_documents_form_storage_help()}
					>
						<input
							type="text"
							name="storage_uri"
							class="field-input font-mono text-[13px]"
							required
							placeholder="s3://veli-evidence/users/.../file.jpg"
							value={v.storage_uri}
						/>
					</Field>
				</div>

				<Field
					label="GPS lat"
					hint={m.admin_documents_form_gps_help()}
				>
					<input
						type="text"
						name="gps_lat"
						class="field-input font-mono"
						placeholder="9.66845"
						value={v.gps_lat}
						inputmode="decimal"
					/>
				</Field>

				<Field label="GPS lng">
					<input
						type="text"
						name="gps_lng"
						class="field-input font-mono"
						placeholder="80.00742"
						value={v.gps_lng}
						inputmode="decimal"
					/>
				</Field>

				<div class="md:col-span-2">
					<Field
						label={m.admin_documents_field_device()}
						hint={m.admin_documents_form_device_help()}
					>
						<input
							type="text"
							name="device_id"
							class="field-input font-mono"
							value={v.device_id}
						/>
					</Field>
				</div>

				<div class="md:col-span-2 flex justify-end gap-3 pt-2 border-t border-rule">
					<Button kind="primary" size="md" type="submit">
						{m.admin_documents_form_submit()}
					</Button>
				</div>
			</form>
		</CardContent>
	</Card>
</div>
