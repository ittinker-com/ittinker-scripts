# ITTinker Skripte & Automatisierungs-Toolkits

> Öffentliche Automatisierungsskripte, DevOps-Workflows und System-Utilities für die ITTinker-Plattform.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Toolkit-Index

| Verzeichnis | Name | Beschreibung |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API Channel Models Sync** | Automatische Modell-Synchronisation von Upstream-Providern mit Diff-Prüfung und Snapshot-Backup. |
| [`vps-init/`](./vps-init/) | **VPS-Initialisierung (1-Klick)** | Vollständiges VPS-Setup vom Bare-Metal bis Production: Updates, Benutzer, SSH-Hardening, Firewall, BBR, fail2ban. |
| [`vps-bench/`](./vps-bench/) | **VPS Benchmark Toolkit** | Interaktives Menü mit 15+ Testskripten: Performance, Routing-Traces, IP-Qualität, Streaming-Unlock, Speedtests. |
| [`ssh-key-setup/`](./ssh-key-setup/) | **SSH-Schlüssel Setup-Assistent** | Geführte SSH-Schlüssel-Konfiguration: Ed25519-Generierung, Server-Upload, SSH-Config und SSH-Agent Verwaltung. |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Cloudflare UFW Firewall** | Automatische UFW-Regeln für offizielle Cloudflare-IPs auf Port 80/443 mit Dry-Run und wöchentlichem Cron-Job. |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Cloudflare Domain Best-Practices** | 1-Klick-Setup bewährter Domain-Einstellungen: Full Strict SSL, HSTS, 301 www-Redirect, Cache Rules, Bot Fight Mode. |
| [`vps-gfw-diagnose/`](./vps-gfw-diagnose/) | **VPS-Konnektivitätsdiagnose** | Multi-Regionen-Diagnosetool zur Unterscheidung von Serverausfall, Port-Blockaden oder staatlicher IP-Zensur (GFW). |
| [`docker-quick-deploy/`](./docker-quick-deploy/) | **Production Docker Installer** | 1-Klick-Installer für Docker CE & Compose V2 mit Log-Rotation (Schutz vor vollem Speicher), Live-Restore und Rechten. |
| [`vps-health-monitor/`](./vps-health-monitor/) | **Schlanker VPS-Health-Monitor** | Ressourcenfreier Cron-Monitor mit Webhook-Alarmen (Telegram, Discord, Feishu) bei hoher CPU-, RAM- oder Festplattenlast. |
| [`cloudflare-tunnel-setup/`](./cloudflare-tunnel-setup/) | **Cloudflare Tunnel Setup** | Schnelle Installation des cloudflared Systemd-Dienstes ohne offene eingehende Ports oder IP-Freigabe. |
| [`tailscale-quick-mesh/`](./tailscale-quick-mesh/) | **Tailscale Quick Mesh Setup** | Sicheres WireGuard-Mesh-Netzwerk über Cloud-Grenzen hinweg mit IP-Forwarding und Subnet-Router-Unterstützung. |

---

## Richtlinien

- Alle eigenständigen Skripte sind in separaten Unterordnern im Kebab-Case-Format organisiert.
- Jedes Tool enthält ausführbare Shell-Skripte und mehrsprachige README-Dokumentationen.

