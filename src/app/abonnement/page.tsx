import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { isEditorialAccount } from "@/lib/roles";
import { checkoutOpen, stripeEnabled, stripeMode } from "@/lib/stripe";
import Logo from "../logo";
import { STATUTS } from "@/lib/etudiants";
import { demanderTarifEtudiant, openPortal, resilier, startCheckout } from "./actions";

export const metadata: Metadata = {
  title: "Abonnement PREMIUM — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  etudiant_envoye: "Justificatif reçu : nous le vérifions et vous répondons par e-mail, en général sous 48 h.",
  etudiant_statut: "Choisissez votre statut.",
  etudiant_atteste: "Cochez l'attestation avant d'envoyer.",
  etudiant_fichier: "Joignez votre justificatif.",
  etudiant_format: "Format non accepté : envoyez un PDF, un JPEG ou un PNG.",
  etudiant_taille: "Fichier trop lourd : 3 Mo au maximum.",
  etudiant_deja: "Une demande est déjà en cours d'examen.",
  etudiant_attente: "Votre justificatif est en cours de vérification : le paiement s'ouvrira avec −30 % dès sa validation.",
  etudiant_erreur: "L'envoi n'a pas abouti. Réessayez dans un instant.",
  merci: "Merci ! Votre paiement est enregistré. L'accès PREMIUM s'active dans quelques secondes : rechargez la page si besoin.",
  annule: "Paiement annulé : aucun montant n'a été débité.",
  cases: "Cochez les deux cases pour continuer.",
  code: "Ce code promotionnel n'est pas valable. Vérifiez-le, ou laissez le champ vide.",
  resiliation: "Résiliation enregistrée : votre accès PREMIUM reste ouvert jusqu'à la fin de la période payée, sans renouvellement.",
  portail: "Espace de facturation indisponible pour ce compte : écrivez-nous à contact@medical-guidelines.net.",
};

