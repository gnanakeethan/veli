<script lang="ts">
	import type { Snippet } from 'svelte'

	interface Props {
		label: string
		hint?: string
		error?: string
		required?: boolean
		htmlFor?: string
		children?: Snippet
	}

	let { label, hint, error, required = false, htmlFor, children }: Props = $props()
</script>

<div class="field">
	<label class="field-label" for={htmlFor}>
		{label}{#if required}<span class="req">*</span>{/if}
	</label>
	{@render children?.()}
	{#if error}
		<span class="field-error">{error}</span>
	{:else if hint}
		<span class="field-help">{hint}</span>
	{/if}
</div>
