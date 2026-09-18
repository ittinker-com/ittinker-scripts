# Configuration du Pare-feu UFW pour Cloudflare

> Configuration automatique d'UFW pour n'autoriser les flux Web (ports 80/443) que depuis les plages d'adresses IP officielles de Cloudflare.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Utilisation

```bash
# Simulation
sudo bash setup.sh

# Appliquer et installer la tâche cron
sudo bash setup.sh --apply --install-cron
```

---

## Licence

MIT © [ITTinker](https://ittinker.com)
