"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function FinaliserComptePage() {
  const router = useRouter();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [password2, setPassword2] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  function passwordAssezForte(pw: string) {
    return (
      pw.length >= 10 &&
      /[a-z]/.test(pw) &&
      /[A-Z]/.test(pw) &&
      /[0-9]/.test(pw)
    );
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    if (username.trim().length < 3) {
      setError("L'identifiant doit contenir au moins 3 caractères.");
      return;
    }
    if (!passwordAssezForte(password)) {
      setError(
        "Le mot de passe doit contenir au moins 10 caractères, une majuscule, une minuscule et un chiffre.",
      );
      return;
    }
    if (password !== password2) {
      setError("Les deux mots de passe ne correspondent pas.");
      return;
    }

    setLoading(true);
    const supabase = createClient();

    const { data: available, error: checkError } = await supabase.rpc(
      "is_username_available",
      { candidate: username.trim() },
    );
    if (checkError) {
      setLoading(false);
      setError("Impossible de vérifier la disponibilité de l'identifiant. Réessayez.");
      return;
    }
    if (available === false) {
      setLoading(false);
      setError("Cet identifiant est déjà pris, choisissez-en un autre.");
      return;
    }

    const { data: userData, error: updateError } = await supabase.auth.updateUser({
      password,
    });
    if (updateError || !userData.user) {
      setLoading(false);
      setError(
        "Une erreur est survenue lors de la création du mot de passe (" +
          (updateError?.message ?? "session invalide") +
          "). Le lien a peut-être expiré : recommencez l'inscription.",
      );
      return;
    }

    const { error: profileError } = await supabase
      .from("profiles")
      .update({ username: username.trim(), setup_completed: true })
      .eq("id", userData.user.id);

    setLoading(false);
    if (profileError) {
      setError(
        "Compte créé mais l'identifiant n'a pas pu être enregistré (" +
          profileError.message +
          "). Contactez le support.",
      );
      return;
    }

    router.push("/");
  }

  return (
    <div className="mx-auto min-h-screen max-w-md px-6 py-16">
      <h1 className="text-2xl font-semibold text-slate-900">
        Finaliser votre compte
      </h1>
      <p className="mt-2 text-sm text-slate-600">
        Votre adresse email est confirmée. Choisissez un identifiant et un
        mot de passe sécurisé pour accéder au site.
      </p>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label className="block text-sm font-medium text-slate-700">
            Nom d&apos;utilisateur
          </label>
          <input
            required
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-teal-600 focus:outline-none focus:ring-1 focus:ring-teal-600"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700">
            Mot de passe
          </label>
          <input
            required
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-teal-600 focus:outline-none focus:ring-1 focus:ring-teal-600"
          />
          <p className="mt-1 text-xs text-slate-500">
            Au moins 10 caractères, avec majuscule, minuscule et chiffre.
          </p>
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700">
            Confirmer le mot de passe
          </label>
          <input
            required
            type="password"
            value={password2}
            onChange={(e) => setPassword2(e.target.value)}
            className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-teal-600 focus:outline-none focus:ring-1 focus:ring-teal-600"
          />
        </div>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-md bg-teal-700 px-4 py-2.5 text-sm font-medium text-white hover:bg-teal-800 disabled:opacity-50"
        >
          {loading ? "Création…" : "Activer mon compte"}
        </button>
      </form>
    </div>
  );
}
