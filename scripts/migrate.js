// Kleines Hilfsskript, um die SQL-Dateien aus sql/ gegen DATABASE_URL auszuführen.
// Nutzung: DATABASE_URL=postgres://... node scripts/migrate.js
require("dotenv").config();
const fs = require("fs");
const path = require("path");
const { Pool } = require("pg");

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function run() {
  const sqlDir = path.join(__dirname, "..", "sql");
  const files = fs.readdirSync(sqlDir).filter((f) => f.endsWith(".sql")).sort();

  for (const file of files) {
    console.log(`Führe ${file} aus...`);
    const sql = fs.readFileSync(path.join(sqlDir, file), "utf-8");
    await pool.query(sql);
  }

  console.log("Alle Migrationen angewendet.");
  await pool.end();
}

run().catch((err) => {
  console.error("Fehler bei der Migration:", err.message);
  process.exit(1);
});
