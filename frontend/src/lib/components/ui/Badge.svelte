<script lang="ts">
	import type { Snippet } from 'svelte'

	interface Props {
		kind?: 'primary' | 'accent' | 'alert' | 'info' | 'mute'
		dot?: boolean
		children?: Snippet
	}

	let { kind = 'primary', dot = false, children }: Props = $props()
</script>

<span class="badge badge-{kind}">
	{#if dot}<i class="dot"></i>{/if}
	{@render children?.()}
</span>
