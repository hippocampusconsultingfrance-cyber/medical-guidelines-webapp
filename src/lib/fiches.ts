// Doit rester égal à public.free_unlock_quota() (migration 20260928220000) :
// la base fait foi, cette valeur ne sert qu'à l'affichage.
export const FREE_QUOTA = 5;

// Les scripts d'import enregistrent au 1er janvier une source dont seule
// l'année est connue : on n'affiche alors que l'année, sans fausse précision.
// Ancienneté de la source (cahier des charges §4.3) : au-delà de 10 ans, la
// fiche invite à vérifier qu'aucune actualisation n'a été publiée.
export const ANCIENNETE_MAX = 10;
export function avertissementAnciennete(publicationDate: string | null) {
  if (!publicationDate) return null;
  const annee = Number(publicationDate.slice(0, 4));
  const age = new Date().getUTCFullYear() - annee;
  if (!Number.isFinite(age) || age <= ANCIENNETE_MAX) return null;
  return `Recommandation publiée en ${annee}, il y a plus de ${ANCIENNETE_MAX} ans : vérifiez auprès de la société savante qu'aucune actualisation n'a été publiée depuis.`;
}

// Vérification de la source (cahier des charges §4.3) : dernière date de
// vérification (à défaut, date de publication de la fiche) et prochaine
// vérification prévue, à la fin du mois suivant.
export function verificationSource(verifiedAt: string | null, publishedAt: string | null) {
  const derniere = verifiedAt ?? publishedAt?.slice(0, 10) ?? null;
  if (!derniere) return null;
  const [y, m] = derniere.split("-").map(Number);
  const prochaine = new Date(Date.UTC(y, m + 1, 0)).toISOString().slice(0, 10);
  const jour = (v: string) => `${v.slice(8, 10)}/${v.slice(5, 7)}/${v.slice(0, 4)}`;
  return { derniere: jour(derniere), prochaine: jour(prochaine) };
}

export function formatDate(value: string | null) {
  if (!value) return null;
  if (value.endsWith("-01-01")) return value.slice(0, 4);
  return new Date(`${value}T00:00:00Z`).toLocaleDateString("fr-FR", {
    day: "numeric",
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  });
}

// Carte d'une fiche dans le catalogue (documents.card_json, lisible par tous).
export type Card = {
  badge?: string;
  title?: string;
  short?: string;
  society?: string;
  version?: string;
  validated?: string;
  methodology?: string;
  pages?: number;
  section?: string;
};

/* ---------------------------------------------------------------------------
 * Rendu de presentation_json : portage fidèle du rendu de l'atelier
 * (rfe-sfar-website, site/app.js : renderBlock, renderTable, renderLegend). Le HTML
 * des blocs provient du pipeline éditorial de l'atelier (contenu de
 * confiance, jamais saisi par un utilisateur) et est inséré tel quel, comme
 * dans l'ancienne page.
 * ------------------------------------------------------------------------- */
type Cell =
  | null
  | { t: "chip"; label: string }
  | { t: "p"; html: string; style?: string }
  | { t: "table"; rows: Cell[][] };
type Block =
  | { t: "section"; text: string }
  | { t: "p"; html: string; style?: string }
  | { t: "panel"; tone?: string; content: Block }
  | { t: "table"; rows: Cell[][] };
export type Presentation = { sections: { items: Block[] }[] };
export type TocItem = { id: string; text: string };

const CHIP_CLASS: Record<string, string> = {
  "1+": "chip-good",
  A: "chip-good",
  "2+": "chip-accent",
  B: "chip-accent",
  "2-": "chip-warn",
  C: "chip-warn",
  "1-": "chip-crit",
  AE: "chip-neutral",
};

export function chipClass(label: string | null | undefined) {
  return (label && CHIP_CLASS[label]) || "chip-neutral";
}

