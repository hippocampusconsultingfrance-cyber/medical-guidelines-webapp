// Doit rester égal à public.free_unlock_quota() (migration 20260928220000) :
// la base fait foi, cette valeur ne sert qu'à l'affichage.
export const FREE_QUOTA = 5;

// Les scripts d'import enregistrent au 1er janvier une source dont seule
// l'année est connue : on n'affiche alors que l'année, sans fausse précision.
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
};

/* ---------------------------------------------------------------------------
 * Rendu de presentation_json : portage fidèle du rendu de l'ancienne page
 * public/fiches/index.html (renderBlock, renderTable, renderLegend). Le HTML
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
    out += `<div class="legend__item"><span class="chip ${chipClass(chip.label)}">${chip.label}</span><span>${label && label.t === "p" ? label.html : ""}</span></div>`;
  }
  return `${out}</div>`;
}

function isHeaderRow(row: Cell[]) {
  return row.some((c) => c && c.t === "p" && (c.style === "head_w" || c.style === "head_w_c"));
}

function renderCell(c: Cell, tag: "td" | "th"): string {
  if (!c) return `<${tag}></${tag}>`;
  if (c.t === "chip") {
    return `<${tag} class="num"><span class="chip ${chipClass(c.label)}">${c.label}</span></${tag}>`;
  }
  if (c.t === "p") {
    const center = c.style === "cell_c" || c.style === "head_w_c";
    const inner = c.style === "cell_b" ? `<strong>${c.html}</strong>` : c.html;
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

function renderBlock(b: Block | null | undefined, toc: { counter: number; items: TocItem[] }): string {
  if (!b) return "";
  if (b.t === "section") {
    const id = slugify(b.text, toc.counter++);
    toc.items.push({ id, text: b.text });
    return `<h2 class="block-section" id="${id}">${b.text}</h2>`;
  }
  if (b.t === "p") {
    const cls = `block-p${b.style === "note" ? " is-note" : ""}${b.style === "source" ? " is-source" : ""}`;
    return `<p class="${cls}">${b.html}</p>`;
  }
  if (b.t === "panel") {
    return `<div class="panel ${b.tone || "default"}">${renderBlock(b.content, toc)}</div>`;
  }
  if (b.t === "table") return isLegendTable(b.rows) ? renderLegend(b.rows) : renderTable(b.rows);
  return "";
}

export function renderPresentation(p: Presentation) {
  const toc = { counter: 0, items: [] as TocItem[] };
  const html = (p.sections ?? [])
    .flatMap((s) => s.items ?? [])
    .map((b) => renderBlock(b, toc))
    .join("");
  return { html, toc: toc.items };
}
