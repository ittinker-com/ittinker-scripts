# ITTinker Scripts & Automation Toolkits

> Public automation scripts, DevOps workflows, and system utility toolkits for the ITTinker platform.

[English](README.md) | [中文说明](README.zh-CN.md)

---

## Toolkits Index

| Directory | Name | Description |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API Channel Models Sync** | Automate channel model synchronization from upstream providers with auto-diff and snapshot backup. |
| [`vps-init/`](./vps-init/) | **VPS One-Click Initialization** | Complete VPS setup from bare metal to production-ready: system update, user creation, SSH hardening, firewall, BBR, fail2ban. |
| [`vps-bench/`](./vps-bench/) | **VPS Benchmark Toolkit** | Interactive menu integrating 15+ benchmark scripts: performance, route tracing, IP quality, streaming unlock, speed test. |
| [`ssh-key-setup/`](./ssh-key-setup/) | **SSH Key Setup Wizard** | Guided SSH key configuration: generate keys, upload to servers, configure SSH Config & Agent, multi-account support. |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Cloudflare UFW Firewall** | Auto-configure UFW to only allow Cloudflare IPs on ports 80/443, with dry-run mode and weekly cron updates. |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Cloudflare Domain Best-Practice Baseline** | One-click production baseline setup for any target domain: Full Strict SSL, HSTS, 301 www-redirect, static asset Cache Rules, Bot Fight Mode. |
| [`vps-gfw-diagnose/`](./vps-gfw-diagnose/) | **VPS Connectivity & GFW Diagnostic** | Multi-region connectivity and blocking diagnostic tool to differentiate server down vs. port block vs. GFW IP blocking. |
| [`docker-quick-deploy/`](./docker-quick-deploy/) | **Production Docker Installer** | One-click installer for Docker CE & Compose V2 with production defaults (log-rotation, live-restore, non-root user group). |
| [`vps-health-monitor/`](./vps-health-monitor/) | **Zero-Dependency Health Monitor** | Cron-friendly VPS health monitoring tool with instant webhook alerts (Telegram, Discord, Feishu) when CPU/RAM/Disk limits are exceeded. |
| [`cloudflare-tunnel-setup/`](./cloudflare-tunnel-setup/) | **Cloudflare Tunnel Setup** | Fast automated installer for cloudflared systemd service, completely eliminating the need for open inbound public ports. |
| [`tailscale-quick-mesh/`](./tailscale-quick-mesh/) | **Tailscale Quick Mesh Setup** | Instant cross-cloud encrypted mesh networking setup with IP forwarding, pre-auth keys, and subnet router support. |

---

## Guidelines

- All standalone tools and scripts should be organized in their own self-contained directories.
- Directory names use kebab-case in lowercase English.
- Each tool directory must contain an English `README.md` (default), multilingual documentation where applicable (e.g. `README.zh-CN.md`), and executable script files.
