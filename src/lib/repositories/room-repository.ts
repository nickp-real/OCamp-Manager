import { ifEmptyThrowError, isExisted } from '$lib/utils/db-utils';
import { db } from '@db/index';
import { room, selectRoomSchema, type CreateRoom } from '@db/schema/rooms';
import { and, eq } from 'drizzle-orm';

type UpdateRoomBody = Partial<CreateRoom>;

const roomList = selectRoomSchema.array();

const isExist = isExisted(room.deletedAt);

export async function getRooms() {
	const allRooms = await db.select().from(room).where(isExist);
	return roomList.parse(allRooms);
}

export async function getRoomById(id: number) {
	const roomData = await db
		.select()
		.from(room)
		.where(and(isExist, eq(room.id, id)))
		.limit(1);

	ifEmptyThrowError(roomData, 'Room data is not found');

	return selectRoomSchema.parse(roomData.at(0));
}

export async function createRoom(data: CreateRoom) {
	await db.insert(room).values(data);
}

export async function updateRoomById(id: number, data: UpdateRoomBody) {
	await db
		.update(room)
		.set({ ...data, updatedAt: new Date() })
		.where(and(isExist, eq(room.id, id)));
}

export async function deleteRoomById(id: number) {
	await db
		.update(room)
		.set({ deletedAt: new Date() })
		.where(and(isExist, eq(room.id, id)));
}
