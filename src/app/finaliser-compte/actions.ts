"use server";

import { composerBienvenue } from "@/lib/bienvenue";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { checkoutOpen } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const LOG = "bienvenue";

// E-mail de bienvenue du membre connecté, une seule fois (journal
// notifications_log, body « bienvenue », et clé d'idempotence Resend). Un
// échec n'empêche jamais l'accès au site.
export async function envoyerBienvenue() {
  try {
    if (!emailEnabled()) return;
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user?.email) return;

    const admin = createAdminClient();
    const [{ data: profile }, { count: deja }] = await Promise.all([
      admin
        .from("profiles")
        .select("prenom, setup_completed, specialty_id, specialty:specialties(name_i18n)")
        .eq("id", user.id)
        .single(),
      admin.from("notifications_log").select("id", { count: "exact", head: true }).eq("user_id", user.id).eq("body", LOG),
    ]);
    if (!profile?.setup_completed || (deja ?? 0) > 0) return;

    let fiches = 0;
    if (profile.specialty_id) {
      const { count } = await admin
        .from("document_specialties")
        .select("document_id, documents!inner(published_at, freshness_status)", { count: "exact", head: true })
        .eq("specialty_id", profile.specialty_id)
        .not("documents.published_at", "is", null)
        .neq("documents.freshness_status", "retiree");
      fiches = count ?? 0;
    }
    const spec = profile.specialty as { name_i18n: { fr?: string } | null } | { name_i18n: { fr?: string } | null }[] | null;
    const specialite = (Array.isArray(spec) ? spec[0] : spec)?.name_i18n?.fr ?? null;

    const email = composerBienvenue(
      {
        email: user.email,
        prenom: (profile.prenom as string | null) || null,
        specialite: specialite ? specialite.toLowerCase() : null,
        fiches,
        premiumOuvert: checkoutOpen(false),
      },
      siteUrl(),
    );
    const sent = await sendBatch([email], `bienvenue-${user.id}`);
    if (!sent.ok) {
      console.error("Bienvenue : envoi", sent.error);
      return;
    }
    await admin.from("notifications_log").insert({ user_id: user.id, subject: email.subject, body: LOG, channel: "email" });
  } catch (e) {
    console.error("Bienvenue", e);
  }
}
