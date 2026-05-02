<script lang="ts">
	import { onMount } from 'svelte'
	import { goto } from '$app/navigation'
	import * as m from '$lib/paraglide/messages'
	import type { PageData } from './+page.server'
	import Card from '$lib/components/ui/Card.svelte'
	import CardContent from '$lib/components/ui/CardContent.svelte'
	import StatusStrip from '$lib/components/ui/StatusStrip.svelte'
	import Button from '$lib/components/ui/Button.svelte'
	import VeliMark from '$lib/components/ui/VeliMark.svelte'
	import Timeline from '$lib/components/ui/Timeline.svelte'
	import TimelineRow from '$lib/components/ui/TimelineRow.svelte'
	import TierBadge from '$lib/components/ui/TierBadge.svelte'

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

<div class="flex min-h-screen flex-col bg-paper-2 text-ink page">
	<main class="flex flex-1 flex-col px-6 py-12 max-w-5xl mx-auto w-full">

		<!-- Hero -->
		<section class="mb-8">
			<div class="flex flex-col gap-6 sm:flex-row sm:items-end sm:gap-12">
				<div class="flex flex-col gap-3">
					<h1 class="m-0"><VeliMark /></h1>
					<span class="tamil-submark">வெளி<span class="dot">.</span></span>
				</div>
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

		<!-- Tagline -->
		<section class="mb-10">
			<p class="tagline-line">{m.tagline()}</p>
		</section>

		<!-- CTA -->
		<section class="mb-14 flex flex-wrap gap-3">
			<a href="/procedures">
				<Button kind="primary" size="md">{m.home_procedures_link()}</Button>
			</a>
			<a href="/users/new">
				<Button kind="ghost" size="md">{m.register_cta()}</Button>
			</a>
		</section>

		<!-- Phase status timeline -->
		<section class="mb-14">
			<div class="sec-tag mb-3"><span>STATUS</span></div>
			<h2 class="sec-title">{m.home_phase_status_title()}</h2>
			<p class="sec-sub">{m.home_phase_status_blurb()}</p>
			<div class="mt-6">
				<Timeline>
					<TimelineRow
						time="2026"
						state="active"
						title={`${m.home_phase0_title()} · ${m.home_phase_current()}`}
						desc={m.home_phase0_blurb()}
					/>
					<TimelineRow
						time="2026–27"
						state="pending"
						title={m.phase1_title()}
						desc={m.phase1_blurb()}
					/>
					<TimelineRow
						time="2027–28"
						state="pending"
						title={m.phase2_title()}
						desc={m.phase2_blurb()}
					/>
					<TimelineRow
						time="2028–29"
						state="pending"
						title={m.phase3_title()}
						desc={m.phase3_blurb()}
					/>
					<TimelineRow
						time="2029–30"
						state="pending"
						title={m.home_phase4_title()}
						desc={m.home_phase4_blurb()}
					/>
				</Timeline>
			</div>
		</section>

		<!-- Three-tier verification -->
		<section class="mb-14">
			<div class="sec-tag mb-3"><span>VERIFICATION</span></div>
			<h2 class="sec-title">{m.home_verification_title()}</h2>
			<p class="sec-sub">{m.home_verification_blurb()}</p>
			<div class="grid gap-4 mt-6 sm:grid-cols-3">
				<Card>
					<CardContent>
						<TierBadge tier="self_asserted" />
						<p class="text-[14.5px] text-ink-2 leading-relaxed mt-3">{m.home_tier_self_asserted_blurb()}</p>
					</CardContent>
				</Card>
				<Card>
					<CardContent>
						<TierBadge tier="community_corroborated" />
						<p class="text-[14.5px] text-ink-2 leading-relaxed mt-3">{m.home_tier_community_corroborated_blurb()}</p>
					</CardContent>
				</Card>
				<Card>
					<CardContent>
						<TierBadge tier="authority_attested" />
						<p class="text-[14.5px] text-ink-2 leading-relaxed mt-3">{m.home_tier_authority_attested_blurb()}</p>
					</CardContent>
				</Card>
			</div>
		</section>

		<!-- Channels -->
		<section class="mb-12">
			<div class="sec-tag mb-3"><span>CHANNELS</span></div>
			<h2 class="sec-title">{m.home_channels_title()}</h2>
			<p class="sec-sub">{m.home_channels_blurb()}</p>
			<div class="grid gap-3 mt-6 grid-cols-1 sm:grid-cols-2 lg:grid-cols-5">
				<div class="ch-cell">
					<span class="ch-code">PWA</span>
					<h3 class="ch-title">{m.home_channel_pwa_title()}</h3>
					<p class="ch-desc">{m.home_channel_pwa_desc()}</p>
				</div>
				<div class="ch-cell">
					<span class="ch-code">IVR</span>
					<h3 class="ch-title">{m.home_channel_ivr_title()}</h3>
					<p class="ch-desc">{m.home_channel_ivr_desc()}</p>
				</div>
				<div class="ch-cell">
					<span class="ch-code">USSD</span>
					<h3 class="ch-title">{m.home_channel_ussd_title()}</h3>
					<p class="ch-desc">{m.home_channel_ussd_desc()}</p>
				</div>
				<div class="ch-cell">
					<span class="ch-code">SMS</span>
					<h3 class="ch-title">{m.home_channel_sms_title()}</h3>
					<p class="ch-desc">{m.home_channel_sms_desc()}</p>
				</div>
				<div class="ch-cell">
					<span class="ch-code">HOT</span>
					<h3 class="ch-title">{m.home_channel_hotline_title()}</h3>
					<p class="ch-desc">{m.home_channel_hotline_desc()}</p>
				</div>
			</div>
		</section>
	</main>

	<footer class="border-t border-rule px-6 py-6 text-sm text-ink-3 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
		<span>{m.footer()}</span>
		<a
			href="/admin/login"
			class="font-mono text-[11.5px] uppercase tracking-wider text-ink-3 hover:text-ink transition-colors flex items-center gap-1.5"
			data-testid="home-staff-signin"
		>
			<span>{m.home_staff_signin()}</span>
			<span aria-hidden="true">→</span>
		</a>
	</footer>

	<StatusStrip
		reachable={data.backend.reachable}
		hello={data.backend.hello}
		error={data.backend.error}
	/>
