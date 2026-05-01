<script lang="ts">
	import Icon from './Icon.svelte'

	interface Props {
		title: string
		body: string
		cite?: string
		markIcon?: string
	}

	let { title, body, cite, markIcon = 'shield-check' }: Props = $props()
</script>

<aside class="trust">
	<div class="trust-mark"><Icon name={markIcon} size={18} /></div>
	<div class="trust-body">
		<div class="trust-title">{title}</div>
		<div class="trust-text">{body}</div>
		{#if cite}<div class="trust-cite">↳ {cite}</div>{/if}
	</div>
</aside>
