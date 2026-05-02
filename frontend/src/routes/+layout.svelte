<script lang="ts">
	import '../app.css';
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import LocaleSwitcher from '$lib/components/ui/LocaleSwitcher.svelte';

	let { children } = $props();

	// Admin routes carry their own page header with an integrated
	// LocaleSwitcher; rendering the fixed-corner one too would
	// stack two switchers on top of each other (see screenshot
	// from 2026-05-02). Citizen-facing routes (/, /users/*) have
	// no header bar and rely on this fixed one for locale switching.
	const isAdminRoute = $derived($page.url.pathname.startsWith('/admin'));

	onMount(async () => {
		try {
			const { SplashScreen } = await import('@capacitor/splash-screen');
			await SplashScreen.hide();
		} catch {
			// ignore: not running inside Capacitor
		}
	});
</script>

{#if !isAdminRoute}
	<div class="fixed right-4 top-4 z-50">
		<LocaleSwitcher />
	</div>
{/if}

{@render children?.()}
