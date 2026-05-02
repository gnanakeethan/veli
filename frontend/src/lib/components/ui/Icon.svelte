<script lang="ts">
	import { cn } from '$lib/utils';

	interface Props {
		name: string;
		size?: number;
		filled?: boolean;
		class?: string;
	}

	let { name, size = 22, filled = false, class: className }: Props = $props();

	// Icons are rendered inline as static SVG paths rather than via
	// @lucide/svelte. The lucide-svelte Icon component uses
	// `<svelte:element this={tag} {...attrs}>` inside an {#each} block,
	// which fails to hydrate correctly under Svelte 5.55 + lucide
	// 1.14 (TypeError: "Cannot read properties of undefined (reading
	// 'call')" during effect destruction). Rendering paths inline
	// keeps the SVG tree static for hydration.
	//
	// Source: lucide.dev/icons/<name> — keep paths in sync with that
	// reference (24×24 viewBox, stroke-width 2 source, rendered at
	// 1.6 here for visual weight). Add new icons by appending an
	// {:else if} branch.

	// Some keys are aliases used in older code paths; keep them.
	const canonicalName = $derived.by(() => {
		switch (name) {
			case 'doc':
			case 'file':
				return 'file';
			case 'pin':
			case 'map-pin':
				return 'map-pin';
			case 'seed':
				return 'sprout';
			case 'cam':
				return 'camera';
			case 'chip':
				return 'cpu';
			case 'wifi_off':
			case 'wifi-off':
				return 'wifi-off';
			case 'cart':
				return 'shopping-cart';
			case 'chev':
			case 'chevron-right':
				return 'chevron-right';
			default:
				return name;
		}
	});

	const cls = $derived(cn('inline-block align-middle shrink-0', className));
</script>

<svg
	xmlns="http://www.w3.org/2000/svg"
	width={size}
	height={size}
	viewBox="0 0 24 24"
	fill={filled ? 'currentColor' : 'none'}
	stroke="currentColor"
	stroke-width="1.6"
	stroke-linecap="round"
	stroke-linejoin="round"
	aria-hidden="true"
	class={cls}
