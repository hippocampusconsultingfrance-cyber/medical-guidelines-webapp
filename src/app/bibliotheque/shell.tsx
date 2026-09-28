import Link from "next/link";
import type { TocItem } from "@/lib/fiches";
import { cardTitle, docState, type Library } from "./data";
import MenuToggle from "./menu-toggle";

// Cadre commun de la bibliothèque, repris de l'ancienne page : barre
// latérale (fiches, sommaire de la fiche ouverte) et zone de lecture.
export default function Shell({
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
  return (
    <div className="mg-app">
      <MenuToggle />
      <aside className="sidebar" id="sidebar">
        <div className="sidebar__brand">
          <div className="sidebar__mark">Medical Guidelines</div>
          <div className="sidebar__sub">
            Synthèses fiables des recommandations cliniques, au service de la
            pratique quotidienne.
          </div>
        </div>
        <nav className="nav-group" aria-label="Fiches">
          <Link href="/bibliotheque" className={`nav-link${activeId ? "" : " is-active"}`}>
            <span className="nav-link__dot" />
            Toutes les fiches
            <span className="count-badge" style={{ background: "var(--accent)" }}>
              {lib.docs.length}
            </span>
          </Link>
          {lib.docs.map((d) => {
            const state = docState(lib, d.id);
            return (
              <Link
                key={d.id}
                href={`/bibliotheque/${d.id}`}
                className={`nav-link${d.id === activeId ? " is-active" : ""}`}
              >
                <span className="nav-link__dot" />
                {cardTitle(d)}
                {state === "lock" && (
                  <span className="nav-link__lock" aria-label="Fiche bloquée">
                    🔒
                  </span>
                )}
              </Link>
            );
          })}
        </nav>
        {toc && toc.length > 0 && (
          <div className="toc">
            {toc.map((t) => (
              <a key={t.id} href={`#${t.id}`} className="toc__item">
                {t.text}
              </a>
            ))}
          </div>
        )}
        <div className="sidebar__footer">
          <Link href="/" style={{ color: "inherit" }}>
            Accueil
          </Link>
          {" · "}
          <Link href="/compte" style={{ color: "inherit" }}>
            Mon compte
          </Link>
          {lib.canPublish && (
            <>
              {" · "}
              <Link href="/bibliotheque/signalements" style={{ color: "inherit" }}>
                Signalements
              </Link>
            </>
          )}
          <br />
          Synthèses indépendantes, non officielles. Se référer aux textes
          intégraux en cas de doute.
        </div>
      </aside>
      <main>
        <div className="content-wrap">{children}</div>
      </main>
    </div>
  );
}
