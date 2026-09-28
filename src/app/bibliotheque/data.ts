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

  const isEditor = Boolean(profile?.editorial_role);
  let published = new Set<string>();
  if (isEditor) {
    const { data: active } = await supabase
      .from("recommendations")
      .select("document_id")
      .eq("status", "active");
    published = new Set((active ?? []).map((r) => r.document_id as string));
  }

  return {
    docs: (documents ?? []) as LibraryDoc[],
    unlocked: new Set((unlocks ?? []).map((u) => u.document_id as string)),
    premium: Boolean(premium),
    isEditor,
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
