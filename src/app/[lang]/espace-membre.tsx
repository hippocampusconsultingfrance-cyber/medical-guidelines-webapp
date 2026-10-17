import Link from "next/link";
import type { SupabaseClient, User } from "@supabase/supabase-js";
import { FICHE } from "@/i18n/fiche";
import { fmt, plur, riche } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { nomProfession, nomSpecialite } from "@/i18n/specialites";
import { formatDate, FREE_QUOTA } from "@/lib/fiches";
import type { LangueOuverte } from "@/lib/langues";
import {
  cardTitle,
  docState,
  loadLibrary,
  societyCounts,
  type Library,
  type LibraryDoc,
} from "./bibliotheque/data";
import { followSociety, unfollowSociety } from "./actions";
import LogoutButton from "./logout-button";
import { assistantOuvertAuxMembres } from "@/lib/assistant";
import Logo from "./logo";
import { ESPACE } from "./textes-espace";

// Espace membre (page d'accueil d'un compte connecté) : fiches mises à jour,
// nouveautés de l'année des sociétés savantes de la spécialité, fiches les
// plus consultées, favoris, lecture en cours, crédits ou abonnement, suivi
// des sociétés (alertes e-mail). Tout vient des données que la base laisse
// lire au compte : fiches de sa spécialité, ses propres déblocages, favoris,
// suivis et historique, et des fonctions dédiées (my_document_updates,
// popular_documents) qui ne renvoient rien de l'historique des autres.

type Profile = { prenom: string | null; profession: string | null };

type DocumentUpdate = {
  document_id: string;
  title: string;
  freshness_status: string;
  superseded_by: string | null;
  version_label: string | null;
  change_type: string | null;
  diff_summary: string | null;
  version_published_at: string | null;
};

const STATE_CLASS = {
  lock: "bg-slate-100 text-slate-600",
  open: "bg-emerald-50 text-emerald-800",
  draft: "bg-amber-50 text-amber-800",
};

// Textes, langue et liens de la page, pour les blocs ci-dessous.
type I18n = {
  t: (typeof ESPACE)["fr"];
  tf: (typeof FICHE)["fr"];
  langue: LangueOuverte;
  locale: string;
  lien: (p: string) => string;
};

// Nombre de nouveautés affichées avant le lien vers la bibliothèque.
const NEWS_LIMIT = 8;
// Sociétés du filtre des nouveautés visibles d'emblée, les autres repliées.
const CHIP_LIMIT = 6;
const RECENT_LIMIT = 5;

const primaryBtn =
  "inline-flex items-center justify-center rounded-lg bg-[#0E3A78] px-5 py-2.5 font-semibold text-white shadow-sm hover:bg-[#0B2F63] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#3AA8E0]";
const card = "rounded-2xl border border-slate-200 p-5";

