// Outil d'import du contenu clinique dans la base (cahier des charges V4.5,
// spécification technique §3).
//
// Charge les scripts de supabase/content/ du document le plus récent au plus
// ancien (date de publication de la source), un script par transaction, et
// s'arrête à la première erreur. Tout reste en brouillon : un script qui
// passerait une recommandation au statut « active » est refusé avant import.
// Les scripts sont idempotents (on conflict do nothing) : un rejeu ne crée
// pas de doublon.
//
// Usage :
//   node scripts/import-content.mjs            # affiche l'ordre, sans rien importer
//   DATABASE_URL=... node scripts/import-content.mjs --apply
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";

const dir = fileURLToPath(new URL("../supabase/content/", import.meta.url));
const apply = process.argv.includes("--apply");

function publicationDate(sql) {
  const start = sql.indexOf("insert into public.documents");
  if (start < 0) return null;
  const match = sql.slice(start, start + 2500).match(/'(\d{4}-\d{2}-\d{2})'/);
  return match ? match[1] : null;
}

// Refuse toute ligne de code (hors commentaire) qui publierait directement.
function publishesDirectly(sql) {
  return sql
    .split("\n")
    .filter((line) => !line.trim().startsWith("--"))
    .some((line) => /status\s*=\s*'active'|'active'\s*[,)]/i.test(line));
}

const files = readdirSync(dir)
  .filter((f) => f.endsWith(".sql"))
  .map((name) => {
    const sql = readFileSync(join(dir, name), "utf8");
    return { name, date: publicationDate(sql), direct: publishesDirectly(sql) };
  });

const blocked = files.filter((f) => f.direct);
if (blocked.length) {
  console.error("Import refusé : publication directe détectée dans", blocked.map((f) => f.name).join(", "));
  process.exit(1);
}

// Du plus récent au plus ancien ; les documents sans date en dernier.
files.sort((a, b) => {
  if (a.date === b.date) return a.name.localeCompare(b.name);
  if (!a.date) return 1;
  if (!b.date) return -1;
  return b.date.localeCompare(a.date);
});

console.log(`${files.length} scripts de contenu, du plus récent au plus ancien :`);
for (const [i, f] of files.entries()) {
  console.log(`${String(i + 1).padStart(3)}. ${f.date ?? "sans date "}  ${f.name}`);
}
const undated = files.filter((f) => !f.date);
if (undated.length) {
  console.warn(`Attention : ${undated.length} document(s) sans date de publication, importé(s) en dernier.`);
}

if (!apply) {
  console.log("\nAperçu uniquement. Ajoutez --apply (avec DATABASE_URL) pour importer.");
  process.exit(0);
}

const url = process.env.DATABASE_URL;
if (!url) {
  console.error("DATABASE_URL manquant.");
  process.exit(1);
}

function psql(args) {
  return spawnSync("psql", [url, "-X", "-q", "-v", "ON_ERROR_STOP=1", ...args], { encoding: "utf8" });
}

for (const [i, f] of files.entries()) {
  const res = psql(["--single-transaction", "-f", join(dir, f.name)]);
  if (res.status !== 0) {
    console.error(`\nÉchec sur ${f.name} (${i + 1}/${files.length}) :\n${res.stderr}`);
    console.error("Import arrêté ; les scripts précédents restent importés (rejouables sans doublon).");
    process.exit(1);
  }
  console.log(`✔ ${i + 1}/${files.length} ${f.name}`);
}

const summary = psql([
  "-At",
  "-c",
  "select (select count(*) from public.documents) || ' documents, ' || " +
    "(select count(*) from public.recommendations) || ' recommandations, statuts : ' || " +
    "(select coalesce(string_agg(distinct status, ', '), '-') from public.recommendations)",
]);
console.log(`\nTerminé : ${summary.stdout.trim()}`);
