<script lang="ts">
	import type { Snippet } from 'svelte'
	import Icon from './Icon.svelte'

	interface Props {
		title: string
		tab?: number
		status?: string
		tabIcons?: string[]
		tabLabels?: string[]
		children: Snippet
	}

	let {
		title,
		tab = 0,
		status = '09:42',
		tabIcons = ['home', 'file', 'map-pin', 'user'],
		tabLabels = ['முகப்பு', 'ஆவணம்', 'அலுவலகம்', 'நான்'],
		children
	}: Props = $props()
</script>

<div class="phone">
	<div class="phone-status">
		<span>{status}</span>
		<span style="display:flex;gap:6px"><span>4G</span><span>87%</span></span>
	</div>
	<div class="phone-app">
		<div class="phone-appbar">
			<Icon name="chevron-left" size={20} />
			<div class="phone-appbar-title">{title}</div>
			<Icon name="search" size={20} />
		</div>
		<div class="phone-screen">
			<div class="phone-content">
				{@render children()}
			</div>
		</div>
		<div class="phone-tabbar">
			{#each tabIcons as iconName, i}
				<div class="phone-tab" class:active={tab === i}>
					<Icon name={iconName} size={20} />
					<span>{tabLabels[i]}</span>
				</div>
			{/each}
		</div>
	</div>
</div>
