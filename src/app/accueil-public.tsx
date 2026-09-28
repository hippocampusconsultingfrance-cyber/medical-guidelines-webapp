import Link from "next/link";

const PRINCIPES = [
  {
    titre: "Lisible en 30 secondes",
    texte:
      "Les recommandations sont présentées par thème, dans des tableaux clairs, chacune avec son grade tel qu'il figure dans la source.",
  },
  {
    titre: "Toujours relié à la source",
    texte:
      "Société savante, titre, date et lien vers le document officiel : la fiche ne remplace jamais le texte de référence.",
  },
  {
    titre: "Grades sans altération",
    texte:
      "Les grades et niveaux de preuve sont reproduits comme dans la source, ou signalés « non indiqué ». Aucun n'est inventé ni fusionné.",
  },
  {
    titre: "Transparence",
    texte:
      "Les divergences entre sociétés savantes sont affichées sans arbitrage ; toute erreur peut être signalée depuis la fiche.",
  },
];

const ETAPES = [
  ["1", "Créez un compte gratuit", "Nom, e-mail et profession ; confirmation de l'adresse par un lien envoyé par e-mail."],
  ["2", "Choisissez vos fiches", "Le compte gratuit donne accès à 5 fiches gratuites au choix, consultables à vie, sans carte bancaire."],
  ["3", "Consultez sur ordinateur ou mobile", "Consultation en ligne uniquement, adaptée aux écrans de téléphone."],
];

