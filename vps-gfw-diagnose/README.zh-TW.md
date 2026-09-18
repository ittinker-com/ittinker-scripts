# VPS 連通性與被牆狀態多維診斷工具

> 專為出海開發者與維運設計的終端連通性多維自我檢測腳本。一鍵區分伺服器當機、埠防火牆攔截還是被 GFW 針對性阻斷。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 快速使用

```bash
# 1. 檢測目標 IP（預設檢測 22 埠）
bash diagnose.sh 1.2.3.4

# 2. 指定檢測埠（如 HTTPS 443 埠）
bash diagnose.sh myvps.example.com -p 443
```

---

## 開源協議

MIT © [ITTinker](https://ittinker.com)
