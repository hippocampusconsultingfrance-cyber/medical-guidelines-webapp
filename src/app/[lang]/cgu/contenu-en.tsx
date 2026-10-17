import { CGU_VERSION } from "@/lib/legal";
import { MediationEn } from "../mediation";

// Traduction d'information des CGU (contenu-fr.tsx fait seul foi).
export default function CguEn() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Terms of Use</h1>
      <p className="mt-2 text-slate-500">Version of {CGU_VERSION.split("-").reverse().join("/")}.</p>

      <h2 className={h2}>1. Purpose and access to the service</h2>
      <p className="mt-2">
        Medical Guidelines is a site of summaries of French professional guidelines in several specialties
        (anaesthesiology and critical care, critical care medicine, emergency medicine, paediatrics…). Access to the
        content is reserved for health professionals and students in medical and allied health programmes, subject to
        creating an account. The free account gives access to 5 full summaries in total, for life, without a credit
        card, chosen from the specialty stated at registration or, as long as the catalogue still covers that specialty
        poorly (fewer than 20 published summaries), from all published summaries. The PREMIUM subscription (every
        summary in the chosen specialty), offered for the specialties covered by the catalogue, costs €50 including VAT
        per year, payable annually in advance; it renews automatically on its anniversary date and can be cancelled at
        any time, access being maintained until the end of the paid year. The current year&apos;s price is guaranteed;
        any increase applies only on renewal, after notice at least 30 days in advance with a cancellation link. The
        subscription terms (discounts, right of withdrawal, invoicing) are set out in the terms of sale, which are
        separate from these terms and accepted at each subscription.
      </p>

      <h2 className={h2}>2. Nature of the service and content — no binding medical value</h2>
      <p className="mt-2">
        Medical Guidelines is a service that helps readers use professional guidelines: it lets them find them, read
        them as summaries written by the publisher and reviewed by its medical team (the review date appears on each
        summary), compare them and be alerted to their updates. The official guideline documents are neither sold nor
        distributed by the site: they remain the work and property of their authors, freely available on their
        websites, to which each summary links. The subscription pays for the service: writing and medical review of
        the summaries, search tools, alerts and hosting.
      </p>
      <p className="mt-2">
        The published summaries are independent summaries, produced as memory aids, from the documents published by
        the medical societies. They do not replace reading the full text of the official guidelines and do not engage
        the liability of the societies concerned. No logo, trademark or protected element of a medical society is
        reproduced on this site. In case of clinical doubt, the user must refer to the full text of the guideline or to
        specialist advice.
      </p>

      <h2 className={h2}>3. Intellectual property and permitted use</h2>
      <p className="mt-2">
        The guidelines cited (wording, grades, tables, figures) belong to their authors and publishers; the summaries
        cite them with their reference and the link to the official text. The summaries, their selection, their
        organisation, the database and the site&apos;s software belong to the publisher (articles L341-1 et seq. of
        the French Intellectual Property Code for the database).
      </p>
      <p className="mt-2">
        The account grants a personal right of access, for professional use. The following are prohibited: copying or
        systematically extracting the summaries, including by a robot or a program; reselling or distributing the
        content; circumventing the site&apos;s protection measures. If reading occurs at an abnormal rate, reading is
        automatically suspended for a limited time and an administrator is notified (see the{" "}
        <a href="/en/confidentialite" className="underline">
          privacy policy
        </a>
        ).
      </p>

      <h2 className={h2}>4. User account</h2>
      <p className="mt-2">
        Creating an account requires providing identification data (last name, first name, phone, email, profession)
        and confirming the email address. The account is personal: its credentials must not be shared or lent. The user
        is responsible for keeping their password confidential and for any activity carried out from their account.
      </p>

      <h2 className={h2}>5. Personal data</h2>
      <p className="mt-2">
        The processing of personal data is fully described in our{" "}
        <a href="/en/confidentialite" className="underline">
          Privacy Policy
        </a>
        , a separate document that we invite you to read before registering. Consent to share data with commercial
        partners is separate from acceptance of these Terms of Use and is never required to create an account.
      </p>

      <h2 className={h2}>6. Deletion, suspension and closure of the account</h2>
      <p className="mt-2">
        The user may delete their account at any time from the “My account” page; their personal data are then
        erased immediately, subject to legal retention obligations (accounting records).
      </p>
      <p className="mt-2">
        The publisher may suspend access to an account, after notifying the user by email and inviting them to explain
        themselves, in the event of a breach of these terms: systematic extraction or copying of the content, sharing
        or lending credentials, circumventing protection measures, false declaration of professional status. In the
        event of a serious or repeated breach, the account may be closed; any current subscription is then refunded
        pro rata for the remaining period, except in case of fraud. The automatic and temporary suspension of reading
        in case of an abnormal rate (article 3) is not a sanction.
      </p>

      <h2 className={h2}>7. Liability and availability</h2>
      <p className="mt-2">
        The summaries and the research assistant are reading aids intended for health professionals. They replace
        neither the official text of the guidelines, nor the examination of the patient, nor clinical judgement: any
        diagnostic or therapeutic decision is the sole responsibility of the professional who makes it. The publisher
        takes the greatest care to keep the summaries faithful to their sources and corrects any error reported
        (public corrections log), without guaranteeing that the content is free of errors or exhaustive.
      </p>
      <p className="mt-2">
        The publisher endeavours to keep the site accessible at all times, without any obligation of result:
        interruptions for maintenance, updates or technical incidents may occur. Links to the websites of medical
        societies and other sites are the responsibility of their respective publishers.
      </p>

      <h2 className={h2}>8. Research assistant (artificial intelligence)</h2>
      <p className="mt-2">
        The research assistant, reserved for PREMIUM subscribers, uses an artificial intelligence model to find the
        passages in the summaries that answer a question. Its answers are generated automatically: they may contain
        errors or omissions, and each passage must be checked in the summary and in the official source cited before
        any decision. The assistant gives no opinion about a patient. It is forbidden to enter any data that could
        identify a patient. Questions are not kept by the site; their processing is described in the privacy policy.
      </p>

      <h2 className={h2}>9. Changes to the terms</h2>
      <p className="mt-2">
        The publisher may change these terms, in particular to reflect changes in the service or in regulations. Any
        significant change is notified by email at least 30 days before it comes into force. A user who does not accept
        it may delete their account before that date; continuing to use the site after that date constitutes
        acceptance. The version accepted at registration is recorded.
      </p>

      <h2 className={h2}>10. Applicable law, disputes and mediation</h2>
      <p className="mt-2">
        These Terms of Use are governed by French law. In the event of a dispute, the user is invited to contact the
        publisher first at contact@medical-guidelines.net. Failing an amicable settlement, the dispute is brought before
        the competent courts of Paris where the user acts in a professional capacity; a consumer user may refer the
        matter to the court of their choice under the conditions provided by law and use consumer mediation free of
        charge:
      </p>
      <MediationEn />
    </div>
  );
}
