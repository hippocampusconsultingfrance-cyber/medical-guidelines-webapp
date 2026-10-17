"use server";

import { nomSpecialite } from "@/i18n/specialites";
import { composerBienvenue } from "@/lib/bienvenue";
import { langueMembre } from "@/lib/emails-textes";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { deposerJustificatif } from "@/lib/etudiants-depot";
import { checkoutOpen } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const LOG = "bienvenue";

// E-mail de bienvenue du membre connecté, une seule fois (journal
// notifications_log, body « bienvenue », et clé d'idempotence Resend). Un
// échec n'empêche jamais l'accès au site. Langue : celle de la page.
export async function envoyerBienvenue(langueDemandee?: string) {
  const langue = langueMembre(langueDemandee);
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
        .select("prenom, setup_completed, specialty_id, specialty:specialties(slug, name_i18n)")
        .eq("id", user.id)
        .single(),
      admin.from("notifications_log").select("id", { count: "exact", head: true }).eq("user_id", user.id).eq("body", LOG),
    ]);
    if (!profile?.setup_completed || (deja ?? 0) > 0) return;

    let fiches = 0;
    const { data: couverte } = profile.specialty_id
      ? await admin.rpc("specialite_couverte", { spec: profile.specialty_id })
      : { data: false };
    if (profile.specialty_id) {
      const { count } = await admin
        .from("document_specialties")
        .select("document_id, documents!inner(published_at, freshness_status)", { count: "exact", head: true })
        .eq("specialty_id", profile.specialty_id)
        .not("documents.published_at", "is", null)
        .neq("documents.freshness_status", "retiree");
      fiches = count ?? 0;
    }
    type Specialite = { slug: string; name_i18n: { fr?: string } | null };
    const spec = profile.specialty as Specialite | Specialite[] | null;
    const s = Array.isArray(spec) ? spec[0] : spec;
    const specialite = s?.name_i18n?.fr ? nomSpecialite(s.slug, s.name_i18n.fr, langue) : null;

    const email = composerBienvenue(
      {
        email: user.email,
        prenom: (profile.prenom as string | null) || null,
        // « en anesthésie-réanimation » ; en anglais, nom propre de la spécialité.
        specialite: specialite ? (langue === "fr" ? specialite.toLowerCase() : specialite) : null,
        fiches,
        premiumOuvert: checkoutOpen(false),
        // Vérification impossible : message habituel.
        catalogueOuvert: couverte === false,
      },
      siteUrl(),
      langue,
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

// Justificatif obligatoire à la finalisation d'un compte « en formation »
// (case cochée à l'inscription). Une demande déjà déposée vaut réussite
// (nouvel essai après une erreur sur l'identifiant ou le mot de passe).
export async function deposerJustificatifInscription(formData: FormData): Promise<string> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return "etudiant_session";
  const r = await deposerJustificatif(user.id, formData);
  return r === "etudiant_deja" ? "etudiant_envoye" : r;
}
