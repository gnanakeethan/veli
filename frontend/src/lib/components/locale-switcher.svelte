<script lang="ts">
	import { getLocale, setLocale, locales } from '$lib/paraglide/runtime';

	const labels: Record<string, string> = {
		ta: 'தமிழ்',
		en: 'English',
		si: 'සිංහල'
	};

	let currentLocale = $derived(getLocale());
</script>

<nav aria-label="Language selector" class="flex gap-1">
	{#each locales as locale (locale)}
		<button
			type="button"
			onclick={() => setLocale(locale)}
			aria-pressed={currentLocale === locale}
			class="rounded px-2.5 py-1.5 text-xs font-medium transition-colors"
			class:bg-primary={currentLocale === locale}
			class:text-primary-foreground={currentLocale === locale}
			class:bg-secondary={currentLocale !== locale}
			class:text-secondary-foreground={currentLocale !== locale}
		>
			{labels[locale] ?? locale}
		</button>
	{/each}
</nav>
