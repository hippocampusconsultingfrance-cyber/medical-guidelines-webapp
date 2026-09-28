// Génère supabase/content/0200_fiches_atelier.sql à partir de l'atelier
// (dépôt rfe-sfar-website) : les fiches terminées (build/content_*.json),
// leurs métadonnées (site/app.js : DOC_META, FICHE_HREF_MATCH) et la
// bibliothèque des recommandations (build/library_final.json).
//
// Pour chaque fiche :
//   - si un document existe déjà (même URL source), il reçoit sa carte
//     (card_json) et sa mise en page (presentation_json) ;
//   - sinon, le document est créé, avec ses spécialités.
// Aucune fiche n'est publiée par ce script : la mise en ligne reste une
// action du porteur de projet (publish_all_documents / bouton « Publier »).
//
// Usage : ATELIER_DIR=../rfe-sfar-website node scripts/import-atelier.mjs
import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import vm from "node:vm";

const root = new URL("../", import.meta.url);
const atelier = process.env.ATELIER_DIR ?? new URL("../rfe-sfar-website", root).pathname;

// 1. Données de l'atelier (même lecture que sa page site/app.js).
const blocks = { library: readFileSync(join(atelier, "build/library_final.json"), "utf8") };
for (const f of readdirSync(join(atelier, "build")).filter((f) => /^content_.*\.json$/.test(f))) {
  blocks[f.slice(8, -5)] = readFileSync(join(atelier, "build", f), "utf8");
}
const js = readFileSync(join(atelier, "site/app.js"), "utf8");
const data = js
  .slice(0, js.indexOf("/* ============================================================\n   Small helpers"))
  .replace(/^\s*\(function\(\)\{/, "");
const ctx = {
  document: {
    getElementById: (id) => {
      const key = id.replace(/^content-/, "");
      if (!(key in blocks)) throw new Error(`Contenu manquant dans l'atelier : ${key}`);
      return { textContent: blocks[key] };
    },
  },
};
vm.createContext(ctx);
vm.runInContext(`${data}\n;this.out = { RAW, DOC_META, FICHE_HREF_MATCH, LIBRARY_BY_FICHE_KEY };`, ctx);
const { RAW, DOC_META, FICHE_HREF_MATCH, LIBRARY_BY_FICHE_KEY } = ctx.out;

// 2. Documents déjà en base : URL source lue dans les scripts de contenu.
const contentDir = new URL("supabase/content/", root);
const existing = [];
for (const f of readdirSync(contentDir).filter((f) => /^00.*\.sql$/.test(f))) {
  const sql = readFileSync(new URL(f, contentDir), "utf8");
  const i = sql.indexOf("insert into public.documents");
  if (i < 0) continue;
  const u = sql.slice(i, i + 4000).match(/'(https?:\/\/[^']+)'/);
  if (u) existing.push(u[1]);
}

// 3. Spécialités à partir de la catégorie de la bibliothèque. Toutes les
// fiches de l'atelier relèvent de l'anesthésie-réanimation (spécialité pilote).
const CATEGORY_SPECIALTIES = {
  Anesthésie: ["anesthesie_reanimation", "infirmierere_anesthesiste_iade"],
  Réanimation: ["anesthesie_reanimation", "medecine_intensive_reanimation"],
  Urgences: ["medecine_d_urgence"],
  Obstétrique: ["gynecologie_obstetrique", "sage_femme_maieuticienne"],
  Pédiatrie: ["pediatrie"],
  Infectiologie: ["infectiologie_maladies_infectieuses_et_tropicales"],
  Nutrition: ["dieteticienne_nutritionniste"],
};
function specialtiesFor(category) {
  const out = new Set(["anesthesie_reanimation"]);
  for (const part of (category ?? "").split(",").map((s) => s.trim())) {
    for (const slug of CATEGORY_SPECIALTIES[part] ?? []) out.add(slug);
  }
  return [...out];
}

function publicationDate(lib, meta) {
  const raw = lib?.exact_date ?? lib?.year ?? `${meta.version ?? ""} ${meta.validated ?? ""}`;
  const full = String(raw).match(/\b(19|20)\d{2}-\d{2}-\d{2}\b/);
  if (full) return full[0];
  const year = String(raw).match(/\b(19|20)\d{2}\b/);
  return year ? `${year[0]}-01-01` : null; // année seule : affichée comme telle
}

const q = (s) => (s == null ? "null" : `'${String(s).replace(/'/g, "''")}'`);
const tag = "$mgjson$";
const json = (o) => {
  const s = JSON.stringify(o);
  if (s.includes(tag)) throw new Error(`Délimiteur ${tag} présent dans le contenu`);
  return `${tag}${s}${tag}::jsonb`;
};

const CARD_FIELDS = ["badge", "title", "short", "society", "version", "validated", "methodology", "pages"];
let sql =
  "-- Généré par scripts/import-atelier.mjs — ne pas modifier à la main.\n" +
  "-- Fiches de l'atelier : carte, mise en page et spécialités. Aucune\n" +
  "-- publication (published_at et statuts inchangés). Idempotent.\n\n";
let matched = 0;
let created = 0;
const keys = Object.keys(DOC_META);

// Première passe : document visé par chaque fiche.
const targets = new Map();
for (const key of keys) {
  const meta = DOC_META[key];
  const lib = LIBRARY_BY_FICHE_KEY[key];
  if (!RAW[key]) throw new Error(`Fiche sans contenu : ${key}`);
  const tokens = [...(FICHE_HREF_MATCH[key] ?? []), meta.url, lib?.direct_pdf_url, lib?.href]
    .filter(Boolean)
    .map((t) => t.replace(/\/$/, ""));
  const hits = [...new Set(existing.filter((u) => tokens.some((t) => u.includes(t) || t.includes(u.replace(/\/$/, "")))))];
  if (hits.length > 1) throw new Error(`Fiche ${key} : ${hits.length} documents correspondants`);
  const url = hits[0] ?? meta.url ?? lib?.direct_pdf_url ?? lib?.href;
  if (!url) throw new Error(`Fiche ${key} : aucune URL source`);
  targets.set(key, { url, existing: hits.length > 0 });
}

// Un même PDF découpé en plusieurs fiches (ex. blocs périmédullaires 2006) :
// chaque fiche devient un document distinct, avec l'URL du PDF suivie d'un
// repère propre (#fiche), qui ouvre toujours le même PDF.
const uses = new Map();
for (const t of targets.values()) uses.set(t.url, (uses.get(t.url) ?? 0) + 1);
for (const [key, t] of targets) {
  if (uses.get(t.url) > 1) {
    if (t.existing) throw new Error(`Document existant partagé par plusieurs fiches : ${t.url}`);
    t.url = `${t.url}#${key}`;
  }
}

for (const key of keys) {
  const meta = DOC_META[key];
  const lib = LIBRARY_BY_FICHE_KEY[key];
  const { url, existing: isExisting } = targets.get(key);
  const card = Object.fromEntries(CARD_FIELDS.filter((f) => meta[f] != null).map((f) => [f, meta[f]]));
  // Rubrique de la barre latérale : premier domaine de la catégorie de la
  // bibliothèque (« Anesthésie, Urgences » → Anesthésie). Les fiches sans
  // entrée dans la bibliothèque (découpages de textes SFAR d'anesthésie :
  // blocs périmédullaires, traitements chroniques) sont rangées en Anesthésie.
  card.section = (lib?.category ?? "Anesthésie").split(",")[0].trim();
  const presentation = { v: 1, key, sections: RAW[key].sections };

  if (isExisting) {
    matched++;
  } else {
    created++;
    // original_language : non indiqué par l'atelier, laissé explicite plutôt
    // que deviné (cf. commentaire du schéma sur ce champ).
    sql +=
      `insert into public.documents (title, doc_type, publication_date, source_url, original_language)\n` +
      `values (${q(lib?.title ?? meta.title)}, ${q(lib?.exact_type ?? null)}, ${q(publicationDate(lib, meta))}, ${q(url)}, 'non_renseigne')\n` +
      `on conflict (source_url) do nothing;\n`;
  }
  // Spécialités : ajoutées (jamais retirées) pour toutes les fiches, y compris
  // les documents existants, tous rattachés à l'anesthésie-réanimation.
  sql +=
    `insert into public.document_specialties (document_id, specialty_id)\n` +
    `select d.id, s.id from public.documents d, public.specialties s\n` +
    `where d.source_url = ${q(url)} and s.slug in (${specialtiesFor(lib?.category).map(q).join(", ")})\n` +
    `on conflict do nothing;\n`;
  sql +=
    `update public.documents set\n` +
    `  fiche_key = ${q(key)},\n` +
    `  card_json = ${json(card)},\n` +
    `  presentation_json = ${json(presentation)}\n` +
    `where source_url = ${q(url)};\n\n`;
}

writeFileSync(new URL("supabase/content/0200_fiches_atelier.sql", root), sql);
console.log(`${keys.length} fiches : ${matched} documents existants complétés, ${created} documents créés.`);
