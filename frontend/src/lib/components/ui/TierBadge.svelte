<script lang="ts">
	import { cn } from '$lib/utils';
	import * as m from '$lib/paraglide/messages';
	import type { VerificationTier } from '$lib/api';

	interface Props {
		tier: VerificationTier;
		class?: string;
	}

	let { tier, class: className }: Props = $props();

	const tierConfig = $derived(() => {
		switch (tier) {
			case 'self_asserted':
				return {
					classes: 'bg-muted text-muted-foreground',
					en: m.tier_self_asserted_en(),
					ta: m.tier_self_asserted_ta()
				};
			case 'community_corroborated':
				return {
					classes: 'bg-secondary text-secondary-foreground',
					en: m.tier_community_corroborated_en(),
					ta: m.tier_community_corroborated_ta()
				};
			case 'authority_attested':
				return {
					classes: 'bg-primary text-primary-foreground',
					en: m.tier_authority_attested_en(),
					ta: m.tier_authority_attested_ta()
				};
		}
	});
</script>

<span
	class={cn(
		'inline-flex items-center gap-1 rounded-sm px-2 py-0.5 text-xs font-medium',
		tierConfig().classes,
		className
	)}
>
	<span lang="ta">{tierConfig().ta}</span>
	<span aria-hidden="true">·</span>
	<span lang="en">{tierConfig().en}</span>
</span>
