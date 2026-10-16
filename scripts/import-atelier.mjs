// Génère supabase/content/0200_fiches_atelier.sql à partir de l'atelier
// (dépôt central des sociétés savantes, anciennement rfe-sfar-website) :
// les fiches terminées (build/content_*.json),
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
// Pas d'accord, pas de fiche : l'import est refusé tant que le contrôle des
// accords de l'atelier (outils/accords.mjs) signale une erreur, c'est-à-dire
// une fiche sans l'accord de sa société porteuse.
//
// Usage : ATELIER_DIR=../depot-central-societes-savantes node scripts/import-atelier.mjs
import { createHash } from "node:crypto";
import { existsSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { pathToFileURL } from "node:url";
import vm from "node:vm";

const root = new URL("../", import.meta.url);
const atelier =
  process.env.ATELIER_DIR ??
  ["../depot-central-societes-savantes", "../rfe-sfar-website"]
    .map((d) => new URL(d, root).pathname)
    .find((d) => existsSync(d)) ??
  new URL("../depot-central-societes-savantes", root).pathname;

// 0. Accords des sociétés savantes (règle de l'atelier).
const controle = join(atelier, "outils/accords.mjs");
if (!existsSync(controle)) throw new Error(`Contrôle des accords absent de l'atelier : ${controle}`);
const accords = (await import(pathToFileURL(controle).href)).verifier(atelier);
if (accords.erreurs.length) {
  console.error(accords.erreurs.map((e) => `ERREUR  ${e}`).join("\n"));
  throw new Error(`Import refusé : ${accords.erreurs.length} erreur(s) d'accord dans l'atelier (pas d'accord, pas de fiche).`);
}
for (const a of accords.avertissements) console.warn(`Accords : ${a}`);

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

// Résumé de la carte (card_json.short) : il est public (pages indexées par
// Google, bibliothèque, e-mails). Celui de l'atelier mêle parfois la
// description clinique et des notes de travail (décomptes, « disclosed »,
// renvois aux clés de fiches…) : il est alors remplacé par le résumé relu
// de scripts/resumes-fiches.json. « atelier » y est l'empreinte du résumé
// d'origine : s'il change dans l'atelier, le résumé relu est à revoir.
const RESUMES = JSON.parse(readFileSync(new URL("scripts/resumes-fiches.json", root), "utf8"));
const NOTE_INTERNE =
  /disclos|recherche web|index habituel|recoupement|supersede|sur ce site|ce corpus|chipp|décompte|git-track|installment|`/i;
const aRelire = [];
function resume(key, short) {
  const relu = RESUMES[key];
  if (relu) {
    if (relu.atelier !== createHash("sha1").update(short ?? "").digest("hex").slice(0, 10)) {
      aRelire.push(`${key} (résumé modifié dans l'atelier)`);
    }
    return relu.resume;
  }
  if (short && NOTE_INTERNE.test(short)) aRelire.push(`${key} (notes internes)`);
  return short;
}

// Sociétés savantes signataires, lues dans la mention de la carte
// (« SFAR / SRLF / SFMU (AFC, AFU) — RFE 2019 » → SFAR, SRLF, SFMU, AFC, AFU).
// Sigles de type de document ou ambigus écartés.
const NOT_SOCIETIES = new Set(["RFE", "RBP", "RPP", "RPC", "ALR", "SF", "CNP", "GRADE", "PT", "STP"]);
// Graphie de référence d'un sigle écrit de plusieurs façons.
const CANONICAL = { SOFRASIMS: "SoFraSimS" };
export function societiesOf(mention) {
  const head = String(mention ?? "").split("—")[0];
  const out = [];
  for (const token of head.match(/\b[A-Z][A-Za-z0-9]*[A-Z][A-Za-z0-9-]*\b/g) ?? []) {
    for (const part of token.split("-")) {
      const name = CANONICAL[part.toUpperCase()] ?? part;
      if (/^[A-Z][A-Za-z0-9]*[A-Z0-9]$/.test(part) && !NOT_SOCIETIES.has(part) && !out.includes(name)) out.push(name);
    }
  }
  return out;
}
const allSocieties = new Set();
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
  if (card.short != null) card.short = resume(key, card.short);
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
  // Sociétés signataires : ajoutées (jamais retirées) ; la première est la
  // société porteuse (documents.society_id) si elle n'est pas déjà renseignée.
  const societies = societiesOf(meta.society);
  societies.forEach((a) => allSocieties.add(a));
  if (societies.length) {
    sql +=
      `insert into public.document_societies (document_id, society_id)\n` +
      `select d.id, s.id from public.documents d, public.societies s\n` +
      `where d.source_url = ${q(url)} and s.acronym in (${societies.map(q).join(", ")})\n` +
      `on conflict do nothing;\n` +
      `update public.documents d set society_id = s.id from public.societies s\n` +
      `where d.source_url = ${q(url)} and d.society_id is null and s.acronym = ${q(societies[0])};\n`;
  }
  sql +=
    `update public.documents set\n` +
    `  fiche_key = ${q(key)},\n` +
    `  card_json = ${json(card)},\n` +
    `  presentation_json = ${json(presentation)}\n` +
    `where source_url = ${q(url)};\n\n`;
}

