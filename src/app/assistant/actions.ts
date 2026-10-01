"use server";

import {
  ASSISTANT_QUOTA,
  assistantConfigure,
  assistantOuvertAuxMembres,
  interrogerAssistant,
  rechercherPassages,
  type Reponse,
} from "@/lib/assistant";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

export type EtatAssistant = { question: string; reponse: Reponse | null };

// Question posée à l'assistant de recherche. Accès : équipe éditoriale, et
// abonnés PREMIUM une fois l'assistant ouvert (ASSISTANT_PUBLIC=1). Limite
// quotidienne par membre ; rien de la question n'est conservé.
export async function poserQuestion(_: EtatAssistant, formData: FormData): Promise<EtatAssistant> {
  const question = String(formData.get("question") ?? "").trim().slice(0, 500);
  const erreur = (message: string): EtatAssistant => ({ question, reponse: { etat: "erreur", message } });
  if (question.length < 5) return erreur("Posez une question de quelques mots.");
  if (!assistantConfigure()) return erreur("L'assistant n'est pas encore configuré.");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return erreur("Connectez-vous pour utiliser l'assistant.");
  const [{ data: equipe }, { data: premium }] = await Promise.all([
    supabase.rpc("has_editorial_role", { min_role: "relecteur" }),
    supabase.rpc("has_premium"),
  ]);
  if (!equipe && !(premium && assistantOuvertAuxMembres())) {
    return erreur("L'assistant de recherche est réservé aux abonnés PREMIUM.");
  }

  const admin = createAdminClient();
  const depuis = new Date(Date.now() - 24 * 3600 * 1000).toISOString();
  const { count } = await admin
    .from("assistant_usage")
    .select("id", { count: "exact", head: true })
    .eq("user_id", user.id)
    .gte("created_at", depuis);
  if ((count ?? 0) >= (equipe ? ASSISTANT_QUOTA * 5 : ASSISTANT_QUOTA)) {
    return erreur(`Limite de ${ASSISTANT_QUOTA} questions par 24 heures atteinte : réessayez demain.`);
  }

  const passages = await rechercherPassages(supabase, question);
  const reponse = await interrogerAssistant(question, passages);
  await admin.from("assistant_usage").insert({
    user_id: user.id,
    extraits: reponse.etat === "ok" ? reponse.extraits.length : 0,
    refus: reponse.etat === "refus",
  });
  return { question, reponse };
}
