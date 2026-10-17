import { Fragment, type ReactNode } from "react";

// Repères d'un texte traduit : fmt("{n} fiches", { n: 3 }) = "3 fiches".
export function fmt(texte: string, valeurs: Record<string, string | number>): string {
  return texte.replace(/\{(\w+)\}/g, (repere, cle: string) => (cle in valeurs ? String(valeurs[cle]) : repere));
}

// Texte traduit avec balises (liens, gras) : riche("Lire les <cgu>CGU</cgu>",
// { cgu: (c) => <a href="/cgu">{c}</a> }). Balises simples, sans imbrication ;
// une balise sans rendu fourni garde seulement son contenu.
export function riche(
  texte: string,
  balises: Record<string, (contenu: string) => ReactNode>,
  valeurs?: Record<string, string | number>,
): ReactNode {
  const source = valeurs ? fmt(texte, valeurs) : texte;
  const parties: ReactNode[] = [];
  const re = /<(\w+)>([\s\S]*?)<\/\1>/g;
  let debut = 0;
  let m: RegExpExecArray | null;
  while ((m = re.exec(source))) {
    if (m.index > debut) parties.push(source.slice(debut, m.index));
    const rendu = balises[m[1]];
    parties.push(<Fragment key={m.index}>{rendu ? rendu(m[2]) : m[2]}</Fragment>);
    debut = m.index + m[0].length;
  }
  if (debut < source.length) parties.push(source.slice(debut));
  return <>{parties}</>;
}

// Accord en nombre : plur("fr-FR", 3, { one: "{n} fiche", other: "{n} fiches" })
// = "3 fiches" (catégories Intl.PluralRules ; « other » obligatoire).
export type Pluriel = Partial<Record<Intl.LDMLPluralRule, string>> & { other: string };
export function plur(locale: string, n: number, formes: Pluriel, valeurs: Record<string, string | number> = {}): string {
  const forme = formes[new Intl.PluralRules(locale).select(n)] ?? formes.other;
  return fmt(forme, { n, ...valeurs });
}
