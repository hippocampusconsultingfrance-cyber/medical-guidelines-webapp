"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { passwordAssezFort, PASSWORD_RULE } from "@/lib/password";
import { deposerJustificatifInscription, envoyerBienvenue } from "./actions";

// Mêmes règles que le serveur (src/lib/etudiants.ts), pour prévenir tôt.
const STATUTS: [string, string][] = [
  ["externe", "Externe (étudiant hospitalier)"],
  ["interne", "Interne"],
  ["resident", "Résident"],
  ["docteur_junior", "Docteur junior"],
  ["autre", "Autre étudiant en santé"],
];
const TYPES = ["application/pdf", "image/jpeg", "image/png"];
const MAX = 3 * 1024 * 1024;
const ERREURS: Record<string, string> = {
  etudiant_statut: "Choisissez votre statut de formation.",
  etudiant_atteste: "Cochez l'attestation de formation.",
  etudiant_fichier: "Joignez votre justificatif de formation.",
  etudiant_format: "Justificatif : format non accepté (PDF, JPEG ou PNG).",
  etudiant_taille: "Justificatif trop lourd : 3 Mo au maximum.",
  etudiant_session: "Votre session a expiré : recommencez l'inscription.",
  etudiant_erreur:
    "Le justificatif n'a pas pu être envoyé. Réessayez dans un instant.",
};

export default function FinaliserComptePage() {
  const router = useRouter();
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
      setError("L'identifiant doit contenir au moins 3 caractères.");
      return;
    }
    if (!passwordAssezFort(password)) {
      setError(`Le mot de passe doit contenir au moins ${PASSWORD_RULE}.`);
      return;
    }
    if (password !== password2) {
      setError("Les deux mots de passe ne correspondent pas.");
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
      setError(
        "Impossible de vérifier la disponibilité de l'identifiant. Réessayez.",
      );
      return;
    }
    if (available === false) {
      setLoading(false);
      setError("Cet identifiant est déjà pris, choisissez-en un autre.");
      return;
    }

    const { data: userData, error: updateError } =
      await supabase.auth.updateUser({
        password,
      });
    if (updateError || !userData.user) {
      setLoading(false);
      setError(
        "Le mot de passe n'a pas pu être enregistré. Votre session a peut-être expiré : recommencez l'inscription.",
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
        "Compte créé, mais l'identifiant n'a pas pu être enregistré. Réessayez dans quelques instants.",
      );
      return;
    }

    // E-mail de bienvenue (une seule fois ; un échec n'empêche pas l'accès).
    await envoyerBienvenue().catch(() => undefined);
    router.push(enFormation ? "/abonnement?r=etudiant_envoye#etudiant" : "/");
  }

  return (
    <div className="mx-auto min-h-screen max-w-md px-6 py-16">
      <h1 className="text-2xl font-semibold text-slate-900">
        Finaliser votre compte
      </h1>
      <p className="mt-2 text-sm text-slate-600">
        Votre adresse email est confirmée. Choisissez un identifiant et un mot
        de passe sécurisé pour accéder au site.
      </p>

      <form onSubmit={handleSubmit} className="mt-8 space-y-5">
        <div>
          <label
            htmlFor="username"
            className="block text-sm font-medium text-slate-700"
          >
            Nom d&apos;utilisateur
          </label>
          <input
            id="username"
            required
            autoComplete="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-teal-600 focus:outline-none focus:ring-1 focus:ring-teal-600"
          />
        </div>

        <div>
          <label
            htmlFor="password"
            className="block text-sm font-medium text-slate-700"
          >
            Mot de passe
          </label>
          <input
            id="password"
            required
            type="password"
            autoComplete="new-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-teal-600 focus:outline-none focus:ring-1 focus:ring-teal-600"
          />
          <p className="mt-1 text-xs text-slate-500">
            Au moins {PASSWORD_RULE}.
          </p>
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
            className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-teal-600 focus:outline-none focus:ring-1 focus:ring-teal-600"
          />
        </div>

        {enFormation && (
          <fieldset className="space-y-4 rounded-lg border border-slate-200 p-4">
            <legend className="px-1 text-sm font-semibold text-slate-900">
              Justificatif de formation (−30 % la première année)
            </legend>
            <p className="text-xs text-slate-600">
              Vous avez indiqué être en formation. Joignez un justificatif de
              l&apos;année universitaire en cours (carte d&apos;étudiant,
              certificat de scolarité, attestation d&apos;affectation). Après
              vérification, sous 48 h en général, la réduction de 30 %
              s&apos;appliquera automatiquement à votre abonnement. Le
              justificatif est supprimé dès notre décision.
            </p>
            <div>
              <label
                htmlFor="statut"
                className="block text-sm font-medium text-slate-700"
              >
                Votre statut
              </label>
              <select
                id="statut"
                required
                value={statut}
                onChange={(e) => setStatut(e.target.value)}
                className="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm"
              >
                <option value="" disabled>
                  Choisir…
                </option>
                {STATUTS.map(([v, l]) => (
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
                Justificatif (PDF, JPEG ou PNG, 3 Mo maximum)
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
              <span>
                J&apos;atteste être en formation pour l&apos;année universitaire
                en cours.
              </span>
            </label>
          </fieldset>
        )}

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
