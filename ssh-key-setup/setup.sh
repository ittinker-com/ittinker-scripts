#!/usr/bin/env bash
# ==============================================================================
# SSH Key Setup & Configuration Wizard
# Description: Interactive tool to generate SSH keys, upload to server, and configure SSH config
# ==============================================================================

set -u

# === Constants & Colors / 常量与颜色 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
DEFAULT_PORT="22"
DEFAULT_USER="root"
SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"
BACKUP_CONFIG="$SSH_CONFIG.bak.$(date +%Y%m%d%H%M%S)"

# === Helper Functions / 辅助函数 ===
print_step() {
    echo -e "\n${BLUE}==> ${1}${NC}"
}

print_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

print_warning() {
    echo -e "${YELLOW}! ${1}${NC}"
}

print_error() {
    echo -e "${RED}✗ ${1}${NC}" >&2
}

die() {
    print_error "$1"
    exit 1
}

ask_yes_no() {
    local prompt="$1"
    local default_yes="${2:-true}"
    local answer

    if [ "$default_yes" = true ]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$(echo -e "${CYAN}$prompt${NC}")" answer
    answer=${answer:-$( [ "$default_yes" = true ] && echo "y" || echo "n" )}

    [[ "$answer" =~ ^[Yy]$ ]]
}

detect_os() {
    case "$(uname -s)" in
        Darwin*)    OS="macOS" ;;
        Linux*)     OS="Linux" ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*) OS="Windows" ;;
        *)          OS="Unknown" ;;
    esac
}

fix_permissions() {
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    if [ -f "$SSH_CONFIG" ]; then
        chmod 600 "$SSH_CONFIG"
    fi
}

backup_config() {
    if [ -f "$SSH_CONFIG" ]; then
        cp "$SSH_CONFIG" "$BACKUP_CONFIG"
        print_success "Backed up SSH config to $BACKUP_CONFIG"
    fi
}

# === Core Logic / 核心逻辑 ===

generate_key() {
    local key_file="${1:-}"
    
    if [ -z "$key_file" ]; then
        read -p "$(echo -e "${CYAN}Enter key purpose/label (default: default): ${NC}")" label
        label=${label:-default}
        
        if [ "$label" = "default" ]; then
            key_file="$SSH_DIR/id_ed25519"
        else
            key_file="$SSH_DIR/${label}_ed25519"
        fi
    fi

    if [ -f "$key_file" ]; then
        if ! ask_yes_no "Key $key_file already exists. Overwrite?" false; then
            print_warning "Skipping key generation."
            echo "$key_file"
            return 0
        fi
    fi

    read -p "$(echo -e "${CYAN}Enter comment (default: $USER@$(hostname)): ${NC}")" comment
    comment=${comment:-"$USER@$(hostname)"}

    print_step "Generating SSH Key Pair (Ed25519)..."
    if ssh-keygen -t ed25519 -f "$key_file" -C "$comment"; then
        chmod 600 "$key_file"
        chmod 644 "$key_file.pub"
        print_success "Generated SSH key: $key_file"
        echo "$key_file"
    else
        die "Failed to generate SSH key."
    fi
}

upload_key() {
    local key_file="$1"
    local host="$2"
    local port="${3:-$DEFAULT_PORT}"
    local user="${4:-$DEFAULT_USER}"

    print_step "Uploading Public Key to $host..."
    
    if command -v ssh-copy-id >/dev/null 2>&1; then
        if ssh-copy-id -i "$key_file.pub" -p "$port" "$user@$host"; then
            print_success "Key successfully uploaded using ssh-copy-id."
        else
            print_warning "ssh-copy-id failed, attempting manual upload..."
            manual_upload "$key_file" "$host" "$port" "$user"
        fi
    else
        manual_upload "$key_file" "$host" "$port" "$user"
    fi
}

manual_upload() {
    local key_file="$1"
    local host="$2"
    local port="$3"
    local user="$4"
    
    cat "$key_file.pub" | ssh -p "$port" "$user@$host" 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
    if [ $? -eq 0 ]; then
        print_success "Key successfully uploaded manually."
    else
        die "Failed to upload key to server."
    fi
}

update_config() {
    local key_file="$1"
    local host="$2"
    local port="$3"
    local user="$4"
    local alias

    print_step "Generating SSH Config Entry..."
    read -p "$(echo -e "${CYAN}Enter Host alias (e.g., vps1, prod, github): ${NC}")" alias
    while [ -z "$alias" ]; do
        read -p "$(echo -e "${CYAN}Host alias cannot be empty: ${NC}")" alias
    done

    backup_config
    fix_permissions

    if grep -q "^Host[[:space:]]\+$alias\b" "$SSH_CONFIG" 2>/dev/null; then
        print_warning "Host alias '$alias' already exists in $SSH_CONFIG."
        if ! ask_yes_no "Continue anyway?" true; then
            return 1
        fi
    fi

    cat >> "$SSH_CONFIG" <<EOF

Host $alias
    HostName $host
    User $user
    Port $port
    IdentityFile $key_file
    IdentitiesOnly yes
EOF

    # Add global settings if not present
    if ! grep -q "^Host \*" "$SSH_CONFIG" 2>/dev/null; then
        cat >> "$SSH_CONFIG" <<EOF

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    AddKeysToAgent yes
EOF
    fi

    print_success "Added config for '$alias' to $SSH_CONFIG"
    echo "$alias"
}

