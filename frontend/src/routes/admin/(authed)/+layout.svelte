<script lang="ts">
	import type { Snippet } from 'svelte';
	import * as m from '$lib/paraglide/messages';
	import { page } from '$app/stores';
	import LocaleSwitcher from '$lib/components/ui/LocaleSwitcher.svelte';
	import Icon from '$lib/components/ui/Icon.svelte';
	import Badge from '$lib/components/ui/Badge.svelte';
	import { cn } from '$lib/utils';
	import type { LayoutData } from './$types';

	let { data, children }: { data: LayoutData; children: Snippet } = $props();

	const navItems = [
		{ href: '/admin', icon: 'check' as const, ta: 'மேலோட்டம்', en: 'Dashboard' },
		{ href: '/admin/users', icon: 'doc' as const, ta: 'பயனர்கள்', en: 'Users' },
		{ href: '/admin/documents', icon: 'file' as const, ta: 'ஆவணங்கள்', en: 'Documents' }
	];

	function isActive(href: string, pathname: string): boolean {
		if (href === '/admin') return pathname === '/admin';
		return pathname === href || pathname.startsWith(href + '/');
	}

	const primaryRole = $derived(
		data.me.roles.find((r) => r.code === 'super_admin') ??
			data.me.roles.find((r) => r.code === 'manager') ??
			data.me.roles[0]
	);
</script>

<svelte:head>
	<title>{m.admin_login_title()}</title>
</svelte:head>

<div class="min-h-screen bg-paper-2 text-ink flex flex-col">
	<header
		class="border-b border-rule bg-paper px-6 py-3 flex items-center justify-between gap-4"
	>
		<div class="flex items-center gap-4">
			<a href="/admin" class="hero-mark text-xl">
				வெளி<span class="dot">.</span>
			</a>
			<span class="font-mono text-[11px] uppercase tracking-wider text-ink-3"
				>admin · நிர்வாகம்</span
			>
		</div>
		<div class="flex items-center gap-4">
			<div class="hidden sm:flex flex-col items-end leading-tight">
				<span class="text-[13.5px] text-ink">{data.me.user.display_name}</span>
				<span class="font-mono text-[11px] text-ink-3">{data.me.user.email ?? data.me.user.phone}</span>
			</div>
			{#if primaryRole}
				<Badge kind="accent">{primaryRole.code}</Badge>
			{/if}
			<LocaleSwitcher />
			<form method="POST" action="/admin/logout">
				<button
					type="submit"
					class="btn btn-ghost btn-sm"
					aria-label="Sign out"
				>
					<Icon name="wifi_off" size={16} />
					<span class="ml-1">வெளியேறு</span>
				</button>
			</form>
		</div>
	</header>

	<div class="flex flex-1">
		<aside
			class="hidden md:flex w-56 shrink-0 flex-col gap-1 border-r border-rule bg-paper px-3 py-6"
		>
			{#each navItems as item (item.href)}
				{@const active = isActive(item.href, $page.url.pathname)}
				<a
					href={item.href}
					class={cn(
						'flex items-center gap-3 rounded px-3 py-2 transition-colors',
						active
							? 'bg-primary/10 text-primary font-semibold'
							: 'text-ink-2 hover:bg-paper-3 hover:text-ink'
					)}
				>
					<Icon name={item.icon} size={18} />
					<div class="leading-tight">
						<div class="text-[14px]">{item.ta}</div>
						<div class="font-mono text-[10.5px] text-ink-3">{item.en}</div>
					</div>
				</a>
			{/each}
		</aside>

		<main class="flex-1 px-6 py-8 max-w-6xl mx-auto w-full">
			{@render children()}
		</main>
	</div>
</div>
