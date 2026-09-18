# Cloudflare Tunnel 一键自动部署工具

> 一键下载最新版 cloudflared 并注册为 systemd 守护进程。彻底免除服务器开放任何入站端口，零公网暴露安全穿透。

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

---

## 为什么推荐使用 Cloudflare Tunnel？

- **0 端口暴露**：不需要在防火墙开放 80 / 443 甚至 22 端口，所有连接均由本机主动向 Cloudflare 建立加密出站。
- **无公网 IP 穿透**：家里的 NAS、开发笔记本或廉价没有公网 IP 的机器，随时随地接入自定义域名。
- **防止 IP 封锁与探测**：黑客扫描扫不到源站真实端口与 IP。

---

## 快速使用

```bash
sudo bash setup.sh --token "你的Cloudflare_Tunnel_Token"
```

---

## 开源协议

MIT © [ITTinker](https://ittinker.com)
