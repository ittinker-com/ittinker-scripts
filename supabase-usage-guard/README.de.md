# Supabase Datenbank-Gesundheits- & Performance-Audit

> Umfassende Diagnosesuite für Supabase / PostgreSQL: Erkennung von hohem Egress, langsamen SQL-Queries, fehlenden Indizes und Tabellen-Bloat.

[English](README.md) | [中文说明](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Verwendung

Kopieren Sie [`diagnose-db-health.sql`](./diagnose-db-health.sql) in den **SQL Editor** im Supabase-Dashboard oder führen Sie den CLI-Befehl aus:

```bash
bash audit.sh --db "postgresql://..."
```

---

## Lizenz

MIT © [ITTinker](https://ittinker.com)
