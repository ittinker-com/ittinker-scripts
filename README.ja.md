# ITTinker 自動化＆DevOps スクリプトツールキット

> ITTinker プラットフォーム向けのオープンソース自動化スクリプト、DevOps ワークフロー、システム運用ユーティリティ集。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## ツール一覧

| ディレクトリ | ツール名 | 概要 |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API モデル同期ツール** | アップストリームプロバイダーからのモデル同期、差分検出、スナップショットバックアップを自動化。 |
| [`vps-init/`](./vps-init/) | **VPS ワンクリック初期化** | ベアメタルから本番運用可能まで：更新、ユーザー作成、SSH 強化、ファイアウォール、BBR、fail2ban。 |
| [`vps-bench/`](./vps-bench/) | **VPS ベンチマーク集** | 15 以上の測定ツールを統合した対話型メニュー：CPU/ディスク性能、ルーティング、IP 品質、速度テスト。 |
| [`ssh-key-setup/`](./ssh-key-setup/) | **SSH 鍵セットアップウィザード** | 対話型 SSH 鍵設定：Ed25519 生成、サーバー配置、SSH Config および Agent 管理。 |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Cloudflare UFW ファイアウォール** | ポート 80/443 を公式 Cloudflare IP のみに制限する UFW 自動設定（Cron 定期更新対応）。 |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Cloudflare ドメインベストプラクティス** | ドメイン初期設定の自動化：Full Strict SSL、HSTS、www 301 リダイレクト、Cache Rules、ボット防御。 |
| [`vps-gfw-diagnose/`](./vps-gfw-diagnose/) | **VPS 接続＆アクセス制限診断** | グローバル測定ノードによる多地域診断：サーバーダウン、ポート遮断、GFW による IP 規制の識別。 |
| [`docker-quick-deploy/`](./docker-quick-deploy/) | **本番向け Docker インストーラー** | ログ容量制限（ディスク満杯防止）、live-restore、一般ユーザー権限を含む Docker CE & Compose V2 導入。 |
| [`vps-health-monitor/`](./vps-health-monitor/) | **軽量 VPS ヘルスモニター** | 常駐不要の Cron スクリプト。CPU/メモリ/ディスク制限超過時に Telegram/Discord/Feishu へ即座に通知。 |
| [`cloudflare-tunnel-setup/`](./cloudflare-tunnel-setup/) | **Cloudflare Tunnel 自動構築** | 受信ポートを一切開けずにローカルサービスを安全に公開できる cloudflared systemd 設定。 |
| [`tailscale-quick-mesh/`](./tailscale-quick-mesh/) | **Tailscale メッシュネットワーク構築** | 異なるクラウド間を WireGuard で暗号化接続。IP 転送、Pre-auth 認証、サブネットルーティング対応。 |

---

## リポジトリのガイドライン

- 各ツールは独立した kebab-case 形式のディレクトリに格納されています。
- 各ツールには実行可能なスクリプトと多言語 README ドキュメントが付属しています。

