import { MediationTraduite } from "../mediation";

// Traduction d'information des mentions légales (contenu-fr.tsx fait seul foi).
export default function MentionsLegalesZh() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">法律声明</h1>

      <h2 className={h2}>发布者</h2>
      <p className="mt-2">
        medical-guidelines.net 网站由 Hippocampus Consulting 发布，该公司为依据法国法律设立的有限责任公司（SARL），注册资本
        1000 €。
      </p>
      <ul className="mt-2 list-disc ps-5">
        <li>注册地址：6 rue d&apos;Armaillé, 75017 Paris, 法国</li>
        <li>巴黎商业登记 RCS Paris 999 259 252（SIREN 999 259 252）</li>
        <li>欧盟增值税号：FR43 999 259 252</li>
        <li>
          电话：
          <a href="tel:+33972152413" className="underline">
            +33 9 72 15 24 13
          </a>
        </li>
        <li>
          联系方式：
          <a href="mailto:contact@medical-guidelines.net" className="underline">
            contact@medical-guidelines.net
          </a>
        </li>
      </ul>

      <h2 className={h2}>出版负责人</h2>
      <p className="mt-2">Ahmed Ben Lallahom 医生。</p>

      <h2 className={h2}>托管</h2>
      <p className="mt-2">Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723, 美国；电话：+1 (951) 383-6898；vercel.com。</p>
      <p className="mt-2">
        数据库由 Supabase 托管于欧盟境内（德国法兰克福）。服务商的详细信息载于
        <a href="/zh/confidentialite" className="underline">
          隐私政策
        </a>
        。
      </p>

      <h2 className={h2}>消费调解</h2>
      <MediationTraduite langue="zh" />

      <h2 className={h2}>知识产权</h2>
      <p className="mt-2">
        本站发布的摘要是发布者根据各医学学会指南撰写的独立摘要，并始终注明官方来源。摘要不代表这些学会，本站亦不转载其任何标志或受保护的元素。指南仍为其作者以及发布它们的学会或机构的作品和财产；指南仍可在其网站上免费获取，每篇摘要均链接至该网站。本站不出售、不分发原始文件。未经发布者书面许可，禁止复制或提取本站的任何内容，即使是部分内容。
      </p>
      <p className="mt-2">
        <b>权利人的请求。</b>任何作者、医学学会或出版方均可发送邮件至
        <a href="mailto:contact@medical-guidelines.net" className="underline">
          contact@medical-guidelines.net
        </a>
        ，要求更正、署名、修改或撤下某项内容，并注明其身份和资格、相关文件、本站上的相关摘要以及请求事项。此类请求将优先处理：只需提出请求，相关摘要即在审查期间从本站下线，并在
        7 天内发送附理由的答复。请求及其处理结果将予以保存。
      </p>

      <h2 className={h2}>内容性质</h2>
      <p className="mt-2">
        本站面向医疗卫生专业人员及医学类专业学生。本站不能替代阅读指南全文，也不能替代临床判断。使用条件详见
        <a href="/zh/cgu" className="underline">
          使用条款
        </a>
        。
      </p>
    </div>
  );
}
