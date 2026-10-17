"use server";

import { redirect } from "next/navigation";
import { langueDuFormulaire } from "@/i18n/serveur";
import { unsubscribeByToken } from "@/lib/desinscription";
import { chemin } from "@/lib/langues";

export async function confirmUnsubscribe(formData: FormData) {
  const ok = await unsubscribeByToken(String(formData.get("t") ?? ""));
  redirect(chemin(langueDuFormulaire(formData), `/alertes/desinscription?r=${ok ? "ok" : "erreur"}`));
}
