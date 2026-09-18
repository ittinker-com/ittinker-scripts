#!/usr/bin/env bash
# ==============================================================================
# Script: diagnose.sh
# Description: Multi-Region VPS Connectivity & GFW Blocking Diagnostic Tool
#              VPS 连通性与“被墙”多维自检工具
# Documentation: https://ittinker.com/
# Repository: https://github.com/ittinker-com/ittinker-scripts
# ==============================================================================

set -u

# === Colors / 终端颜色 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

TARGET_HOST=""
TARGET_PORT="22"

# === Show Help / 帮助说明 ===
show_help() {
    cat << 'HELP_EOF'
VPS Connectivity & GFW Blocking Diagnostic Tool / VPS 连通性与被墙多维自检工具

Usage / 用法:
  bash diagnose.sh <TARGET_IP_OR_DOMAIN> [OPTIONS]

Options / 选项:
  -p, --port <port>    Target port to probe (Default: 22 / 默认 22 端口)
  -h, --help           Show this help message / 显示帮助信息

Examples / 示例:
  bash diagnose.sh 1.2.3.4
  bash diagnose.sh myvps.example.com -p 443

Diagnostic Steps / 诊断流程:
  1. Local Connectivity (本地连通性): Ping (ICMP) + TCP Port Handshake
  2. Multi-Region Global Probe (全球多节点探针):
     Queries public measurement nodes across China, North America, Europe, and Asia.
  3. Intelligent Verdict (智能归因判断):
     - Differentiate Server Down vs Port Blocked vs GFW IP Blocking.
HELP_EOF
    exit 0
}

# === Argument Parsing / 参数解析 ===
if [[ $# -eq 0 ]]; then
    show_help
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -p|--port)
            TARGET_PORT="$2"
            shift 2
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            ;;
        *)
            if [[ -z "$TARGET_HOST" ]]; then
                TARGET_HOST="$1"
            fi
            shift
            ;;
    esac
done

if [[ -z "$TARGET_HOST" ]]; then
    echo -e "${RED}Error: Target IP or domain must be specified.${NC}"
    exit 1
fi

# === Header / 横幅 ===
echo -e "${CYAN}${BOLD}"
echo "============================================================"
echo "    ITTinker VPS Connectivity & Blocking Diagnostic Tool   "
echo "    VPS 连通性与被墙状态多维诊断工具                        "
echo "============================================================"
echo -e "${NC}"
echo -e "Target / 目标: ${YELLOW}${TARGET_HOST}${NC} | Port / 端口: ${YELLOW}${TARGET_PORT}${NC}"
echo -e "Timestamp / 时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# === Step 1: Local Diagnostics / 本地连通性测试 ===
echo -e "${BLUE}${BOLD}[Phase 1] Local Machine Probing / 本地连通性探测${NC}"

# 1.1 ICMP Ping Test
echo -n "  - ICMP Ping (本地 Ping 测试)... "
if ping -c 3 -W 2 "$TARGET_HOST" >/dev/null 2>&1; then
    LOCAL_PING_OK="true"
    echo -e "${GREEN}[OK / 连通]${NC}"
else
    LOCAL_PING_OK="false"
    echo -e "${RED}[FAILED / 超时或阻断]${NC}"
fi

# 1.2 TCP Port Handshake Test
echo -n "  - TCP Port $TARGET_PORT Handshake (本地端口探测)... "
TCP_TEST_SUCCESS="false"
if command -v nc >/dev/null 2>&1; then
    if nc -z -w 3 "$TARGET_HOST" "$TARGET_PORT" >/dev/null 2>&1; then
        TCP_TEST_SUCCESS="true"
    fi
elif command -v curl >/dev/null 2>&1; then
    if curl -s --connect-timeout 3 "telnet://${TARGET_HOST}:${TARGET_PORT}" </dev/null >/dev/null 2>&1; then
        TCP_TEST_SUCCESS="true"
    fi
fi

if [[ "$TCP_TEST_SUCCESS" == "true" ]]; then
    LOCAL_TCP_OK="true"
    echo -e "${GREEN}[OK / 端口开放]${NC}"
else
    LOCAL_TCP_OK="false"
    echo -e "${RED}[FAILED / 端口无法连接]${NC}"
fi

echo ""

