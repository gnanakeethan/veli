<script lang="ts">
	interface Props {
		body: string
		to?: string
		from?: string
	}

	let { body, to = 'VELI', from: fromAddr = 'SMS · 1919' }: Props = $props()
</script>

<article class="sms">
	<header class="sms-h">
		<span>{fromAddr}</span>
		<span>{to}</span>
	</header>
	<pre class="sms-body">{body}</pre>
</article>
