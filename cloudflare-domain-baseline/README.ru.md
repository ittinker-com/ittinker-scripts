# Базовая Оптимизация Домена Cloudflare (Best Practices)

> Скрипт для настройки безопасного production-профиля любого домена в Cloudflare: Full Strict SSL, HSTS, 301-редирект с www, Cache Rules и защита от ботов.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Что Включает Скрипт?

1. **Full (Strict) SSL + HSTS**: Защита от атак типа "человек посередине" (max-age 6 месяцев, subdomains).
2. **Канонический 301-Редирект**: Автоматический редирект с `www.domain.com` на `domain.com` (сохраняет SEO-вес).
3. **Cache Rules для Статики**: Кэширование картинок, CSS, JS и шрифтов на 30 дней на серверах Cloudflare.
4. **Защита от Ботов (Bot Fight Mode)**: Блокировка автоматизированных сканеров и парсеров.
5. **Сетевые Протоколы**: Включение HTTP/3 (QUIC), Brotli и Early Hints.

## Запуск

```bash
# Предпросмотр (Dry Run)
bash setup-zone.sh -d example.com -t "ВАШ_API_TOKEN"

# Применение
bash setup-zone.sh -d example.com -t "ВАШ_API_TOKEN" --apply
```

---

## Лицензия

MIT © [ITTinker](https://ittinker.com)
