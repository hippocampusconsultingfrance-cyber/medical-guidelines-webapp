import type { SupabaseClient } from "@supabase/supabase-js";
import { orderSocieties, type Card } from "@/lib/fiches";

export type PublicFiche = {
  id: string;
  fiche_key: string;
  title: string;
  doc_type: string | null;
  publication_date: string | null;
  source_url: string;
  card_json: Card | null;
  societies: string[];
};

type Row = Omit<PublicFiche, "societies"> & {
  document_societies: { societies: { acronym: string } | { acronym: string }[] | null }[] | null;
};

// Métadonnées publiques des fiches en ligne (jamais le contenu : la base ne
// le transmet qu'aux comptes autorisés).
export async function loadPublicFiches(supabase: SupabaseClient, key?: string, limit?: number) {
  let query = supabase
    .from("documents")
    .select("id, fiche_key, title, doc_type, publication_date, source_url, card_json, document_societies(societies(acronym))")
    .not("fiche_key", "is", null)
    .not("published_at", "is", null)
    .order("publication_date", { ascending: false, nullsFirst: false })
    .order("title");
  if (key) query = query.eq("fiche_key", key);
  if (limit) query = query.limit(limit);
  const { data } = await query;
  return ((data ?? []) as unknown as Row[]).map(({ document_societies, ...d }) => ({
    ...d,
    societies: orderSocieties(
      (document_societies ?? [])
        .flatMap((l) => (Array.isArray(l.societies) ? l.societies : l.societies ? [l.societies] : []))
        .map((s) => s.acronym),
      d.card_json?.society,
    ),
  }));
}
