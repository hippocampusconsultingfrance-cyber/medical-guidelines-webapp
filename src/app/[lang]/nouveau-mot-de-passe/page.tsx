"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { passwordAssezFort, PASSWORD_RULE } from "@/lib/password";

// Atteinte après le lien de réinitialisation (voir /auth/callback) : la
// session est déjà ouverte, il ne reste qu'à enregistrer le mot de passe.
export default function NouveauMotDePassePage() {
  const router = useRouter();
  const [password, setPassword] = useState("");
  const [password2, setPassword2] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    if (!passwordAssezFort(password)) {
      setError(`Le mot de passe doit contenir ${PASSWORD_RULE}.`);
      return;
    }
    if (password !== password2) {
      setError("Les deux mots de passe ne correspondent pas.");
      return;
    }

    setLoading(true);
    const supabase = createClient();
    const { error: updateError } = await supabase.auth.updateUser({ password });
    setLoading(false);

    if (updateError) {
      setError(
        "Le mot de passe n'a pas pu être enregistré. Le lien a peut-être expiré : refaites une demande depuis « Mot de passe oublié ».",
      );
      return;
    }
    router.push("/");
    router.refresh();
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">
        Nouveau mot de passe
      </h1>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label
            htmlFor="password"
            className="block text-sm font-medium text-slate-700"
          >
            Nouveau mot de passe
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
          <p className="mt-1 text-xs text-slate-500">Au moins {PASSWORD_RULE}.</p>
        </div>

        <div>
          <label
            htmlFor="password2"
            className="block text-sm font-medium text-slate-700"
          >
            Confirmer le mot de passe
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
          {loading ? "Enregistrement…" : "Enregistrer"}
        </button>
      </form>
    </div>
  );
}
