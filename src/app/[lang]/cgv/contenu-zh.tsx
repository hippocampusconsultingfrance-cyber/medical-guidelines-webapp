import { MediationTraduite } from "../mediation";
import { CGV_VERSION } from "@/lib/stripe";

// Traduction d'information des CGV (contenu-fr.tsx fait seul foi).
export default function CgvZh() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  const [annee, mois, jour] = CGV_VERSION.slice(0, 10).split("-");
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">销售条款</h1>
      <p className="mt-2 text-slate-500">
        {annee} 年 {Number(mois)} 月 {Number(jour)} 日版本
        {CGV_VERSION.length > 10 ? `（修订 ${CGV_VERSION.slice(11)}）` : ""}。
      </p>

      <h2 className={h2}>1. 卖方</h2>
      <p className="mt-2">
        Hippocampus Consulting，注册资本 1000 € 的有限责任公司（SARL），地址：6 rue d&apos;Armaillé, 75017 Paris,
        法国，巴黎商业登记 RCS Paris 999 259 252，欧盟增值税号 FR43 999 259 252，medical-guidelines.net
        网站发布者。电话：+33 9 72 15 24 13。联系方式：contact@medical-guidelines.net。
      </p>

      <h2 className={h2}>2. 服务内容</h2>
      <p className="mt-2">
        PREMIUM 订阅在订阅期内提供注册时所选专科全部摘要的访问权限，仅限在线阅读。不提供任何下载、导出或打印功能。摘要为独立摘要，不能替代官方指南或临床判断（参见
        <a href="/zh/cgu" className="underline">
          使用条款
        </a>
        ）。
      </p>
      <p className="mt-2">
        订阅费用于支付服务本身：摘要的撰写和医学审阅、检索工具、提醒及托管。本站不出售、不分发官方指南文件：它们仍为其作者的作品和财产，可在其网站上免费获取，每篇摘要均链接至该网站。
      </p>

      <h2 className={h2}>3. 价格</h2>
      <p className="mt-2">
        每年 50 €（含全部税费），其中包含 20% 的法国增值税（即不含税 41.67 €）。付款前会显示应付价格、可能的折扣及续订日期；发票会列明增值税金额。
      </p>

      <h2 className={h2}>4. 折扣</h2>
      <p className="mt-2">
        创始会员优惠：前 100 名订阅者首年优惠 30%。在读/培训中的医疗卫生专业人员价格（医学或医疗相关专业学生、住院医师、初级医师）：凭本学年注册证明并经发布者核实，首年优惠
        30%。证明通过后，该折扣（个人专属、仅限使用一次）将在付款时自动应用。每次续订时需重新提交证明。各项折扣不可叠加。证明仅由发布者查阅，并在作出决定后立即删除；仅保留所申报的身份、学年及决定。
      </p>

      <h2 className={h2}>5. 期限、续订与取消</h2>
      <p className="mt-2">
        订阅期限为一年，并按届时有效的价格自动续订。续订前一至三个月，订阅者将通过电子邮件获知续订日期及不续订的选择（《法国消费法典》第
        L215-1 条）。订阅者可随时在“订阅”页面点击“取消我的订阅”按钮取消订阅；访问权限保留至已付费年度结束，之后账户恢复为免费账户，用免费点数解锁的摘要不会丢失。如价格发生变动，订阅者将在续订前至少
        30 天通过电子邮件获知，并可选择取消。
      </p>

      <h2 className={h2}>6. 付款与发票</h2>
      <p className="mt-2">付款通过支付服务商 Stripe 以银行卡完成；发布者无法获取银行卡数据。每笔付款均会开具发票并通过电子邮件发送。</p>

      <h2 className={h2}>7. 撤回权</h2>
      <p className="mt-2">
        消费者原则上享有 14 天的撤回期。由于内容访问即时开通，订阅者在订阅时明确要求立即履行服务，并放弃自访问开始之日起的撤回权；该要求将连同订阅日期及本条款版本一并记录。
      </p>

      <h2 className={h2}>8. 责任</h2>
      <p className="mt-2">
        发布者竭力确保摘要忠实于其来源，但不保证完全无误。任何错误均可在摘要中直接报告。发布者不对任何临床决定承担责任，临床决定由医疗卫生专业人员独自负责。
      </p>

      <h2 className={h2}>9. 调解与适用法律</h2>
      <MediationTraduite langue="zh" />
      <p className="mt-2">本条款受法国法律管辖。</p>
    </div>
  );
}
