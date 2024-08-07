import { sql } from '@vercel/postgres';
import { drizzle as prodDrizzle, type VercelPgDatabase } from 'drizzle-orm/vercel-postgres';
import pg from 'pg';
import { NODE_ENV } from '$env/static/private';
import { env } from '$env/dynamic/private';
import { drizzle as localDrizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';

export let db: NodePgDatabase | VercelPgDatabase;

// local pg
if (NODE_ENV === 'development') {
	const { Client } = pg;
	const client = new Client({ connectionString: env.DATABASE_URL });
	await client.connect();
	db = localDrizzle(client, { logger: true });
} else {
	// vercel
	db = prodDrizzle(sql, { logger: true });
}
