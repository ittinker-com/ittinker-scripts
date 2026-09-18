# Cloudflare UFW Firewall Setup

> Automatische UFW-Konfiguration, die den Webverkehr (Port 80/443) ausschließlich auf offizielle Cloudflare-IP-Bereiche beschränkt.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Schnellstart

```bash
# Vorschau
sudo bash setup.sh

# Anwenden und Cronjob einrichten
sudo bash setup.sh --apply --install-cron
```

---

## Lizenz

MIT © [ITTinker](https://ittinker.com)
