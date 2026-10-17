import { MediationTraduite } from "../mediation";

// Traduction d'information des mentions légales (contenu-fr.tsx fait seul foi).
export default function MentionsLegalesDe() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Impressum</h1>

      <h2 className={h2}>Herausgeber</h2>
      <p className="mt-2">
        Die Website medical-guidelines.net wird herausgegeben von Hippocampus Consulting, einer Gesellschaft mit
        beschränkter Haftung französischen Rechts (SARL) mit einem Stammkapital von 1.000 €.
      </p>
      <ul className="mt-2 list-disc ps-5">
        <li>Sitz: 6 rue d&apos;Armaillé, 75017 Paris, Frankreich</li>
        <li>Handelsregister RCS Paris 999 259 252 (SIREN 999 259 252)</li>
        <li>Umsatzsteuer-Identifikationsnummer: FR43 999 259 252</li>
        <li>
          Telefon:{" "}
          <a href="tel:+33972152413" className="underline">
            +33 9 72 15 24 13
          </a>
        </li>
        <li>
          Kontakt:{" "}
          <a href="mailto:contact@medical-guidelines.net" className="underline">
            contact@medical-guidelines.net
          </a>
        </li>
      </ul>

      <h2 className={h2}>Verantwortlich für den Inhalt</h2>
      <p className="mt-2">Dr. Ahmed Ben Lallahom.</p>

      <h2 className={h2}>Hosting</h2>
      <p className="mt-2">
        Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723, Vereinigte Staaten; Telefon: +1 (951) 383-6898;
        vercel.com.
      </p>
      <p className="mt-2">
        Die Datenbank wird von Supabase in der Europäischen Union (Frankfurt, Deutschland) gehostet. Angaben zu den
        Dienstleistern finden Sie in der{" "}
        <a href="/de/confidentialite" className="underline">
          Datenschutzerklärung
        </a>
        .
      </p>

      <h2 className={h2}>Verbraucherschlichtung</h2>
      <MediationTraduite langue="de" />

      <h2 className={h2}>Geistiges Eigentum</h2>
      <p className="mt-2">
        Die veröffentlichten Zusammenfassungen sind unabhängige Zusammenfassungen, die der Herausgeber auf Grundlage der
        Leitlinien der Fachgesellschaften verfasst hat; deren offizielle Quelle wird stets angegeben. Sie verpflichten
        diese Fachgesellschaften nicht; keines ihrer Logos oder geschützten Elemente wird wiedergegeben. Die Leitlinien
        bleiben Werk und Eigentum ihrer Autoren sowie der Fachgesellschaften oder Einrichtungen, die sie veröffentlichen;
        sie bleiben auf deren Websites frei zugänglich, auf die jede Zusammenfassung verweist. Die Website verkauft und
        verbreitet die Originaldokumente nicht. Jede auch nur teilweise Vervielfältigung oder Entnahme von Inhalten der
        Website ist ohne schriftliche Genehmigung des Herausgebers untersagt.
      </p>
      <p className="mt-2">
        <b>Anfrage eines Rechteinhabers.</b> Jeder Autor, jede Fachgesellschaft und jeder Verlag kann unter{" "}
        <a href="mailto:contact@medical-guidelines.net" className="underline">
          contact@medical-guidelines.net
        </a>{" "}
        die Korrektur, Zuordnung, Änderung oder Entfernung eines Inhalts verlangen, unter Angabe seiner Identität und
        Eigenschaft, des betroffenen Dokuments, der Zusammenfassung auf der Website und des Gegenstands der Anfrage. Die
        Anfrage wird vorrangig bearbeitet: Die betroffene Zusammenfassung wird auf einfache Anfrage während der Prüfung
        von der Website genommen, und innerhalb von 7 Tagen wird eine begründete Antwort gesendet. Die Anfragen und ihr
        Ergebnis werden aufbewahrt.
      </p>

      <h2 className={h2}>Art der Inhalte</h2>
      <p className="mt-2">
        Die Website richtet sich an Gesundheitsfachpersonen und Studierende der Gesundheitsberufe. Sie ersetzt weder die
        Lektüre des vollständigen Textes der Leitlinien noch das klinische Urteil. Die Nutzungsbedingungen sind in den{" "}
        <a href="/de/cgu" className="underline">
          Nutzungsbedingungen
        </a>{" "}
        festgelegt.
      </p>
    </div>
  );
}
