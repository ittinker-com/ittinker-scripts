#!/usr/bin/env bash
# ==============================================================================
# Script: bench.sh
# Description: ITTinker VPS Benchmark Toolkit (15+ tools in 1)
# Documentation: https://ittinker.com/posts/20260110-vps-benchmark-scripts-guide/
# ==============================================================================

# Treat unset variables as errors
set -u

# === Color Settings / 颜色设置 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

LOG_FILE="vps-bench-$(date +%Y%m%d_%H%M%S).log"
SWAP_FILE="/swapfile_bench"
SWAP_CREATED=0

log() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

err() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# === Preflight Checks / 环境检查 ===
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        return 1
    fi
    return 0
}

check_deps() {
    log "Checking dependencies... / 检查依赖..."
    local deps=("curl" "wget")
    local pkg_manager=""

    if command -v apt-get >/dev/null 2>&1; then
        pkg_manager="apt-get install -y"
    elif command -v yum >/dev/null 2>&1; then
        pkg_manager="yum install -y"
    fi

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            warn "$dep is missing."
            if check_root; then
                if [ -n "$pkg_manager" ]; then
                    log "Installing $dep... / 安装 $dep..."
                    $pkg_manager "$dep"
                else
                    err "Unknown package manager. Please install $dep manually."
                    exit 1
                fi
            else
                err "Please install $dep manually or run as root."
                exit 1
            fi
        fi
    done
}

# === Swap Helper / Swap 辅助功能 ===
setup_swap() {
    log "Setting up 2GB swap for heavy tests (GeekBench)... / 配置2GB Swap防止OOM..."
    if check_root; then
        if [ ! -f "$SWAP_FILE" ]; then
            fallocate -l 2G "$SWAP_FILE" 2>/dev/null || dd if=/dev/zero of="$SWAP_FILE" bs=1M count=2048 2>/dev/null
            chmod 600 "$SWAP_FILE"
            mkswap "$SWAP_FILE" >/dev/null 2>&1
            swapon "$SWAP_FILE" >/dev/null 2>&1
            SWAP_CREATED=1
            log "Swap created successfully."
        else
            log "Swap already exists."
        fi
    else
        warn "Not root, skipping swap creation. YABS might fail on low RAM VPS."
    fi
}

cleanup_swap() {
    if [ "$SWAP_CREATED" -eq 1 ]; then
        log "Cleaning up temporary swap... / 清理临时 Swap..."
        swapoff "$SWAP_FILE" >/dev/null 2>&1
        rm -f "$SWAP_FILE"
        SWAP_CREATED=0
        log "Swap cleaned up."
    fi
}

# === Reference Values / 参考标准 ===
show_reference() {
    echo -e "${CYAN}========================================================================${NC}"
    echo -e "${CYAN}                     VPS Benchmark Reference Values                     ${NC}"
    echo -e "${CYAN}========================================================================${NC}"
    echo -e " ${YELLOW}Disk I/O:${NC}    < 100MB/s (Poor) | 100-300MB/s (Avg) | > 500MB/s (Good)"
    echo -e " ${YELLOW}GeekBench 6:${NC} < 500 (Poor)     | 500-1000 (Avg)    | > 1500 (Good)"
    echo -e " ${YELLOW}Latency:${NC}     < 50ms (Local)   | < 150ms (Global)  | > 200ms (Slow)"
    echo -e "${CYAN}========================================================================${NC}"
    echo ""
}

