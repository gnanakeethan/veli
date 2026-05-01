<script lang="ts">
	import { cn } from '$lib/utils'
	import Home from '@lucide/svelte/icons/home'
	import Search from '@lucide/svelte/icons/search'
	import FileIcon from '@lucide/svelte/icons/file'
	import MapPin from '@lucide/svelte/icons/map-pin'
	import Sprout from '@lucide/svelte/icons/sprout'
	import Camera from '@lucide/svelte/icons/camera'
	import Shield from '@lucide/svelte/icons/shield'
	import Bell from '@lucide/svelte/icons/bell'
	import User from '@lucide/svelte/icons/user'
	import MapIcon from '@lucide/svelte/icons/map'
	import Leaf from '@lucide/svelte/icons/leaf'
	import Cpu from '@lucide/svelte/icons/cpu'
	import Eye from '@lucide/svelte/icons/eye'
	import Download from '@lucide/svelte/icons/download'
	import WifiOff from '@lucide/svelte/icons/wifi-off'
	import ShoppingCart from '@lucide/svelte/icons/shopping-cart'
	import Sun from '@lucide/svelte/icons/sun'
	import Fish from '@lucide/svelte/icons/fish'
	import ChevronRight from '@lucide/svelte/icons/chevron-right'
	import Check from '@lucide/svelte/icons/check'
	import Phone from '@lucide/svelte/icons/phone'
	import IdCard from '@lucide/svelte/icons/id-card'

	interface Props {
		name: string
		size?: number
		filled?: boolean
		class?: string
	}

	let { name, size = 22, filled = false, class: className }: Props = $props()

	const iconMap: Record<string, unknown> = {
		home: Home,
		search: Search,
		doc: FileIcon,
		pin: MapPin,
		seed: Sprout,
		cam: Camera,
		shield: Shield,
		bell: Bell,
		user: User,
		map: MapIcon,
		leaf: Leaf,
		chip: Cpu,
		eye: Eye,
		download: Download,
		'wifi-off': WifiOff,
		wifi_off: WifiOff,
		cart: ShoppingCart,
		sun: Sun,
		fish: Fish,
		chev: ChevronRight,
		check: Check,
		phone: Phone,
		'id-card': IdCard
	}

	// The component to render — falls back to undefined if name not in map.
	// We use a type assertion because Svelte typed component constructors
	// don't have a common base type we can easily express here.
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	const IconComponent = $derived((iconMap[name] ?? null) as any)
</script>

{#if IconComponent}
	<IconComponent
		width={size}
		height={size}
		stroke-width={1.6}
		class={cn('inline-block align-middle shrink-0', className)}
		fill={filled ? 'currentColor' : 'none'}
	/>
{:else}
	<!-- placeholder for unmapped icon names -->
	<svg
		width={size}
		height={size}
		viewBox="0 0 24 24"
		fill="none"
		stroke="currentColor"
		stroke-width="1.6"
		class={cn('inline-block align-middle shrink-0', className)}
	>
		<rect x="3" y="3" width="18" height="18" rx="2" />
	</svg>
{/if}
