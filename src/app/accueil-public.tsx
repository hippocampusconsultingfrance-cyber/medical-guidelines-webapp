import Link from "next/link";
import Logo from "./logo";

// Page d'accueil publique (visiteur non connecté). Couleurs du logo :
// bleu marine #0E3A78, turquoise #2BB5A6, bleu ciel #3AA8E0. Ne promettre
// que ce qui existe réellement sur le site.

const PRINCIPES = [
  {
    titre: "Clair et structuré",
    texte:
      "Les recommandations sont présentées par thème, dans des tableaux clairs, chacune avec son grade tel qu'il figure dans la source.",
    icone: "M4 6h16M4 12h16M4 18h10",
  },
  {
    titre: "Toujours relié à la source",
    texte:
      "Société savante, titre, date et lien vers le document officiel : la fiche ne remplace jamais le texte de référence.",
    icone: "M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1",
  },
  {
    titre: "Grades sans altération",
    texte:
      "Les grades et niveaux de preuve sont reproduits comme dans la source, ou signalés « non indiqué ». Aucun n'est inventé ni fusionné.",
    icone: "M9 12l2 2 4-4M12 3l7 3v6c0 4.5-3 8-7 9-4-1-7-4.5-7-9V6z",
  },
  {
    titre: "Transparence",
    texte:
      "Les divergences entre sociétés savantes sont affichées sans arbitrage ; toute erreur peut être signalée depuis la fiche.",
    icone: "M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12zM12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z",
  },
];

const ETAPES = [
  ["1", "Créez un compte gratuit", "Nom, e-mail, profession et spécialité à consulter ; confirmation de l'adresse par un lien envoyé par e-mail."],
  ["2", "Débloquez 5 fiches", "Choisissez 5 fiches complètes, consultables à vie, sans carte bancaire."],
  ["3", "Consultez partout", "Sur ordinateur, tablette ou téléphone, au moment où vous en avez besoin."],
];

const FAQ = [
  [
    "Pour qui ?",
    "Pour les médecins, internes et étudiants, ainsi que pour les professionnels paramédicaux. Les fiches couvrent déjà l'anesthésie-réanimation, la réanimation, la médecine d'urgence, la pédiatrie et d'autres spécialités, et s'étendent progressivement ; vous choisissez à l'inscription la spécialité que vous souhaitez consulter.",
  ],
  [
    "Ces fiches remplacent-elles les recommandations officielles ?",
    "Non. Ce sont des synthèses indépendantes, écrites comme aide-mémoire. Elles ne sont ni éditées ni validées par les sociétés savantes citées et ne remplacent ni le document source ni le jugement clinique.",
  ],
  [
    "Vendez-vous les recommandations des sociétés savantes ?",
    "Non. Les recommandations restent en accès libre sur les sites des sociétés savantes, et chaque fiche renvoie au texte officiel. L'abonnement ne sert pas à tirer profit des recommandations : il couvre ce que coûte le site, c'est-à-dire l'hébergement, les développeurs et les outils d'intelligence artificielle qui aident à préparer les fiches. Ce site a été construit grâce à des personnes volontaires.",
  ],
  [
    "Que contient l'offre payante ?",
    "L'abonnement PREMIUM ouvre toutes les fiches de votre spécialité, avec des alertes e-mail à chaque mise à jour, pour 50 € TTC par an, résiliable à tout moment. La première année : −30 % pour les 100 premiers abonnés (code FONDATEURS, soit 35 €) ou −30 % pour les professionnels de santé en formation sur justificatif ; ces réductions ne se cumulent pas.",
  ],
  [
    "Puis-je télécharger ou imprimer une fiche ?",
    "Non : la consultation se fait uniquement en ligne, sur ordinateur et sur mobile.",
  ],
  [
    "Y a-t-il des données de patients ?",
    "Non. Le site ne traite aucune donnée de santé de patient.",
  ],
];

const CHIPS: Record<string, string> = {
  "1+": "bg-emerald-50 text-emerald-800",
  "2+": "bg-sky-50 text-sky-800",
  AE: "bg-slate-100 text-slate-700",
};

// Extrait réel de la fiche « Anticoagulants & procédure invasive »
// (SFAR / GIHP, RFE 2026), à titre d'illustration.
const APERCU = [
  ["2.1", "AVK : poursuivre le traitement ; contrôler l'INR dans la semaine précédant la procédure (absence de surdosage).", "2+"],
  ["2.2", "AOD (apixaban, dabigatran, édoxaban, rivaroxaban) : sauter la prise de la veille au soir ET celle du matin de la procédure (quel que soit le schéma), reprise aux doses habituelles ≥ 6h après le geste.", "2+"],
];

