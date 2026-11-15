# Google Search QRG SEO Audit Agent

> 基于 Google 官方《搜索质量评估指南》（Search Quality Rater Guidelines, QRG）构建的双轨全自动 SEO 智能体。

## 核心设计与分工
- **确定性感知层（Deterministic Layer）**：纯标准库高效解析，检查 Mobile Viewport、Title 长度、MC/SC 占空比、Trust（About/Contact/Privacy）证据链与 Schema 结构化数据。
- **认知判定层（Cognitive Layer）**：依托 QRG 核心评级提示词，驱动 LLM 自动对 **Page Purpose、Main Content Effort、Trustworthiness（E-E-A-T）与 Needs Met** 进行四维打分，输出结构化整改建议。

## 快速上手

```bash
# 1. 基础规则巡检（无需安装额外依赖，纯 Python 3 原生运行）
python3 audit_agent.py "https://yourdomain.com/your-page/"

# 2. 启用 LLM 深度认知审核（需配置 API Key）
export OPENAI_API_KEY="sk-..."
python3 audit_agent.py "https://yourdomain.com/your-page/" --output report.md
```

## 专栏对应章节
- 架构理论：[读懂 Google Search 系列 B56 · 全自动 SEO Audit Agent 架构](https://blog.ittinker.com/posts/google-圣经-能不能被做成一个自动化-seo-audit-agent/)
- 专栏全景：[读懂 Google Search：110 篇实战全景导览](https://blog.ittinker.com/posts/google-search-guide/)
