import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import {
  accordion,
  chipClass,
  escapeHtml,
  formatDate,
  FREE_QUOTA,
  renderPresentation,
  type Presentation,
  type TocItem,
} from "@/lib/fiches";
import { cardTitle, FRESHNESS_LABEL, loadLibrary } from "../data";
import AccordionControls from "../accordion-controls";
import Shell from "../shell";
import { reportError, setFreshness, setPublication, toggleFavorite, unlockDocument } from "./actions";

export const metadata: Metadata = {
  title: "Fiche — Medical Guidelines",
};

const UUID = /^[0-9a-f-]{36}$/i;

const MESSAGES: Record<string, string> = {
  quota_atteint: `Vous avez utilisé vos ${FREE_QUOTA} crédits. L'abonnement PREMIUM ouvre toutes les fiches de votre spécialité.`,
  indisponible: "Cette fiche n'est pas disponible pour votre compte.",
  erreur: "Le déblocage n'a pas abouti. Réessayez dans un instant.",
  publiee: "Fiche publiée : elle est maintenant visible par les membres de sa spécialité.",
  depubliee: "Fiche dépubliée : elle n'est plus visible par les membres.",
  confirmation_requise: "Cochez la case de relecture avant de publier.",
  publication_erreur: "La publication n'a pas abouti (droits de validateur requis).",
  signalement_envoye: "Merci : votre signalement a été envoyé. Il sera examiné avant toute correction.",
  signalement_vide: "Décrivez l'erreur en quelques mots avant d'envoyer.",
  signalement_erreur: "Le signalement n'a pas pu être envoyé. Réessayez dans un instant.",
  veille_ok: "Statut de la fiche enregistré.",
  veille_version: "Nouvelle version enregistrée, statut de la fiche mis à jour.",
  veille_invalide: "Formulaire incomplet : vérifiez le statut et le type de version.",
  veille_remplacement: "Choisissez la fiche qui remplace celle-ci.",
  veille_retrait: "Cochez la case de confirmation pour retirer la fiche.",
  veille_version_existe: "Cette version est déjà enregistrée pour cette fiche.",
  veille_erreur: "L'enregistrement n'a pas abouti (droits de validateur requis).",
};

const FRESHNESS_OPTIONS: [string, string][] = [
  ["a_jour", "À jour"],
  ["revision_detectee", "Révision détectée : nouvelle version en cours d'analyse"],
  ["remplacee", "Remplacée par une autre fiche"],
  ["retiree", "Retirée : invisible pour les membres"],
];

type Version = {
  id: string;
  version_label: string;
  change_type: string;
  diff_summary: string | null;
  detected_at: string;
  published_at: string | null;
};

const FRESHNESS_NOTICE: Record<string, string> = {
  revision_detectee:
    "Une nouvelle version de la recommandation source a été détectée : cette fiche est en cours de révision par notre équipe.",
  remplacee: "La recommandation source a été remplacée par un texte plus récent.",
};

type Recommendation = {
  id: string;
  recommendation_code: string;
  statement: string;
  grade: string | null;
  evidence_level: string | null;
  source_section: string | null;
  source_page: number | null;
  status: string;
};

