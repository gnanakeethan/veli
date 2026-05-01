<script lang="ts">
	import { cn } from '$lib/utils';
	import type { Snippet } from 'svelte';

	interface Props {
		class?: string;
		title?: string;
		children?: Snippet;
	}

	let { class: className, title, children }: Props = $props();
</script>

<div class={cn('border-b px-6 py-4', className)}>
	{#if title}
		<h2 class="text-lg font-semibold text-primary">{title}</h2>
	{/if}
	{@render children?.()}
</div>
