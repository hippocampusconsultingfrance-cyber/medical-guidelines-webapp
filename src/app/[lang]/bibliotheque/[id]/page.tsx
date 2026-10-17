import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { CATALOGUE_OUVERT_QUOTA } from "@/lib/catalogue";
import { chargerCorrections, CRITICITES, dateCorrection } from "@/lib/corrections";
import { signalerSuspensions } from "@/lib/extraction";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import {
  accordion,
  avertissementAnciennete,
  verificationSource,
  chipClass,
  escapeHtml,
  formatDate,
  FREE_QUOTA,
  methodologieLisible,
  renderPresentation,
  type Presentation,
  type TocItem,
} from "@/lib/fiches";
import { cardTitle, FRESHNESS_LABEL, loadLibrary } from "../data";
import AccordionControls from "../accordion-controls";
import { publierCorrection } from "../signalements/actions";
import Shell from "../shell";
import { marquerRelue, reportError, setFreshness, setPublication, toggleFavorite, unlockDocument } from "./actions";

export const metadata: Metadata = {
  title: "Fiche — Medical Guidelines",
};

const UUID = /^[0-9a-f-]{36}$/i;

const MESSAGES: Record<string, string> = {
  quota_atteint: `Vous avez utilisé vos ${FREE_QUOTA} crédits. L'abonnement PREMIUM ouvre toutes les fiches de votre spécialité.`,
  indisponible: "Cette fiche n'est pas disponible pour votre compte.",
  erreur: "Le déblocage n'a pas abouti. Réessayez dans un instant.",
  suspendu: "Consultation suspendue temporairement : aucun crédit n'a été utilisé.",
  publiee: "Fiche publiée : elle est maintenant visible par les membres de sa spécialité.",
  depubliee: "Fiche dépubliée : elle n'est plus visible par les membres.",
  confirmation_requise: "Cochez la case de relecture avant de valider.",
  relue: "Relecture enregistrée : la mention « Relue par … » est à jour sur la fiche.",
  relue_nom: "Renseignez votre prénom et votre nom dans Mon compte : ils figurent dans la mention de relecture.",
  relue_erreur: "La relecture n'a pas pu être enregistrée.",
  publication_erreur: "La publication n'a pas abouti (droits de validateur requis).",
  publication_juridique:
    "Publication refusée : le statut juridique de la source n'est pas « Validé » (Registre juridique, depuis le tableau de bord).",
  publication_date: "Publication refusée : la date de publication de la source manque.",
  publication_source: "Publication refusée : l'URL de la source officielle manque.",
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
  correction_publiee: "Correction publiée au journal public.",
  correction_incomplete: "Choisissez la criticité et résumez la correction (5 caractères au moins).",
  correction_erreur: "La correction n'a pas pu être publiée.",
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

type Divergence = {
  id: string;
  question: string;
  avertissement: string | null;
  positions: {
    document_id: string;
    titre: string;
    societes: string | null;
    date: string | null;
    position: string;
    population: string | null;
    grade: string | null;
    niveau: string | null;
  }[];
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

// Points clés validés (colonne lue avec la clé serveur). Une lecture
// impossible (clé absente, migration manquante) ne doit jamais empêcher
// d'afficher la fiche : l'encadré est alors simplement omis.
async function lirePointsCles(id: string): Promise<{ data: { points_cles: unknown } | null }> {
  try {
    return await createAdminClient().from("documents").select("points_cles").eq("id", id).maybeSingle();
  } catch {
    return { data: null };
  }
}

export default async function FichePage({
  params,
  searchParams,
}: PageProps<"/[lang]/bibliotheque/[id]">) {
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

  // Lectures indépendantes, envoyées ensemble.
  const [{ data: extra }, { data: verif }, { data: relecture }, { data: canRead, error: errLecture }, { data: blocked }, { data: versions }] =
    await Promise.all([
      supabase
        .from("documents")
        .select("revision_date, source_url, grading_system, superseded_by_document_id")
        .eq("id", id)
        .single(),
      // Requête séparée : sans la migration 20260930130000, la colonne manque.
      supabase.from("documents").select("source_verified_at").eq("id", id).maybeSingle(),
      // Requête séparée : sans la migration 20261001170000, les colonnes manquent.
      supabase.from("documents").select("relue_par_nom, relue_le").eq("id", id).maybeSingle(),
      supabase.rpc("can_read_document", { doc_id: id }),
      supabase.rpc("is_access_blocked"),
      lib.canPublish
        ? supabase
            .from("document_versions")
            .select("id, version_label, change_type, diff_summary, detected_at, published_at")
            .eq("document_id", id)
            .order("detected_at", { ascending: false })
        : Promise.resolve({ data: null }),
    ]);
  // Droit de lecture illisible (panne) : page d'erreur, pas une fiche
  // affichée à tort comme bloquée.
  if (errLecture) throw new Error(`Droit de lecture indisponible : ${errLecture.message}`);
  const verification = verificationSource(
    (verif?.source_verified_at as string | null | undefined) ?? null,
    doc.published_at,
  );
  const r = (await searchParams).r;
  const message =
    r === "quota_atteint" && lib.catalogueOuvert ? CATALOGUE_OUVERT_QUOTA : typeof r === "string" ? MESSAGES[r] : undefined;

  const card = doc.card_json;
  const date = formatDate(doc.publication_date);
  const isFavorite = lib.favorite.has(id);
  const replacement = extra?.superseded_by_document_id
    ? lib.docs.find((d) => d.id === extra.superseded_by_document_id)
    : undefined;
  const freshness = doc.freshness_status ? FRESHNESS_NOTICE[doc.freshness_status] : undefined;
  const anciennete = doc.freshness_status === "remplacee" ? null : avertissementAnciennete(doc.publication_date);
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
            <b>Méthodologie</b>&nbsp;{card?.methodology ? methodologieLisible(card.methodology) : extra?.grading_system}
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
        {relecture?.relue_par_nom && relecture.relue_le && (
          <span>
            <b>Relue par</b>&nbsp;{relecture.relue_par_nom as string}, le {formatDate(relecture.relue_le as string)}
          </span>
        )}
        {verification && (
          <span>
            <b>Source vérifiée le</b>&nbsp;{verification.derniere} · prochaine vérification prévue le{" "}
            {verification.prochaine}
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
      {anciennete && (
        <div className="panel warn" role="note">
          <b>Source ancienne.</b> {anciennete}
        </div>
      )}
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

  // Lecture suspendue (trop de fiches ouvertes trop vite) : message neutre,
  // sans proposer de débloquer la fiche.
  const suspension = (
    <Shell lib={lib} activeId={id}>
      {header}
      <div className="unlock-box">
        <h2>Consultation momentanément suspendue</h2>
        <p>
          Un nombre inhabituel de fiches a été ouvert depuis votre compte en peu de temps. Pour protéger le
          contenu, la lecture est suspendue pendant quelques heures ; elle reprendra automatiquement.
        </p>
        <p>
          S&apos;il s&apos;agit d&apos;un usage normal, écrivez-nous à contact@medical-guidelines.net : nous
          rétablirons l&apos;accès.
        </p>
      </div>
    </Shell>
  );
  if (blocked && !lib.isEditor) {
    await signalerSuspensions();
    return suspension;
  }

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
              {!message && <p>{lib.catalogueOuvert ? CATALOGUE_OUVERT_QUOTA : MESSAGES.quota_atteint}</p>}
              {!lib.catalogueOuvert && (
                <a href="/abonnement" className="btn btn-primary" style={{ display: "inline-block", textDecoration: "none" }}>
                  Passer à PREMIUM
                </a>
              )}
            </>
          )}
        </div>
      </Shell>
    );
  }

  // Chaque lecture est journalisée et limitée par la base (anti-extraction) :
  // un rythme anormal suspend la lecture, dès cette fiche.
  const { data: presentation, error: errPresentation } = await supabase.rpc("get_document_presentation", { doc_id: id });
  if (errPresentation) throw new Error(`Contenu de la fiche indisponible : ${errPresentation.message}`);
  let body: string;
  let toc: TocItem[];
  if (presentation) {
    ({ html: body, toc } = renderPresentation(presentation as Presentation));
  } else {
    const { data: recs, error } = await supabase.rpc("get_document_recommendations", { doc_id: id });
    if (recs === null && !error) {
      await signalerSuspensions();
      return suspension;
    }
    ({ html: body, toc } = renderRecommendations((recs ?? []) as Recommendation[]));
  }
  // Points clés validés par un médecin (colonne lue par le serveur seulement,
  // ici sur une fiche que le membre a le droit de lire). Sans la migration
  // 20261001180000, la colonne manque : rien n'est affiché.
  const [, corrections, { data: divData }, { data: cles }] = await Promise.all([
    supabase.from("consultation_history").insert({ user_id: user.id, document_id: id }),
    chargerCorrections(supabase, id, 50),
    supabase.rpc("get_divergences", { doc_id: id }),
    lirePointsCles(id),
  ]);
  const divergences = (Array.isArray(divData) ? divData : []) as Divergence[];
  const pointsCles = Array.isArray(cles?.points_cles) ? (cles.points_cles as string[]) : [];

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
        {pointsCles.length > 0 && (
          <section className="panel" aria-label="Points clés" style={{ marginTop: 18 }}>
            <p style={{ fontWeight: 700 }}>Points clés</p>
            <ul style={{ margin: 0, paddingLeft: 20 }}>
              {pointsCles.map((p, i) => (
                <li key={i} style={{ marginBottom: 4 }}>
                  {p}
                </li>
              ))}
            </ul>
          </section>
        )}
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
                  <form action={marquerRelue} style={{ marginBottom: 12 }}>
                    <input type="hidden" name="id" value={id} />
                    <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 8px" }}>
                      <input type="checkbox" name="confirme" value="1" required style={{ marginTop: 3 }} />
                      <span>
                        J&apos;ai relu cette fiche aujourd&apos;hui : source officielle, date, grades et contenu vérifiés.
                      </span>
                    </label>
                    <button className="btn btn-ghost btn-sm">Signer la relecture</button>
                  </form>
                )}
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
        {divergences.map((d) => (
          <section key={d.id} className="panel warn" style={{ userSelect: "text", WebkitUserSelect: "text" }}>
            <h2 style={{ fontSize: "1rem", margin: "0 0 4px" }}>Recommandations divergentes : {d.question}</h2>
            <p style={{ fontSize: "0.85rem", margin: "0 0 10px" }}>
              Les sociétés savantes ne formulent pas la même recommandation. Leurs positions sont présentées
              séparément, sans que l&apos;une soit présentée comme meilleure.
              {d.avertissement ? ` ${d.avertissement}` : ""}
            </p>
            <div style={{ display: "grid", gap: 10, gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))" }}>
              {d.positions.map((p) => (
                <div
                  key={p.document_id}
                  style={{ background: "var(--surface)", border: "1px solid var(--border)", borderRadius: 8, padding: "10px 12px" }}
                >
                  <div style={{ fontWeight: 700, fontSize: "0.9rem" }}>
                    {p.societes ?? "Société"}
                    {p.date ? ` · ${p.date.slice(0, 4)}` : ""}
                  </div>
                  <p style={{ fontSize: "0.9rem", margin: "6px 0" }}>{p.position}</p>
                  <div style={{ fontSize: "0.8rem", color: "var(--ink-muted)" }}>
                    Population : {p.population || "non indiquée"} · Grade : {p.grade || "non indiqué"} · Niveau de
                    preuve : {p.niveau || "non indiqué"}
                  </div>
                  {p.document_id !== id && (
                    <Link href={`/bibliotheque/${p.document_id}`} style={{ fontSize: "0.8rem" }}>
                      Voir la fiche : {p.titre} →
                    </Link>
                  )}
                </div>
              ))}
            </div>
          </section>
        ))}
        {toc.length > 1 && <AccordionControls />}
        <div dangerouslySetInnerHTML={{ __html: body }} />
        <p className="block-p" style={{ fontSize: "0.82rem", color: "var(--ink-muted)", marginTop: 18 }}>
          Recommandations citées d&apos;après{" "}
          {doc.societies.length ? doc.societies.map((s) => lib.societyNames[s] ?? s).join(", ") : "leurs auteurs"}, «&nbsp;
          {doc.title}&nbsp;»{doc.publication_date ? ` (${doc.publication_date.slice(0, 4)})` : ""}. Elles restent
          l&apos;œuvre et la propriété de leurs auteurs
          {extra?.source_url ? (
            <>
              {" "}; texte intégral en accès libre :{" "}
              <a href={extra.source_url} target="_blank" rel="noopener noreferrer">
                document source officiel
              </a>
            </>
          ) : null}
          . Synthèse indépendante, ni éditée ni validée par les sociétés savantes citées.
        </p>
        <section className="unlock-box" id="corrections" style={{ userSelect: "text", WebkitUserSelect: "text" }}>
          <h2 style={{ fontSize: "1rem", margin: 0 }}>Journal des corrections de cette fiche</h2>
          {typeof r === "string" && r.startsWith("correction") && message && (
            <p style={{ color: "var(--ink)", fontWeight: 600, marginTop: 10 }}>{message}</p>
          )}
          {corrections.length ? (
            <ul style={{ margin: "10px 0 0", paddingLeft: 18, fontSize: "0.9rem" }}>
              {corrections.map((c) => (
                <li key={c.id}>
                  {dateCorrection(c.corrected_at)} — <b>{CRITICITES[c.criticite] ?? c.criticite}</b> : {c.resume}
                </li>
              ))}
            </ul>
          ) : (
            <p style={{ fontSize: "0.9rem", margin: "8px 0 0" }}>Aucune correction publiée pour cette fiche.</p>
          )}
          <p style={{ fontSize: "0.82rem", margin: "8px 0 0" }}>
            <Link href="/corrections">Journal de toutes les corrections →</Link>
          </p>
          {lib.isAdmin && (
            <details style={{ marginTop: 12 }}>
              <summary style={{ cursor: "pointer", fontWeight: 600 }}>Publier une correction</summary>
              <form action={publierCorrection} style={{ marginTop: 10 }}>
                <input type="hidden" name="document_id" value={id} />
                <input type="hidden" name="retour" value="fiche" />
                <div className="field">
                  <label htmlFor="cr-crit">Criticité</label>
                  <select id="cr-crit" name="criticite" required defaultValue="">
                    <option value="" disabled>
                      Choisir…
                    </option>
                    {Object.entries(CRITICITES).map(([v, l]) => (
                      <option key={v} value={v}>
                        {l}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="field">
                  <label htmlFor="cr-resume">Résumé public de la correction</label>
                  <textarea id="cr-resume" name="resume" required minLength={5} maxLength={1000} />
                </div>
                <button className="btn btn-primary btn-sm">Publier la correction</button>
              </form>
            </details>
          )}
        </section>
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
          <b>Référence de la source :</b>{" "}
          {[doc.societies.join(" / ") || card?.society, `« ${doc.title} »`, card?.version ?? date]
            .filter(Boolean)
            .join(", ")}
          .{" "}
          {extra?.source_url && (
            <>
              Texte intégral en accès libre :{" "}
              <a href={extra.source_url} target="_blank" rel="noopener noreferrer">
                document officiel ↗
              </a>
              .{" "}
            </>
          )}
          Les recommandations citées restent l&apos;œuvre et la propriété de leurs auteurs ; cette fiche est une
          synthèse indépendante qui ne remplace pas le texte intégral. Correction ou retrait :{" "}
          <a href="mailto:contact@medical-guidelines.net">contact@medical-guidelines.net</a>.{" "}
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
      rec.grade?.trim()
        ? `<span class="chip ${chipClass(rec.grade)}">${escapeHtml(rec.grade)}</span>`
        : `<span class="chip chip-neutral">Grade non indiqué</span>`,
      `Niveau de preuve : ${rec.evidence_level?.trim() ? escapeHtml(rec.evidence_level) : "non indiqué"}`,
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