export default async function FichePage({
  params,
  searchParams,
}: PageProps<"/bibliotheque/[id]">) {
  const { id } = await params;
  if (!UUID.test(id)) notFound();

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const lib = await loadLibrary(supabase, user.id);
  const doc = lib.docs.find((d) => d.id === id);
  if (!doc) notFound();

  const { data: extra } = await supabase
    .from("documents")
    .select("revision_date, source_url, grading_system, superseded_by_document_id")
    .eq("id", id)
    .single();
  const { data: canRead } = await supabase.rpc("can_read_document", { doc_id: id });
  const { data: versions } = lib.canPublish
    ? await supabase
        .from("document_versions")
        .select("id, version_label, change_type, diff_summary, detected_at, published_at")
        .eq("document_id", id)
        .order("detected_at", { ascending: false })
    : { data: null };
  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;

  const card = doc.card_json;
  const date = formatDate(doc.publication_date);
  const isFavorite = lib.favorite.has(id);
  const replacement = extra?.superseded_by_document_id
    ? lib.docs.find((d) => d.id === extra.superseded_by_document_id)
    : undefined;
  const freshness = doc.freshness_status ? FRESHNESS_NOTICE[doc.freshness_status] : undefined;
  const header = (
    <div className="doc-header">
      <div className="doc-header__eyebrow">
        {card?.society ?? [doc.doc_type, date].filter(Boolean).join(" — ")}
      </div>
      <h1>{cardTitle(doc)}</h1>
      {card?.title && card.title !== doc.title && (
        <p className="block-p" style={{ color: "var(--ink-muted)", marginTop: 0 }}>
          {doc.title}
        </p>
      )}
      <div className="doc-header__meta">
        {(card?.methodology || extra?.grading_system) && (
          <span>
            <b>Méthodologie</b>&nbsp;{card?.methodology ?? extra?.grading_system}
          </span>
        )}
        <span>
          <b>Version</b>&nbsp;{card?.version ?? date ?? "non indiquée"}
        </span>
        {card?.validated && (
          <span>
            <b>Validation</b>&nbsp;{card.validated}
          </span>
        )}
        {extra?.revision_date && (
          <span>
            <b>Révision</b>&nbsp;{formatDate(extra.revision_date)}
          </span>
        )}
        {doc.societies.length > 0 && (
          <span>
            <b>Société{doc.societies.length > 1 ? "s" : ""}</b>&nbsp;
            {doc.societies
              .map((s) => (lib.societyNames[s] ? `${s} (${lib.societyNames[s]})` : s))
              .join(" · ")}
          </span>
        )}
      </div>
      <div className="doc-header__actions">
        {extra?.source_url && (
          <a className="source-link" href={extra.source_url} target="_blank" rel="noopener noreferrer">
            Document source officiel ↗
          </a>
        )}
        <form action={toggleFavorite}>
          <input type="hidden" name="id" value={id} />
          <input type="hidden" name="favori" value={isFavorite ? "0" : "1"} />
          <button className={`btn btn-ghost btn-sm fav-btn${isFavorite ? " is-on" : ""}`} aria-pressed={isFavorite}>
            {isFavorite ? "★ Dans mes favoris" : "☆ Ajouter aux favoris"}
          </button>
        </form>
      </div>
      {freshness && (
        <div className="panel warn" role="note">
          <b>{FRESHNESS_LABEL[doc.freshness_status!]}.</b> {freshness}
          {replacement && (
            <>
              {" "}
              <Link href={`/bibliotheque/${replacement.id}`}>Voir la nouvelle fiche : {cardTitle(replacement)} →</Link>
            </>
          )}
        </div>
      )}
    </div>
  );

  if (!canRead) {
    const remaining = Math.max(FREE_QUOTA - lib.unlocked.size, 0);
    return (
      <Shell lib={lib} activeId={id}>
        {header}
        {card?.short && <p className="block-p">{card.short}</p>}
        <div className="unlock-box">
          <h2>🔒 Fiche bloquée</h2>
          {message && <p style={{ color: "var(--ink)", fontWeight: 600 }}>{message}</p>}
          {remaining > 0 ? (
            <>
              <p>
                Débloquer cette fiche utilise <b>1 crédit</b>. Il vous en reste{" "}
                <b>{remaining}</b> sur {FREE_QUOTA}. Une fiche débloquée le reste
                définitivement.
              </p>
              <form action={unlockDocument}>
                <input type="hidden" name="id" value={id} />
                <button className="btn btn-primary">Utiliser 1 crédit pour débloquer</button>
              </form>
            </>
          ) : (
            <>
              {!message && <p>{MESSAGES.quota_atteint}</p>}
              <a href="/abonnement" className="btn btn-primary" style={{ display: "inline-block", textDecoration: "none" }}>
                Passer à PREMIUM
              </a>
            </>
          )}
        </div>
      </Shell>
    );
  }

  await supabase.from("consultation_history").insert({ user_id: user.id, document_id: id });

  const { data: presentation } = await supabase.rpc("get_document_presentation", { doc_id: id });
  let body: string;
  let toc: TocItem[];
  if (presentation) {
    ({ html: body, toc } = renderPresentation(presentation as Presentation));
  } else {
    const { data: recs } = await supabase
      .from("recommendations")
      .select("id, recommendation_code, statement, grade, evidence_level, source_section, source_page, status")
      .eq("document_id", id)
      .order("recommendation_code");
    ({ html: body, toc } = renderRecommendations((recs ?? []) as Recommendation[]));
  }

  const watermark = `${user.email} · ${new Date().toLocaleString("fr-FR", { timeZone: "Europe/Paris" })}`;

  return (
    <Shell lib={lib} activeId={id} toc={toc}>
      <div className="fiche-premium">
        <div className="watermark" aria-hidden="true">
          {Array.from({ length: 80 }, (_, i) => (
            <span key={i}>{watermark}</span>
          ))}
        </div>
        {header}
        {lib.isEditor && (
          <div className="unlock-box" style={{ marginTop: 18, marginBottom: 10 }}>
            {message && !String(r).startsWith("signalement") && !String(r).startsWith("veille") && (
              <p style={{ color: "var(--ink)", fontWeight: 600 }}>{message}</p>
            )}
            {lib.published.has(id) ? (
              <>
                <p>
                  <span className="state-pill state-open">Publiée</span> Visible par
                  les membres de la spécialité (5 crédits gratuits ou PREMIUM).
                </p>
                {lib.canPublish && (
                  <form action={setPublication}>
                    <input type="hidden" name="id" value={id} />
                    <input type="hidden" name="publier" value="0" />
                    <button className="btn btn-ghost">Dépublier cette fiche</button>
                  </form>
                )}
              </>
            ) : (
              <>
                <p>
                  <span className="state-pill state-draft">Brouillon</span> Invisible
                  pour les membres tant qu&apos;elle n&apos;est pas publiée.
                </p>
                {lib.canPublish && (
                  <form action={setPublication}>
                    <input type="hidden" name="id" value={id} />
                    <input type="hidden" name="publier" value="1" />
                    <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 12px" }}>
                      <input type="checkbox" name="confirme" value="1" required style={{ marginTop: 3 }} />
                      <span>
                        J&apos;ai relu cette fiche : source officielle, date, grades et
                        contenu vérifiés.
                      </span>
                    </label>
                    <button className="btn btn-primary">Publier cette fiche</button>
                  </form>
                )}
              </>
            )}
            {lib.canPublish && (
              <details id="veille" open={typeof r === "string" && r.startsWith("veille")} style={{ marginTop: 16 }}>
                <summary style={{ cursor: "pointer", fontWeight: 700 }}>
                  Veille : nouvelle version ou changement de statut
                </summary>
                {typeof r === "string" && r.startsWith("veille") && message && (
                  <p style={{ color: "var(--ink)", fontWeight: 600, marginTop: 12 }}>{message}</p>
                )}
                <form action={setFreshness} style={{ marginTop: 12 }}>
                  <input type="hidden" name="id" value={id} />
                  <div className="field">
                    <label htmlFor="vf-statut">Statut de la fiche</label>
                    <select id="vf-statut" name="statut" defaultValue={doc.freshness_status ?? "a_jour"}>
                      {FRESHNESS_OPTIONS.map(([v, l]) => (
                        <option key={v} value={v}>
                          {l}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="field">
                    <label htmlFor="vf-remplacee">Remplacée par (si « Remplacée »)</label>
                    <select id="vf-remplacee" name="remplacee_par" defaultValue={extra?.superseded_by_document_id ?? ""}>
                      <option value="">—</option>
                      {lib.docs
                        .filter((d) => d.id !== id)
                        .map((d) => (
                          <option key={d.id} value={d.id}>
                            {cardTitle(d)}
                            {d.publication_date ? ` (${d.publication_date.slice(0, 4)})` : ""}
                          </option>
                        ))}
                    </select>
                  </div>
                  <fieldset style={{ border: "1px solid var(--border)", borderRadius: 8, padding: "10px 14px", margin: "8px 0 12px" }}>
                    <legend style={{ fontSize: "0.86rem", fontWeight: 700 }}>Nouvelle version de la source (facultatif)</legend>
                    <div className="field">
                      <label htmlFor="vf-version">Version (ex. « RFE 2026 », « mise à jour mars 2026 »)</label>
                      <input id="vf-version" name="version" maxLength={100} />
                    </div>
                    <div className="field">
                      <label htmlFor="vf-type">Type de changement</label>
                      <select id="vf-type" name="type" defaultValue="majeure">
                        <option value="majeure">Majeure (recommandations modifiées)</option>
                        <option value="mineure">Mineure (forme, précisions)</option>
                      </select>
                    </div>
                    <div className="field">
                      <label htmlFor="vf-resume">Ce qui change (affiché aux membres)</label>
                      <textarea id="vf-resume" name="resume" maxLength={2000} />
                    </div>
                    <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem" }}>
                      <input type="checkbox" name="publier_version" value="1" style={{ marginTop: 3 }} />
                      <span>
                        Publier cette version : les membres qui suivent la fiche
                        (débloquée, favorite ou consultée) sont prévenus.
                      </span>
                    </label>
                  </fieldset>
                  <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 12px" }}>
                    <input type="checkbox" name="confirme_retrait" value="1" style={{ marginTop: 3 }} />
                    <span>Si « Retirée » : je confirme que la fiche doit disparaître pour les membres.</span>
                  </label>
                  <button className="btn btn-primary">Enregistrer</button>
                </form>
                {versions && versions.length > 0 && (
                  <div style={{ marginTop: 16, fontSize: "0.86rem" }}>
                    <b>Versions enregistrées</b>
                    <ul style={{ margin: "6px 0 0", paddingLeft: 18 }}>
                      {(versions as Version[]).map((v) => (
                        <li key={v.id}>
                          {v.version_label} — {v.change_type}
                          {v.published_at
                            ? `, publiée le ${new Date(v.published_at).toLocaleDateString("fr-FR", { timeZone: "Europe/Paris" })}`
                            : ", non publiée"}
                          {v.diff_summary ? ` : ${v.diff_summary}` : ""}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </details>
            )}
          </div>
        )}
        {toc.length > 1 && <AccordionControls />}
        <div dangerouslySetInnerHTML={{ __html: body }} />
        <details
          className="unlock-box"
          id="signaler"
          open={r === "signalement_vide" || r === "signalement_erreur"}
          style={{ userSelect: "text", WebkitUserSelect: "text" }}
        >
          <summary style={{ cursor: "pointer", fontWeight: 700 }}>⚠ Signaler une erreur dans cette fiche</summary>
          {typeof r === "string" && r.startsWith("signalement") && message && (
            <p style={{ color: "var(--ink)", fontWeight: 600, marginTop: 12 }}>{message}</p>
          )}
          <form action={reportError} style={{ marginTop: 12 }}>
            <input type="hidden" name="id" value={id} />
            <input type="hidden" name="title" value={cardTitle(doc)} />
            <div className="field">
              <label htmlFor="rf-section">Section ou tableau concerné (facultatif)</label>
              <input id="rf-section" name="section" maxLength={300} />
            </div>
            <div className="field">
              <label htmlFor="rf-description">Description de l&apos;erreur</label>
              <textarea id="rf-description" name="description" required minLength={5} maxLength={4000} />
            </div>
            <button className="btn btn-primary">Envoyer le signalement</button>
          </form>
        </details>
        <p className="block-p is-note" style={{ marginTop: 40 }}>
          Synthèse indépendante : elle ne remplace pas le texte intégral de la
          recommandation officielle.{" "}
          <Link href="/bibliotheque">← Toutes les fiches</Link>
        </p>
      </div>
    </Shell>
  );
}

// Fiches sans mise en page détaillée : recommandations groupées par section
// de la source, dans le même style que les fiches détaillées. Le texte vient
// de la base et est échappé.
function renderRecommendations(recs: Recommendation[]) {
  const toc: TocItem[] = [];
  const groups: { title: string; html: string }[] = [];
  for (const rec of recs) {
    const section = rec.source_section ?? "Recommandations";
    if (groups[groups.length - 1]?.title !== section) groups.push({ title: section, html: "" });
    const meta = [
      rec.grade && `<span class="chip ${chipClass(rec.grade)}">${escapeHtml(rec.grade)}</span>`,
      rec.evidence_level && `Niveau de preuve : ${escapeHtml(rec.evidence_level)}`,
      rec.source_page && `p. ${rec.source_page}`,
      escapeHtml(rec.recommendation_code),
      rec.status !== "active" && `<span class="state-pill state-draft">${escapeHtml(rec.status)}</span>`,
    ].filter(Boolean);
    groups[groups.length - 1].html += `<div class="panel"><p>${escapeHtml(rec.statement)}</p><div class="rec-meta">${meta.join(" ")}</div></div>`;
  }
  const html = groups
    .map((g, i) => {
      const id = `section-${i}`;
      toc.push({ id, text: g.title });
      return accordion(escapeHtml(g.title), id, g.html, i === 0);
    })
    .join("");
  return { html, toc };
}
