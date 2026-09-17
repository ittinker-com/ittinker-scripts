# Cloudflare Domain Best-Practice Baseline Setup

> One-click script to apply production-grade security, caching, canonical 301 redirection, and crawler defense best practices for any target domain on Cloudflare.

[English](README.md) | [中文说明](README.zh-CN.md)

---

## Why This Tool?

When adding a new domain to Cloudflare, the default settings leave several critical performance and security optimizations disabled (or set to sub-optimal defaults). 

Manually clicking through dozens of Cloudflare dashboard panels for every new project or domain is error-prone. This tool automates the **2026 Cloudflare Best-Practice Baseline** via the Cloudflare v4 API in seconds.

---

## Best Practices Covered

### 1. SSL/TLS & Strict Security
- **Full (Strict) Mode**: Enforces end-to-end encryption with valid origin SSL certificates, preventing man-in-the-middle attacks between Cloudflare and your origin server.
- **HSTS (HTTP Strict Transport Security)**: Enforces HTTPS in browsers with `max-age=15552000` (6 months), `includeSubDomains`, and `nosniff`.
- **Always Use HTTPS**: Automatically redirects all insecure `http://` requests to `https://`.
- **Modern TLS Version**: Sets minimum TLS version to **TLS 1.2** and activates **TLS 1.3** for faster cryptographic handshakes.
- **Automatic HTTPS Rewrites**: Eliminates mixed-content warnings by rewriting insecure HTTP resources.

### 2. Canonical 301 Redirect Rules (SEO Optimization)
- Automatically provisions Cloudflare **Dynamic Redirect Rules** to 301 permanently redirect `www.example.com` to `example.com` (preserving URI paths and query strings).
- Prevents domain authority fragmentation and search engine duplicate content issues.

### 3. Static Asset Cache Rules (Bandwidth & Speed)
- Automatically adds modern **Cache Rules** targeting static extensions:
  `css, js, jpg, jpeg, png, webp, avif, gif, ico, svg, woff, woff2, ttf, eot, mp4`.
- **Edge Cache TTL**: 30 days (2,592,000s) to absorb >95% of asset traffic at the edge.
- **Browser Cache TTL**: 7 days (604,800s).
- Enables `stale-while-revalidate` to serve cache while asynchronously refreshing in the background.

### 4. Crawler & Bot Defense
- **Bot Fight Mode**: Blocks and challenges automated malicious bots, content scrapers, and aggressive scan engines.
- **Browser Integrity Check (BIC)**: Evaluates HTTP headers to detect malicious scrapers and abusive automated traffic.
- **Hotlink Protection**: Prevents third-party websites from leeching your images and media bandwidth.
- **Email Address Obfuscation**: Scrambles on-page mailto addresses to prevent spam harvesting bots.

### 5. Next-Gen Network Acceleration
- **HTTP/3 (QUIC)** and **HTTP/2**: Maximizes multiplexing and resilience over packet-loss networks.
- **0-RTT Connection Resumption**: Accelerates return-visitor handshake latency.
- **Brotli Compression**: Outperforms gzip by 15-25% for HTML, CSS, and JS payloads.
- **Early Hints (Status Code 103)**: Preloads critical assets while the server prepares page responses.

---

## Requirements

- `bash` (4.0+)
- `curl`
- `jq`
- Cloudflare API Token with permissions:
  - `Zone:Read`
  - `Zone:Edit`
  - `Zone Settings:Edit`
  - `Ruleset:Edit`

---

## Quick Start

### 1. Dry Run (Preview Changes safely)
```bash
bash setup-zone.sh -d yourdomain.com -t "YOUR_CLOUDFLARE_API_TOKEN"
```

### 2. Apply Best Practices
```bash
bash setup-zone.sh -d yourdomain.com -t "YOUR_CLOUDFLARE_API_TOKEN" --apply
```

---

## CLI Options

| Flag | Description | Default |
| :--- | :--- | :--- |
| `-d, --domain <name>` | Target domain name (e.g. `ittinker.com`) | Prompt if empty |
| `-t, --token <token>` | Cloudflare API Token | Prompt if empty |
| `-z, --zone-id <id>` | Explicit Zone ID (optional, fetched automatically) | Auto |
| `--apply` | Apply changes to production Cloudflare Zone | False |
| `--dry-run` | Preview proposed changes without modifying anything | True |
| `--no-hsts` | Skip HSTS configuration | False |
| `--no-www-redirect` | Skip creating `www` -> root 301 redirect rule | False |
| `--no-cache-rules` | Skip creating static asset Cache Rules | False |
| `--no-bot-fight` | Skip enabling Bot Fight Mode | False |
| `-h, --help` | Display help screen | - |

---

## Automatic Backups

Before making any modifications, the script automatically dumps the full zone settings to:
```
./cf-backup/<domain>_backup_<timestamp>.json
```
You can revert or inspect your prior state at any time.

---

## License

MIT © [ITTinker](https://ittinker.com)
