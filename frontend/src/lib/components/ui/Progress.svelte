<script lang="ts">
	interface Props {
		value: number
		label?: string
	}

	let { value, label }: Props = $props()

	// Clamp to 0–100
	let pct = $derived(Math.min(100, Math.max(0, value)))
</script>

{#if label}
	<div class="flex items-center justify-between mb-1 text-xs text-ink-3">
		<span>{label}</span>
		<span>{pct}%</span>
	</div>
{/if}
<div class="progress">
	<i style="width:{pct}%"></i>
</div>
