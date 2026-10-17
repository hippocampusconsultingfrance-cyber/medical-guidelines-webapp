import { MediationEn } from "../mediation";
import { CGV_VERSION } from "@/lib/stripe";

// Traduction d'information des CGV (contenu-fr.tsx fait seul foi).
export default function CgvEn() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Terms of Sale</h1>
      <p className="mt-2 text-slate-500">
        Version of {CGV_VERSION.slice(0, 10).split("-").reverse().join("/")}
        {CGV_VERSION.length > 10 ? ` (revision ${CGV_VERSION.slice(11)})` : ""}.
      </p>

      <h2 className={h2}>1. Seller</h2>
      <p className="mt-2">
        Hippocampus Consulting, SARL (limited liability company) with a share capital of €1,000, 6 rue d&apos;Armaillé,
        75017 Paris, France, RCS Paris 999 259 252, intra-EU VAT number FR43 999 259 252, publisher of the site
        medical-guidelines.net. Phone: +33 9 72 15 24 13. Contact: contact@medical-guidelines.net.
      </p>

      <h2 className={h2}>2. Offer</h2>
      <p className="mt-2">
        The PREMIUM subscription gives access, for online reading only, to every summary in the specialty chosen at
        registration, for the duration of the subscription. No download, export or printing is offered. The summaries
        are independent summaries that replace neither the official guidelines nor clinical judgement (see the{" "}
        <a href="/en/cgu" className="underline">
          terms of use
        </a>
        ).
      </p>
      <p className="mt-2">
        The subscription pays for the service: writing and medical review of the summaries, search tools, alerts and
        hosting. The official guideline documents are neither sold nor distributed by the site: they remain the work
        and property of their authors, freely available on their websites, to which each summary links.
      </p>

      <h2 className={h2}>3. Price</h2>
      <p className="mt-2">
        €50 including all taxes per year, of which French VAT at 20% (i.e. €41.67 excluding tax). The price paid, any
        discounts and the renewal date are shown before payment; the invoice states the amount of VAT.
      </p>

      <h2 className={h2}>4. Discounts</h2>
      <p className="mt-2">
        Founding members offer: −30% on the first year for the first 100 subscribers. Rate for health professionals in
        training (medical or allied health students, residents, junior doctors): −30% on the first year, on
        presentation of a certificate of enrolment for the current academic year, validated by the publisher. Once the
        proof is validated, the discount, which is personal and single-use, is applied automatically at payment. New
        proof is requested at each renewal. Discounts cannot be combined. The proof is viewed only by the publisher and
        is deleted as soon as a decision is made; only the declared status, the academic year and the decision are
        kept.
      </p>

      <h2 className={h2}>5. Term, renewal and cancellation</h2>
      <p className="mt-2">
        The subscription is concluded for one year and renews automatically at the price then in force. The subscriber
        is informed by email of the renewal date and of the option not to renew between one and three months before it
        (article L215-1 of the French Consumer Code). They may cancel at any time from the “Subscription” page, “Cancel
        my subscription” button; access is maintained until the end of the paid year, after which the account becomes
        free again, without losing the summaries unlocked with the free credits. If the price changes, the subscriber is
        informed by email at least 30 days before renewal, with the option to cancel.
      </p>

      <h2 className={h2}>6. Payment and invoice</h2>
      <p className="mt-2">
        Payment is made by bank card via Stripe, a payment service provider; the publisher has no access to card data.
        An invoice is issued for each payment and sent by email.
      </p>

      <h2 className={h2}>7. Right of withdrawal</h2>
      <p className="mt-2">
        Consumers in principle have 14 days to withdraw. As access to the content is immediate, the subscriber
        expressly requests, when subscribing, the immediate performance of the service and waives their right of
        withdrawal from the start of access; this request is recorded with the date of subscription and the version of
        these terms.
      </p>

      <h2 className={h2}>8. Liability</h2>
      <p className="mt-2">
        The publisher takes the greatest care to keep the summaries faithful to their sources, without guaranteeing
        that they are error-free. Any error can be reported from the summary. The publisher cannot be held liable for a
        clinical decision, which is the sole responsibility of the health professional.
      </p>

      <h2 className={h2}>9. Mediation and applicable law</h2>
      <MediationEn />
      <p className="mt-2">These terms are governed by French law.</p>
    </div>
  );
}
