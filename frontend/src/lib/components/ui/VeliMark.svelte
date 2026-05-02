<script lang="ts">
	import { onMount } from 'svelte'

	let played = $state(false)

	onMount(() => {
		const id = window.setTimeout(() => {
			played = true
		}, 450)
		return () => window.clearTimeout(id)
	})
</script>

<span class="veli-mark" class:played aria-label="Veli">
	<span class="ch v">V</span>
	<span class="ch e">e</span>
	<span class="ch l">l</span>
	<span class="ch i">i</span>
</span>

<style>
	.veli-mark {
		display: inline-flex;
		font-family: var(--f-mono);
		font-size: clamp(72px, 12vw, 168px);
		font-weight: 800;
		line-height: 0.85;
		letter-spacing: 0.02em;
		color: var(--ink-3);
		user-select: none;
	}
	.ch {
		display: inline-block;
		width: 0.85em;
		text-align: center;
		will-change: transform;
	}
	/* Pre-play: l and i swapped → reads "Veil". */
	.l { transform: translate(0.85em, 0); }
	.i { transform: translate(-0.85em, 0); }
	.veli-mark.played .l {
		animation: l-cross var(--dur-ceremony) var(--ease-standard) forwards;
	}
	.veli-mark.played .i {
		animation: i-cross var(--dur-ceremony) var(--ease-standard) forwards;
	}
	.veli-mark.played { color: var(--ink); }
	.veli-mark { transition: color var(--dur-ceremony) var(--ease-standard); }

	/* l drops under, i lifts over — they cross paths. */
	@keyframes l-cross {
		0%   { transform: translate(0.85em, 0); }
		50%  { transform: translate(0.425em, 0.32em); }
		100% { transform: translate(0, 0); }
	}
	@keyframes i-cross {
		0%   { transform: translate(-0.85em, 0); }
		50%  { transform: translate(-0.425em, -0.32em); }
		100% { transform: translate(0, 0); }
	}
</style>