const FAQ = [
  [
    "Pour qui ?",
    "Pour les médecins, internes et étudiants, ainsi que pour les professionnels paramédicaux. La spécialité pilote est l'anesthésie-réanimation (sociétés savantes françaises : SFAR, SRLF, HAS et partenaires).",
  ],
  [
    "Ces fiches remplacent-elles les recommandations officielles ?",
    "Non. Ce sont des synthèses indépendantes, écrites comme aide-mémoire. Elles ne sont ni éditées ni validées par les sociétés savantes citées et ne remplacent ni le document source ni le jugement clinique.",
  ],
  [
    "Que contient l'offre payante ?",
    "L'abonnement PREMIUM (toutes les fiches de votre spécialité, 50 € TTC par an) n'est pas encore ouvert. Ce prix est une hypothèse commerciale, révisable, et sera confirmé avant l'ouverture des abonnements ; il inclut le tarif fondateurs (−30 % la première année pour les 100 premiers abonnés) et le tarif étudiant (−30 % sur justificatif), non cumulables.",
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

export default function AccueilPublic() {
  return (
    <div className="flex min-h-screen flex-col bg-white text-slate-800">
      <a
        href="#contenu"
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:rounded focus:bg-white focus:px-3 focus:py-2 focus:text-teal-800"
      >
        Aller au contenu
      </a>

      <header className="border-b border-slate-200">
        <div className="mx-auto flex max-w-5xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
          <span className="text-base font-semibold text-slate-900">
            Medical Guidelines
          </span>
          <nav aria-label="Compte" className="flex items-center gap-2 text-sm">
            <Link
              href="/connexion"
              className="rounded-md px-3 py-2 text-slate-700 hover:bg-slate-100"
            >
              Se connecter
            </Link>
            <Link
              href="/inscription"
              className="rounded-md bg-teal-700 px-3 py-2 font-medium text-white hover:bg-teal-800"
            >
              Créer un compte
            </Link>
          </nav>
        </div>
      </header>

      <main id="contenu" className="flex-1">
        <section className="bg-slate-50">
          <div className="mx-auto max-w-5xl px-4 py-14 sm:px-6 sm:py-20">
            <p className="text-sm font-medium uppercase tracking-wide text-teal-800">
              Anesthésie-réanimation
            </p>
            <h1 className="mt-3 max-w-3xl text-3xl font-semibold leading-tight text-slate-900 sm:text-5xl">
              Les recommandations professionnelles, en fiches claires et sourcées
            </h1>
            <p className="mt-5 max-w-2xl text-lg text-slate-700">
              Trouvez, comprenez et vérifiez une recommandation en quelques
              secondes, sans relire un document de 100 pages. Pour les
              médecins et les professionnels paramédicaux.
            </p>
            <div className="mt-8 flex flex-col gap-3 sm:flex-row">
              <Link
                href="/inscription"
                className="rounded-md bg-teal-700 px-6 py-3 text-center font-medium text-white hover:bg-teal-800"
              >
                Créer mon compte gratuit
              </Link>
              <Link
                href="/connexion"
                className="rounded-md border border-slate-300 bg-white px-6 py-3 text-center font-medium text-slate-800 hover:bg-slate-100"
              >
                J&apos;ai déjà un compte
              </Link>
            </div>
            <p className="mt-4 text-sm text-slate-600">
              5 fiches gratuites, sans carte bancaire.
            </p>
          </div>
        </section>

        <section aria-labelledby="principes" className="mx-auto max-w-5xl px-4 py-14 sm:px-6">
          <h2 id="principes" className="text-2xl font-semibold text-slate-900">
            Ce que vous trouvez dans chaque fiche
          </h2>
          <ul className="mt-8 grid gap-6 sm:grid-cols-2">
            {PRINCIPES.map((p) => (
              <li key={p.titre} className="rounded-lg border border-slate-200 p-5">
                <h3 className="font-semibold text-slate-900">{p.titre}</h3>
                <p className="mt-2 text-slate-700">{p.texte}</p>
              </li>
            ))}
          </ul>
        </section>

        <section aria-labelledby="etapes" className="bg-slate-50">
          <div className="mx-auto max-w-5xl px-4 py-14 sm:px-6">
            <h2 id="etapes" className="text-2xl font-semibold text-slate-900">
              Comment ça marche
            </h2>
            <ol className="mt-8 grid gap-6 sm:grid-cols-3">
              {ETAPES.map(([n, t, d]) => (
                <li key={n} className="rounded-lg bg-white p-5 shadow-sm ring-1 ring-slate-200">
                  <span
                    aria-hidden="true"
                    className="flex h-8 w-8 items-center justify-center rounded-full bg-teal-700 text-sm font-semibold text-white"
                  >
                    {n}
                  </span>
                  <h3 className="mt-3 font-semibold text-slate-900">{t}</h3>
                  <p className="mt-2 text-slate-700">{d}</p>
                </li>
              ))}
            </ol>
          </div>
        </section>

        <section aria-labelledby="offre" className="mx-auto max-w-5xl px-4 py-14 sm:px-6">
          <h2 id="offre" className="text-2xl font-semibold text-slate-900">
            Une offre simple
          </h2>
          <div className="mt-8 grid gap-6 sm:grid-cols-2">
            <div className="rounded-lg border border-slate-200 p-6">
              <h3 className="text-lg font-semibold text-slate-900">Gratuit</h3>
              <p className="mt-1 text-3xl font-semibold text-slate-900">0 €</p>
              <ul className="mt-4 space-y-2 text-slate-700">
                <li>5 fiches complètes gratuites, consultables à vie</li>
                <li>Aucune carte bancaire</li>
                <li>Consultation sur ordinateur et mobile</li>
              </ul>
              <Link
                href="/inscription"
                className="mt-6 inline-block rounded-md bg-teal-700 px-5 py-3 font-medium text-white hover:bg-teal-800"
              >
                Commencer gratuitement
              </Link>
            </div>
            <div className="rounded-lg border border-dashed border-slate-300 bg-slate-50 p-6">
              <h3 className="text-lg font-semibold text-slate-900">
                Premium{" "}
                <span className="ml-1 rounded bg-amber-100 px-2 py-0.5 text-xs font-medium text-amber-900">
                  Bientôt
                </span>
              </h3>
              <p className="mt-1 text-3xl font-semibold text-slate-900">
                50 € <span className="text-base font-normal text-slate-600">TTC / an</span>
              </p>
              <ul className="mt-4 space-y-2 text-slate-700">
                <li>Toutes les fiches de votre spécialité</li>
                <li>Paiement annuel, résiliable à tout moment</li>
                <li>
                  −30 % la première année pour les 100 premiers abonnés
                  (offre membres fondateurs, 35 €)
                </li>
                <li>
                  −30 % pour les internes et étudiants sur justificatif (non
                  cumulable)
                </li>
              </ul>
              <p className="mt-4 text-sm text-slate-600">
                Ouverture des abonnements à venir. Prix indicatif, révisable avant
                l&apos;ouverture ; créez votre compte gratuit pour être informé.
              </p>
            </div>
          </div>
        </section>

        <section aria-labelledby="faq" className="bg-slate-50">
          <div className="mx-auto max-w-3xl px-4 py-14 sm:px-6">
            <h2 id="faq" className="text-2xl font-semibold text-slate-900">
              Questions fréquentes
            </h2>
            <div className="mt-6 divide-y divide-slate-200 rounded-lg bg-white ring-1 ring-slate-200">
              {FAQ.map(([q, r]) => (
                <details key={q} className="group p-4">
                  <summary className="cursor-pointer font-medium text-slate-900">
                    {q}
                  </summary>
                  <p className="mt-2 text-slate-700">{r}</p>
                </details>
              ))}
            </div>
          </div>
        </section>
      </main>

      <footer className="border-t border-slate-200">
        <div className="mx-auto max-w-5xl px-4 py-8 text-sm text-slate-600 sm:px-6">
          <p>
            Aide à la pratique : ces fiches ne remplacent ni le jugement
            clinique ni le document source officiel, et ne sont ni éditées ni
            validées par les sociétés savantes citées.
          </p>
          <nav aria-label="Informations légales" className="mt-4 flex flex-wrap gap-x-5 gap-y-2">
            <Link href="/cgu" className="underline hover:text-slate-900">
              Conditions d&apos;utilisation
            </Link>
            <Link href="/confidentialite" className="underline hover:text-slate-900">
              Confidentialité
            </Link>
            <Link href="/mentions-legales" className="underline hover:text-slate-900">
              Mentions légales
            </Link>
            <a href="mailto:contact@medical-guidelines.net" className="underline hover:text-slate-900">
              contact@medical-guidelines.net
            </a>
          </nav>
          <p className="mt-4">© Hippocampus Consulting</p>
        </div>
      </footer>
    </div>
  );
}
