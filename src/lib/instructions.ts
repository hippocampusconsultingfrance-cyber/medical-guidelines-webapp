// Instructions prêtes à copier pour Claude (ou un développeur), affichées
// dans le tableau de bord à côté de chaque suggestion ou signalement : elles
// reprennent tout le contexte utile pour corriger sans relire la page.

const DEPOT = "hippocampusconsultingfrance-cyber/medical-guidelines-webapp";
const SITE = "https://www.medical-guidelines.net";

export const CATEGORIES_SUGGESTION: Record<string, string> = {
  probleme: "Problème sur le site",
  amelioration: "Idée d'amélioration",
  contenu: "Contenu d'une fiche",
  autre: "Autre",
};

const cite = (t: string) => t.replace(/\s+/g, " ").trim();

export function instructionSuggestion(s: { categorie: string; page: string | null; message: string; created_at: string }) {
  const ou = s.page ? `sur la page ${SITE}${s.page}` : "sans page précise";
  const date = new Date(s.created_at).toLocaleDateString("fr-FR", { timeZone: "Europe/Paris" });
  const quoi =
    s.categorie === "probleme"
      ? "Reproduis le problème, trouve sa cause dans le code et corrige-la. Ajoute un test si c'est possible."
      : s.categorie === "amelioration"
        ? "Évalue l'idée : si elle est simple et sans risque, réalise-la ; sinon, propose-moi une solution avant de coder."
        : s.categorie === "contenu"
          ? "Vérifie le point dans la source officielle de la fiche avant toute modification ; ne change rien qui ne soit pas dans la source."
          : "Analyse la demande et propose-moi la suite à donner.";
  return [
    `Dépôt ${DEPOT}.`,
    `Un membre a envoyé le ${date} une suggestion (« ${CATEGORIES_SUGGESTION[s.categorie] ?? s.categorie} ») ${ou} :`,
    `« ${cite(s.message)} »`,
    quoi,
    "Explique-moi simplement ce que tu as fait, puis ouvre une pull request.",
  ].join("\n");
}

export function instructionSignalement(r: {
  doc_title: string | null;
  section: string | null;
  description: string;
  source_url?: string | null;
  doc_id?: string | null;
}) {
  return [
    `Dépôt ${DEPOT}.`,
    `Un membre signale une erreur dans la fiche « ${r.doc_title ?? "?"} »${r.doc_id ? ` (id ${r.doc_id})` : ""}${r.section ? `, section « ${cite(r.section)} »` : ""} :`,
    `« ${cite(r.description)} »`,
    r.source_url ? `Source officielle : ${r.source_url}` : "Source officielle : voir la fiche.",
    "1. Compare le passage signalé avec la source officielle et dis-moi si l'erreur est réelle.",
    "2. Si oui, propose la correction exacte (texte avant / après, grade et niveau de preuve repris tels quels de la source) et sa criticité (mineure, majeure ou critique) ; si elle est critique, dis-le-moi tout de suite pour dépublier la fiche.",
    "3. Après mon accord, applique la correction dans la fiche et rédige le résumé pour le journal public des corrections.",
  ].join("\n");
}
