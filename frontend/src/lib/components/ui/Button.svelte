<script lang="ts">
	import type { Snippet } from 'svelte'
	import { cn } from '$lib/utils'

	export interface ButtonProps {
		kind?: 'primary' | 'secondary' | 'ghost' | 'alert'
		size?: 'sm' | 'md' | 'lg'
		block?: boolean
		disabled?: boolean
		type?: 'button' | 'submit'
		class?: string
		onclick?: (event: MouseEvent) => void
		children?: Snippet
		'aria-label'?: string
	}

	let {
		kind = 'primary',
		size = 'md',
		block = false,
		disabled = false,
		type = 'button',
		class: className,
		onclick,
		children,
		'aria-label': ariaLabel
	}: ButtonProps = $props()

	let cls = $derived(
		cn(
			'btn',
			`btn-${kind}`,
			size === 'lg' ? 'btn-lg' : size === 'sm' ? 'btn-sm' : '',
			block ? 'btn-block' : '',
			className
		)
	)
</script>

<button class={cls} {disabled} {type} {onclick} aria-label={ariaLabel}>
	{@render children?.()}
</button>
