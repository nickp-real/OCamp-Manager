import { message, superValidate } from "sveltekit-superforms";
import type { PageServerLoadEvent, Actions } from "./$types";
import { zod } from "sveltekit-superforms/adapters";
import { campFormSchema, type CampFormBody } from "$lib/client/form/camp-form";
import { fail } from "@sveltejs/kit";
import { updateCampById } from "@controllers/camp-controller";
import { getAllMajors } from "@controllers/major-controller";

export async function load({ parent }: PageServerLoadEvent) {
	const { camp } = await parent();
	const formatedCamp: CampFormBody = {
		...camp,
		hasLaundry: camp.hasLaundry,
		laundryPrice: camp.laundryPrice ? parseFloat(camp.laundryPrice) : undefined,
		campMajors: camp.campMajor.map(({ majorId }) => ({ majorId }))
	};

	const form = await superValidate(formatedCamp, zod(campFormSchema));
	const majors = getAllMajors();

	return { form, majors };
}

export const actions: Actions = {
	default: async ({ request, params }) => {
		if (!params.id) return fail(400, { message: "Invalid ID" });
		const form = await superValidate(request, zod(campFormSchema));

		if (!form.valid) return fail(400, { form });

		const body = { ...form.data, laundryPrice: parseFloat(form.data.laundryPrice) };

		await updateCampById(params.id!, body);
		console.log("Update camp success");

		return message(form, "Update camp success");
	}
};
