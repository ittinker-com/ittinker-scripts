# Supabase 数据库健康、慢查询与流量防超限体检工具

> 专为 Supabase / PostgreSQL 设计的全方位体检诊断套件。一键排查 Shared Pooler 流量大户、慢 SQL、缺失索引、无用索引与表膨胀。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 解决的痛点

Supabase 免费套餐每月仅有 5GB 出站流量（Egress）。当出现 `Shared Pooler Egress` 异常飙升时，通常是由于：
1. **未做内存缓存的高频读取**：每个接口都在重复全量拉取 `config` 等配置表，产生数百万行网络搬运。
2. **缺失索引导致全表硬扫**：大量查询只能逐行扫描整张大表，耗时极高且吃满连接池。
3. **无分页无上限的数据导出**：大长文本字段未做字段过滤或 `LIMIT` 限制。

本套件提供一站式、开箱即用的 360° 数据库全身体检。

---

## 体检检测项目

1. **流量大户排行 (Top Egress)**：精准找出搬运数据行数最多、偷跑连接池流量的元凶 SQL。
2. **耗时最长慢 SQL (Slow Queries)**：排查累计耗时最长、平均耗时最高的低效语句。
3. **严重缺失索引的表 (Seq Scans)**：统计全表扫描读取量与索引命中率，明确指导需要给哪张表建索引。
4. **冗余/废弃索引 (Unused Indexes)**：找出从未被查询命中、白占磁盘且拖慢写入速度的无用索引。
5. **表物理存储空间 Top 10**：分析真实数据量与索引体积占比。
6. **表膨胀与死元组 (Dead Tuples)**：排查频繁更新或删除后堆积的垃圾死元组。

---

## 使用方式

### 方式 1：控制台一键执行（最推荐，零环境要求）
1. 进入 **Supabase 控制台** -> 点击左侧 **SQL Editor**。
2. 复制 [`diagnose-db-health.sql`](./diagnose-db-health.sql) 里的所有内容粘贴进去。
3. 点击 **Run**，结果立刻呈现在浏览器界面中。

### 方式 2：终端自动化执行
```bash
# 传入 Supabase 数据库连接串（在 Project Settings -> Database -> Connection URI 获取）
bash audit.sh --db "postgresql://postgres.[ref]:[pass]@aws-0-[region].pooler.supabase.com:6543/postgres"
```

---

## 开源协议

MIT © [ITTinker](https://ittinker.com)
