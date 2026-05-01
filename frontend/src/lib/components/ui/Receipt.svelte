<script lang="ts">
	interface Row {
		label: string
		value: string
	}

	interface Props {
		rows: Row[]
		num?: string
		header?: string
		date?: string
	}

	let {
		rows,
		num,
		header = 'VELI · ரசீது',
		date = new Date().toISOString().slice(0, 10).replace(/-/g, '·')
	}: Props = $props()
</script>

<div class="receipt">
	<div class="receipt-h">
		<span>{header}</span>
		<span>{date}</span>
	</div>
	{#each rows as row}
		<div class="receipt-row">
			<span class="lbl">{row.label}</span>
			<span>{row.value}</span>
		</div>
	{/each}
	{#if num}<div class="receipt-num">{num}</div>{/if}
</div>
