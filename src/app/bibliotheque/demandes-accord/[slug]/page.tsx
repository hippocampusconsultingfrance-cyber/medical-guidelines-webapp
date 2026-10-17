import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import {
  BUCKET,
  dateLongue,
  designationParDefaut,
  formuleParDefaut,
  genererCourriel,
  piedDePage,
  texteVersHtml,
  type Demande,
  type Modele,
} from "@/lib/demandes-accord";
import { ETATS, ETATS_PARTIS } from "@/lib/demandes-accord-etats";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../../data";
import Shell from "../../shell";
import { changerEtat, enregistrerDemande, operationFiche } from "../actions";
import PieceJointe from "../piece-jointe";

export const metadata: Metadata = {
  title: "Demande d'accord — medical-guidelines.net",
};

export const maxDuration = 60;

type Evenement = { id: number; evenement: string; detail: string | null; cree_le: string };

const LIBELLES: Record<string, string> = {
  releve: "Adresses relevées",
  generation: "Courriel généré",
  validation: "Validée",
  envoi: "Envoyée",
  relance: "Relancée",
  erreur: "Erreur",
  modification: "Modifiée",
  piece_jointe: "Pièce jointe",
};

const heure = (v: string) =>
  new Date(v).toLocaleString("fr-FR", { day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit", timeZone: "Europe/Paris" });

// Fiche d'une demande : adresses, réglages, texte du courriel, aperçu,
// pièce jointe, envoi et suivi.
export default async function DemandePage({ params, searchParams }: PageProps<"/bibliotheque/demandes-accord/[slug]">) {
  const { slug } = await params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const admin = createAdminClient();
  const [{ data: ligne }, { data: modeleBrut }] = await Promise.all([
    admin.from("demandes_accord").select("*").eq("societe_slug", slug).maybeSingle(),
    admin.from("demandes_accord_modele").select("*").eq("id", 1).maybeSingle(),
  ]);
  const d = ligne as Demande | null;
  const m = modeleBrut as Modele | null;
  if (!d || !m) notFound();
  const { data: evenements } = await admin
    .from("demandes_accord_journal")
    .select("id, evenement, detail, cree_le")
    .eq("demande_id", d.id)
    .order("cree_le", { ascending: false })
    .limit(50);

  const chemin = d.piece_jointe_chemin ?? m.piece_jointe_chemin;
  const nomPj = d.piece_jointe_chemin ? d.piece_jointe_nom : m.piece_jointe_nom;
  const lienPj = chemin ? (await admin.storage.from(BUCKET).createSignedUrl(chemin, 600)).data?.signedUrl : undefined;

  const sp = await searchParams;
  const message = typeof sp.ok === "string" ? { ok: true, texte: sp.ok } : typeof sp.ko === "string" ? { ok: false, texte: sp.ko } : null;
  const parti = ETATS_PARTIS.includes(d.etat);
  const apercu = d.corps ?? genererCourriel(m, d).corps;
  const objet = d.objet?.trim() || m.objet;
  const carte = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "14px 16px" };
  const petit = { fontSize: "0.82rem", color: "var(--ink-muted)" };

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">
          <Link href="/bibliotheque/demandes-accord">Demandes d&apos;accord</Link> · {d.specialite ?? "Spécialité à préciser"}
        </div>
        <h1>
          {d.sigle} <span className={`chip chip-${ETATS[d.etat].ton}`} style={{ verticalAlign: "middle" }}>{ETATS[d.etat].libelle}</span>
        </h1>
        <div className="doc-header__meta">
          <span>{d.nom}</span>
          {d.site && (
            <span>
              <a href={d.site} target="_blank" rel="noopener noreferrer">
                Site ↗
              </a>
            </span>
          )}
          <span>
            {d.nb_fiches} fiche(s) en ligne{d.nb_porteuse ? `, dont ${d.nb_porteuse} comme premier signataire` : ""}
          </span>
          {d.envoye_le && <span>Envoyée le {dateLongue(d.envoye_le)}</span>}
          {d.relance_le && <span>Relancée le {dateLongue(d.relance_le)}</span>}
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status" style={message.ok ? undefined : { borderColor: "var(--crit, #B42318)" }}>
          <b>{message.texte}</b>
        </div>
      )}
      {d.erreur && d.etat === "erreur" && (
        <div className="credit-strip" role="alert">
          Dernière erreur : {d.erreur}
        </div>
      )}

      <form action={operationFiche} style={{ ...carte, display: "flex", gap: 8, flexWrap: "wrap", alignItems: "center", margin: "14px 0" }}>
        <input type="hidden" name="id" value={d.id} />
        <input type="hidden" name="slug" value={d.societe_slug} />
        <button className="btn btn-ghost btn-sm" name="op" value="relever" disabled={!d.site}>
          Relever les adresses sur le site
        </button>
        <button className="btn btn-ghost btn-sm" name="op" value="generer" disabled={parti}>
          {d.corps ? "Régénérer depuis le modèle" : "Générer le courriel"}
        </button>
        <button className="btn btn-ghost btn-sm" name="op" value="valider" disabled={!["pret", "erreur"].includes(d.etat)}>
          Valider après relecture
        </button>
        <button className="btn btn-primary btn-sm" name="op" value="envoyer" disabled={d.etat !== "valide"}>
          Envoyer maintenant
        </button>
        <button className="btn btn-ghost btn-sm" name="op" value="relancer" disabled={d.etat !== "envoye"}>
          Relancer (après 7 jours)
        </button>
        <span style={petit}>Régénérer remplace le texte du courriel par celui du modèle.</span>
      </form>

      <form action={enregistrerDemande} style={{ display: "grid", gap: 16 }}>
        <input type="hidden" name="id" value={d.id} />
        <input type="hidden" name="slug" value={d.societe_slug} />

        <section style={carte}>
          <h2 className="block-section" style={{ marginTop: 0 }}>
            Destinataires
          </h2>
          {d.adresses.length === 0 ? (
            <p style={petit}>Aucune adresse relevée. {d.site ? "Lancez le relevé ci-dessus" : "Aucun site connu"}, ou ajoutez une adresse.</p>
          ) : (
            <ul style={{ listStyle: "none", padding: 0, margin: 0, display: "grid", gap: 6 }}>
              {d.adresses.map((a) => (
                <li key={a.adresse}>
                  <label style={{ display: "inline-flex", gap: 8, alignItems: "baseline" }}>
                    <input type="checkbox" name="destinataires" value={a.adresse} defaultChecked={d.destinataires.includes(a.adresse)} disabled={parti} />
                    <span>
                      <b>{a.adresse}</b> <span style={petit}>— {a.nature}</span>
                      {a.page && (
                        <>
                          {" "}
                          <a href={a.page} target="_blank" rel="noopener noreferrer" style={petit}>
                            (page source ↗)
                          </a>
                        </>
                      )}
                    </span>
                  </label>
                </li>
              ))}
            </ul>
          )}
          <div className="field" style={{ marginTop: 10 }}>
            <label htmlFor="autres_destinataires">Ajouter une adresse (séparées par des virgules)</label>
            <input id="autres_destinataires" name="autres_destinataires" disabled={parti} placeholder="secretariat@societe.fr" />
            <div className="field__hint">Le premier destinataire coché reçoit le courriel, les autres sont en copie (4 au plus).</div>
          </div>
        </section>

        <section style={carte}>
          <h2 className="block-section" style={{ marginTop: 0 }}>
            Personnalisation
          </h2>
          <div style={{ display: "grid", gap: 10, gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))" }}>
            <div className="field">
              <label htmlFor="formule_appel">Formule d&apos;appel</label>
              <input id="formule_appel" name="formule_appel" defaultValue={d.formule_appel ?? ""} placeholder={formuleParDefaut(d)} disabled={parti} />
            </div>
            <div className="field">
              <label htmlFor="designation">Désignation dans le texte</label>
              <input id="designation" name="designation" defaultValue={d.designation ?? ""} placeholder={designationParDefaut(d.sigle, d.nom)} disabled={parti} />
            </div>
            <div className="field">
              <label htmlFor="objet">Objet</label>
              <input id="objet" name="objet" defaultValue={d.objet ?? ""} placeholder={m.objet} disabled={parti} />
            </div>
            <div className="field">
              <label htmlFor="revues">Revues de la société (droits d&apos;édition)</label>
              <input id="revues" name="revues" defaultValue={d.revues ?? ""} placeholder="notamment …" disabled={parti} />
            </div>
          </div>
          <div className="field">
            <label htmlFor="exemple">Paragraphe d&apos;exemple (vide : celui du modèle, exemple SFAR)</label>
            <textarea id="exemple" name="exemple" rows={4} defaultValue={d.exemple ?? ""} placeholder={m.exemple_defaut} disabled={parti} />
          </div>
          <div className="field">
            <label htmlFor="paragraphe_specifique">Paragraphe propre à la société (facultatif)</label>
            <textarea id="paragraphe_specifique" name="paragraphe_specifique" rows={3} defaultValue={d.paragraphe_specifique ?? ""} disabled={parti} />
          </div>
          <div className="field__hint">Après une modification de ces champs, « Régénérer depuis le modèle » met le courriel à jour.</div>
        </section>

        <section style={carte}>
          <h2 className="block-section" style={{ marginTop: 0 }}>
            Texte du courriel
          </h2>
          <div className="field">
            <label htmlFor="corps">Texte envoyé (paragraphes séparés par une ligne vide ; listes en « - »)</label>
            <textarea id="corps" name="corps" rows={24} defaultValue={d.corps ?? ""} placeholder="Cliquez sur « Générer le courriel »." disabled={parti} style={{ fontFamily: "inherit" }} />
          </div>
          <div className="field">
            <label htmlFor="notes">Notes internes (jamais envoyées)</label>
            <textarea id="notes" name="notes" rows={3} defaultValue={d.notes ?? ""} />
          </div>
          <button className="btn btn-primary">Enregistrer</button>
        </section>
      </form>

      <section style={{ ...carte, marginTop: 16 }}>
        <h2 className="block-section" style={{ marginTop: 0 }}>
          Pièce jointe
        </h2>
        <p style={{ margin: "0 0 8px" }}>
          {chemin ? (
            <>
              {d.piece_jointe_chemin ? "Propre à la société" : "Par défaut (modèle)"} :{" "}
              {lienPj ? (
                <a href={lienPj} target="_blank" rel="noopener noreferrer">
                  {nomPj ?? "fichier"} ↗
                </a>
              ) : (
                nomPj
              )}{" "}
              <span style={petit}>(lien valable 10 min)</span>
            </>
          ) : (
            "Aucune : ajoutez le dossier de comparaison de la société, ou une pièce jointe par défaut dans le modèle."
          )}
        </p>
        {!parti && <PieceJointe cible={d.id} actuelle={d.piece_jointe_chemin ? d.piece_jointe_nom : null} />}
      </section>

      <section style={{ ...carte, marginTop: 16 }}>
        <h2 className="block-section" style={{ marginTop: 0 }}>
          Aperçu
        </h2>
        <div style={petit}>
          À : {d.destinataires[0] ?? "—"}
          {d.destinataires.length > 1 ? ` · Copie : ${d.destinataires.slice(1).join(", ")}` : ""} · Objet : {objet}
          {!d.corps && " · (aperçu du texte que générera le modèle)"}
        </div>
        <div
          style={{ border: "1px solid var(--border)", borderRadius: 8, padding: 16, marginTop: 8, background: "#fff", overflowX: "auto" }}
          dangerouslySetInnerHTML={{ __html: texteVersHtml(apercu, piedDePage(d)) }}
        />
      </section>

      <section style={{ ...carte, marginTop: 16 }}>
        <h2 className="block-section" style={{ marginTop: 0 }}>
          Suivi
        </h2>
        <form action={changerEtat} style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "flex-end" }}>
          <input type="hidden" name="id" value={d.id} />
          <input type="hidden" name="slug" value={d.societe_slug} />
          <div className="field" style={{ flex: "1 1 260px", margin: 0 }}>
            <label htmlFor="note">Note (ex. résumé de la réponse)</label>
            <input id="note" name="note" maxLength={1000} />
          </div>
          <button className="btn btn-ghost btn-sm" name="etat" value="reponse">
            Réponse reçue
          </button>
          <button className="btn btn-ghost btn-sm" name="etat" value="accord">
            Accord obtenu
          </button>
          <button className="btn btn-ghost btn-sm" name="etat" value="refus">
            Refus
          </button>
          <button className="btn btn-ghost btn-sm" name="etat" value="ne_pas_contacter">
            Ne plus contacter
          </button>
          {!parti && (
            <button className="btn btn-ghost btn-sm" name="etat" value="pret">
              Rouvrir (à relire)
            </button>
          )}
        </form>
        <p style={petit}>
          Un accord obtenu se reporte aussi dans l&apos;atelier (societes/{d.societe_slug}/ACCORD.md : statut, date, périmètre, preuve).
        </p>
        <h3 style={{ fontSize: "0.95rem", margin: "14px 0 6px" }}>Journal</h3>
        {(evenements ?? []).length === 0 ? (
          <p style={petit}>Rien pour l&apos;instant.</p>
        ) : (
          <ul style={{ margin: 0, paddingLeft: 18, fontSize: "0.86rem" }}>
            {((evenements ?? []) as Evenement[]).map((e) => (
              <li key={e.id}>
                {heure(e.cree_le)} — <b>{LIBELLES[e.evenement] ?? (e.evenement.startsWith("etat:") ? ETATS[e.evenement.slice(5) as keyof typeof ETATS]?.libelle ?? e.evenement : e.evenement)}</b>
                {e.detail ? ` : ${e.detail}` : ""}
              </li>
            ))}
          </ul>
        )}
      </section>
    </Shell>
  );
}
