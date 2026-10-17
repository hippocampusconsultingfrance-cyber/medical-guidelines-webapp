"use server";

import { revalidateTag } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { FICHES_PUBLIQUES } from "../../../recommandations/data";
import { LANGUES_TRADUCTION } from "./langues";

const UUID = /^[0-9a-f-]{36}$/i;

// Relecture d'une traduction : droits vérifiés par la base
// (review_translation, relecteur ou plus).
export async function reviewTranslation(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const cible = String(formData.get("cible") ?? "");
  if (!UUID.test(id) || !(LANGUES_TRADUCTION as readonly string[]).includes(cible)) redirect("/bibliotheque/traductions");
  const relue = formData.get("relue") === "1";
  const notes = String(formData.get("notes") ?? "").slice(0, 4000);
  if (relue && formData.get("confirme") !== "1") redirect(`/bibliotheque/${id}/${cible}?r=confirmation#relecture`);

  const supabase = await createClient();
  const { data, error } = await supabase.rpc("review_translation", {
    doc_id: id,
    target_lang: cible,
    relue,
    notes,
  });
  redirect(`/bibliotheque/${id}/${cible}?r=${error || !data ? "erreur" : relue ? "relue" : "brouillon"}#relecture`);
}

// Motifs de refus de publish_translation (verrou des traductions) → code du
// message affiché.
const REFUS: [string, string][] = [
  ["registre juridique", "pub_registre"],
  ["fiche française a changé", "pub_fr_change"],
  ["points à vérifier", "pub_a_verifier"],
  ["non relue par un médecin", "pub_fr_non_relue"],
  ["non relue", "pub_non_relue"],
  ["validateur", "pub_droits"],
];

// Publier ou retirer une traduction (validateur) : relue, ou par IA non relue
// avec sa mention ; conditions vérifiées par la base (publish_translation).
export async function publishTranslation(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const cible = String(formData.get("cible") ?? "");
  if (!UUID.test(id) || !(LANGUES_TRADUCTION as readonly string[]).includes(cible)) redirect("/bibliotheque/traductions");
  const publier = formData.get("publier") === "1";
  if (publier && formData.get("confirme") !== "1") redirect(`/bibliotheque/${id}/${cible}?r=pub_confirmation#publication`);

  const supabase = await createClient();
  const { data, error } = await supabase.rpc("publish_translation", { doc_id: id, target_lang: cible, publier });
  if (data === "ok") revalidateTag(FICHES_PUBLIQUES, { expire: 0 });
  const motif = String(data ?? error?.message ?? "");
  const code = data === "ok" ? (publier ? "publiee" : "retiree") : (REFUS.find(([m]) => motif.includes(m))?.[1] ?? "pub_erreur");
  redirect(`/bibliotheque/${id}/${cible}?r=${code}#publication`);
}
