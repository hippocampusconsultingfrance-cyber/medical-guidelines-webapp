"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { PROFESSION_GROUPS } from "@/lib/professions";

export type Specialty = { slug: string; category: string; isOther: boolean; name: string };

const SPECIALTY_GROUPS = [
  { category: "medicale", label: "Spécialités médicales" },
  { category: "paramedicale", label: "Professions paramédicales" },
];

// Liste des spécialités lue par le serveur (page.tsx) : pas d'attente à
// l'affichage du formulaire.
export default function InscriptionForm({ specialties }: { specialties: Specialty[] }) {
  const router = useRouter();
  const [nom, setNom] = useState("");
  const [prenom, setPrenom] = useState("");
  const [telephone, setTelephone] = useState("");
  const [email, setEmail] = useState("");
  const [profession, setProfession] = useState("");
  const [professionAutre, setProfessionAutre] = useState("");
  const [enFormation, setEnFormation] = useState(false);
  const [specialty, setSpecialty] = useState("");
  const [consentService, setConsentService] = useState(false);
  const [consentPartners, setConsentPartners] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [submitted, setSubmitted] = useState(false);
  const [code, setCode] = useState("");
  const [codeError, setCodeError] = useState<string | null>(null);
  const [codeLoading, setCodeLoading] = useState(false);
  const [resendMessage, setResendMessage] = useState<string | null>(null);

  const professionEstAutre = profession === "Autre";

  async function sendOtp() {
    const supabase = createClient();
    return supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: true,
        emailRedirectTo: `${window.location.origin}/auth/callback`,
        data: {
          nom,
          prenom,
          telephone,
          profession,
          profession_autre: professionEstAutre ? professionAutre.trim() : null,
          specialty_slug: specialty,
          consent_service: true,
          consent_partners: consentPartners,
          en_formation: enFormation,
        },
      },
    });
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    if (!consentService) {
      setError(
        "Vous devez accepter les Conditions Générales d'Utilisation et la Politique de Confidentialité pour créer un compte.",
      );
      return;
    }
    if (professionEstAutre && professionAutre.trim().length < 2) {
      setError("Merci de préciser votre spécialité.");
      return;
    }

    setLoading(true);
    const { error: signUpError } = await sendOtp();
    setLoading(false);

    if (signUpError) {
      setError(
        signUpError.status === 429
          ? "Trop de demandes en peu de temps. Patientez quelques minutes puis réessayez."
          : "L'envoi du code a échoué. Vérifiez votre adresse email et réessayez.",
      );
      return;
    }
    setSubmitted(true);
  }

  async function handleVerifyCode(e: React.FormEvent) {
    e.preventDefault();
    setCodeError(null);
    setCodeLoading(true);
    const supabase = createClient();
    const { error: verifyError } = await supabase.auth.verifyOtp({
      email,
      token: code.trim(),
      type: "email",
    });
    setCodeLoading(false);

    if (verifyError) {
      setCodeError(
        "Code invalide ou expiré. Vérifiez le code ou demandez-en un nouveau.",
      );
      return;
    }
    router.push("/finaliser-compte");
  }

  async function handleResend() {
    setCodeError(null);
    setResendMessage(null);
    setCodeLoading(true);
    const { error: resendError } = await sendOtp();
    setCodeLoading(false);
    if (resendError) {
      setCodeError(
        resendError.status === 429
          ? "Trop de demandes en peu de temps. Patientez quelques minutes avant de redemander un code."
          : "Impossible de renvoyer le code. Réessayez dans quelques instants.",
      );
      return;
    }
    setResendMessage("Un nouveau code vient d'être envoyé à " + email + ".");
  }

  if (submitted) {
    return (
      <div className="flex flex-col text-center">
        <h1 className="text-2xl font-bold text-[#0E3A78]">
          Vérifiez votre boîte email
        </h1>
        <p className="mt-4 text-slate-600">
          Un code a été envoyé à <strong>{email}</strong>.
          Saisissez-le ci-dessous pour valider votre adresse et finaliser la
          création de votre compte (choix d&apos;un identifiant et d&apos;un
          mot de passe). Le lien présent dans l&apos;email fonctionne aussi,
          mais uniquement s&apos;il est ouvert sur cet appareil.
        </p>

        <form onSubmit={handleVerifyCode} className="mt-6 space-y-3">
          <input
            required
            inputMode="numeric"
            autoComplete="one-time-code"
            maxLength={10}
            value={code}
            onChange={(e) => setCode(e.target.value.replace(/\D/g, ""))}
            placeholder="12345678"
            className="w-full rounded-md border border-slate-300 px-3 py-2.5 text-center text-lg tracking-[0.3em] focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />

          {codeError && <p className="text-sm text-red-600">{codeError}</p>}
          {resendMessage && (
            <p className="text-sm text-[#1A74A6]">{resendMessage}</p>
          )}

          <button
            type="submit"
            disabled={codeLoading || code.trim().length < 6}
            className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
          >
            {codeLoading ? "Vérification…" : "Valider le code"}
          </button>

          <button
            type="button"
            onClick={handleResend}
            disabled={codeLoading}
            className="w-full text-center text-sm text-[#1A74A6] underline disabled:opacity-50"
          >
            Renvoyer le code
          </button>
        </form>
      </div>
    );
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">
        Créer un compte
      </h1>
      <p className="mt-2 text-sm text-slate-600">
        Accès réservé aux professionnels de santé. Vous recevrez un email de
        confirmation pour finaliser votre inscription.
      </p>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label htmlFor="nom" className="block text-sm font-medium text-slate-700">
              Nom
            </label>
            <input
            id="nom"
            autoComplete="family-name"
              required
              value={nom}
              onChange={(e) => setNom(e.target.value)}
              className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
            />
          </div>
          <div>
            <label htmlFor="prenom" className="block text-sm font-medium text-slate-700">
              Prénom
            </label>
            <input
            id="prenom"
            autoComplete="given-name"
              required
              value={prenom}
              onChange={(e) => setPrenom(e.target.value)}
              className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
            />
          </div>
        </div>

        <div>
          <label htmlFor="telephone" className="block text-sm font-medium text-slate-700">
            Numéro de téléphone
          </label>
          <input
            id="telephone"
            autoComplete="tel"
            required
            type="tel"
            value={telephone}
            onChange={(e) => setTelephone(e.target.value)}
            placeholder="06 12 34 56 78"
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
        </div>

        <div>
          <label htmlFor="email" className="block text-sm font-medium text-slate-700">
            Adresse email
          </label>
          <input
            id="email"
            autoComplete="email"
            required
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
        </div>

        <div>
          <label htmlFor="profession" className="block text-sm font-medium text-slate-700">
            Profession
          </label>
          <select
            id="profession"
            required
            value={profession}
            onChange={(e) => setProfession(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          >
            <option value="" disabled>
              Sélectionnez votre profession
            </option>
            {PROFESSION_GROUPS.map((group) => (
              <optgroup key={group.label} label={group.label}>
                {group.options.map((opt) => (
                  <option key={opt} value={opt}>
                    {opt}
                  </option>
                ))}
              </optgroup>
            ))}
          </select>
          <label className="mt-2 flex items-start gap-2 text-sm text-slate-700">
            <input
              type="checkbox"
              checked={enFormation}
              onChange={(e) => setEnFormation(e.target.checked)}
              className="mt-0.5 h-4 w-4"
            />
            <span>
              (en formation) Étudiant en médecine ou paramédical, interne, résident, docteur junior : −30 % la première année, sur
              justificatif demandé à l&apos;étape suivante.
            </span>
          </label>
        </div>

        {professionEstAutre && (
          <div>
            <label htmlFor="profession-autre" className="block text-sm font-medium text-slate-700">
              Précisez votre spécialité
            </label>
            <input
            id="profession-autre"
              required
              value={professionAutre}
              onChange={(e) => setProfessionAutre(e.target.value)}
              className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
            />
          </div>
        )}

        <div>
          <label htmlFor="specialite" className="block text-sm font-medium text-slate-700">
            Spécialité que vous souhaitez consulter
          </label>
          <select
            id="specialite"
            required
            value={specialty}
            onChange={(e) => setSpecialty(e.target.value)}
            aria-describedby="specialite-aide"
            className="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          >
            <option value="" disabled>
              {specialties.length ? "Sélectionnez une spécialité" : "Liste indisponible : rechargez la page"}
            </option>
            {SPECIALTY_GROUPS.map((g) => (
              <optgroup key={g.category} label={g.label}>
                {specialties
                  .filter((s) => s.category === g.category)
                  .map((s) => (
                    <option key={s.slug} value={s.slug}>
                      {s.name}
                    </option>
                  ))}
              </optgroup>
            ))}
          </select>
          <p id="specialite-aide" className="mt-1 text-xs text-slate-500">
            Votre compte donne accès aux fiches de cette spécialité. Pour en
            changer plus tard, contactez-nous.
          </p>
        </div>

        <div className="space-y-3 rounded-md border border-slate-200 bg-slate-50 p-4">
          <label className="flex items-start gap-3 text-sm text-slate-700">
            <input
              required
              type="checkbox"
              checked={consentService}
              onChange={(e) => setConsentService(e.target.checked)}
              className="mt-0.5 h-4 w-4 rounded border-slate-300"
            />
            <span>
              J&apos;accepte les{" "}
              <Link href="/cgu" target="_blank" className="underline">
                Conditions Générales d&apos;Utilisation
              </Link>{" "}
              et la{" "}
              <Link
                href="/confidentialite"
                target="_blank"
                className="underline"
              >
                Politique de Confidentialité
              </Link>
              . Mes données (nom, prénom, téléphone, email, profession, spécialité) sont
              traitées pour créer et sécuriser mon compte.{" "}
              <em>Obligatoire.</em>
            </span>
          </label>

          <label className="flex items-start gap-3 text-sm text-slate-700">
            <input
              type="checkbox"
              checked={consentPartners}
              onChange={(e) => setConsentPartners(e.target.checked)}
              className="mt-0.5 h-4 w-4 rounded border-slate-300"
            />
            <span>
              J&apos;accepte que mes données soient partagées avec des
              entreprises partenaires à des fins commerciales (offres,
              produits ou services liés à mon activité professionnelle).{" "}
              <em>
                Facultatif — vous pouvez créer votre compte sans cocher cette
                case, et revenir sur ce choix à tout moment depuis la page
                « Mon compte ».
              </em>
            </span>
          </label>
        </div>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
        >
          {loading ? "Envoi en cours…" : "Créer mon compte"}
        </button>

        <p className="text-center text-sm text-slate-600">
          Déjà inscrit ?{" "}
          <Link href="/connexion" className="font-medium text-[#1A74A6] underline">
            Se connecter
          </Link>
        </p>
      </form>
    </div>
  );
}
