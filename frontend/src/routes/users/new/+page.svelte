<script lang="ts">
	import { enhance } from '$app/forms'
	import * as m from '$lib/paraglide/messages'
	import type { ActionData } from './$types'
	import Card from '$lib/components/ui/Card.svelte'
	import CardHeader from '$lib/components/ui/CardHeader.svelte'
	import CardContent from '$lib/components/ui/CardContent.svelte'
	import Button from '$lib/components/ui/Button.svelte'
	import Field from '$lib/components/ui/Field.svelte'

	let { form }: { form: ActionData } = $props()

	// Pre-fill values from a failed submission so input is not lost.
	const vals = $derived(form?.values ?? { phone: '', display_name: '', locale: 'ta', nic_number: '' })

	function errorMessage(code: string | undefined): string {
		if (!code) return ''
		if (code === 'invalid phone') return m.invalid_phone_msg()
		if (code === 'invalid locale') return m.invalid_locale_msg()
		if (code === 'invalid display_name') return m.invalid_display_name_msg()
		if (code === 'invalid json') return m.register_unknown_error()
		if (code === 'server') return m.server_error()
		return m.register_unknown_error()
	}
</script>

<div class="flex min-h-screen flex-col bg-paper-2 text-ink">
	<main class="mx-auto w-full max-w-2xl px-6 py-12">
		<Card>
			<CardHeader>
				<h1 class="text-xl font-semibold text-primary">{m.register_user_title()}</h1>
			</CardHeader>
			<CardContent>
				<form method="POST" use:enhance class="flex flex-col gap-6">
					{#if form?.error}
						<div
							role="alert"
							class="rounded-md border border-alert/30 bg-alert-soft px-4 py-3 text-sm text-alert-ink"
						>
							{errorMessage(form.error)}
						</div>
					{/if}

					<!-- Phone -->
					<Field
						label={m.user_field_phone()}
						hint={m.register_phone_help()}
						error={form?.error === 'invalid phone' ? m.invalid_phone_msg() : undefined}
						required
						htmlFor="phone"
					>
						<input
							id="phone"
							name="phone"
							type="tel"
							required
							value={vals.phone}
							class:is-error={form?.error === 'invalid phone'}
							class="field-input"
						/>
					</Field>

					<!-- Display name -->
					<Field
						label={m.user_field_display_name()}
						error={form?.error === 'invalid display_name' ? m.invalid_display_name_msg() : undefined}
						required
						htmlFor="display_name"
					>
						<input
							id="display_name"
							name="display_name"
							type="text"
							required
							maxlength="200"
							value={vals.display_name}
							class:is-error={form?.error === 'invalid display_name'}
							class="field-input"
						/>
					</Field>

					<!-- Locale -->
					<Field
						label={m.register_locale_label()}
						error={form?.error === 'invalid locale' ? m.invalid_locale_msg() : undefined}
						required
						htmlFor="locale"
					>
						<select
							id="locale"
							name="locale"
							required
							class:is-error={form?.error === 'invalid locale'}
							class="field-input"
						>
							<option value="ta" selected={vals.locale === 'ta' || vals.locale === ''}>
								{m.register_locale_ta()}
							</option>
							<option value="en" selected={vals.locale === 'en'}>
								{m.register_locale_en()}
							</option>
							<option value="si" selected={vals.locale === 'si'}>
								{m.register_locale_si()}
							</option>
						</select>
					</Field>

					<!-- NIC (optional) -->
					<Field
						label={m.user_field_nic()}
						hint={m.register_nic_help()}
						htmlFor="nic_number"
					>
						<input
							id="nic_number"
							name="nic_number"
							type="text"
							value={vals.nic_number}
							class="field-input"
						/>
					</Field>

					<Button type="submit" kind="primary" size="lg">
						{m.register_submit()}
					</Button>
				</form>
			</CardContent>
		</Card>
	</main>
</div>
