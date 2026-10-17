import type { Metadata } from "next";
import { cache } from "react";
import Link from "next/link";
import { notFound } from "next/navigation";
import { FICHE } from "@/i18n/fiche";
import { fmt, plur } from "@/i18n/format";
import { rubrique } from "@/i18n/rubriques";
import { textes } from "@/i18n/serveur";
import { ANCIENNETE_MAX, anneeAncienne, FREE_QUOTA, formatDate, methodologieLisible } from "@/lib/fiches";
import { LANGUES_OUVERTES, texteFrancais, type LangueOuverte } from "@/lib/langues";
import { INDEXABLE, LANGUES_CONTENU, SITE_URL, alternatives, contenuIndexable, ficheKey, ficheSlug } from "@/lib/seo";
import { loadApercuPublic, loadPointsClesPublics, loadPublicFiches, loadTraductionsPubliques } from "../data";
import PublicHeader from "../public-header";
import { RECOMMANDATIONS } from "../textes";
import DonneesStructurees from "../../donnees-structurees";
import SelonConnexion from "../../selon-connexion";

// Pages mises en cache (identiques pour tous les visiteurs), générées à la
// première visite puis régénérées au plus toutes les 5 minutes, ou dès
// qu'une fiche est publiée ou retirée (étiquette des fiches publiques).
export const revalidate = 300;
export function generateStaticParams() {
  return [];
}

// Chapitres affichés dans le sommaire public (les suivants sont comptés).
const CHAPITRES_MAX = 12;

// Une seule lecture par requête pour les métadonnées et la page.
const load = cache(async (slug: string) => {
  if (!/^[a-z0-9-]{2,120}$/.test(slug)) return null;
  const [fiche] = await loadPublicFiches(ficheKey(slug));
  return fiche ? { fiche } : null;
});

export async function generateMetadata({ params }: PageProps<"/[lang]/recommandations/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  const { t, langue } = await textes(RECOMMANDATIONS);
  const found = await load(slug);
  if (!found) return { title: t.fiche.introuvable };
  const { fiche } = found;
  // Traduction publiée dans la langue de la page : titre et résumé traduits,
  // page indexée ; hreflang : le français et les langues traduites.
  const traductions = await loadTraductionsPubliques(fiche.id);
  const tr = langue === "fr" ? undefined : traductions[langue];
  const title = tr?.card?.title ?? fiche.card_json?.title ?? fiche.title;
  const description = (tr?.card?.short ?? fiche.card_json?.short ?? fiche.title).slice(0, 160);
  const langues: LangueOuverte[] = [...LANGUES_CONTENU, ...LANGUES_OUVERTES.filter((l) => !LANGUES_CONTENU.includes(l) && traductions[l])];
  const adresses = alternatives(langue, `/recommandations/${slug}`, langues);
  return {
    title: `${title} — ${fiche.societies.slice(0, 3).join(" / ") || FICHE[langue].synthese} | medical-guidelines.net`,
    description,
    alternates: adresses,
    robots: { index: contenuIndexable(langue) || (INDEXABLE && Boolean(tr)), follow: INDEXABLE },
    openGraph: {
      title,
      description,
      type: "article",
      url: adresses.canonical,
      siteName: "medical-guidelines.net",
      locale: t.catalogue.ogLocale,
    },
    twitter: { card: "summary_large_image" },
  };
}

