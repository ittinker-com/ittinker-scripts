#!/usr/bin/env bash
# ==============================================================================
# Script: monitor.sh
# Description: Zero-Dependency Lightweight VPS Health & Security Monitor
#              零依赖极简 VPS 健康检查与 Webhook 告警工具
# Supported Alerts: Telegram Bot, Discord Webhook, Feishu/Lark, Custom Webhooks
# ==============================================================================

set -u

# === Threshold Configurations / 告警阈值配置 ===
CPU_THRESHOLD="${ALERT_CPU:-85}"       # CPU % 阈值
MEM_THRESHOLD="${ALERT_MEM:-85}"       # 内存使用率 % 阈值
DISK_THRESHOLD="${ALERT_DISK:-85}"     # 磁盘使用率 % 阈值

# === Webhook Settings / 机器人推送配置 ===
TG_BOT_TOKEN="${TG_BOT_TOKEN:-}"
TG_CHAT_ID="${TG_CHAT_ID:-}"
DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"
FEISHU_WEBHOOK_URL="${FEISHU_WEBHOOK_URL:-}"
GENERIC_WEBHOOK_URL="${GENERIC_WEBHOOK_URL:-}"

HOSTNAME="$(hostname)"
IP_ADDR="$(curl -s4 --max-time 3 ifconfig.me || echo "Unknown-IP")"
DATE_STR="$(date '+%Y-%m-%d %H:%M:%S')"

# === Metrics Collection / 指标收集 ===
# 1. CPU Usage
if command -v top >/dev/null 2>&1; then
    CPU_IDLE=$(top -bn1 | grep -i "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print int($1)}')
    CPU_USAGE=$((100 - CPU_IDLE))
else
    CPU_USAGE=0
fi

# 2. Memory Usage
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
if [[ $MEM_TOTAL -gt 0 ]]; then
    MEM_USAGE=$((MEM_USED * 100 / MEM_TOTAL))
else
    MEM_USAGE=0
fi

# 3. Disk Usage (Root partition /)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

# 4. Fail2ban Banned IPs (Optional)
BANNED_COUNT=0
if command -v fail2ban-client >/dev/null 2>&1; then
    BANNED_COUNT=$(fail2ban-client status sshd 2>/dev/null | grep -i "Currently banned:" | awk '{print $4}' || echo 0)
fi

# === Check Alert Conditions / 判断是否告警 ===
ALERT_ITEMS=()

if [[ $CPU_USAGE -ge $CPU_THRESHOLD ]]; then
    ALERT_ITEMS+=("⚠️ High CPU Usage: ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)")
fi

if [[ $MEM_USAGE -ge $MEM_THRESHOLD ]]; then
    ALERT_ITEMS+=("⚠️ High Memory Usage: ${MEM_USAGE}% (Threshold: ${MEM_THRESHOLD}%)")
fi

if [[ $DISK_USAGE -ge $DISK_THRESHOLD ]]; then
    ALERT_ITEMS+=("🚨 High Disk Usage: ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)")
fi

# Print status to stdout
echo "=== VPS Health Inspection [$DATE_STR] ==="
echo "Host: $HOSTNAME ($IP_ADDR)"
echo "CPU: ${CPU_USAGE}% | Mem: ${MEM_USAGE}% | Disk: ${DISK_USAGE}% | Fail2ban Banned: $BANNED_COUNT"

if [[ ${#ALERT_ITEMS[@]} -eq 0 ]]; then
    echo "Status: All system metrics are within safe thresholds. [OK]"
    exit 0
fi

echo "Status: Threshold exceeded! Sending notification..."

# === Notification Dispatch / 消息推送分发 ===
MESSAGE="🚨 *VPS Health Alert / 服务器资源告警*
*Host:* \`${HOSTNAME}\` (\`${IP_ADDR}\`)
*Time:* ${DATE_STR}

"
for item in "${ALERT_ITEMS[@]}"; do
    MESSAGE="${MESSAGE}- ${item}
"
done
MESSAGE="${MESSAGE}
*Current Snapshot:*
CPU: ${CPU_USAGE}% | RAM: ${MEM_USAGE}% | Disk: ${DISK_USAGE}%"

# Send to Telegram
if [[ -n "$TG_BOT_TOKEN" && -n "$TG_CHAT_ID" ]]; then
    curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TG_CHAT_ID}" \
        -d parse_mode="Markdown" \
        -d text="${MESSAGE}" >/dev/null 2>&1
    echo "  - Sent to Telegram."
fi

# Send to Discord
if [[ -n "$DISCORD_WEBHOOK_URL" ]]; then
    DISCORD_PAYLOAD=$(jq -n --arg content "$MESSAGE" '{content: $content}')
    curl -s -H "Content-Type: application/json" -X POST -d "$DISCORD_PAYLOAD" "$DISCORD_WEBHOOK_URL" >/dev/null 2>&1
    echo "  - Sent to Discord."
fi

# Send to Feishu / Lark
if [[ -n "$FEISHU_WEBHOOK_URL" ]]; then
    FEISHU_PAYLOAD=$(jq -n --arg text "$MESSAGE" '{msg_type: "text", content: {text: $text}}')
    curl -s -H "Content-Type: application/json" -X POST -d "$FEISHU_PAYLOAD" "$FEISHU_WEBHOOK_URL" >/dev/null 2>&1
    echo "  - Sent to Feishu."
fi
