#!/usr/bin/env bash
# ==============================================================================
# Script: deploy.sh
# Description: Production-Ready Docker & Docker Compose Installer with Best Practices
#              Docker 与 Docker Compose 生产级最佳实践一键部署工具
#
# Best Practices:
# 1. Official upstream repositories (supports automatic Mainland China mirror fallback)
# 2. Log-rotation configured by default (/etc/docker/daemon.json) to avoid disk fill-ups
# 3. Live-restore enabled (containers stay running while docker daemon updates)
# 4. Current non-root user added to docker group automatically
# ==============================================================================

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

TARGET_USER="${SUDO_USER:-$USER}"

show_help() {
    cat << 'HELP_EOF'
Production Docker & Docker Compose Installer / 生产级 Docker 一键安装配置工具

Usage / 用法:
  sudo bash deploy.sh [OPTIONS]

Options / 选项:
  --mirror <cn|official>  Choose package & registry mirror (Default: auto-detected)
  --user <username>       Target user to add to docker group (Default: current user)
  -h, --help              Show this help message

Included Best Practices:
  - Docker CE Engine + Docker Compose V2 Plugin
  - Configures /etc/docker/daemon.json with log-opts: max-size=50m, max-file=3
  - Enables live-restore to keep containers running during daemon reloads
HELP_EOF
    exit 0
}

MIRROR_CHOICE="auto"

while [[ $# -gt 0 ]]; do
    case $1 in
        --mirror)
            MIRROR_CHOICE="$2"
            shift 2
            ;;
        --user)
            TARGET_USER="$2"
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
    echo -e "${RED}Error: This script must be run as root (use sudo).${NC}"
    exit 1
fi

echo -e "${CYAN}${BOLD}"
echo "============================================================"
echo "   Production Docker & Compose Setup / Docker 最佳实践部署  "
echo "============================================================"
echo -e "${NC}"

# Detect OS
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS_ID="${ID:-}"
    OS_CODENAME="${VERSION_CODENAME:-}"
else
    echo -e "${RED}Cannot detect OS distribution.${NC}"
    exit 1
fi

echo -e "${BLUE}[1/5] Checking environment & dependencies...${NC}"
if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    apt-get update -qq
    apt-get install -y -qq apt-transport-https ca-certificates curl gnupg lsb-release
elif [[ "$OS_ID" == "centos" || "$OS_ID" == "rhel" || "$OS_ID" == "rocky" || "$OS_ID" == "almalinux" ]]; then
    yum install -y -q yum-utils
else
    echo -e "${YELLOW}Warning: Untested distribution ($OS_ID), attempting installation...${NC}"
fi

# Detect Geo location (China vs Overseas)
if [[ "$MIRROR_CHOICE" == "auto" ]]; then
    echo -n "  - Detecting server location... "
    if curl -s --max-time 3 https://www.google.com >/dev/null 2>&1; then
        MIRROR_CHOICE="official"
        echo -e "${GREEN}Overseas (Using Official Docker Upstream)${NC}"
    else
        MIRROR_CHOICE="cn"
        echo -e "${YELLOW}Mainland China detected (Using Aliyun/USTC Mirror)${NC}"
    fi
fi

echo -e "${BLUE}[2/5] Setting up Docker repository...${NC}"
if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    install -m 0755 -d /etc/apt/keyrings
    if [[ "$MIRROR_CHOICE" == "cn" ]]; then
        curl -fsSL "https://mirrors.aliyun.com/docker-ce/linux/$OS_ID/gpg" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.aliyun.com/docker-ce/linux/$OS_ID $OS_CODENAME stable" > /etc/apt/sources.list.d/docker.list
    else
        curl -fsSL "https://download.docker.com/linux/$OS_ID/gpg" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS_ID $OS_CODENAME stable" > /etc/apt/sources.list.d/docker.list
    fi
    apt-get update -qq
    echo -e "${BLUE}[3/5] Installing Docker Engine & Docker Compose...${NC}"
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
elif [[ "$OS_ID" == "centos" || "$OS_ID" == "rhel" || "$OS_ID" == "rocky" || "$OS_ID" == "almalinux" ]]; then
    if [[ "$MIRROR_CHOICE" == "cn" ]]; then
        yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    else
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    fi
    echo -e "${BLUE}[3/5] Installing Docker Engine & Docker Compose...${NC}"
    yum install -y -q docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

echo -e "${BLUE}[4/5] Applying production daemon.json best practices...${NC}"
mkdir -p /etc/docker

# Production daemon.json with log-rotation, metrics, and live-restore
cat << 'DAEMON_EOF' > /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "3"
  },
  "live-restore": true,
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 5
}
DAEMON_EOF

systemctl daemon-reload
systemctl enable --now docker

echo -e "${BLUE}[5/5] Granting non-root user permissions...${NC}"
if id "$TARGET_USER" >/dev/null 2>&1; then
    usermod -aG docker "$TARGET_USER"
    echo -e "  - Added user ${GREEN}$TARGET_USER${NC} to ${GREEN}docker${NC} group."
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 Docker & Docker Compose setup completed successfully!${NC}"
docker --version
docker compose version
echo ""
echo -e "${YELLOW}Tip: If running commands as '$TARGET_USER', run 'newgrp docker' or re-login for group changes to take effect.${NC}"
