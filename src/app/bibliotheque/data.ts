import type { SupabaseClient } from "@supabase/supabase-js";
import { orderSocieties, type Card } from "@/lib/fiches";

export type LibraryDoc = {
  id: string;
  title: string;
  doc_type: string | null;
  publication_date: string | null;
  card_json: Card | null;
  published_at: string | null;
  freshness_status: string | null;
  societies: string[];
};

// Statut de fraîcheur (cahier des charges §5.4), libellés affichés.
export const FRESHNESS_LABEL: Record<string, string> = {
  revision_detectee: "Révision détectée",
  remplacee: "Remplacée",
  retiree: "Retirée",
};

// Tout ce qu'affichent la barre latérale et le catalogue. Les droits sont
// appliqués par la base : un membre ne reçoit que les fiches publiées de sa
// spécialité, un relecteur reçoit aussi les brouillons.
export async function loadLibrary(supabase: SupabaseClient, userId: string) {
  const [{ data: documents }, { data: unlocks }, { data: premium }, { data: profile }, { data: favorites }] =
    await Promise.all([
      supabase
        .from("documents")
        .select(
          "id, title, doc_type, publication_date, card_json, published_at, freshness_status, document_societies(societies(acronym, full_name))",
        )
        .order("publication_date", { ascending: false, nullsFirst: false })
        .order("title"),
      // Filtre explicite : un administrateur lit aussi les déblocages des autres comptes.
      supabase.from("document_unlocks").select("document_id").eq("user_id", userId),
      supabase.rpc("has_premium"),
      supabase
        .from("profiles")
        .select("editorial_role, specialty:specialties(name_i18n)")
        .eq("id", userId)
        .single(),
      supabase
        .from("favorites")
        .select("document_id")
        .eq("user_id", userId)
        .not("document_id", "is", null)
        .order("created_at", { ascending: false }),
    ]);

  const role = (profile?.editorial_role as string | null) ?? null;
  const isEditor = Boolean(role);
  let published = new Set<string>();
  if (isEditor) {
    const { data: status } = await supabase.rpc("document_publication_status");
    published = new Set(
      ((status ?? []) as { document_id: string; active: number }[])
        .filter((s) => s.active > 0)
        .map((s) => s.document_id),
    );
    for (const d of (documents ?? []) as { id: string; published_at: string | null }[]) {
      if (d.published_at) published.add(d.id);
    }
  }

  const spec = profile?.specialty as
    | { name_i18n: { fr?: string } | null }
    | { name_i18n: { fr?: string } | null }[]
    | null
    | undefined;
  const specialty = (Array.isArray(spec) ? spec[0] : spec)?.name_i18n?.fr ?? null;

  type Society = { acronym: string; full_name: string | null };
  type Row = Omit<LibraryDoc, "societies"> & {
    document_societies: { societies: Society | Society[] | null }[] | null;
  };
  // Nom complet de chaque sigle, pour l'infobulle (vide s'il n'est pas connu).
  const societyNames: Record<string, string> = {};
  const docs: LibraryDoc[] = ((documents ?? []) as unknown as Row[]).map(({ document_societies, ...d }) => {
    const list = (document_societies ?? []).flatMap((l) =>
      Array.isArray(l.societies) ? l.societies : l.societies ? [l.societies] : [],
    );
    for (const s of list) if (s.full_name) societyNames[s.acronym] = s.full_name;
    return {
      ...d,
      societies: orderSocieties(
        list.map((s) => s.acronym),
        d.card_json?.society,
      ),
    };
  });
  const favoriteIds = ((favorites ?? []) as { document_id: string }[]).map((f) => f.document_id);

  return {
    specialty,
    docs,
    societyNames,
    unlocked: new Set((unlocks ?? []).map((u) => u.document_id as string)),
    // Du plus récent au plus ancien.
    favorites: favoriteIds,
    favorite: new Set(favoriteIds),
    premium: Boolean(premium),
    isEditor,
    // Publication réservée aux validateurs et administrateurs.
    canPublish: role === "validateur" || role === "admin",
    isAdmin: role === "admin",
    published,
  };
}

export type Library = Awaited<ReturnType<typeof loadLibrary>>;

export function docState(lib: Library, id: string): "draft" | "open" | "lock" {
  if (lib.isEditor && !lib.published.has(id)) return "draft";
  if (lib.isEditor || lib.premium || lib.unlocked.has(id)) return "open";
  return "lock";
}

export function cardTitle(d: LibraryDoc) {
  return d.card_json?.title ?? d.title;
}

// Rubriques de la barre latérale, dans cet ordre ; les autres à la suite.
const SECTION_ORDER = ["Anesthésie", "Réanimation", "Urgences", "Obstétrique", "Pédiatrie"];

export function groupBySection<T extends Pick<LibraryDoc, "card_json">>(docs: T[]) {
  const groups = new Map<string, T[]>();
  for (const d of docs) {
    const section = d.card_json?.section ?? "Autres";
    groups.set(section, [...(groups.get(section) ?? []), d]);
  }
  const rank = (s: string) => {
    const i = SECTION_ORDER.indexOf(s);
    return i < 0 ? (s === "Autres" ? 99 : 50) : i;
  };
  return [...groups.entries()].sort(([a], [b]) => rank(a) - rank(b) || a.localeCompare(b, "fr"));
}

// Sociétés savantes présentes dans le catalogue, de la plus représentée à la
// moins représentée (filtre de la bibliothèque).
export function societyCounts(docs: LibraryDoc[]) {
  const counts = new Map<string, number>();
  for (const d of docs) for (const s of d.societies) counts.set(s, (counts.get(s) ?? 0) + 1);
  return [...counts.entries()].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]));
}
