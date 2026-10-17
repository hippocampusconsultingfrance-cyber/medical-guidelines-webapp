import { MediationTraduite } from "../mediation";
import { CGV_VERSION } from "@/lib/stripe";

// Traduction d'information des CGV (contenu-fr.tsx fait seul foi).
export default function CgvEs() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Condiciones de venta</h1>
      <p className="mt-2 text-slate-500">
        Versión del {CGV_VERSION.slice(0, 10).split("-").reverse().join("/")}
        {CGV_VERSION.length > 10 ? ` (revisión ${CGV_VERSION.slice(11)})` : ""}.
      </p>

      <h2 className={h2}>1. Vendedor</h2>
      <p className="mt-2">
        Hippocampus Consulting, SARL (sociedad de responsabilidad limitada) con un capital de 1000 €, 6 rue
        d&apos;Armaillé, 75017 París, Francia, RCS París 999 259 252, número de IVA intracomunitario FR43 999 259 252,
        editor del sitio medical-guidelines.net. Teléfono: +33 9 72 15 24 13. Contacto: contact@medical-guidelines.net.
      </p>

      <h2 className={h2}>2. Oferta</h2>
      <p className="mt-2">
        La suscripción PREMIUM da acceso, solo para lectura en línea, a todos los resúmenes de la especialidad elegida al
        registrarse, durante la vigencia de la suscripción. No se ofrece ninguna descarga, exportación ni impresión. Los
        resúmenes son resúmenes independientes que no sustituyen ni a las guías oficiales ni al juicio clínico (véanse
        las{" "}
        <a href="/es/cgu" className="underline">
          condiciones de uso
        </a>
        ).
      </p>
      <p className="mt-2">
        La suscripción remunera el servicio: redacción y revisión médica de los resúmenes, herramientas de búsqueda,
        alertas y alojamiento. Los documentos oficiales de las guías no se venden ni se distribuyen en el sitio: siguen
        siendo obra y propiedad de sus autores, de libre acceso en sus webs, a las que remite cada resumen.
      </p>

      <h2 className={h2}>3. Precio</h2>
      <p className="mt-2">
        50 € con todos los impuestos incluidos al año, de los cuales IVA francés del 20 % (es decir, 41,67 € sin
        impuestos). El precio pagado, los posibles descuentos y la fecha de renovación se indican antes del pago; la
        factura detalla el importe del IVA.
      </p>

      <h2 className={h2}>4. Descuentos</h2>
      <p className="mt-2">
        Oferta miembros fundadores: −30 % el primer año para los 100 primeros suscriptores. Tarifa para profesionales
        sanitarios en formación (estudiantes de medicina o de ciencias de la salud, residentes, médicos jóvenes): −30 %
        el primer año, previa presentación de un certificado de matrícula del curso académico actual, validado por el
        editor. Una vez validado el justificante, el descuento, personal y de un solo uso, se aplica automáticamente al
        pago. Se solicita un nuevo justificante en cada renovación. Los descuentos no son acumulables. El justificante
        solo lo consulta el editor y se elimina en cuanto se toma la decisión; solo se conservan la situación declarada,
        el curso académico y la decisión.
      </p>

      <h2 className={h2}>5. Duración, renovación y cancelación</h2>
      <p className="mt-2">
        La suscripción se contrata por un año y se renueva automáticamente al precio vigente en ese momento. Se informa
        al suscriptor por correo electrónico de la fecha de renovación y de la posibilidad de no renovar entre uno y tres
        meses antes (artículo L215-1 del Código de Consumo francés). Puede cancelarla en cualquier momento desde la
        página «Suscripción», botón «Cancelar mi suscripción»; el acceso se mantiene hasta el final del año pagado,
        después la cuenta vuelve a ser gratuita, sin perder los resúmenes desbloqueados con los créditos gratuitos. En
        caso de cambio de precio, se informa al suscriptor por correo al menos 30 días antes de la renovación, con la
        posibilidad de cancelar.
      </p>

      <h2 className={h2}>6. Pago y factura</h2>
      <p className="mt-2">
        El pago se realiza con tarjeta bancaria a través de Stripe, proveedor de servicios de pago; el editor no tiene
        acceso a los datos de la tarjeta. Se emite una factura por cada pago, que se envía por correo electrónico.
      </p>

      <h2 className={h2}>7. Derecho de desistimiento</h2>
      <p className="mt-2">
        El consumidor dispone en principio de 14 días para desistir. Al ser inmediato el acceso al contenido, el
        suscriptor solicita expresamente, al suscribirse, la ejecución inmediata del servicio y renuncia a su derecho de
        desistimiento desde el inicio del acceso; esta solicitud se registra con la fecha de suscripción y la versión de
        estas condiciones.
      </p>

      <h2 className={h2}>8. Responsabilidad</h2>
      <p className="mt-2">
        El editor pone el máximo cuidado en la fidelidad de los resúmenes a sus fuentes, sin garantizar la ausencia de
        errores. Cualquier error puede notificarse desde el resumen. El editor no puede ser considerado responsable de
        una decisión clínica, que corresponde únicamente al profesional sanitario.
      </p>

      <h2 className={h2}>9. Mediación y derecho aplicable</h2>
      <MediationTraduite langue="es" />
      <p className="mt-2">Estas condiciones se rigen por el derecho francés.</p>
    </div>
  );
}
