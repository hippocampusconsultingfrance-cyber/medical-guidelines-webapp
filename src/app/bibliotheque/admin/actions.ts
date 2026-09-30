"use server";

import * as Sentry from "@sentry/nextjs";
import { redirect } from "next/navigation";
import { SENTRY_ENABLED } from "@/lib/sentry";
import { createClient } from "@/lib/supabase/server";

// Erreur simulée (administrateurs) : vérifie qu'elle remonte dans Sentry
// (checklist 6.1).
export async function testerSentry() {
  const supabase = await createClient();
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");
  if (!SENTRY_ENABLED) redirect("/bibliotheque/admin?r=sentry_inactif");
  Sentry.captureException(new Error("Erreur simulée depuis le tableau de bord (test Sentry)"));
  await Sentry.flush(3000);
  redirect("/bibliotheque/admin?r=sentry_envoye");
}
