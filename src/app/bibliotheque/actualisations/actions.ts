"use server";

import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Valide (la fiche ancienne passe « remplacée », avec un lien vers la
// nouvelle) ou écarte une proposition d'actualisation. Validateur ou
// administrateur (vérifié par la base).
export async function deciderActualisation(formData: FormData) {
  const ancienne = String(formData.get("ancienne") ?? "");
  const nouvelle = String(formData.get("nouvelle") ?? "");
  const valider = formData.get("decision") === "valider";
  if (!UUID.test(ancienne) || !UUID.test(nouvelle)) redirect("/bibliotheque/actualisations");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: ok } = await supabase.rpc("has_editorial_role", { min_role: "validateur" });
  if (!ok) redirect("/bibliotheque");

  if (valider) {
    const { data, error } = await supabase
      .from("documents")
      .update({ freshness_status: "remplacee", superseded_by_document_id: nouvelle })
      .eq("id", ancienne)
      .select("id");
    redirect(`/bibliotheque/actualisations?r=${error || !data?.length ? "erreur" : "validee"}`);
  }
  const { error } = await createAdminClient()
    .from("actualisations_ecartees")
    .upsert({ ancienne_id: ancienne, nouvelle_id: nouvelle, ecartee_par: user.id });
  redirect(`/bibliotheque/actualisations?r=${error ? "erreur" : "ecartee"}`);
}
