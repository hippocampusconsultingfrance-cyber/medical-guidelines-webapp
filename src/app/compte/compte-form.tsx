"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

type Profile = {
  nom: string;
  prenom: string;
  telephone: string;
  profession: string;
  profession_autre: string | null;
  username: string | null;
  consent_partners: boolean;
  // Relation many-to-one : objet unique à l'exécution, typé tableau ou objet
  // selon le client Supabase.
  specialty?: { name_i18n: { fr?: string } | null } | { name_i18n: { fr?: string } | null }[] | null;
};

type Consent = {
  consent_type: string;
  value: boolean;
  recorded_at: string;
};

const inputClass =
  "mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-teal-600 focus:outline-none focus:ring-1 focus:ring-teal-600";

function formatDate(iso: string) {
  return new Date(iso).toLocaleString("fr-FR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    timeZone: "Europe/Paris",
  });
}

export default function CompteForm({
  email,
  profile,
  consents,
}: {
  email: string;
  profile: Profile;
  consents: Consent[];
}) {
  const router = useRouter();
  const [nom, setNom] = useState(profile.nom);
  const [prenom, setPrenom] = useState(profile.prenom);
  const [telephone, setTelephone] = useState(profile.telephone);
  const [saveMessage, setSaveMessage] = useState<string | null>(null);
  const [consentMessage, setConsentMessage] = useState<string | null>(null);
  const [deleteConfirm, setDeleteConfirm] = useState("");
  const [deleteError, setDeleteError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setSaveMessage(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    const { error } = await supabase
      .from("profiles")
      .update({ nom: nom.trim(), prenom: prenom.trim(), telephone: telephone.trim() })
      .eq("id", user?.id ?? "");
    setBusy(false);
    setSaveMessage(
      error
        ? "Les modifications n'ont pas pu être enregistrées. Réessayez."
        : "Modifications enregistrées.",
    );
    if (!error) router.refresh();
  }

  async function handleConsent(value: boolean) {
    setBusy(true);
    setConsentMessage(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    const { error } = await supabase
      .from("profiles")
      .update({ consent_partners: value })
      .eq("id", user?.id ?? "");
    setBusy(false);
    setConsentMessage(
      error
        ? "Votre choix n'a pas pu être enregistré. Réessayez."
        : value
          ? "Consentement au partage avec les partenaires enregistré."
          : "Consentement retiré : vos données ne seront plus partagées avec des partenaires.",
    );
    if (!error) router.refresh();
  }

  async function handleExport() {
    setBusy(true);
    const supabase = createClient();
    const [{ data: fullProfile }, { data: consentLog }, { data: reports }] =
      await Promise.all([
        supabase.from("profiles").select("*").single(),
        supabase.from("consent_log").select("consent_type, value, recorded_at"),
        supabase
          .from("error_reports")
          .select("doc, doc_title, section, description, status, created_at"),
      ]);
    setBusy(false);

    const data = {
      exporte_le: new Date().toISOString(),
      email,
      profil: fullProfile,
      historique_consentements: consentLog ?? [],
      signalements_erreurs: reports ?? [],
    };
    const blob = new Blob([JSON.stringify(data, null, 2)], {
      type: "application/json",
    });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "mes-donnees-medical-guidelines.json";
    a.click();
    URL.revokeObjectURL(url);
  }

  async function handleDelete(e: React.FormEvent) {
    e.preventDefault();
    setDeleteError(null);
    if (deleteConfirm.trim().toUpperCase() !== "SUPPRIMER") {
      setDeleteError("Tapez SUPPRIMER pour confirmer.");
      return;
    }
    setBusy(true);
    const supabase = createClient();
    const { error } = await supabase.rpc("delete_my_account");
    if (error) {
      setBusy(false);
      setDeleteError("La suppression a échoué. Réessayez dans quelques instants.");
      return;
    }
    await supabase.auth.signOut();
    router.push("/connexion?compte=supprime");
    router.refresh();
  }

  const spec = Array.isArray(profile.specialty) ? profile.specialty[0] : profile.specialty;
  const specialtyName = spec?.name_i18n?.fr;

  return (
    <div className="mt-8 space-y-10">
      <section>
        <h2 className="text-lg font-semibold text-slate-900">
          Informations personnelles
        </h2>
        <p className="mt-1 text-sm text-slate-600">
          Profession : {profile.profession}
          {profile.profession_autre ? ` (${profile.profession_autre})` : ""}
          {specialtyName ? ` · Spécialité : ${specialtyName}` : ""}
          {profile.username ? ` · Identifiant : ${profile.username}` : ""}
        </p>
        <form onSubmit={handleSave} className="mt-4 space-y-4">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label htmlFor="nom" className="block text-sm font-medium text-slate-700">
                Nom
              </label>
              <input
                id="nom"
                required
                autoComplete="family-name"
                value={nom}
                onChange={(e) => setNom(e.target.value)}
                className={inputClass}
              />
            </div>
            <div>
              <label htmlFor="prenom" className="block text-sm font-medium text-slate-700">
                Prénom
              </label>
              <input
                id="prenom"
                required
                autoComplete="given-name"
                value={prenom}
                onChange={(e) => setPrenom(e.target.value)}
                className={inputClass}
              />
            </div>
          </div>
          <div>
            <label htmlFor="telephone" className="block text-sm font-medium text-slate-700">
              Numéro de téléphone
            </label>
            <input
              id="telephone"
              required
              type="tel"
              autoComplete="tel"
              value={telephone}
              onChange={(e) => setTelephone(e.target.value)}
              className={inputClass}
            />
          </div>
          {saveMessage && <p className="text-sm text-slate-700">{saveMessage}</p>}
          <button
            type="submit"
            disabled={busy}
            className="rounded-md bg-teal-700 px-4 py-2 text-sm font-medium text-white hover:bg-teal-800 disabled:opacity-50"
          >
            Enregistrer
          </button>
        </form>
      </section>

      <section>
        <h2 className="text-lg font-semibold text-slate-900">
          Partage avec des partenaires
        </h2>
        <p className="mt-1 text-sm text-slate-600">
          {profile.consent_partners
            ? "Vous avez accepté que vos données soient partagées avec des entreprises partenaires."
            : "Vos données ne sont pas partagées avec des entreprises partenaires."}{" "}
          Ce choix n&apos;a aucun effet sur votre accès aux fiches.
        </p>
        <button
          type="button"
          disabled={busy}
          onClick={() => handleConsent(!profile.consent_partners)}
          className="mt-3 rounded-md border border-slate-300 px-4 py-2 text-sm text-slate-800 hover:bg-slate-50 disabled:opacity-50"
        >
          {profile.consent_partners ? "Retirer mon consentement" : "Donner mon consentement"}
        </button>
        {consentMessage && <p className="mt-2 text-sm text-slate-700">{consentMessage}</p>}
        {consents.length > 0 && (
          <details className="mt-4 text-sm text-slate-600">
            <summary className="cursor-pointer">Historique de mes consentements</summary>
            <ul className="mt-2 space-y-1">
              {consents.map((c, i) => (
                <li key={i}>
                  {formatDate(c.recorded_at)} —{" "}
                  {c.consent_type === "service" ? "Conditions d'utilisation" : "Partenaires"} :{" "}
                  {c.value ? "accepté" : "refusé"}
                </li>
              ))}
            </ul>
          </details>
        )}
      </section>

      <section>
        <h2 className="text-lg font-semibold text-slate-900">Mes données</h2>
        <p className="mt-1 text-sm text-slate-600">
          Téléchargez l&apos;ensemble des données associées à votre compte
          (fichier JSON).
        </p>
        <button
          type="button"
          disabled={busy}
          onClick={handleExport}
          className="mt-3 rounded-md border border-slate-300 px-4 py-2 text-sm text-slate-800 hover:bg-slate-50 disabled:opacity-50"
        >
          Exporter mes données
        </button>
      </section>

      <section className="rounded-md border border-red-200 bg-red-50 p-4">
        <h2 className="text-lg font-semibold text-red-800">Supprimer mon compte</h2>
        <p className="mt-1 text-sm text-red-900">
          Votre compte, votre profil et l&apos;historique de vos consentements
          seront effacés définitivement. Les signalements d&apos;erreurs que
          vous avez envoyés sont conservés sans lien avec votre identité.
        </p>
        <form onSubmit={handleDelete} className="mt-3 space-y-3">
          <label htmlFor="delete-confirm" className="block text-sm text-red-900">
            Tapez <strong>SUPPRIMER</strong> pour confirmer
          </label>
          <input
            id="delete-confirm"
            value={deleteConfirm}
            onChange={(e) => setDeleteConfirm(e.target.value)}
            className={inputClass + " bg-white"}
          />
          {deleteError && <p className="text-sm text-red-700">{deleteError}</p>}
          <button
            type="submit"
            disabled={busy}
            className="rounded-md bg-red-700 px-4 py-2 text-sm font-medium text-white hover:bg-red-800 disabled:opacity-50"
          >
            Supprimer définitivement mon compte
          </button>
        </form>
      </section>
    </div>
  );
}
