# Cloudflare 網域名稱最佳實踐基準自動化配置

> 一鍵將 Cloudflare 上任意指定網域名稱自動化配置為生產級安全、靜態資產長效快取、www 規範化 301 重新導向與惡意爬蟲防禦最佳實踐狀態。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 快速使用

```bash
# 預覽模式
bash setup-zone.sh -d yourdomain.com -t "YOUR_CF_API_TOKEN"

# 正式生效
bash setup-zone.sh -d yourdomain.com -t "YOUR_CF_API_TOKEN" --apply
```

---

## 開源協議

MIT © [ITTinker](https://ittinker.com)