export default async function EspaceMembre({
  supabase,
  user,
  profile,
  societe: societeParam,
  r,
}: {
  supabase: SupabaseClient;
  user: User;
  profile: Profile | null;
  societe: string;
  r: string;
}) {
  const { t, langue, lien, locale } = await textes(ESPACE);
  const i18n: I18n = { t, tf: FICHE[langue], langue, locale, lien };
  // Les deux fonctions et la colonne email_alerts viennent de la migration
  // 20260929140000 : en son absence, les blocs correspondants restent vides.
  const [lib, { data: history }, { data: sub }, { data: updates }, { data: popular }, { data: follows }, { data: prefs }] =
    await Promise.all([
      loadLibrary(supabase, user.id),
      supabase
        .from("consultation_history")
        .select("document_id, viewed_at")
        .eq("user_id", user.id)
        .not("document_id", "is", null)
        .order("viewed_at", { ascending: false })
        .limit(50),
      supabase
        .from("subscriptions")
        .select("current_period_end, canceled_at")
        .eq("user_id", user.id)
        .maybeSingle(),
      supabase.rpc("my_document_updates"),
      supabase.rpc("popular_documents", { max_results: 5 }),
      supabase
        .from("notification_preferences")
        .select("societies(acronym)")
        .eq("user_id", user.id)
        .not("society_id", "is", null),
      supabase.from("profiles").select("email_alerts").eq("id", user.id).maybeSingle(),
    ]);

  const year = new Intl.DateTimeFormat(locale, { year: "numeric", timeZone: "Europe/Paris" }).format(new Date());
  const yearDocs = lib.docs.filter((d) => d.publication_date?.startsWith(year));
  const yearSocieties = societyCounts(yearDocs);
  const societe = yearSocieties.some(([s]) => s === societeParam) ? societeParam : "";
  const news = societe ? yearDocs.filter((d) => d.societies.includes(societe)) : yearDocs;
  // Aucune recommandation de l'année : les plus récentes, pour ne jamais
  // afficher un bloc vide.
  const latest = yearDocs.length ? [] : lib.docs.filter((d) => d.publication_date).slice(0, 6);

  const byId = new Map(lib.docs.map((d) => [d.id, d]));
  const seen = new Set<string>();
  const recent: { doc: LibraryDoc; viewedAt: string }[] = [];
  for (const h of (history ?? []) as { document_id: string; viewed_at: string }[]) {
    const doc = byId.get(h.document_id);
    if (!doc || seen.has(doc.id)) continue;
    seen.add(doc.id);
    recent.push({ doc, viewedAt: h.viewed_at });
    if (recent.length === RECENT_LIMIT) break;
  }

  const favorites = lib.favorites.flatMap((id) => byId.get(id) ?? []);
  const popularDocs = ((popular ?? []) as { document_id: string; rank: number }[]).flatMap(
    (p) => byId.get(p.document_id) ?? [],
  );
  const societies = societyCounts(lib.docs);
  const followed = new Set(
    ((follows ?? []) as { societies: { acronym: string } | { acronym: string }[] | null }[]).flatMap((f) =>
      (Array.isArray(f.societies) ? f.societies : f.societies ? [f.societies] : []).map((s) => s.acronym),
    ),
  );
  const emailAlerts = (prefs as { email_alerts?: boolean } | null)?.email_alerts;
  // Les alertes font partie de PREMIUM : un ancien abonné garde ses suivis,
  // qui ne sont plus affichés tant qu'il n'est pas réabonné.
  const canFollow = lib.premium || lib.isEditor;
  const unlockedDocs = lib.docs.filter((d) => lib.unlocked.has(d.id));
  const newsHref = (s: string) => lien(s ? `/?societe=${encodeURIComponent(s)}` : "/");
  const libraryYearHref = lien(`/bibliotheque?annee=${year}${societe ? `&societe=${encodeURIComponent(societe)}` : ""}`);
  const message = t.messages[r];
  const specialite = lib.specialty && lib.specialtySlug ? nomSpecialite(lib.specialtySlug, lib.specialty, langue) : lib.specialty;

  return (
    <div className="mx-auto min-h-screen max-w-6xl px-4 py-8 sm:px-6 sm:py-10">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <Logo />
        <nav className="flex items-center gap-4" aria-label={t.navCompte}>
          <Link href={lien("/bibliotheque")} className="text-sm font-medium text-slate-700 hover:text-slate-900">
            {t.bibliotheque}
          </Link>
          <Link href={lien("/compte")} className="text-sm font-medium text-slate-700 hover:text-slate-900">
            {t.monCompte}
          </Link>
          <LogoutButton />
        </nav>
      </header>

      <section className="mt-8 rounded-2xl bg-gradient-to-br from-[#0E3A78] to-[#1C5FA8] px-5 py-7 text-white sm:px-8">
        <h1 className="text-2xl font-bold sm:text-3xl">
          {t.bienvenue}
          {profile?.prenom ? `, ${profile.prenom.charAt(0).toLocaleUpperCase(locale) + profile.prenom.slice(1)}` : ""}
        </h1>
        <p className="mt-1 text-sm text-sky-100 sm:text-base">
          {[
            profile?.profession ? nomProfession(profile.profession, langue) : null,
            lib.specialty && lib.specialty !== profile?.profession ? fmt(t.specialiteConsultee, { specialite: specialite ?? "" }) : null,
          ]
            .filter(Boolean)
            .join(" · ")}
        </p>
        <form action={lien("/bibliotheque")} role="search" className="mt-6 flex max-w-2xl flex-col gap-2 sm:flex-row">
          <label className="flex flex-1 items-center gap-2 rounded-lg bg-white px-3 text-slate-800 focus-within:ring-2 focus-within:ring-[#3AA8E0]">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="h-5 w-5 shrink-0 text-slate-400" aria-hidden="true">
              <circle cx="11" cy="11" r="7" />
              <path d="m20 20-3.5-3.5" />
            </svg>
            <span className="sr-only">{t.rechercheLibelle}</span>
            <input
              name="q"
              type="search"
              maxLength={100}
              placeholder={t.recherchePlaceholder}
              className="w-full bg-transparent py-3 text-sm outline-none placeholder:text-slate-400 sm:text-base"
            />
          </label>
          <button className="rounded-lg bg-[#2BB5A6] px-5 py-3 font-semibold text-white hover:bg-[#23998C]">
            {t.rechercher}
          </button>
        </form>
        <dl className="mt-6 grid grid-cols-3 gap-3 text-center sm:max-w-xl sm:text-start">
          <Stat value={lib.docs.length} label={plur(locale, lib.docs.length, t.statFiches)} />
          <Stat value={yearDocs.length} label={plur(locale, yearDocs.length, t.statNouveautes, { annee: year })} />
          <Stat value={societies.length} label={plur(locale, societies.length, t.statSocietes)} />
        </dl>
      </section>

      {lib.isEditor && (
        <p className="mt-4 rounded-lg bg-amber-50 px-4 py-3 text-sm text-amber-900">
          {t.relecteur}
        </p>
      )}

      <div className="mt-8 grid gap-8 lg:grid-cols-[minmax(0,1fr)_320px]">
        <div className="space-y-10">
          {updates && updates.length > 0 && (
            <UpdatesBlock updates={updates as DocumentUpdate[]} byId={byId} i18n={i18n} />
          )}

          <section id="nouveautes" aria-labelledby="nouveautes-titre" className="scroll-mt-6">
            <div className="flex flex-wrap items-end justify-between gap-2">
              <div>
                <h2 id="nouveautes-titre" className="text-xl font-bold text-[#0E3A78]">
                  {yearDocs.length ? fmt(t.nouveautes, { annee: year }) : t.dernieres}
                </h2>
                <p className="mt-1 text-sm text-slate-600">
                  {fmt(yearDocs.length ? t.nouveautesTexte : t.dernieresTexte, { annee: year })}
                </p>
              </div>
              <Link href={lien("/bibliotheque")} className="text-sm font-semibold text-[#1A74A6] hover:underline">
                {t.toute}
              </Link>
            </div>

            {yearSocieties.length > 1 && (
              <nav className="mt-4 flex flex-wrap items-start gap-2" aria-label={fmt(t.filtrer, { annee: year })}>
                <SocietyChip href={newsHref("")} active={!societe} label={t.toutes} count={yearDocs.length} />
                {yearSocieties.slice(0, CHIP_LIMIT).map(([s, n]) => (
                  <SocietyChip key={s} href={newsHref(s)} active={societe === s} label={s} title={lib.societyNames[s]} count={n} />
                ))}
                {yearSocieties.length > CHIP_LIMIT && (
                  <details
                    className="group basis-full"
                    open={yearSocieties.slice(CHIP_LIMIT).some(([s]) => s === societe)}
                  >
                    <summary className="inline-block cursor-pointer list-none rounded-full border border-dashed border-slate-300 px-3 py-1 text-sm font-semibold text-slate-600 hover:border-[#1A74A6] hover:text-[#1A74A6] [&::-webkit-details-marker]:hidden">
                      <span className="group-open:hidden">{plur(locale, yearSocieties.length - CHIP_LIMIT, t.autresSocietes)}</span>
                      <span className="hidden group-open:inline">{t.moinsSocietes}</span>
                    </summary>
                    <span className="mt-2 flex flex-wrap gap-2">
                      {yearSocieties.slice(CHIP_LIMIT).map(([s, n]) => (
                        <SocietyChip key={s} href={newsHref(s)} active={societe === s} label={s} title={lib.societyNames[s]} count={n} />
                      ))}
                    </span>
                  </details>
                )}
              </nav>
            )}

            {news.length === 0 && latest.length === 0 ? (
              <p className="mt-6 rounded-xl border border-dashed border-slate-300 p-6 text-sm text-slate-600">
                {t.aucuneFiche}
              </p>
            ) : (
              <ul className="mt-5 grid gap-3 sm:grid-cols-2">
                {(yearDocs.length ? news.slice(0, NEWS_LIMIT) : latest).map((d) => (
                  <li key={d.id}>
                    <DocCard doc={d} lib={lib} i18n={i18n} />
                  </li>
                ))}
              </ul>
            )}
            {news.length > NEWS_LIMIT && (
              <p className="mt-4 text-sm">
                <Link href={libraryYearHref} className="font-semibold text-[#1A74A6] hover:underline">
                  {fmt(t.voirNouveautes, { n: news.length, annee: year, societe: societe ? ` ${societe}` : "" })}
                </Link>
              </p>
            )}
          </section>

          {popularDocs.length > 0 && (
            <section aria-labelledby="populaires-titre">
              <h2 id="populaires-titre" className="text-xl font-bold text-[#0E3A78]">
                {t.populaires}
              </h2>
              <p className="mt-1 text-sm text-slate-600">{lib.premium || lib.isEditor ? t.populairesPremium : t.populairesCredits}</p>
              <ol className="mt-4 divide-y divide-slate-100 rounded-xl border border-slate-200">
                {popularDocs.map((d, i) => {
                  const state = docState(lib, d.id);
                  return (
                    <li key={d.id}>
                      <Link href={lien(`/bibliotheque/${d.id}`)} className="group flex items-center gap-4 px-4 py-3">
                        <span className="w-6 shrink-0 text-lg font-bold text-[#177E73]" aria-hidden="true">
                          {i + 1}
                        </span>
                        <span className="min-w-0 flex-1">
                          <span className="block font-semibold text-slate-900 group-hover:text-[#1A74A6] group-hover:underline">
                            {cardTitle(d)}
                          </span>
                          <span className="block text-xs text-slate-500">
                            {[d.societies.join(" · "), formatDate(d.publication_date, locale)].filter(Boolean).join(" — ")}
                          </span>
                        </span>
                        <span className={`shrink-0 rounded-full px-2 py-0.5 text-xs font-medium ${STATE_CLASS[state]}`}>
                          {i18n.tf.etats[state]}
                        </span>
                      </Link>
                    </li>
                  );
                })}
              </ol>
            </section>
          )}
        </div>

        <aside className="space-y-6">
          <AccessCard lib={lib} unlockedDocs={unlockedDocs} sub={sub} i18n={i18n} />

          <section aria-labelledby="favoris-titre" className={card}>
            <h2 id="favoris-titre" className="font-bold text-[#0E3A78]">
              {t.favoris}
            </h2>
            {favorites.length ? (
              <ul className="mt-3 divide-y divide-slate-100">
                {favorites.slice(0, 8).map((d) => (
                  <li key={d.id}>
                    <Link href={lien(`/bibliotheque/${d.id}`)} className="group flex items-baseline justify-between gap-3 py-2">
                      <span className="text-sm font-medium text-slate-800 group-hover:text-[#1A74A6] group-hover:underline">
                        {cardTitle(d)}
                      </span>
                      {docState(lib, d.id) === "lock" && (
                        <span className="shrink-0 text-xs" aria-label={t.ficheBloquee}>
                          🔒
                        </span>
                      )}
                    </Link>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="mt-2 text-sm text-slate-600">{t.favorisVide}</p>
            )}
            {favorites.length > 8 && (
              <Link href={lien("/bibliotheque")} className="mt-2 inline-block text-xs font-semibold text-[#1A74A6] hover:underline">
                {t.tousFavoris}
              </Link>
            )}
          </section>

          <section aria-labelledby="reprendre-titre" className={card}>
            <h2 id="reprendre-titre" className="font-bold text-[#0E3A78]">
              {t.reprendre}
            </h2>
            {recent.length ? (
              <ul className="mt-3 divide-y divide-slate-100">
                {recent.map(({ doc, viewedAt }) => (
                  <li key={doc.id}>
                    <Link href={lien(`/bibliotheque/${doc.id}`)} className="group flex items-baseline justify-between gap-3 py-2">
                      <span className="text-sm font-medium text-slate-800 group-hover:text-[#1A74A6] group-hover:underline">
                        {cardTitle(doc)}
                      </span>
                      <span className="shrink-0 text-xs text-slate-500">{viewedLabel(viewedAt, i18n)}</span>
                    </Link>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="mt-2 text-sm text-slate-600">{t.reprendreVide}</p>
            )}
          </section>

          {societies.length > 0 && (
            <section id="alertes" aria-labelledby="societes-titre" className={`${card} scroll-mt-6`}>
              <h2 id="societes-titre" className="font-bold text-[#0E3A78]">
                {t.societesTitre}
              </h2>
              <p className="mt-1 text-xs text-slate-500">
                {t.societesTexte}
                {canFollow && followed.size > 0 ? t.societeSuivie : ""}
              </p>
              <div className="mt-3 flex flex-wrap gap-2">
                {societies.slice(0, 12).map(([s, n]) => (
                  <Link
                    key={s}
                    href={lien(`/bibliotheque?societe=${encodeURIComponent(s)}`)}
                    title={lib.societyNames[s]}
                    className="rounded-full border border-slate-200 px-3 py-1 text-xs font-semibold text-slate-700 hover:border-[#1A74A6] hover:text-[#1A74A6]"
                  >
                    {canFollow && followed.has(s) && <span aria-label={t.suivie}>🔔 </span>}
                    {s} <span className="font-normal text-slate-500">{n}</span>
                  </Link>
                ))}
              </div>
              {societies.length > 12 && (
                <Link href={lien("/bibliotheque")} className="mt-3 inline-block text-xs font-semibold text-[#1A74A6] hover:underline">
                  {plur(locale, societies.length - 12, t.autresDansBibliotheque)}
                </Link>
              )}

              <div className="mt-5 border-t border-slate-100 pt-4">
                <h3 className="text-sm font-bold text-slate-800">{t.alertesTitre}</h3>
                {message && (
                  <p role="status" className="mt-2 rounded-md bg-[#EEF6FB] px-3 py-2 text-xs font-medium text-[#0E3A78]">
                    {message}
                  </p>
                )}
                {canFollow ? (
                  <>
                    <p className="mt-1 text-xs text-slate-600">{t.alertesTexte}</p>
                    {emailAlerts === false && (
                      <p className="mt-2 text-xs font-medium text-amber-800">
                        {riche(t.alertesDesactivees, {
                          compte: (c) => (
                            <Link href={lien("/compte#alertes")} className="underline">
                              {c}
                            </Link>
                          ),
                        })}
                      </p>
                    )}
                    {followed.size > 0 && (
                      <ul className="mt-3 flex flex-wrap gap-2" aria-label={t.suiviesAria}>
                        {[...followed].sort().map((s) => (
                          <li key={s}>
                            <form action={unfollowSociety} className="inline-flex">
                              <input type="hidden" name="societe" value={s} />
                              <input type="hidden" name="retour" value="/" />
                              <input type="hidden" name="langue" value={langue} />
                              <button
                                title={fmt(t.nePlusSuivre, { societe: lib.societyNames[s] ?? s })}
                                className="rounded-full bg-[#EEF6FB] px-3 py-1 text-xs font-semibold text-[#0E3A78] hover:bg-red-50 hover:text-red-700"
                              >
                                🔔 {s} <span aria-hidden="true">×</span>
                                <span className="sr-only">{t.nePlusSuivreCourt}</span>
                              </button>
                            </form>
                          </li>
                        ))}
                      </ul>
                    )}
                    {societies.some(([s]) => !followed.has(s)) && (
                      <form action={followSociety} className="mt-3 flex gap-2">
                        <input type="hidden" name="retour" value="/" />
                        <input type="hidden" name="langue" value={langue} />
                        <label className="sr-only" htmlFor="suivre-societe">
                          {t.societeASuivre}
                        </label>
                        <select
                          id="suivre-societe"
                          name="societe"
                          required
                          defaultValue=""
                          className="min-w-0 flex-1 rounded-md border border-slate-300 bg-white px-2 py-1.5 text-sm"
                        >
                          <option value="" disabled>
                            {t.suivreUne}
                          </option>
                          {societies
                            .filter(([s]) => !followed.has(s))
                            .map(([s]) => (
                              <option key={s} value={s}>
                                {lib.societyNames[s] ? `${s} — ${lib.societyNames[s]}` : s}
                              </option>
                            ))}
                        </select>
                        <button className="shrink-0 rounded-md bg-[#0E3A78] px-3 py-1.5 text-sm font-semibold text-white hover:bg-[#0B2F63]">
                          {t.suivre}
                        </button>
                      </form>
                    )}
                  </>
                ) : (
                  <p className="mt-1 text-xs text-slate-600">
                    {riche(t.alertesPremium, {
                      abonnement: (c) => (
                        <Link href={lien("/abonnement")} className="font-semibold text-[#1A74A6] underline">
                          {c}
                        </Link>
                      ),
                    })}
                  </p>
                )}
              </div>
            </section>
          )}
        </aside>
      </div>
    </div>
  );
}

function Stat({ value, label }: { value: number; label: string }) {
  return (
    <div className="flex flex-col rounded-lg bg-white/10 px-3 py-2">
      <dt className="order-last text-xs text-sky-100">{label}</dt>
      <dd className="text-xl font-bold sm:text-2xl">{value}</dd>
    </div>
  );
}

function SocietyChip({
  href,
  active,
  label,
  title,
  count,
}: {
  href: string;
  active: boolean;
  label: string;
  title?: string;
  count: number;
}) {
  return (
    <Link
      href={href}
      scroll={false}
      title={title}
      aria-current={active ? "true" : undefined}
      className={`rounded-full border px-3 py-1 text-sm font-semibold ${
        active
          ? "border-[#0E3A78] bg-[#0E3A78] text-white"
          : "border-slate-200 text-slate-700 hover:border-[#1A74A6] hover:text-[#1A74A6]"
      }`}
    >
      {label} <span className={active ? "font-normal text-sky-100" : "font-normal text-slate-500"}>{count}</span>
    </Link>
  );
}

function DocCard({ doc, lib, i18n }: { doc: LibraryDoc; lib: Library; i18n: I18n }) {
  const state = docState(lib, doc.id);
  const c = doc.card_json;
  return (
    <Link
      href={i18n.lien(`/bibliotheque/${doc.id}`)}
      className="flex h-full flex-col rounded-xl border border-slate-200 p-4 transition hover:border-[#1A74A6] hover:shadow-sm"
    >
      <span className="flex items-center justify-between gap-2">
        <span className="text-xs font-semibold uppercase tracking-wide text-[#1A74A6]">
          {doc.doc_type ?? i18n.tf.recommandation}
          {doc.publication_date ? ` · ${formatDate(doc.publication_date, i18n.locale)}` : ""}
        </span>
        <span className="flex shrink-0 items-center gap-1.5">
          {lib.favorite.has(doc.id) && (
            <span className="text-sm text-amber-600" aria-label={i18n.t.favoris}>
              ★
            </span>
          )}
          <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${STATE_CLASS[state]}`}>
            {i18n.tf.etats[state]}
          </span>
        </span>
      </span>
      <span className="mt-2 font-semibold leading-snug text-slate-900">{cardTitle(doc)}</span>
      {c?.short && <span className="mt-1 line-clamp-2 text-sm text-slate-600">{c.short}</span>}
      {doc.societies.length > 0 && (
        <span className="mt-auto flex flex-wrap gap-1 pt-3">
          {doc.societies.map((s) => (
            <span
              key={s}
              title={lib.societyNames[s]}
              className="rounded bg-[#EEF6FB] px-1.5 py-0.5 text-xs font-semibold text-[#0E3A78]"
            >
              {s}
            </span>
          ))}
        </span>
      )}
    </Link>
  );
}

// Fiches débloquées, favorites ou consultées qui ont changé : nouvelle
// version depuis la dernière visite, révision en cours, remplacement ou
// retrait (une fiche retirée n'est plus consultable : pas de lien).
function UpdatesBlock({ updates, byId, i18n }: { updates: DocumentUpdate[]; byId: Map<string, LibraryDoc>; i18n: I18n }) {
  const { t, tf, lien } = i18n;
  return (
    <section aria-labelledby="maj-titre" className="rounded-2xl border border-amber-200 bg-amber-50 p-5">
      <h2 id="maj-titre" className="text-lg font-bold text-amber-900">
        {t.majTitre}
      </h2>
      <p className="mt-1 text-sm text-amber-900/80">{t.majTexte}</p>
      <ul className="mt-3 space-y-2">
        {updates.map((u) => {
          const doc = byId.get(u.document_id);
          const replacement = u.superseded_by ? byId.get(u.superseded_by) : undefined;
          const detail =
            u.freshness_status === "retiree"
              ? t.majRetiree
              : u.freshness_status === "remplacee"
                ? t.majRemplacee
                : u.freshness_status === "revision_detectee"
                  ? t.majRevision
                  : [
                      u.version_label && fmt(t.majVersion, { version: u.version_label }),
                      u.change_type && fmt(t.majModification, { type: tf.criticites[u.change_type]?.toLowerCase() ?? u.change_type }),
                      u.version_published_at && fmt(t.majPubliee, { date: formatDateTime(u.version_published_at, i18n.locale) }),
                    ]
                      .filter(Boolean)
                      .join(", ") + (u.diff_summary ? ` — ${u.diff_summary}` : "");
          return (
            <li key={u.document_id} className="rounded-lg bg-white px-4 py-3">
              <div className="flex flex-wrap items-baseline justify-between gap-2">
                {doc ? (
                  <Link href={lien(`/bibliotheque/${doc.id}`)} className="font-semibold text-slate-900 hover:text-[#1A74A6] hover:underline">
                    {u.title}
                  </Link>
                ) : (
                  <span className="font-semibold text-slate-900">{u.title}</span>
                )}
                <span className="rounded-full bg-amber-100 px-2 py-0.5 text-xs font-semibold text-amber-900">
                  {tf.fraicheur[u.freshness_status] ?? t.majDefaut}
                </span>
              </div>
              <p className="mt-1 text-sm text-slate-600">{detail}</p>
              {replacement && (
                <Link href={lien(`/bibliotheque/${replacement.id}`)} className="mt-1 inline-block text-sm font-semibold text-[#1A74A6] hover:underline">
                  {fmt(t.nouvelleFiche, { titre: cardTitle(replacement) })}
                </Link>
              )}
            </li>
          );
        })}
      </ul>
    </section>
  );
}

function AccessCard({
  lib,
  unlockedDocs,
  sub,
  i18n,
}: {
  lib: Library;
  unlockedDocs: LibraryDoc[];
  sub: { current_period_end: string | null; canceled_at: string | null } | null;
  i18n: I18n;
}) {
  const { t, tf, lien, locale } = i18n;
  if (lib.isEditor) return null;

  if (lib.premium) {
    const fin = sub?.current_period_end ? formatDateTime(sub.current_period_end, locale, true) : null;
    return (
      <section aria-labelledby="acces-titre" className="rounded-2xl border-2 border-[#2BB5A6] p-5">
        <h2 id="acces-titre" className="font-bold text-[#0E3A78]">
          {t.premiumTitre}
        </h2>
        <p className="mt-1 text-sm text-slate-600">
          {t.premiumTexte}
          {fin ? fmt(sub?.canceled_at ? t.premiumJusquau : t.premiumRenouvellement, { date: fin }) : "."}
        </p>
        <Link href={lien("/abonnement")} className="mt-3 inline-block text-sm font-semibold text-[#1A74A6] hover:underline">
          {t.gerer}
        </Link>
        {assistantOuvertAuxMembres() && (
          <div className="mt-4 border-t border-slate-200 pt-4">
            <h3 className="font-semibold text-[#0E3A78]">{t.assistantTitre}</h3>
            <p className="mt-1 text-sm text-slate-600">{t.assistantTexte}</p>
            <Link href={lien("/assistant")} className="mt-2 inline-block text-sm font-semibold text-[#1A74A6] hover:underline">
              {t.assistantLien}
            </Link>
          </div>
        )}
      </section>
    );
  }

  const used = Math.min(lib.unlocked.size, FREE_QUOTA);
  const remaining = FREE_QUOTA - used;
  return (
    <section aria-labelledby="acces-titre" className={card}>
      <h2 id="acces-titre" className="font-bold text-[#0E3A78]">
        {t.creditsTitre}
      </h2>
      <div className="mt-3 flex items-center gap-1.5" aria-hidden="true">
        {Array.from({ length: FREE_QUOTA }, (_, i) => (
          <span key={i} className={`h-2.5 flex-1 rounded-full ${i < used ? "bg-slate-200" : "bg-[#2BB5A6]"}`} />
        ))}
      </div>
      <p className="mt-2 text-sm text-slate-700">
        <b>{plur(locale, remaining, t.creditsRestants)}</b> {fmt(t.creditsSur, { quota: FREE_QUOTA })}
      </p>
      {unlockedDocs.length > 0 && (
        <>
          <h3 className="mt-4 text-xs font-semibold uppercase tracking-wide text-slate-500">{t.debloquees}</h3>
          <ul className="mt-1 space-y-1">
            {unlockedDocs.map((d) => (
              <li key={d.id}>
                <Link href={lien(`/bibliotheque/${d.id}`)} className="text-sm text-slate-800 hover:text-[#1A74A6] hover:underline">
                  {cardTitle(d)}
                </Link>
              </li>
            ))}
          </ul>
        </>
      )}
      {lib.catalogueOuvert ? (
        <p className="mt-4 rounded-lg bg-slate-50 p-3 text-xs leading-relaxed text-slate-600">
          {fmt(tf.catalogueOuvert, { quota: FREE_QUOTA })}
        </p>
      ) : (
        <Link href={lien("/abonnement")} className={`${primaryBtn} mt-4 w-full text-sm`}>
          {t.passerPremium}
        </Link>
      )}
    </section>
  );
}

function formatDateTime(iso: string, locale: string, year = false) {
  return new Date(iso).toLocaleDateString(locale, {
    day: "numeric",
    month: "long",
    ...(year ? { year: "numeric" } : {}),
    timeZone: "Europe/Paris",
  });
}

// « aujourd'hui », « hier », « il y a 3 j », puis la date (fuseau de Paris).
function viewedLabel(iso: string, { t, locale }: I18n) {
  const day = (d: Date) => d.toLocaleDateString("sv-SE", { timeZone: "Europe/Paris" });
  const diff = Math.round((Date.parse(day(new Date())) - Date.parse(day(new Date(iso)))) / 86_400_000);
  if (diff <= 0) return t.aujourdhui;
  if (diff === 1) return t.hier;
  if (diff < 7) return fmt(t.ilYa, { n: diff });
  return new Date(iso).toLocaleDateString(locale, { day: "numeric", month: "short", timeZone: "Europe/Paris" });
}
