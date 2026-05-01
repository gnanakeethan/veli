<script lang="ts">
	import { tv } from 'tailwind-variants';
	import { cn } from '$lib/utils';
	import type { Snippet } from 'svelte';

	export interface ButtonProps {
		variant?: 'primary' | 'secondary' | 'ghost' | 'destructive';
		size?: 'sm' | 'md' | 'lg';
		disabled?: boolean;
		class?: string;
		onclick?: (event: MouseEvent) => void;
		children?: Snippet;
		type?: 'button' | 'submit' | 'reset';
		'aria-label'?: string;
	}

	const button = tv({
		base: [
			'inline-flex items-center justify-center gap-2',
			'rounded-md font-medium transition-colors',
			'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
			'disabled:pointer-events-none disabled:opacity-50'
		],
		variants: {
			variant: {
				primary: 'bg-primary text-primary-foreground hover:bg-primary/90',
				secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
				ghost: 'hover:bg-accent hover:text-accent-foreground',
				destructive: 'bg-destructive text-primary-foreground hover:bg-destructive/90'
			},
			size: {
				sm: 'h-9 px-3 text-xs',
				md: 'h-11 min-h-[44px] px-4 text-sm',
				lg: 'h-12 px-6 text-base'
			}
		},
		defaultVariants: {
			variant: 'primary',
			size: 'md'
		}
	});

	let {
		variant = 'primary',
		size = 'md',
		disabled = false,
		class: className,
		onclick,
		children,
		type = 'button',
		'aria-label': ariaLabel
	}: ButtonProps = $props();
</script>

<button
	{type}
	{disabled}
	{onclick}
	aria-label={ariaLabel}
	class={cn(button({ variant, size }), className)}
>
	{@render children?.()}
</button>