# === Step 2: Global Region Simulation (Globalping / API) ===
echo -e "${BLUE}${BOLD}[Phase 2] Multi-Region Global Status / 全球分布式节点探针探测${NC}"
echo -e "  Querying global public probes via Globalping network..."

GLOBALPING_API="https://api.globalping.io/v1/measurements"

run_globalping() {
    local target="$1"
    local proto="$2" # ping or tcp
    local port="${3:-}"

    local payload
    if [[ "$proto" == "ping" ]]; then
        payload=$(cat << JSON_EOF
{
  "limit": 6,
  "target": "$target",
  "type": "ping",
  "locations": [
    {"country": "CN"},
    {"country": "US"},
    {"country": "DE"},
    {"country": "JP"}
  ]
}
JSON_EOF
)
    else
        payload=$(cat << JSON_EOF
{
  "limit": 6,
  "target": "$target",
  "type": "tcp",
  "measurementOptions": {"port": $port},
  "locations": [
    {"country": "CN"},
    {"country": "US"},
    {"country": "DE"},
    {"country": "JP"}
  ]
}
JSON_EOF
)
    fi

    local create_resp
    create_resp=$(curl -s -X POST "$GLOBALPING_API" -H "Content-Type: application/json" -d "$payload")
    local measurement_id
    measurement_id=$(echo "$create_resp" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)

    if [[ -z "$measurement_id" ]]; then
        return 1
    fi

    # Poll for result (wait up to 6s)
    local i=0
    local result=""
    while [[ $i -lt 6 ]]; do
        sleep 1
        result=$(curl -s "$GLOBALPING_API/$measurement_id")
        local status
        status=$(echo "$result" | grep -o '"status":"[^"]*' | head -1 | cut -d'"' -f4)
        if [[ "$status" == "finished" ]]; then
            break
        fi
        i=$((i + 1))
    done

    echo "$result"
}

API_AVAILABLE="false"
CN_PING_OK="false"
OVERSEA_PING_OK="false"
CN_TCP_OK="false"
OVERSEA_TCP_OK="false"

if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    PING_RES=$(run_globalping "$TARGET_HOST" "ping" || echo "")
    if [[ -n "$PING_RES" ]]; then
        API_AVAILABLE="true"

        # Check results
        CN_PASS_COUNT=$(echo "$PING_RES" | jq '[.results[]? | select(.probe.country == "CN" and .result.status == "finished" and (.result.stats.rcv // 0) > 0)] | length')
        OVERSEA_PASS_COUNT=$(echo "$PING_RES" | jq '[.results[]? | select(.probe.country != "CN" and .result.status == "finished" and (.result.stats.rcv // 0) > 0)] | length')

        if [[ "$CN_PASS_COUNT" -gt 0 ]]; then CN_PING_OK="true"; fi
        if [[ "$OVERSEA_PASS_COUNT" -gt 0 ]]; then OVERSEA_PING_OK="true"; fi

        echo -e "  - 中国大陆 ICMP Ping: $( [[ "$CN_PING_OK" == "true" ]] && echo -e "${GREEN}✓ 畅通${NC}" || echo -e "${RED}✗ 超时/阻断${NC}" )"
        echo -e "  - 海外多国 ICMP Ping: $( [[ "$OVERSEA_PING_OK" == "true" ]] && echo -e "${GREEN}✓ 畅通${NC}" || echo -e "${RED}✗ 超时/未响应${NC}" )"

        # TCP Check
        TCP_RES=$(run_globalping "$TARGET_HOST" "tcp" "$TARGET_PORT" || echo "")
        if [[ -n "$TCP_RES" ]]; then
            CN_TCP_PASS=$(echo "$TCP_RES" | jq '[.results[]? | select(.probe.country == "CN" and .result.status == "finished")] | length')
            OVERSEA_TCP_PASS=$(echo "$TCP_RES" | jq '[.results[]? | select(.probe.country != "CN" and .result.status == "finished")] | length')

            if [[ "$CN_TCP_PASS" -gt 0 ]]; then CN_TCP_OK="true"; fi
            if [[ "$OVERSEA_TCP_PASS" -gt 0 ]]; then OVERSEA_TCP_OK="true"; fi

            echo -e "  - 中国大陆 TCP 端口 $TARGET_PORT: $( [[ "$CN_TCP_OK" == "true" ]] && echo -e "${GREEN}✓ 可连通${NC}" || echo -e "${RED}✗ 阻断/关闭${NC}" )"
            echo -e "  - 海外多国 TCP 端口 $TARGET_PORT: $( [[ "$OVERSEA_TCP_OK" == "true" ]] && echo -e "${GREEN}✓ 可连通${NC}" || echo -e "${RED}✗ 阻断/关闭${NC}" )"
        fi
    fi
