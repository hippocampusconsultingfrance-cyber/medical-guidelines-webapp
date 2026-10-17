"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useLien } from "@/i18n/client";
import { fmt } from "@/i18n/format";
import { createClient } from "@/lib/supabase/client";
import { passwordAssezFort } from "@/lib/password";
import type { TextesFinaliser } from "../textes-auth";
import { deposerJustificatifInscription, envoyerBienvenue } from "./actions";

// Mêmes règles que le serveur (src/lib/etudiants.ts), pour prévenir tôt.
const TYPES = ["application/pdf", "image/jpeg", "image/png"];
const MAX = 3 * 1024 * 1024;

// Textes (page.tsx) dans la langue de la page ; regle : règle du mot de passe.
export default function FinaliserCompteForm({ t, regle }: { t: TextesFinaliser; regle: string }) {
  const router = useRouter();
  const lien = useLien();
  const ERREURS = t.erreurs;
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [password2, setPassword2] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  // Case « en formation » cochée à l'inscription : justificatif obligatoire.
  const [enFormation, setEnFormation] = useState(false);
  const [statut, setStatut] = useState("");
  const [fichier, setFichier] = useState<File | null>(null);
  const [atteste, setAtteste] = useState(false);

  useEffect(() => {
    createClient()
      .auth.getUser()
      .then(({ data }) =>
        setEnFormation(data.user?.user_metadata?.en_formation === true),
      );
  }, []);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);

    if (username.trim().length < 3) {
      setError(t.identifiantCourt);
      return;
    }
    if (!passwordAssezFort(password)) {
      setError(fmt(t.motDePasseFaible, { regle }));
      return;
    }
    if (password !== password2) {
      setError(t.differents);
      return;
    }

    if (enFormation) {
      if (!statut) return setError(ERREURS.etudiant_statut);
      if (!fichier) return setError(ERREURS.etudiant_fichier);
      if (!TYPES.includes(fichier.type))
        return setError(ERREURS.etudiant_format);
      if (fichier.size > MAX) return setError(ERREURS.etudiant_taille);
      if (!atteste) return setError(ERREURS.etudiant_atteste);
    }

    setLoading(true);
    const supabase = createClient();

    if (enFormation) {
      const fd = new FormData();
      fd.set("statut", statut);
      fd.set("justificatif", fichier!);
      fd.set("atteste", "1");
      const r = await deposerJustificatifInscription(fd).catch(
        () => "etudiant_erreur",
      );
      if (r !== "etudiant_envoye") {
        setLoading(false);
        setError(ERREURS[r] ?? ERREURS.etudiant_erreur);
        return;
      }
    }

    const { data: available, error: checkError } = await supabase.rpc(
      "is_username_available",
      { candidate: username.trim() },
    );
    if (checkError) {
      setLoading(false);
      setError(t.verificationImpossible);
      return;
    }
    if (available === false) {
      setLoading(false);
      setError(t.identifiantPris);
      return;
    }

    const { data: userData, error: updateError } =
      await supabase.auth.updateUser({
        password,
      });
    if (updateError || !userData.user) {
      setLoading(false);
      setError(t.motDePasseNonEnregistre);
      return;
    }

    const { error: profileError } = await supabase
      .from("profiles")
      .update({ username: username.trim(), setup_completed: true })
      .eq("id", userData.user.id);

    setLoading(false);
    if (profileError) {
      setError(t.identifiantNonEnregistre);
      return;
    }

    // E-mail de bienvenue (une seule fois ; un échec n'empêche pas l'accès).
    await envoyerBienvenue().catch(() => undefined);
    router.push(lien(enFormation ? "/abonnement?r=etudiant_envoye#etudiant" : "/"));
  }

  return (
    <div className="w-full">
      <h1 className="text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>
      <p className="mt-2 text-sm text-slate-600">{t.intro}</p>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label
            htmlFor="username"
            className="block text-sm font-medium text-slate-700"
          >
            {t.identifiant}
          </label>
          <input
            id="username"
            required
            autoComplete="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
          />
        </div>

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

        {enFormation && (
          <fieldset className="space-y-4 rounded-lg border border-slate-200 p-4">
            <legend className="px-1 text-sm font-semibold text-slate-900">
              {t.justificatifTitre}
            </legend>
            <p className="text-xs text-slate-600">{t.justificatifTexte}</p>
            <div>
              <label
                htmlFor="statut"
                className="block text-sm font-medium text-slate-700"
              >
                {t.statut}
              </label>
              <select
                id="statut"
                required
                value={statut}
                onChange={(e) => setStatut(e.target.value)}
                className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm"
              >
                <option value="" disabled>
                  {t.choisir}
                </option>
                {t.statuts.map(([v, l]) => (
                  <option key={v} value={v}>
                    {l}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label
                htmlFor="justificatif"
                className="block text-sm font-medium text-slate-700"
              >
                {t.fichier}
              </label>
              <input
                id="justificatif"
                type="file"
                required
                accept="application/pdf,image/jpeg,image/png"
                onChange={(e) => setFichier(e.target.files?.[0] ?? null)}
                className="mt-1 block w-full text-sm"
              />
            </div>
            <label className="flex items-start gap-3 text-sm text-slate-700">
              <input
                type="checkbox"
                checked={atteste}
                onChange={(e) => setAtteste(e.target.checked)}
                className="mt-0.5 h-4 w-4"
              />
              <span>{t.atteste}</span>
            </label>
          </fieldset>
        )}

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
        >
          {loading ? t.creation : t.activer}
        </button>
      </form>
    </div>
  );
}
