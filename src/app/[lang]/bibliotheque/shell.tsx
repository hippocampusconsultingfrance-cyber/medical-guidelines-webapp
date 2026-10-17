import Link from "next/link";
import { rubrique } from "@/i18n/rubriques";
import { textes } from "@/i18n/serveur";
import { nomSpecialite } from "@/i18n/specialites";
import type { TocItem } from "@/lib/fiches";
import { LogoMark } from "../logo";
import { cardTitle, docState, groupBySection, type Library } from "./data";
import BoutonIdee from "./bouton-idee";
import MenuToggle from "./menu-toggle";
import { BIBLIOTHEQUE } from "./textes";

// Cadre commun de la bibliothèque : barre latérale (logo, spécialité
// consultée, fiches rangées par rubrique, sommaire de la fiche ouverte) et
// zone de lecture. Liens de l'équipe (tableau de bord…) : pages en français.
export default async function Shell({
  lib,
  activeId,
  toc,
  children,
}: {
  lib: Library;
  activeId?: string;
  toc?: TocItem[];
  children: React.ReactNode;
}) {
  const { t: tout, langue, lien } = await textes(BIBLIOTHEQUE);
  const t = tout.shell;
  const groups = groupBySection(lib.docs);
  const activeSection = lib.docs.find((d) => d.id === activeId)?.card_json?.section ?? null;
  const byId = new Map(lib.docs.map((d) => [d.id, d]));
  const favorites = lib.favorites.flatMap((id) => byId.get(id) ?? []);

  return (
    <div className="mg-app">
      <MenuToggle />
      <aside className="sidebar" id="sidebar">
        <Link href={lien("/")} className="sidebar__brand sidebar__brand--logo" aria-label={t.accueilAria}>
          <span className="sidebar__logo">
            <LogoMark className="sidebar__logo-mark" />
          </span>
          <span>
            <span className="sidebar__mark">
              medical-guidelines<span className="sidebar__tld">.net</span>
            </span>
            {lib.specialty && (
              <span className="sidebar__specialty">
                {lib.specialtySlug ? nomSpecialite(lib.specialtySlug, lib.specialty, langue) : lib.specialty}
              </span>
            )}
          </span>
        </Link>

        {toc && toc.length > 0 && (
          <div className="toc">
            <div className="nav-group__label">{t.sommaire}</div>
            {toc.map((item) => (
              <a key={item.id} href={`#${item.id}`} className="toc__item">
                {item.text}
              </a>
            ))}
          </div>
        )}

        <nav className="nav-group" aria-label={t.fichesAria}>
          <Link href={lien("/bibliotheque")} className={`nav-link${activeId ? "" : " is-active"}`}>
            <span className="nav-link__dot" />
            {t.toutes}
            <span className="count-badge" style={{ background: "var(--accent)" }}>
              {lib.docs.length}
            </span>
          </Link>
          {favorites.length > 0 && (
            <details className="nav-section" open={!activeId || favorites.some((d) => d.id === activeId)}>
              <summary className="nav-section__title">
                {t.favoris}
                <span className="nav-section__count">{favorites.length}</span>
              </summary>
              {favorites.map((d) => (
                <Link
                  key={d.id}
                  href={lien(`/bibliotheque/${d.id}`)}
                  className={`nav-link nav-link--sub${d.id === activeId ? " is-active" : ""}`}
                >
                  {cardTitle(d)}
                </Link>
              ))}
            </details>
          )}
          {groups.map(([section, docs]) => (
            <details key={section} className="nav-section" open={section === activeSection}>
              <summary className="nav-section__title">
                {rubrique(section, langue).nom}
                <span className="nav-section__count">{docs.length}</span>
              </summary>
              {docs.map((d) => {
                const state = docState(lib, d.id);
                return (
                  <Link
                    key={d.id}
                    href={lien(`/bibliotheque/${d.id}`)}
                    className={`nav-link nav-link--sub${d.id === activeId ? " is-active" : ""}`}
                  >
                    {cardTitle(d)}
                    {state === "lock" && (
                      <span className="nav-link__lock" aria-label={t.ficheBloquee}>
                        🔒
                      </span>
                    )}
                  </Link>
                );
              })}
            </details>
          ))}
        </nav>

        <div className="sidebar__footer">
          <Link href={lien("/")} style={{ color: "inherit" }}>
            {t.accueil}
          </Link>
          {" · "}
          <Link href={lien("/compte")} style={{ color: "inherit" }}>
            {t.monCompte}
          </Link>
          {(lib.isEditor || lib.premium) && (
            <>
              {" · "}
              <Link href={lien("/assistant")} style={{ color: "inherit" }}>
                {t.assistant}
              </Link>
            </>
          )}
          {lib.isAdmin && (
            <>
              {" · "}
              <Link href="/bibliotheque/admin" style={{ color: "inherit", fontWeight: 700 }}>
                Tableau de bord
              </Link>
            </>
          )}
          {lib.isEditor && (
            <>
              {" · "}
              <Link href="/bibliotheque/traductions" style={{ color: "inherit" }}>
                Traductions
              </Link>
            </>
          )}
          {lib.canPublish && (
            <>
              {" · "}
              <Link href="/bibliotheque/signalements" style={{ color: "inherit" }}>
                Signalements
              </Link>
              {" · "}
              <Link href="/bibliotheque/statistiques" style={{ color: "inherit" }}>
                Statistiques
              </Link>
              {" · "}
              <Link href="/bibliotheque/veille" style={{ color: "inherit" }}>
                Lettre de veille
              </Link>
              {" · "}
              <Link href="/bibliotheque/divergences" style={{ color: "inherit" }}>
                Divergences
              </Link>
              {" · "}
              <Link href="/bibliotheque/actualisations" style={{ color: "inherit" }}>
                Actualisations
              </Link>
              {" · "}
              <Link href="/bibliotheque/juridique" style={{ color: "inherit" }}>
                Registre juridique
              </Link>
              {" · "}
              <Link href="/bibliotheque/reformulations" style={{ color: "inherit" }}>
                Reformulations
              </Link>
              {" · "}
              <Link href="/bibliotheque/points-cles" style={{ color: "inherit" }}>
                Points clés
              </Link>
              {" · "}
              <Link href="/bibliotheque/relecture" style={{ color: "inherit" }}>
                Relecture
              </Link>
              {lib.isAdmin && (
                <>
                  {" · "}
                  <Link href="/bibliotheque/suggestions" style={{ color: "inherit" }}>
                    Suggestions des membres
                  </Link>
                  {" · "}
                  <Link href="/bibliotheque/relecteurs" style={{ color: "inherit" }}>
                    Médecins relecteurs
                  </Link>
                </>
              )}
              {lib.isAdmin && (
                <>
                  {" · "}
                  <Link href="/bibliotheque/membres" style={{ color: "inherit" }}>
                    Membres inscrits
                  </Link>
                  {" · "}
                  <Link href="/bibliotheque/etudiants" style={{ color: "inherit" }}>
                    Professionnels en formation
                  </Link>
                  {" · "}
                  <Link href="/bibliotheque/acces" style={{ color: "inherit" }}>
                    Accès anormaux
                  </Link>
                  {" · "}
                  <Link href="/bibliotheque/demandes-accord" style={{ color: "inherit" }}>
                    Demandes d&apos;accord
                  </Link>
                </>
              )}
            </>
          )}
          <br />
          {t.avertissement}
        </div>
      </aside>
      <main>
        <div className="content-wrap">{children}</div>
      </main>
      <BoutonIdee libelle={t.idee} />
    </div>
  );
}
