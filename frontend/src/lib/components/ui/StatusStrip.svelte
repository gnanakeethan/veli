<script lang="ts">
	import { cn } from '$lib/utils'
	import * as m from '$lib/paraglide/messages'
	import Badge from './Badge.svelte'
	import type { HelloResponse } from '$lib/api'

	interface Props {
		reachable: boolean
		hello?: HelloResponse
		error?: string
	}

	let { reachable, hello, error }: Props = $props()
</script>

<div
	class={cn(
		'border-t border-rule px-6 py-3 text-xs',
		reachable ? 'bg-paper-2 text-ink-3' : 'bg-alert-soft text-alert-ink'
	)}
>
	<span class="font-medium">{m.system_status()}:</span>
	{#if reachable}
		<span class="ml-1">{m.backend_reachable()}</span>
		{#if hello}
			<span class="ml-2">
				<Badge kind="accent">{m.phase_label({ phase: hello.phase })}</Badge>
			</span>
		{/if}
	{:else}
		<span class="ml-1">{m.backend_unreachable()}</span>
		{#if error}
			<span class="ml-2 opacity-75">({error})</span>
		{/if}
	{/if}
</div>
