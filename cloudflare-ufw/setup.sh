#!/usr/bin/env bash
set -u

# === Colors / 颜色 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# === Configuration / 配置 ===
COMMENT_TAG="Cloudflare"
URL_V4="https://www.cloudflare.com/ips-v4"
URL_V6="https://www.cloudflare.com/ips-v6"

# State variables
DRY_RUN=true
ACTION="update"
INSTALL_CRON=false

# === Functions / 功能函数 ===

show_help() {
    echo "Usage: sudo bash setup.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run          Preview changes without applying (default)"
    echo "  --apply            Apply changes to UFW rules"
    echo "  --install-cron     Also install weekly cron job"
    echo "  --remove           Remove all Cloudflare UFW rules"
    echo "  --remove-cron      Remove the cron job"
    echo "  --status           Show current Cloudflare UFW rules"
    echo "  --help             Show this help"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}ERROR: Please run as root (use sudo). / 错误：请以 root 身份运行（使用 sudo）。${NC}"
        exit 1
    fi
}

check_ufw() {
    if ! command -v ufw >/dev/null 2>&1; then
        echo -e "${RED}ERROR: UFW is not installed. / 错误：未安装 UFW。${NC}"
        exit 1
    fi
    if ! ufw status | grep -q "Status: active"; then
        echo -e "${YELLOW}WARNING: UFW is not active. Please enable it with 'ufw enable' before or after setup. / 警告：UFW 未启用。${NC}"
    fi
}

fetch_ips() {
    echo -e "${BLUE}Fetching Cloudflare IPs... / 获取 Cloudflare IP...${NC}"
    CF_IPV4=$(curl -sL --max-time 10 "$URL_V4")
    CF_IPV6=$(curl -sL --max-time 10 "$URL_V6")

    if [ -z "$CF_IPV4" ] || [ -z "$CF_IPV6" ]; then
        echo -e "${RED}ERROR: Failed to fetch Cloudflare IPs. / 错误：获取 IP 失败。${NC}"
        exit 1
    fi

    # Basic validation: ensure format looks somewhat like IPs
    if ! echo "$CF_IPV4" | grep -qE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"; then
        echo -e "${RED}ERROR: Invalid IPv4 data received. / 错误：接收到的 IPv4 数据无效。${NC}"
        exit 1
    fi
    if ! echo "$CF_IPV6" | grep -qE ":"; then
        echo -e "${RED}ERROR: Invalid IPv6 data received. / 错误：接收到的 IPv6 数据无效。${NC}"
        exit 1
    fi
    echo -e "${GREEN}Successfully fetched IPs. / 成功获取 IP 列表。${NC}"
}

show_status() {
    echo -e "${BLUE}Current Cloudflare UFW Rules: / 当前 Cloudflare UFW 规则：${NC}"
    ufw status numbered | grep "$COMMENT_TAG" || echo -e "${YELLOW}No Cloudflare rules found. / 未找到相关规则。${NC}"
}

remove_rules() {
    local rules
    # Retrieve matching rule numbers. awk/sed combination extracts the ID safely.
    rules=$(ufw status numbered | grep "$COMMENT_TAG" | awk -F'[][]' '{print $2}' | sed 's/ //g' | sort -rn)
    
    local count=0
    for rule_num in $rules; do
        if [ "$DRY_RUN" = true ]; then
            echo -e "${YELLOW}[DRY-RUN]${NC} Would delete rule number: $rule_num"
        else
            ufw --force delete "$rule_num" >/dev/null
            echo -e "${GREEN}Deleted rule number: $rule_num${NC}"
        fi
        count=$((count+1))
    done
    echo -e "${BLUE}Total rules removed: $count${NC}"
}

add_rules() {
    local count=0
    for ip in $CF_IPV4 $CF_IPV6; do
        if [ "$DRY_RUN" = true ]; then
            echo -e "${YELLOW}[DRY-RUN]${NC} Would add rule: allow from $ip to any port 80,443 proto tcp comment '$COMMENT_TAG'"
        else
            ufw allow from "$ip" to any port 80,443 proto tcp comment "$COMMENT_TAG" >/dev/null
        fi
        count=$((count+1))
    done
    echo -e "${BLUE}Total rules added: $count${NC}"

    if [ "$DRY_RUN" = false ]; then
        echo -e "${BLUE}Reloading UFW... / 正在重载 UFW...${NC}"
        ufw reload >/dev/null
    fi
}

manage_cron() {
    local SCRIPT_PATH
    SCRIPT_PATH=$(readlink -f "$0")
    local CRON_CMD="0 0 * * 1 $SCRIPT_PATH --apply > /dev/null 2>&1"

    if [ "$ACTION" = "remove_cron" ]; then
        if crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
            crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" | crontab -
            echo -e "${GREEN}Cron job removed. / 定时任务已移除。${NC}"
        else
            echo -e "${YELLOW}No cron job found. / 未找到定时任务。${NC}"
        fi
    elif [ "$INSTALL_CRON" = true ]; then
        if crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
            echo -e "${YELLOW}Cron job already exists. / 定时任务已存在。${NC}"
        else
            (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
            echo -e "${GREEN}Cron job installed (Weekly on Monday 00:00). / 定时任务已安装（每周一 00:00 执行）。${NC}"
        fi
    fi
}

# === Main / 主程序 ===

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true; shift ;;
        --apply) DRY_RUN=false; shift ;;
        --install-cron) INSTALL_CRON=true; shift ;;
        --remove) ACTION="remove"; shift ;;
        --remove-cron) ACTION="remove_cron"; shift ;;
        --status) ACTION="status"; shift ;;
        --help|-h) show_help; exit 0 ;;
        *) echo -e "${RED}Unknown option: $1${NC}"; show_help; exit 1 ;;
    esac
done

check_root

if [ "$ACTION" = "status" ]; then
    check_ufw
    show_status
    exit 0
fi

if [ "$ACTION" = "remove_cron" ]; then
    manage_cron
    exit 0
fi

check_ufw

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}==============================================${NC}"
    echo -e "${YELLOW}   DRY-RUN MODE / 试运行模式 (NO CHANGES)    ${NC}"
    echo -e "${YELLOW}==============================================${NC}"
fi

if [ "$ACTION" = "remove" ]; then
    echo -e "\n${BLUE}--- Removing rules / 移除规则 ---${NC}"
    remove_rules
    if [ "$DRY_RUN" = true ]; then
        echo -e "\n${YELLOW}Dry-run completed. Run with '--apply --remove' to make changes. / 试运行结束，添加 '--apply --remove' 以应用更改。${NC}"
    fi
    exit 0
fi

if [ "$ACTION" = "update" ]; then
    fetch_ips
    echo -e "\n${BLUE}--- Removing old rules / 移除旧规则 ---${NC}"
    remove_rules
    echo -e "\n${BLUE}--- Adding new rules / 添加新规则 ---${NC}"
    add_rules
fi

manage_cron

if [ "$DRY_RUN" = true ]; then
    echo -e "\n${YELLOW}Dry-run completed. Run with '--apply' to make changes. / 试运行结束，添加 '--apply' 以应用更改。${NC}"
else
    echo -e "\n${GREEN}Successfully applied Cloudflare UFW rules! / Cloudflare UFW 规则应用成功！${NC}"
fi
