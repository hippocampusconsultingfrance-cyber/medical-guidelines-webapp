"use server";

import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;
const txt = (v: FormDataEntryValue | null, max: number) => String(v ?? "").trim().slice(0, max) || null;

// Droit : validateur ou administrateur (vérifié par la base).
async function editeur() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: ok } = await supabase.rpc("has_editorial_role", { min_role: "validateur" });
  if (!ok) redirect("/bibliotheque");
  return user.id;
}

// Nouvelle divergence : une question clinique et 2 à 4 positions (fiche,
// position, population, grade, niveau de preuve).
export async function creerDivergence(formData: FormData) {
  const userId = await editeur();
  const back = (r: string) => redirect(`/bibliotheque/divergences?r=${r}`);
  const question = txt(formData.get("question"), 300);
  const avertissement = txt(formData.get("avertissement"), 1000);
  if (!question || question.length < 5) back("question");

  const positions = [0, 1, 2, 3]
    .map((i) => ({
      document_id: String(formData.get(`doc_${i}`) ?? ""),
      position: txt(formData.get(`position_${i}`), 1500),
      population: txt(formData.get(`population_${i}`), 300),
      grade: txt(formData.get(`grade_${i}`), 100),
      evidence_level: txt(formData.get(`niveau_${i}`), 100),
      sort_order: i,
    }))
    .filter((p) => UUID.test(p.document_id) && p.position);
  if (positions.length < 2 || new Set(positions.map((p) => p.document_id)).size !== positions.length) back("positions");

  const admin = createAdminClient();
  const { data: d, error } = await admin
    .from("divergences")
    .insert({ question, avertissement, created_by: userId })
    .select("id")
    .single();
  if (error || !d) {
    console.error("Divergence", error);
    back("erreur");
  }
  const { error: e2 } = await admin
    .from("divergence_positions")
    .insert(positions.map((p) => ({ ...p, divergence_id: d!.id })));
  if (e2) {
    console.error("Divergence : positions", e2);
    await admin.from("divergences").delete().eq("id", d!.id);
    back("erreur");
  }
  back("creee");
}

export async function supprimerDivergence(formData: FormData) {
  await editeur();
  const id = String(formData.get("id") ?? "");
  if (UUID.test(id)) await createAdminClient().from("divergences").delete().eq("id", id);
  redirect("/bibliotheque/divergences?r=supprimee");
}
