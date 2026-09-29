import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { MEDIATEUR, mediateurRenseigne } from "@/lib/legal";
import { isAdminAccount } from "@/lib/roles";
import { SITE_URL } from "@/lib/seo";
import { CGV_VERSION, getStripe, stripeEnabled, stripeMode } from "@/lib/stripe";
import { createClient } from "@/lib/supabase/server";

export const metadata: Metadata = {
  title: "Vérification du paiement — medical-guidelines.net",
};

// Vérification de la configuration Stripe avant (et après) le passage au
// paiement réel : docs/PASSAGE_PAIEMENT_REEL.md. Réservée aux
// administrateurs ; lecture seule, rien n'est modifié chez Stripe.

type Check = { label: string; ok: boolean | null; detail: string };

const WEBHOOK_EVENTS = [
  "checkout.session.completed",
  "customer.subscription.created",
  "customer.subscription.updated",
  "customer.subscription.deleted",
];

async function run(label: string, fn: () => Promise<Omit<Check, "label">>): Promise<Check> {
  try {
    return { label, ...(await fn()) };
  } catch (e) {
    return { label, ok: false, detail: e instanceof Error ? e.message : "Erreur Stripe" };
  }
}

async function stripeChecks(): Promise<Check[]> {
  const stripe = getStripe();
  const mode = stripeMode();
  const live = mode === "live";
  return Promise.all([
    run("Compte Stripe activé (encaissements et virements)", async () => {
      const a = await stripe.accounts.retrieveCurrent();
      const ok = Boolean(a.charges_enabled && a.payouts_enabled && a.details_submitted);
      return {
        ok: live ? ok : null,
        detail: `paiements ${a.charges_enabled ? "oui" : "non"}, virements ${a.payouts_enabled ? "oui" : "non"}, dossier ${a.details_submitted ? "complet" : "incomplet"} ; libellé bancaire « ${a.settings?.payments?.statement_descriptor ?? "—"} »`,
      };
    }),
    run("Prix PREMIUM : 50 € par an, actif", async () => {
      const p = await stripe.prices.retrieve(process.env.STRIPE_PRICE_ID!);
      const ok =
        p.active &&
        p.currency === "eur" &&
        p.unit_amount === 5000 &&
        p.recurring?.interval === "year" &&
        p.recurring?.interval_count === 1 &&
        p.livemode === live;
      return {
        ok,
        detail: `${(p.unit_amount ?? 0) / 100} ${p.currency.toUpperCase()} / ${p.recurring?.interval_count ?? "?"} ${p.recurring?.interval ?? "?"}, ${p.active ? "actif" : "inactif"}, mode ${p.livemode ? "réel" : "test"}, TVA ${p.tax_behavior === "inclusive" ? "incluse" : p.tax_behavior ?? "non précisée"}`,
      };
    }),
    run("Webhook vers le site (4 événements)", async () => {
      const list = await stripe.webhookEndpoints.list({ limit: 100 });
      const ep = list.data.find((w) => w.url.endsWith("/api/stripe/webhook"));
      if (!ep) return { ok: false, detail: `aucun point de réception ${SITE_URL}/api/stripe/webhook` };
      const missing = WEBHOOK_EVENTS.filter((e) => !ep.enabled_events.includes(e) && !ep.enabled_events.includes("*"));
      const secret = (process.env.STRIPE_WEBHOOK_SECRET ?? "").startsWith("whsec_");
      return {
        ok: ep.status === "enabled" && missing.length === 0 && secret && ep.url.startsWith(SITE_URL),
        detail: `${ep.url}, ${ep.status}${missing.length ? `, manquants : ${missing.join(", ")}` : ""}${secret ? "" : ", STRIPE_WEBHOOK_SECRET absent"}`,
      };
    }),
    run("Portail client : factures, carte, résiliation", async () => {
      const list = await stripe.billingPortal.configurations.list({ is_default: true, limit: 1 });
      const c = list.data[0];
      if (!c) return { ok: false, detail: "portail non configuré" };
      const f = c.features;
      const ok = f.invoice_history.enabled && f.payment_method_update.enabled && f.subscription_cancel.enabled;
      return {
        ok,
        detail: `factures ${f.invoice_history.enabled ? "oui" : "non"}, carte ${f.payment_method_update.enabled ? "oui" : "non"}, résiliation ${f.subscription_cancel.enabled ? `oui (${f.subscription_cancel.mode === "at_period_end" ? "en fin de période" : "immédiate"})` : "non"}`,
      };
    }),
    run("Code FONDATEURS : −30 % la 1re année, 100 utilisations", async () => {
      const list = await stripe.promotionCodes.list({ code: "FONDATEURS", active: true, limit: 1, expand: ["data.promotion.coupon"] });
      const pc = list.data[0];
      if (!pc) return { ok: false, detail: "code absent ou inactif" };
      const coupon = pc.promotion?.coupon;
      const c = typeof coupon === "string" || !coupon ? null : coupon;
      const ok = c?.percent_off === 30 && c?.duration === "once" && pc.max_redemptions === 100;
      return {
        ok,
        detail: `${c?.percent_off ?? "?"} %, durée ${c?.duration ?? "?"}, ${pc.times_redeemed} utilisé(s) sur ${pc.max_redemptions ?? "illimité"}`,
      };
    }),
    run("TVA française 20 % incluse, sur les factures", async () => {
      if (process.env.STRIPE_TAX === "1") {
        const t = await stripe.tax.settings.retrieve();
        return { ok: t.status === "active", detail: `calculée par Stripe Tax (${t.status === "active" ? "actif" : "à compléter"})` };
      }
      const id = process.env.STRIPE_TAX_RATE_ID;
      if (!id) return { ok: false, detail: "aucune TVA appliquée : STRIPE_TAX_RATE_ID absent" };
      const r = await stripe.taxRates.retrieve(id);
      return {
        ok: r.active && r.percentage === 20 && r.inclusive && r.livemode === live,
        detail: `${r.display_name} ${r.percentage} %, ${r.inclusive ? "incluse" : "en sus"}, ${r.country ?? "pays non précisé"}, ${r.active ? "actif" : "inactif"}, mode ${r.livemode ? "réel" : "test"}`,
      };
    }),
  ]);
}

