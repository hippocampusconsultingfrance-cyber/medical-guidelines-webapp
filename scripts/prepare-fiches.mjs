// Prépare public/fiches/index.html avant chaque build (npm run build).
//
// Ce fichier est généré dans le dépôt rfe-sfar-website au format « artefact »
// claude.ai : il n'a ni doctype ni balise viewport, car claude.ai l'enveloppe
// à la publication. Servi tel quel par le site, il s'affiche en mode de
// compatibilité et en largeur ordinateur sur téléphone. On ajoute ici
// l'enveloppe manquante et le pont des signalements d'erreurs. Le script est
// idempotent (le bloc inséré est régénéré à chaque passage) : les
// synchronisations qui écrasent le fichier sont corrigées au build suivant.
import { readFileSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const file = fileURLToPath(new URL("../public/fiches/index.html", import.meta.url));
const START = "<!-- prepare-fiches -->";
const END = "<!-- /prepare-fiches -->";

let html = readFileSync(file, "utf8").replace(/^\uFEFF/, "");

// Retire un bloc déjà inséré (build précédent) pour le régénérer à jour.
const endIndex = html.indexOf(END);
if (html.includes(START) && endIndex !== -1) {
  html = html.slice(endIndex + END.length).trimStart();
}

// Retire un éventuel doctype/charset d'origine pour éviter les doublons.
html = html
  .replace(/^\s*<!doctype html>\s*/i, "")
  .replace(/^\s*<html lang="fr">\s*/i, "")
  .replace(/^\s*<meta charset="UTF-8">\s*/i, "");

const head = [
  "<!doctype html>",
  '<html lang="fr">',
  START,
  '<meta charset="utf-8">',
  '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">',
  '<meta name="robots" content="noindex, nofollow">',
  // Sur téléphone, les cartes de la grille débordaient à cause de lignes
  // insécables (sociétés savantes, nombre de pages).
  "<style>.doc-grid>*{min-width:0}.doc-card{overflow-wrap:anywhere}</style>",
  '<script src="/fiches/signalements-bridge.js"></script>',
  END,
  "",
].join("\n");

writeFileSync(file, head + html);
console.log("prepare-fiches : doctype, viewport et pont des signalements ajoutés");
