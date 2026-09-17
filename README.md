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

---

## Guidelines

- All standalone tools and scripts should be organized in their own self-contained directories.
- Directory names use kebab-case in lowercase English.
- Each tool directory must contain an English `README.md` (default), multilingual documentation where applicable (e.g. `README.zh-CN.md`), and executable script files.
