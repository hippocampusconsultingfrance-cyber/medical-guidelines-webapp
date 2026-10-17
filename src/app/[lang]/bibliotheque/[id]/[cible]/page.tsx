import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { chipClass, escapeHtml, renderPresentation, type Card, type Presentation } from "@/lib/fiches";
import { direction } from "@/lib/langues";
import { createClient } from "@/lib/supabase/server";
import AccordionControls from "../../accordion-controls";
import { cardTitle, loadLibrary } from "../../data";
import Shell from "../../shell";
import { publishTranslation, reviewTranslation } from "./actions";
import { LANGUES_TRADUCTION, NOMS_TRADUCTION, type LangueTraduction } from "./langues";

export const metadata: Metadata = {
  title: "Relecture de la traduction — medical-guidelines.net",
};

const UUID = /^[0-9a-f-]{36}$/i;

const MESSAGES: Record<string, string> = {
  relue: "Traduction marquée relue.",
  brouillon: "Traduction repassée en brouillon.",
  confirmation: "Cochez la case de relecture avant de marquer la traduction relue.",
  erreur: "L'enregistrement n'a pas abouti (droits de relecteur requis).",
  publiee: "Traduction publiée : visible des membres dans cette langue, avec sa mention.",
  retiree: "Publication retirée : la fiche est de nouveau servie en français dans cette langue.",
  pub_confirmation: "Cochez la case de confirmation avant de publier.",
  pub_registre: "Publication refusée : le registre juridique n'autorise pas la traduction de cette source (translation_allowed = oui et revue juridique « valide » requis).",
  pub_fr_change: "Publication refusée : la fiche française a changé depuis la traduction.",
  pub_a_verifier: "Publication refusée : des points restent à vérifier.",
  pub_fr_non_relue: "Publication refusée : la fiche française n'est pas publiée ou pas relue par un médecin.",
  pub_non_relue: "Publication refusée : traduction non relue.",
  pub_droits: "Publication réservée aux validateurs.",
  pub_erreur: "La publication n'a pas abouti.",
};

type KeyPoint = { ref?: string; grade?: string; fr?: string } & Record<string, string | undefined>;
type Translation = {
  status: string;
  publiee_sans_relecture?: boolean;
  publiee_le?: string | null;
  card_json: Card | null;
  presentation_json: (Presentation & { chip_legend?: Record<string, string> | null }) | null;
  key_points: KeyPoint[] | null;
  a_verifier: string[] | null;
  source_publication_date: string | null;
  fr_a_jour: boolean;
  review_notes: string | null;
  reviewed_at: string | null;
  imported_at: string;
};

