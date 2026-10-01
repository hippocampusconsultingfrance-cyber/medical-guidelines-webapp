import "server-only";
import { PROFESSION_GROUPS } from "@/lib/professions";
import type { createClient } from "@/lib/supabase/server";

// Titre « Dr » pour les médecins, chirurgiens-dentistes et pharmaciens.
const DOCTEURS = new Set(
  PROFESSION_GROUPS.filter((g) => g.label === "Médecins" || g.label === "Odontologie et pharmacie").flatMap((g) => g.options),
);

// Mention « Relue par Dr …, le … » signée par le validateur connecté (nom
// pris dans son profil par la base).
export async function signerRelecture(supabase: Awaited<ReturnType<typeof createClient>>, id: string) {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { error: { message: "non connecté" } };
  const { data: profil } = await supabase.from("profiles").select("profession").eq("id", user.id).maybeSingle();
  return supabase.rpc("marquer_relue", { doc_id: id, docteur: DOCTEURS.has((profil?.profession as string | null) ?? "") });
}
