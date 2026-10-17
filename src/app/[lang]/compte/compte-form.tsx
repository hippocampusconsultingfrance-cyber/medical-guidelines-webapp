"use client";

import { useState } from "react";
import { usePathname, useRouter } from "next/navigation";
import { useLangue } from "@/i18n/client";
import { fmt, riche } from "@/i18n/format";
import { COOKIE_LANGUE, LANGUES_OUVERTES, LOCALES, NOMS_LANGUES, chemin, decouper, estOuverte } from "@/lib/langues";
import { createClient } from "@/lib/supabase/client";
import type { TextesCompteForm } from "./textes";

type Profile = {
  nom: string;
  prenom: string;
  telephone: string;
  profession: string;
  profession_autre: string | null;
  username: string | null;
  consent_partners: boolean;
};

type Consent = {
  consent_type: string;
  value: boolean;
  recorded_at: string;
};

const inputClass =
  "mt-1 w-full rounded-lg border border-slate-300 px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30";

function formatDate(iso: string, locale: string) {
  return new Date(iso).toLocaleString(locale, {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    timeZone: "Europe/Paris",
  });
}

// Profession et spécialité : libellés dans la langue de la page (page.tsx).
export default function CompteForm({
  email,
  profile,
  profession,
  specialite,
  consents,
  t,
}: {
  email: string;
  profile: Profile;
  profession: string;
  specialite: string | null;
  consents: Consent[];
  t: TextesCompteForm;
}) {
  const router = useRouter();
  const langue = useLangue();
  const pathname = usePathname() ?? "/compte";
  const [langueMessage, setLangueMessage] = useState<string | null>(null);
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
    setSaveMessage(error ? t.enregistreErreur : t.enregistre);
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
    setConsentMessage(error ? t.consentementErreur : value ? t.consentementDonne : t.consentementRetire);
    if (!error) router.refresh();
  }

  async function handleExport() {
    setBusy(true);
    const supabase = createClient();
    // Filtre explicite : un administrateur lit aussi les lignes des autres comptes.
    const {
      data: { user },
    } = await supabase.auth.getUser();
    const uid = user?.id ?? "";
    const [
      { data: fullProfile },
      { data: consentLog },
      { data: reports },
      { data: favorites },
      { data: follows },
      { data: alerts },
      { data: history },
      { data: suggestions },
    ] = await Promise.all([
      supabase.from("profiles").select("*").eq("id", uid).single(),
      supabase.from("consent_log").select("consent_type, value, recorded_at"),
      supabase
        .from("error_reports")
        .select("doc, doc_title, section, description, status, created_at")
        .eq("user_id", uid),
      supabase.from("favorites").select("document_id, created_at").eq("user_id", uid),
      supabase
        .from("notification_preferences")
        .select("society_id, created_at, societies(acronym)")
        .eq("user_id", uid),
      supabase.from("notifications_log").select("subject, body, document_id, channel, sent_at").eq("user_id", uid),
      supabase.from("consultation_history").select("document_id, viewed_at").eq("user_id", uid),
      supabase.from("site_suggestions").select("categorie, page, message, status, created_at").eq("user_id", uid),
    ]);
    setBusy(false);

    const data = {
      exporte_le: new Date().toISOString(),
      email,
      profil: fullProfile,
      historique_consentements: consentLog ?? [],
      signalements_erreurs: reports ?? [],
      favoris: favorites ?? [],
      societes_suivies: follows ?? [],
      alertes_envoyees: alerts ?? [],
      historique_consultation: history ?? [],
      suggestions: suggestions ?? [],
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
    if (deleteConfirm.trim().toUpperCase() !== t.mot) {
      setDeleteError(t.taperErreur);
      return;
    }
    setBusy(true);
    const supabase = createClient();
    const { error } = await supabase.rpc("delete_my_account");
    if (error) {
      setBusy(false);
      setDeleteError(t.suppressionErreur);
      return;
    }
    await supabase.auth.signOut();
    router.push(chemin(langue, "/connexion?compte=supprime"));
    router.refresh();
  }

  // Langue du site et des e-mails : enregistrée dans le profil, puis la
  // même page dans la nouvelle langue.
  async function handleLangue(nouvelle: string) {
    if (!estOuverte(nouvelle) || nouvelle === langue) return;
    setBusy(true);
    setLangueMessage(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    const { error } = await supabase
      .from("profiles")
      .update({ langue_preferee: nouvelle })
      .eq("id", user?.id ?? "");
    setBusy(false);
    if (error) {
      setLangueMessage(t.langueErreur);
      return;
    }
    document.cookie = `${COOKIE_LANGUE}=${nouvelle}; path=/; max-age=31536000; samesite=lax`;
    window.location.assign(chemin(nouvelle, decouper(pathname).reste));
  }

  return (
    <div className="mt-8 space-y-10">
      <section>
        <h2 className="text-lg font-semibold text-slate-900">{t.langueTitre}</h2>
        <p className="mt-1 text-sm text-slate-600">{t.langueTexte}</p>
        <select
          aria-label={t.langueTitre}
          value={langue}
          disabled={busy}
          onChange={(e) => handleLangue(e.target.value)}
          className="mt-3 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm"
        >
          {LANGUES_OUVERTES.map((l) => (
            <option key={l} value={l} lang={l}>
              {NOMS_LANGUES[l]}
            </option>
          ))}
        </select>
        {langueMessage && <p className="mt-2 text-sm text-red-700">{langueMessage}</p>}
      </section>

      <section>
        <h2 className="text-lg font-semibold text-slate-900">{t.infos}</h2>
        <p className="mt-1 text-sm text-slate-600">
          {fmt(t.profession, { profession })}
          {profile.profession_autre ? ` (${profile.profession_autre})` : ""}
          {specialite ? fmt(t.specialite, { specialite }) : ""}
          {profile.username ? fmt(t.identifiant, { identifiant: profile.username }) : ""}
        </p>
        <form onSubmit={handleSave} className="mt-4 space-y-4">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label htmlFor="nom" className="block text-sm font-medium text-slate-700">
                {t.nom}
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
                {t.prenom}
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
              {t.telephone}
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
            className="rounded-lg bg-[#0E3A78] px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
          >
            {t.enregistrer}
          </button>
        </form>
      </section>

      <section>
        <h2 className="text-lg font-semibold text-slate-900">{t.partageTitre}</h2>
        <p className="mt-1 text-sm text-slate-600">
          {profile.consent_partners ? t.partageOui : t.partageNon} {t.partageEffet}
        </p>
        <button
          type="button"
          disabled={busy}
          onClick={() => handleConsent(!profile.consent_partners)}
          className="mt-3 rounded-md border border-slate-300 px-4 py-2 text-sm text-slate-800 hover:bg-slate-50 disabled:opacity-50"
        >
          {profile.consent_partners ? t.retirer : t.donner}
        </button>
        {consentMessage && <p className="mt-2 text-sm text-slate-700">{consentMessage}</p>}
        {consents.length > 0 && (
          <details className="mt-4 text-sm text-slate-600">
            <summary className="cursor-pointer">{t.historique}</summary>
            <ul className="mt-2 space-y-1">
              {consents.map((c, i) => (
                <li key={i}>
                  {formatDate(c.recorded_at, LOCALES[langue])} — {c.consent_type === "service" ? t.cgu : t.partenaires} :{" "}
                  {c.value ? t.accepte : t.refuse}
                </li>
              ))}
            </ul>
          </details>
        )}
      </section>

      <section>
        <h2 className="text-lg font-semibold text-slate-900">{t.donneesTitre}</h2>
        <p className="mt-1 text-sm text-slate-600">{t.donneesTexte}</p>
        <button
          type="button"
          disabled={busy}
          onClick={handleExport}
          className="mt-3 rounded-md border border-slate-300 px-4 py-2 text-sm text-slate-800 hover:bg-slate-50 disabled:opacity-50"
        >
          {t.exporter}
        </button>
      </section>

      <section className="rounded-md border border-red-200 bg-red-50 p-4">
        <h2 className="text-lg font-semibold text-red-800">{t.supprimerTitre}</h2>
        <p className="mt-1 text-sm text-red-900">{t.supprimerTexte}</p>
        <form onSubmit={handleDelete} className="mt-3 space-y-3">
          <label htmlFor="delete-confirm" className="block text-sm text-red-900">
            {riche(t.taper, { b: (c) => <strong>{c}</strong> })}
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
            {t.supprimer}
          </button>
        </form>
      </section>
    </div>
  );
}