export function escapeHtml(s: string) {
  return s.replace(/[&<>"']/g, (c) => `&#${c.charCodeAt(0)};`);
}

function slugify(s: string, i: number) {
  const base = (s || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
  return `${base || "section"}-${i}`;
}

function isLegendTable(rows: Cell[][]) {
  return (
    rows.length === 1 &&
    rows[0].every((c) => c && (c.t === "chip" || (c.t === "p" && c.style === "badge_head")))
  );
}

function renderLegend(rows: Cell[][]) {
  const cells = rows[0];
  let out = '<div class="legend">';
  for (let i = 0; i < cells.length; i += 2) {
    const chip = cells[i];
    const label = cells[i + 1];
    if (!chip || chip.t !== "chip") continue;
    out += `<div class="legend__item"><span class="chip ${chipClass(chip.label)}">${nettoyerHtml(chip.label)}</span><span>${label && label.t === "p" ? nettoyerHtml(label.html) : ""}</span></div>`;
  }
  return `${out}</div>`;
}

function isHeaderRow(row: Cell[]) {
  return row.some((c) => c && c.t === "p" && (c.style === "head_w" || c.style === "head_w_c"));
}

function renderCell(c: Cell, tag: "td" | "th"): string {
  if (!c) return `<${tag}></${tag}>`;
  if (c.t === "chip") {
    return `<${tag} class="num"><span class="chip ${chipClass(c.label)}">${nettoyerHtml(c.label)}</span></${tag}>`;
  }
  if (c.t === "p") {
    const center = c.style === "cell_c" || c.style === "head_w_c";
    const inner = c.style === "cell_b" ? `<strong>${nettoyerHtml(c.html)}</strong>` : nettoyerHtml(c.html);
    return `<${tag}${center ? ' class="align-c"' : ""}>${inner}</${tag}>`;
  }
  if (c.t === "table") return `<${tag}>${renderTable(c.rows)}</${tag}>`;
  return `<${tag}></${tag}>`;
}

function renderTable(rows: Cell[][]) {
  if (!rows?.length) return "";
  let html = '<div class="table-scroll"><table class="rfe">';
  let body = rows;
  if (isHeaderRow(rows[0])) {
    html += `<thead><tr>${rows[0].map((c) => renderCell(c, "th")).join("")}</tr></thead>`;
    body = rows.slice(1);
  }
  html += `<tbody>${body.map((r) => `<tr>${r.map((c) => renderCell(c, "td")).join("")}</tr>`).join("")}</tbody>`;
  return `${html}</table></div>`;
}

// Nettoyage des fragments HTML du contenu des fiches (défense en profondeur,
// en plus de la CSP stricte) : seules les balises de mise en forme produites
// par l'atelier sont gardées (gras, italique, exposant, indice, code, saut de
// ligne, couleur de texte) ; toute autre balise, tout attribut (sauf une
// couleur #hex) et tout chevron isolé sont neutralisés en texte.
const BALISES = new Set(["b", "strong", "i", "em", "u", "br", "sup", "sub", "super", "code", "font", "span"]);
export function nettoyerHtml(brut: unknown): string {
  if (typeof brut !== "string") return brut == null ? "" : escapeHtml(String(brut));
  const fragment = texteLisible(brut);
  let out = "";
  let last = 0;
  const re = /<(\/?)([a-zA-Z][a-zA-Z0-9]*)([^<>]*)>/g;
  const texte = (t: string) => t.replace(/</g, "&lt;").replace(/>/g, "&gt;");
  for (let m = re.exec(fragment); m; m = re.exec(fragment)) {
    out += texte(fragment.slice(last, m.index));
    last = re.lastIndex;
    const [, fin, nomBrut, attrs] = m;
    const nom = nomBrut.toLowerCase();
    if (!BALISES.has(nom)) {
      out += escapeHtml(m[0]);
      continue;
    }
    if (nom === "br") {
      out += "<br>";
      continue;
    }
    if (fin) {
      out += `</${nom}>`;
      continue;
    }
    const couleur = nom === "font" ? /color\s*=\s*\\?["']?(#[0-9a-fA-F]{3,8})/.exec(attrs)?.[1] : undefined;
    out += couleur ? `<font color="${couleur}">` : `<${nom}>`;
  }
  return out + texte(fragment.slice(last));
}

function renderBlock(b: Block | null | undefined, toc: { counter: number; items: TocItem[] }): string {
  if (!b) return "";
  if (b.t === "section") {
    const id = slugify(b.text, toc.counter++);
    toc.items.push({ id, text: b.text });
    return `<h2 class="block-section" id="${id}">${nettoyerHtml(b.text)}</h2>`;
  }
  if (b.t === "p") {
    const cls = `block-p${b.style === "note" ? " is-note" : ""}${b.style === "source" ? " is-source" : ""}`;
    return `<p class="${cls}">${nettoyerHtml(b.html)}</p>`;
  }
  if (b.t === "panel") {
    return `<div class="panel ${/^[a-z_-]{1,20}$/.test(b.tone ?? "") ? b.tone : "default"}">${renderBlock(b.content, toc)}</div>`;
  }
  if (b.t === "table") return isLegendTable(b.rows) ? renderLegend(b.rows) : renderTable(b.rows);
  return "";
}

// Affichage en accordéon : chaque section de la fiche devient un bloc
// repliable (<details>), la première ouverte. Les blocs placés avant la
// première section (principe général, légende) restent toujours visibles.
export function accordion(title: string, id: string, body: string, open: boolean) {
  return (
    `<details class="acc" id="${id}"${open ? " open" : ""}>` +
    `<summary class="acc__title">${title}</summary><div class="acc__body">${body}</div></details>`
  );
}

export function renderPresentation(p: Presentation) {
  const toc = { counter: 0, items: [] as TocItem[] };
  let html = "";
  let current: { id: string; title: string; body: string } | null = null;
  const flush = () => {
    if (current) html += accordion(current.title, current.id, current.body, current.id === toc.items[0]?.id);
  };
  for (const b of (p.sections ?? []).flatMap((s) => s.items ?? [])) {
    if (b?.t === "section") {
      flush();
      const id = slugify(b.text, toc.counter++);
      toc.items.push({ id, text: b.text });
      current = { id, title: nettoyerHtml(b.text), body: "" };
    } else if (current) {
      current.body += renderBlock(b, toc);
    } else {
      html += renderBlock(b, toc);
    }
  }
  flush();
  return { html, toc: toc.items };
}

// Sociétés dans l'ordre de la mention de la carte (société porteuse en
// premier), les autres ensuite par ordre alphabétique.
export function orderSocieties(societies: string[], mention: string | undefined) {
  const head = (mention ?? "").split("—")[0];
  const rank = (s: string) => {
    const i = head.search(new RegExp(`\\b${s.replace(/[^A-Za-z0-9]/g, "")}\\b`));
    return i < 0 ? Number.MAX_SAFE_INTEGER : i;
  };
  return [...societies].sort((a, b) => rank(a) - rank(b) || a.localeCompare(b));
}

// Termes internes de l'atelier restés dans le texte des fiches (« chip »,
// « disclosure », « grep », « tag », notes sur le dépôt de l'atelier) :
// remplacés à l'affichage par des formulations lisibles, sans toucher au
// sens, aux chiffres ni aux grades, pour que la correction survive aux
// réimports du contenu. Les règles particulières passent avant les
// générales.
const JARGON: [RegExp, string][] = [
  // Notes sur le processus de l'atelier, sans intérêt pour le lecteur.
  [/ — trouvé (?:hors du processus habituel de ce dépôt )?(?:via recherche web )?\(absent de <code>library_final\.json<\/code>[^)]*\)(?:, via recherche web)?\./g, "."],
  [/l'index interne du projet \(`library_final\.json`\)/g, "l'index interne du projet"],
  [/ \(grep monoligne\)/g, ""],
  [/un grep naïf ligne-par-ligne/g, "un comptage automatique ligne par ligne"],
  [/Vérifié exhaustivement par grep \(([^)]*)\)/g, "Vérifié exhaustivement ($1)"],
  [/Vérifié par grep exhaustif/g, "Vérifié une à une"],
  [/par grep exhaustif/g, "une à une"],
  [/\bgrep\b/g, "recherche automatique"],
  // Renvois et signalements.
  [/\(disclosure en page 1 de la fiche\)/g, "(précisé en tête de la fiche)"],
  [/voir disclosure méthodologique en page 1(?: de la fiche)?/g, "voir la note méthodologique en tête de la fiche"],
  [/disclosure d'une incohérence source-interne/g, "incohérence interne à la source signalée"],
  [/(\d+) divergences source-internes disclosées/g, "$1 incohérences internes à la source signalées"],
  [/source-internes/g, "internes à la source"],
  [/source-interne/g, "interne à la source"],
  [/résolution textuelle disclosée/g, "force déduite du texte"],
  [/disclosurée/g, "signalée"],
  [/disclosées/g, "signalées"],
  [/disclosée/g, "signalée"],
  [/disclosés/g, "signalés"],
  [/disclosé(?![a-zé])/g, "signalé"],
  [/couverts par ce dépôt/g, "couverts par ce site"],
  [/\(disclosed\)/g, "(signalé)"],
  [/\(disclosed, /g, "(signalé, "],
  [/incohérence disclosed/g, "incohérence signalée"],
  [/\bdisclosed\b/g, "signalé"],
  [/Disclosure/g, "Précision"],
  [/disclosure/g, "précision"],
  [/en page 1 de la fiche/g, "en tête de la fiche"],
  // « page 1 » de la fiche (jamais « page 1 du texte source »).
  [/\b(?:en )?page 1\b(?! du| de la source)/g, "en tête de la fiche"],
  // Vocabulaire de mise en page.
  [/[Cc]hips? « /g, "« "],
  [/\bChip\b/g, "Étiquette"],
  [/\bchips\b/g, "étiquettes"],
  [/\bchip\b/g, "étiquette"],
  [/taguées/g, "gradées"],
  [/tagués/g, "gradés"],
  [/taguée/g, "gradée"],
  [/tagué/g, "gradé"],
  [/\btags\b/g, "mentions de grade"],
  [/\btag\b/g, "mention de grade"],
  [/(ACTUALISE|Actualise)\/(?:SUPERSEDE|supersede)/g, "$1"],
  [/\bsuperseded\b/gi, "remplacée"],
  [/\bsupersedes?\b/gi, "remplace"],
  [/seule tier numérique présente/g, "seul niveau numérique présent"],
  [/convention bespoke propre/g, "convention propre"],
  [/convention bespoke/g, "convention propre à ce document"],
  [/\b(par|à|de) le source\b/g, "$1 la source"],
  [/\ble source\b/g, "la source"],
];

// Décomptes du champ « Méthodologie » de la carte (« AE:13 », « GRADE1 ») :
// propres à ce champ, jamais appliqués au contenu (doses « 1:1000 »).
const DECOMPTES: [RegExp, string][] = [
  [/GRADE([12])\b/g, "GRADE $1"],
  [/([\wÉ/+-]+(?: \d)?):(\d+)/g, "$1 : $2"],
];

const appliquer = (texte: string, regles: [RegExp, string][]) =>
  regles.reduce((t, [motif, remplacement]) => t.replace(motif, remplacement), texte);

// Fiches citées dans les notes méthodologiques par leur clé technique (ou
// par le script de l'atelier, « fiche_<clé>.py ») : remplacées par leur titre.
// Seules des clés composées (avec « _ ») sont listées, jamais un mot courant.
const FICHES_CITEES: Record<string, string> = {
  anesth_pediatrique_structures: "Structures et matériel de l'anesthésie pédiatrique",
  erreurs_medicamenteuses_ar_2016: "Prévention des erreurs médicamenteuses en anesthésie-réanimation (actualisation 2016)",
  intubation_difficile_adulte: "Intubation difficile & extubation (adulte)",
  postop_2006: "Les blocs périmédullaires chez l'adulte — Analgésie postopératoire (Q8/15)",
  raac_lobectomie_pulmonaire_2019: "Réhabilitation améliorée après lobectomie pulmonaire",
  raac_orthopedique_2019: "Réhabilitation améliorée — arthroplastie de hanche/genou",
  resection_hepatique_2025: "Prise en charge péri-opératoire — Résection hépatique",
  sujet_age_esf: "Anesthésie du sujet âgé — exemple de la FESF",
  voies_aeriennes_adulte: "Voies aériennes en anesthésie adulte",
};
const CLE_CITEE = new RegExp(
  // Jamais à l'intérieur d'une adresse (« /…/cle.pdf »).
  `(?:<code>|<i>)?(?<![/\\w.-])(fiche_)?(${Object.keys(FICHES_CITEES).join("|")})(?:\\.py)?\\b(?![/.-]\\w)(?:</code>|</i>)?`,
  "g",
);
const REFERENCES: [RegExp, string][] = [
  [/ déjà git-trackée/g, ""],
  [/\(grade_chip\)/g, "(étiquette de grade colorée)"],
  [/le funnel_diagram de la fiche/g, "le schéma en entonnoir de la fiche"],
  [/\(cf\. la fiche/g, "(voir la fiche"],
];

export function texteLisible(texte: string) {
  const cites = texte.replace(CLE_CITEE, (_tout, script: string | undefined, cle: string) =>
    `${script ? "la fiche " : ""}« ${FICHES_CITEES[cle]} »`,
  );
  return appliquer(appliquer(cites, REFERENCES), JARGON);
}

export function methodologieLisible(texte: string) {
  return appliquer(texteLisible(texte), DECOMPTES);
}
