<script lang="ts">
	interface StepDef {
		ta: string
		en?: string
	}

	interface Props {
		steps: StepDef[]
		active: number
		ariaLabel: string
	}

	let { steps, active, ariaLabel }: Props = $props()
</script>

<nav class="steps" aria-label={ariaLabel}>
	{#each steps as step, i}
		{#if i > 0}
			<div class="step-line"></div>
		{/if}
		<div class="step" class:done={i < active} class:active={i === active}>
			<div class="step-mark">{i < active ? '✓' : i + 1}</div>
			<div>
				<div class="step-label">{step.ta}</div>
				{#if step.en}
					<div style="font-family:var(--f-mono);font-size:10.5px;color:var(--ink-mute);margin-top:2px">{step.en}</div>
				{/if}
			</div>
		</div>
	{/each}
</nav>
