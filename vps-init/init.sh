#!/usr/bin/env bash
# ==============================================================================
# vps-init - Complete VPS Initialization Script
# ITTinker Scripts (https://github.com/ittinker-com/ittinker-scripts)
# ==============================================================================

set -u

# === Variables & Colors ===
# 变量和颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

USERNAME="${VPS_USER:-ittinker}"
SSH_PORT="${VPS_PORT:-22000}"
TIMEZONE="${VPS_TZ:-Asia/Shanghai}"
SKIP_CONFIRM="${VPS_YES:-0}"
STEP_RUN="${VPS_STEP:-0}"
LOG_FILE="/var/log/vps-init-$(date +%Y%m%d_%H%M%S).log"

# === Functions ===
# 函数定义
log() {
    echo -e "${CYAN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "SUCCESS: $1" >> "$LOG_FILE"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    echo "ERROR: $1" >> "$LOG_FILE"
    exit 1
}

warn() {
    echo -e "${YELLOW}⚠️ $1${NC}"
    echo "WARN: $1" >> "$LOG_FILE"
}

info() {
    echo -e "${CYAN}🔄 $1${NC}"
    echo "INFO: $1" >> "$LOG_FILE"
}

confirm() {
    if [ "$SKIP_CONFIRM" -eq 1 ]; then
        return 0
    fi
    read -p "$1 [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}

ask_input() {
    local prompt=$1
    local default_val=$2
    local var_name=$3
    if [ "$SKIP_CONFIRM" -eq 1 ]; then
        eval $var_name=\"$default_val\"
        return
    fi
    read -p "$prompt [$default_val]: " input_val
    if [ -z "$input_val" ]; then
        eval $var_name=\"$default_val\"
    else
        eval $var_name=\"$input_val\"
    fi
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "Please run as root (请使用 root 权限运行)"
    fi
}

check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
            error "Unsupported OS: $ID (仅支持 Ubuntu/Debian)"
        fi
        log "Detected OS (检测到系统): $PRETTY_NAME"
    else
        error "Cannot detect OS (无法检测系统)"
    fi
}

backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        cp -a "$file" "${file}.bak.$(date +%Y%m%d%H%M%S)"
        log "Backed up $file (已备份 $file)"
    fi
}

# === Steps ===
# 执行步骤

step_1() {
    info "Step 1: System Update (系统更新)"
    log "Running apt update && apt full-upgrade..."
    apt update >> "$LOG_FILE" 2>&1
    apt full-upgrade -y >> "$LOG_FILE" 2>&1
    apt autoremove -y >> "$LOG_FILE" 2>&1
    apt autoclean >> "$LOG_FILE" 2>&1
    success "System updated (系统更新完成)"
    
    if [ -f /var/run/reboot-required ]; then
        warn "Reboot required after script completion! (完成后需要重启服务器！)"
    fi
}

step_2() {
    info "Step 2: Install Essential Tools (安装必备工具)"
    log "Installing curl, wget, git, vim, htop, tree, unzip, net-tools, ufw, fail2ban..."
    apt install -y sudo curl wget git vim htop tree unzip net-tools ufw fail2ban >> "$LOG_FILE" 2>&1
    success "Essential tools installed (必备工具安装完成)"
}

step_3() {
    info "Step 3: Create Non-root User (创建普通用户)"
    ask_input "Enter username (输入用户名)" "$USERNAME" "USERNAME"
    
    if id "$USERNAME" &>/dev/null; then
        warn "User $USERNAME already exists (用户 $USERNAME 已存在)"
    else
        log "Creating user $USERNAME..."
        adduser --gecos "" "$USERNAME"
        usermod -aG sudo "$USERNAME"
        success "User $USERNAME created and added to sudo group (用户已创建并加入 sudo 组)"
        
        if su - "$USERNAME" -c 'sudo whoami' | grep -q root; then
            success "Sudo access verified (Sudo 权限验证成功)"
        else
            warn "Sudo access verification failed (Sudo 权限验证失败)"
        fi
    fi
}

