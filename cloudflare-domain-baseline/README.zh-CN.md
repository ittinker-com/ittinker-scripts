# Cloudflare 域名最佳实践基线自动化配置

> 一键将 Cloudflare 上任意指定域名自动化配置为生产级安全、静态资产长效缓存、www 规范化 301 重定向与恶意爬虫防御最佳实践状态。

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

---

## 为什么需要这个脚本？

每当向 Cloudflare 添加一个新域名或出海项目时，Cloudflare 默认的初始配置往往偏保守，且很多关键优化（如严格 SSL、HSTS、TLS 1.3、缓存规则、防爬虫、规范化重定向）并未开启或配置得当。

每次都在后台逐项翻找、手工点击十几个菜单页面极易疏漏。本脚本通过 Cloudflare v4 REST API，几秒钟内为指定域名注入一套 **2026 年 Cloudflare 黄金基线最佳实践**。

---

## 覆盖的 5 大最佳实践板块

### 1. SSL/TLS 严格加密与 HSTS
- **Full (Strict) 严格模式**：强制端到端双向严格加密，校验源站有效证书，根除 Cloudflare 与源站之间的中间人窃听与篡改。
- **HSTS (HTTP Strict Transport Security)**：下发严格传输安全响应头（`max-age=15552000` 即 6 个月，覆盖子域名与 `nosniff` 防嗅探）。
- **Always Use HTTPS**：全站所有 HTTP 请求自动强制升级为 HTTPS。
- **现代安全协议**：将最低 TLS 版本锁定为 **TLS 1.2**，同时激活 **TLS 1.3** 与 0-RTT 极速握手。
- **自动重写不安全内容**：自动将页面引用的 `http://` 资源转为 `https://`，避免浏览器黄色混合内容感叹号。

### 2. 规范化 301 重定向 (SEO 权重聚合)
- 自动在 Cloudflare **Dynamic Redirect Rules** 中创建一条永久 301 重定向规则：
  自动将 `www.yourdomain.com` 重定向至根域名 `yourdomain.com`（保留全部路径与 Query 参数）。
- 彻底避免外链权重分散与搜索引擎判罚重复内容（Duplicate Content）。

### 3. 静态资产智能强缓存 (Cache Rules)
- 采用最新的 Cloudflare **Cache Rules** 机制，精准匹配常见静态扩展名：
  `css, js, jpg, jpeg, png, webp, avif, gif, ico, svg, woff, woff2, ttf, eot, mp4`。
- **边缘缓存 TTL (Edge Cache)**：长达 30 天（2592000 秒），将 95% 以上的静态带宽压力阻截在 Cloudflare 边缘节点，极致节省源站 VPS 带宽与 CPU 开销。
- **浏览器端缓存 TTL (Browser Cache)**：7 天（604800 秒）。
- 开启 `stale-while-revalidate`，缓存更新期间仍然即时响应用户，后台异步刷新。

### 4. 恶意爬虫与扫描器防护 (Bot Defense)
- **Bot Fight Mode**：开启基础防爬机制，有效识别并拦截恶意爬虫、扫描脚本与资源探测器。
- **浏览器完整性检查 (BIC)**：识别请求头异常、无头浏览器与恶意爬虫特征。
- **防盗链 (Hotlink Protection)**：防止其他站恶意盗用你的图片等媒体文件。
- **邮箱混淆防采集 (Email Obfuscation)**：自动加密页面展示的邮箱链接，阻断邮箱抓取器。

### 5. 传输协议与加速优化
- **HTTP/3 (QUIC) & HTTP/2**：显著提升移动网络及弱网环境下的并发加载速度。
- **0-RTT 连接复用**：常客访问握手延迟降至 0。
- **Brotli 高效压缩**：比常规 gzip 体积缩减 15~25%。
- **早期提示 Early Hints (103)**：在源站准备 HTML 期间提前通知浏览器预加载 CSS/JS。

---

## 运行环境与依赖

- `bash` (4.0+)
- `curl`
- `jq`
- 具备以下权限的 Cloudflare API Token：
  - `Zone:Read`
  - `Zone:Edit`
  - `Zone Settings:Edit`
  - `Ruleset:Edit`

---

## 快速上手

### 1. 预览模式（Dry Run - 仅检查，不改动）
```bash
bash setup-zone.sh -d yourdomain.com -t "YOUR_CLOUDFLARE_API_TOKEN"
```

### 2. 正式生效（Apply - 写入 Cloudflare）
```bash
bash setup-zone.sh -d yourdomain.com -t "YOUR_CLOUDFLARE_API_TOKEN" --apply
```

---

## 命令行参数一览

| 参数标志 | 说明 | 默认行为 |
| :--- | :--- | :--- |
| `-d, --domain <name>` | 目标域名（如 `ittinker.com`） | 未指定时交互式提示 |
| `-t, --token <token>` | Cloudflare API Token | 未指定时交互式提示 |
| `-z, --zone-id <id>` | 指定 Zone ID（可选，默认按域名自动获取） | 自动获取 |
| `--apply` | 确认写入并更新配置到 Cloudflare | 默认仅预览 (Dry Run) |
| `--dry-run` | 仅比对并输出拟变更项 | 默认开启 |
| `--no-hsts` | 跳过配置 HSTS 响应头 | 默认配置 |
| `--no-www-redirect` | 跳过创建 `www` 到根域名的 301 重定向 | 默认创建 |
| `--no-cache-rules` | 跳过创建静态资源强缓存 Cache Rules | 默认创建 |
| `--no-bot-fight` | 跳过开启 Bot Fight Mode 爬虫防护 | 默认开启 |
| `-h, --help` | 查看帮助文档 | - |

---

## 自动快照备份

在对域名做任何修改之前，脚本会自动将该域名现有的所有设置导出备份至：
```
./cf-backup/<domain>_backup_<timestamp>.json
```
随时可以比对历史状态或查阅初始配置。

---

## 开源协议

MIT © [ITTinker](https://ittinker.com)
