# Supabase データベース健全性＆スロークエリ診断ツール

> Supabase / PostgreSQL 向けの総合診断スイート。Shared Pooler トラフィック急増の原因、スロークエリ、インデックス欠如、テーブル肥大化を一括チェック。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 使い方

Supabase ダッシュボードの **SQL Editor** に [`diagnose-db-health.sql`](./diagnose-db-health.sql) を貼り付けて実行するか、CLI から実行します：

```bash
bash audit.sh --db "postgresql://..."
```

---

## ライセンス

MIT © [ITTinker](https://ittinker.com)
