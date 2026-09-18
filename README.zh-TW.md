# ITTinker 自動化與維運腳本工具箱

> 面向 ITTinker 平台的開源自動化腳本、DevOps 工作流與日常維運工具集合。

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [Русский](README.ru.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Français](README.fr.md)

---

## 工具目錄清單

| 工具目錄 | 工具名稱 | 簡要說明 |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API 渠道模型同步腳本** | 自動從上游探針獲取最新可用模型，支援精確對比分析、Dry Run 預演與快照備份。 |
| [`vps-init/`](./vps-init/) | **VPS 一鍵初始化腳本** | 從裸機到生產可用的完整初始化：系統更新、使用者建立、SSH 加固、防火牆、BBR 加速、fail2ban 防暴力破解。 |
| [`vps-bench/`](./vps-bench/) | **VPS 評測工具箱** | 互動式選單整合 15+ 評測腳本：綜合效能、回程路由、IP 品質、串流解鎖、三網測速。 |
| [`ssh-key-setup/`](./ssh-key-setup/) | **SSH 金鑰一鍵配置** | 引導式 SSH 金鑰配置：生成金鑰、上傳到伺服器、配置 SSH Config 與 Agent、多帳號支援。 |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Cloudflare UFW 防火牆配置** | 自動配置 UFW 僅允許 Cloudflare IP 存取 80/443 埠，支援預覽模式與每週定時更新。 |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Cloudflare 網域名稱最佳實踐基準配置** | 一鍵為指定網域名稱注入生產級黃金配置：Full Strict 嚴格 SSL、HSTS 回應頭、www 規範化 301 重新導向、靜態資源強快取、Bot 防爬。 |
| [`vps-gfw-diagnose/`](./vps-gfw-diagnose/) | **VPS 連通性與被牆多維自我檢測** | 終端聯動全球分散式探針，快速區分伺服器當機、埠防火牆攔截與 GFW 針對性阻斷。 |
| [`docker-quick-deploy/`](./docker-quick-deploy/) | **生產級 Docker 環境一鍵部署** | 自動安裝最新 Docker CE & Compose V2，自帶日誌限額輪轉、免停機平滑重載與普通使用者組免 sudo。 |
| [`vps-health-monitor/`](./vps-health-monitor/) | **零依賴極簡健康監控告警** | 純原生 Bash 編寫，超閾值自動觸發 Telegram / Discord / 飛書 告警，資源佔用近乎為零。 |
| [`cloudflare-tunnel-setup/`](./cloudflare-tunnel-setup/) | **Cloudflare Tunnel 自動穿透部署** | 一鍵安裝 cloudflared 並註冊為 systemd 守護行程，免向公網開放任何入站埠。 |
| [`tailscale-quick-mesh/`](./tailscale-quick-mesh/) | **Tailscale 極速組網與子網路由** | 一鍵跨雲組建 WireGuard 虛擬內網，支援免密碼自動入網與子網路由 (Subnet Router) 廣播。 |
| [`supabase-usage-guard/`](./supabase-usage-guard/) | **Supabase Health & Egress Guard** | 360° health diagnostic suite: audits slow queries, missing indexes, table bloat, and top egress consumer SQL. |

---

## 規範約定

- 每個獨立工具或維運工作流程存放於各自專用的子目錄中。
- 目錄名採用全小寫加橫線（kebab-case）的英文命名規則。
- 每個工具目錄均配備多語言說明文件，並具備可執行的腳本檔案。

