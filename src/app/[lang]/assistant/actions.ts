"use server";

import {
  ASSISTANT_QUOTA,
  assistantConfigure,
  assistantOuvertAuxMembres,
  donneesIdentifiantes,
  interrogerAssistant,
  messageDonneesIdentifiantes,
  rechercherPassages,
  type Reponse,
} from "@/lib/assistant";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

export type EtatAssistant = { question: string; reponse: Reponse | null };

// Question posée à l'assistant de recherche. Accès : équipe éditoriale, et
// abonnés PREMIUM une fois l'assistant ouvert (ASSISTANT_PUBLIC=1). Une
// question contenant une donnée identifiante n'est pas envoyée. Limite
// quotidienne par membre : la question est comptée avant l'appel à l'IA
// (reserver_question_assistant), et refusée si le compteur est illisible ;
// une panne de l'IA ne la décompte pas. Rien de la question n'est conservé.
export async function poserQuestion(_: EtatAssistant, formData: FormData): Promise<EtatAssistant> {
  const question = String(formData.get("question") ?? "").trim().slice(0, 500);
  const erreur = (message: string): EtatAssistant => ({ question, reponse: { etat: "erreur", message } });
  if (question.length < 5) return erreur("Posez une question de quelques mots.");
  const identifiantes = donneesIdentifiantes(question);
  if (identifiantes.length) return { question, reponse: { etat: "refus", message: messageDonneesIdentifiantes(identifiantes) } };
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
  const { data: reservation, error: errQuota } = await admin.rpc("reserver_question_assistant", {
    membre: user.id,
    quota: equipe ? ASSISTANT_QUOTA * 5 : ASSISTANT_QUOTA,
  });
  if (errQuota) {
    console.error("Assistant : compteur illisible", errQuota);
    return erreur("L'assistant est momentanément indisponible : réessayez dans un instant.");
  }
  if (!reservation) return erreur(`Limite de ${ASSISTANT_QUOTA} questions par 24 heures atteinte : réessayez demain.`);

  // Panne (de l'IA ou du serveur) : la question n'est pas décomptée.
  const liberer = async () => {
    const { error } = await admin.from("assistant_usage").delete().eq("id", reservation);
    if (error) console.error("Assistant : question non libérée", error);
  };
  let reponse: Reponse;
  try {
    const passages = await rechercherPassages(supabase, question);
    reponse = await interrogerAssistant(question, passages);
  } catch (e) {
    await liberer();
    throw e;
  }
  if (reponse.etat === "erreur") {
    await liberer();
  } else {
    const { error } = await admin
      .from("assistant_usage")
      .update({ extraits: reponse.etat === "ok" ? reponse.extraits.length : 0, refus: reponse.etat === "refus" })
      .eq("id", reservation);
    if (error) console.error("Assistant : compteur non mis à jour", error);
  }
  return { question, reponse };
}
