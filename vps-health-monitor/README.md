# Zero-Dependency VPS Health & Alert Monitor

> Lightweight, cron-friendly Bash monitoring tool with multi-channel webhook alerts (Telegram, Discord, Feishu) when CPU, Memory, or Disk limits are breached.

[English](README.md) | [中文说明](README.zh-CN.md)

---

## Why This Tool?

Full-fledged monitoring stacks like Prometheus, Grafana, or Datadog consume significant memory and setup time, which is overkill for developers managing 2 to 10 VPS instances.

`monitor.sh` requires zero background daemon memory:
- Runs in milliseconds via cron.
- Collects real-time CPU, RAM, Disk, and Fail2ban ban counts.
- Dispatches alert cards only when safety thresholds are breached.

---

## Usage

### 1. Test Run Locally
```bash
# Provide Webhook environment variable
export TG_BOT_TOKEN="123456:ABC-DEF"
export TG_CHAT_ID="12345678"
# Or: export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
# Or: export FEISHU_WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/..."

bash monitor.sh
```

### 2. Add to Crontab (Runs every 10 minutes)
```bash
(crontab -l 2>/dev/null; echo "*/10 * * * * ALERT_CPU=90 TG_BOT_TOKEN=\"xxx\" TG_CHAT_ID=\"yyy\" /path/to/monitor.sh > /dev/null 2>&1") | crontab -
```

---

## License

MIT © [ITTinker](https://ittinker.com)
