#!/usr/bin/env bash
# ==============================================================================
# Script: setup-zone.sh
# Description: Cloudflare Domain Best-Practice Baseline Configuration Script
#              Cloudflare 指定域名最佳实践基线配置脚本
#
# 涵盖 2026 年 Cloudflare 顶级最佳实践：
# 1. SSL/TLS 严格安全：
#    - Full (Strict) 端到端严格加密
#    - HSTS 强加密保护 (max-age 6个月, includeSubDomains, nosniff)
#    - Always Use HTTPS 强制跳转
#    - Min TLS 1.2 + TLS 1.3 现代协议
#    - Automatic HTTPS Rewrites 自动修复混合内容
# 2. 规范化 301 重定向 (Canonical Redirect Rules)：
#    - 自动将 www.{domain} 永久 301 重定向至根域名 {domain} (SEO 权重归一)
# 3. 静态资产智能强缓存 (Cache Rules)：
#    - 针对 css, js, webp, avif, png, svg, fonts 等静态文件覆盖源站缓存
#    - Edge Cache 30天 + Browser Cache 7天，大幅降低源站 VPS 带宽与负载
# 4. 爬虫与安全防御 (Bot Fight Mode & WAF)：
#    - 开启 Bot Fight Mode 拦截恶意刷量脚本与爬虫
#    - 开启 Browser Integrity Check (BIC 浏览器完整性校验)
#    - 开启 Hotlink Protection 防盗链
#    - 开启 Email Obfuscation 邮箱混淆防采集
# 5. 网络加速与下一代协议：
#    - 开启 HTTP/2, HTTP/3 (QUIC), 0-RTT, Brotli, Early Hints (103)
# ==============================================================================

set -u

# === Color Settings / 终端颜色 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === Configuration & Environment Variables / 配置与环境变量 ===
CF_API_TOKEN="${CF_API_TOKEN:-}"
DOMAIN="${CF_DOMAIN:-}"
ZONE_ID="${CF_ZONE_ID:-}"

ENABLE_HSTS="${CF_ENABLE_HSTS:-true}"          # 是否开启 HSTS
REDIRECT_WWW="${CF_REDIRECT_WWW:-true}"        # 是否开启 www -> 根域名 301 重定向
SETUP_CACHE_RULES="${CF_SETUP_CACHE:-true}"     # 是否配置静态资源强缓存规则
ENABLE_BOT_FIGHT="${CF_ENABLE_BOT:-true}"       # 是否开启防爬虫/Bot Fight Mode
DRY_RUN="${DRY_RUN:-true}"
BACKUP_DIR="./cf-backup"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

# === Log Helpers / 输出函数 ===
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_step() {
    echo -e "\n${CYAN}==> $1${NC}"
}

# === Show Help / 帮助说明 ===
show_help() {
    cat << 'HELP_EOF'
Cloudflare Domain Best-Practice Setup Script / Cloudflare 域名最佳实践基线配置脚本

Usage / 用法:
  bash setup-zone.sh [OPTIONS]

Options / 选项:
  -d, --domain <domain>    Target domain name (e.g. ittinker.com) / 目标域名
  -t, --token <token>      Cloudflare API Token with Zone:Edit permissions / 具备 Zone:Edit 权限的 API Token
  -z, --zone-id <id>       (Optional) Explicit Zone ID / 可选直接传入 Zone ID
  --no-hsts                Skip HSTS configuration / 跳过 HSTS 严格传输安全配置
  --no-www-redirect        Do not create www -> apex 301 redirect rule / 跳过创建 www 跳转根域名规则
  --no-cache-rules         Do not create static asset cache rules / 跳过创建静态资源缓存优化规则
  --no-bot-fight           Do not enable bot fight mode / 跳过开启爬虫防御模式
  --apply                  Apply changes (Default is dry-run mode) / 实际生效修改（默认为预览模式）
  --dry-run                Preview proposed changes only / 仅预览将要修改的配置
  -h, --help               Show this help message / 显示帮助信息

Best Practices Covered / 包含的最佳实践:
  1. SSL/TLS & HSTS: Full Strict SSL, TLS 1.3, Min TLS 1.2, Always HTTPS, HSTS (max-age 6 months + subdomains).
  2. Canonical Redirect: Automatic 301 redirect from www.${domain} to ${domain}.
  3. Caching: Modern Cloudflare Cache Rules for static files (images, css, js, fonts) to save server bandwidth.
  4. Bot Defense: Enable Bot Fight Mode, Browser Integrity Check (BIC), and Email Obfuscation.
  5. Acceleration: Brotli compression, HTTP/3 (QUIC), 0-RTT, Early Hints.

Examples / 示例:
  1. Preview changes (Dry Run):
     bash setup-zone.sh -d ittinker.com -t "your_api_token"

  2. Apply best-practice configuration:
     bash setup-zone.sh -d ittinker.com -t "your_api_token" --apply

HELP_EOF
    exit 0
}

