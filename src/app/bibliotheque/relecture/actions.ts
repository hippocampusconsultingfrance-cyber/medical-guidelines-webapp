"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Relecture groupée signée « Équipe médicale interne » : le validateur
// connecté atteste la relecture des fiches cochées. Droit de validateur,
// fiches déjà signées et journal vérifiés par la base.
export async function signerEquipe(formData: FormData) {
  if (formData.get("atteste") !== "1") redirect("/bibliotheque/relecture?r=attestation");
  const ids = formData.getAll("ids").map(String).filter((id) => UUID.test(id)).slice(0, 500);
  if (!ids.length) redirect("/bibliotheque/relecture?r=aucune");
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("signer_relecture_equipe", { doc_ids: ids });
  if (error) {
    console.error("Relecture équipe", error);
    redirect("/bibliotheque/relecture?r=erreur");
  }
  revalidatePath("/bibliotheque", "layout");
  redirect(`/bibliotheque/relecture?r=ok_${Number(data) || 0}`);
}
