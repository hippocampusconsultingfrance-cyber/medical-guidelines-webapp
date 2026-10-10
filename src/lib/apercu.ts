import { texteLisible } from "@/lib/fiches";

// Aperçu public du contenu d'une fiche : le paragraphe d'ouverture quand il
// délimite le champ (« Champ… », « Objectif… », « Périmètre… » ; jamais un
// « Résumé », qui peut citer des recommandations), réduit à deux phrases, et
// les titres des chapitres. Aucune recommandation ni aucun grade n'en sort.
export type ApercuPublic = { champ: string | null; chapitres: string[] };

const CHAMP = /^(Champ|Objectif|Périmètre)[^:]{0,60}:\s*/i;
const CHAPITRE_ANNEXE = /^(Sources|Légende|Déclaration d'intérêts|Méthodologie|Avertissement)/i;
const ENTITES: Record<string, string> = { "&nbsp;": " ", "&amp;": "&", "&lt;": "<", "&gt;": ">", "&quot;": '"', "&#39;": "'", "&bull;": "•" };

function texteBrut(html: unknown) {
  if (typeof html !== "string") return "";
  return texteLisible(html)
    .replace(/<br\s*\/?>/gi, " ")
    .replace(/<\/?[a-zA-Z][^>]*>/g, "")
    .replace(/&[a-z#0-9]+;/gi, (e) => ENTITES[e] ?? e)
    .replace(/\s+/g, " ")
    .trim();
}

function deuxPhrases(texte: string, max = 450) {
  // Les phrases qui décrivent la fabrication de la fiche (« reproduit… »)
  // restent dans la fiche complète ; sans sa première phrase, le paragraphe
  // n'est pas montré.
  const phrases = texte.split(/(?<=[.!?])\s+(?=[A-ZÀ-ÖØ-Þ«(0-9])/).slice(0, 2);
  const fabrication = (p: string) => /reprodu|recopi/i.test(p);
  if (!phrases.length || fabrication(phrases[0])) return "";
  let out = "";
  for (const p of phrases.filter((p) => !fabrication(p))) {
    if (out && out.length + p.length + 1 > max) break;
    out = out ? `${out} ${p}` : p;
  }
  if (out.length <= max) return out;
  const coupe = out.slice(0, max);
  return `${coupe.slice(0, Math.max(coupe.lastIndexOf(", "), coupe.lastIndexOf(" ")))}…`;
}

type Bloc = { t?: string; text?: string; html?: string; content?: Bloc };

export function extraireApercu(presentation: unknown): ApercuPublic {
  const sections = (presentation as { sections?: { items?: Bloc[] }[] } | null)?.sections;
  const blocs = Array.isArray(sections) ? sections.flatMap((s) => (Array.isArray(s?.items) ? s.items : [])) : [];
  const chapitres = [
    ...new Set(
      blocs
        .filter((b) => b?.t === "section")
        .map((b) => texteBrut(b.text))
        .filter((t) => t && !CHAPITRE_ANNEXE.test(t)),
    ),
  ];
  const premier = blocs[0];
  const ouverture = texteBrut(premier?.t === "panel" ? premier.content?.html : premier?.t === "p" ? premier.html : "");
  const champ = CHAMP.test(ouverture) ? deuxPhrases(ouverture.replace(CHAMP, "")) : "";
  return { champ: champ ? champ.charAt(0).toUpperCase() + champ.slice(1) : null, chapitres };
}