# === Argument Parsing / 参数解析 ===
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--domain)
                DOMAIN="$2"
                shift 2
                ;;
            -t|--token)
                CF_API_TOKEN="$2"
                shift 2
                ;;
            -z|--zone-id)
                ZONE_ID="$2"
                shift 2
                ;;
            --no-hsts)
                ENABLE_HSTS="false"
                shift
                ;;
            --no-www-redirect)
                REDIRECT_WWW="false"
                shift
                ;;
            --no-cache-rules)
                SETUP_CACHE_RULES="false"
                shift
                ;;
            --no-bot-fight)
                ENABLE_BOT_FIGHT="false"
                shift
                ;;
            --apply)
                DRY_RUN="false"
                shift
                ;;
            --dry-run)
                DRY_RUN="true"
                shift
                ;;
            -h|--help)
                show_help
                ;;
            *)
                log_error "Unknown option: $1 / 未知选项: $1"
                show_help
                ;;
        esac
    done
}

# === Preflight Checks / 预检查 ===
check_preflight() {
    if ! command -v curl >/dev/null 2>&1; then
        log_error "curl is required but not installed. / 请先安装 curl。"
        exit 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        log_error "jq is required but not installed. / 请先安装 jq。"
        echo "macOS: brew install jq"
        echo "Ubuntu/Debian: sudo apt install -y jq"
        exit 1
    fi

    if [[ -z "$CF_API_TOKEN" ]]; then
        read -p "Enter Cloudflare API Token (输入 CF API Token): " CF_API_TOKEN
    fi

    if [[ -z "$CF_API_TOKEN" ]]; then
        log_error "Cloudflare API Token is missing. / 缺少 Cloudflare API Token。"
        exit 1
    fi

    if [[ -z "$DOMAIN" && -z "$ZONE_ID" ]]; then
        read -p "Enter Target Domain (输入目标域名，如 ittinker.com): " DOMAIN
    fi

    if [[ -z "$DOMAIN" && -z "$ZONE_ID" ]]; then
        log_error "Neither Domain nor Zone ID was specified. / 必须提供域名或 Zone ID。"
        exit 1
    fi
}

# === Cloudflare API Wrapper / API 调用封装 ===
cf_api() {
    local method="$1"
    local endpoint="$2"
    local data="${3:-}"

    if [[ -n "$data" ]]; then
        curl -s -X "$method" "https://api.cloudflare.com/client/v4$endpoint" \
            -H "Authorization: Bearer $CF_API_TOKEN" \
            -H "Content-Type: application/json" \
            --data "$data"
    else
        curl -s -X "$method" "https://api.cloudflare.com/client/v4$endpoint" \
            -H "Authorization: Bearer $CF_API_TOKEN" \
            -H "Content-Type: application/json"
    fi
}

