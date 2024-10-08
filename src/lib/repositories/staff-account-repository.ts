import { ifEmptyThrowError, isExisted } from "$lib/utils/db-utils";
import { db } from "@db/index";
import {
	type CreateStaffAccount,
	selectStaffAccountSchema,
	type StaffAccount,
	staffAccount
} from "@db/schema/staff-account";

import { and, eq } from "drizzle-orm";

type UpdateStaffAccountBody = Partial<CreateStaffAccount>;

const staffAccountList = selectStaffAccountSchema.array();

const isExist = isExisted(staffAccount.deletedAt);

export async function getAll() {
	const allStaffAccount = await db.select().from(staffAccount).where(isExist);
	return staffAccountList.parse(allStaffAccount);
}

export async function getStaffAccountById(id: StaffAccount["id"]) {
	const staffAccountData = await db
		.select()
		.from(staffAccount)
		.where(and(isExist, eq(staffAccount.id, id)))
		.limit(1);

	ifEmptyThrowError(staffAccountData, "Staff account data is not found");

	return selectStaffAccountSchema.parse(staffAccountData.at(0));
}

export async function getStaffAccountByStaffId(staffId: StaffAccount["staffId"]) {
	const staffAccountData = await db
		.select()
		.from(staffAccount)
		.where(and(isExist, eq(staffAccount.staffId, staffId)))
		.limit(1);
	return staffAccountData.at(0) ? selectStaffAccountSchema.parse(staffAccountData.at(0)) : null;
}

export async function createStaffAccount(data: CreateStaffAccount) {
	await db.insert(staffAccount).values(data);
}

export async function updateStaffAccountById(id: StaffAccount["id"], data: UpdateStaffAccountBody) {
	await db
		.update(staffAccount)
		.set({ ...data, updatedAt: new Date() })
		.where(and(isExist, eq(staffAccount.id, id)));
}
export async function updateStaffAccountByStaffId(
	staffId: StaffAccount["staffId"],
	data: UpdateStaffAccountBody
) {
	await db
		.update(staffAccount)
		.set({ ...data, updatedAt: new Date() })
		.where(and(isExist, eq(staffAccount.staffId, staffId)));
}

export async function deleteStaffAccountById(id: StaffAccount["id"]) {
	await db
		.update(staffAccount)
		.set({ deletedAt: new Date() })
		.where(and(isExist, eq(staffAccount.id, id)));
}
export async function deleteStaffAccountByStaffId(staffId: StaffAccount["staffId"]) {
	await db
		.update(staffAccount)
		.set({ deletedAt: new Date() })
		.where(and(isExist, eq(staffAccount.staffId, staffId)));
}
