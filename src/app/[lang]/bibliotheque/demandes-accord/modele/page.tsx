import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { BUCKET, type Modele } from "@/lib/demandes-accord";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../../data";
import Shell from "../../shell";
import { enregistrerModele } from "../actions";
import PieceJointe from "../piece-jointe";

export const metadata: Metadata = {
  title: "Modèle de courriel — demandes d'accord — medical-guidelines.net",
};

const REPERES: [string, string][] = [
  ["{{formule_appel}}", "« Madame la Présidente, Monsieur le Président » (ou celle de la société)"],
  ["{{la_societe}}", "« la SRLF », « le GIHP », « l'AFU »"],
  ["{{de_la_societe}}", "« de la SRLF », « du GIHP », « de l'AFU »"],
  ["{{paragraphe_place}}", "accord de la SFAR, puis la place de la société sur le site (nombre de fiches) ou l'élargissement à sa spécialité"],
  ["{{paragraphe_exemple}}", "paragraphe d'exemple propre à la société, sinon celui ci-dessous"],
  ["{{offre_lien}}", "lien vers le site, l'adhésion et le congrès (institutions : le site seulement)"],
  ["{{paragraphe_specifique}}", "paragraphe propre à la société (facultatif)"],
  ["{{paragraphe_revues}}", "question sur les droits des éditeurs de revues"],
  ["{{date_envoi}}", "relance seulement : date du premier courriel"],
];

// Modèle de courriel, de relance et pièce jointe par défaut (administrateurs).
export default async function ModelePage({ searchParams }: PageProps<"/[lang]/bibliotheque/demandes-accord/modele">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const admin = createAdminClient();
  const { data } = await admin.from("demandes_accord_modele").select("*").eq("id", 1).maybeSingle();
  const m = data as Modele | null;
  if (!m) notFound();
  const lien = m.piece_jointe_chemin ? (await admin.storage.from(BUCKET).createSignedUrl(m.piece_jointe_chemin, 600)).data?.signedUrl : undefined;

  const sp = await searchParams;
  const message = typeof sp.ok === "string" ? sp.ok : typeof sp.ko === "string" ? sp.ko : null;
  const carte = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "14px 16px" };

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">
          <Link href="/bibliotheque/demandes-accord">Demandes d&apos;accord</Link>
        </div>
        <h1>Modèle de courriel</h1>
        <div className="doc-header__meta">
          <span>Utilisé pour générer le courriel de chaque société ; un paragraphe dont le repère est vide disparaît.</span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}

      <section style={{ ...carte, margin: "14px 0" }}>
        <h2 className="block-section" style={{ marginTop: 0 }}>
          Pièce jointe par défaut
        </h2>
        <p style={{ margin: "0 0 8px" }}>
          Jointe aux sociétés qui n&apos;ont pas leur propre dossier :{" "}
          {lien ? (
            <a href={lien} target="_blank" rel="noopener noreferrer">
              {m.piece_jointe_nom ?? "fichier"} ↗
            </a>
          ) : (
            "aucune pour l'instant (conseil : le dossier de comparaison SFAR, mesure corrigée)."
          )}
        </p>
        <PieceJointe cible="modele" actuelle={m.piece_jointe_nom} />
      </section>

      <form action={enregistrerModele} style={{ ...carte, display: "grid", gap: 10 }}>
        <div className="field">
          <label htmlFor="objet">Objet</label>
          <input id="objet" name="objet" defaultValue={m.objet} required />
        </div>
        <div className="field">
          <label htmlFor="corps">Courriel</label>
          <textarea id="corps" name="corps" rows={30} defaultValue={m.corps} required style={{ fontFamily: "inherit" }} />
        </div>
        <div className="field">
          <label htmlFor="exemple_defaut">Paragraphe d&apos;exemple par défaut (accompagne la pièce jointe par défaut)</label>
          <textarea id="exemple_defaut" name="exemple_defaut" rows={4} defaultValue={m.exemple_defaut} required />
        </div>
        <div className="field">
          <label htmlFor="relance_objet">Objet de la relance</label>
          <input id="relance_objet" name="relance_objet" defaultValue={m.relance_objet} required />
        </div>
        <div className="field">
          <label htmlFor="relance_corps">Relance (même pièce jointe ; le courriel initial est cité dessous s&apos;il a été envoyé depuis l&apos;outil)</label>
          <textarea id="relance_corps" name="relance_corps" rows={12} defaultValue={m.relance_corps} required style={{ fontFamily: "inherit" }} />
        </div>
        <div>
          <button className="btn btn-primary">Enregistrer le modèle</button>
        </div>
      </form>

      <section style={{ ...carte, marginTop: 16 }}>
        <h2 className="block-section" style={{ marginTop: 0 }}>
          Repères
        </h2>
        <ul style={{ margin: 0, paddingLeft: 18, fontSize: "0.9rem" }}>
          {REPERES.map(([r, s]) => (
            <li key={r}>
              <code>{r}</code> : {s}
            </li>
          ))}
        </ul>
        <p style={{ fontSize: "0.82rem", color: "var(--ink-muted)" }}>
          Chaque envoi se termine par une mention fixe : d&apos;où vient l&apos;adresse, et « répondez STOP pour ne plus être
          contacté ».
        </p>
      </section>
    </Shell>
  );
}
