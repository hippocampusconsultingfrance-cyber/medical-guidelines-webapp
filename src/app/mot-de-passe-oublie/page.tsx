"use client";

import { useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

export default function MotDePasseOubliePage() {
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
      setError(
        "Trop de demandes en peu de temps. Patientez quelques minutes puis réessayez.",
      );
      return;
    }
    // Même message que l'adresse existe ou non, pour ne pas révéler
    // quelles adresses ont un compte.
    setSent(true);
  }

  if (sent) {
    return (
      <div className="flex flex-col text-center">
        <h1 className="text-2xl font-bold text-[#0E3A78]">
          Vérifiez votre boîte email
        </h1>
        <p className="mt-4 text-slate-600">
          Si un compte existe pour <strong>{email}</strong>, un lien pour
          choisir un nouveau mot de passe vient d&apos;y être envoyé.
        </p>
        <p className="mt-6 text-sm">
          <Link href="/connexion" className="text-[#1C7FB6] underline">
            Retour à la connexion
          </Link>
        </p>
      </div>
    );
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">
        Mot de passe oublié
      </h1>
      <p className="mt-2 text-sm text-slate-600">
        Indiquez l&apos;adresse email de votre compte : vous recevrez un lien
        pour choisir un nouveau mot de passe.
      </p>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label
            htmlFor="email"
            className="block text-sm font-medium text-slate-700"
          >
            Email
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
          {loading ? "Envoi…" : "Recevoir le lien"}
        </button>

        <p className="text-center text-sm text-slate-600">
          <Link href="/connexion" className="font-medium text-[#1C7FB6] underline">
            Retour à la connexion
          </Link>
        </p>
      </form>
    </div>
  );
}
