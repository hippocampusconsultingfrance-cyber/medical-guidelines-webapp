"use server";

import { redirect } from "next/navigation";
import { unsubscribeByToken } from "@/lib/desinscription";

export async function confirmUnsubscribe(formData: FormData) {
  const ok = await unsubscribeByToken(String(formData.get("t") ?? ""));
  redirect(`/alertes/desinscription?r=${ok ? "ok" : "erreur"}`);
}
