<script lang="ts">
	import type { Snippet } from 'svelte'
	import Icon from './Icon.svelte'

	type StateKind = 'empty' | 'loading' | 'error'

	interface Props {
		kind: StateKind
		title: string
		body?: string
		icon?: string
		children?: Snippet
	}

	let { kind, title, body, icon, children }: Props = $props()

	const defaultIcon: Record<StateKind, string> = {
		empty: 'file',
		loading: 'download',
		error: 'wifi-off'
	}

	const resolvedIcon = $derived(icon ?? defaultIcon[kind])
</script>

<div class="state-card">
	<div class="state-mark {kind}">
		<Icon name={resolvedIcon} size={22} />
	</div>
	<div class="state-title">{title}</div>
	{#if body}
		<div class="state-body">{body}</div>
	{/if}
	{#if children}
		<div class="state-footer">{@render children()}</div>
	{/if}
</div>
