import { MediationEn } from "../mediation";

// Traduction d'information des mentions légales (contenu-fr.tsx fait seul foi).
export default function MentionsLegalesEn() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Legal notice</h1>

      <h2 className={h2}>Publisher</h2>
      <p className="mt-2">
        The site medical-guidelines.net is published by Hippocampus Consulting, a French limited liability company
        (SARL) with a share capital of €1,000.
      </p>
      <ul className="mt-2 list-disc ps-5">
        <li>Registered office: 6 rue d&apos;Armaillé, 75017 Paris, France</li>
        <li>RCS Paris 999 259 252 (SIREN 999 259 252)</li>
        <li>Intra-EU VAT number: FR43 999 259 252</li>
        <li>
          Phone:{" "}
          <a href="tel:+33972152413" className="underline">
            +33 9 72 15 24 13
          </a>
        </li>
        <li>
          Contact:{" "}
          <a href="mailto:contact@medical-guidelines.net" className="underline">
            contact@medical-guidelines.net
          </a>
        </li>
      </ul>

      <h2 className={h2}>Publication director</h2>
      <p className="mt-2">Dr Ahmed Ben Lallahom.</p>

      <h2 className={h2}>Host</h2>
      <p className="mt-2">
        Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723, United States; phone: +1 (951) 383-6898; vercel.com.
      </p>
      <p className="mt-2">
        The database is hosted by Supabase in the European Union (Frankfurt, Germany). Details of the providers are
        given in the{" "}
        <a href="/en/confidentialite" className="underline">
          privacy policy
        </a>
        .
      </p>

      <h2 className={h2}>Consumer mediation</h2>
      <MediationEn />

      <h2 className={h2}>Intellectual property</h2>
      <p className="mt-2">
        The published summaries are independent summaries, written by the publisher from the guidelines of the medical
        societies, whose official source is always given. They do not commit those societies, none of whose logos or
        protected elements is reproduced. The guidelines remain the work and property of their authors and of the
        societies or institutions that publish them; they remain freely available on their websites, to which each
        summary links. The site neither sells nor distributes the original documents. Any reproduction or extraction of
        the site&apos;s content, even partial, is prohibited without the publisher&apos;s written permission.
      </p>
      <p className="mt-2">
        <b>Request from a rights holder.</b> Any author, medical society or publisher may request the correction,
        attribution, modification or removal of content at{" "}
        <a href="mailto:contact@medical-guidelines.net" className="underline">
          contact@medical-guidelines.net
        </a>
        , stating their identity and capacity, the document concerned, the summary on the site and the subject of the
        request. The request is handled as a priority: the summary concerned is taken down from the site, on simple
        request, while it is examined, and a reasoned reply is sent within 7 days. Requests and their outcome are kept.
      </p>

      <h2 className={h2}>Nature of the content</h2>
      <p className="mt-2">
        The site is intended for health professionals and students in health programmes. It replaces neither reading
        the full text of the guidelines nor clinical judgement. The terms of use are set out in the{" "}
        <a href="/en/cgu" className="underline">
          terms of use
        </a>
        .
      </p>
    </div>
  );
}
