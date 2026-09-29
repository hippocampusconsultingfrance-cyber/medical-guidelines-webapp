import type { SupabaseClient } from "@supabase/supabase-js";
import type { Card } from "@/lib/fiches";

export type LibraryDoc = {
  id: string;
  title: string;
  doc_type: string | null;
  publication_date: string | null;
  card_json: Card | null;
  published_at: string | null;
  societies: string[];
};

// Tout ce qu'affichent la barre latérale et le catalogue. Les droits sont
// appliqués par la base : un membre ne reçoit que les fiches publiées de sa
// spécialité, un relecteur reçoit aussi les brouillons.
export async function loadLibrary(supabase: SupabaseClient, userId: string) {
  const [{ data: documents }, { data: unlocks }, { data: premium }, { data: profile }] =
    await Promise.all([
      supabase
        .from("documents")
        .select("id, title, doc_type, publication_date, card_json, published_at, document_societies(societies(acronym))")
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

  type Row = Omit<LibraryDoc, "societies"> & {
    document_societies: { societies: { acronym: string } | { acronym: string }[] | null }[] | null;
  };
  const docs: LibraryDoc[] = ((documents ?? []) as unknown as Row[]).map(({ document_societies, ...d }) => ({
    ...d,
    societies: (document_societies ?? [])
      .flatMap((l) => (Array.isArray(l.societies) ? l.societies : l.societies ? [l.societies] : []))
      .map((s) => s.acronym),
  }));

  return {
    specialty,
    docs,
    unlocked: new Set((unlocks ?? []).map((u) => u.document_id as string)),
    premium: Boolean(premium),
    isEditor,
    // Publication réservée aux validateurs et administrateurs.
    canPublish: role === "validateur" || role === "admin",
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

export function groupBySection(docs: LibraryDoc[]) {
  const groups = new Map<string, LibraryDoc[]>();
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
