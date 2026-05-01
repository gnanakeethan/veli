<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import * as m from '$lib/paraglide/messages';
	import type { PageData } from './+page.server';

	let { data }: { data: PageData } = $props();

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

	<div
		class="border-t px-6 py-3 text-xs"
		class:bg-destructive={!data.backend.reachable}
		class:text-destructive-foreground={!data.backend.reachable}
		class:bg-card={data.backend.reachable}
		class:text-muted-foreground={data.backend.reachable}
	>
		<span class="font-medium">{m.system_status()}:</span>
		{#if data.backend.reachable}
			<span class="ml-1">{m.backend_reachable()}</span>
			{#if data.backend.hello}
				<span class="ml-2 rounded bg-secondary px-1.5 py-0.5 text-secondary-foreground">
					{m.phase_label({ phase: data.backend.hello.phase })}
				</span>
			{/if}
		{:else}
			<span class="ml-1">{m.backend_unreachable()}</span>
			{#if data.backend.error}
				<span class="ml-2 opacity-75">({data.backend.error})</span>
			{/if}
		{/if}
	</div>
</div>