export default async function VerificationPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  if (!(await isAdminAccount(supabase, user.id))) notFound();

  const mode = stripeMode();
  const checks: Check[] = [
    {
      label: "Clé Stripe",
      ok: mode === "live" ? true : mode === "test" ? null : false,
      detail: mode === "live" ? "mode RÉEL" : mode === "test" ? "mode TEST (paiement réservé à l'équipe)" : "absente",
    },
    {
      label: "Médiateur de la consommation (CGV)",
      ok: mediateurRenseigne(),
      detail: mediateurRenseigne() ? `${MEDIATEUR.nom} — ${MEDIATEUR.site}` : "à renseigner dans src/lib/legal.ts",
    },
    { label: "Version des CGV acceptée au paiement", ok: null, detail: CGV_VERSION },
    ...(stripeEnabled() ? await stripeChecks() : []),
  ];

  const { data: subs } = await supabase.from("subscriptions").select("status, stripe_subscription_id");
  const withStripe = (subs ?? []).filter((s) => s.stripe_subscription_id);
  checks.push({
    label: "Abonnements enregistrés",
    ok: null,
    detail: `${withStripe.length} abonnement(s) Stripe en base (${withStripe.filter((s) => s.status === "actif").length} actif(s)). Au passage en réel, supprimer ceux créés en mode test.`,
  });

  const allOk = mode === "live" && checks.every((c) => c.ok !== false);
  return (
    <div className="mx-auto min-h-screen max-w-3xl px-6 py-10 text-sm text-slate-700">
      <Link href="/abonnement" className="underline">
        ← Abonnement
      </Link>
      <h1 className="mt-6 text-2xl font-bold text-[#0E3A78]">Vérification du paiement</h1>
      <p className="mt-2">
        Lecture seule : rien n&apos;est modifié chez Stripe. Procédure complète :
        docs/PASSAGE_PAIEMENT_REEL.md (dépôt GitHub).
      </p>
      <p className={`mt-4 rounded-lg p-4 font-semibold ${allOk ? "bg-emerald-50 text-emerald-900" : "bg-amber-50 text-amber-900"}`}>
        {allOk
          ? "Paiement réel prêt : les membres peuvent s'abonner."
          : mode === "live"
            ? "Mode réel : au moins un point est à corriger (✗)."
            : "Mode test : la vente aux membres n'est pas ouverte."}
      </p>
      <ul className="mt-6 space-y-3">
        {checks.map((c) => (
          <li key={c.label} className="rounded-lg border border-slate-200 p-3">
            <span className="mr-2 font-bold">{c.ok === true ? "✓" : c.ok === false ? "✗" : "•"}</span>
            <b>{c.label}</b>
            <div className="mt-1 text-slate-600">{c.detail}</div>
          </li>
        ))}
      </ul>
    </div>
  );
}
