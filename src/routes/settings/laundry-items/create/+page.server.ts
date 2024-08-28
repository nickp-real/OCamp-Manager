import { laundryItemSchema } from "$lib/client/form/laundry-item-form";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async () => {
	const form = await superValidate(zod(laundryItemSchema));

	return { form };
};
