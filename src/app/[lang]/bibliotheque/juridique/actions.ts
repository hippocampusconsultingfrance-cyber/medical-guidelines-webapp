"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { CHAMPS } from "./champs";

const UUID = /^[0-9a-f-]{36}$/i;

// Enregistre le profil juridique de toutes les fiches d'une société
// porteuse (ou de la seule fiche indiquée). Validateur ou administrateur :
// le droit d'écriture est vérifié par la base (RLS) et chaque modification
// est tracée dans le journal d'administration.
export async function enregistrerProfil(formData: FormData) {
  const societe = String(formData.get("societe") ?? "");
  const fiche = String(formData.get("fiche") ?? "");
  if (societe !== "aucune" && !UUID.test(societe)) redirect("/bibliotheque/juridique");
  if (fiche && !UUID.test(fiche)) redirect("/bibliotheque/juridique");

  const profil: Record<string, string | null> = {};
  for (const c of CHAMPS) {
    const v = String(formData.get(c.nom) ?? "");
    if (!c.options.some(([val]) => val === v)) redirect("/bibliotheque/juridique?r=invalide");
    profil[c.nom] = v || null;
  }
  const notes = String(formData.get("legal_notes") ?? "").trim().slice(0, 2000);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  let ids: string[];
  if (fiche) {
    ids = [fiche];
  } else {
    let q = supabase.from("documents").select("id");
    q = societe === "aucune" ? q.is("society_id", null) : q.eq("society_id", societe);
    const { data } = await q;
    ids = (data ?? []).map((d) => d.id as string);
  }
  if (!ids.length) redirect("/bibliotheque/juridique?r=vide");

  const { error } = await supabase.from("source_legal_profiles").upsert(
    ids.map((id) => ({
      document_id: id,
      ...profil,
      copyright_status: profil.copyright_status ?? "a_verifier",
      legal_review_status: profil.legal_review_status ?? "non_revu",
      legal_notes: notes || null,
      updated_at: new Date().toISOString(),
    })),
    { onConflict: "document_id" },
  );
  redirect(`/bibliotheque/juridique?r=${error ? "erreur" : `ok_${ids.length}`}`);
}
