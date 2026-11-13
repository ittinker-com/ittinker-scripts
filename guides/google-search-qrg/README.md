# 读懂 Google Search：110 篇搜索质量与 SEO 实战指南开源知识库

> 🌟 **基于 Google 官方评估准则（QRG）与算法工程逻辑构建的现代 SEO 知识全集。**
> 
> 本知识库专为独立开发者（Indie Hacker）、出海团队、SaaS 创始人及技术型站长打造。全景拆解从算法机制、E-E-A-T 真实标尺、AI 生成内容边界，到出海工具站与矩阵建设的完整工程体系。

🌐 **官方在线交互主页**：[blog.ittinker.com/posts/google-search-guide/](https://blog.ittinker.com/posts/google-search-guide/)

---

## 知识库架构导航

知识库由两大核心支柱构成，共计 110 篇长文精析及 1,500+ 原创全景技术图解：

```text
guides/google-search-qrg/
├── a-qrg-principles/        # 📘 A 系列：QRG 官方原著逐章拆解（54 篇）
│   ├── README.md            # A 系列索引与知识矩阵
│   ├── a01-what-problem-does-google-search-solve.md
│   └── ...
├── b-indie-dev-playbook/    # 🚀 B 系列：独立开发者出海实操指南（56 篇）
│   ├── README.md            # B 系列实战索引与场景航线
│   ├── b01-how-many-words-does-an-ai-tool-page-need.md
│   └── ...
└── assets/                  # 🎨 全景技术图解与架构设计图谱
```

---

## 核心专栏入口

### 📘 [A 系列：Google 质量评估准则（QRG）官方原著逐章拆解](./a-qrg-principles/) (共 54 篇)
- **底层心法**：QRG 究竟是什么、评估员如何打分、为什么不是直接算法代码却指导着整个搜索生态。
- **质量总纲**：Page Purpose、Main Content (MC)、Supplementary Content (SC) 与 Ads 的真实权值。
- **信任护城河**：E-E-A-T（经验、专业、权威、信任）的实测落地，为什么 Trust 是唯一不可妥协的核心。
- **违规红线**：Spam、Expired Domains、Site Reputation Abuse、Scaled Content Abuse（AI批量滥用）官方定义。

👉 [浏览 A 系列全部 54 篇文档](./a-qrg-principles/)

---

### 🚀 [B 系列：独立开发者出海实战心法与踩坑指南](./b-indie-dev-playbook/) (共 56 篇)
- **工具与落地页设计**：破除“页面必须满 1500 字”迷信、300 字工具页如何赢过 3000 字长文博客、CTA 密度合规界限。
- **AI 内容与 pSEO 边界**：Google 到底允不允许 AI 写内容、文本相似度 vs 信息原创度、10 万个 pSEO 页面放量门禁。
- **冷启动与信任搭建**：新网站没有 Reputation 怎么破局、出海 SaaS 必须具备的信任底盘与合规穿透。
- **QRG 实验室**：真实网站端到端审查 SOP、三大主流大模型（GPT/Claude/Gemini）当 Rater 盲测一致性实验。

👉 [浏览 B 系列全部 56 篇文档](./b-indie-dev-playbook/)

---

## 常见问题直达航线

1. **做 AI 工具页，到底需要写多少字？**
   - 见 [`b01-how-many-words-does-an-ai-tool-page-need.md`](./b-indie-dev-playbook/b01-how-many-words-does-an-ai-tool-page-need.md)
2. **为什么 300 字工具页往往比 3000 字长篇博客更有价值？**
   - 见 [`b02-why-300-words-tool-page-outvalues-3000-words-blog.md`](./b-indie-dev-playbook/b02-why-300-words-tool-page-outvalues-3000-words-blog.md)
3. **Generator、Examples、Prompt、FAQ，谁才是页面的 Main Content？**
   - 见 [`b03-who-is-main-content-in-ai-tool-page.md`](./b-indie-dev-playbook/b03-who-is-main-content-in-ai-tool-page.md)
4. **页面放太多 CTA 转化按钮，会不会被判定为 Low Quality？**
   - 见 [`b04-do-too-many-ctas-hurt-page-quality.md`](./b-indie-dev-playbook/b04-do-too-many-ctas-hurt-page-quality.md)
5. **AI 批量生成内容（pSEO）什么时候会踩中 Scaled Content Abuse 严打红线？**
   - 见 [`a25-scaled-content-abuse-ai-mass-content.md`](./a-qrg-principles/a25-scaled-content-abuse-ai-mass-content.md) 与 [`b18-programmatic-seo-and-scaled-content-abuse.md`](./b-indie-dev-playbook/b18-programmatic-seo-and-scaled-content-abuse.md)

---

## 协议与声明

本项目文档内容基于 Google 官方公开之 [Search Quality Evaluator Guidelines (QRG)](https://developers.google.com/search/docs/fundamentals/creating-helpful-content) 进行独立技术剖析与出海工程实战总结，遵循开源共享理念。欢迎 Star 收藏与提交 Issue 探讨！
