import { entityTimestampColumns } from "@db/utils/columns-util";
import { date, index, pgTable, serial, text, varchar } from "drizzle-orm/pg-core";
import { createSelectSchema, createInsertSchema } from "drizzle-zod";

export const staff = pgTable(
	"staff",
	{
		id: serial("id").primaryKey(),
		firstName: varchar("first_name", { length: 256 }).notNull(),
		lastName: varchar("last_name", { length: 256 }).notNull(),
		nickname: varchar("nickname", { length: 256 }),
		phone: varchar("phone", { length: 191 }),
		birthday: date("birthday", { mode: "date" }).notNull(),
		additionalInfo: text("additional_info"),
		...entityTimestampColumns
	},
	(staff) => ({
		staffIdx1: index("staff_idx_1").on(staff.firstName),
		staffIdx2: index("staff_idx_2").on(staff.lastName),
		staffIdx3: index("staff_idx_3").on(staff.phone),
		staffIdx4: index("staff_idx_4").on(staff.deletedAt),
		staffIdx5: index("staff_idx_5").on(staff.createdAt),
		staffIdx6: index("staff_idx_6").on(staff.updatedAt)
	})
);

export const selectStaffSchema = createSelectSchema(staff);
export const insertStaffSchema = createInsertSchema(staff, {
	firstName: ({ firstName }) => firstName.trim().min(1),
	lastName: ({ lastName }) => lastName.trim().min(1)
});
export type Staff = typeof staff.$inferSelect;
export type CreateStaff = typeof staff.$inferInsert;
