<script lang="ts">
	import '../app.css';
	import { onMount } from 'svelte';
	import LocaleSwitcher from '$lib/components/locale-switcher.svelte';

	let { children } = $props();

	onMount(async () => {
		try {
			const { SplashScreen } = await import('@capacitor/splash-screen');
			await SplashScreen.hide();
		} catch {
			// ignore: not running inside Capacitor
		}
	});
</script>

<div class="fixed right-4 top-4 z-50">
	<LocaleSwitcher />
</div>

{@render children?.()}
