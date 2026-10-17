import type { LangueOuverte } from "@/lib/langues";
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

// Traductions d'information de la mention ci-dessus (le français fait foi).
const TRADUCTIONS: Record<Exclude<LangueOuverte, "fr">, { texte: string; tel: string; site: string; email: string }> = {
  en: {
    texte:
      "In accordance with the provisions of the French Consumer Code concerning “the consumer dispute mediation process”, after contacting us at contact@medical-guidelines.net and failing a satisfactory reply, you may use a consumer mediation procedure free of charge with:",
    tel: "Phone: ",
    site: "Website: ",
    email: "Email: ",
  },
  es: {
    texte:
      "De conformidad con las disposiciones del Código de Consumo francés relativas al «proceso de mediación de los litigios de consumo», tras habernos escrito a contact@medical-guidelines.net y a falta de una respuesta satisfactoria, puede recurrir gratuitamente a un procedimiento de mediación de consumo ante:",
    tel: "Tel.: ",
    site: "Sitio web: ",
    email: "Correo electrónico: ",
  },
  de: {
    texte:
      "Gemäß den Bestimmungen des französischen Verbrauchergesetzbuchs über „das Verfahren der Verbraucherstreitschlichtung“ können Sie, nachdem Sie sich unter contact@medical-guidelines.net an uns gewandt haben und keine zufriedenstellende Antwort erhalten haben, kostenlos ein Verbraucherschlichtungsverfahren in Anspruch nehmen bei:",
    tel: "Tel.: ",
    site: "Website: ",
    email: "E-Mail: ",
  },
  ar: {
    texte:
      "وفقًا لأحكام قانون الاستهلاك الفرنسي المتعلقة بـ«إجراءات الوساطة في نزاعات الاستهلاك»، وبعد التواصل معنا على العنوان contact@medical-guidelines.net وفي حال عدم تلقي رد مُرضٍ، يمكنك اللجوء مجانًا إلى إجراء وساطة استهلاكية لدى:",
    tel: "الهاتف: ",
    site: "الموقع الإلكتروني: ",
    email: "البريد الإلكتروني: ",
  },
  zh: {
    texte:
      "根据《法国消费法典》关于“消费纠纷调解程序”的规定，在通过 contact@medical-guidelines.net 与我们联系但未获得满意答复后，您可以免费向以下机构申请消费调解：",
    tel: "电话：",
    site: "网站：",
    email: "电子邮箱：",
  },
};

export function MediationTraduite({ langue }: { langue: Exclude<LangueOuverte, "fr"> }) {
  const t = TRADUCTIONS[langue];
  return (
    <>
      <p className="mt-2">{t.texte}</p>
      <p className="mt-2 rounded-md border border-slate-200 p-3">
        <b>{MEDIATEUR.nom}</b>
        <br />
        {MEDIATEUR.adresse}
        <br />
        {t.tel}
        <span dir="ltr">{MEDIATEUR.telephone}</span>
        <br />
        {t.site}
        <a href={MEDIATEUR.site} className="underline" target="_blank" rel="noopener noreferrer">
          {MEDIATEUR.site}
        </a>
        <br />
        {t.email}
        {MEDIATEUR.email}
      </p>
    </>
  );
}
