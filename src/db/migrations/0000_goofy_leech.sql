DO $$ BEGIN
 CREATE TYPE "payment_method" AS ENUM('cash', 'prompt_pay');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "sex" AS ENUM('male', 'female');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "camp" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(256) NOT NULL,
	"from_date" date NOT NULL,
	"to_date" date NOT NULL,
	"text" text NOT NULL,
	"hasLaundry" boolean DEFAULT true NOT NULL,
	"laundry_price" numeric(10, 2),
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "camp_major" (
	"id" serial PRIMARY KEY NOT NULL,
	"camp_id" integer,
	"major_id" integer,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "camp_participant" (
	"id" serial PRIMARY KEY NOT NULL,
	"camp_id" integer,
	"participant_id" integer,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "camp_participant_unq_1" UNIQUE("camp_id","participant_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "camp_staff" (
	"id" serial PRIMARY KEY NOT NULL,
	"camp_id" integer,
	"staff_id" integer,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "camp_staff_unq_1" UNIQUE("camp_id","staff_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "major" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(256) NOT NULL,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "laundry_item" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(256) NOT NULL,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "room_laundry_item" (
	"id" serial PRIMARY KEY NOT NULL,
	"room_id" integer,
	"item_id" integer,
	"quantity" integer NOT NULL,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "room" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(256) NOT NULL,
	"description" text,
	"camp_id" integer,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "room_unq_1" UNIQUE("name","camp_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "room_participant" (
	"id" serial PRIMARY KEY NOT NULL,
	"room_id" integer,
	"camp_participant_id" integer,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "room_participant_unq_1" UNIQUE("camp_participant_id","room_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "room_staff" (
	"id" serial PRIMARY KEY NOT NULL,
	"room_id" integer,
	"camp_staff_id" integer,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "room_staff_unq_1" UNIQUE("camp_staff_id","room_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "participant" (
	"id" serial PRIMARY KEY NOT NULL,
	"first_name" varchar(256) NOT NULL,
	"last_name" varchar(256) NOT NULL,
	"nickname" varchar(256),
	"phone" varchar(191),
	"birthday" date NOT NULL,
	"sex" "sex" NOT NULL,
	"additional_info" text,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "staff" (
	"id" serial PRIMARY KEY NOT NULL,
	"first_name" varchar(256) NOT NULL,
	"last_name" varchar(256) NOT NULL,
	"nickname" varchar(256),
	"phone" varchar(191),
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"additional_info" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "staff_account" (
	"id" serial PRIMARY KEY NOT NULL,
	"staff_id" integer,
	"email" varchar(256) NOT NULL,
	"password" varchar(256) NOT NULL,
	"deleted_at" timestamp DEFAULT '1970-01-01 00:00:00.001' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "staff_account_staff_id_unique" UNIQUE("staff_id")
);
--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "camp_idx_1" ON "camp" ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_idx_2" ON "camp" ("from_date");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_idx_3" ON "camp" ("to_date");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_idx_4" ON "camp" ("hasLaundry");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_idx_5" ON "camp" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_idx_6" ON "camp" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_idx_7" ON "camp" ("updated_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_major_idx_1" ON "camp_major" ("camp_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_major_idx_2" ON "camp_major" ("major_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_major_idx_3" ON "camp_major" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_major_idx_4" ON "camp_major" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_major_idx_5" ON "camp_major" ("updated_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_participant_idx_1" ON "camp_participant" ("camp_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_participant_idx_2" ON "camp_participant" ("participant_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_participant_idx_3" ON "camp_participant" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_participant_idx_4" ON "camp_participant" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_participant_idx_5" ON "camp_participant" ("updated_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_staff_idx_1" ON "camp_staff" ("camp_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_staff_idx_2" ON "camp_staff" ("staff_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_staff_idx_3" ON "camp_staff" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_staff_idx_4" ON "camp_staff" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "camp_staff_idx_5" ON "camp_staff" ("updated_at");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "major_idx_1" ON "major" ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "major_idx_2" ON "major" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "major_idx_3" ON "major" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "major_idx_4" ON "major" ("updated_at");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "laundry_item_idx_1" ON "laundry_item" ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "laundry_item_idx_2" ON "laundry_item" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "laundry_item_idx_3" ON "laundry_item" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "laundry_item_idx_4" ON "laundry_item" ("updated_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_laundry_item_idx_1" ON "room_laundry_item" ("room_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_laundry_item_idx_2" ON "room_laundry_item" ("item_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_laundry_item_idx_3" ON "room_laundry_item" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_laundry_item_idx_4" ON "room_laundry_item" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_laundry_item_idx_5" ON "room_laundry_item" ("updated_at");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "room_idx_1" ON "room" ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_idx_2" ON "room" ("camp_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_idx_3" ON "room" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_idx_4" ON "room" ("updated_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_idx_5" ON "room" ("created_at");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "room_participant_idx_1" ON "room_participant" ("room_id");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "room_participant_idx_2" ON "room_participant" ("camp_participant_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_participant_idx_3" ON "room_participant" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_participant_idx_4" ON "room_participant" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_participant_idx_5" ON "room_participant" ("updated_at");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "room_staff_idx_1" ON "room_staff" ("room_id");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "room_staff_idx_2" ON "room_staff" ("camp_staff_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_staff_idx_3" ON "room_staff" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_staff_idx_4" ON "room_staff" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "room_staff_idx_5" ON "room_staff" ("updated_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "participant_idx_1" ON "participant" ("first_name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "participant_idx_2" ON "participant" ("last_name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "participant_idx_3" ON "participant" ("phone");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "participant_idx_4" ON "participant" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "participant_idx_5" ON "participant" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "participant_idx_6" ON "participant" ("updated_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_idx_1" ON "staff" ("first_name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_idx_2" ON "staff" ("last_name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_idx_3" ON "staff" ("phone");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_idx_4" ON "staff" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_idx_5" ON "staff" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_idx_6" ON "staff" ("updated_at");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "staff_account_idx_1" ON "staff_account" ("staff_id");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "staff_account_idx_2" ON "staff_account" ("email");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_account_idx_3" ON "staff_account" ("deleted_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_account_idx_4" ON "staff_account" ("created_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "staff_account_idx_5" ON "staff_account" ("updated_at");--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "camp_major" ADD CONSTRAINT "camp_major_camp_id_camp_id_fk" FOREIGN KEY ("camp_id") REFERENCES "camp"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "camp_major" ADD CONSTRAINT "camp_major_major_id_major_id_fk" FOREIGN KEY ("major_id") REFERENCES "major"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "camp_participant" ADD CONSTRAINT "camp_participant_camp_id_camp_id_fk" FOREIGN KEY ("camp_id") REFERENCES "camp"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "camp_participant" ADD CONSTRAINT "camp_participant_participant_id_participant_id_fk" FOREIGN KEY ("participant_id") REFERENCES "participant"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "camp_staff" ADD CONSTRAINT "camp_staff_camp_id_camp_id_fk" FOREIGN KEY ("camp_id") REFERENCES "camp"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "camp_staff" ADD CONSTRAINT "camp_staff_staff_id_staff_id_fk" FOREIGN KEY ("staff_id") REFERENCES "staff"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "room_laundry_item" ADD CONSTRAINT "room_laundry_item_room_id_room_id_fk" FOREIGN KEY ("room_id") REFERENCES "room"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "room_laundry_item" ADD CONSTRAINT "room_laundry_item_item_id_laundry_item_id_fk" FOREIGN KEY ("item_id") REFERENCES "laundry_item"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "room" ADD CONSTRAINT "room_camp_id_camp_id_fk" FOREIGN KEY ("camp_id") REFERENCES "camp"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "room_participant" ADD CONSTRAINT "room_participant_room_id_room_id_fk" FOREIGN KEY ("room_id") REFERENCES "room"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "room_participant" ADD CONSTRAINT "room_participant_camp_participant_id_camp_participant_id_fk" FOREIGN KEY ("camp_participant_id") REFERENCES "camp_participant"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "room_staff" ADD CONSTRAINT "room_staff_room_id_room_id_fk" FOREIGN KEY ("room_id") REFERENCES "room"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "room_staff" ADD CONSTRAINT "room_staff_camp_staff_id_camp_staff_id_fk" FOREIGN KEY ("camp_staff_id") REFERENCES "camp_staff"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "staff_account" ADD CONSTRAINT "staff_account_staff_id_staff_id_fk" FOREIGN KEY ("staff_id") REFERENCES "staff"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
