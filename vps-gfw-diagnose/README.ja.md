# VPS 接続＆アクセス制限多地域診断ツール

> サーバーダウン、ポート遮断、または GFW（グレートファイアウォール）による IP 規制を即座に判別できる対話型診断ツール。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 使い方

```bash
# 1. IP での診断（デフォルト: 22 番ポート）
bash diagnose.sh 1.2.3.4

# 2. 特定ポート（例: 443）の診断
bash diagnose.sh myvps.example.com -p 443
```

---

## ライセンス

MIT © [ITTinker](https://ittinker.com)
