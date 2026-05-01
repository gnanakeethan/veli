<script lang="ts">
	import type { Snippet } from 'svelte'
	import { cn } from '$lib/utils'

	interface Props {
		class?: string
		children?: Snippet
	}

	let { class: className, children }: Props = $props()
</script>

<article class={cn('card', className)}>
	{@render children?.()}
</article>
