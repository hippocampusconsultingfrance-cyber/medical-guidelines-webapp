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
export function nettoyerHtml(fragment: unknown): string {
  if (typeof fragment !== "string") return fragment == null ? "" : escapeHtml(String(fragment));
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