// Relecture de la traduction d'une fiche dans une langue (équipe éditoriale) :
// points à vérifier, points clés français/traduits, fiche traduite complète,
// décision du relecteur. Jamais visible des membres.
export default async function TraductionPage({ params, searchParams }: PageProps<"/[lang]/bibliotheque/[id]/[cible]">) {
  const { id, cible: brut } = await params;
  if (!UUID.test(id) || !(LANGUES_TRADUCTION as readonly string[]).includes(brut)) notFound();
  const cible = brut as LangueTraduction;
  const nom = NOMS_TRADUCTION[cible];
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.isEditor) redirect(`/bibliotheque/${id}`);
  const doc = lib.docs.find((d) => d.id === id);
  if (!doc) notFound();

  const { data } = await supabase
    .from("document_translations")
    // Toutes les colonnes : celles de la publication (migration
    // 20261018110000) manquent tant qu'elle n'est pas appliquée.
    .select("*")
    .eq("document_id", id)
    .eq("lang", cible)
    .maybeSingle();
  const t = data as Translation | null;
  if (!t) notFound();

  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;
  const { html, toc } = t.presentation_json ? renderPresentation(t.presentation_json) : { html: "", toc: [] };
  const legend = t.presentation_json?.chip_legend ?? null;
  const date = (v: string | null) =>
    v ? new Date(v).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric", timeZone: "Europe/Paris" }) : null;

  return (
    <Shell lib={lib} activeId={id} toc={toc}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">
          Traduction {nom.adjectif} ·{" "}
          {t.status === "publiee"
            ? t.publiee_sans_relecture
              ? "publiée (IA, non relue)"
              : "publiée (relue)"
            : `${t.status === "relue" ? "relue" : "brouillon"} · non publiée`}
        </div>
        <h1 lang={cible} dir={direction(cible)}>
          {t.card_json?.title ?? cardTitle(doc)}
        </h1>
        <p className="block-p" style={{ color: "var(--ink-muted)", marginTop: 0 }}>
          Fiche française : <Link href={`/bibliotheque/${id}`}>{cardTitle(doc)}</Link>
          {" · "}importée le {date(t.imported_at)}
          {t.source_publication_date ? ` · source du ${date(t.source_publication_date)}` : ""}
        </p>
        {t.card_json?.short && (
          <p className="block-p" lang={cible} dir={direction(cible)}>
            {t.card_json.short}
          </p>
        )}
        {!t.fr_a_jour && (
          <div className="panel warn" role="note">
            <b>Fiche française modifiée depuis la traduction.</b> Cette version {nom.adjectif} part
            d&apos;un contenu français antérieur : à retraduire ou à comparer avant relecture.
          </div>
        )}
      </div>

      {t.a_verifier && t.a_verifier.length > 0 && (
        <div className="panel warn" style={{ marginTop: 16 }}>
          <b>Points à vérifier ({t.a_verifier.length})</b>
          <ul style={{ margin: "8px 0 0", paddingLeft: 18 }}>
            {t.a_verifier.map((a, i) => (
              <li key={i} style={{ marginBottom: 6 }}>
                {a}
              </li>
            ))}
          </ul>
        </div>
      )}

      {t.key_points && t.key_points.length > 0 && (
        <>
          <h2 className="block-section">Points clés — français / {nom.adjectif}</h2>
          <div className="table-scroll">
            <table className="rfe">
              <thead>
                <tr>
                  <th>Réf.</th>
                  <th>Grade</th>
                  <th>Français</th>
                  <th>{nom.autonyme}</th>
                </tr>
              </thead>
              <tbody>
                {t.key_points.map((k, i) => (
                  <tr key={i}>
                    <td>{k[`ref_${cible}`] ?? k.ref}</td>
                    <td className="num">
                      {k.grade && <span className={`chip ${chipClass(k.grade)}`}>{k.grade}</span>}
                    </td>
                    <td>{k.fr}</td>
                    <td lang={cible} dir={direction(cible)}>
                      {k[cible]}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}

      {legend && (
        <p className="block-p is-note" style={{ marginTop: 12 }} lang={cible} dir={direction(cible)}>
          <b>{nom.legende}</b>{" "}
          {Object.entries(legend)
            .map(([k, v]) => `${k} = ${v}`)
            .join(" · ")}
        </p>
      )}

      <h2 className="block-section">Fiche traduite</h2>
      {toc.length > 1 && <AccordionControls deplier="Tout déplier" replier="Tout replier" />}
      <div lang={cible} dir={direction(cible)} dangerouslySetInnerHTML={{ __html: html || `<p class="block-p">${escapeHtml("(contenu vide)")}</p>` }} />

      <form action={reviewTranslation} className="unlock-box" id="relecture" style={{ marginTop: 28 }}>
        <h2>Relecture</h2>
        {message && !r?.toString().startsWith("pub") && !["publiee", "retiree"].includes(String(r)) && (
          <p style={{ color: "var(--ink)", fontWeight: 600 }}>{message}</p>
        )}
        {t.reviewed_at && (
          <p style={{ fontSize: "0.9rem" }}>
            Dernière décision le {date(t.reviewed_at)} : {t.status === "relue" ? "relue" : "brouillon"}.
          </p>
        )}
        <input type="hidden" name="id" value={id} />
        <input type="hidden" name="cible" value={cible} />
        <div className="field">
          <label htmlFor="tr-notes">Remarques du relecteur (corrections à faire dans l&apos;atelier, points tranchés)</label>
          <textarea id="tr-notes" name="notes" maxLength={4000} rows={5} defaultValue={t.review_notes ?? ""} />
        </div>
        <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 12px" }}>
          <input type="checkbox" name="confirme" value="1" style={{ marginTop: 3 }} />
          <span>
            J&apos;ai relu la traduction : grades, doses, unités et seuils identiques à la fiche
            française ; points « à vérifier » traités ; aucune note interne.
          </span>
        </label>
        <div style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
          <button className="btn btn-primary" name="relue" value="1">
            Marquer relue
          </button>
          <button className="btn btn-ghost" name="relue" value="0">
            Repasser en brouillon
          </button>
        </div>
      </form>
      {lib.canPublish && (
        <form action={publishTranslation} className="unlock-box" id="publication" style={{ marginTop: 20 }}>
          <h2>Publication</h2>
          {message && (r?.toString().startsWith("pub") || ["publiee", "retiree"].includes(String(r))) && <p style={{ color: "var(--ink)", fontWeight: 600 }}>{message}</p>}
          <input type="hidden" name="id" value={id} />
          <input type="hidden" name="cible" value={cible} />
          {t.status === "publiee" ? (
            <>
              <p style={{ fontSize: "0.9rem" }}>
                Publiée{t.publiee_le ? ` le ${date(t.publiee_le)}` : ""}{" "}
                {t.publiee_sans_relecture
                  ? "comme traduction par IA non relue, avec la mention « Traduction réalisée par IA à partir de la fiche française relue par un médecin. Non relue dans cette langue. La version française et le texte officiel font foi. »"
                  : "comme traduction relue par un médecin."}
              </p>
              <button className="btn btn-ghost" name="publier" value="0">
                Retirer la publication
              </button>
            </>
          ) : (
            <>
              <p style={{ fontSize: "0.9rem" }}>
                {t.status === "relue"
                  ? "Traduction relue : publiable comme traduction relue par un médecin."
                  : "Traduction non relue : publiable comme traduction par IA non relue, avec sa mention, si la fiche française est publiée et relue par un médecin, si elle n'a pas changé depuis la traduction et si aucun point ne reste à vérifier."}{" "}
                Dans tous les cas, le registre juridique doit autoriser la traduction de la source.
              </p>
              <ul style={{ margin: "0 0 12px", paddingLeft: 18, fontSize: "0.86rem" }}>
                <li>Fiche française à jour : {t.fr_a_jour ? "oui" : "non"}</li>
                <li>Points à vérifier : {t.a_verifier?.length ?? 0}</li>
              </ul>
              <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 12px" }}>
                <input type="checkbox" name="confirme" value="1" style={{ marginTop: 3 }} />
                <span>
                  {t.status === "relue"
                    ? "Je publie cette traduction relue, avec la mention « La version française et le texte officiel font foi »."
                    : "Je publie cette traduction par IA, non relue dans cette langue, avec la mention « Traduction réalisée par IA à partir de la fiche française relue par un médecin. Non relue dans cette langue. La version française et le texte officiel font foi. »"}
                </span>
              </label>
              <button className="btn btn-primary" name="publier" value="1">
                Publier
              </button>
            </>
          )}
        </form>
      )}
      <p className="block-p is-note" style={{ marginTop: 24 }}>
        <Link href="/bibliotheque/traductions">← Toutes les traductions</Link>
      </p>
    </Shell>
  );
}
