#!/usr/bin/env bash
# ==============================================================================
# Script: setup.sh
# Description: One-Click Cloudflare Tunnel (cloudflared) Automated Setup
#              Cloudflare Tunnel 一键穿透与 systemd 守护服务部署工具
# ==============================================================================

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

TUNNEL_TOKEN="${CF_TUNNEL_TOKEN:-}"

show_help() {
    cat << 'HELP_EOF'
Cloudflare Tunnel One-Click Setup / Cloudflare Tunnel 一键部署工具

Usage / 用法:
  sudo bash setup.sh [OPTIONS]

Options / 选项:
  -t, --token <TOKEN>    Cloudflare Tunnel Token from Zero Trust dashboard
  -h, --help             Show this help message

Steps executed:
  1. Detect architecture and install latest cloudflared binary
  2. Install cloudflared as a systemd service using your Tunnel Token
  3. Enable and start the service (auto-restarts on reboot)
HELP_EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--token)
            TUNNEL_TOKEN="$2"
            shift 2
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
    echo -e "${RED}Error: Please run as root (sudo bash setup.sh).${NC}"
    exit 1
fi

echo -e "${CYAN}${BOLD}"
echo "============================================================"
echo "    Cloudflare Tunnel (cloudflared) Automated Setup         "
echo "============================================================"
echo -e "${NC}"

# Detect Architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64)  CLOUDFLARED_ARCH="amd64" ;;
    aarch64|arm64) CLOUDFLARED_ARCH="arm64" ;;
    armv7l)  CLOUDFLARED_ARCH="arm" ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}[1/3] Downloading latest cloudflared binary (${CLOUDFLARED_ARCH})...${NC}"
BIN_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${CLOUDFLARED_ARCH}"

curl -fsSL -o /usr/local/bin/cloudflared "$BIN_URL"
chmod +x /usr/local/bin/cloudflared

echo -e "  - Installed: $(/usr/local/bin/cloudflared --version)"

if [[ -z "$TUNNEL_TOKEN" ]]; then
    echo ""
    echo -e "${YELLOW}Please enter your Cloudflare Tunnel Token.${NC}"
    echo -e "Obtain it from: Cloudflare Zero Trust Dashboard -> Networks -> Tunnels"
    read -p "Tunnel Token: " TUNNEL_TOKEN
fi

if [[ -z "$TUNNEL_TOKEN" ]]; then
    echo -e "${RED}Error: Tunnel token cannot be empty.${NC}"
    exit 1
fi

echo -e "${BLUE}[2/3] Installing cloudflared system service...${NC}"
/usr/local/bin/cloudflared service install "$TUNNEL_TOKEN"

echo -e "${BLUE}[3/3] Starting cloudflared service...${NC}"
systemctl daemon-reload
systemctl enable --now cloudflared

echo ""
echo -e "${GREEN}${BOLD}🎉 Cloudflare Tunnel installed and running successfully!${NC}"
systemctl status cloudflared --no-pager | head -10
