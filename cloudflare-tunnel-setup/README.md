# Cloudflare Tunnel (cloudflared) One-Click Setup

> Effortlessly install and configure Cloudflare Tunnel as a persistent systemd daemon without opening any inbound ports or exposing your origin IP.

[English](README.md) | [中文说明](README.zh-CN.md)

---

## Why Use Cloudflare Tunnel?

- **Zero Inbound Ports**: Completely eliminates the need to expose ports 80, 443, or 22 to the public internet.
- **NAT / Home Lab Friendly**: Expose local services behind CGNAT (home NAS, Raspberry Pi, local Docker containers) with full SSL.
- **GFW / Port Block Bypassing**: Route traffic encrypted over Cloudflare's outbound edge network.

---

## Quick Start

```bash
sudo bash setup.sh --token "YOUR_TUNNEL_TOKEN"
```

---

## License

MIT © [ITTinker](https://ittinker.com)
