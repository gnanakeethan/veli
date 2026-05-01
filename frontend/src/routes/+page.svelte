<script lang="ts">
	import { onMount } from 'svelte'
	import { goto } from '$app/navigation'
	import * as m from '$lib/paraglide/messages'
	import type { PageData } from './+page.server'
	import Card from '$lib/components/ui/Card.svelte'
	import CardContent from '$lib/components/ui/CardContent.svelte'
	import StatusStrip from '$lib/components/ui/StatusStrip.svelte'
	import Button from '$lib/components/ui/Button.svelte'

	let { data }: { data: PageData } = $props()

	onMount(async () => {
		try {
			const { Capacitor } = await import('@capacitor/core')
			if (Capacitor.isNativePlatform()) {
				await goto('/app/home', { replaceState: true })
			}
		} catch {
			// ignore: not running inside Capacitor
		}
	})
</script>

<div class="flex min-h-screen flex-col bg-paper-2 text-ink">
	<main class="flex flex-1 flex-col px-6 py-12 max-w-5xl mx-auto w-full">

		<!-- Hero -->
		<section class="mb-12">
			<div class="flex flex-col gap-6 sm:flex-row sm:items-end sm:gap-12">
				<h1 class="hero-mark">வெளி<span class="dot">.</span></h1>
				<dl class="grid grid-cols-2 gap-x-8 gap-y-3 pb-2 text-sm">
					<div>
						<dt class="text-xs font-mono uppercase tracking-wider text-ink-3">{m.hero_meta_name_label()}</dt>
						<dd class="font-semibold text-ink mt-0.5">{m.hero_meta_name_value()}</dd>
					</div>
					<div>
						<dt class="text-xs font-mono uppercase tracking-wider text-ink-3">{m.hero_meta_meaning_label()}</dt>
						<dd class="font-semibold text-ink mt-0.5">{m.hero_meta_meaning_value()}</dd>
					</div>
					<div>
						<dt class="text-xs font-mono uppercase tracking-wider text-ink-3">{m.hero_meta_use_label()}</dt>
						<dd class="text-ink-2 mt-0.5">{m.hero_meta_use_value()}</dd>
					</div>
					<div>
						<dt class="text-xs font-mono uppercase tracking-wider text-ink-3">{m.hero_meta_version_label()}</dt>
						<dd class="font-mono text-ink-3 mt-0.5">{m.hero_meta_version_value()}</dd>
					</div>
				</dl>
			</div>
		</section>

		<!-- CTA -->
		<section class="mb-10">
			<a href="/users/new">
				<Button kind="primary" size="md">{m.register_cta()}</Button>
			</a>
		</section>

		<!-- Phase cards -->
		<section class="grid w-full grid-cols-1 gap-6 sm:grid-cols-3">
			<!-- Phase 1 -->
			<Card>
				<CardContent>
					<div class="text-xs font-mono uppercase tracking-wider text-ink-3 flex items-center gap-2 mb-3">
						<span class="bg-ink text-paper rounded-sm w-[22px] h-[22px] inline-flex items-center justify-center font-semibold text-xs">1</span>
						SERVICES
					</div>
					<h2 class="text-[22px] font-bold leading-tight">{m.phase1_title()}</h2>
					<p class="font-latin text-sm text-ink-3 mt-0.5">{m.phase1_subtitle_en()}</p>
					<p class="text-[14.5px] text-ink-2 leading-relaxed mt-2">{m.phase1_blurb()}</p>
				</CardContent>
			</Card>

			<!-- Phase 2 -->
			<Card>
				<CardContent>
					<div class="text-xs font-mono uppercase tracking-wider text-ink-3 flex items-center gap-2 mb-3">
						<span class="bg-ink text-paper rounded-sm w-[22px] h-[22px] inline-flex items-center justify-center font-semibold text-xs">2</span>
						LAND
					</div>
					<h2 class="text-[22px] font-bold leading-tight">{m.phase2_title()}</h2>
					<p class="font-latin text-sm text-ink-3 mt-0.5">{m.phase2_subtitle_en()}</p>
					<p class="text-[14.5px] text-ink-2 leading-relaxed mt-2">{m.phase2_blurb()}</p>
				</CardContent>
			</Card>

			<!-- Phase 3 -->
			<Card>
				<CardContent>
					<div class="text-xs font-mono uppercase tracking-wider text-ink-3 flex items-center gap-2 mb-3">
						<span class="bg-ink text-paper rounded-sm w-[22px] h-[22px] inline-flex items-center justify-center font-semibold text-xs">3</span>
						AGRI
					</div>
					<h2 class="text-[22px] font-bold leading-tight">{m.phase3_title()}</h2>
					<p class="font-latin text-sm text-ink-3 mt-0.5">{m.phase3_subtitle_en()}</p>
					<p class="text-[14.5px] text-ink-2 leading-relaxed mt-2">{m.phase3_blurb()}</p>
				</CardContent>
			</Card>
		</section>
	</main>

	<footer class="border-t border-rule px-6 py-6 text-center text-sm text-ink-3">
		{m.footer()}
	</footer>

	<StatusStrip
		reachable={data.backend.reachable}
		hello={data.backend.hello}
		error={data.backend.error}
	/>
</div>
