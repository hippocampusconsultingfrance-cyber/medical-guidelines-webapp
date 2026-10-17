"use client";

import { Suspense, useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import type { TextesSecurite } from "../compte/securite/textes";

// Saisie du code de double authentification après la connexion : la
// session passe au niveau aal2 et les droits d'administration sont rétablis.
function Formulaire({ t }: { t: TextesSecurite }) {
  const router = useRouter();
  const suite = useSearchParams().get("suite");
  const destination = suite && suite.startsWith("/") && !suite.startsWith("//") ? suite : "/bibliotheque";
  const [facteur, setFacteur] = useState<string | null>(null);
  const [code, setCode] = useState("");
  const [erreur, setErreur] = useState<string | null>(null);
  const [occupe, setOccupe] = useState(false);

  useEffect(() => {
    const supabase = createClient();
    supabase.auth.mfa.getAuthenticatorAssuranceLevel().then(async ({ data }) => {
      if (data?.currentLevel === "aal2" || data?.nextLevel !== "aal2") {
        router.replace(destination);
        return;
      }
      const { data: f } = await supabase.auth.mfa.listFactors();
      setFacteur(f?.totp?.find((x) => x.status === "verified")?.id ?? null);
    });
  }, [router, destination]);

  async function valider(e: React.FormEvent) {
    e.preventDefault();
    if (!facteur) return;
    setErreur(null);
    setOccupe(true);
    const { error } = await createClient().auth.mfa.challengeAndVerify({ factorId: facteur, code: code.trim() });
    setOccupe(false);
    if (error) {
      setErreur(t.codeIncorrect);
      return;
    }
    router.replace(destination);
    router.refresh();
  }

  return (
    <form onSubmit={valider} className="mt-6 space-y-4">
      <label className="block text-sm text-slate-700">
        {t.mfa.libelle}
        <input
          inputMode="numeric"
          autoComplete="one-time-code"
          pattern="[0-9]{6}"
          maxLength={6}
          required
          autoFocus
          value={code}
          onChange={(e) => setCode(e.target.value)}
          className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-lg tracking-widest"
        />
      </label>
      {erreur && <p className="text-sm text-red-600">{erreur}</p>}
      <button disabled={occupe || !facteur} className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm disabled:opacity-50">
        {t.mfa.valider}
      </button>
    </form>
  );
}

export default function MfaForm({ t }: { t: TextesSecurite }) {
  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">{t.mfa.titre}</h1>
      <p className="mt-2 text-sm text-slate-600">{t.mfa.intro}</p>
      <Suspense>
        <Formulaire t={t} />
      </Suspense>
    </div>
  );
}