>
	{#if canonicalName === 'check'}
		<path d="M20 6 9 17l-5-5" />
	{:else if canonicalName === 'home'}
		<path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8" />
		<path
			d="M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"
		/>
	{:else if canonicalName === 'search'}
		<path d="m21 21-4.34-4.34" />
		<circle cx="11" cy="11" r="8" />
	{:else if canonicalName === 'file'}
		<path
			d="M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z"
		/>
		<path d="M14 2v5a1 1 0 0 0 1 1h5" />
	{:else if canonicalName === 'map-pin'}
		<path
			d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"
		/>
		<circle cx="12" cy="10" r="3" />
	{:else if canonicalName === 'sprout'}
		<path
			d="M14 9.536V7a4 4 0 0 1 4-4h1.5a.5.5 0 0 1 .5.5V5a4 4 0 0 1-4 4 4 4 0 0 0-4 4c0 2 1 3 1 5a5 5 0 0 1-1 3"
		/>
		<path d="M4 9a5 5 0 0 1 8 4 5 5 0 0 1-8-4" />
		<path d="M5 21h14" />
	{:else if canonicalName === 'camera'}
		<path
			d="M13.997 4a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 1.759-1.048l.489-.904A2 2 0 0 1 10.004 4z"
		/>
		<circle cx="12" cy="13" r="3" />
	{:else if canonicalName === 'shield'}
		<path
			d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"
		/>
	{:else if canonicalName === 'shield-check'}
		<path
			d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"
		/>
		<path d="m9 12 2 2 4-4" />
	{:else if canonicalName === 'bell'}
		<path d="M10.268 21a2 2 0 0 0 3.464 0" />
		<path
			d="M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326"
		/>
	{:else if canonicalName === 'user'}
		<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
		<circle cx="12" cy="7" r="4" />
	{:else if canonicalName === 'map'}
		<path
			d="M14.106 5.553a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619v12.764a1 1 0 0 1-.553.894l-4.553 2.277a2 2 0 0 1-1.788 0l-4.212-2.106a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0z"
		/>
		<path d="M15 5.764v15" />
		<path d="M9 3.236v15" />
	{:else if canonicalName === 'leaf'}
		<path
			d="M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z"
		/>
		<path d="M2 21c0-3 1.85-5.36 5.08-6C9.5 14.52 12 13 13 12" />
	{:else if canonicalName === 'cpu'}
		<path d="M12 20v2" />
		<path d="M12 2v2" />
		<path d="M17 20v2" />
		<path d="M17 2v2" />
		<path d="M2 12h2" />
		<path d="M2 17h2" />
		<path d="M2 7h2" />
		<path d="M20 12h2" />
		<path d="M20 17h2" />
		<path d="M20 7h2" />
		<path d="M7 20v2" />
		<path d="M7 2v2" />
		<rect x="4" y="4" width="16" height="16" rx="2" />
		<rect x="8" y="8" width="8" height="8" rx="1" />
	{:else if canonicalName === 'eye'}
		<path
			d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"
		/>
		<circle cx="12" cy="12" r="3" />
	{:else if canonicalName === 'download'}
		<path d="M12 15V3" />
		<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
		<path d="m7 10 5 5 5-5" />
	{:else if canonicalName === 'wifi-off'}
		<path d="M12 20h.01" />
		<path d="M8.5 16.429a5 5 0 0 1 7 0" />
		<path d="M5 12.859a10 10 0 0 1 5.17-2.69" />
		<path d="M19 12.859a10 10 0 0 0-2.007-1.523" />
		<path d="M2 8.82a15 15 0 0 1 4.177-2.643" />
		<path d="M22 8.82a15 15 0 0 0-11.288-3.764" />
		<path d="m2 2 20 20" />
	{:else if canonicalName === 'shopping-cart'}
		<circle cx="8" cy="21" r="1" />
		<circle cx="19" cy="21" r="1" />
		<path
			d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"
		/>
	{:else if canonicalName === 'sun'}
		<circle cx="12" cy="12" r="4" />
		<path d="M12 2v2" />
		<path d="M12 20v2" />
		<path d="m4.93 4.93 1.41 1.41" />
		<path d="m17.66 17.66 1.41 1.41" />
		<path d="M2 12h2" />
		<path d="M20 12h2" />
		<path d="m6.34 17.66-1.41 1.41" />
		<path d="m19.07 4.93-1.41 1.41" />
	{:else if canonicalName === 'fish'}
		<path
			d="M6.5 12c.94-3.46 4.94-6 8.5-6 3.56 0 6.06 2.54 7 6-.94 3.47-3.44 6-7 6s-7.56-2.53-8.5-6Z"
		/>
		<path d="M18 12v.5" />
		<path d="M16 17.93a9.77 9.77 0 0 1 0-11.86" />
		<path
			d="M7 10.67C7 8 5.58 5.97 2.73 5.5c-1 1.5-1 5 .23 6.5-1.24 1.5-1.24 5-.23 6.5C5.58 18.03 7 16 7 13.33"
		/>
		<path d="M10.46 7.26C10.2 5.88 9.17 4.24 8 3h5.8a2 2 0 0 1 1.98 1.67l.23 1.4" />
		<path
			d="m16.01 17.93-.23 1.4A2 2 0 0 1 13.8 21H9.5a5.96 5.96 0 0 0 1.49-3.98"
		/>
	{:else if canonicalName === 'chevron-right'}
		<path d="m9 18 6-6-6-6" />
	{:else if canonicalName === 'chevron-left'}
		<path d="m15 18-6-6 6-6" />
	{:else if canonicalName === 'phone'}
		<path
			d="M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384"
		/>
	{:else if canonicalName === 'id-card'}
		<path d="M16 10h2" />
		<path d="M16 14h2" />
		<path d="M6.17 15a3 3 0 0 1 5.66 0" />
		<circle cx="9" cy="11" r="2" />
		<rect x="2" y="5" width="20" height="14" rx="2" />
	{:else}
		<!-- placeholder for unmapped icon names -->
		<rect x="3" y="3" width="18" height="18" rx="2" />
	{/if}
</svg>
