# Cloudflare UFW ファイアウォール自動設定

> Web トラフィック（ポート 80/443）を Cloudflare 公式の IP レンジのみに制限し、オリジンサーバーへの直接攻撃を防ぎます。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 使い方

```bash
# プレビュー
sudo bash setup.sh

# 適用および週次 Cron 登録
sudo bash setup.sh --apply --install-cron
```

---

## ライセンス

MIT © [ITTinker](https://ittinker.com)
