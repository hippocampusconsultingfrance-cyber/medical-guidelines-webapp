"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Validation (avec retouche possible) ou refus d'une reformulation. Droit de
// validateur, fiche inchangée et traçabilité vérifiés par la base.
export async function deciderReformulation(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const fiche = String(formData.get("fiche") ?? "");
  const decision = formData.get("decision");
  const texte = String(formData.get("texte") ?? "").trim().slice(0, 4000);
  if (!UUID.test(id)) redirect("/bibliotheque/reformulations");
  const retour = `/bibliotheque/reformulations?fiche=${encodeURIComponent(fiche)}`;

  const supabase = await createClient();
  const { data, error } =
    decision === "refuser"
      ? await supabase.rpc("refuser_reformulation", { reformulation_id: id })
      : await supabase.rpc("appliquer_reformulation", { reformulation_id: id, texte });
  redirect(`${retour}&r=${error ? "erreur" : String(data)}#${id}`);
}
