import Link from "next/link";
import type { SupabaseClient, User } from "@supabase/supabase-js";
import { formatDate, FREE_QUOTA } from "@/lib/fiches";
import {
  cardTitle,
  docState,
  FRESHNESS_LABEL,
  loadLibrary,
  societyCounts,
  type Library,
  type LibraryDoc,
} from "./bibliotheque/data";
import { followSociety, unfollowSociety } from "./actions";
import LogoutButton from "./logout-button";
import Logo from "./logo";

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

const STATE_LABEL = { lock: "🔒 Bloquée", open: "Débloquée", draft: "Brouillon" };
const STATE_CLASS = {
  lock: "bg-slate-100 text-slate-600",
  open: "bg-emerald-50 text-emerald-800",
  draft: "bg-amber-50 text-amber-800",
};

const MESSAGES: Record<string, string> = {
  suivi: "Société suivie : vous recevrez un e-mail à chaque nouvelle recommandation qu'elle publie dans votre spécialité.",
  suivi_retire: "Vous ne suivez plus cette société.",
  suivi_erreur: "Le suivi n'a pas pu être enregistré. Réessayez dans un instant.",
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

  const year = new Intl.DateTimeFormat("fr-FR", { year: "numeric", timeZone: "Europe/Paris" }).format(new Date());
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
  const newsHref = (s: string) => (s ? `/?societe=${encodeURIComponent(s)}` : "/");
  const libraryYearHref = `/bibliotheque?annee=${year}${societe ? `&societe=${encodeURIComponent(societe)}` : ""}`;
  const message = MESSAGES[r];

  return (
    <div className="mx-auto min-h-screen max-w-6xl px-4 py-8 sm:px-6 sm:py-10">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <Logo />
        <nav className="flex items-center gap-4" aria-label="Compte">
          <Link href="/bibliotheque" className="text-sm font-medium text-slate-700 hover:text-slate-900">
            Bibliothèque
          </Link>
          <Link href="/compte" className="text-sm font-medium text-slate-700 hover:text-slate-900">
            Mon compte
          </Link>
          <LogoutButton />
        </nav>
      </header>

      <section className="mt-8 rounded-2xl bg-gradient-to-br from-[#0E3A78] to-[#1C5FA8] px-5 py-7 text-white sm:px-8">
        <h1 className="text-2xl font-bold sm:text-3xl">
          Bienvenue{profile?.prenom ? `, ${profile.prenom}` : ""}
        </h1>
        <p className="mt-1 text-sm text-sky-100 sm:text-base">
          {[profile?.profession, lib.specialty && lib.specialty !== profile?.profession ? `spécialité consultée : ${lib.specialty}` : null]
            .filter(Boolean)
            .join(" · ")}
        </p>
        <form action="/bibliotheque" role="search" className="mt-6 flex max-w-2xl flex-col gap-2 sm:flex-row">
          <label className="flex flex-1 items-center gap-2 rounded-lg bg-white px-3 text-slate-800 focus-within:ring-2 focus-within:ring-[#3AA8E0]">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="h-5 w-5 shrink-0 text-slate-400" aria-hidden="true">
              <circle cx="11" cy="11" r="7" />
              <path d="m20 20-3.5-3.5" />
            </svg>
            <span className="sr-only">Rechercher une fiche</span>
            <input
              name="q"
              type="search"
              maxLength={100}
              placeholder="Rechercher une recommandation (sepsis, AOD, intubation…)"
              className="w-full bg-transparent py-3 text-sm outline-none placeholder:text-slate-400 sm:text-base"
            />
          </label>
          <button className="rounded-lg bg-[#2BB5A6] px-5 py-3 font-semibold text-white hover:bg-[#23998C]">
            Rechercher
          </button>
        </form>
        <dl className="mt-6 grid grid-cols-3 gap-3 text-center sm:max-w-xl sm:text-left">
          <Stat value={lib.docs.length} label={lib.docs.length > 1 ? "fiches disponibles" : "fiche disponible"} />
          <Stat value={yearDocs.length} label={`nouveauté${yearDocs.length > 1 ? "s" : ""} ${year}`} />
          <Stat value={societies.length} label={societies.length > 1 ? "sociétés savantes" : "société savante"} />
        </dl>
      </section>

      {lib.isEditor && (
        <p className="mt-4 rounded-lg bg-amber-50 px-4 py-3 text-sm text-amber-900">
          Compte relecteur : la bibliothèque et cette page affichent aussi les brouillons, avec le
          bouton de publication.
        </p>
      )}

      <div className="mt-8 grid gap-8 lg:grid-cols-[minmax(0,1fr)_320px]">
        <div className="space-y-10">
          {updates && updates.length > 0 && (
            <UpdatesBlock updates={updates as DocumentUpdate[]} byId={byId} />
          )}

          <section id="nouveautes" aria-labelledby="nouveautes-titre" className="scroll-mt-6">
            <div className="flex flex-wrap items-end justify-between gap-2">
              <div>
                <h2 id="nouveautes-titre" className="text-xl font-bold text-[#0E3A78]">
                  {yearDocs.length ? `Nouveautés ${year}` : "Dernières recommandations"}
                </h2>
                <p className="mt-1 text-sm text-slate-600">
                  {yearDocs.length
                    ? `Recommandations publiées en ${year} par les sociétés savantes de votre spécialité.`
                    : `Aucune recommandation publiée en ${year} pour votre spécialité à ce jour : voici les plus récentes.`}
                </p>
              </div>
              <Link href="/bibliotheque" className="text-sm font-semibold text-[#1C7FB6] hover:underline">
                Toute la bibliothèque →
              </Link>
            </div>

            {yearSocieties.length > 1 && (
              <nav className="mt-4 flex flex-wrap items-start gap-2" aria-label={`Filtrer les nouveautés ${year} par société savante`}>
                <SocietyChip href={newsHref("")} active={!societe} label="Toutes" count={yearDocs.length} />
                {yearSocieties.slice(0, CHIP_LIMIT).map(([s, n]) => (
                  <SocietyChip key={s} href={newsHref(s)} active={societe === s} label={s} title={lib.societyNames[s]} count={n} />
                ))}
                {yearSocieties.length > CHIP_LIMIT && (
                  <details
                    className="group basis-full"
                    open={yearSocieties.slice(CHIP_LIMIT).some(([s]) => s === societe)}
                  >
                    <summary className="inline-block cursor-pointer list-none rounded-full border border-dashed border-slate-300 px-3 py-1 text-sm font-semibold text-slate-600 hover:border-[#1C7FB6] hover:text-[#1C7FB6] [&::-webkit-details-marker]:hidden">
                      <span className="group-open:hidden">+ {yearSocieties.length - CHIP_LIMIT} autres sociétés</span>
                      <span className="hidden group-open:inline">Moins de sociétés</span>
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
                Aucune fiche n&apos;est encore publiée pour votre spécialité. Elles apparaîtront ici au fil
                de leur validation par notre équipe médicale.
              </p>
            ) : (
              <ul className="mt-5 grid gap-3 sm:grid-cols-2">
                {(yearDocs.length ? news.slice(0, NEWS_LIMIT) : latest).map((d) => (
                  <li key={d.id}>
                    <DocCard doc={d} lib={lib} />
                  </li>
                ))}
              </ul>
            )}
            {news.length > NEWS_LIMIT && (
              <p className="mt-4 text-sm">
                <Link href={libraryYearHref} className="font-semibold text-[#1C7FB6] hover:underline">
                  Voir les {news.length} nouveautés {year}
                  {societe ? ` ${societe}` : ""} dans la bibliothèque →
                </Link>
              </p>
            )}
          </section>

          {popularDocs.length > 0 && (
            <section aria-labelledby="populaires-titre">
              <h2 id="populaires-titre" className="text-xl font-bold text-[#0E3A78]">
                Les plus consultées de votre spécialité
              </h2>
              <p className="mt-1 text-sm text-slate-600">
                {lib.premium || lib.isEditor
                  ? "Les fiches les plus lues par les membres ces trois derniers mois."
                  : "Les fiches les plus lues par les membres ces trois derniers mois : de quoi vous aider à choisir celles à débloquer avec vos crédits."}
              </p>
              <ol className="mt-4 divide-y divide-slate-100 rounded-xl border border-slate-200">
                {popularDocs.map((d, i) => {
                  const state = docState(lib, d.id);
                  return (
                    <li key={d.id}>
                      <Link href={`/bibliotheque/${d.id}`} className="group flex items-center gap-4 px-4 py-3">
                        <span className="w-6 shrink-0 text-lg font-bold text-[#2BB5A6]" aria-hidden="true">
                          {i + 1}
                        </span>
                        <span className="min-w-0 flex-1">
                          <span className="block font-semibold text-slate-900 group-hover:text-[#1C7FB6] group-hover:underline">
                            {cardTitle(d)}
                          </span>
                          <span className="block text-xs text-slate-500">
                            {[d.societies.join(" · "), formatDate(d.publication_date)].filter(Boolean).join(" — ")}
                          </span>
                        </span>
                        <span className={`shrink-0 rounded-full px-2 py-0.5 text-xs font-medium ${STATE_CLASS[state]}`}>
                          {STATE_LABEL[state]}
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
          <AccessCard lib={lib} unlockedDocs={unlockedDocs} sub={sub} />

          <section aria-labelledby="favoris-titre" className={card}>
            <h2 id="favoris-titre" className="font-bold text-[#0E3A78]">
              ★ Mes favoris
            </h2>
            {favorites.length ? (
              <ul className="mt-3 divide-y divide-slate-100">
                {favorites.slice(0, 8).map((d) => (
                  <li key={d.id}>
                    <Link href={`/bibliotheque/${d.id}`} className="group flex items-baseline justify-between gap-3 py-2">
                      <span className="text-sm font-medium text-slate-800 group-hover:text-[#1C7FB6] group-hover:underline">
                        {cardTitle(d)}
                      </span>
                      {docState(lib, d.id) === "lock" && (
                        <span className="shrink-0 text-xs" aria-label="Fiche bloquée">
                          🔒
                        </span>
                      )}
                    </Link>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="mt-2 text-sm text-slate-600">
                Ajoutez une fiche à vos favoris avec le bouton « ☆ Ajouter aux favoris » de sa page :
                elle apparaîtra ici et dans la bibliothèque.
              </p>
            )}
            {favorites.length > 8 && (
              <Link href="/bibliotheque" className="mt-2 inline-block text-xs font-semibold text-[#1C7FB6] hover:underline">
                Tous mes favoris dans la bibliothèque →
              </Link>
            )}
          </section>

          <section aria-labelledby="reprendre-titre" className={card}>
            <h2 id="reprendre-titre" className="font-bold text-[#0E3A78]">
              Reprendre la lecture
            </h2>
            {recent.length ? (
              <ul className="mt-3 divide-y divide-slate-100">
                {recent.map(({ doc, viewedAt }) => (
                  <li key={doc.id}>
                    <Link href={`/bibliotheque/${doc.id}`} className="group flex items-baseline justify-between gap-3 py-2">
                      <span className="text-sm font-medium text-slate-800 group-hover:text-[#1C7FB6] group-hover:underline">
                        {cardTitle(doc)}
                      </span>
                      <span className="shrink-0 text-xs text-slate-500">{viewedLabel(viewedAt)}</span>
                    </Link>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="mt-2 text-sm text-slate-600">
                Les fiches que vous ouvrez apparaîtront ici, pour y revenir en un clic.
              </p>
            )}
          </section>

          {societies.length > 0 && (
            <section id="alertes" aria-labelledby="societes-titre" className={`${card} scroll-mt-6`}>
              <h2 id="societes-titre" className="font-bold text-[#0E3A78]">
                Sociétés savantes de votre spécialité
              </h2>
              <p className="mt-1 text-xs text-slate-500">
                Nombre de fiches co-signées, dans la bibliothèque.
                {canFollow && followed.size > 0 ? " 🔔 : société suivie." : ""}
              </p>
              <div className="mt-3 flex flex-wrap gap-2">
                {societies.slice(0, 12).map(([s, n]) => (
                  <Link
                    key={s}
                    href={`/bibliotheque?societe=${encodeURIComponent(s)}`}
                    title={lib.societyNames[s]}
                    className="rounded-full border border-slate-200 px-3 py-1 text-xs font-semibold text-slate-700 hover:border-[#1C7FB6] hover:text-[#1C7FB6]"
                  >
                    {canFollow && followed.has(s) && <span aria-label="suivie">🔔 </span>}
                    {s} <span className="font-normal text-slate-500">{n}</span>
                  </Link>
                ))}
              </div>
              {societies.length > 12 && (
                <Link href="/bibliotheque" className="mt-3 inline-block text-xs font-semibold text-[#1C7FB6] hover:underline">
                  Et {societies.length - 12} autres dans la bibliothèque →
                </Link>
              )}

              <div className="mt-5 border-t border-slate-100 pt-4">
                <h3 className="text-sm font-bold text-slate-800">Alertes e-mail</h3>
                {message && (
                  <p role="status" className="mt-2 rounded-md bg-[#EEF6FB] px-3 py-2 text-xs font-medium text-[#0E3A78]">
                    {message}
                  </p>
                )}
                {canFollow ? (
                  <>
                    <p className="mt-1 text-xs text-slate-600">
                      Un e-mail par jour au plus, quand une société suivie publie une recommandation
                      dans votre spécialité ou qu&apos;une de vos fiches est mise à jour.
                    </p>
                    {emailAlerts === false && (
                      <p className="mt-2 text-xs font-medium text-amber-800">
                        Vos alertes e-mail sont désactivées :{" "}
                        <Link href="/compte#alertes" className="underline">
                          les réactiver dans Mon compte
                        </Link>
                        .
                      </p>
                    )}
                    {followed.size > 0 && (
                      <ul className="mt-3 flex flex-wrap gap-2" aria-label="Sociétés suivies">
                        {[...followed].sort().map((s) => (
                          <li key={s}>
                            <form action={unfollowSociety} className="inline-flex">
                              <input type="hidden" name="societe" value={s} />
                              <input type="hidden" name="retour" value="/" />
                              <button
                                title={`Ne plus suivre ${lib.societyNames[s] ?? s}`}
                                className="rounded-full bg-[#EEF6FB] px-3 py-1 text-xs font-semibold text-[#0E3A78] hover:bg-red-50 hover:text-red-700"
                              >
                                🔔 {s} <span aria-hidden="true">×</span>
                                <span className="sr-only">ne plus suivre</span>
                              </button>
                            </form>
                          </li>
                        ))}
                      </ul>
                    )}
                    {societies.some(([s]) => !followed.has(s)) && (
                      <form action={followSociety} className="mt-3 flex gap-2">
                        <input type="hidden" name="retour" value="/" />
                        <label className="sr-only" htmlFor="suivre-societe">
                          Société à suivre
                        </label>
                        <select
                          id="suivre-societe"
                          name="societe"
                          required
                          defaultValue=""
                          className="min-w-0 flex-1 rounded-md border border-slate-300 bg-white px-2 py-1.5 text-sm"
                        >
                          <option value="" disabled>
                            Suivre une société…
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
                          Suivre
                        </button>
                      </form>
                    )}
                  </>
                ) : (
                  <p className="mt-1 text-xs text-slate-600">
                    Suivez les sociétés de votre choix et recevez un e-mail à chaque nouvelle
                    recommandation, ainsi qu&apos;à chaque mise à jour de vos fiches : inclus dans{" "}
                    <Link href="/abonnement" className="font-semibold text-[#1C7FB6] underline">
                      l&apos;abonnement PREMIUM
                    </Link>
                    .
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
          : "border-slate-200 text-slate-700 hover:border-[#1C7FB6] hover:text-[#1C7FB6]"
      }`}
    >
      {label} <span className={active ? "font-normal text-sky-100" : "font-normal text-slate-500"}>{count}</span>
    </Link>
  );
}

function DocCard({ doc, lib }: { doc: LibraryDoc; lib: Library }) {
  const state = docState(lib, doc.id);
  const c = doc.card_json;
  return (
    <Link
      href={`/bibliotheque/${doc.id}`}
      className="flex h-full flex-col rounded-xl border border-slate-200 p-4 transition hover:border-[#1C7FB6] hover:shadow-sm"
    >
      <span className="flex items-center justify-between gap-2">
        <span className="text-xs font-semibold uppercase tracking-wide text-[#1C7FB6]">
          {doc.doc_type ?? "Recommandation"}
          {doc.publication_date ? ` · ${formatDate(doc.publication_date)}` : ""}
        </span>
        <span className="flex shrink-0 items-center gap-1.5">
          {lib.favorite.has(doc.id) && (
            <span className="text-sm text-amber-600" aria-label="Dans mes favoris">
              ★
            </span>
          )}
          <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${STATE_CLASS[state]}`}>
            {STATE_LABEL[state]}
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
function UpdatesBlock({ updates, byId }: { updates: DocumentUpdate[]; byId: Map<string, LibraryDoc> }) {
  return (
    <section aria-labelledby="maj-titre" className="rounded-2xl border border-amber-200 bg-amber-50 p-5">
      <h2 id="maj-titre" className="text-lg font-bold text-amber-900">
        Vos fiches ont été mises à jour
      </h2>
      <p className="mt-1 text-sm text-amber-900/80">
        Fiches que vous avez débloquées, mises en favori ou consultées.
      </p>
      <ul className="mt-3 space-y-2">
        {updates.map((u) => {
          const doc = byId.get(u.document_id);
          const replacement = u.superseded_by ? byId.get(u.superseded_by) : undefined;
          const detail =
            u.freshness_status === "retiree"
              ? "Recommandation retirée par la société savante : la fiche n'est plus consultable."
              : u.freshness_status === "remplacee"
                ? "Recommandation remplacée par un texte plus récent."
                : u.freshness_status === "revision_detectee"
                  ? "Nouvelle version de la source détectée : fiche en cours de révision."
                  : [
                      u.version_label && `Version ${u.version_label}`,
                      u.change_type && `modification ${u.change_type}`,
                      u.version_published_at && `publiée le ${formatDateTime(u.version_published_at)}`,
                    ]
                      .filter(Boolean)
                      .join(", ") + (u.diff_summary ? ` — ${u.diff_summary}` : "");
          return (
            <li key={u.document_id} className="rounded-lg bg-white px-4 py-3">
              <div className="flex flex-wrap items-baseline justify-between gap-2">
                {doc ? (
                  <Link href={`/bibliotheque/${doc.id}`} className="font-semibold text-slate-900 hover:text-[#1C7FB6] hover:underline">
                    {u.title}
                  </Link>
                ) : (
                  <span className="font-semibold text-slate-900">{u.title}</span>
                )}
                <span className="rounded-full bg-amber-100 px-2 py-0.5 text-xs font-semibold text-amber-900">
                  {FRESHNESS_LABEL[u.freshness_status] ?? "Mise à jour"}
                </span>
              </div>
              <p className="mt-1 text-sm text-slate-600">{detail}</p>
              {replacement && (
                <Link href={`/bibliotheque/${replacement.id}`} className="mt-1 inline-block text-sm font-semibold text-[#1C7FB6] hover:underline">
                  Nouvelle fiche : {cardTitle(replacement)} →
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
}: {
  lib: Library;
  unlockedDocs: LibraryDoc[];
  sub: { current_period_end: string | null; canceled_at: string | null } | null;
}) {
  if (lib.isEditor) return null;

  if (lib.premium) {
    const fin = sub?.current_period_end ? formatDateTime(sub.current_period_end, true) : null;
    return (
      <section aria-labelledby="acces-titre" className="rounded-2xl border-2 border-[#2BB5A6] p-5">
        <h2 id="acces-titre" className="font-bold text-[#0E3A78]">
          Abonnement PREMIUM actif
        </h2>
        <p className="mt-1 text-sm text-slate-600">
          Toutes les fiches de votre spécialité sont ouvertes
          {fin ? (sub?.canceled_at ? `, jusqu'au ${fin}.` : ` ; renouvellement le ${fin}.`) : "."}
        </p>
        <Link href="/abonnement" className="mt-3 inline-block text-sm font-semibold text-[#1C7FB6] hover:underline">
          Gérer mon abonnement →
        </Link>
      </section>
    );
  }

  const used = Math.min(lib.unlocked.size, FREE_QUOTA);
  const remaining = FREE_QUOTA - used;
  return (
    <section aria-labelledby="acces-titre" className={card}>
      <h2 id="acces-titre" className="font-bold text-[#0E3A78]">
        Mes crédits
      </h2>
      <div className="mt-3 flex items-center gap-1.5" aria-hidden="true">
        {Array.from({ length: FREE_QUOTA }, (_, i) => (
          <span key={i} className={`h-2.5 flex-1 rounded-full ${i < used ? "bg-slate-200" : "bg-[#2BB5A6]"}`} />
        ))}
      </div>
      <p className="mt-2 text-sm text-slate-700">
        <b>
          {remaining} crédit{remaining > 1 ? "s" : ""} restant{remaining > 1 ? "s" : ""}
        </b>{" "}
        sur {FREE_QUOTA}. Un crédit débloque une fiche, définitivement.
      </p>
      {unlockedDocs.length > 0 && (
        <>
          <h3 className="mt-4 text-xs font-semibold uppercase tracking-wide text-slate-500">Mes fiches débloquées</h3>
          <ul className="mt-1 space-y-1">
            {unlockedDocs.map((d) => (
              <li key={d.id}>
                <Link href={`/bibliotheque/${d.id}`} className="text-sm text-slate-800 hover:text-[#1C7FB6] hover:underline">
                  {cardTitle(d)}
                </Link>
              </li>
            ))}
          </ul>
        </>
      )}
      <Link href="/abonnement" className={`${primaryBtn} mt-4 w-full text-sm`}>
        Passer à PREMIUM · 50 € / an
      </Link>
    </section>
  );
}

function formatDateTime(iso: string, year = false) {
  return new Date(iso).toLocaleDateString("fr-FR", {
    day: "numeric",
    month: "long",
    ...(year ? { year: "numeric" } : {}),
    timeZone: "Europe/Paris",
  });
}

// « aujourd'hui », « hier », « il y a 3 j », puis la date (fuseau de Paris).
function viewedLabel(iso: string) {
  const day = (d: Date) => d.toLocaleDateString("sv-SE", { timeZone: "Europe/Paris" });
  const diff = Math.round((Date.parse(day(new Date())) - Date.parse(day(new Date(iso)))) / 86_400_000);
  if (diff <= 0) return "aujourd'hui";
  if (diff === 1) return "hier";
  if (diff < 7) return `il y a ${diff} j`;
  return new Date(iso).toLocaleDateString("fr-FR", { day: "numeric", month: "short", timeZone: "Europe/Paris" });
}
