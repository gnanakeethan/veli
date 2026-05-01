<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import * as m from '$lib/paraglide/messages';
	import type { PageData } from './+page.server';
	import Card from '$lib/components/ui/Card.svelte';
	import CardHeader from '$lib/components/ui/CardHeader.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import StatusStrip from '$lib/components/ui/StatusStrip.svelte';

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
			<Card>
				<CardHeader title={m.phase1_title()} />
				<CardContent>
					<p class="text-sm text-muted-foreground">{m.phase1_blurb()}</p>
				</CardContent>
			</Card>
			<Card>
				<CardHeader title={m.phase2_title()} />
				<CardContent>
					<p class="text-sm text-muted-foreground">{m.phase2_blurb()}</p>
				</CardContent>
			</Card>
			<Card>
				<CardHeader title={m.phase3_title()} />
				<CardContent>
					<p class="text-sm text-muted-foreground">{m.phase3_blurb()}</p>
				</CardContent>
			</Card>
		</section>
	</main>

	<footer class="border-t px-6 py-6 text-center text-sm text-muted-foreground">
		{m.footer()}
	</footer>

	<StatusStrip
		reachable={data.backend.reachable}
		hello={data.backend.hello}
		error={data.backend.error}
	/>
</div>