# === Resolve Zone ID / 获取 Zone ID ===
resolve_zone_id() {
    if [[ -n "$ZONE_ID" ]]; then
        log_info "Using provided Zone ID: $ZONE_ID"
        return
    fi

    log_info "Resolving Zone ID for domain: $DOMAIN ..."
    local resp
    resp=$(cf_api GET "/zones?name=$DOMAIN&status=active")

    local success
    success=$(echo "$resp" | jq -r '.success // false')

    if [[ "$success" != "true" ]]; then
        log_error "Failed to query zone. Response / 查询 Zone 失败:"
        echo "$resp" | jq . 2>/dev/null || echo "$resp"
        exit 1
    fi

    local count
    count=$(echo "$resp" | jq '.result | length')

    if [[ "$count" -eq 0 ]]; then
        log_error "No active zone found matching domain '$DOMAIN'. Please verify spelling or token permissions."
        exit 1
    fi

    ZONE_ID=$(echo "$resp" | jq -r '.result[0].id')
    DOMAIN=$(echo "$resp" | jq -r '.result[0].name')
    log_success "Found Zone ID: $ZONE_ID ($DOMAIN)"
}

# === Backup Current Settings / 备份现有设置 ===
backup_settings() {
    log_step "Backing up current domain settings / 备份当前域名配置"
    mkdir -p "$BACKUP_DIR"
    local backup_file="$BACKUP_DIR/${DOMAIN}_backup_${TIMESTAMP}.json"

    local resp
    resp=$(cf_api GET "/zones/$ZONE_ID/settings")
    local success
    success=$(echo "$resp" | jq -r '.success // false')

    if [[ "$success" == "true" ]]; then
        echo "$resp" | jq '.result' > "$backup_file"
        log_success "Backup saved to: $backup_file"
    else
        log_warn "Failed to fetch full settings list for backup. Continuing..."
    fi
}

# === Update Setting Item / 更新单个设置项 ===
apply_setting() {
    local setting_id="$1"
    local payload="$2"
    local desc="$3"

    echo -n "  - $desc ($setting_id)... "

    # 1. 查询当前值
    local current_resp
    current_resp=$(cf_api GET "/zones/$ZONE_ID/settings/$setting_id")
    local current_val
    current_val=$(echo "$current_resp" | jq -c '.result.value // null')

    local target_val
    target_val=$(echo "$payload" | jq -c '.value // null')

    if [[ "$current_val" == "$target_val" ]]; then
        echo -e "${GREEN}[ALREADY SET]${NC} (Current: $current_val)"
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[WILL CHANGE]${NC} ($current_val -> $target_val)"
        return
    fi

    # 2. 执行更新
    local patch_resp
    patch_resp=$(cf_api PATCH "/zones/$ZONE_ID/settings/$setting_id" "$payload")
    local success
    success=$(echo "$patch_resp" | jq -r '.success // false')

    if [[ "$success" == "true" ]]; then
        echo -e "${GREEN}[UPDATED]${NC} -> $target_val"
    else
        echo -e "${RED}[FAILED]${NC}"
        echo "    $(echo "$patch_resp" | jq -c '.errors // []')"
    fi
}

# === Configure HSTS / 配置 HTTP 严格传输安全 ===
configure_hsts() {
    if [[ "$ENABLE_HSTS" != "true" ]]; then
        log_info "Skipping HSTS setup as requested (--no-hsts)."
        return
    fi

    echo -n "  - HTTP Strict Transport Security (HSTS)... "
    local current_resp
    current_resp=$(cf_api GET "/zones/$ZONE_ID/settings/security_header")
    local current_enabled
    current_enabled=$(echo "$current_resp" | jq -r '.result.value.strict_transport_security.enabled // false')

    local target_payload='{
        "value": {
            "strict_transport_security": {
                "enabled": true,
                "max_age": 15552000,
                "include_subdomains": true,
                "nosniff": true
            }
        }
    }'

    if [[ "$current_enabled" == "true" ]]; then
        echo -e "${GREEN}[ALREADY ENABLED]${NC}"
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[WILL CHANGE]${NC} (enabled: true, max_age: 6 months, include_subdomains: true)"
        return
    fi

    local patch_resp
    patch_resp=$(cf_api PATCH "/zones/$ZONE_ID/settings/security_header" "$target_payload")
    local success
    success=$(echo "$patch_resp" | jq -r '.success // false')

    if [[ "$success" == "true" ]]; then
        echo -e "${GREEN}[UPDATED]${NC}"
    else
        echo -e "${RED}[FAILED]${NC}"
        echo "    $(echo "$patch_resp" | jq -c '.errors // []')"
    fi
}

