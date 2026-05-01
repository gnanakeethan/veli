<script lang="ts">
	import type { Snippet } from 'svelte'
	import { cn } from '$lib/utils'

	interface Props {
		class?: string
		title?: string
		children?: Snippet
	}

	let { class: className, title, children }: Props = $props()
</script>

<header class={cn('px-6 py-4 border-b border-rule', className)}>
	{#if title}
		<h2 class="text-lg font-semibold text-primary">{title}</h2>
	{/if}
	{@render children?.()}
</header>
