<script lang="ts">
	interface Option {
		value: string
		label: string
	}

	interface Props {
		options: Option[]
		value: string
		onchange: (v: string) => void
		ariaLabel?: string
	}

	let { options, value, onchange, ariaLabel = 'Segmented control' }: Props = $props()
</script>

<nav class="seg" aria-label={ariaLabel}>
	{#each options as opt (opt.value)}
		<button
			aria-pressed={value === opt.value}
			onclick={() => onchange(opt.value)}
		>
			{opt.label}
		</button>
	{/each}
</nav>
