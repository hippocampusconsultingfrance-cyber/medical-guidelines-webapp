// Génère le SQL qui crée ou met à jour les demandes d'accord (outil
// /bibliotheque/demandes-accord) à partir de l'atelier : une ligne par
// dossier societes/<slug>/ACCORD.md, avec ses adresses (section « Adresses
// pour la demande d'accord »), son nombre de fiches (documents/registre.json)
// et son rang dans l'ordre conseillé (societes/SUIVI.md).
//
// Ne remplace jamais ce qui a été fait dans l'outil : adresses et
// destinataires seulement s'ils sont vides, personnalisation seulement si
// elle est vide. L'état suit l'atelier quand la demande y a avancé hors de
// l'outil (envoyée à la main, accord, refus) et qu'elle n'est pas partie
// depuis l'outil : une société déjà sollicitée ne peut plus être renvoyée.
//
// Usage : ATELIER_DIR=../depot-central-societes-savantes node scripts/demandes-accord/importer.mjs > demandes.sql
// puis appliquer demandes.sql sur la base (éditeur SQL de Supabase).
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const root = new URL("../../", import.meta.url);
const atelier =
  process.env.ATELIER_DIR ??
  ["../depot-central-societes-savantes", "../rfe-sfar-website"]
    .map((d) => new URL(d, root).pathname)
    .find((d) => existsSync(d)) ??
  new URL("../depot-central-societes-savantes", root).pathname;
const dossier = join(atelier, "societes");
if (!existsSync(dossier)) throw new Error(`Atelier introuvable : ${dossier} (ATELIER_DIR)`);

const perso = JSON.parse(readFileSync(new URL("personnalisation.json", import.meta.url), "utf8"));
const registre = JSON.parse(readFileSync(join(atelier, "documents/registre.json"), "utf8"));
const suivi = existsSync(join(dossier, "SUIVI.md")) ? readFileSync(join(dossier, "SUIVI.md"), "utf8") : "";
const rangs = new Map([...suivi.matchAll(/^\| (\d+) \| \[[^\]]+\]\(([^/]+)\/ACCORD\.md\)/gm)].map((m) => [m[2], Number(m[1])]));

const ADRESSE = /^[A-Za-z0-9][A-Za-z0-9._%+-]*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,12}$/;
const ETAT = { accord_obtenu: "accord", demande_envoyee: "envoye", refus: "refus" };

// Même choix que l'outil (src/lib/demandes-accord.ts) : présidence, puis
// secrétariat, puis contact ; adresses de la société d'abord ; deux au plus.
function choisir(adresses) {
  const rang = (a) =>
    (a.nature.startsWith("société") ? 0 : 10) +
    (/president|presidence/.test(a.adresse) ? 0 : /secr/.test(a.adresse) ? 1 : /contact|info|accueil|courrier/.test(a.adresse) ? 2 : 3);
  return adresses.filter((a) => ADRESSE.test(a.adresse)).sort((a, b) => rang(a) - rang(b)).slice(0, 2).map((a) => a.adresse);
}

const q = (v) => (v === null || v === undefined || v === "" ? "null" : `'${String(v).replace(/'/g, "''")}'`);
const tableau = (l) => (l.length ? `array[${l.map(q).join(", ")}]::text[]` : "'{}'::text[]");

const lignes = [];
for (const slug of readdirSync(dossier).sort()) {
  const f = join(dossier, slug, "ACCORD.md");
  if (!existsSync(f)) continue;
  const texte = readFileSync(f, "utf8");
  const tete = texte.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!tete) continue;
  const h = Object.fromEntries(
    tete[1].split(/\r?\n/).map((l) => [l.slice(0, l.indexOf(":")).trim(), l.slice(l.indexOf(":") + 1).trim()]).filter(([k]) => k),
  );
  const section = texte.match(/## Adresses pour la demande d'accord\n\n([\s\S]*?)\n\n## /)?.[1] ?? "";
  const adresses = [...section.matchAll(/^- (\S+@\S+) — (.*) \((.*)\)$/gm)].map((m) => ({ adresse: m[1], nature: m[2], page: m[3] }));
  const nbFiches = registre.filter((d) => d.etat === "fait" && (d.signataires ?? []).includes(slug)).length;
  const nbPorteuse = registre.filter((d) => d.etat === "fait" && d.porteuse === slug).length;
  const p = perso[slug] ?? {};
  // Date d'envoi notée au journal : « - 17/10/2026 : demande d'accord envoyée … ».
  const envoi = texte.match(/^- (\d{2})\/(\d{2})\/(\d{4}) : demande d'accord envoyée/m);
  const envoyeLe = envoi ? `${envoi[3]}-${envoi[2]}-${envoi[1]}T12:00:00+02:00` : null;
  lignes.push(
    `(${[
      q(slug),
      q(h.sigle || slug.toUpperCase()),
      q(h.nom),
      q(h.type),
      q(h.specialite),
      q(h.site),
      rangs.has(slug) ? rangs.get(slug) : "null",
      nbFiches,
      nbPorteuse,
      `${q(JSON.stringify(adresses))}::jsonb`,
      tableau(choisir(adresses)),
      q(p.exemple),
      q(p.revues),
      q(p.paragraphe_specifique),
      q(ETAT[h.statut] ?? "a_preparer"),
      envoyeLe ? `${q(envoyeLe)}::timestamptz` : "null",
    ].join(", ")})`,
  );
}

console.log(`-- Demandes d'accord : ${lignes.length} sociétés de l'atelier (${atelier}).
insert into public.demandes_accord
  (societe_slug, sigle, nom, type, specialite, site, priorite, nb_fiches, nb_porteuse, adresses, destinataires, exemple, revues, paragraphe_specifique, etat, envoye_le)
values
${lignes.join(",\n")}
on conflict (societe_slug) do update set
  sigle = excluded.sigle,
  nom = excluded.nom,
  type = excluded.type,
  specialite = excluded.specialite,
  site = excluded.site,
  priorite = excluded.priorite,
  nb_fiches = excluded.nb_fiches,
  nb_porteuse = excluded.nb_porteuse,
  adresses = case when demandes_accord.adresses = '[]'::jsonb then excluded.adresses else demandes_accord.adresses end,
  destinataires = case
    when cardinality(demandes_accord.destinataires) = 0 and demandes_accord.etat in ('a_preparer', 'pret') then excluded.destinataires
    else demandes_accord.destinataires end,
  exemple = coalesce(demandes_accord.exemple, excluded.exemple),
  revues = coalesce(demandes_accord.revues, excluded.revues),
  paragraphe_specifique = coalesce(demandes_accord.paragraphe_specifique, excluded.paragraphe_specifique),
  etat = case
    when demandes_accord.etat in ('a_preparer', 'pret', 'valide', 'erreur') and excluded.etat <> 'a_preparer' then excluded.etat
    else demandes_accord.etat end,
  envoye_le = coalesce(demandes_accord.envoye_le, excluded.envoye_le),
  modifie_le = now();`);
