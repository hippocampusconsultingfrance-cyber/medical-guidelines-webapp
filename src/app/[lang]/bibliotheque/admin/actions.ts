"use server";

import * as Sentry from "@sentry/nextjs";
import { redirect } from "next/navigation";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { SENTRY_ENABLED } from "@/lib/sentry";
import { calculerSynthese, composerSynthese } from "@/lib/synthese";
import { createAdminClient } from "@/lib/supabase/admin";
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

// Envoie tout de suite la synthèse hebdomadaire à l'administrateur connecté
// (aperçu ; l'envoi automatique a lieu le lundi matin).
export async function envoyerSynthese() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!user?.email || !isAdmin) redirect("/bibliotheque");
  if (!emailEnabled()) redirect("/bibliotheque/admin?r=synthese_erreur");
  const synthese = await calculerSynthese(createAdminClient(), new Date());
  const sent = await sendBatch([composerSynthese(synthese, user.email!, siteUrl())], `synthese-essai-${Date.now()}`);
  redirect(`/bibliotheque/admin?r=${sent.ok ? "synthese_envoyee" : "synthese_erreur"}`);
}
