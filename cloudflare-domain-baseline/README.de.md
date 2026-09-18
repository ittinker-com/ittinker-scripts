# Cloudflare Domain Best-Practice Baseline Setup

> 1-Klick-Skript zur produktionsreifen Konfiguration für jede Cloudflare-Domain: Full Strict SSL, HSTS, 301-Redirect für www, Cache Rules und Bot-Schutz.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Enthaltene Best Practices

- **Full Strict SSL & HSTS**: Maximale Transportverschlüsselung bis zum Ursprungsserver.
- **Kanonische 301-Weiterleitung**: Automatischer 301-Redirect von `www` auf die Hauptdomain.
- **Cache Rules für statische Inhalte**: Bis zu 30 Tage Edge-Cache entlasten den VPS-Server enorm.
- **Bot Fight Mode & BIC**: Schutz vor bösartigen Web-Scrapern.
- **Netzwerkoptimierung**: Aktivierung von HTTP/3 (QUIC), 0-RTT und Brotli.

## Verwendung

```bash
# Vorschau (Dry Run)
bash setup-zone.sh -d example.com -t "API_TOKEN"

# Anwenden
bash setup-zone.sh -d example.com -t "API_TOKEN" --apply
```

---

## Lizenz

MIT © [ITTinker](https://ittinker.com)