// Sociétés absentes du référentiel : créées « à valider » (sans pays : non
// indiqué par l'atelier), avant tous les rattachements.
const header = [...allSocieties]
  .sort()
  .map(
    (a) =>
      `insert into public.societies (acronym) select ${q(a)}\n` +
      `where not exists (select 1 from public.societies where acronym = ${q(a)});\n`,
  )
  .join("");
const cut = sql.indexOf("\n\n") + 2;
sql = sql.slice(0, cut) + header + "\n" + sql.slice(cut);

writeFileSync(new URL("supabase/content/0200_fiches_atelier.sql", root), sql);
if (aRelire.length) {
  console.warn(`Résumés à relire dans scripts/resumes-fiches.json :\n  ${aRelire.join("\n  ")}`);
}
console.log(`${keys.length} fiches : ${matched} documents existants complétés, ${created} documents créés, ${allSocieties.size} sociétés signataires.`);

// 4. Traductions anglaises (build/en/content_<clé>.json, brouillons de la
// routine) → supabase/content/0210_traductions_en.sql, table
// document_translations (lecture réservée à l'équipe éditoriale). Un
// brouillon modifié depuis le dernier import repasse en « brouillon » ;
// fr_a_jour indique si la traduction part du contenu français actuel.
const enDir = join(atelier, "build/en");
const sha = (buf) => createHash("sha256").update(buf).digest("hex");
let en = 0;
let enSql =
  "-- Généré par scripts/import-atelier.mjs — ne pas modifier à la main.\n" +
  "-- Traductions anglaises des fiches, en brouillon pour relecture (aucune\n" +
  "-- publication). Idempotent.\n\n";
for (const f of readdirSync(enDir).filter((f) => /^content_.*\.json$/.test(f)).sort()) {
  const key = f.slice(8, -5);
  if (!keys.includes(key)) {
    console.warn(`Traduction sans fiche importée : ${key}`);
    continue;
  }
  const raw = readFileSync(join(enDir, f));
  const d = JSON.parse(raw.toString("utf8"));
  if (d.lang !== "en") throw new Error(`${f} : langue ${d.lang}`);
  const frRaw = readFileSync(join(atelier, "build", `content_${key}.json`));
  const card = Object.fromEntries(CARD_FIELDS.filter((k) => d.meta?.[k] != null).map((k) => [k, d.meta[k]]));
  const presentation = { v: 1, key, lang: "en", chip_legend: d.chip_legend ?? null, sections: d.sections };
  const date = /^\d{4}-\d{2}-\d{2}$/.test(d.source_publication_date ?? "") ? d.source_publication_date : null;
  enSql +=
    `insert into public.document_translations (document_id, lang, card_json, presentation_json, key_points, a_verifier, source_publication_date, content_sha256, fr_a_jour)\n` +
    `select d.id, 'en', ${json(card)}, ${json(presentation)}, ${json(d.key_points ?? [])}, ${json(d.a_verifier ?? [])}, ${q(date)}, ${q(sha(raw))}, ${d.translated_from?.sha256 === sha(frRaw)}\n` +
    `from public.documents d where d.fiche_key = ${q(key)}\n` +
    `on conflict (document_id, lang) do update set\n` +
    `  card_json = excluded.card_json, presentation_json = excluded.presentation_json,\n` +
    `  key_points = excluded.key_points, a_verifier = excluded.a_verifier,\n` +
    `  source_publication_date = excluded.source_publication_date, fr_a_jour = excluded.fr_a_jour,\n` +
    `  status = case when public.document_translations.content_sha256 = excluded.content_sha256\n` +
    `    then public.document_translations.status else 'brouillon' end,\n` +
    `  content_sha256 = excluded.content_sha256, imported_at = now();\n\n`;
  en++;
}
writeFileSync(new URL("supabase/content/0210_traductions_en.sql", root), enSql);
console.log(`${en} traduction(s) anglaise(s) en brouillon.`);