step_4() {
    info "Step 4: SSH Hardening (SSH 安全加固)"
    
    ask_input "Enter new SSH port (输入新 SSH 端口 1024-65535)" "$SSH_PORT" "SSH_PORT"
    if ! [[ "$SSH_PORT" =~ ^[0-9]+$ ]] || [ "$SSH_PORT" -lt 1024 ] || [ "$SSH_PORT" -gt 65535 ]; then
        warn "Invalid port, using default 22000 (无效端口，使用默认值 22000)"
        SSH_PORT=22000
    fi
    
    local passwd_auth="no"
    if ! confirm "Disable Password Authentication? (禁用密码登录？推荐/Recommended)"; then
        passwd_auth="yes"
    fi
    
    local sshd_config="/etc/ssh/sshd_config"
    backup_file "$sshd_config"
    
    log "Configuring SSH..."
    
    sed -i 's/^#*Port .*/Port '"$SSH_PORT"'/' "$sshd_config"
    if ! grep -q "^Port $SSH_PORT" "$sshd_config"; then echo "Port $SSH_PORT" >> "$sshd_config"; fi
    
    sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' "$sshd_config"
    if ! grep -q "^PermitRootLogin no" "$sshd_config"; then echo "PermitRootLogin no" >> "$sshd_config"; fi
    
    sed -i 's/^#*PubkeyAuthentication .*/PubkeyAuthentication yes/' "$sshd_config"
    if ! grep -q "^PubkeyAuthentication yes" "$sshd_config"; then echo "PubkeyAuthentication yes" >> "$sshd_config"; fi
    
    sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication '"$passwd_auth"'/' "$sshd_config"
    if ! grep -q "^PasswordAuthentication $passwd_auth" "$sshd_config"; then echo "PasswordAuthentication $passwd_auth" >> "$sshd_config"; fi
    
    sed -i 's/^#*Protocol .*/Protocol 2/' "$sshd_config"
    if ! grep -q "^Protocol 2" "$sshd_config"; then echo "Protocol 2" >> "$sshd_config"; fi

    sed -i 's/^#*MaxAuthTries .*/MaxAuthTries 3/' "$sshd_config"
    if ! grep -q "^MaxAuthTries 3" "$sshd_config"; then echo "MaxAuthTries 3" >> "$sshd_config"; fi
    
    sed -i 's/^#*ClientAliveInterval .*/ClientAliveInterval 300/' "$sshd_config"
    if ! grep -q "^ClientAliveInterval 300" "$sshd_config"; then echo "ClientAliveInterval 300" >> "$sshd_config"; fi
    
    sed -i 's/^#*ClientAliveCountMax .*/ClientAliveCountMax 2/' "$sshd_config"
    if ! grep -q "^ClientAliveCountMax 2" "$sshd_config"; then echo "ClientAliveCountMax 2" >> "$sshd_config"; fi
    
    systemctl restart sshd
    success "SSH configured (SSH 配置完成)"
    warn "IMPORTANT: Do NOT close your current terminal! Open a new one and verify you can login via port $SSH_PORT before exiting! (重要：请勿关闭当前终端！退出前请新开终端验证是否能通过 $SSH_PORT 端口登录！)"
}

step_5() {
    info "Step 5: Configure UFW Firewall (配置 UFW 防火墙)"
    log "Configuring UFW rules..."
    ufw --force reset >> "$LOG_FILE" 2>&1
    ufw default deny incoming >> "$LOG_FILE" 2>&1
    ufw default allow outgoing >> "$LOG_FILE" 2>&1
    ufw allow "$SSH_PORT"/tcp comment 'SSH' >> "$LOG_FILE" 2>&1
    ufw allow 80/tcp comment 'HTTP' >> "$LOG_FILE" 2>&1
    ufw allow 443/tcp comment 'HTTPS' >> "$LOG_FILE" 2>&1
    ufw --force enable >> "$LOG_FILE" 2>&1
    success "UFW configured and enabled (UFW 防火墙配置并启用)"
}

