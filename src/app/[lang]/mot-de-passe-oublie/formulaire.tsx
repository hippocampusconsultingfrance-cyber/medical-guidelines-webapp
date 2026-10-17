"use client";

import { useState } from "react";
import Link from "next/link";
import { useLien } from "@/i18n/client";
import { riche } from "@/i18n/format";
import { createClient } from "@/lib/supabase/client";
import type { TextesOublie } from "../textes-auth";

export default function MotDePasseOublieForm({ t }: { t: TextesOublie }) {
  const lien = useLien();
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [sent, setSent] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const supabase = createClient();
    const { error: resetError } = await supabase.auth.resetPasswordForEmail(
      email,
      { redirectTo: `${window.location.origin}/auth/callback?type=recovery` },
    );

    setLoading(false);
    if (resetError?.status === 429) {
      setError(t.trop);
      return;
    }
    // Même message que l'adresse existe ou non, pour ne pas révéler
    // quelles adresses ont un compte.
    setSent(true);
  }

  if (sent) {
    return (
      <div className="flex flex-col text-center">
        <h1 className="text-2xl font-bold text-[#0E3A78]">{t.verifiezTitre}</h1>
        <p className="mt-4 text-slate-600">{riche(t.verifiezTexte, { b: (c) => <strong>{c}</strong> }, { email })}</p>
        <p className="mt-6 text-sm">
          <Link href={lien("/connexion")} className="text-[#1A74A6] underline">
            {t.retour}
          </Link>
        </p>
      </div>
    );
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>
      <p className="mt-2 text-sm text-slate-600">{t.intro}</p>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label
            htmlFor="email"
            className="block text-sm font-medium text-slate-700"
          >
            {t.email}
          </label>
          <input
            id="email"
            required
            type="email"
            autoComplete="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
        </div>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
        >
          {loading ? t.envoi : t.recevoir}
        </button>

        <p className="text-center text-sm text-slate-600">
          <Link href={lien("/connexion")} className="font-medium text-[#1A74A6] underline">
            {t.retour}
          </Link>
        </p>
      </form>
    </div>
  );
}
