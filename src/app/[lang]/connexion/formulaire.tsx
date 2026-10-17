"use client";

import { useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";
import { useLien } from "@/i18n/client";
import { createClient } from "@/lib/supabase/client";
import type { TextesConnexion } from "../textes-auth";

// Formulaire de connexion (textes : page.tsx, dans la langue de la page).
export default function ConnexionForm({ t }: { t: TextesConnexion }) {
  const router = useRouter();
  const lien = useLien();
  const searchParams = useSearchParams();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const accountDeleted = searchParams.get("compte") === "supprime";
  const [error, setError] = useState<string | null>(
    searchParams.get("erreur") === "lien-invalide"
      ? t.lienInvalide
      : null,
  );

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const supabase = createClient();
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    setLoading(false);
    if (signInError) {
      setError(t.incorrect);
      return;
    }
    router.push(lien("/"));
    router.refresh();
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>

      {accountDeleted && (
        <p className="mt-4 rounded-md bg-slate-100 p-3 text-sm text-slate-700">
          {t.supprime}
        </p>
      )}

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-slate-700">
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

        <div>
          <label htmlFor="password" className="block text-sm font-medium text-slate-700">
            {t.motDePasse}
          </label>
          <input
            id="password"
            required
            type="password"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
        </div>

        <p className="text-end text-sm">
          <Link
            href={lien("/mot-de-passe-oublie")}
            className="text-[#1A74A6] underline"
          >
            {t.oublie}
          </Link>
        </p>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
        >
          {loading ? t.enCours : t.bouton}
        </button>

        <p className="text-center text-sm text-slate-600">
          {t.pasDeCompte}{" "}
          <Link
            href={lien("/inscription")}
            className="font-medium text-[#1A74A6] underline"
          >
            {t.inscrire}
          </Link>
        </p>
      </form>
    </div>
  );
}