step_6() {
    info "Step 6: Enable BBR (开启 BBR 拥塞控制)"
    local current_bbr
    current_bbr=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | awk '{print $3}')
    
    if [ "$current_bbr" == "bbr" ]; then
        success "BBR is already enabled (BBR 已开启)"
    else
        log "Enabling BBR..."
        if ! grep -q "net.core.default_qdisc=fq" /etc/sysctl.conf; then
            echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        fi
        if ! grep -q "net.ipv4.tcp_congestion_control=bbr" /etc/sysctl.conf; then
            echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        fi
        sysctl -p >> "$LOG_FILE" 2>&1
        
        if lsmod | grep -q bbr; then
            success "BBR enabled successfully (BBR 开启成功)"
        else
            warn "BBR module loaded but not visible in lsmod. Verify with 'sysctl net.ipv4.tcp_congestion_control'"
        fi
    fi
}

step_7() {
    info "Step 7: Configure fail2ban (配置 fail2ban 防护)"
    if [ ! -f /etc/fail2ban/jail.conf ]; then
        error "fail2ban not installed properly (fail2ban 未正确安装)"
    fi
    
    backup_file "/etc/fail2ban/jail.local"
    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    
    log "Configuring sshd jail..."
    mkdir -p /etc/fail2ban/jail.d
    cat <<EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = $SSH_PORT
maxretry = 3
bantime = 3600
findtime = 600
EOF

    systemctl restart fail2ban
    systemctl enable fail2ban >> "$LOG_FILE" 2>&1
    success "fail2ban configured (fail2ban 配置完成)"
}

step_8() {
    info "Step 8: Set Timezone (设置时区)"
    ask_input "Enter timezone (输入时区)" "$TIMEZONE" "TIMEZONE"
    log "Setting timezone to $TIMEZONE..."
    if timedatectl set-timezone "$TIMEZONE" >> "$LOG_FILE" 2>&1; then
        success "Timezone set to $TIMEZONE (时区已设置为 $TIMEZONE)"
    else
        warn "Failed to set timezone. You may need to run 'dpkg-reconfigure tzdata'"
    fi
}

show_help() {
    cat << EOF
Usage: sudo bash init.sh [OPTIONS]

Options:
  --step N        Run only step N (1-8)
  --user NAME     Set username (default: ittinker)
  --port PORT     Set SSH port (default: 22000)
  --tz TIMEZONE   Set timezone (default: Asia/Shanghai)
  --yes           Skip confirmations
  --help          Show this help
EOF
    exit 0
}

# === Main ===
main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --step)
                STEP_RUN="$2"
                shift 2
                ;;
            --user)
                USERNAME="$2"
                shift 2
                ;;
            --port)
                SSH_PORT="$2"
                shift 2
                ;;
            --tz)
                TIMEZONE="$2"
                shift 2
                ;;
            --yes)
                SKIP_CONFIRM=1
                shift
                ;;
            --help)
                show_help
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                ;;
        esac
    done

    check_root
    
    # Initialize log
    touch "$LOG_FILE"
    chmod 600 "$LOG_FILE"
    log "Starting vps-init script..."
    
    check_os

    if [ "$STEP_RUN" -ne 0 ]; then
        if [[ "$STEP_RUN" -ge 1 && "$STEP_RUN" -le 8 ]]; then
            "step_$STEP_RUN"
        else
            error "Invalid step number: $STEP_RUN (无效的步骤号: 1-8)"
        fi
    else
        info "Running all initialization steps (运行全部初始化步骤)"
        step_1
        step_2
        step_3
        step_4
        step_5
        step_6
        step_7
        step_8
        success "VPS Initialization Complete! (VPS 初始化完成！)"
        echo -e "${CYAN}Check $LOG_FILE for details (查看 $LOG_FILE 获取详细日志)${NC}"
    fi
}

main "$@"
