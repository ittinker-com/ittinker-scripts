# Cloudflare ドメインベストプラクティス自動設定

> 指定したドメインに対し、Full Strict SSL、HSTS、www からの 301 リダイレクト、Cache Rules、ボット防御など本番運用に必須の設定を一括適用します。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 使い方

```bash
# プレビュー（Dry Run）
bash setup-zone.sh -d yourdomain.com -t "YOUR_CF_API_TOKEN"

# 実際に適用
bash setup-zone.sh -d yourdomain.com -t "YOUR_CF_API_TOKEN" --apply
```

---

## ライセンス

MIT © [ITTinker](https://ittinker.com)
