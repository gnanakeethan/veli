<script lang="ts">
	type TimelineDotState = 'done' | 'active' | 'fail' | 'pending'

	interface Props {
		time: string
		state: TimelineDotState
		title: string
		desc?: string
	}

	let { time, state, title, desc }: Props = $props()

	// 'pending' maps to the default ring (no extra class); others map 1:1.
	const stateClass = $derived(state === 'pending' ? '' : state)
</script>

<li class="tl-row">
	<div class="tl-time">{time}</div>
	<div class="tl-axis">
		<div class="tl-dot {stateClass}"></div>
	</div>
	<div class="tl-body">
		<strong>{title}</strong>
		{#if desc}
			<div class="tl-desc">{desc}</div>
		{/if}
	</div>
</li>
