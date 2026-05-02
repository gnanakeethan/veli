<script lang="ts">
	import type { Snippet } from 'svelte'
	import Icon from './Icon.svelte'

	interface Props {
		title: string
		signal?: string
		iconName?: string
		children: Snippet
	}

	let {
		title,
		signal = 'SIGNAL · ░░░░ NONE',
		iconName = 'wifi-off',
		children
	}: Props = $props()
</script>

<div class="sync">
	<div class="sync-h">
		<div class="sync-h-l">
			<Icon name={iconName} size={18} />
			<span>{title}</span>
		</div>
		<div style="font-family:var(--f-mono);font-size:11px;color:var(--ink-3)">{signal}</div>
	</div>
	{@render children()}
</div>
