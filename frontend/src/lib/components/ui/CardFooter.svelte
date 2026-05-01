<script lang="ts">
	import type { Snippet } from 'svelte'
	import { cn } from '$lib/utils'

	interface Props {
		class?: string
		children?: Snippet
	}

	let { class: className, children }: Props = $props()
</script>

<footer class={cn('px-6 py-4 border-t border-rule', className)}>
	{@render children?.()}
</footer>
