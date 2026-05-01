<script lang="ts">
	import { getLocale, setLocale, locales } from '$lib/paraglide/runtime'

	const labels: Record<string, string> = {
		ta: 'தமிழ்',
		en: 'English',
		si: 'සිංහල'
	}

	let currentLocale = $derived(getLocale())
</script>

<nav class="seg" aria-label="Language selector">
	{#each locales as locale (locale)}
		<button aria-pressed={currentLocale === locale} onclick={() => setLocale(locale)}>
			{labels[locale] ?? locale}
		</button>
	{/each}
</nav>
