// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
	namespace App {
		interface Locals {
			user: { id: string; phone: string; displayName: string; locale: 'ta' | 'en' | 'si' } | null;
		}
	}
}

export {};
