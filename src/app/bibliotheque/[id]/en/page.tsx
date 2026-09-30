import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { chipClass, escapeHtml, renderPresentation, type Card, type Presentation } from "@/lib/fiches";
import { createClient } from "@/lib/supabase/server";
import AccordionControls from "../../accordion-controls";
import { cardTitle, loadLibrary } from "../../data";
import Shell from "../../shell";
import { reviewTranslation } from "./actions";

export const metadata: Metadata = {
  title: "Relecture de la traduction — medical-guidelines.net",
};

const UUID = /^[0-9a-f-]{36}$/i;

const MESSAGES: Record<string, string> = {
  relue: "Traduction marquée relue.",
  brouillon: "Traduction repassée en brouillon.",
  confirmation: "Cochez la case de relecture avant de marquer la traduction relue.",
  erreur: "L'enregistrement n'a pas abouti (droits de relecteur requis).",
};

type KeyPoint = { ref?: string; ref_en?: string; grade?: string; fr?: string; en?: string };
type Translation = {
  status: string;
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

// Relecture de la version anglaise d'une fiche (équipe éditoriale) : points
// à vérifier, points clés français/anglais, fiche traduite complète, décision
// du relecteur. Jamais visible des membres.
export default async function TraductionPage({ params, searchParams }: PageProps<"/bibliotheque/[id]/en">) {
  const { id } = await params;
  if (!UUID.test(id)) notFound();
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
    .select(
      "status, card_json, presentation_json, key_points, a_verifier, source_publication_date, fr_a_jour, review_notes, reviewed_at, imported_at",
    )
    .eq("document_id", id)
    .eq("lang", "en")
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
          Traduction anglaise · {t.status === "relue" ? "relue" : "brouillon"} · non publiée
        </div>
        <h1>{t.card_json?.title ?? cardTitle(doc)}</h1>
        <p className="block-p" style={{ color: "var(--ink-muted)", marginTop: 0 }}>
          Fiche française : <Link href={`/bibliotheque/${id}`}>{cardTitle(doc)}</Link>
          {" · "}importée le {date(t.imported_at)}
          {t.source_publication_date ? ` · source du ${date(t.source_publication_date)}` : ""}
        </p>
        {t.card_json?.short && <p className="block-p">{t.card_json.short}</p>}
        {!t.fr_a_jour && (
          <div className="panel warn" role="note">
            <b>Fiche française modifiée depuis la traduction.</b> Cette version anglaise part
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
          <h2 className="block-section">Points clés — français / anglais</h2>
          <div className="table-scroll">
            <table className="rfe">
              <thead>
                <tr>
                  <th>Réf.</th>
                  <th>Grade</th>
                  <th>Français</th>
                  <th>English</th>
                </tr>
              </thead>
              <tbody>
                {t.key_points.map((k, i) => (
                  <tr key={i}>
                    <td>{k.ref_en ?? k.ref}</td>
                    <td className="num">
                      {k.grade && <span className={`chip ${chipClass(k.grade)}`}>{k.grade}</span>}
                    </td>
                    <td>{k.fr}</td>
                    <td>{k.en}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}

      {legend && (
        <p className="block-p is-note" style={{ marginTop: 12 }}>
          <b>Grade legend:</b>{" "}
          {Object.entries(legend)
            .map(([k, v]) => `${k} = ${v}`)
            .join(" · ")}
        </p>
      )}

      <h2 className="block-section">Fiche traduite</h2>
      {toc.length > 1 && <AccordionControls />}
      <div lang="en" dangerouslySetInnerHTML={{ __html: html || `<p class="block-p">${escapeHtml("(contenu vide)")}</p>` }} />

      <form action={reviewTranslation} className="unlock-box" id="relecture" style={{ marginTop: 28 }}>
        <h2>Relecture</h2>
        {message && <p style={{ color: "var(--ink)", fontWeight: 600 }}>{message}</p>}
        {t.reviewed_at && (
          <p style={{ fontSize: "0.9rem" }}>
            Dernière décision le {date(t.reviewed_at)} : {t.status === "relue" ? "relue" : "brouillon"}.
          </p>
        )}
        <input type="hidden" name="id" value={id} />
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
      <p className="block-p is-note" style={{ marginTop: 24 }}>
        <Link href="/bibliotheque/traductions">← Toutes les traductions</Link>
      </p>
    </Shell>
  );
}
