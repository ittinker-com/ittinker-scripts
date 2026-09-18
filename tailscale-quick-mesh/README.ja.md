# Tailscale クイックメッシュ＆サブネットルーター構築

> Tailscale のワンクリック導入、Linux カーネル IP 転送の有効化、およびサブネットルーター（Subnet Router）設定を自動化します。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 使い方

```bash
# 通常セットアップ
sudo bash mesh.sh

# 認証キーとサブネットルートを指定した自動セットアップ
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## ライセンス

MIT © [ITTinker](https://ittinker.com)
