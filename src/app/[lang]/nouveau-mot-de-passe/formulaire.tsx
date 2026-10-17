"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useLien } from "@/i18n/client";
import { fmt } from "@/i18n/format";
import { createClient } from "@/lib/supabase/client";
import { passwordAssezFort } from "@/lib/password";
import type { TextesNouveau } from "../textes-auth";

// Atteinte après le lien de réinitialisation (voir /auth/callback) : la
// session est déjà ouverte, il ne reste qu'à enregistrer le mot de passe.
export default function NouveauMotDePasseForm({ t, regle }: { t: TextesNouveau; regle: string }) {
  const router = useRouter();
  const lien = useLien();
  const [password, setPassword] = useState("");
  const [password2, setPassword2] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    if (!passwordAssezFort(password)) {
      setError(fmt(t.faible, { regle }));
      return;
    }
    if (password !== password2) {
      setError(t.differents);
      return;
    }

    setLoading(true);
    const supabase = createClient();
    const { error: updateError } = await supabase.auth.updateUser({ password });
    setLoading(false);

    if (updateError) {
      setError(t.nonEnregistre);
      return;
    }
    router.push(lien("/"));
    router.refresh();
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label
            htmlFor="password"
            className="block text-sm font-medium text-slate-700"
          >
            {t.motDePasse}
          </label>
          <input
            id="password"
            required
            type="password"
            autoComplete="new-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
          <p className="mt-1 text-xs text-slate-500">{fmt(t.auMoins, { regle })}</p>
        </div>

        <div>
          <label
            htmlFor="password2"
            className="block text-sm font-medium text-slate-700"
          >
            {t.confirmer}
          </label>
          <input
            id="password2"
            required
            type="password"
            autoComplete="new-password"
            value={password2}
            onChange={(e) => setPassword2(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
        </div>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
        >
          {loading ? t.enregistrement : t.enregistrer}
        </button>
      </form>
    </div>
  );
}
