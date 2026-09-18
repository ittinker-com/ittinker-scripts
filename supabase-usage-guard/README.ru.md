# Аудит Производительности и Защиты от Перерасхода Supabase

> Комплексный набор диагностических запросов для Supabase / PostgreSQL: выявление медленных SQL, отсутствующих индексов, раздутых таблиц и запросов с высоким исходящим трафиком (Egress).

[English](README.md) | [中文说明](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Запуск

Вставьте содержимое [`diagnose-db-health.sql`](./diagnose-db-health.sql) в **SQL Editor** в панели Supabase или запустите в терминале:

```bash
bash audit.sh --db "postgresql://..."
```

---

## Лицензия

MIT © [ITTinker](https://ittinker.com)