export default async function AbonnementPage({ searchParams }: PageProps<"/abonnement">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const [{ data: sub }, { data: premium }, isEditor, { data: demande }] = await Promise.all([
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
  ]);
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
    ? new Date(sub.current_period_end).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })
    : null;

  // Tarif professionnel en formation : le justificatif se dépose AVANT le paiement
  // (le code validé est prérempli au paiement). Pour un abonné, seul l'état
  // d'une demande existante est rappelé.
  const blocEtudiant = (
    <section id="etudiant" className="mt-6 rounded-2xl border border-slate-200 p-6">
      <h2 className="text-lg font-semibold text-slate-900">Professionnel de santé en formation ? −30 % la première année</h2>
      <p className="mt-2 text-sm text-slate-600">
        Étudiants en médecine ou paramédicaux, internes, résidents, docteurs juniors : déposez un justificatif de
        l&apos;année universitaire en cours (carte d&apos;étudiant, certificat de scolarité,
        attestation d&apos;affectation) <b>avant de payer</b>. Après vérification (en général sous
        48 h), la réduction de 30 % s&apos;applique automatiquement au paiement (35 € TTC la
        première année). Le justificatif est supprimé dès notre décision.
      </p>
      {etudiantMessage && (
        <p role="status" className="mt-3 rounded-lg bg-[#EEF6FB] p-3 text-sm font-medium text-[#0E3A78]">
          {etudiantMessage}
        </p>
      )}
      {demande?.status === "en_attente" ? (
        <p className="mt-4 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
          Justificatif reçu le{" "}
          {new Date(demande.created_at as string).toLocaleDateString("fr-FR", { timeZone: "Europe/Paris" })} :
          vérification en cours. Réponse par e-mail.
        </p>
      ) : demande?.status === "valide" && (remiseEtudiant || demande.applied_to_subscription) ? (
        <p className="mt-4 rounded-lg bg-emerald-50 p-4 text-sm text-emerald-900">
          {remiseEtudiant ? (
            <>
              Justificatif validé : −30 % appliqués automatiquement au paiement ci-dessous, soit 35 € TTC la
              première année.
            </>
          ) : (
            <>Justificatif validé : −30 % sur votre prochain renouvellement.</>
          )}
        </p>
      ) : (
        <form action={demanderTarifEtudiant} className="mt-4 space-y-3">
          {demande?.status === "refuse" && (
            <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-900">
              Votre précédent justificatif n&apos;a pas été validé
              {demande.decision_note ? ` : ${demande.decision_note}` : "."} Vous pouvez en déposer un nouveau.
            </p>
          )}
          <label className="block text-sm text-slate-700">
            Votre statut
            <select name="statut" required defaultValue="" className="mt-1 block w-full rounded-lg border border-slate-300 px-3 py-2">
              <option value="" disabled>
                Choisir…
              </option>
              {Object.entries(STATUTS).map(([v, l]) => (
                <option key={v} value={v}>
                  {l}
                </option>
              ))}
            </select>
          </label>
          <label className="block text-sm text-slate-700">
            Justificatif (PDF, JPEG ou PNG, 3 Mo maximum)
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
            <span>J&apos;atteste être en formation pour l&apos;année universitaire en cours.</span>
          </label>
          <button className="rounded-lg border border-slate-300 px-5 py-2.5 font-semibold text-slate-800 hover:bg-slate-50">
            Envoyer mon justificatif
          </button>
        </form>
      )}
    </section>
  );

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

      {!premium && blocEtudiant}

      {premium ? (
        <section className="mt-6 rounded-2xl border-2 border-[#2BB5A6] p-6">
          <p className="text-lg font-semibold text-slate-900">Votre abonnement PREMIUM est actif.</p>
          <p className="mt-2 text-slate-600">
            Toutes les fiches de votre spécialité sont ouvertes
            {!sub?.stripe_subscription_id
              ? fin
                ? `, accès offert jusqu'au ${fin}.`
                : ", accès offert sans date de fin."
              : fin
                ? sub.canceled_at
                  ? ` jusqu'au ${fin} (résiliation enregistrée).`
                  : ` ; prochain renouvellement le ${fin}.`
                : "."}
          </p>
          {enabled && sub?.stripe_customer_id && (
            <div className="mt-5 flex flex-wrap gap-3">
              <form action={openPortal}>
                <button className="rounded-lg border border-slate-300 px-5 py-2.5 font-semibold text-slate-800 hover:bg-slate-50">
                  Factures et moyen de paiement
                </button>
              </form>
              {sub.stripe_subscription_id && !sub.canceled_at && (
                <form action={resilier}>
                  <button className="rounded-lg border border-red-300 px-5 py-2.5 font-semibold text-red-800 hover:bg-red-50">
                    Résilier mon abonnement
                  </button>
                </form>
              )}
            </div>
          )}
        </section>
      ) : (
        <section className="mt-6 rounded-2xl border border-slate-200 p-6">
          {remiseEtudiant ? (
            <p className="text-4xl font-bold text-[#0E3A78]">
              35 €{" "}
              <span className="text-base font-normal text-slate-500">TTC la première année, puis 50 € / an</span>
            </p>
          ) : (
            <p className="text-4xl font-bold text-[#0E3A78]">
              50 € <span className="text-base font-normal text-slate-500">TTC / an</span>
            </p>
          )}
          <ul className="mt-4 space-y-2 text-sm text-slate-700">
            <li>✓ Toutes les fiches de votre spécialité, sans limite de crédits</li>
            <li>✓ Alertes e-mail : nouvelles recommandations des sociétés savantes que vous suivez et mises à jour de vos fiches</li>
            <li>✓ Paiement annuel ; résiliation à tout moment, accès maintenu jusqu&apos;à la fin de l&apos;année payée</li>
            <li>✓ Offre membres fondateurs : −30 % la première année pour les 100 premiers abonnés (code FONDATEURS)</li>
            <li>✓ Professionnels de santé en formation : −30 % sur justificatif déposé ci-dessus (non cumulable)</li>
          </ul>
          <p className="mt-4 rounded-lg bg-slate-50 p-3 text-xs leading-relaxed text-slate-600">
            Votre abonnement ne paie pas les recommandations : elles restent en accès libre sur les sites des
            sociétés savantes. Il ne sert pas à en tirer profit mais à couvrir ce que coûte le site :
            l&apos;hébergement, les développeurs et les outils d&apos;intelligence artificielle. Ce site a été
            construit grâce à des personnes volontaires.{" "}
            <Link href="/demarche" className="underline">
              Notre démarche
            </Link>
          </p>

          {open && paiementBloque ? (
            <p className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
              {attente
                ? "Votre justificatif de formation est en cours de vérification. Vous recevrez un e-mail dès sa validation : le paiement s'ouvrira alors ici, avec −30 %."
                : "Vous avez indiqué être en formation : déposez d'abord votre justificatif ci-dessus pour bénéficier de −30 %."}
            </p>
          ) : open ? (
            <form action={startCheckout} className="mt-6 space-y-3">
              {!remiseEtudiant && (
                <label className="block text-sm text-slate-700">
                  Code promotionnel (facultatif)
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
                Paiement sécurisé par Stripe. Une facture vous est envoyée par e-mail.
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