// Page publique de résumé d'une fiche : ce qui figure sur sa carte (titre,
// sociétés, date, méthodologie, résumé), son champ d'application, ses 3
// premiers points clés validés, le sommaire de ses chapitres et le lien vers
// la source. Le contenu de la fiche (recommandations détaillées et grades)
// reste réservé aux comptes (crédits ou PREMIUM).
export default async function RecommandationPage({ params }: PageProps<"/[lang]/recommandations/[slug]">) {
  const { slug } = await params;
  const { t, langue, lien, locale } = await textes(RECOMMANDATIONS);
  const tf = FICHE[langue];
  const fr = texteFrancais(langue);
  const found = await load(slug);
  if (!found) notFound();
  const { fiche } = found;
  if (ficheSlug(fiche.fiche_key) !== slug) notFound();
  const [toutes, points, apercuFr, traductions] = await Promise.all([
    loadPublicFiches(),
    loadPointsClesPublics(fiche.id),
    loadApercuPublic(fiche.id),
    loadTraductionsPubliques(fiche.id),
  ]);
  // Traduction publiée dans la langue de la page (sinon : contenu en français).
  const tr = langue === "fr" ? undefined : traductions[langue];
  const apercu = tr ? tr.apercu : apercuFr;
  const contenu = tr ? { lang: langue } : fr;
  // Texte source remplacé : lien vers la fiche qui le remplace, si elle est en ligne.
  const remplacante =
    fiche.freshness_status === "remplacee" && fiche.superseded_by_document_id
      ? toutes.find((f) => f.id === fiche.superseded_by_document_id)
      : undefined;
  // Autres fiches de la même spécialité, de la plus récente à la plus ancienne.
  const section = fiche.card_json?.section;
  const voisines = section
    ? toutes.filter((f) => f.id !== fiche.id && f.card_json?.section === section).slice(0, 6)
    : [];

  const c = fiche.card_json;
  const title = tr?.card?.title ?? c?.title ?? fiche.title;
  const resume = tr?.card?.short ?? c?.short;
  const date = formatDate(fiche.publication_date, locale);
  const annee = fiche.freshness_status === "remplacee" ? null : anneeAncienne(fiche.publication_date);
  const url = `${SITE_URL}${lien(`/recommandations/${slug}`)}`;
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "MedicalWebPage",
    name: title,
    description: resume ?? fiche.title,
    url,
    about: { "@type": "MedicalGuideline", name: fiche.title, url: fiche.source_url },
    audience: { "@type": "MedicalAudience", audienceType: "Clinician" },
    // Contenu de la fiche : en français tant que sa traduction n'est pas publiée.
    inLanguage: tr ? langue : "fr",
  };

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <DonneesStructurees data={jsonLd} />
      <DonneesStructurees
        data={{
          "@context": "https://schema.org",
          "@type": "BreadcrumbList",
          itemListElement: [
            { "@type": "ListItem", position: 1, name: t.accueil, item: alternatives(langue, "/").canonical },
            { "@type": "ListItem", position: 2, name: t.recommandations, item: `${SITE_URL}${lien("/recommandations")}` },
            { "@type": "ListItem", position: 3, name: title, item: url },
          ],
        }}
      />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <p className="text-sm">
          <Link href={lien("/recommandations")} className="text-[#1A74A6] underline">
            {t.fiche.retour}
          </Link>
        </p>
        <p className="mt-6 font-mono text-xs font-semibold uppercase tracking-wider text-[#177E73]">
          {c?.society ?? fiche.societies.join(" / ")}
        </p>
        <h1 className="mt-2 text-3xl font-bold leading-tight text-[#0E3A78]" {...contenu}>
          {title}
        </h1>
        {c?.title && c.title !== fiche.title && (
          <p className="mt-2 text-slate-600" {...fr}>
            {fiche.title}
          </p>
        )}
        <p className="mt-2 text-sm text-slate-500">{t.fiche.independante}</p>
        {tr ? (
          <p role="note" className="mt-4 rounded-lg bg-amber-50 p-3 text-sm text-amber-900 ring-1 ring-amber-200">
            {tr.iaNonRelue ? tf.traductionIA : tf.traductionRelue}
          </p>
        ) : (
          tf.enFrancais && (
            <p role="note" className="mt-4 rounded-lg bg-slate-50 p-3 text-sm text-slate-600 ring-1 ring-slate-200">
              {tf.enFrancais}
            </p>
          )
        )}

        {fiche.freshness_status === "remplacee" && (
          <p role="note" className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
            <b>{t.fiche.remplaceeTitre}</b> {t.fiche.remplaceeTexte}
            {remplacante && (
              <>
                {" "}
                {t.fiche.remplaceeVoir}{" "}
                <Link href={lien(`/recommandations/${ficheSlug(remplacante.fiche_key)}`)} className="font-semibold underline">
                  {remplacante.card_json?.title ?? remplacante.title}
                </Link>
                .
              </>
            )}{" "}
            {t.fiche.remplaceeHistorique}
          </p>
        )}
        {fiche.freshness_status === "revision_detectee" && (
          <p role="note" className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
            <b>{t.fiche.revisionTitre}</b> {t.fiche.revisionTexte}
          </p>
        )}

        {apercu.champ ? (
          <section className="mt-8" aria-labelledby="champ">
            <h2 id="champ" className="text-lg font-bold text-slate-900">
              {t.fiche.champ}
            </h2>
            <p className="mt-2 leading-relaxed text-slate-700" {...contenu}>
              {apercu.champ}
            </p>
          </section>
        ) : (
          resume && (
            <section className="mt-8">
              <h2 className="text-lg font-bold text-slate-900">{t.fiche.resume}</h2>
              <p className="mt-2 leading-relaxed text-slate-700" {...contenu}>
                {resume}
              </p>
            </section>
          )
        )}

        {points.length > 0 && (
          <section className="mt-8" aria-labelledby="points-cles">
            <h2 id="points-cles" className="text-lg font-bold text-slate-900">
              {t.fiche.pointsCles}
            </h2>
            <ul className="mt-3 list-disc space-y-2 ps-5 leading-relaxed text-slate-700" {...fr}>
              {points.map((p) => (
                <li key={p}>{p}</li>
              ))}
            </ul>
          </section>
        )}

        <section className="mt-6 rounded-2xl bg-[#EEF6FB] p-6">
          <h2 className="text-lg font-bold text-[#0E3A78]">{t.fiche.lireTitre}</h2>
          <p className="mt-2 text-sm text-slate-700">{fmt(t.fiche.lireTexte, { quota: FREE_QUOTA })}</p>
          <SelonConnexion
            connecte={
              <Link
                href={lien(`/bibliotheque/${fiche.id}`)}
                className="mt-4 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
              >
                {t.fiche.ouvrir}
              </Link>
            }
            visiteur={
              <div className="mt-4 flex flex-col gap-3 sm:flex-row">
                <Link
                  href={lien("/inscription")}
                  className="rounded-lg bg-[#0E3A78] px-6 py-3 text-center font-semibold text-white hover:bg-[#0B2F63]"
                >
                  {t.fiche.creerCompte}
                </Link>
                <Link
                  href={lien("/connexion")}
                  className="rounded-lg border border-slate-300 bg-white px-6 py-3 text-center font-semibold text-slate-800 hover:bg-slate-50"
                >
                  {t.fiche.dejaCompte}
                </Link>
              </div>
            }
          />
        </section>

        {apercu.chapitres.length > 1 && (
          <section className="mt-10" aria-labelledby="sommaire">
            <h2 id="sommaire" className="text-lg font-bold text-slate-900">
              {t.fiche.sommaire}
            </h2>
            <ol className="mt-3 list-decimal space-y-1 ps-6 text-slate-700 marker:text-slate-400" {...contenu}>
              {apercu.chapitres.slice(0, CHAPITRES_MAX).map((chapitre) => (
                <li key={chapitre}>{chapitre}</li>
              ))}
            </ol>
            {apercu.chapitres.length > CHAPITRES_MAX && (
              <p className="mt-2 text-sm text-slate-500">
                {plur(locale, apercu.chapitres.length - CHAPITRES_MAX, t.fiche.autresChapitres)}
              </p>
            )}
          </section>
        )}

        <dl className="mt-10 grid gap-x-6 gap-y-2 text-sm sm:grid-cols-[auto_1fr]">
          {fiche.societies.length > 0 && (
            <>
              <dt className="font-semibold text-slate-900">{t.fiche.societes}</dt>
              <dd className="text-slate-600">{fiche.societies.join(", ")}</dd>
            </>
          )}
          {(fiche.doc_type || date) && (
            <>
              <dt className="font-semibold text-slate-900">{t.fiche.document}</dt>
              <dd className="text-slate-600">{[fiche.doc_type, date].filter(Boolean).join(" · ")}</dd>
            </>
          )}
          {c?.methodology && (
            <>
              <dt className="font-semibold text-slate-900">{t.fiche.methodologie}</dt>
              <dd className="text-slate-600">{methodologieLisible(c.methodology)}</dd>
            </>
          )}
          {c?.validated && (
            <>
              <dt className="font-semibold text-slate-900">{t.fiche.validation}</dt>
              <dd className="text-slate-600">{c.validated}</dd>
            </>
          )}
        </dl>

        {annee && (
          <p role="note" className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
            <b>{tf.ancienneTitre}</b> {fmt(tf.ancienneTexte, { annee, max: ANCIENNETE_MAX })}
          </p>
        )}


        <p className="mt-6 text-sm">
          <a href={fiche.source_url} target="_blank" rel="noopener noreferrer" className="text-[#1A74A6] underline">
            {tf.sourceOfficielle}
          </a>{" "}
          <span className="text-slate-500">
            {t.fiche.accesLibre}
            {fiche.link_status === "ok" && fiche.link_last_checked_at
              ? fmt(t.fiche.lienControle, { date: formatDate(fiche.link_last_checked_at.slice(0, 10), locale) ?? "" })
              : ""}
            .
          </span>
        </p>


        {voisines.length > 0 && (
          <section className="mt-10" aria-labelledby="voisines">
            <h2 id="voisines" className="text-lg font-bold text-slate-900">
              {fmt(t.fiche.autres, { rubrique: section ? rubrique(section, langue).nom : "" })}
            </h2>
            <ul className="mt-3 divide-y divide-slate-100 overflow-hidden rounded-2xl ring-1 ring-slate-200">
              {voisines.map((f) => (
                <li key={f.id}>
                  <Link
                    href={lien(`/recommandations/${ficheSlug(f.fiche_key)}`)}
                    className="flex flex-col gap-0.5 px-4 py-3 hover:bg-slate-50"
                  >
                    <span className="font-medium text-slate-900">{f.card_json?.title ?? f.title}</span>
                    <span className="font-mono text-xs text-slate-500">
                      {[f.societies.slice(0, 3).join(" / "), formatDate(f.publication_date, locale)].filter(Boolean).join(" · ")}
                    </span>
                  </Link>
                </li>
              ))}
            </ul>
            <p className="mt-3 text-sm">
              <Link href={lien("/recommandations")} className="text-[#1A74A6] underline">
                {t.fiche.voirToutes}
              </Link>
            </p>
          </section>
        )}

        <p className="mt-10 text-xs text-slate-500">
          {t.fiche.avertissement}{" "}
          <Link href={lien("/demarche")} className="underline">
            {t.fiche.demarche}
          </Link>
        </p>
      </main>
    </div>
  );
}
