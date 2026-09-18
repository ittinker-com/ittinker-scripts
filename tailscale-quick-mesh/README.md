# Tailscale Quick Mesh & Subnet Router Setup

> One-click script to install Tailscale, enable Linux kernel IP forwarding, and effortlessly configure mesh networking, subnet routing, and exit nodes.

[English](README.md) | [中文说明](README.zh-CN.md)

---

## Why Tailscale for Indie Developers?

- **Direct End-to-End Encryption**: Securely connect VPS instances across different clouds (AWS, DO, Vultr, Contabo) without exposing public SSH ports.
- **NAT / Firewall Traversal**: Access home servers or local development environments anywhere in the world.
- **MagicDNS**: SSH into `vps1` or `nas` via plain hostnames instead of tracking dynamic IPs.

---

## Quick Start

```bash
# Basic setup
sudo bash mesh.sh

# Headless setup with Auth Key & Subnet routing
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## License

MIT © [ITTinker](https://ittinker.com)
