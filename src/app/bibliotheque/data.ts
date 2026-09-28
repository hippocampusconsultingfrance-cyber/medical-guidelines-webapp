import type { SupabaseClient } from "@supabase/supabase-js";
import type { Card } from "@/lib/fiches";

export type LibraryDoc = {
  id: string;
  title: string;
  doc_type: string | null;
  publication_date: string | null;
  card_json: Card | null;
};

// Tout ce qu'affichent la barre latérale et le catalogue. Les droits sont
// appliqués par la base : un membre ne reçoit que les fiches publiées de sa
// spécialité, un relecteur reçoit aussi les brouillons.
export async function loadLibrary(supabase: SupabaseClient, userId: string) {
  const [{ data: documents }, { data: unlocks }, { data: premium }, { data: profile }] =
    await Promise.all([
      supabase
        .from("documents")
        .select("id, title, doc_type, publication_date, card_json")
        .order("publication_date", { ascending: false, nullsFirst: false })
        .order("title"),
      supabase.from("document_unlocks").select("document_id"),
      supabase.rpc("has_premium"),
      supabase.from("profiles").select("editorial_role").eq("id", userId).single(),
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
  }

  return {
    docs: (documents ?? []) as LibraryDoc[],
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
