<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import * as m from '$lib/paraglide/messages';

	onMount(async () => {
		try {
			const { Capacitor } = await import('@capacitor/core');
			if (Capacitor.isNativePlatform()) {
				await goto('/app/home', { replaceState: true });
			}
		} catch {
			// ignore: not running inside Capacitor
		}
	});
</script>

<div class="flex min-h-screen flex-col bg-background text-foreground">
	<main class="flex flex-1 flex-col items-center justify-center px-6 py-16">
		<section class="flex flex-col items-center text-center">
			<h1 class="text-7xl font-bold tracking-tight text-primary sm:text-8xl">வெளி</h1>
			<p class="mt-3 text-4xl font-medium text-muted-foreground">Veḷi</p>
			<p class="mt-6 max-w-2xl text-base text-muted-foreground sm:text-lg">{m.tagline()}</p>
		</section>

		<section class="mt-16 grid w-full max-w-5xl grid-cols-1 gap-6 sm:grid-cols-3">
			<article class="rounded-lg border bg-card p-6 text-card-foreground shadow-sm">
				<h2 class="text-lg font-semibold text-primary">{m.phase1_title()}</h2>
				<p class="mt-3 text-sm text-muted-foreground">{m.phase1_blurb()}</p>
			</article>
			<article class="rounded-lg border bg-card p-6 text-card-foreground shadow-sm">
				<h2 class="text-lg font-semibold text-primary">{m.phase2_title()}</h2>
				<p class="mt-3 text-sm text-muted-foreground">{m.phase2_blurb()}</p>
			</article>
			<article class="rounded-lg border bg-card p-6 text-card-foreground shadow-sm">
				<h2 class="text-lg font-semibold text-primary">{m.phase3_title()}</h2>
				<p class="mt-3 text-sm text-muted-foreground">{m.phase3_blurb()}</p>
			</article>
		</section>
	</main>

	<footer class="border-t px-6 py-6 text-center text-sm text-muted-foreground">
		{m.footer()}
	</footer>
</div>
