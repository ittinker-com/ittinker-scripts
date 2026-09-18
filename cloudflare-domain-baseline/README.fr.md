# Configuration de Référence pour Noms de Domaine Cloudflare

> Script en 1 clic appliquant les meilleures pratiques de production sur tout domaine Cloudflare : Full Strict SSL, HSTS, redirection 301 www, Cache Rules et antibot.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Utilisation

```bash
# Mode simulation (Dry Run)
bash setup-zone.sh -d example.com -t "API_TOKEN"

# Appliquer les modifications
bash setup-zone.sh -d example.com -t "API_TOKEN" --apply
```

---

## Licence

MIT © [ITTinker](https://ittinker.com)
