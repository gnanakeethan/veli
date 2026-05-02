<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import CardFooter from '$lib/components/ui/CardFooter.svelte';
	import LocaleSwitcher from '$lib/components/ui/LocaleSwitcher.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const errorTextTa = $derived.by(() => {
		switch (data.error) {
			case 'unconfigured':
				return m.admin_login_error_unconfigured_ta();
			case 'not_provisioned':
				return m.admin_login_error_not_provisioned_ta();
			case 'state_mismatch':
			case 'missing_code':
			case 'invalid_id_token':
			case 'generic':
				return m.admin_login_error_generic_ta();
			default:
				return null;
		}
	});

	const errorTextEn = $derived.by(() => {
		switch (data.error) {
			case 'unconfigured':
				return m.admin_login_error_unconfigured();
			case 'not_provisioned':
				return m.admin_login_error_not_provisioned();
			case 'state_mismatch':
			case 'missing_code':
			case 'invalid_id_token':
			case 'generic':
				return m.admin_login_error_generic();
			default:
				return null;
		}
	});
</script>

<svelte:head>
	<title>{m.admin_login_title()} · {m.app_name()}</title>
</svelte:head>

<div class="flex min-h-screen flex-col bg-paper-2 text-ink">
	<header class="flex items-center justify-between px-6 py-4 border-b border-rule">
		<a href="/" class="hero-mark text-2xl">
			வெளி<span class="dot">.</span>
		</a>
		<LocaleSwitcher />
	</header>

	<main class="flex-1 flex items-center justify-center px-6 py-12">
		<div class="w-full max-w-md">
			<Card>
				<CardContent>
					<div
						class="text-xs font-mono uppercase tracking-wider text-ink-3 mb-2"
					>
						ADMIN · {m.admin_login_subtitle_ta()}
					</div>
					<h1 class="text-[26px] font-bold leading-tight mb-2">
						{m.admin_login_title()}
					</h1>
					<p class="text-[14.5px] text-ink-2 leading-relaxed">
						{m.admin_login_blurb_ta()}
					</p>
					<p class="font-latin text-[13px] text-ink-3 leading-relaxed mt-2">
						{m.admin_login_blurb()}
					</p>

					{#if errorTextTa && errorTextEn}
						<div
							role="alert"
							class="mt-5 rounded border border-alert/40 bg-alert-soft px-4 py-3 text-alert-ink text-[13.5px]"
						>
							<div>{errorTextTa}</div>
							<div class="font-latin text-[12.5px] mt-1 opacity-90">
								{errorTextEn}
							</div>
						</div>
					{/if}

					<a
						href="/api/v1/auth/google/start"
						class="btn btn-primary btn-lg btn-block mt-6"
						data-testid="admin-login-google"
					>
						<span>{m.admin_login_signin_ta()}</span>
					</a>
				</CardContent>
				<CardFooter>
					<div class="font-mono text-[11.5px] text-ink-3 leading-relaxed">
						<div>↳ {m.admin_login_security_note_ta()}</div>
						<div class="opacity-80">↳ {m.admin_login_security_note()}</div>
					</div>
				</CardFooter>
			</Card>
		</div>
	</main>

	<footer
		class="border-t border-rule px-6 py-4 text-center text-[12.5px] text-ink-3"
	>
		{m.footer()}
	</footer>
</div>
