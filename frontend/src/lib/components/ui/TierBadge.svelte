<script lang="ts">
	import * as m from '$lib/paraglide/messages'
	import type { VerificationTier } from '$lib/api'

	interface Props {
		tier: VerificationTier
	}

	let { tier }: Props = $props()

	const tierLevel = $derived(
		tier === 'authority_attested'
			? 'gold'
			: tier === 'community_corroborated'
				? 'silver'
				: 'bronze'
	)

	const enLabel = $derived(
		tier === 'authority_attested'
			? m.tier_authority_attested_en()
			: tier === 'community_corroborated'
				? m.tier_community_corroborated_en()
				: m.tier_self_asserted_en()
	)

	const taLabel = $derived(
		tier === 'authority_attested'
			? m.tier_authority_attested_ta()
			: tier === 'community_corroborated'
				? m.tier_community_corroborated_ta()
				: m.tier_self_asserted_ta()
	)
</script>

<span class="tier tier-{tierLevel}">
	<span lang="en">{enLabel}</span>
	<span aria-hidden="true">·</span>
	<span lang="ta">{taLabel}</span>
</span>
