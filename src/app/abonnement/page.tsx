import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { stripeEnabled } from "@/lib/stripe";
import Logo from "../logo";
import { openPortal, startCheckout } from "./actions";

export const metadata: Metadata = {
  title: "Abonnement PREMIUM — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  merci: "Merci ! Votre paiement est enregistré. L'accès PREMIUM s'active dans quelques secondes : rechargez la page si besoin.",
  annule: "Paiement annulé : aucun montant n'a été débité.",
  cases: "Cochez les deux cases pour continuer.",
};

export default async function AbonnementPage({ searchParams }: PageProps<"/abonnement">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const [{ data: sub }, { data: premium }] = await Promise.all([
    supabase
      .from("subscriptions")
      .select("status, current_period_end, canceled_at, stripe_customer_id")
      .eq("user_id", user.id)
      .maybeSingle(),
    supabase.rpc("has_premium"),
  ]);
  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;
  const enabled = stripeEnabled();
  const fin = sub?.current_period_end
    ? new Date(sub.current_period_end).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })
    : null;

  return (
    <div className="mx-auto min-h-screen max-w-2xl px-6 py-10">
      <div className="flex items-center justify-between gap-3">
        <Link href="/">
          <Logo />
        </Link>
        <Link href="/bibliotheque" className="text-sm text-slate-700 underline">
          Bibliothèque
        </Link>
      </div>

      <h1 className="mt-10 text-2xl font-bold text-[#0E3A78]">Abonnement PREMIUM</h1>
      {message && (
        <p role="status" className="mt-4 rounded-lg bg-[#EEF6FB] p-4 text-sm font-medium text-[#0E3A78]">
          {message}
        </p>
      )}

      {premium ? (
        <section className="mt-6 rounded-2xl border-2 border-[#2BB5A6] p-6">
          <p className="text-lg font-semibold text-slate-900">Votre abonnement PREMIUM est actif.</p>
          <p className="mt-2 text-slate-600">
            Toutes les fiches de votre spécialité sont ouvertes
            {fin ? (sub?.canceled_at ? ` jusqu'au ${fin} (résiliation enregistrée).` : ` ; prochain renouvellement le ${fin}.`) : "."}
          </p>
          {enabled && sub?.stripe_customer_id && (
            <form action={openPortal} className="mt-5">
              <button className="rounded-lg border border-slate-300 px-5 py-2.5 font-semibold text-slate-800 hover:bg-slate-50">
                Factures, moyen de paiement, résiliation
              </button>
            </form>
          )}
        </section>
      ) : (
        <section className="mt-6 rounded-2xl border border-slate-200 p-6">
          <p className="text-4xl font-bold text-[#0E3A78]">
            50 € <span className="text-base font-normal text-slate-500">TTC / an</span>
          </p>
          <ul className="mt-4 space-y-2 text-sm text-slate-700">
            <li>✓ Toutes les fiches de votre spécialité, sans limite de crédits</li>
            <li>✓ Alertes e-mail : nouvelles recommandations des sociétés savantes que vous suivez et mises à jour de vos fiches</li>
            <li>✓ Paiement annuel ; résiliation à tout moment, accès maintenu jusqu&apos;à la fin de l&apos;année payée</li>
            <li>✓ Offre membres fondateurs : −30 % la première année pour les 100 premiers abonnés (code FONDATEURS)</li>
            <li>✓ Internes et étudiants : −30 % sur justificatif, code personnel à demander à l&apos;adresse de contact (non cumulable)</li>
          </ul>

          {enabled ? (
            <form action={startCheckout} className="mt-6 space-y-3">
              <label className="flex items-start gap-3 text-sm text-slate-700">
                <input type="checkbox" name="cgv" value="1" required className="mt-0.5 h-4 w-4" />
                <span>
                  J&apos;ai lu et j&apos;accepte les{" "}
                  <Link href="/cgv" target="_blank" className="underline">
                    Conditions Générales de Vente
                  </Link>
                  .
                </span>
              </label>
              <label className="flex items-start gap-3 text-sm text-slate-700">
                <input type="checkbox" name="retractation" value="1" required className="mt-0.5 h-4 w-4" />
                <span>
                  Je demande l&apos;accès immédiat au service et je renonce expressément à mon
                  droit de rétractation de 14 jours dès le début de l&apos;accès.
                </span>
              </label>
              <button className="w-full rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]">
                Payer et activer PREMIUM
              </button>
              <p className="text-xs text-slate-500">
                Paiement sécurisé par Stripe. Vous pourrez saisir un code promotionnel sur la
                page de paiement. Une facture vous est envoyée par e-mail.
              </p>
            </form>
          ) : (
            <p className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
              Les abonnements ouvrent bientôt. En attendant, vos 5 crédits gratuits restent disponibles.
            </p>
          )}
        </section>
      )}
    </div>
  );
}
