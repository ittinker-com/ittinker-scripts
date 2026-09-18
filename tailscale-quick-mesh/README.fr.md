# Configuration Rapide de Réseau Mesh Tailscale & Routeur de Sous-réseau

> Installation automatisée de Tailscale, activation de l'IP Forwarding Linux et interconnexion privée chiffrée entre serveurs.

[English](README.md) | [中文说明](README.zh-CN.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Utilisation

```bash
# Installation interactive
sudo bash mesh.sh

# Automatisée avec clé d'authentification et sous-réseau
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## Licence

MIT © [ITTinker](https://ittinker.com)
