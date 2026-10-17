"use client";

import { CGU_VERSION } from "@/lib/legal";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useLien } from "@/i18n/client";
import { fmt, riche } from "@/i18n/format";
import type { LangueOuverte } from "@/lib/langues";
import { createClient } from "@/lib/supabase/client";
import type { TextesInscription } from "../textes-auth";

export type Specialty = { slug: string; category: string; isOther: boolean; name: string; couverte: boolean };
export type GroupeProfessions = { label: string; options: { value: string; label: string }[] };

// Liste des spécialités et des professions lue par le serveur (page.tsx),
// dans la langue de la page : pas d'attente à l'affichage du formulaire.
export default function InscriptionForm({
  specialties,
  professions,
  t,
  langue,
}: {
  specialties: Specialty[];
  professions: GroupeProfessions[];
  t: TextesInscription;
  langue: LangueOuverte;
}) {
  const router = useRouter();
  const lien = useLien();
  const groupesSpecialites = [
    { category: "medicale", label: t.groupeMedical },
    { category: "paramedicale", label: t.groupeParamedical },
  ];
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
          cgu_version: CGU_VERSION,
          consent_partners: consentPartners,
          en_formation: enFormation,
          // Langue du membre (e-mails), recopiée dans son profil.
          langue,
        },
      },
    });
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    if (!consentService) {
      setError(t.erreurCgu);
      return;
    }
    if (professionEstAutre && professionAutre.trim().length < 2) {
      setError(t.erreurAutre);
      return;
    }

    setLoading(true);
    const { error: signUpError } = await sendOtp();
    setLoading(false);

    if (signUpError) {
      setError(
        signUpError.status === 429
          ? t.erreurTrop
          : t.erreurEnvoi,
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
      setCodeError(t.erreurCode);
      return;
    }
    router.push(lien("/finaliser-compte"));
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
          ? t.erreurTropRenvoi
          : t.erreurRenvoi,
      );
      return;
    }
    setResendMessage(fmt(t.renvoye, { email }));
  }

  if (submitted) {
    return (
      <div className="flex flex-col text-center">
        <h1 className="text-2xl font-bold text-[#0E3A78]">{t.verifiezTitre}</h1>
        <p className="mt-4 text-slate-600">{riche(t.verifiezTexte, { b: (c) => <strong>{c}</strong> }, { email })}</p>

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
            {codeLoading ? t.verification : t.validerCode}
          </button>

          <button
            type="button"
            onClick={handleResend}
            disabled={codeLoading}
            className="w-full text-center text-sm text-[#1A74A6] underline disabled:opacity-50"
          >
            {t.renvoyer}
          </button>
        </form>
      </div>
    );
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>
      <p className="mt-2 text-sm text-slate-600">{t.intro}</p>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label htmlFor="nom" className="block text-sm font-medium text-slate-700">
              {t.nom}
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
              {t.prenom}
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
            {t.telephone}
          </label>
          <input
            id="telephone"
            autoComplete="tel"
            required
            type="tel"
            value={telephone}
            onChange={(e) => setTelephone(e.target.value)}
            placeholder={t.telephoneExemple}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
        </div>

        <div>
          <label htmlFor="email" className="block text-sm font-medium text-slate-700">
            {t.email}
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
            {t.profession}
          </label>
          <select
            id="profession"
            required
            value={profession}
            onChange={(e) => setProfession(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          >
            <option value="" disabled>
              {t.choisirProfession}
            </option>
            {professions.map((group) => (
              <optgroup key={group.label} label={group.label}>
                {group.options.map((opt) => (
                  <option key={opt.value} value={opt.value}>
                    {opt.label}
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
            <span>{t.enFormation}</span>
          </label>
        </div>

        {professionEstAutre && (
          <div>
            <label htmlFor="profession-autre" className="block text-sm font-medium text-slate-700">
              {t.preciser}
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
            {t.specialite}
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
              {specialties.length ? t.choisirSpecialite : t.listeIndisponible}
            </option>
            {groupesSpecialites.map((g) => (
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
            {t.aideSpecialite}
          </p>
          {specialty && specialties.find((s) => s.slug === specialty)?.couverte === false && (
            <p role="note" className="mt-2 rounded-md bg-amber-50 p-3 text-xs leading-relaxed text-amber-900">
              {t.peuCouverte}
            </p>
          )}
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
              {riche(t.consentement, {
                cgu: (c) => (
                  <Link href={lien("/cgu")} target="_blank" className="underline">
                    {c}
                  </Link>
                ),
                confidentialite: (c) => (
                  <Link href={lien("/confidentialite")} target="_blank" className="underline">
                    {c}
                  </Link>
                ),
                em: (c) => <em>{c}</em>,
              })}
            </span>
          </label>

          <label className="flex items-start gap-3 text-sm text-slate-700">
            <input
              type="checkbox"
              checked={consentPartners}
              onChange={(e) => setConsentPartners(e.target.checked)}
              className="mt-0.5 h-4 w-4 rounded border-slate-300"
            />
            <span>{riche(t.partenaires, { em: (c) => <em>{c}</em> })}</span>
          </label>
        </div>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
        >
          {loading ? t.envoi : t.creer}
        </button>

        <p className="text-center text-sm text-slate-600">
          {t.dejaInscrit}{" "}
          <Link href={lien("/connexion")} className="font-medium text-[#1A74A6] underline">
            {t.seConnecter}
          </Link>
        </p>
      </form>
    </div>
  );
}
