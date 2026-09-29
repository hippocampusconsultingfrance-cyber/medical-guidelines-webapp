import { MEDIATEUR } from "@/lib/legal";

// Mention obligatoire du médiateur de la consommation, dans les termes
// fournis par le médiateur (CGV et mentions légales).
export default function Mediation() {
  return (
    <>
      <p className="mt-2">
        Conformément aux dispositions du Code de la consommation concernant « le processus de
        médiation des litiges de la consommation », après nous avoir sollicités à
        l&apos;adresse contact@medical-guidelines.net et à défaut de réponse vous satisfaisant,
        vous avez la possibilité de recourir gratuitement à une procédure de médiation de la
        consommation auprès de :
      </p>
      <p className="mt-2 rounded-md border border-slate-200 p-3">
        <b>{MEDIATEUR.nom}</b>
        <br />
        {MEDIATEUR.adresse}
        <br />
        Tél. : {MEDIATEUR.telephone}
        <br />
        Site internet :{" "}
        <a href={MEDIATEUR.site} className="underline" target="_blank" rel="noopener noreferrer">
          {MEDIATEUR.site}
        </a>
        <br />
        E-mail : {MEDIATEUR.email}
      </p>
    </>
  );
}
