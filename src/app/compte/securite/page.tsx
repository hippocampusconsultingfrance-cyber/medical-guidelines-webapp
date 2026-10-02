"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

type Facteur = { id: string; friendly_name?: string | null; status: string; created_at: string };

// Double authentification (code à 6 chiffres d'une application comme
// Google Authenticator, Microsoft Authenticator ou l'app Mots de passe
// d'Apple). Recommandée pour tous ; exigée en pratique pour les comptes de
// l'équipe : une fois activée, les droits d'administration demandent le code
// (règle appliquée par la base).
export default function SecuritePage() {
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
    const { data, error } = await supabase.auth.mfa.enroll({ factorType: "totp", friendlyName: "Téléphone" });
    setOccupe(false);
    if (error || !data) {
      setErreur("L'activation n'a pas pu démarrer. Réessayez dans un instant.");
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
      setErreur("Code incorrect ou expiré : saisissez le code affiché maintenant dans l'application.");
      return;
    }
    setEnrolement(null);
    setCode("");
    setMessage("Double authentification activée. Le code vous sera demandé à chaque nouvelle connexion.");
    charger();
  }

  async function desactiver(id: string) {
    if (!confirm("Désactiver la double authentification ? Votre compte sera moins protégé.")) return;
    setErreur(null);
    const { error } = await createClient().auth.mfa.unenroll({ factorId: id });
    if (error) {
      setErreur("Désactivation impossible : saisissez d'abord votre code (reconnexion), puis réessayez.");
      return;
    }
    setMessage("Double authentification désactivée.");
    charger();
  }

  return (
    <div className="mx-auto min-h-screen max-w-md px-6 py-12">
      <p className="text-sm">
        <Link href="/compte" className="text-[#1C7FB6] underline">
          ← Mon compte
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">Double authentification</h1>
      <p className="mt-2 text-sm text-slate-600">
        En plus du mot de passe, un code à 6 chiffres donné par une application de votre téléphone (Google
        Authenticator, Microsoft Authenticator, ou l&apos;app Mots de passe de l&apos;iPhone). Même si votre mot de
        passe était volé, personne ne pourrait se connecter sans votre téléphone.
      </p>

      {message && <p className="mt-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-900">{message}</p>}
      {erreur && <p className="mt-4 rounded-lg bg-red-50 p-3 text-sm text-red-800">{erreur}</p>}

      {chargement ? (
        <p className="mt-6 text-sm text-slate-500">Chargement…</p>
      ) : facteurs.length ? (
        <div className="mt-6 rounded-lg border border-emerald-200 p-4">
          <p className="font-semibold text-emerald-800">✓ Activée</p>
          {facteurs.map((f) => (
            <div key={f.id} className="mt-2 flex items-center justify-between gap-3 text-sm">
              <span>
                {f.friendly_name || "Application d'authentification"} — depuis le{" "}
                {new Date(f.created_at).toLocaleDateString("fr-FR")}
              </span>
              <button onClick={() => desactiver(f.id)} className="text-red-700 underline">
                Désactiver
              </button>
            </div>
          ))}
        </div>
      ) : enrolement ? (
        <form onSubmit={verifier} className="mt-6 space-y-4">
          <p className="text-sm text-slate-700">
            1. Dans l&apos;application, ajoutez un compte en scannant ce QR code (sur iPhone : réglages
            Mots de passe → « Configurer un code de validation »).
          </p>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={enrolement.qr} alt="QR code de double authentification" width={200} height={200} className="mx-auto" />
          <p className="text-xs text-slate-500 break-all">
            Sans appareil photo, saisissez cette clé : <code>{enrolement.secret}</code>
          </p>
          <label className="block text-sm text-slate-700">
            2. Saisissez le code à 6 chiffres affiché par l&apos;application
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
            Activer
          </button>
        </form>
      ) : (
        <button
          onClick={commencer}
          disabled={occupe}
          className="mt-6 w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm disabled:opacity-50"
        >
          Activer la double authentification
        </button>
      )}
    </div>
  );
}
