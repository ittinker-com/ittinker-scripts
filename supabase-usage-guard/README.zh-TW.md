# Supabase 資料庫健康、慢查詢與流量防超限健檢工具

> 專為 Supabase / PostgreSQL 設計的全方位健檢診斷套件。一鍵排查 Shared Pooler 流量大戶、慢 SQL、缺失索引、無用索引與表膨脹。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 快速使用

在 Supabase 控制台的 **SQL Editor** 中貼上 [`diagnose-db-health.sql`](./diagnose-db-health.sql) 執行即可，或透過命令列執行：

```bash
bash audit.sh --db "postgresql://..."
```

---

## 開源協議

MIT © [ITTinker](https://ittinker.com)
