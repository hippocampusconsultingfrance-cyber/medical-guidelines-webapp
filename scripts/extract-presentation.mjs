// Extrait la mise en page des fiches détaillées de l'ancienne page
// (public/fiches/index.html) et génère supabase/content/0100_presentation_fiches.sql,
// qui renseigne pour chaque document :
//   - card_json : la carte du catalogue (lisible par tous) ;
//   - presentation_json : le contenu mis en page (protégé, lu seulement par
//     get_document_presentation()).
// Les fiches sont rattachées aux documents par leur URL source, comme le
// faisait l'ancienne page (FICHE_HREF_MATCH). Une fiche sans correspondance
// unique arrête le script.
//
// Usage : node scripts/extract-presentation.mjs
import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import vm from "node:vm";

const root = new URL("../", import.meta.url);
const html = readFileSync(new URL("public/fiches/index.html", root), "utf8");

const blocks = {};
for (const m of html.matchAll(/<script id="content-([^"]+)" type="application\/json">([\s\S]*?)<\/script>/g)) {
  blocks[m[1]] = m[2];
}
const scripts = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map((m) => m[1]);
const js = scripts[scripts.length - 1];
const data = js
  .slice(0, js.indexOf("/* ============================================================\n   Small helpers"))
  .replace(/^\s*\(function\(\)\{/, "");
const ctx = { document: { getElementById: (id) => ({ textContent: blocks[id.replace(/^content-/, "")] }) } };
vm.createContext(ctx);
vm.runInContext(`${data}\n;this.out = { RAW, DOC_META, FICHE_HREF_MATCH };`, ctx);
const { RAW, DOC_META, FICHE_HREF_MATCH } = ctx.out;

// URL source de chaque document, lue dans les scripts de contenu.
const contentDir = new URL("supabase/content/", root);
const urls = [];
for (const f of readdirSync(contentDir).filter((f) => /^00.*\.sql$/.test(f))) {
  const sql = readFileSync(new URL(f, contentDir), "utf8");
  const i = sql.indexOf("insert into public.documents");
  if (i < 0) continue;
  const u = sql.slice(i, i + 4000).match(/'(https?:\/\/[^']+)'/);
  if (u) urls.push(u[1]);
}

const CARD_FIELDS = ["badge", "title", "short", "society", "version", "validated", "methodology", "pages"];
const tag = "$mgjson$";
let sql =
  "-- Généré par scripts/extract-presentation.mjs — ne pas modifier à la main.\n" +
  "-- Carte (card_json) et mise en page (presentation_json) des fiches détaillées.\n" +
  "-- Aucune recommandation n'est publiée par ce script. Idempotent.\n\n";
let count = 0;
for (const key of Object.keys(DOC_META)) {
  const meta = DOC_META[key];
  const tokens = [...(FICHE_HREF_MATCH[key] ?? []), meta.url].filter(Boolean).map((t) => t.replace(/\/$/, ""));
  const hits = urls.filter((u) => tokens.some((t) => u.includes(t)));
  if (hits.length !== 1) {
    console.error(`Fiche ${key} : ${hits.length} document(s) correspondant(s), attendu 1.`);
    process.exit(1);
  }
  const card = Object.fromEntries(CARD_FIELDS.filter((f) => meta[f] != null).map((f) => [f, meta[f]]));
  const presentation = { v: 1, key, sections: RAW[key].sections };
  for (const json of [card, presentation]) {
    if (JSON.stringify(json).includes(tag)) throw new Error(`Délimiteur ${tag} présent dans ${key}`);
  }
  sql +=
    `update public.documents set\n` +
    `  card_json = ${tag}${JSON.stringify(card)}${tag}::jsonb,\n` +
    `  presentation_json = ${tag}${JSON.stringify(presentation)}${tag}::jsonb\n` +
    `where source_url = '${hits[0].replace(/'/g, "''")}';\n\n`;
  count++;
}

writeFileSync(new URL("supabase/content/0100_presentation_fiches.sql", root), sql);
console.log(`${count} fiches détaillées écrites dans supabase/content/0100_presentation_fiches.sql`);
