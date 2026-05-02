<script lang="ts">
	type SyncRowState = 'q' | 'r' | 'k' | 'e'

	interface Props {
		state: SyncRowState
		name: string
		meta: string
	}

	let { state, name, meta }: Props = $props()

	const glyphs: Record<SyncRowState, string> = {
		k: '✓',
		r: '↻',
		q: '…',
		e: '!'
	}

	const glyph = $derived(glyphs[state])
</script>

<div class="sync-row">
	<div class="sync-mark {state}">{glyph}</div>
	<div class="sync-name">{name}</div>
	<div class="sync-meta">{meta}</div>
</div>
