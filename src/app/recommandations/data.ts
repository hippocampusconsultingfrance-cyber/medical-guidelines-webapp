import { createClient } from "@supabase/supabase-js";
import { unstable_cache } from "next/cache";
import { extraireApercu, type ApercuPublic } from "@/lib/apercu";
import { orderSocieties, type Card } from "@/lib/fiches";
import { createAdminClient } from "@/lib/supabase/admin";

export type PublicFiche = {
  id: string;
  fiche_key: string;
  title: string;
  doc_type: string | null;
  publication_date: string | null;
  source_url: string;
  card_json: Card | null;
  societies: string[];
  // Veille : « a_jour », « revision_detectee » ou « remplacee » (texte source
  // remplacé, superseded_by_document_id désignant la fiche qui le remplace).
  freshness_status: string | null;
  superseded_by_document_id: string | null;
};

type Row = Omit<PublicFiche, "societies"> & {
  document_societies: { societies: { acronym: string } | { acronym: string }[] | null }[] | null;
};

// Métadonnées publiques des fiches en ligne (jamais le contenu : la base ne
// le transmet qu'aux comptes autorisés), lues avec la clé publique et
// gardées 5 minutes en cache : accueil, catalogue, pages de résumé et images
// de partage ne réinterrogent plus la base à chaque visite. Publier ou
// retirer une fiche vide ce cache aussitôt (FICHES_PUBLIQUES, actions de la
// fiche) ; un réimport du contenu apparaît en 5 minutes au plus.
export const FICHES_PUBLIQUES = "fiches-publiques";

const toutesLesFiches = unstable_cache(
  async (): Promise<PublicFiche[]> => {
    const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!, {
      auth: { persistSession: false },
    });
    const { data, error } = await supabase
      .from("documents")
      .select(
        "id, fiche_key, title, doc_type, publication_date, source_url, card_json, freshness_status, superseded_by_document_id, document_societies(societies(acronym))",
      )
      .not("fiche_key", "is", null)
      .not("published_at", "is", null)
      .order("publication_date", { ascending: false, nullsFirst: false })
      .order("title");
    // Une erreur ne doit pas être gardée en cache comme une liste vide.
    if (error) throw new Error(`Lecture des fiches publiques : ${error.message}`);
    return ((data ?? []) as unknown as Row[]).map(({ document_societies, ...d }) => ({
      ...d,
      societies: orderSocieties(
        (document_societies ?? [])
          .flatMap((l) => (Array.isArray(l.societies) ? l.societies : l.societies ? [l.societies] : []))
          .map((s) => s.acronym),
        d.card_json?.society,
      ),
    }));
  },
  [FICHES_PUBLIQUES],
  { revalidate: 300, tags: [FICHES_PUBLIQUES] },
);

// Toutes les fiches en ligne (les plus récentes d'abord), une seule (key)
// ou les premières (limit).
export async function loadPublicFiches(key?: string, limit?: number) {
  const toutes = await toutesLesFiches();
  if (key) return toutes.filter((f) => f.fiche_key === key);
  return limit ? toutes.slice(0, limit) : toutes;
}

// Points clés validés par un médecin (3 à 5 par fiche), dont les 3 premiers
// sont montrés sur la page publique de la fiche. La colonne n'est lisible
// que par le serveur ; gardés 5 minutes en cache comme les métadonnées. Une
// lecture impossible n'empêche jamais d'afficher la page.
const pointsCles = unstable_cache(
  async (id: string): Promise<string[]> => {
    try {
      const { data } = await createAdminClient().from("documents").select("points_cles").eq("id", id).maybeSingle();
      const points = data?.points_cles;
      return Array.isArray(points) ? points.filter((p): p is string => typeof p === "string") : [];
    } catch {
      return [];
    }
  },
  ["points-cles-publics"],
  { revalidate: 300, tags: [FICHES_PUBLIQUES] },
);

export async function loadPointsClesPublics(id: string, nombre = 3) {
  return (await pointsCles(id)).slice(0, nombre);
}

// Aperçu public (champ et chapitres, voir @/lib/apercu), lu par le serveur et
// gardé 5 minutes en cache comme les points clés.
const apercu = unstable_cache(
  async (id: string): Promise<ApercuPublic> => {
    try {
      const { data } = await createAdminClient().from("documents").select("presentation_json").eq("id", id).maybeSingle();
      return extraireApercu(data?.presentation_json);
    } catch {
      return { champ: null, chapitres: [] };
    }
  },
  ["apercu-public"],
  { revalidate: 300, tags: [FICHES_PUBLIQUES] },
);

export async function loadApercuPublic(id: string) {
  return apercu(id);
}
