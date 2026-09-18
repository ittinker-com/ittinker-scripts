# VPS Connectivity & GFW Blocking Diagnostic Tool

> Multi-region connectivity and blocking diagnostic tool for indie hackers and sysadmins to instantly differentiate whether a VPS is down, firewalled, or blocked by the GFW.

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## Why This Tool?

When your VPS suddenly becomes unreachable, developers often panic and jump to conclusions:
- Did the server crash or reboot?
- Is my SSH configuration broken?
- Did my firewall lock me out?
- Or has the IP address been targeted and blocked by the Great Firewall (GFW)?

Instead of guessing or manually checking multiple online ping websites, `diagnose.sh` runs multi-region probing (China vs. US/EU/Asia) directly from your terminal and delivers an instant diagnosis.

---

## Diagnostic Matrix

| Local Ping | China Nodes | Overseas Nodes | Port Test | Verdict & Action |
| :--- | :--- | :--- | :--- | :--- |
| ❌ Failed | ❌ Failed | ✅ OK | ❌ Blocked in CN | **IP Blocked (被墙)**: Request new IP from provider or route via Cloudflare Tunnel / CDN. |
| ✅ OK | ✅ OK | ✅ OK | ❌ Failed | **Port Blocked or Closed**: Check UFW/iptables and cloud provider security groups. |
| ❌ Failed | ❌ Failed | ❌ Failed | ❌ Failed | **Server Down / Offline**: Check provider dashboard, hypervisor status, or reboot instance. |
| ✅ OK | ✅ OK | ✅ OK | ✅ OK | **Healthy**: Issue is likely local DNS/proxy configuration or client SSH keys. |

---

## Usage

```bash
# 1. Probe by IP (Default Port: 22)
bash diagnose.sh 1.2.3.4

# 2. Probe specific port (e.g. HTTPS 443)
bash diagnose.sh myvps.example.com -p 443
```

---

## License

MIT © [ITTinker](https://ittinker.com)
