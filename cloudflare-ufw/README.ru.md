# Настройка UFW для Cloudflare

> Автоматическая настройка правил UFW, разрешающих доступ к портам 80/443 только через официальные диапазоны IP Cloudflare.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Запуск

```bash
# Предпросмотр (Dry Run)
sudo bash setup.sh

# Применение правил и установка Cron
sudo bash setup.sh --apply --install-cron
```

---

## Лицензия

MIT © [ITTinker](https://ittinker.com)
