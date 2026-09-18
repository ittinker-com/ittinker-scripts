# ITTinker Scripts et Boîtes à Outils d'Automatisation

> Scripts publics d'automatisation, flux de travail DevOps et utilitaires système pour la plateforme ITTinker.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Index des Outils

| Répertoire | Nom | Description |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API Channel Models Sync** | Synchronisation automatisée des modèles d'API en amont avec calcul de diff et sauvegarde. |
| [`vps-init/`](./vps-init/) | **Initialisation VPS en 1 Clic** | Configuration complète de VPS brut : mise à jour, utilisateur dédié, sécurité SSH, pare-feu, BBR, fail2ban. |
| [`vps-bench/`](./vps-bench/) | **Boîte à Outils de Benchmark VPS** | Menu interactif intégrant plus de 15 tests : performances, routage, qualité d'IP, streaming, tests de débit. |
| [`ssh-key-setup/`](./ssh-key-setup/) | **Assistant de Configuration SSH** | Configuration guidée de clés Ed25519 : génération, déploiement sur serveur, gestion SSH Config et Agent. |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Pare-feu Cloudflare UFW** | Configuration automatique d'UFW autorisant uniquement les IP Cloudflare sur ports 80/443 avec cron hebdomadaire. |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Configuration de Référence Cloudflare** | Bonnes pratiques pour noms de domaine : Full Strict SSL, HSTS, redirection 301 www, Cache Rules et antibot. |
| [`vps-gfw-diagnose/`](./vps-gfw-diagnose/) | **Diagnostic de Connectivité VPS** | Outil multirégional identifiant panne serveur, port fermé ou blocage d'IP par censure réseau (GFW). |
| [`docker-quick-deploy/`](./docker-quick-deploy/) | **Installateur Docker pour Production** | Déploiement de Docker CE & Compose V2 avec rotation des journaux (anti-saturation disque), live-restore et droits. |
| [`vps-health-monitor/`](./vps-health-monitor/) | **Moniteur Léger de Santé VPS** | Surveillance sans démon via cron avec alertes Webhook (Telegram, Discord, Feishu) en cas de surcharge CPU/RAM/Disque. |
| [`cloudflare-tunnel-setup/`](./cloudflare-tunnel-setup/) | **Configuration de Cloudflare Tunnel** | Installation rapide de cloudflared en service systemd sans ouverture de port public entrant. |
| [`tailscale-quick-mesh/`](./tailscale-quick-mesh/) | **Réseau Mesh Rapide Tailscale** | Interconnexion chiffrée WireGuard multicloud avec routage de sous-réseau et nœud de sortie. |

---

## Conventions

- Tous les outils indépendants sont organisés dans des dossiers dédiés au format kebab-case.
- Chaque dossier comprend des scripts exécutables et une documentation multilingue.