# === Configure Bot Fight Mode / 配置爬虫防护 ===
configure_bot_management() {
    log_step "Bot Defense & Crawler Protection / 爬虫防护与自动化请求限制"
    if [[ "$ENABLE_BOT_FIGHT" != "true" ]]; then
        log_info "Skipping Bot Fight Mode as requested (--no-bot-fight)."
        return
    fi

    echo -n "  - Bot Fight Mode (bot_fight_mode)... "
    local current_resp
    current_resp=$(cf_api GET "/zones/$ZONE_ID/bot_management")
    local current_mode
    current_mode=$(echo "$current_resp" | jq -r '.result.fight_mode // false' 2>/dev/null)

    if [[ "$current_mode" == "true" ]]; then
        echo -e "${GREEN}[ALREADY ENABLED]${NC}"
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[WILL CHANGE]${NC} (fight_mode: false -> true)"
        return
    fi

    local put_resp
    put_resp=$(cf_api PUT "/zones/$ZONE_ID/bot_management" '{"fight_mode":true}')
    local success
    success=$(echo "$put_resp" | jq -r '.success // false')

    if [[ "$success" == "true" ]]; then
        echo -e "${GREEN}[ENABLED]${NC}"
    else
        echo -e "${YELLOW}[SKIPPED/UNSUPPORTED BY PLAN]${NC}"
    fi
}