</div>

<style>
	.page :global(.tamil-submark) {
		font-family: var(--f-tamil);
		font-weight: 700;
		font-size: clamp(28px, 4vw, 44px);
		line-height: 1;
		letter-spacing: -0.02em;
		color: var(--ink-2);
	}
	.page :global(.tamil-submark .dot) {
		color: var(--accent);
	}

	.tagline-line {
		font-family: var(--f-tamil);
		font-weight: 600;
		font-size: clamp(18px, 2.4vw, 26px);
		line-height: 1.35;
		color: var(--ink);
		margin: 0;
		max-width: 48ch;
	}

	.sec-title {
		font-size: clamp(22px, 2.6vw, 28px);
		font-weight: 800;
		line-height: 1.2;
		letter-spacing: -0.01em;
		color: var(--ink);
		margin: 6px 0 4px 0;
	}
	.sec-sub {
		font-size: 14.5px;
		line-height: 1.55;
		color: var(--ink-2);
		max-width: 64ch;
		margin: 0;
	}

	.ch-cell {
		background: var(--paper);
		border: 1px solid var(--rule);
		border-radius: var(--r-md);
		padding: 16px 14px;
		display: flex;
		flex-direction: column;
		gap: 6px;
	}
	.ch-code {
		font-family: var(--f-mono);
		font-size: 10.5px;
		font-weight: 700;
		letter-spacing: 0.14em;
		color: var(--paper);
		background: var(--ink);
		padding: 3px 7px;
		border-radius: 3px;
		align-self: flex-start;
		margin-bottom: 4px;
	}
	.ch-title {
		font-size: 16px;
		font-weight: 700;
		color: var(--ink);
		line-height: 1.2;
		margin: 0;
	}
	.ch-desc {
		font-size: 13.5px;
		line-height: 1.5;
		color: var(--ink-2);
		margin: 0;
	}
</style>
