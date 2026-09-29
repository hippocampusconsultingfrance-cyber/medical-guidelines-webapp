import Link from "next/link";
import type { SupabaseClient, User } from "@supabase/supabase-js";
import { formatDate, FREE_QUOTA } from "@/lib/fiches";
import { cardTitle, docState, loadLibrary, societyCounts, type Library, type LibraryDoc } from "./bibliotheque/data";
import LogoutButton from "./logout-button";
import Logo from "./logo";

// Espace membre (page d'accueil d'un compte connecté) : nouveautés de l'année
// des sociétés savantes de la spécialité, lecture en cours, crédits ou
// abonnement, raccourcis vers la bibliothèque. Tout vient des données que la
// base laisse lire au compte : fiches de sa spécialité, ses propres
// déblocages et son historique.

type Profile = { prenom: string | null; profession: string | null };

const STATE_LABEL = { lock: "🔒 Bloquée", open: "Débloquée", draft: "Brouillon" };
const STATE_CLASS = {
  lock: "bg-slate-100 text-slate-600",
  open: "bg-emerald-50 text-emerald-800",
  draft: "bg-amber-50 text-amber-800",
};

// Nombre de nouveautés affichées avant le lien vers la bibliothèque.
const NEWS_LIMIT = 8;
// Sociétés du filtre des nouveautés visibles d'emblée, les autres repliées.
const CHIP_LIMIT = 6;
const RECENT_LIMIT = 5;

const primaryBtn =
  "inline-flex items-center justify-center rounded-lg bg-[#0E3A78] px-5 py-2.5 font-semibold text-white shadow-sm hover:bg-[#0B2F63] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#3AA8E0]";

export default async function EspaceMembre({
  supabase,
  user,
  profile,
  societe: societeParam,
}: {
  supabase: SupabaseClient;
  user: User;
  profile: Profile | null;
  societe: string;
}) {
  const [lib, { data: history }, { data: sub }] = await Promise.all([
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

  const societies = societyCounts(lib.docs);
  const unlockedDocs = lib.docs.filter((d) => lib.unlocked.has(d.id));
  const newsHref = (s: string) => (s ? `/?societe=${encodeURIComponent(s)}` : "/");
  const libraryYearHref = `/bibliotheque?annee=${year}${societe ? `&societe=${encodeURIComponent(societe)}` : ""}`;

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
                <SocietyChip key={s} href={newsHref(s)} active={societe === s} label={s} count={n} />
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
                      <SocietyChip key={s} href={newsHref(s)} active={societe === s} label={s} count={n} />
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

        <aside className="space-y-6">
          <AccessCard lib={lib} unlockedDocs={unlockedDocs} sub={sub} />

          <section aria-labelledby="reprendre-titre" className="rounded-2xl border border-slate-200 p-5">
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
            <section aria-labelledby="societes-titre" className="rounded-2xl border border-slate-200 p-5">
              <h2 id="societes-titre" className="font-bold text-[#0E3A78]">
                Sociétés savantes de votre spécialité
              </h2>
              <p className="mt-1 text-xs text-slate-500">Nombre de fiches co-signées, dans la bibliothèque.</p>
              <div className="mt-3 flex flex-wrap gap-2">
                {societies.slice(0, 12).map(([s, n]) => (
                  <Link
                    key={s}
                    href={`/bibliotheque?societe=${encodeURIComponent(s)}`}
                    className="rounded-full border border-slate-200 px-3 py-1 text-xs font-semibold text-slate-700 hover:border-[#1C7FB6] hover:text-[#1C7FB6]"
                  >
                    {s} <span className="font-normal text-slate-500">{n}</span>
                  </Link>
                ))}
              </div>
              {societies.length > 12 && (
                <Link href="/bibliotheque" className="mt-3 inline-block text-xs font-semibold text-[#1C7FB6] hover:underline">
                  Et {societies.length - 12} autres dans la bibliothèque →
                </Link>
              )}
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

function SocietyChip({ href, active, label, count }: { href: string; active: boolean; label: string; count: number }) {
  return (
    <Link
      href={href}
      scroll={false}
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
        <span className={`shrink-0 rounded-full px-2 py-0.5 text-xs font-medium ${STATE_CLASS[state]}`}>
          {STATE_LABEL[state]}
        </span>
      </span>
      <span className="mt-2 font-semibold leading-snug text-slate-900">{cardTitle(doc)}</span>
      {c?.short && <span className="mt-1 line-clamp-2 text-sm text-slate-600">{c.short}</span>}
      {doc.societies.length > 0 && (
        <span className="mt-auto flex flex-wrap gap-1 pt-3">
          {doc.societies.map((s) => (
            <span key={s} className="rounded bg-[#EEF6FB] px-1.5 py-0.5 text-xs font-semibold text-[#0E3A78]">
              {s}
            </span>
          ))}
        </span>
      )}
    </Link>
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
    const fin = sub?.current_period_end
      ? new Date(sub.current_period_end).toLocaleDateString("fr-FR", {
          day: "numeric",
          month: "long",
          year: "numeric",
          timeZone: "Europe/Paris",
        })
      : null;
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
    <section aria-labelledby="acces-titre" className="rounded-2xl border border-slate-200 p-5">
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

// « aujourd'hui », « hier », « il y a 3 j », puis la date (fuseau de Paris).
function viewedLabel(iso: string) {
  const day = (d: Date) => d.toLocaleDateString("sv-SE", { timeZone: "Europe/Paris" });
  const diff = Math.round((Date.parse(day(new Date())) - Date.parse(day(new Date(iso)))) / 86_400_000);
  if (diff <= 0) return "aujourd'hui";
  if (diff === 1) return "hier";
  if (diff < 7) return `il y a ${diff} j`;
  return new Date(iso).toLocaleDateString("fr-FR", { day: "numeric", month: "short", timeZone: "Europe/Paris" });
}
