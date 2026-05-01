<script lang="ts">
	import '../app.css';
	import { onMount } from 'svelte';

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

{@render children?.()}
