"use server";

import { redirect } from "next/navigation";
import { signerRelecture } from "@/lib/relecture";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

const lignes = (texte: string) =>
  texte
    .split(/\r?\n/)
    .map((l) => l.replace(/^\s*[-•*]\s*/, "").trim())
    .filter(Boolean)
    .slice(0, 6);

// Validation (avec retouche possible) ou refus des points clés d'une fiche.
// Droit de validateur, nombre de points et journal vérifiés par la base ; la
// relecture complète de la fiche peut être signée en même temps.
export async function deciderPointsCles(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque/points-cles");
  const retour = `/bibliotheque/points-cles?fiche=${id}`;
  const supabase = await createClient();

  if (formData.get("decision") === "refuser") {
    const { data, error } = await supabase.rpc("refuser_points_cles", { doc_id: id });
    redirect(`${retour}&r=${error ? "erreur" : String(data)}`);
  }
  const points = lignes(String(formData.get("points") ?? "").slice(0, 3000));
  const { data, error } = await supabase.rpc("valider_points_cles", { doc_id: id, points });
  if (error || data !== "ok") redirect(`${retour}&r=${error ? "erreur" : String(data)}`);
  if (formData.get("relue") === "1") {
    const { error: e } = await signerRelecture(supabase, id);
    if (e) redirect(`${retour}&r=${/Nom/.test(e.message) ? "relue_nom" : "relue_erreur"}`);
    redirect(`${retour}&r=ok_relue`);
  }
  redirect(`${retour}&r=ok`);
}

// Validation groupée : valide telles quelles toutes les propositions
// restantes (chacune passe par valider_points_cles : droit, journal).
export async function validerTousPointsCles(formData: FormData) {
  if (formData.get("confirme") !== "1") redirect("/bibliotheque/points-cles?r=confirmation");
  const supabase = await createClient();
  const { data, error } = await supabase.from("points_cles_propositions").select("document_id, points").eq("status", "proposee");
  if (error) redirect("/bibliotheque/points-cles?r=erreur");
  let ok = 0;
  const restantes = data ?? [];
  for (let i = 0; i < restantes.length; i += 10) {
    const lot = await Promise.all(
      restantes
        .slice(i, i + 10)
        .map((l) => supabase.rpc("valider_points_cles", { doc_id: l.document_id, points: l.points as string[] })),
    );
    ok += lot.filter((r) => !r.error && r.data === "ok").length;
  }
  redirect(`/bibliotheque/points-cles?r=groupe_${ok}`);
}