# === Test Functions / 测试功能 ===
run_test_1() { log "Running bench.sh..."; wget -qO- bench.sh | bash 2>&1 | tee -a "$LOG_FILE"; }
run_test_2() { log "Running SuperBench..."; wget -qO- git.io/superbench.sh | bash 2>&1 | tee -a "$LOG_FILE"; }
run_test_3() { log "Running YABS..."; setup_swap; curl -sL yabs.sh | bash 2>&1 | tee -a "$LOG_FILE"; cleanup_swap; }
run_test_4() { log "Running LemonBench..."; wget -qO- https://raw.githubusercontent.com/LemonBench/LemonBench/main/LemonBench.sh | bash -s -- --full 2>&1 | tee -a "$LOG_FILE"; }
run_test_5() { log "Running 融合怪 ecs.sh..."; bash <(wget -qO- bash.spiritlhl.net/ecs) 2>&1 | tee -a "$LOG_FILE"; }
run_test_6() { log "Running UnixBench..."; wget --no-check-certificate https://github.com/teddysun/across/raw/master/unixbench.sh && chmod +x unixbench.sh && ./unixbench.sh 2>&1 | tee -a "$LOG_FILE"; rm -f unixbench.sh; }

run_test_7() { log "Running backtrace..."; curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh 2>&1 | tee -a "$LOG_FILE"; }
run_test_8() { log "Running mtr_trace..."; curl https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh | bash 2>&1 | tee -a "$LOG_FILE"; }
run_test_9() { log "Running NextTrace..."; curl nxtrace.org/nt | bash 2>&1 | tee -a "$LOG_FILE"; }

run_test_10() { log "Running IP.Check.Place..."; bash <(curl -Ls IP.Check.Place) 2>&1 | tee -a "$LOG_FILE"; }
run_test_11() { log "Running ipcheck.ing..."; bash <(curl -sL ipcheck.ing) 2>&1 | tee -a "$LOG_FILE"; }
run_test_12() { log "Running RegionRestrictionCheck..."; bash <(curl -L -s check.unlock.media) 2>&1 | tee -a "$LOG_FILE"; }
run_test_13() { log "Running MediaUnlockTest..."; bash <(curl -Ls unlock.moe) 2>&1 | tee -a "$LOG_FILE"; }

run_test_14() { log "Running AutoSpeed..."; bash <(curl -sL bash.icu/speedtest) 2>&1 | tee -a "$LOG_FILE"; }
run_test_15() { 
    log "Running Speedtest CLI..."
    if command -v speedtest-cli >/dev/null 2>&1; then
        speedtest-cli 2>&1 | tee -a "$LOG_FILE"
    elif command -v speedtest >/dev/null 2>&1; then
        speedtest 2>&1 | tee -a "$LOG_FILE"
    else
        warn "Speedtest CLI not found. Please install it first."
    fi
}

run_quick() {
    log "Running Quick Combo..."
    run_test_1
    run_test_7
    run_test_10
}

run_all() {
    log "Running ALL Tests..."
    for i in {1..15}; do
        "run_test_$i"
    done
}

run_test_by_num() {
    local num=$1
    if [[ "$num" -ge 1 && "$num" -le 15 ]]; then
        "run_test_$num"
    else
        err "Invalid test number: $num"
    fi
}

# === Menu UI / 菜单界面 ===
show_menu() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║       ITTinker VPS Benchmark Toolkit v1.0        ║${NC}"
    echo -e "${CYAN}║       https://ittinker.com                       ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║                                                  ║${NC}"
    echo -e "${CYAN}║  === Comprehensive Performance 综合性能 ===       ║${NC}"
    echo -e "${CYAN}║   1) bench.sh          Classic / 经典测试         ║${NC}"
    echo -e "${CYAN}║   2) SuperBench         China Speed / 国内测速    ║${NC}"
    echo -e "${CYAN}║   3) YABS              GeekBench / 跑分           ║${NC}"
    echo -e "${CYAN}║   4) LemonBench        Full Test / 柠檬全测        ║${NC}"
    echo -e "${CYAN}║   5) 融合怪 ecs.sh      All-in-One / 最全能 ⭐     ║${NC}"
    echo -e "${CYAN}║   6) UnixBench         CPU Only / CPU专测          ║${NC}"
    echo -e "${CYAN}║                                                  ║${NC}"
    echo -e "${CYAN}║  === Route Tracing 回程路由 ===                    ║${NC}"
    echo -e "${CYAN}║   7) backtrace         Quick Route / 快速路由 ⭐   ║${NC}"
    echo -e "${CYAN}║   8) mtr_trace         3-Network / 三网路由        ║${NC}"
    echo -e "${CYAN}║   9) NextTrace         Detailed / 详细路由          ║${NC}"
    echo -e "${CYAN}║                                                  ║${NC}"
    echo -e "${CYAN}║  === IP & Streaming IP质量 & 流媒体 ===            ║${NC}"
    echo -e "${CYAN}║  10) IP.Check.Place    IP Quality / IP质量 ⭐      ║${NC}"
    echo -e "${CYAN}║  11) ipcheck.ing       IP Check / IP检测           ║${NC}"
    echo -e "${CYAN}║  12) Streaming Check   Unlock Test / 流媒体解锁    ║${NC}"
    echo -e "${CYAN}║  13) MediaUnlockTest   More Platforms / 更多平台    ║${NC}"
    echo -e "${CYAN}║                                                  ║${NC}"
    echo -e "${CYAN}║  === Speed Test 测速 ===                           ║${NC}"
    echo -e "${CYAN}║  14) AutoSpeed         3-Network / 三网测速         ║${NC}"
    echo -e "${CYAN}║  15) Speedtest CLI     Official / 官方测速           ║${NC}"
    echo -e "${CYAN}║                                                  ║${NC}"
    echo -e "${CYAN}║  === Quick Combos 快捷组合 ===                     ║${NC}"
    echo -e "${CYAN}║  Q) Quick Test         bench.sh + backtrace + IP  ║${NC}"
    echo -e "${CYAN}║  A) Run ALL            Complete Report / 完整报告   ║${NC}"
    echo -e "${CYAN}║                                                  ║${NC}"
    echo -e "${CYAN}║  0) Exit / 退出                                   ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_help() {
    echo "Usage: bash bench.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --quick       Run quick combo (bench.sh + backtrace + IP check)"
    echo "  --all         Run all tests sequentially"
    echo "  --test N      Run specific test number (1-15)"
    echo "  --help        Show this help"
}

# === Main Entry / 主程序 ===
main() {
    if [[ $# -gt 0 ]]; then
        check_deps
        case "$1" in
            --quick)
                run_quick
                exit 0
                ;;
            --all)
                run_all
                exit 0
                ;;
            --test)
                if [[ $# -eq 2 ]]; then
                    run_test_by_num "$2"
                else
                    err "--test requires a test number"
                fi
                exit 0
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                err "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    fi

    check_deps
    
    while true; do
        show_menu
        read -p "Please select an option (0-15, Q, A): " choice
        case "$choice" in
            1|2|3|4|5|6|7|8|9|10|11|12|13|14|15)
                run_test_by_num "$choice"
                ;;
            [qQ])
                run_quick
                ;;
            [aA])
                run_all
                ;;
            0)
                log "Exiting... Bye!"
                exit 0
                ;;
            *)
                err "Invalid choice."
                ;;
        esac
        
        show_reference
        read -p "Press Enter to return to menu... / 按回车键返回菜单..."
    done
}

main "$@"
