"use server";

import { createHash } from "node:crypto";
import { redirect } from "next/navigation";
import { journaliser } from "@/lib/journal";
import { sendBatch, emailEnabled, siteUrl } from "@/lib/email";
import { chargerDestinataires, chargerLettre, composerLettre, logBody, moisValide } from "@/lib/lettre";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

async function adminUser() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");
  const { data: profile } = await supabase.from("profiles").select("prenom, alerts_token, specialty_id").eq("id", user.id).single();
  return { user, profile };
}

function lire(formData: FormData) {
  const mois = String(formData.get("mois") ?? "");
  const intro = String(formData.get("intro") ?? "").slice(0, 2000);
  if (!moisValide(mois)) redirect("/bibliotheque/veille");
  const back = (r: string) =>
    redirect(`/bibliotheque/veille?mois=${mois}&r=${r}${intro ? `&intro=${encodeURIComponent(intro)}` : ""}`);
  return { mois, intro, back };
}

// Essai : la lettre de la spécialité de l'administrateur, à sa propre adresse.
export async function envoyerEssai(formData: FormData) {
  const { mois, intro, back } = lire(formData);
  const { user, profile } = await adminUser();
  if (!emailEnabled()) back("sans_cle");
  const lettre = await chargerLettre(createAdminClient(), mois);
  const email = composerLettre(
    lettre,
    {
      email: user.email!,
      prenom: (profile?.prenom as string | null) ?? null,
      alertsToken: (profile?.alerts_token as string | null) ?? "essai",
      specialtyId: (profile?.specialty_id as string | null) ?? null,
    },
    intro,
    siteUrl(),
  );
  if (!email) back("vide");
  const sent = await sendBatch([{ ...email!, subject: `[ESSAI] ${email!.subject}` }], `lettre-essai-${mois}-${Date.now()}`);
  back(sent.ok ? "essai_envoye" : "erreur");
}

// Envoi aux membres PREMIUM qui ne l'ont pas encore reçue. Confirmation
// obligatoire ; chaque envoi est journalisé (jamais deux fois le même mois).
export async function envoyerLettre(formData: FormData) {
  const { mois, intro, back } = lire(formData);
  const { user } = await adminUser();
  if (formData.get("confirme") !== "1") back("confirmation");
  if (!emailEnabled()) back("sans_cle");

  const admin = createAdminClient();
  const [lettre, destinataires] = await Promise.all([chargerLettre(admin, mois), chargerDestinataires(admin, mois)]);
  const site = siteUrl();
  const envois = destinataires
    .map((d) => ({ d, email: composerLettre(lettre, d, intro, site) }))
    .filter((x): x is { d: (typeof destinataires)[number]; email: NonNullable<typeof x.email> } => x.email !== null);

  let envoyes = 0;
  let echecs = 0;
  for (let i = 0; i < envois.length; i += 100) {
    const lot = envois.slice(i, i + 100);
    const key = createHash("sha256")
      .update(mois + JSON.stringify(lot.map((x) => x.d.userId)))
      .digest("hex");
    const sent = await sendBatch(
      lot.map((x) => x.email),
      `lettre-${key}`,
    );
    if (!sent.ok) {
      console.error("Lettre mensuelle : envoi", sent.error);
      echecs += lot.length;
      continue;
    }
    envoyes += lot.length;
    const { error } = await admin.from("notifications_log").insert(
      lot.map((x) => ({ user_id: x.d.userId, subject: x.email.subject, body: logBody(mois), channel: "email" })),
    );
    if (error) console.error("Lettre mensuelle : journal", error);
  }
  await journaliser(user.id, "lettre_envoyee", "notifications_log", null, { mois, envoyes, echecs });
  back(echecs ? `partiel_${envoyes}_${echecs}` : `envoyee_${envoyes}`);
}
