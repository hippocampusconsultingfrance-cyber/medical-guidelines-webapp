// Détection des fiches probablement remplacées par une version plus récente
// (même sujet, sociétés communes, publication plus récente d'au moins deux
// ans). Simple rapprochement des titres : chaque proposition est validée ou
// écartée par un validateur (/bibliotheque/actualisations), jamais appliquée
// automatiquement.

export type FicheActu = {
  id: string;
  titre: string;
  date: string | null;
  statut: string | null;
  societes: string[];
};

export type Proposition = { ancienne: FicheActu; nouvelle: FicheActu; score: number };

const VIDES = new Set(
  "les des del dans pour par sur une aux avec chez hors entre sans prise charge recommandations recommandation generales gestion actualisation reactualisation phase exemple apres avant lors non tout tous".split(
    " ",
  ),
);
// Sigles développés, pour rapprocher « ALR » de « anesthésie locorégionale ».
const SIGLES: Record<string, string[]> = {
  alr: ["anest", "locor"],
  aap: ["agent", "antip"],
  tih: ["throm", "induit", "hepar"],
  aod: ["antic", "oraux"],
  nvpo: ["nause", "vomis"],
};
const ENFANT = new Set(["enfan", "pedia"]);
// Mots trop généraux dans ce catalogue pour rapprocher deux sujets.
const GENERIQUES = new Set(
  "anest urgen grave soins criti perio reani chiru medec struc organ patie adult prise charg aigue".split(" "),
);

function mots(titre: string) {
  const out = new Set<string>();
  const brut = titre
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, " ")
    .split(" ");
  for (const m of brut) {
    if (SIGLES[m]) SIGLES[m].forEach((s) => out.add(s));
    else if (m.length >= 3 && !/^\d+$/.test(m) && !/^q\d/.test(m) && !VIDES.has(m)) out.add(m.slice(0, 5));
  }
  return out;
}

const annee = (d: string | null) => (d ? Number(d.slice(0, 4)) : null);

export function proposerActualisations(fiches: FicheActu[], ecartees: Set<string>): Proposition[] {
  const base = fiches.map((f) => ({ f, m: mots(f.titre), a: annee(f.date) }));
  const out: Proposition[] = [];
  for (const anc of base) {
    if (anc.a === null || anc.f.statut === "remplacee" || anc.f.statut === "retiree") continue;
    let best: Proposition | null = null;
    for (const nouv of base) {
      if (nouv.f.id === anc.f.id || nouv.a === null || nouv.a - anc.a < 2) continue;
      if (nouv.f.statut === "remplacee" || nouv.f.statut === "retiree") continue;
      if (ecartees.has(`${anc.f.id}:${nouv.f.id}`)) continue;
      if (!anc.f.societes.some((s) => nouv.f.societes.includes(s))) continue;
      // Populations différentes (adulte / enfant) : pas un remplacement.
      const enfA = [...anc.m].some((x) => ENFANT.has(x));
      const enfN = [...nouv.m].some((x) => ENFANT.has(x));
      if ((anc.m.has("adult") && enfN && !enfA) || (nouv.m.has("adult") && enfA && !enfN)) continue;
      // Parties d'une même série (« Titre — partie A » / « Titre — partie B »).
      const [pa, sa] = anc.f.titre.split(" — ");
      const [pn, sn] = nouv.f.titre.split(" — ");
      if (sa && sn && pa === pn && sa !== sn && !/actualis/i.test(sn)) continue;
      // Cadres différents (réanimation / urgence) : sujets distincts.
      if (anc.m.has("reani") !== nouv.m.has("reani") && (anc.m.has("urgen") || nouv.m.has("urgen"))) continue;
      const a = [...anc.m].filter((x) => !GENERIQUES.has(x));
      const n = new Set([...nouv.m].filter((x) => !GENERIQUES.has(x)));
      if (!a.length || !n.size) continue;
      const partages = a.filter((x) => n.has(x));
      const communs = partages.length;
      const score = communs / Math.min(a.length, n.size);
      // Une population seule (enfant, pédiatrie) ne fait pas un même sujet.
      if (partages.every((x) => ENFANT.has(x))) continue;
      const ok = (score >= 0.75 && communs >= 2) || (score === 1 && communs === 1 && a.length <= 2 && n.size <= 2);
      if (ok && (!best || score > best.score || (score === best.score && (nouv.a ?? 0) > (annee(best.nouvelle.date) ?? 0))))
        best = { ancienne: anc.f, nouvelle: nouv.f, score };
    }
    if (best) out.push(best);
  }
  return out.sort((x, y) => y.score - x.score || x.ancienne.titre.localeCompare(y.ancienne.titre, "fr"));
}

// Fiches publiées et propositions écartées, puis propositions restantes.
// Sans la migration des propositions écartées, aucune n'est écartée.
export async function chargerPropositions(supabase: import("@supabase/supabase-js").SupabaseClient) {
  const [{ data: docs }, { data: ec }] = await Promise.all([
    supabase
      .from("documents")
      .select("id, title, card_json, publication_date, freshness_status, document_societies(societies(acronym))")
      .not("published_at", "is", null),
    supabase.from("actualisations_ecartees").select("ancienne_id, nouvelle_id"),
  ]);
  type Row = {
    id: string;
    title: string;
    card_json: { title?: string } | null;
    publication_date: string | null;
    freshness_status: string | null;
    document_societies: { societies: { acronym: string } | { acronym: string }[] | null }[] | null;
  };
  const fiches: FicheActu[] = ((docs ?? []) as unknown as Row[]).map((d) => ({
    id: d.id,
    titre: d.card_json?.title ?? d.title,
    date: d.publication_date,
    statut: d.freshness_status,
    societes: (d.document_societies ?? [])
      .flatMap((l) => (Array.isArray(l.societies) ? l.societies : l.societies ? [l.societies] : []))
      .map((s) => s.acronym),
  }));
  const ecartees = new Set(((ec ?? []) as { ancienne_id: string; nouvelle_id: string }[]).map((e) => `${e.ancienne_id}:${e.nouvelle_id}`));
  return proposerActualisations(fiches, ecartees);
}
