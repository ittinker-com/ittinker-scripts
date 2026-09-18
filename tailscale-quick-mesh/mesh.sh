#!/usr/bin/env bash
# ==============================================================================
# Script: mesh.sh
# Description: One-Click Tailscale VPN & Subnet Router Installer
#              Tailscale 虚拟专用内网一键安装与子网路由配置工具
# ==============================================================================

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

AUTH_KEY="${TAILSCALE_AUTH_KEY:-}"
ADVERTISE_ROUTES=""
EXIT_NODE=false

show_help() {
    cat << 'HELP_EOF'
Tailscale Quick Mesh Setup / Tailscale 虚拟网组网一键工具

Usage / 用法:
  sudo bash mesh.sh [OPTIONS]

Options / 选项:
  --authkey <KEY>         Tailscale Pre-authenticated Key for headless setup
  --advertise-routes <CIDR> Advertise subnet routes (e.g. 192.168.1.0/24)
  --exit-node             Advertise this device as an exit node
  -h, --help              Show this help message
HELP_EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --authkey)
            AUTH_KEY="$2"
            shift 2
            ;;
        --advertise-routes)
            ADVERTISE_ROUTES="$2"
            shift 2
            ;;
        --exit-node)
            EXIT_NODE=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            shift
            ;;
    esac
done

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Error: Please run as root (sudo bash mesh.sh).${NC}"
    exit 1
fi

echo -e "${CYAN}${BOLD}"
echo "============================================================"
echo "    Tailscale Mesh & Subnet Setup / Tailscale 一键组网      "
echo "============================================================"
echo -e "${NC}"

echo -e "${BLUE}[1/3] Enabling Linux IP Forwarding (内核转发支持)...${NC}"
if ! grep -q "net.ipv4.ip_forward = 1" /etc/sysctl.conf; then
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
fi
if ! grep -q "net.ipv6.conf.all.forwarding = 1" /etc/sysctl.conf; then
    echo "net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
fi
sysctl -p >/dev/null 2>&1

echo -e "${BLUE}[2/3] Installing Tailscale...${NC}"
if ! command -v tailscale >/dev/null 2>&1; then
    curl -fsSL https://tailscale.com/install.sh | sh
fi

echo -e "${BLUE}[3/3] Bringing up Tailscale node...${NC}"
CMD="tailscale up --accept-routes"

if [[ -n "$AUTH_KEY" ]]; then
    CMD="$CMD --authkey=$AUTH_KEY"
fi

if [[ -n "$ADVERTISE_ROUTES" ]]; then
    CMD="$CMD --advertise-routes=$ADVERTISE_ROUTES"
fi

if [[ "$EXIT_NODE" == true ]]; then
    CMD="$CMD --advertise-exit-node"
fi

eval "$CMD"

echo ""
echo -e "${GREEN}${BOLD}🎉 Tailscale node is successfully initialized!${NC}"
tailscale ip -4
