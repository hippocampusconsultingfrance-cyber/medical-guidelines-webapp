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

// Validation groupée : applique telles quelles toutes les propositions
// restantes d'une fiche (ou de toutes les fiches). Chaque libellé passe par
// appliquer_reformulation (droit de validateur, fiche inchangée, journal).
export async function validerToutes(formData: FormData) {
  const fiche = String(formData.get("fiche") ?? "");
  const portee = formData.get("portee") === "toutes" ? "toutes" : "fiche";
  const retour = `/bibliotheque/reformulations?fiche=${encodeURIComponent(fiche)}`;
  if (formData.get("confirme") !== "1") redirect(`${retour}&r=confirmation`);

  const supabase = await createClient();
  let q = supabase.from("libelles_reformulation").select("id, proposition_html").eq("status", "proposee");
  if (portee === "fiche") q = q.eq("fiche_key", fiche);
  const { data, error } = await q;
  if (error) redirect(`${retour}&r=erreur`);

  let ok = 0;
  let ecartees = 0;
  const lignes = data ?? [];
  for (let i = 0; i < lignes.length; i += 10) {
    const lot = await Promise.all(
      lignes.slice(i, i + 10).map((l) =>
        supabase.rpc("appliquer_reformulation", { reformulation_id: l.id, texte: l.proposition_html }),
      ),
    );
    for (const r of lot) {
      if (!r.error && r.data === "ok") ok++;
      else ecartees++;
    }
  }
  redirect(`${retour}&r=groupe_${ok}_${ecartees}`);
}
