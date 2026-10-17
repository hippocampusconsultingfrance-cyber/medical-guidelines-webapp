import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { debutFenetreEnvois, plafondJour } from "@/lib/demandes-accord";
import type { Adresse, Etat, LigneTableau } from "@/lib/demandes-accord-etats";
import { emailEnabled } from "@/lib/email";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import Tableau from "./tableau";

export const metadata: Metadata = {
  title: "Demandes d'accord — medical-guidelines.net",
};

// Relevé des adresses et envois : jusqu'à 40 s par société.
export const maxDuration = 60;

type Ligne = {
  id: string;
  societe_slug: string;
  sigle: string;
  nom: string | null;
  specialite: string | null;
  type: string | null;
  priorite: number | null;
  nb_fiches: number;
  destinataires: string[];
  adresses: Adresse[];
  piece_jointe_chemin: string | null;
  etat: Etat;
  envoye_le: string | null;
  site: string | null;
};

// Demandes d'accord aux sociétés savantes (administrateurs) : une ligne par
// société de l'atelier ; adresses, courriel personnalisé, pièce jointe,
// envoi et suivi des réponses.
export default async function DemandesAccordPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const admin = createAdminClient();
  const depuis = debutFenetreEnvois();
  const [{ data, error }, { data: modele }, { count: envoisJour }] = await Promise.all([
    admin
      .from("demandes_accord")
      .select("id, societe_slug, sigle, nom, specialite, type, priorite, nb_fiches, destinataires, adresses, piece_jointe_chemin, etat, envoye_le, site")
      .order("priorite", { ascending: true, nullsFirst: false })
      .order("sigle"),
    admin.from("demandes_accord_modele").select("piece_jointe_nom, piece_jointe_chemin").eq("id", 1).maybeSingle(),
    admin.from("demandes_accord_journal").select("id", { count: "exact", head: true }).in("evenement", ["envoi", "relance"]).gte("cree_le", depuis),
  ]);
  if (error) throw new Error(`Demandes d'accord indisponibles : ${error.message}`);
  const defaut = Boolean(modele?.piece_jointe_chemin);
  const lignes: LigneTableau[] = ((data ?? []) as Ligne[]).map((l) => ({
    id: l.id,
    societe_slug: l.societe_slug,
    sigle: l.sigle,
    nom: l.nom,
    specialite: l.specialite,
    type: l.type,
    priorite: l.priorite,
    nb_fiches: l.nb_fiches,
    destinataires: l.destinataires,
    nb_adresses: l.adresses.length,
    piece_jointe: l.piece_jointe_chemin ? "propre" : defaut ? "defaut" : "aucune",
    etat: l.etat,
    envoye_le: l.envoye_le,
    site: l.site,
  }));

  const compte = (f: (l: LigneTableau) => boolean) => lignes.filter(f).length;
  const tuiles: [string, number, string][] = [
    ["Sociétés", lignes.length, "dans l'atelier"],
    ["Avec adresse", compte((l) => l.nb_adresses > 0), "adresse de la société relevée"],
    ["Prêtes", compte((l) => l.etat === "valide"), "validées, à envoyer"],
    ["Envoyées", compte((l) => ["envoye", "relance", "reponse", "accord", "refus"].includes(l.etat)), "dont relancées : " + compte((l) => l.etat === "relance")],
    ["Réponses", compte((l) => ["reponse", "accord", "refus"].includes(l.etat)), ""],
    ["Accords", compte((l) => l.etat === "accord"), "accord écrit obtenu"],
  ];
  const carte = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "12px 14px" };

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Demandes d&apos;accord aux sociétés savantes</h1>
        <div className="doc-header__meta">
          <span>
            Une demande par société : adresses relevées sur son site, courriel personnalisé, pièce jointe, envoi, relance et suivi.
          </span>
        </div>
      </div>

      {!emailEnabled() && (
        <div className="credit-strip" role="status">
          <b>Envoi désactivé : clé RESEND_API_KEY absente sur Vercel.</b> Le reste de l&apos;outil fonctionne.
        </div>
      )}
      {!defaut && (
        <div className="credit-strip" role="status">
          Aucune pièce jointe par défaut : les sociétés sans dossier propre ne peuvent pas être validées.{" "}
          <Link href="/bibliotheque/demandes-accord/modele">Ajouter le dossier SFAR dans le modèle</Link>.
        </div>
      )}
      {lignes.length === 0 && (
        <div className="credit-strip" role="status">
          Aucune société importée : lancer <code>node scripts/demandes-accord/importer.mjs</code> (voir le README).
        </div>
      )}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(140px, 1fr))", gap: 10, margin: "16px 0" }}>
        {tuiles.map(([titre, n, sous]) => (
          <div key={titre} style={carte}>
            <div style={{ fontSize: "0.78rem", color: "var(--ink-muted)", textTransform: "uppercase", letterSpacing: "0.06em" }}>{titre}</div>
            <div style={{ fontSize: "1.7rem", fontWeight: 700, lineHeight: 1.2 }}>{n}</div>
            {sous && <div style={{ fontSize: "0.78rem", color: "var(--ink-muted)" }}>{sous}</div>}
          </div>
        ))}
      </div>

      <p style={{ fontSize: "0.9rem" }}>
        Ordre conseillé : relever les adresses, générer les courriels, relire chaque courriel sur la fiche de la société, valider,
        puis envoyer. <Link href="/bibliotheque/demandes-accord/modele">Modifier le modèle de courriel et la pièce jointe par défaut</Link>.
      </p>

      <Tableau lignes={lignes} plafond={plafondJour()} envoisJour={envoisJour ?? 0} />
    </Shell>
  );
}
