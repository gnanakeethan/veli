<script lang="ts">
	import { tv } from 'tailwind-variants';
	import { cn } from '$lib/utils';
	import type { Snippet } from 'svelte';

	interface Props {
		variant?: 'default' | 'secondary' | 'destructive';
		size?: 'sm' | 'md';
		class?: string;
		children?: Snippet;
	}

	const badge = tv({
		base: 'inline-flex items-center font-medium transition-colors',
		variants: {
			variant: {
				default: 'bg-primary text-primary-foreground',
				secondary: 'bg-secondary text-secondary-foreground',
				destructive: 'bg-destructive text-primary-foreground'
			},
			size: {
				sm: 'rounded-sm px-1.5 py-0.5 text-xs',
				md: 'rounded-md px-2 py-1 text-sm'
			}
		},
		defaultVariants: {
			variant: 'default',
			size: 'sm'
		}
	});

	let { variant = 'default', size = 'sm', class: className, children }: Props = $props();
</script>

<span class={cn(badge({ variant, size }), className)}>
	{@render children?.()}
</span>
