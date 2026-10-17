"use client";

import { Suspense, useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { useLangue } from "@/i18n/client";
import { fmt } from "@/i18n/format";
import { LOCALES, chemin } from "@/lib/langues";
import { createClient } from "@/lib/supabase/client";
import type { TextesSecurite } from "./textes";

type Facteur = { id: string; friendly_name?: string | null; status: string; created_at: string };

// Double authentification (code à 6 chiffres d'une application comme
// Google Authenticator, Microsoft Authenticator ou l'app Mots de passe
// d'Apple). Recommandée pour tous ; obligatoire pour les comptes de l'équipe
// éditoriale : sans code saisi, la base leur refuse les droits d'équipe
// (mfa_satisfaite) et la bibliothèque les renvoie ici (?obligatoire=1).
function AvisObligatoire({ texte }: { texte: string }) {
  if (useSearchParams().get("obligatoire") !== "1") return null;
  return <p className="mt-4 rounded-lg border border-amber-300 bg-amber-50 p-3 text-sm text-amber-950">{texte}</p>;
}

export default function Reglage({ t }: { t: TextesSecurite }) {
  const langue = useLangue();
  const [facteurs, setFacteurs] = useState<Facteur[]>([]);
  const [chargement, setChargement] = useState(true);
  const [enrolement, setEnrolement] = useState<{ id: string; qr: string; secret: string } | null>(null);
  const [code, setCode] = useState("");
  const [message, setMessage] = useState<string | null>(null);
  const [erreur, setErreur] = useState<string | null>(null);
  const [occupe, setOccupe] = useState(false);

  const charger = useCallback(
    () =>
      createClient()
        .auth.mfa.listFactors()
        .then(({ data }) => {
          setFacteurs(((data?.totp ?? []) as Facteur[]).filter((f) => f.status === "verified"));
          setChargement(false);
        }),
    [],
  );

  useEffect(() => {
    void charger();
  }, [charger]);

  async function commencer() {
    setErreur(null);
    setMessage(null);
    setOccupe(true);
    const supabase = createClient();
    // Un essai d'activation interrompu laisse un facteur non vérifié : on le retire.
    const { data: liste } = await supabase.auth.mfa.listFactors();
    for (const f of (liste?.all ?? []) as Facteur[]) {
      if (f.status !== "verified") await supabase.auth.mfa.unenroll({ factorId: f.id });
    }
    const { data, error } = await supabase.auth.mfa.enroll({ factorType: "totp", friendlyName: t.nomFacteur });
    setOccupe(false);
    if (error || !data) {
      setErreur(t.erreurDemarrage);
      return;
    }
    setEnrolement({ id: data.id, qr: data.totp.qr_code, secret: data.totp.secret });
  }

  async function verifier(e: React.FormEvent) {
    e.preventDefault();
    if (!enrolement) return;
    setErreur(null);
    setOccupe(true);
    const { error } = await createClient().auth.mfa.challengeAndVerify({ factorId: enrolement.id, code: code.trim() });
    setOccupe(false);
    if (error) {
      setErreur(t.codeIncorrect);
      return;
    }
    setEnrolement(null);
    setCode("");
    setMessage(t.activee);
    charger();
  }

  async function desactiver(id: string) {
    if (!confirm(t.confirmerDesactivation)) return;
    setErreur(null);
    const { error } = await createClient().auth.mfa.unenroll({ factorId: id });
    if (error) {
      setErreur(t.desactivationImpossible);
      return;
    }
    setMessage(t.desactivee);
    charger();
  }

  return (
    <div className="mx-auto min-h-screen max-w-md px-6 py-12">
      <p className="text-sm">
        <Link href={chemin(langue, "/compte")} className="text-[#1A74A6] underline">
          {t.monCompte}
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">{t.titre}</h1>
      <p className="mt-2 text-sm text-slate-600">{t.intro}</p>

      <Suspense>
        <AvisObligatoire texte={t.obligatoire} />
      </Suspense>
      {message && <p className="mt-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-900">{message}</p>}
      {erreur && <p className="mt-4 rounded-lg bg-red-50 p-3 text-sm text-red-800">{erreur}</p>}

      {chargement ? (
        <p className="mt-6 text-sm text-slate-500">{t.chargement}</p>
      ) : facteurs.length ? (
        <div className="mt-6 rounded-lg border border-emerald-200 p-4">
          <p className="font-semibold text-emerald-800">{t.etatActivee}</p>
          {facteurs.map((f) => (
            <div key={f.id} className="mt-2 flex items-center justify-between gap-3 text-sm">
              <span>
                {f.friendly_name || t.application}
                {fmt(t.depuis, { date: new Date(f.created_at).toLocaleDateString(LOCALES[langue]) })}
              </span>
              <button onClick={() => desactiver(f.id)} className="text-red-700 underline">
                {t.desactiver}
              </button>
            </div>
          ))}
        </div>
      ) : enrolement ? (
        <form onSubmit={verifier} className="mt-6 space-y-4">
          <p className="text-sm text-slate-700">{t.etape1}</p>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={enrolement.qr} alt={t.qrAlt} width={200} height={200} className="mx-auto" />
          <p className="text-xs text-slate-500 break-all">
            {t.cle} <code>{enrolement.secret}</code>
          </p>
          <label className="block text-sm text-slate-700">
            {t.etape2}
            <input
              inputMode="numeric"
              autoComplete="one-time-code"
              pattern="[0-9]{6}"
              maxLength={6}
              required
              value={code}
              onChange={(e) => setCode(e.target.value)}
              className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-lg tracking-widest"
            />
          </label>
          <button disabled={occupe} className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm disabled:opacity-50">
            {t.activer}
          </button>
        </form>
      ) : (
        <button
          onClick={commencer}
          disabled={occupe}
          className="mt-6 w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm disabled:opacity-50"
        >
          {t.activerDouble}
        </button>
      )}
    </div>
  );
}
