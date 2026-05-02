<script lang="ts">
	import { cn } from '$lib/utils'

	interface Props {
		lines?: number
		width?: string
		height?: string
		class?: string
	}

	let { lines, width = '100%', height = '12px', class: className }: Props = $props()

	// Widths cycle to give a natural-looking variation across skeleton lines.
	const lineWidths = [80, 60, 90, 70, 85]
</script>

{#if lines !== undefined}
	<div style="display:flex;flex-direction:column;gap:8px;width:100%">
		{#each { length: lines } as _, i}
			<div class="skel line" style="width:{lineWidths[i % lineWidths.length]}%"></div>
		{/each}
	</div>
{:else}
	<div class={cn('skel', className)} style="width:{width};height:{height}"></div>
{/if}