const primaryBtn =
  "rounded-lg bg-[#0E3A78] px-6 py-3 text-center font-semibold text-white shadow-sm hover:bg-[#0B2F63] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#3AA8E0]";

export default function AccueilPublic() {
  return (
    <div className="flex min-h-screen flex-col bg-white text-slate-800">
      <a
        href="#contenu"
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:rounded focus:bg-white focus:px-3 focus:py-2 focus:text-[#0E3A78]"
      >
        Aller au contenu
      </a>

      <header className="sticky top-0 z-20 border-b border-slate-200 bg-white/90 backdrop-blur">
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
          <Link href="/" aria-label="medical-guidelines.net, accueil">
            <Logo />
          </Link>
          <nav aria-label="Compte" className="flex items-center gap-1 text-sm sm:gap-2">
            <Link
              href="/connexion"
              className="whitespace-nowrap rounded-lg px-2 py-2 font-medium text-slate-700 hover:bg-slate-100 sm:px-3"
            >
              Se connecter
            </Link>
            <Link
              href="/inscription"
              className="hidden rounded-lg bg-[#0E3A78] px-4 py-2 font-semibold text-white hover:bg-[#0B2F63] sm:inline-block"
            >
              Créer un compte
            </Link>
          </nav>
        </div>
      </header>

      <main id="contenu" className="flex-1">
        {/* Accroche */}
        <section className="relative overflow-hidden bg-gradient-to-b from-[#EEF6FB] to-white">
          <div className="mx-auto grid max-w-6xl items-center gap-12 px-4 py-14 sm:px-6 sm:py-20 lg:grid-cols-[1.1fr_1fr]">
            <div>
              <p className="inline-flex items-center gap-2 rounded-full bg-white px-3 py-1 text-xs font-semibold uppercase tracking-wide text-[#0E3A78] ring-1 ring-[#3AA8E0]/30">
                <span className="h-1.5 w-1.5 rounded-full bg-[#2BB5A6]" aria-hidden="true" />
                Médecins et paramédicaux
              </p>
              <h1 className="mt-5 text-3xl font-bold leading-tight tracking-tight text-[#0E3A78] sm:text-5xl">
                Les recommandations professionnelles, en fiches claires et sourcées
              </h1>
              <p className="mt-5 max-w-xl text-lg text-slate-600">
                Trouvez, comprenez et vérifiez une recommandation en quelques
                instants, sans relire un document de 100 pages. Grades
                conservés, source officielle toujours à portée de clic.
              </p>
              <div className="mt-8 flex flex-col gap-3 sm:flex-row">
                <Link href="/inscription" className={primaryBtn}>
                  Créer mon compte gratuit
                </Link>
                <Link
                  href="/connexion"
                  className="rounded-lg border border-slate-300 bg-white px-6 py-3 text-center font-semibold text-slate-800 hover:bg-slate-50"
                >
                  J&apos;ai déjà un compte
                </Link>
              </div>
              <form action="/recommandations" role="search" className="mt-6 flex max-w-xl gap-2">
                <label htmlFor="q-accueil" className="sr-only">
                  Rechercher une recommandation
                </label>
                <input
                  id="q-accueil"
                  name="q"
                  type="search"
                  placeholder="Ex. : sepsis, ALR…"
                  className="min-w-0 flex-1 rounded-lg border border-slate-300 bg-white px-4 py-3 text-base text-slate-900 shadow-sm placeholder:text-slate-400 focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
                />
                <button className="shrink-0 rounded-lg border border-[#0E3A78] bg-white px-4 py-3 font-semibold text-[#0E3A78] hover:bg-[#EEF6FB]">
                  Chercher
                </button>
              </form>
              <p className="mt-3 text-sm">
                <Link href="/recommandations" className="font-semibold text-[#1A74A6] underline">
                  Voir la liste des recommandations disponibles →
                </Link>
              </p>
              <ul className="mt-6 flex flex-wrap gap-x-5 gap-y-2 text-sm text-slate-600">
                {["5 fiches gratuites", "Sans carte bancaire", "Ordinateur et mobile"].map((t) => (
                  <li key={t} className="flex items-center gap-1.5">
                    <svg viewBox="0 0 20 20" className="h-4 w-4 text-[#177E73]" fill="currentColor" aria-hidden="true">
                      <path d="M16.7 5.3a1 1 0 0 1 0 1.4l-8 8a1 1 0 0 1-1.4 0l-4-4a1 1 0 1 1 1.4-1.4L8 12.6l7.3-7.3a1 1 0 0 1 1.4 0z" />
                    </svg>
                    {t}
                  </li>
                ))}
              </ul>
            </div>

            {/* Aperçu d'une fiche */}
            <figure className="relative">
              <div className="absolute -inset-3 -z-10 rounded-3xl bg-gradient-to-br from-[#2BB5A6]/20 to-[#3AA8E0]/20 blur-2xl" aria-hidden="true" />
              <div className="overflow-hidden rounded-2xl bg-white shadow-xl ring-1 ring-slate-200">
                <div className="border-b border-slate-100 px-5 py-4">
                  <p className="font-mono text-[0.68rem] font-semibold uppercase tracking-wider text-[#177E73]">
                    SFAR / GIHP — RFE 2026
                  </p>
                  <p className="mt-1 text-lg font-bold text-[#0E3A78]">Anticoagulants &amp; procédure invasive</p>
                  <p className="mt-1 text-xs text-slate-500">
                    <b className="text-slate-700">Méthodologie</b> GRADE · <b className="text-slate-700">Version</b> 20 avril 2026
                  </p>
                </div>
                <div className="px-5 py-4">
                  <p className="text-sm font-semibold text-slate-900">Procédure à risque hémorragique faible — pas d&apos;arrêt</p>
                  <table className="mt-3 w-full text-left text-[0.8rem]">
                    <thead>
                      <tr className="bg-[#0E3A78] text-white">
                        <th className="rounded-l-md px-2 py-1.5 font-semibold">Réf.</th>
                        <th className="px-2 py-1.5 font-semibold">Recommandation</th>
                        <th className="rounded-r-md px-2 py-1.5 font-semibold">Grade</th>
                      </tr>
                    </thead>
                    <tbody>
                      {APERCU.map(([ref, texte, grade]) => (
                        <tr key={ref} className="border-b border-slate-100 align-top last:border-0">
                          <td className="px-2 py-2 font-mono font-semibold text-slate-600">{ref}</td>
                          <td className="px-2 py-2 text-slate-700">{texte}</td>
                          <td className="px-2 py-2">
                            <span className={`rounded-full px-2 py-0.5 font-mono text-xs font-semibold ${CHIPS[grade]}`}>{grade}</span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  <p className="mt-3 text-xs font-medium text-[#1A74A6]">Document source officiel ↗</p>
                </div>
              </div>
              <figcaption className="mt-3 text-center text-xs text-slate-500">
                Extrait d&apos;une fiche : chaque recommandation garde son grade et sa source.
              </figcaption>
            </figure>
          </div>
        </section>

        {/* Sources */}
        <section aria-label="Sources" className="border-y border-slate-100 bg-white">
          <div className="mx-auto flex max-w-6xl flex-col items-center gap-3 px-4 py-6 text-center sm:flex-row sm:justify-center sm:gap-6 sm:px-6">
            <p className="text-sm text-slate-500">Synthèses des recommandations publiées par</p>
            <p className="flex flex-wrap justify-center gap-x-5 gap-y-1 text-sm font-bold tracking-wide text-[#0E3A78]">
              <span>SFAR</span>
              <span>SRLF</span>
              <span>HAS</span>
              <span className="font-medium text-slate-500">et sociétés partenaires</span>
            </p>
          </div>
        </section>

        {/* Principes */}
        <section aria-labelledby="principes" className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
          <h2 id="principes" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
            Ce que vous trouvez dans chaque fiche
          </h2>
          <ul className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            {PRINCIPES.map((p) => (
              <li key={p.titre} className="rounded-2xl border border-slate-200 p-6 transition hover:shadow-md">
                <span className="flex h-11 w-11 items-center justify-center rounded-xl bg-gradient-to-br from-[#2BB5A6] to-[#3AA8E0] text-white">
                  <svg viewBox="0 0 24 24" className="h-5 w-5" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                    <path d={p.icone} />
                  </svg>
                </span>
                <h3 className="mt-4 font-semibold text-slate-900">{p.titre}</h3>
                <p className="mt-2 text-sm leading-relaxed text-slate-600">{p.texte}</p>
              </li>
            ))}
          </ul>
        </section>

        {/* Étapes */}
        <section aria-labelledby="etapes" className="bg-[#F4F8FB]">
          <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
            <h2 id="etapes" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
              Comment ça marche
            </h2>
            <ol className="mt-10 grid gap-5 sm:grid-cols-3">
              {ETAPES.map(([n, t, d]) => (
                <li key={n} className="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
                  <span aria-hidden="true" className="flex h-9 w-9 items-center justify-center rounded-full bg-[#0E3A78] text-sm font-bold text-white">
                    {n}
                  </span>
                  <h3 className="mt-4 font-semibold text-slate-900">{t}</h3>
                  <p className="mt-2 text-sm leading-relaxed text-slate-600">{d}</p>
                </li>
              ))}
            </ol>
          </div>
        </section>

        {/* Offre */}
        <section aria-labelledby="offre" className="mx-auto max-w-5xl px-4 py-16 sm:px-6">
          <h2 id="offre" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
            Une offre simple
          </h2>
          <div className="mt-10 grid gap-6 md:grid-cols-2">
            <div className="flex flex-col rounded-2xl border-2 border-[#2BB5A6] p-7">
              <h3 className="text-lg font-semibold text-slate-900">Gratuit</h3>
              <p className="mt-2 text-4xl font-bold text-[#0E3A78]">0 €</p>
              <ul className="mt-5 space-y-2.5 text-sm text-slate-700">
                <li>✓ 5 fiches complètes au choix, consultables à vie</li>
                <li>✓ Aucune carte bancaire</li>
                <li>✓ Consultation sur ordinateur et mobile</li>
              </ul>
              <Link href="/inscription" className={`mt-7 ${primaryBtn}`}>
                Commencer gratuitement
              </Link>
            </div>
            <div className="flex flex-col rounded-2xl border border-slate-200 bg-slate-50 p-7">
              <h3 className="text-lg font-semibold text-slate-900">Premium</h3>
              <p className="mt-2 text-4xl font-bold text-[#0E3A78]">
                50 € <span className="text-base font-normal text-slate-500">TTC / an</span>
              </p>
              <ul className="mt-5 space-y-2.5 text-sm text-slate-700">
                <li>✓ Toutes les fiches de votre spécialité</li>
                <li>✓ Paiement annuel, résiliable à tout moment</li>
                <li>✓ −30 % la première année pour les 100 premiers abonnés (offre membres fondateurs, 35 €)</li>
                <li>✓ −30 % pour les internes et étudiants sur justificatif (non cumulable)</li>
              </ul>
              <Link href="/abonnement" className={`mt-7 ${primaryBtn}`}>
                S&apos;abonner
              </Link>
              <p className="mt-3 text-xs text-slate-500">
                Votre abonnement ne paie pas les recommandations, qui restent en accès libre sur les sites des
                sociétés savantes : il couvre l&apos;hébergement, les développeurs et les outils d&apos;IA du site.{" "}
                <Link href="/demarche" className="underline">
                  Notre démarche
                </Link>
              </p>
            </div>
          </div>
        </section>

        {/* FAQ */}
        <section aria-labelledby="faq" className="bg-[#F4F8FB]">
          <div className="mx-auto max-w-3xl px-4 py-16 sm:px-6">
            <h2 id="faq" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
              Questions fréquentes
            </h2>
            <div className="mt-8 divide-y divide-slate-200 rounded-2xl bg-white ring-1 ring-slate-200">
              {FAQ.map(([q, r]) => (
                <details key={q} className="group p-5">
                  <summary className="flex cursor-pointer list-none items-center justify-between gap-4 font-semibold text-slate-900">
                    {q}
                    <span className="text-[#3AA8E0] transition group-open:rotate-45" aria-hidden="true">+</span>
                  </summary>
                  <p className="mt-3 text-sm leading-relaxed text-slate-600">{r}</p>
                </details>
              ))}
            </div>
          </div>
        </section>

        {/* Appel final */}
        <section className="bg-[#0E3A78]">
          <div className="mx-auto flex max-w-6xl flex-col items-center gap-5 px-4 py-14 text-center sm:px-6">
            <h2 className="text-2xl font-bold text-white sm:text-3xl">Essayez avec 5 fiches gratuites</h2>
            <p className="max-w-xl text-[#CFE6F5]">
              Création du compte en une minute, sans carte bancaire.
            </p>
            <Link
              href="/inscription"
              className="rounded-lg bg-white px-7 py-3 font-semibold text-[#0E3A78] shadow-sm hover:bg-[#EEF6FB]"
            >
              Créer mon compte gratuit
            </Link>
          </div>
        </section>
      </main>

      {/* Pied de page commun (liens légaux) fourni par le layout racine. */}
      <section aria-label="À propos du site" className="border-t border-slate-200 bg-white">
        <div className="mx-auto flex max-w-6xl flex-col gap-4 px-4 py-8 text-sm text-slate-600 sm:px-6">
          <Logo tagline />
          <p className="max-w-3xl">
            Aide à la pratique : ces fiches ne remplacent ni le jugement
            clinique ni le document source officiel, et ne sont ni éditées ni
            validées par les sociétés savantes citées.
          </p>
          <p>
            <Link href="/demarche" className="underline hover:text-slate-900">
              Notre démarche
            </Link>{" "}
            ·{" "}
            <Link href="/corrections" className="underline hover:text-slate-900">
              Journal des corrections
            </Link>{" "}
            · Contact :{" "}
            <a href="mailto:contact@medical-guidelines.net" className="underline hover:text-slate-900">
              contact@medical-guidelines.net
            </a>{" "}
            · © Hippocampus Consulting
          </p>
        </div>
      </section>
    </div>
  );
}
