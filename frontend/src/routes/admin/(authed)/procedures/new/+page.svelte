<script lang="ts">
	import * as m from '$lib/paraglide/messages';
	import Card from '$lib/components/ui/Card.svelte';
	import CardContent from '$lib/components/ui/CardContent.svelte';
	import ProcedureForm from '$lib/components/admin/ProcedureForm.svelte';
	import type { ActionData } from './$types';

	let { form }: { form: ActionData } = $props();
</script>

<div class="flex flex-col gap-6 max-w-3xl">
	<header>
		<a
			href="/admin/procedures"
			class="font-mono text-[12px] text-ink-3 hover:text-ink"
		>
			{m.admin_procedures_back()}
		</a>
		<div class="font-mono text-xs uppercase tracking-wider text-ink-3 mt-2">
			ADMIN · {m.admin_procedures_list_subtitle()}
		</div>
		<h1 class="text-[26px] font-bold mt-1">{m.admin_procedures_create_title()}</h1>
	</header>

	<Card>
		<CardContent>
			<ProcedureForm values={form?.values} error={form?.error ?? null} />
		</CardContent>
	</Card>
</div>
