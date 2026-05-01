<script lang="ts">
	import { getLocale, setLocale, locales } from '$lib/paraglide/runtime';
	import Button from './Button.svelte';

	const labels: Record<string, string> = {
		ta: 'தமிழ்',
		en: 'English',
		si: 'සිංහල'
	};

	let currentLocale = $derived(getLocale());
</script>

<nav aria-label="Language selector" class="flex gap-1">
	{#each locales as locale (locale)}
		<Button
			variant={currentLocale === locale ? 'primary' : 'secondary'}
			size="sm"
			onclick={() => setLocale(locale)}
			aria-label={labels[locale] ?? locale}
		>
			{labels[locale] ?? locale}
		</Button>
	{/each}
</nav>
