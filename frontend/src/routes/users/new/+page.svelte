<script lang="ts">
	import { enhance } from '$app/forms';
	import * as m from '$lib/paraglide/messages';
	import type { ActionData } from './$types';
	import Card from '$lib/components/ui/Card.svelte';
	import CardHeader from '$lib/components/ui/CardHeader.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import Button from '$lib/components/ui/Button.svelte';

	let { form }: { form: ActionData } = $props();

	// Pre-fill values from a failed submission so input is not lost.
	const vals = $derived(form?.values ?? { phone: '', display_name: '', locale: 'ta', nic_number: '' });

	function errorMessage(code: string | undefined): string {
		if (!code) return '';
		if (code === 'invalid phone') return m.invalid_phone_msg();
		if (code === 'invalid locale') return m.invalid_locale_msg();
		if (code === 'invalid display_name') return m.invalid_display_name_msg();
		if (code === 'invalid json') return m.register_unknown_error();
		if (code === 'server') return m.server_error();
		return m.register_unknown_error();
	}
</script>

<div class="flex min-h-screen flex-col bg-background text-foreground">
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
							class="rounded-md border border-destructive/30 bg-destructive/10 px-4 py-3 text-sm text-destructive"
						>
							{errorMessage(form.error)}
						</div>
					{/if}

					<!-- Phone -->
					<div class="flex flex-col gap-1">
						<label
							for="phone"
							class="text-sm font-medium text-foreground"
							aria-label={m.user_field_phone()}
						>
							{m.user_field_phone()}
						</label>
						<input
							id="phone"
							name="phone"
							type="tel"
							required
							value={vals.phone}
							aria-label={m.user_field_phone()}
							class="h-11 w-full rounded-md border border-border bg-background px-3 text-sm text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
						/>
						<p class="text-xs text-muted-foreground">{m.register_phone_help()}</p>
						{#if form?.error === 'invalid phone'}
							<p class="text-sm text-destructive">{m.invalid_phone_msg()}</p>
						{/if}
					</div>

					<!-- Display name -->
					<div class="flex flex-col gap-1">
						<label
							for="display_name"
							class="text-sm font-medium text-foreground"
							aria-label={m.user_field_display_name()}
						>
							{m.user_field_display_name()}
						</label>
						<input
							id="display_name"
							name="display_name"
							type="text"
							required
							maxlength="200"
							value={vals.display_name}
							aria-label={m.user_field_display_name()}
							class="h-11 w-full rounded-md border border-border bg-background px-3 text-sm text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
						/>
						{#if form?.error === 'invalid display_name'}
							<p class="text-sm text-destructive">{m.invalid_display_name_msg()}</p>
						{/if}
					</div>

					<!-- Locale -->
					<div class="flex flex-col gap-1">
						<label
							for="locale"
							class="text-sm font-medium text-foreground"
							aria-label={m.register_locale_label()}
						>
							{m.register_locale_label()}
						</label>
						<select
							id="locale"
							name="locale"
							required
							aria-label={m.register_locale_label()}
							class="h-11 w-full rounded-md border border-border bg-background px-3 text-sm text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
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
						{#if form?.error === 'invalid locale'}
							<p class="text-sm text-destructive">{m.invalid_locale_msg()}</p>
						{/if}
					</div>

					<!-- NIC (optional) -->
					<div class="flex flex-col gap-1">
						<label
							for="nic_number"
							class="text-sm font-medium text-foreground"
							aria-label={m.user_field_nic()}
						>
							{m.user_field_nic()}
						</label>
						<input
							id="nic_number"
							name="nic_number"
							type="text"
							value={vals.nic_number}
							aria-label={m.user_field_nic()}
							class="h-11 w-full rounded-md border border-border bg-background px-3 text-sm text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
						/>
						<p class="text-xs text-muted-foreground">{m.register_nic_help()}</p>
					</div>

					<Button type="submit" variant="primary" size="lg" aria-label={m.register_submit()}>
						{m.register_submit()}
					</Button>
				</form>
			</CardContent>
		</Card>
	</main>
</div>
