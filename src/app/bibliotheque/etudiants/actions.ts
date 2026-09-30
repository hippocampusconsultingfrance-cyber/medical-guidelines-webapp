"use server";

import { redirect } from "next/navigation";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { codeEtudiant, emailDecision } from "@/lib/etudiants";
import { APP, getStripe, stripeEnabled } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;
const YEAR = 365 * 24 * 3600;

// Décision sur une demande de tarif professionnel en formation (administrateurs).
// Validation : remise sur le prochain renouvellement si le membre est déjà
// abonné, sinon code promotionnel personnel à usage unique (valable un an).
// Dans tous les cas, le justificatif est supprimé et le membre prévenu.
export async function deciderEtudiant(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const valide = formData.get("decision") === "valide";
  const note = String(formData.get("note") ?? "").trim().slice(0, 1000) || null;
  if (!UUID.test(id)) redirect("/bibliotheque/etudiants");
  const back = (r: string) => redirect(`/bibliotheque/etudiants?r=${r}`);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");
  if (!valide && !note) back("motif_requis");

  const admin = createAdminClient();
  const { data: req } = await admin
    .from("student_discount_requests")
    .select("id, user_id, status, file_path")
    .eq("id", id)
    .single();
  if (!req || req.status !== "en_attente") back("deja_traitee");

  let code: string | null = null;
  let surAbonnement = false;
  if (valide) {
    const coupon = process.env.STRIPE_STUDENT_COUPON_ID;
    if (!stripeEnabled() || !coupon) back("coupon_absent");
    const stripe = getStripe();
    try {
      const { data: sub } = await admin
        .from("subscriptions")
        .select("status, stripe_subscription_id")
        .eq("user_id", req!.user_id)
        .maybeSingle();
      if (sub?.status === "actif" && sub.stripe_subscription_id) {
        // Déjà abonné : remise sur la prochaine échéance (renouvellement).
        await stripe.subscriptions.update(sub.stripe_subscription_id, { discounts: [{ coupon: coupon! }] });
        surAbonnement = true;
      } else {
        code = codeEtudiant();
        await stripe.promotionCodes.create({
          code,
          max_redemptions: 1,
          expires_at: Math.floor(Date.now() / 1000) + YEAR,
          promotion: { type: "coupon", coupon: coupon! },
          metadata: { app: APP, kind: "etudiant", user_id: req!.user_id },
        });
      }
    } catch (e) {
      console.error("Tarif étudiant : Stripe", e);
      back("stripe_erreur");
    }
  }

  if (req!.file_path) await admin.storage.from("justificatifs").remove([req!.file_path]);
  const { error } = await admin
    .from("student_discount_requests")
    .update({
      status: valide ? "valide" : "refuse",
      decision_note: note,
      decided_by: user.id,
      decided_at: new Date().toISOString(),
      promotion_code: code,
      applied_to_subscription: surAbonnement,
      file_path: null,
    })
    .eq("id", id);
  if (error) {
    console.error("Tarif étudiant : décision", error);
    back("erreur");
  }

  if (emailEnabled()) {
    const [{ data: member }, { data: profile }] = await Promise.all([
      admin.auth.admin.getUserById(req!.user_id),
      admin.from("profiles").select("prenom").eq("id", req!.user_id).single(),
    ]);
    const email = member?.user?.email;
    if (email) {
      const sent = await sendBatch(
        [emailDecision({ email, prenom: (profile?.prenom as string | null) || null, valide, code, surAbonnement, note }, siteUrl())],
        `etudiant-${id}`,
      );
      if (!sent.ok) console.error("Tarif étudiant : e-mail", sent.error);
    }
  }
  back(valide ? "validee" : "refusee");
}
