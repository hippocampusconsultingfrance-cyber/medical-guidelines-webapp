import type { Metadata } from "next";
import { cache } from "react";
import Link from "next/link";
import { notFound } from "next/navigation";
import { avertissementAnciennete, FREE_QUOTA, formatDate, methodologieLisible } from "@/lib/fiches";
import { INDEXABLE, SITE_URL, ficheKey, ficheSlug } from "@/lib/seo";
import { loadApercuPublic, loadPointsClesPublics, loadPublicFiches } from "../data";
import PublicHeader from "../public-header";
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
  const found = await load(slug);
  if (!found) return { title: "Fiche introuvable — medical-guidelines.net" };
  const { fiche } = found;
  const title = fiche.card_json?.title ?? fiche.title;
  const description = (fiche.card_json?.short ?? fiche.title).slice(0, 160);
  return {
    title: `${title} — ${fiche.societies.slice(0, 3).join(" / ") || "fiche de synthèse"} | medical-guidelines.net`,
    description,
    alternates: { canonical: `${SITE_URL}/recommandations/${slug}` },
    robots: { index: INDEXABLE, follow: INDEXABLE },
    openGraph: {
      title,
      description,
      type: "article",
      url: `${SITE_URL}/recommandations/${slug}`,
      siteName: "medical-guidelines.net",
      locale: "fr_FR",
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
  const found = await load(slug);
  if (!found) notFound();
  const { fiche } = found;
  if (ficheSlug(fiche.fiche_key) !== slug) notFound();
  const [toutes, points, apercu] = await Promise.all([
    loadPublicFiches(),
    loadPointsClesPublics(fiche.id),
    loadApercuPublic(fiche.id),
  ]);
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
  const title = c?.title ?? fiche.title;
  const date = formatDate(fiche.publication_date);
  const anciennete = fiche.freshness_status === "remplacee" ? null : avertissementAnciennete(fiche.publication_date);
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "MedicalWebPage",
    name: title,
    description: c?.short ?? fiche.title,
    url: `${SITE_URL}/recommandations/${slug}`,
    about: { "@type": "MedicalGuideline", name: fiche.title, url: fiche.source_url },
    audience: { "@type": "MedicalAudience", audienceType: "Clinician" },
    inLanguage: "fr",
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
            { "@type": "ListItem", position: 1, name: "Accueil", item: SITE_URL },
            { "@type": "ListItem", position: 2, name: "Recommandations", item: `${SITE_URL}/recommandations` },
            { "@type": "ListItem", position: 3, name: title, item: `${SITE_URL}/recommandations/${slug}` },
          ],
        }}
      />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <p className="text-sm">
          <Link href="/recommandations" className="text-[#1A74A6] underline">
            ← Toutes les recommandations
          </Link>
        </p>
        <p className="mt-6 font-mono text-xs font-semibold uppercase tracking-wider text-[#177E73]">
          {c?.society ?? fiche.societies.join(" / ")}
        </p>
        <h1 className="mt-2 text-3xl font-bold leading-tight text-[#0E3A78]">{title}</h1>
        {c?.title && c.title !== fiche.title && <p className="mt-2 text-slate-600">{fiche.title}</p>}
        <p className="mt-2 text-sm text-slate-500">
          Synthèse indépendante, ni éditée ni validée par les sociétés savantes citées.
        </p>

        {fiche.freshness_status === "remplacee" && (
          <p role="note" className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
            <b>Recommandation remplacée.</b> La société savante a publié un texte plus récent sur ce sujet.
            {remplacante && (
              <>
                {" "}
                Consultez plutôt la fiche{" "}
                <Link href={`/recommandations/${ficheSlug(remplacante.fiche_key)}`} className="font-semibold underline">
                  {remplacante.card_json?.title ?? remplacante.title}
                </Link>
                .
              </>
            )}{" "}
            Cette fiche reste disponible pour son intérêt historique.
          </p>
        )}
        {fiche.freshness_status === "revision_detectee" && (
          <p role="note" className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
            <b>Révision en cours.</b> Une nouvelle version de cette recommandation a été annoncée par la société
            savante ; la fiche sera actualisée dès sa publication.
          </p>
        )}

        {apercu.champ ? (
          <section className="mt-8" aria-labelledby="champ">
            <h2 id="champ" className="text-lg font-bold text-slate-900">
              Champ de la recommandation
            </h2>
            <p className="mt-2 leading-relaxed text-slate-700">{apercu.champ}</p>
          </section>
        ) : (
          c?.short && (
            <section className="mt-8">
              <h2 className="text-lg font-bold text-slate-900">Résumé</h2>
              <p className="mt-2 leading-relaxed text-slate-700">{c.short}</p>
            </section>
          )
        )}

        {points.length > 0 && (
          <section className="mt-8" aria-labelledby="points-cles">
            <h2 id="points-cles" className="text-lg font-bold text-slate-900">
              Points clés
            </h2>
            <ul className="mt-3 list-disc space-y-2 pl-5 leading-relaxed text-slate-700">
              {points.map((p) => (
                <li key={p}>{p}</li>
              ))}
            </ul>
          </section>
        )}

        <section className="mt-6 rounded-2xl bg-[#EEF6FB] p-6">
          <h2 className="text-lg font-bold text-[#0E3A78]">Lire la fiche complète</h2>
          <p className="mt-2 text-sm text-slate-700">
            Recommandations détaillées par thème, avec leurs grades tels qu&apos;ils figurent dans la
            source. Compte gratuit : {FREE_QUOTA} fiches au choix, sans carte bancaire.
          </p>
          <SelonConnexion
            connecte={
              <Link
                href={`/bibliotheque/${fiche.id}`}
                className="mt-4 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
              >
                Ouvrir la fiche dans ma bibliothèque
              </Link>
            }
            visiteur={
              <div className="mt-4 flex flex-col gap-3 sm:flex-row">
                <Link
                  href="/inscription"
                  className="rounded-lg bg-[#0E3A78] px-6 py-3 text-center font-semibold text-white hover:bg-[#0B2F63]"
                >
                  Créer mon compte gratuit
                </Link>
                <Link
                  href="/connexion"
                  className="rounded-lg border border-slate-300 bg-white px-6 py-3 text-center font-semibold text-slate-800 hover:bg-slate-50"
                >
                  J&apos;ai déjà un compte
                </Link>
              </div>
            }
          />
        </section>

        {apercu.chapitres.length > 1 && (
          <section className="mt-10" aria-labelledby="sommaire">
            <h2 id="sommaire" className="text-lg font-bold text-slate-900">
              Sommaire de la fiche complète
            </h2>
            <ol className="mt-3 list-decimal space-y-1 pl-6 text-slate-700 marker:text-slate-400">
              {apercu.chapitres.slice(0, CHAPITRES_MAX).map((t) => (
                <li key={t}>{t}</li>
              ))}
            </ol>
            {apercu.chapitres.length > CHAPITRES_MAX && (
              <p className="mt-2 text-sm text-slate-500">
                Et {apercu.chapitres.length - CHAPITRES_MAX} autres chapitres.
              </p>
            )}
          </section>
        )}

        <dl className="mt-10 grid gap-x-6 gap-y-2 text-sm sm:grid-cols-[auto_1fr]">
          {fiche.societies.length > 0 && (
            <>
              <dt className="font-semibold text-slate-900">Sociétés savantes</dt>
              <dd className="text-slate-600">{fiche.societies.join(", ")}</dd>
            </>
          )}
          {(fiche.doc_type || date) && (
            <>
              <dt className="font-semibold text-slate-900">Document</dt>
              <dd className="text-slate-600">{[fiche.doc_type, date].filter(Boolean).join(" · ")}</dd>
            </>
          )}
          {c?.methodology && (
            <>
              <dt className="font-semibold text-slate-900">Méthodologie</dt>
              <dd className="text-slate-600">{methodologieLisible(c.methodology)}</dd>
            </>
          )}
          {c?.validated && (
            <>
              <dt className="font-semibold text-slate-900">Validation</dt>
              <dd className="text-slate-600">{c.validated}</dd>
            </>
          )}
        </dl>

        {anciennete && (
          <p role="note" className="mt-6 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">
            <b>Source ancienne.</b> {anciennete}
          </p>
        )}


        <p className="mt-6 text-sm">
          <a href={fiche.source_url} target="_blank" rel="noopener noreferrer" className="text-[#1A74A6] underline">
            Document source officiel ↗
          </a>{" "}
          <span className="text-slate-500">
            — en accès libre sur le site de la société savante
            {fiche.link_status === "ok" && fiche.link_last_checked_at
              ? ` (lien contrôlé le ${formatDate(fiche.link_last_checked_at.slice(0, 10))})`
              : ""}
            .
          </span>
        </p>


        {voisines.length > 0 && (
          <section className="mt-10" aria-labelledby="voisines">
            <h2 id="voisines" className="text-lg font-bold text-slate-900">
              Autres fiches — {section}
            </h2>
            <ul className="mt-3 divide-y divide-slate-100 overflow-hidden rounded-2xl ring-1 ring-slate-200">
              {voisines.map((f) => (
                <li key={f.id}>
                  <Link
                    href={`/recommandations/${ficheSlug(f.fiche_key)}`}
                    className="flex flex-col gap-0.5 px-4 py-3 hover:bg-slate-50"
                  >
                    <span className="font-medium text-slate-900">{f.card_json?.title ?? f.title}</span>
                    <span className="font-mono text-xs text-slate-500">
                      {[f.societies.slice(0, 3).join(" / "), formatDate(f.publication_date)].filter(Boolean).join(" · ")}
                    </span>
                  </Link>
                </li>
              ))}
            </ul>
            <p className="mt-3 text-sm">
              <Link href="/recommandations" className="text-[#1A74A6] underline">
                Voir toutes les recommandations
              </Link>
            </p>
          </section>
        )}

        <p className="mt-10 text-xs text-slate-500">
          Synthèse indépendante : elle ne remplace ni le texte intégral de la recommandation
          officielle ni le jugement clinique, et n&apos;est ni éditée ni validée par les sociétés
          savantes citées.{" "}
          <Link href="/demarche" className="underline">
            Notre démarche
          </Link>
        </p>
      </main>
    </div>
  );
}
