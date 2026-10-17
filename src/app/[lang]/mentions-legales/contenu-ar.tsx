import { MediationTraduite } from "../mediation";

// Traduction d'information des mentions légales (contenu-fr.tsx fait seul foi).
export default function MentionsLegalesAr() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">البيانات القانونية</h1>

      <h2 className={h2}>الناشر</h2>
      <p className="mt-2">
        ينشر موقع medical-guidelines.net شركة Hippocampus Consulting، وهي شركة ذات مسؤولية محدودة خاضعة للقانون الفرنسي
        (SARL) برأسمال قدره 1000 €.
      </p>
      <ul className="mt-2 list-disc ps-5">
        <li>المقر الاجتماعي: 6 rue d&apos;Armaillé, 75017 Paris، فرنسا</li>
        <li>السجل التجاري RCS Paris 999 259 252 ‏(SIREN 999 259 252)</li>
        <li>رقم ضريبة القيمة المضافة داخل الاتحاد الأوروبي: FR43 999 259 252</li>
        <li>
          الهاتف:{" "}
          <a href="tel:+33972152413" className="underline" dir="ltr">
            +33 9 72 15 24 13
          </a>
        </li>
        <li>
          للتواصل:{" "}
          <a href="mailto:contact@medical-guidelines.net" className="underline">
            contact@medical-guidelines.net
          </a>
        </li>
      </ul>

      <h2 className={h2}>مدير النشر</h2>
      <p className="mt-2">الدكتور Ahmed Ben Lallahom.</p>

      <h2 className={h2}>الاستضافة</h2>
      <p className="mt-2">
        Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723، الولايات المتحدة؛ الهاتف:{" "}
        <span dir="ltr">+1 (951) 383-6898</span>؛ vercel.com.
      </p>
      <p className="mt-2">
        تستضيف Supabase قاعدة البيانات داخل الاتحاد الأوروبي (فرانكفورت، ألمانيا). ترد تفاصيل مقدّمي الخدمات في{" "}
        <a href="/ar/confidentialite" className="underline">
          سياسة الخصوصية
        </a>
        .
      </p>

      <h2 className={h2}>الوساطة الاستهلاكية</h2>
      <MediationTraduite langue="ar" />

      <h2 className={h2}>الملكية الفكرية</h2>
      <p className="mt-2">
        الملخصات المنشورة ملخصات مستقلة يكتبها الناشر انطلاقًا من توصيات الجمعيات العلمية، مع ذكر مصدرها الرسمي دائمًا.
        ولا تُلزم هذه الجمعيات، ولا يُستنسخ أي شعار أو عنصر محمي خاص بها. تبقى التوصيات من عمل مؤلفيها وملكًا لهم وللجمعيات
        أو المؤسسات التي تنشرها؛ وتظل متاحة مجانًا على مواقعها التي يحيل إليها كل ملخص. لا يبيع الموقع الوثائق الأصلية ولا
        يوزّعها. يُحظر أي استنساخ أو استخراج لمحتوى الموقع، ولو جزئيًا، دون إذن كتابي من الناشر.
      </p>
      <p className="mt-2">
        <b>طلب صاحب حق.</b> يمكن لأي مؤلف أو جمعية علمية أو ناشر طلب تصحيح محتوى أو نسبته أو تعديله أو سحبه عبر{" "}
        <a href="mailto:contact@medical-guidelines.net" className="underline">
          contact@medical-guidelines.net
        </a>
        ، مع بيان هويته وصفته، والوثيقة المعنية، والملخص المعني على الموقع، وموضوع الطلب. يُعالَج الطلب بأولوية: يُسحب الملخص
        المعني من الموقع بمجرد الطلب أثناء دراسته، ويُرسل رد معلّل خلال 7 أيام. وتُحفظ الطلبات ونتائجها.
      </p>

      <h2 className={h2}>طبيعة المحتوى</h2>
      <p className="mt-2">
        الموقع موجّه إلى العاملين في المهن الصحية وطلاب التخصصات الصحية. ولا يغني عن قراءة النص الكامل للتوصيات ولا عن
        التقدير السريري. ترد شروط الاستخدام في{" "}
        <a href="/ar/cgu" className="underline">
          شروط الاستخدام
        </a>
        .
      </p>
    </div>
  );
}
