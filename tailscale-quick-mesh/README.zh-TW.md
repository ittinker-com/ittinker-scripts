# Tailscale 極速組網與子網路由器一鍵配置

> 一鍵安裝 Tailscale、開啟 Linux 核心 IP 轉發、支援無密碼 Pre-auth Key 免互動入網與子網路由 (Subnet Router) 廣播。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 快速使用

```bash
# 1. 互動式安裝
sudo bash mesh.sh

# 2. 自動化入網並廣播區域網路網段
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## 開源協議

MIT © [ITTinker](https://ittinker.com)
