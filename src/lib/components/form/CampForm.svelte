<script lang="ts">
	import { superForm, type Infer, type SuperValidated } from "sveltekit-superforms";
	import { campFormSchema, type CampFormSchema } from "$lib/client/form/camp-form";
	import * as Form from "$lib/components/form-ui";
	import { type Major } from "@db/schema/major";
	import { zodClient } from "sveltekit-superforms/adapters";
	import type { FormMode } from "./type";
	import { goto } from "$app/navigation";
	import Chip from "../ui/Chip.svelte";
	import { XCircleIcon } from "lucide-svelte";
	import { toastSuccess } from "../toast/toast";

	export let mode: FormMode = "create";
	export let formData: SuperValidated<Infer<CampFormSchema>>;
	export let majors: Promise<Major[]>;

	const form = superForm(formData, {
		validators: zodClient(campFormSchema),
		dataType: "json",
		resetForm: false,
		onResult: async ({ result }) => {
			if (result.type === "success") {
				toastSuccess(`${mode} camp successful.`);
				if (mode === "create") await goto("/camps");
			}
		}
	});

	const { form: formFieldData, enhance } = form;

	function addMajor(major: CustomEvent<Major>) {
		if ($formFieldData.campMajors.some((formMajor) => formMajor.majorId === major.detail.id))
			return;
		$formFieldData.campMajors = [...$formFieldData.campMajors, { majorId: major.detail.id }];
	}

	function removeMajor(major: Infer<CampFormSchema>["campMajors"][number]) {
		$formFieldData.campMajors = $formFieldData.campMajors.filter(
			(campMajor) => campMajor.majorId !== major.majorId
		);
	}
</script>

<form method="post" use:enhance class="space-y-4">
	<Form.Title>
		{#if mode === "create"}
			Create camp
		{:else}
			Update camp
		{/if}
	</Form.Title>

	<Form.Input id="name" name="name" label="Camp name" {form} />

	<Form.DateInput id="start-date" name="fromDate" label="Start date" {form} />
	<Form.DateInput id="end-date" name="toDate" label="End date" {form} />

	<Form.TextArea id="description" name="description" label="Description" {form} />

	<section class="space-y-4">
		<Form.Checkbox name="hasLaundry" label="Has laundry" {form} />

		{#if $formFieldData.hasLaundry}
			<div class="flex flex-col gap-2">
				<Form.Input
					id="laundry-price"
					name="laundryPrice"
					label="Laundry price (THB)"
					{form}
					disabled={!$formFieldData.hasLaundry}
				/>
			</div>
		{/if}
	</section>

	<Form.Div>
		<Form.Label for="camp-majors">Camp majors</Form.Label>
		{#await majors}
			<Form.Skeleton />
		{:then majors}
			{#if majors.length === 0}
				<div>No majors, please add a major by settings page</div>
			{:else}
				<Form.Combobox
					id="camp-majors"
					items={majors.map((major) => ({ label: major.name, value: major }))}
					on:itemselect={addMajor}
				/>

				<div class="flex gap-2">
					{#each $formFieldData.campMajors as major}
						{@const majorName = majors.find(({ id }) => id === major.majorId)?.name}
						<Chip>
							<span>{majorName}</span>
							<button slot="end-content" type="button" on:click={() => removeMajor(major)}>
								<XCircleIcon class="size-5" />
							</button>
						</Chip>
					{/each}
				</div>
			{/if}
		{/await}
	</Form.Div>

	<section class="flex justify-end space-x-4">
		<button type="button" on:click={() => history.back()}>Cancel</button>
		<button type="submit" class="capitalize">{mode}</button>
	</section>
</form>
