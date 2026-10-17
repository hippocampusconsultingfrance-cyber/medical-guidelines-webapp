import { MediationTraduite } from "../mediation";

// Traduction d'information des mentions légales (contenu-fr.tsx fait seul foi).
export default function MentionsLegalesEs() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Aviso legal</h1>

      <h2 className={h2}>Editor</h2>
      <p className="mt-2">
        El sitio medical-guidelines.net es editado por Hippocampus Consulting, sociedad de responsabilidad limitada de
        derecho francés (SARL) con un capital social de 1000 €.
      </p>
      <ul className="mt-2 list-disc ps-5">
        <li>Domicilio social: 6 rue d&apos;Armaillé, 75017 París, Francia</li>
        <li>RCS París 999 259 252 (SIREN 999 259 252)</li>
        <li>Número de IVA intracomunitario: FR43 999 259 252</li>
        <li>
          Teléfono:{" "}
          <a href="tel:+33972152413" className="underline">
            +33 9 72 15 24 13
          </a>
        </li>
        <li>
          Contacto:{" "}
          <a href="mailto:contact@medical-guidelines.net" className="underline">
            contact@medical-guidelines.net
          </a>
        </li>
      </ul>

      <h2 className={h2}>Director de la publicación</h2>
      <p className="mt-2">Dr. Ahmed Ben Lallahom.</p>

      <h2 className={h2}>Alojamiento</h2>
      <p className="mt-2">
        Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723, Estados Unidos; teléfono: +1 (951) 383-6898; vercel.com.
      </p>
      <p className="mt-2">
        La base de datos está alojada por Supabase en la Unión Europea (Fráncfort, Alemania). Los datos de los
        proveedores figuran en la{" "}
        <a href="/es/confidentialite" className="underline">
          política de privacidad
        </a>
        .
      </p>

      <h2 className={h2}>Mediación de consumo</h2>
      <MediationTraduite langue="es" />

      <h2 className={h2}>Propiedad intelectual</h2>
      <p className="mt-2">
        Los resúmenes publicados son resúmenes independientes, redactados por el editor a partir de las guías de las
        sociedades científicas, cuya fuente oficial se indica siempre. No comprometen a dichas sociedades, de las que no
        se reproduce ningún logotipo ni elemento protegido. Las guías siguen siendo obra y propiedad de sus autores y de
        las sociedades o instituciones que las publican; siguen siendo de libre acceso en sus webs, a las que remite cada
        resumen. El sitio no vende ni distribuye los documentos originales. Queda prohibida cualquier reproducción o
        extracción, incluso parcial, del contenido del sitio sin la autorización escrita del editor.
      </p>
      <p className="mt-2">
        <b>Solicitud de un titular de derechos.</b> Cualquier autor, sociedad científica o editor puede solicitar la
        corrección, la atribución, la modificación o la retirada de un contenido en{" "}
        <a href="mailto:contact@medical-guidelines.net" className="underline">
          contact@medical-guidelines.net
        </a>
        , indicando su identidad y su condición, el documento afectado, el resumen del sitio y el objeto de la solicitud.
        La solicitud se tramita con prioridad: el resumen afectado se retira del sitio, a simple petición, mientras se
        examina, y se envía una respuesta motivada en un plazo de 7 días. Las solicitudes y su resultado se conservan.
      </p>

      <h2 className={h2}>Naturaleza del contenido</h2>
      <p className="mt-2">
        El sitio está destinado a los profesionales sanitarios y a los estudiantes de ciencias de la salud. No sustituye
        ni a la lectura del texto completo de las guías ni al juicio clínico. Las condiciones de uso se detallan en las{" "}
        <a href="/es/cgu" className="underline">
          condiciones de uso
        </a>
        .
      </p>
    </div>
  );
}