fi

if [[ "$API_AVAILABLE" != "true" ]]; then
    echo -e "  ${YELLOW}Notice: Online global probe API rate-limited or unavailable. Fallback to local heuristic.${NC}"
fi

echo ""

# === Step 3: Diagnostic Verdict / 综合智能归因分析 ===
echo -e "${CYAN}${BOLD}[Phase 3] Diagnostic Verdict & Recommendations / 诊断结论与建议${NC}"
echo "------------------------------------------------------------"

if [[ "$API_AVAILABLE" == "true" ]]; then
    if [[ "$OVERSEA_PING_OK" == "true" || "$OVERSEA_TCP_OK" == "true" ]]; then
        if [[ "$CN_PING_OK" == "false" && "$CN_TCP_OK" == "false" ]]; then
            echo -e "${RED}${BOLD}🚨 诊断结论：IP 极大概率已被 GFW 针对性阻断（被墙）！${NC}"
            echo -e "   [特征]: 海外多国均可连通，但中国大陆所有探测节点全线超时中断。"
            echo -e "   [建议解决方案]:"
            echo -e "   1. 联系 VPS 服务商后台提交工单申请更换 IP（部分商户付费或免费更换）。"
            echo -e "   2. 避免裸跑敏感服务，将域名接入 Cloudflare CDN 隐藏源站 IP。"
            echo -e "   3. 使用 Cloudflare Tunnel 或 Tailscale/WireGuard 搭建内网加密通道穿透访问。"
        elif [[ "$CN_PING_OK" == "true" && "$CN_TCP_OK" == "false" ]]; then
            echo -e "${YELLOW}${BOLD}⚠️ 诊断结论：IP 未被墙，但特定端口（$TARGET_PORT）被封锁或防火墙未放行！${NC}"
            echo -e "   [特征]: ICMP Ping 正常，但目标 TCP 端口中国大陆连不上。"
            echo -e "   [建议解决方案]:"
            echo -e "   1. 检查服务器防火墙: 确认 UFW / iptables 是否放行该端口 (`sudo ufw status`)。"
            echo -e "   2. 检查云服务商安全组 (Security Group) 是否在出入站规则放行该端口。"
            echo -e "   3. 若为 SSH (22 端口)，尝试修改为 1024-65535 之间的高位非标端口。"
        else
            echo -e "${GREEN}${BOLD}🎉 诊断结论：VPS 国内外连接状态正常，未被封锁！${NC}"
            echo -e "   若本地仍然无法连接，请重点检查本地局域网代理、本地 SSH 密钥或 ISP 运营商局部网络波动。"
        fi
    else
        echo -e "${RED}${BOLD}⚠️ 诊断结论：服务器宕机 (Down) 或机房网络全线中断！${NC}"
        echo -e "   [特征]: 海外节点与国内节点均完全无法连通（全球全红）。"
        echo -e "   [建议解决方案]:"
        echo -e "   1. 登录 VPS 服务商后台（Vultr / DO / 阿里云等），查看实例是否处于 Running 状态。"
        echo -e "   2. 使用 VNC 网页控制台登录服务器，排查系统内核是否假死或 OOM 崩溃。"
        echo -e "   3. 检查机房是否有停电或网络维护公告。"
    fi
else
    # Fallback to local verdict
    if [[ "$LOCAL_PING_OK" == "true" && "$LOCAL_TCP_OK" == "true" ]]; then
        echo -e "${GREEN}✓ 本地 Ping 与 TCP 握手均正常，当前无阻断迹象。${NC}"
    elif [[ "$LOCAL_PING_OK" == "false" && "$LOCAL_TCP_OK" == "false" ]]; then
        echo -e "${YELLOW}⚠️ 本地无法连通目标服务器。建议打开 https://ping.pe 或 https://www.itdog.cn 输入 IP 查看海外与国内对比。${NC}"
    fi
fi
echo "------------------------------------------------------------"
