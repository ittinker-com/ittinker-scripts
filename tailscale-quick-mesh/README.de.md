# Tailscale Quick Mesh & Subnet-Router Setup

> 1-Klick-Skript zur Installation von Tailscale, Aktivierung des Linux-Kernel-IP-Forwardings und Konfiguration verschlüsselter Netzwerke.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Schnellstart

```bash
# Standard
sudo bash mesh.sh

# Automatisiert mit Auth Key & Subnet
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## Lizenz

MIT © [ITTinker](https://ittinker.com)
