import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { FICHE } from "@/i18n/fiche";
import { fmt, riche } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { FREE_QUOTA } from "@/lib/fiches";
import { createClient } from "@/lib/supabase/server";
import { isEditorialAccount } from "@/lib/roles";
import { checkoutOpen, stripeEnabled, stripeMode } from "@/lib/stripe";
import Logo from "../logo";
import { AUTH } from "../textes-auth";
import { demanderTarifEtudiant, openPortal, resilier, startCheckout } from "./actions";
import { ABONNEMENT } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(ABONNEMENT);
  return { title: t.titreMeta };
}

export default async function AbonnementPage({ searchParams }: PageProps<"/[lang]/abonnement">) {
  const { t, langue, lien, locale } = await textes(ABONNEMENT);
  const MESSAGES = t.messages;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(lien("/connexion"));

  const [{ data: sub }, { data: premium }, isEditor, { data: demande }, { data: ouvert }] = await Promise.all([
    supabase
      .from("subscriptions")
      .select("status, current_period_end, canceled_at, stripe_customer_id, stripe_subscription_id")
      .eq("user_id", user.id)
      .maybeSingle(),
    supabase.rpc("has_premium"),
    isEditorialAccount(supabase, user.id),
    supabase
      .from("student_discount_requests")
      .select("status, statut, created_at, decision_note, promotion_code, applied_to_subscription")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase.rpc("catalogue_ouvert"),
  ]);
  // Spécialité encore peu couverte : abonnement non proposé (@/lib/catalogue).
  const specialiteNonCouverte = Boolean(ouvert) && !isEditor && !premium;
  // Professionnel en formation (case cochée à l'inscription, ou demande déposée
  // ici) : pas de paiement pendant l'examen ; une fois validée, la remise
  // s'applique d'office au paiement (startCheckout), sans code à saisir.
  const enFormation = user.user_metadata?.en_formation === true;
  const attente = demande?.status === "en_attente";
  const remiseEtudiant =
    !premium && demande?.status === "valide" && Boolean(demande.promotion_code) && !demande.applied_to_subscription;
  const paiementBloque = !premium && (attente || (enFormation && !demande));
  const r = (await searchParams).r;
  const etudiantMessage = typeof r === "string" && r.startsWith("etudiant_") ? MESSAGES[r] : undefined;
  const message = typeof r === "string" && !r.startsWith("etudiant_") ? MESSAGES[r] : undefined;
  const enabled = stripeEnabled();
  const open = checkoutOpen(isEditor);
  const testMode = stripeMode() === "test";
  const fin = sub?.current_period_end
    ? new Date(sub.current_period_end).toLocaleDateString(locale, { day: "numeric", month: "long", year: "numeric" })
    : null;

  // Tarif professionnel en formation : le justificatif se dépose AVANT le paiement
  // (le code validé est prérempli au paiement). Pour un abonné, seul l'état
  // d'une demande existante est rappelé.
  const blocEtudiant = (
    <section id="etudiant" className="mt-6 rounded-2xl border border-slate-200 p-6">
      <h2 className="text-lg font-semibold text-slate-900">{t.etudiantTitre}</h2>
      <p className="mt-2 text-sm text-slate-600">{riche(t.etudiantTexte, { b: (c) => <b>{c}</b> })}</p>
      {etudiantMessage && (
        <p role="status" className="mt-3 rounded-lg bg-[#EEF6FB] p-3 text-sm font-medium text-[#0E3A78]">
          {etudiantMessage}
        </p>
      )}
      {demande?.status === "en_attente" ? (
        <p className="mt-4 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
          {fmt(t.justificatifRecu, {
            date: new Date(demande.created_at as string).toLocaleDateString(locale, { timeZone: "Europe/Paris" }),
          })}
        </p>
      ) : demande?.status === "valide" && (remiseEtudiant || demande.applied_to_subscription) ? (
        <p className="mt-4 rounded-lg bg-emerald-50 p-4 text-sm text-emerald-900">
          {remiseEtudiant ? t.valideRemise : t.valideRenouvellement}
        </p>
      ) : (
        <form action={demanderTarifEtudiant} className="mt-4 space-y-3">
          <input type="hidden" name="langue" value={langue} />
          {demande?.status === "refuse" && (
            <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-900">
              {t.refuse}
              {demande.decision_note ? ` : ${demande.decision_note}` : "."}
              {t.refuseFin}
            </p>
          )}
          <label className="block text-sm text-slate-700">
            {t.statut}
            <select name="statut" required defaultValue="" className="mt-1 block w-full rounded-lg border border-slate-300 px-3 py-2">
              <option value="" disabled>
                {t.choisir}
              </option>
              {AUTH[langue].finaliser.statuts.map(([v, l]) => (
                <option key={v} value={v}>
                  {l}
                </option>
              ))}
            </select>
          </label>
          <label className="block text-sm text-slate-700">
            {t.fichier}
            <input
              type="file"
              name="justificatif"
              required
              accept="application/pdf,image/jpeg,image/png"
              className="mt-1 block w-full text-sm"
            />
          </label>
          <label className="flex items-start gap-3 text-sm text-slate-700">
            <input type="checkbox" name="atteste" value="1" required className="mt-0.5 h-4 w-4" />
            <span>{t.atteste}</span>
          </label>
          <button className="rounded-lg border border-slate-300 px-5 py-2.5 font-semibold text-slate-800 hover:bg-slate-50">
            {t.envoyerJustificatif}
          </button>
        </form>
      )}
    </section>
  );

  return (
    <div className="mx-auto min-h-screen max-w-2xl px-6 py-10">
      <div className="flex items-center justify-between gap-3">
        <Link href={lien("/")}>
          <Logo />
        </Link>
        <Link href={lien("/bibliotheque")} className="text-sm text-slate-700 underline">
          {t.bibliotheque}
        </Link>
      </div>

      <h1 className="mt-10 text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>
      {isEditor && (
        <p className="mt-4 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
          <b>Équipe éditoriale</b> — paiement en mode {testMode ? "TEST : aucun débit réel, carte 4242 4242 4242 4242. Les membres voient « ouvre bientôt »." : stripeMode() === "live" ? "RÉEL." : "non configuré."}{" "}
          <Link href="/abonnement/verification" className="underline">
            Vérifier la configuration
          </Link>
        </p>
      )}
      {message && (
        <p role="status" className="mt-4 rounded-lg bg-[#EEF6FB] p-4 text-sm font-medium text-[#0E3A78]">
          {message}
        </p>
      )}

      {!premium && !specialiteNonCouverte && blocEtudiant}

      {premium ? (
        <section className="mt-6 rounded-2xl border-2 border-[#2BB5A6] p-6">
          <p className="text-lg font-semibold text-slate-900">{t.premiumActif}</p>
          <p className="mt-2 text-slate-600">
            {t.premiumTexte}
            {!sub?.stripe_subscription_id
              ? fin
                ? fmt(t.offertJusquau, { date: fin })
                : t.offertSansFin
              : fin
                ? fmt(sub.canceled_at ? t.jusquauResilie : t.renouvellement, { date: fin })
                : "."}
          </p>
          {enabled && sub?.stripe_customer_id && (
            <div className="mt-5 flex flex-wrap gap-3">
              <form action={openPortal}>
                <input type="hidden" name="langue" value={langue} />
                <button className="rounded-lg border border-slate-300 px-5 py-2.5 font-semibold text-slate-800 hover:bg-slate-50">
                  {t.factures}
                </button>
              </form>
              {sub.stripe_subscription_id && !sub.canceled_at && (
                <form action={resilier}>
                  <input type="hidden" name="langue" value={langue} />
                  <button className="rounded-lg border border-red-300 px-5 py-2.5 font-semibold text-red-800 hover:bg-red-50">
                    {t.resilier}
                  </button>
                </form>
              )}
            </div>
          )}
        </section>
      ) : specialiteNonCouverte ? (
        <section className="mt-6 rounded-2xl border border-slate-200 p-6">
          <p className="text-lg font-semibold text-slate-900">{t.bientotTitre}</p>
          <p className="mt-2 text-sm leading-relaxed text-slate-600">{fmt(FICHE[langue].catalogueOuvert, { quota: FREE_QUOTA })}</p>
          <Link href={lien("/bibliotheque")} className="mt-4 inline-block font-semibold text-[#1A74A6] hover:underline">
            {t.choisirGratuites}
          </Link>
        </section>
      ) : (
        <section className="mt-6 rounded-2xl border border-slate-200 p-6">
          {remiseEtudiant ? (
            <p className="text-4xl font-bold text-[#0E3A78]">
              {t.prixEtudiant} <span className="text-base font-normal text-slate-500">{t.prixEtudiantDetail}</span>
            </p>
          ) : (
            <p className="text-4xl font-bold text-[#0E3A78]">
              {t.prix} <span className="text-base font-normal text-slate-500">{t.prixDetail}</span>
            </p>
          )}
          <ul className="mt-4 space-y-2 text-sm text-slate-700">
            {t.avantages.map((a) => (
              <li key={a}>✓ {a}</li>
            ))}
          </ul>
          <p className="mt-4 rounded-lg bg-slate-50 p-3 text-xs leading-relaxed text-slate-600">
            {t.note}{" "}
            <Link href={lien("/demarche")} className="underline">
              {t.demarche}
            </Link>
          </p>

          {open && paiementBloque ? (
            <p className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
              {attente ? t.attente : t.deposerDabord}
            </p>
          ) : open ? (
            <form action={startCheckout} className="mt-6 space-y-3">
              <input type="hidden" name="langue" value={langue} />
              {!remiseEtudiant && (
                <label className="block text-sm text-slate-700">
                  {t.code}
                  <input
                    name="code"
                    maxLength={40}
                    autoComplete="off"
                    placeholder="FONDATEURS"
                    className="mt-1 block w-full rounded-lg border border-slate-300 px-3 py-2 uppercase"
                  />
                </label>
              )}
              <label className="flex items-start gap-3 text-sm text-slate-700">
                <input type="checkbox" name="cgv" value="1" required className="mt-0.5 h-4 w-4" />
                <span>
                  {riche(t.cgv, {
                    cgv: (c) => (
                      <Link href={lien("/cgv")} target="_blank" className="underline">
                        {c}
                      </Link>
                    ),
                  })}
                </span>
              </label>
              <label className="flex items-start gap-3 text-sm text-slate-700">
                <input type="checkbox" name="retractation" value="1" required className="mt-0.5 h-4 w-4" />
                <span>{t.retractation}</span>
              </label>
              <button className="w-full rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]">
                {t.payer}
              </button>
              <p className="text-xs text-slate-500">{t.stripe}</p>
            </form>
          ) : (
            <p className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
              {t.bientot}
            </p>
          )}
        </section>
      )}

    </div>
  );
}
