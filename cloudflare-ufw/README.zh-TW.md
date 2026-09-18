# Cloudflare UFW 防火牆自動配置

> 自動配置 UFW 僅允許 Cloudflare 官方 IP 範圍存取 80/443 埠，支援每週 Cron 定時同步。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 快速使用

```bash
# 預覽
sudo bash setup.sh

# 生效並安裝定時任務
sudo bash setup.sh --apply --install-cron
```

---

## 開源協議

MIT © [ITTinker](https://ittinker.com)