# === Configure WWW to Apex 301 Redirect / 配置 www -> 根域名 301 重定向 ===
configure_www_redirect() {
    log_step "Canonical Redirect Rules / 规范化 301 重定向 (www -> 根域名)"
    if [[ "$REDIRECT_WWW" != "true" ]]; then
        log_info "Skipping WWW redirection as requested (--no-www-redirect)."
        return
    fi

    local rule_name="Redirect www.${DOMAIN} to ${DOMAIN}"
    echo -n "  - Redirect Rule ($rule_name)... "

    local ruleset_resp
    ruleset_resp=$(cf_api GET "/zones/$ZONE_ID/rulesets/phases/http_request_dynamic_redirect/entrypoint")
    local exists
    exists=$(echo "$ruleset_resp" | jq -r --arg name "$rule_name" '.result.rules[]? | select(.description == $name) | .id' 2>/dev/null)

    if [[ -n "$exists" ]]; then
        echo -e "${GREEN}[ALREADY EXISTS]${NC}"
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[WILL CREATE]${NC} (http.host eq \"www.${DOMAIN}\" -> https://${DOMAIN}\$1 [301 Permanent])"
        return
    fi

    local rule_payload
    rule_payload=$(jq -n \
        --arg domain "$DOMAIN" \
        --arg desc "$rule_name" \
        '{
            description: $desc,
            expression: ("(http.host eq \"www." + $domain + "\")"),
            action: "redirect",
            action_parameters: {
                from_value: {
                    status_code: 301,
                    target_url: {
                        expression: ("concat(\"https://" + $domain + "\", http.request.uri.path)")
                    },
                    preserve_query_string: true
                }
            },
            enabled: true
        }')

    local ruleset_id
    ruleset_id=$(echo "$ruleset_resp" | jq -r '.result.id // empty')

    local add_resp
    if [[ -n "$ruleset_id" ]]; then
        add_resp=$(cf_api POST "/zones/$ZONE_ID/rulesets/$ruleset_id/rules" "$rule_payload")
    else
        local create_payload
        create_payload=$(jq -n \
            --argjson rule "$rule_payload" \
            '{
                name: "Zone Dynamic Redirects",
                kind: "zone",
                phase: "http_request_dynamic_redirect",
                rules: [$rule]
            }')
        add_resp=$(cf_api POST "/zones/$ZONE_ID/rulesets" "$create_payload")
    fi

    local success
    success=$(echo "$add_resp" | jq -r '.success // false')
    if [[ "$success" == "true" ]]; then
        echo -e "${GREEN}[CREATED]${NC}"
    else
        echo -e "${RED}[FAILED]${NC}"
        echo "    $(echo "$add_resp" | jq -c '.errors // []')"
    fi
}

# === Configure Cache Rules / 配置静态资产智能强缓存 ===
configure_cache_rules() {
    log_step "Static Asset Cache Optimization / 静态资源智能缓存规则 (Cache Rules)"
    if [[ "$SETUP_CACHE_RULES" != "true" ]]; then
        log_info "Skipping Cache Rules setup as requested (--no-cache-rules)."
        return
    fi

    local rule_name="Cache Static Assets for ${DOMAIN}"
    echo -n "  - Cache Rule ($rule_name)... "

    local ruleset_resp
    ruleset_resp=$(cf_api GET "/zones/$ZONE_ID/rulesets/phases/http_request_cache_settings/entrypoint")
    local exists
    exists=$(echo "$ruleset_resp" | jq -r --arg name "$rule_name" '.result.rules[]? | select(.description == $name) | .id' 2>/dev/null)

    if [[ -n "$exists" ]]; then
        echo -e "${GREEN}[ALREADY EXISTS]${NC}"
        return
    fi

    local cache_expression='(http.request.uri.path.extension in {"css" "js" "jpg" "jpeg" "png" "webp" "avif" "gif" "ico" "svg" "woff" "woff2" "ttf" "eot" "mp4"})'

    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[WILL CREATE]${NC} (Static Extensions -> Edge Cache: 30 days, Browser Cache: 7 days)"
        return
    fi

    local rule_payload
    rule_payload=$(jq -n \
        --arg desc "$rule_name" \
        --arg expr "$cache_expression" \
        '{
            description: $desc,
            expression: $expr,
            action: "set_cache_settings",
            action_parameters: {
                cache: true,
                edge_ttl: {
                    mode: "override_origin",
                    default: 2592000
                },
                browser_ttl: {
                    mode: "override_origin",
                    default: 604800
                },
                serve_stale: {
                    disable_stale_while_revalidate: false
                },
                respect_strong_etags: true
            },
            enabled: true
        }')

    local ruleset_id
    ruleset_id=$(echo "$ruleset_resp" | jq -r '.result.id // empty')

    local add_resp
    if [[ -n "$ruleset_id" ]]; then
        add_resp=$(cf_api POST "/zones/$ZONE_ID/rulesets/$ruleset_id/rules" "$rule_payload")
    else
        local create_payload
        create_payload=$(jq -n \
            --argjson rule "$rule_payload" \
            '{
                name: "Zone Cache Rules",
                kind: "zone",
                phase: "http_request_cache_settings",
                rules: [$rule]
            }')
        add_resp=$(cf_api POST "/zones/$ZONE_ID/rulesets" "$create_payload")
    fi

    local success
    success=$(echo "$add_resp" | jq -r '.success // false')
    if [[ "$success" == "true" ]]; then
        echo -e "${GREEN}[CREATED]${NC}"
    else
        echo -e "${RED}[FAILED]${NC}"
        echo "    $(echo "$add_resp" | jq -c '.errors // []')"
    fi
}

# === Apply Baseline Configurations / 执行基线常规配置 ===
run_baseline_configuration() {
    log_step "1. SSL/TLS & Encryption Settings / SSL与安全加密"
    # SSL 严格模式（Full Strict）避免源站到CDN被劫持
    apply_setting "ssl" '{"value":"strict"}' "SSL/TLS Mode (Full Strict)"
    # 强制所有 HTTP 请求自动跳转 HTTPS
    apply_setting "always_use_https" '{"value":"on"}' "Always Use HTTPS"
    # 自动重写不安全内容 (HTTP -> HTTPS)
    apply_setting "automatic_https_rewrites" '{"value":"on"}' "Automatic HTTPS Rewrites"
    # 最低支持 TLS 1.2（禁用有安全隐患的 TLS 1.0/1.1）
    apply_setting "min_tls_version" '{"value":"1.2"}' "Minimum TLS Version (1.2)"
    # 开启 TLS 1.3 现代高加密协议
    apply_setting "tls_1_3" '{"value":"on"}' "TLS 1.3 Protocol"
    # 开启洋葱路由 (Tor 安全访问)
    apply_setting "opportunistic_onion" '{"value":"on"}' "Opportunistic Onion"
    # 配置 HSTS 严格安全传输头
    configure_hsts

    log_step "2. Security & WAF Baseline / 安全与防护基线"
    # 安全等级设置为 medium（兼顾正常用户体验与恶意识别）
    apply_setting "security_level" '{"value":"medium"}' "Security Level"
    # 开启浏览器完整性检查 (BIC - 自动识别无头浏览器/异常爬虫)
    apply_setting "browser_check" '{"value":"on"}' "Browser Integrity Check (BIC)"
    # 开启热盗链防护 (防盗链)
    apply_setting "hotlink_protection" '{"value":"on"}' "Hotlink Protection"
    # 开启邮箱防爬混淆 (页面展示邮箱自动加密防采集)
    apply_setting "email_obfuscation" '{"value":"on"}' "Email Address Obfuscation"

    log_step "3. Network Protocols & Performance / 传输协议与网络加速"
    # 开启 HTTP/2 与 HTTP/3 (QUIC) 极速协议
    apply_setting "http2" '{"value":"on"}' "HTTP/2 Protocol"
    apply_setting "http3" '{"value":"on"}' "HTTP/3 (QUIC) Protocol"
    # 开启 0-RTT 连接复用加速握手
    apply_setting "zero_rtt" '{"value":"on"}' "0-RTT Connection Resumption"
    # 开启 IPv6 兼容
    apply_setting "ipv6" '{"value":"on"}' "IPv6 Compatibility"
    # 开启 Brotli 现代高效压缩算法
    apply_setting "brotli" '{"value":"on"}' "Brotli Compression"
    # 开启早期提示 Early Hints (103)
    apply_setting "early_hints" '{"value":"on"}' "Early Hints (103)"
    # 开启 WebSockets 支持
    apply_setting "websockets" '{"value":"on"}' "WebSockets Support"
    # 伪装 IPv4 (向不支持IPv6的旧后台透传格式)
    apply_setting "pseudo_ipv4" '{"value":"off"}' "Pseudo IPv4"

    log_step "4. Cache Baseline / 常规缓存基线"
    # 默认浏览器缓存 TTL 设置为 4 小时 (14400 秒)
    apply_setting "browser_cache_ttl" '{"value":14400}' "Browser Cache TTL (4 Hours)"
    # 开启始终在线 (Always Online - 源站短时挂掉返回缓存副本)
    apply_setting "always_online" '{"value":"on"}' "Always Online"
    # 确保开发模式默认关闭
    apply_setting "development_mode" '{"value":"off"}' "Development Mode"
}

# === Print Summary / 汇总与提示 ===
print_summary() {
    echo ""
    echo "============================================================"
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}Mode: DRY RUN (Preview Only / 仅预览)${NC}"
        echo "No changes were made to Cloudflare."
        echo "To apply these best practices, run with: --apply"
        echo ""
        echo "Example: bash setup-zone.sh -d $DOMAIN -t '***' --apply"
    else
        echo -e "${GREEN}Mode: APPLIED (Production Update / 已完成更新)${NC}"
        echo "Cloudflare best-practice baseline configuration is applied successfully!"
        echo "Backup file is available at: $BACKUP_DIR"
    fi
    echo "============================================================"
}

# === Main Entrypoint / 主入口 ===
main() {
    parse_args "$@"
    check_preflight
    resolve_zone_id
    backup_settings
    run_baseline_configuration
    configure_bot_management
    configure_www_redirect
    configure_cache_rules
    print_summary
}

main "$@"
