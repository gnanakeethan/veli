<script lang="ts">
	import type { Snippet } from 'svelte'
	import Icon from './Icon.svelte'

	interface Props {
		icon?: string
		title: string
		meta?: string
		en?: string
		bilingual?: boolean
		trail?: Snippet
		href?: string
	}

	let { icon, title, meta, en, bilingual = false, trail, href }: Props = $props()
</script>

{#if href}
	<a {href} class="lrow lrow-clickable">
		{#if icon}
			<div class="lrow-lead"><Icon name={icon} size={20} /></div>
		{/if}
		<div class="lrow-body">
			<div class="lrow-title">{title}</div>
			{#if meta}<div class="lrow-meta">{meta}</div>{/if}
			{#if bilingual && en}<div class="lrow-en">{en}</div>{/if}
		</div>
		{#if trail}
			<div class="lrow-trail">{@render trail()}</div>
		{/if}
	</a>
{:else}
	<div class="lrow">
		{#if icon}
			<div class="lrow-lead"><Icon name={icon} size={20} /></div>
		{/if}
		<div class="lrow-body">
			<div class="lrow-title">{title}</div>
			{#if meta}<div class="lrow-meta">{meta}</div>{/if}
			{#if bilingual && en}<div class="lrow-en">{en}</div>{/if}
		</div>
		{#if trail}
			<div class="lrow-trail">{@render trail()}</div>
		{/if}
	</div>
{/if}
