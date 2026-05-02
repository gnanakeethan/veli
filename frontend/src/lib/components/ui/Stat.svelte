<script lang="ts">
	interface Props {
		value: string | number
		unit?: string
		label: string
		en?: string
	}

	let { value, unit, label, en }: Props = $props()
</script>

<div class="stat">
	<dd class="stat-num">
		{value}{#if unit}<span class="unit">{unit}</span>{/if}
	</dd>
	<dt class="stat-label">{label}</dt>
	{#if en}
		<dt class="stat-en">{en}</dt>
	{/if}
</div>