configure_agent() {
    local key_file="$1"
    
    print_step "Configuring SSH Agent..."
    detect_os
    
    if [ "$OS" = "macOS" ]; then
        # Check if ssh-add supports --apple-use-keychain
        if ssh-add -h 2>&1 | grep -q 'apple-use-keychain'; then
            ssh-add --apple-use-keychain "$key_file"
        elif ssh-add -h 2>&1 | grep -q '\-K'; then
            ssh-add -K "$key_file"
        else
            ssh-add "$key_file"
        fi
    else
        # Linux / Windows
        if [ -z "${SSH_AUTH_SOCK:-}" ]; then
            eval "$(ssh-agent -s)"
        fi
        ssh-add "$key_file"
    fi
    
    if ssh-add -l | grep -q "$(ssh-keygen -lf "$key_file" | awk '{print $2}')"; then
        print_success "Key added to SSH Agent."
    else
        print_warning "Failed to add key to SSH Agent. You might need to do it manually."
    fi
}

test_connection() {
    local alias="$1"
    
    print_step "Testing Connection to '$alias'..."
    if ssh -o BatchMode=yes -o ConnectTimeout=10 "$alias" 'echo "✅ Connected successfully as $(whoami)@$(hostname)"'; then
        print_success "Connection test passed!"
    else
        print_error "Connection test failed."
    fi
}

interactive_wizard() {
    local loop=true
    
    detect_os
    if [ "$OS" = "Windows" ]; then
        print_warning "Running on Windows (Git Bash/WSL). Make sure your SSH agent service is running."
    fi

    fix_permissions

    while $loop; do
        print_step "Step 1: Generate SSH Key Pair"
        local key_file
        key_file=$(generate_key "")
        # Remove extra text if standard output captures it
        key_file=$(echo "$key_file" | tail -n 1)

        print_step "Step 2: Upload Public Key to Server"
        local host
        read -p "$(echo -e "${CYAN}Enter server IP/hostname (leave blank to skip upload): ${NC}")" host
        
        if [ -n "$host" ]; then
            local port user
            read -p "$(echo -e "${CYAN}Enter SSH port (default: 22): ${NC}")" port
            port=${port:-$DEFAULT_PORT}
            
            read -p "$(echo -e "${CYAN}Enter remote username (default: root): ${NC}")" user
            user=${user:-$DEFAULT_USER}
            
            upload_key "$key_file" "$host" "$port" "$user"
            
            print_step "Step 3: Generate SSH Config Entry"
            local alias
            if alias=$(update_config "$key_file" "$host" "$port" "$user"); then
                alias=$(echo "$alias" | tail -n 1)
                
                print_step "Step 4: Configure SSH Agent"
                configure_agent "$key_file"
                
                print_step "Step 5: Test Connection"
                test_connection "$alias"
            fi
        else
            print_warning "Skipping server upload and config."
        fi
        
        if ! ask_yes_no "\nDo you want to configure another server?" false; then
            loop=false
        fi
    done
    
    print_step "Current SSH Config ($SSH_CONFIG):"
    if [ -f "$SSH_CONFIG" ]; then
        cat "$SSH_CONFIG"
    else
        echo "(Not found)"
    fi
    print_success "Setup complete!"
}

# === Main ===
show_help() {
    echo "Usage: bash setup.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --generate          Only generate key pair (Step 1)"
    echo "  --upload HOST       Upload key to HOST (Step 2)"
    echo "  --config            Only update SSH config (Step 3)"
    echo "  --agent             Only configure SSH Agent (Step 4)"
    echo "  --test ALIAS        Test connection to ALIAS (Step 5)"
    echo "  --key FILE          Use specific key file"
    echo "  --port PORT         SSH port (default: 22)"
    echo "  --user USER         Remote username (default: root)"
    echo "  --help              Show this help"
}

MODE="interactive"
TARGET_HOST=""
TARGET_ALIAS=""
KEY_FILE=""
PORT="$DEFAULT_PORT"
REMOTE_USER="$DEFAULT_USER"

while [[ $# -gt 0 ]]; do
    case $1 in
        --generate) MODE="generate"; shift ;;
        --upload) MODE="upload"; TARGET_HOST="$2"; shift 2 ;;
        --config) MODE="config"; shift ;;
        --agent) MODE="agent"; shift ;;
        --test) MODE="test"; TARGET_ALIAS="$2"; shift 2 ;;
        --key) KEY_FILE="$2"; shift 2 ;;
        --port) PORT="$2"; shift 2 ;;
        --user) REMOTE_USER="$2"; shift 2 ;;
        --help) show_help; exit 0 ;;
        *) print_error "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

case $MODE in
    interactive)
        interactive_wizard
        ;;
    generate)
        generate_key "$KEY_FILE"
        ;;
    upload)
        if [ -z "$KEY_FILE" ] || [ -z "$TARGET_HOST" ]; then
            die "--key and --upload HOST are required."
        fi
        upload_key "$KEY_FILE" "$TARGET_HOST" "$PORT" "$REMOTE_USER"
        ;;
    config)
        if [ -z "$KEY_FILE" ]; then
            die "--key is required for config."
        fi
        read -p "Target Host: " TARGET_HOST
        update_config "$KEY_FILE" "$TARGET_HOST" "$PORT" "$REMOTE_USER"
        ;;
    agent)
        if [ -z "$KEY_FILE" ]; then
            die "--key is required for agent config."
        fi
        configure_agent "$KEY_FILE"
        ;;
    test)
        if [ -z "$TARGET_ALIAS" ]; then
            die "--test ALIAS is required."
        fi
        test_connection "$TARGET_ALIAS"
        ;;
esac
