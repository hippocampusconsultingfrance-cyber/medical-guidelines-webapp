// Traduction d'information de la politique de confidentialité
// (contenu-fr.tsx fait seul foi).
export default function ConfidentialiteZh() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">隐私政策</h1>
      <p className="mt-2 text-slate-500">最后更新：2026 年 10 月 17 日。符合《通用数据保护条例》（GDPR）。</p>

      <div className="mt-6 rounded-md border-s-4 border-[#2BB5A6] bg-[#EEF6FB] p-4">
        <p className="font-medium text-slate-900">简而言之</p>
        <ul className="mt-2 list-disc space-y-1 ps-5">
          <li>我们收集您的姓、名、电话、电子邮箱和职业，用于创建并保护您的账户。</li>
          <li>
            除非您在注册时（或之后在“我的账户”页面）明确且单独勾选相应选项，否则这些数据<strong>绝不</strong>会提供给商业合作伙伴。
          </li>
          <li>您可以随时查阅、更正、导出或要求删除您的数据。</li>
        </ul>
      </div>

      <h2 className={h2}>1. 数据控制者</h2>
      <p className="mt-2">
        本站所收集数据的控制者为 Hippocampus Consulting，注册资本 1000 € 的有限责任公司（SARL），地址：6 rue
        d&apos;Armaillé, 75017 Paris, 法国（SIREN 999 259 252），联系方式：contact@medical-guidelines.net。另请参阅
        <a href="/zh/mentions-legales" className="underline">
          法律声明
        </a>
        。
      </p>

      <h2 className={h2}>2. 收集的数据</h2>
      <p className="mt-2">
        注册时：姓、名、电话号码、电子邮箱地址、职业（选择“其他”时需注明）、阅读的专科；完善账户时再设置用户名和密码（加密存储，绝不以明文保存）。
      </p>
      <p className="mt-2">
        使用过程中：已解锁的摘要、已收藏的摘要、阅读过的摘要记录、关注的学会和电子邮件提醒偏好，以及已发送提醒的列表。如订阅
        PREMIUM：订阅状态和日期、接受销售条款及放弃撤回权的日期、Stripe
        客户和订阅标识。银行卡数据在 Stripe 输入，绝不会传送给我们。这些数据用于显示您的个人空间（继续阅读、收藏、您摘要的更新）并向您发送提醒。“阅读最多”排名仅基于汇总的读者人数：绝不会显示任何个人读过什么。
      </p>
      <p className="mt-2">
        内容安全：每次打开摘要都会被记录（账户、摘要、日期和时间），保存 30
        天，用于发现自动化提取；阅读速度异常时，阅读将被临时暂停并通知管理员。法律依据：发布者保护本站内容免遭复制的合法利益（GDPR
        第 6.1.f 条）；超过 30
        天的记录每晚自动删除。在读/培训专业人员价格：上传的证明仅由管理员查阅，并在作出决定后立即删除；仅保留所申报的身份、学年及决定。
      </p>
      <p className="mt-2">
        申请成为医生审校者（
        <a href="/zh/relecteurs" className="underline">
          医生审校者
        </a>
        页面，无需账户）：姓、名、电话号码、电子邮箱地址、职业、希望校对其摘要的专科以及可选留言。这些数据仅用于就该提议与您联系；仅管理员可访问。法律依据：您的同意（GDPR
        第 6.1.a 条），您可随时发送邮件至 contact@medical-guidelines.net 撤回同意。
      </p>

      <h2 className={h2}>3. 目的与法律依据</h2>
      <p className="mt-2">
        <strong>3.1. 账户运行（必需）。</strong>您的数据用于创建账户、验证身份、保障本站安全，并在适用时管理您的订阅。法律依据：您创建账户时与
        Medical Guidelines 之间合同的履行（GDPR 第 6.1.b 条）。
      </p>
      <p className="mt-2">
        <strong>3.2. 向商业合作伙伴提供（可选）。</strong>当且仅当您在注册时勾选了相应选项，您的数据（姓名、电子邮箱、职业）才可能提供给以下提供与您职业活动相关产品或服务的合作伙伴：LASKA
        CORPORATE SAS。任何新合作伙伴都将被添加到此列表中，并在任何传输前再次征求您的同意。法律依据：明确同意（GDPR 第 6.1.a
        条），该同意与接受使用条款分开收集，从不预先勾选，且可随时撤回，不影响您访问服务。
      </p>
      <p className="mt-2">
        <strong>3.3. 向作者提供的匿名统计。</strong>我们可能向医学学会和指南作者提供关于其指南阅读情况的匿名汇总统计（按摘要、按月、按专科统计的读者人数），仅在读者达到
        10 人及以上时提供，绝不提供任何会员的身份或浏览记录。法律依据：发布者向作者报告其指南传播情况的合法利益（GDPR 第 6.1.f
        条）。
      </p>

      <h2 className={h2}>4. 保存期限</h2>
      <p className="mt-2">
        只要您的账户处于活跃状态，您的数据就会被保存。您删除账户时数据立即删除；账户不活跃满 3 年（3
        年内未登录，正在订阅的除外）时最迟删除，法律另有规定的除外。发票和付款凭证保存 10 年（会计义务，《法国商法典》第
        L123-22 条）。
      </p>
      <p className="mt-2">医生审校者申请在被拒绝 6 个月后删除，最迟在提交 3 年后删除。</p>

      <h2 className={h2}>5. 您的权利</h2>
      <p className="mt-2">
        根据 GDPR，您对您的数据享有访问、更正、删除、限制处理、可携带及反对的权利，并有权随时撤回您对向合作伙伴提供数据的同意（不具追溯效力，且不影响服务访问）。您可以在
        <a href="/zh/compte" className="underline">
          我的账户
        </a>
        页面行使这些权利（修改信息、撤回同意、导出数据、删除账户），或联系本站发布者（contact@medical-guidelines.net）。我们将在一个月内答复。您还有权向法国数据保护机构
        CNIL 投诉（www.cnil.fr）。
      </p>

      <h2 className={h2}>6. 安全</h2>
      <p className="mt-2">密码经哈希处理，绝不以明文保存。数据访问受数据库层面的安全规则限制（每位用户只能查看自己的个人资料）。</p>

      <h2 className={h2}>7. 托管</h2>
      <p className="mt-2">
        数据库（账户和个人资料）由 Supabase Inc. 托管于欧盟境内（德国法兰克福）。本站通过 Vercel Inc.
        的全球分发网络提供服务。这两家服务商均为在美国设立的公司，作为数据处理者行事，并通过欧盟委员会的标准合同条款和/或欧美数据隐私框架规范任何向欧盟以外的数据传输。
      </p>
      <p className="mt-2">
        PREMIUM 订阅的付款由支付服务商 Stripe Payments Europe, Ltd.（爱尔兰都柏林）处理，该公司会接收您的电子邮箱地址、账单地址和付款数据，并开具发票。
      </p>
      <p className="mt-2">
        服务邮件（注册确认、忘记密码）和电子邮件提醒（所关注学会的新指南、您摘要的更新，面向已开启提醒的 PREMIUM
        订阅者），以及发送给已开启提醒的 PREMIUM 订阅者的月度动态信，均由 Resend（Resend,
        Inc.，美国）发送，其在相同条件下作为数据处理者行事。每封提醒邮件均附退订链接；也可在“我的账户”页面关闭提醒。
      </p>
      <p className="mt-2">
        我们还可能向您发送两封跟进邮件，每封仅发送一次：注册 24
        小时后仍未完成时的提醒，以及免费点数用完时的订阅信息。邮件附有退订链接，退订同时会关闭提醒。
      </p>
      <p className="mt-2">
        本站访问量通过 Vercel Web Analytics 统计，不使用 Cookie 或持久标识：仅生成汇总统计（页面浏览量、国家、设备类型、来源网站）。字体由本站自行托管。
      </p>
      <p className="mt-2">
        本站的技术错误会发送至 Sentry（Functional Software, Inc.），托管于欧盟境内（德国），作为数据处理者行事：错误信息、相关页面和浏览器类型，不含
        IP 地址、Cookie、身份信息或摘要内容。这些数据仅用于修复故障，最多保存 90 天。
      </p>
      <p className="mt-2">
        <b>会员建议。</b>当您发送建议（“有想法？”按钮）时，我们会保存您的留言、留言类型、发送页面、日期及与您账户的关联，以便处理并告知您处理结果。仅管理团队可以访问。留言会随您的账户一并删除。请勿填写任何患者数据。
      </p>
      <p className="mt-2">
        <b>检索助手（测试版）。</b>使用时，您的问题和摘要节选会发送至 Anthropic（Anthropic
        PBC，美国），其作为数据处理者生成回答，数据传输受欧盟委员会标准合同条款规范。本站不保存问题和回答：仅记录日期和摘录数量，用于执行每日限额。请勿输入任何可识别患者身份的数据：包含电子邮箱地址、电话号码或社保号码、出生日期或患者编号的问题会被本站拦截，不会发送。
      </p>
      <p className="mt-2">您对向合作伙伴提供数据的同意每次变更均会加注时间戳，并保存在可于“我的账户”页面查阅的记录中。</p>

      <h2 className={h2}>8. Cookie</h2>
      <p className="mt-2">
        本站仅设置其运行所严格必需的 Cookie：用于保持登录状态和保护账户安全的会话
        Cookie，以及一个记住您所用网站语言一年的 Cookie。本站不使用任何广告、访问量统计或社交网络
        Cookie；由于这些 Cookie 无需征得同意，因此不显示任何横幅。
      </p>
    </div>
  );
}
