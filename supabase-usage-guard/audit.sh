#!/usr/bin/env bash
# ==============================================================================
# Script: audit.sh
# Description: Automated Supabase / PostgreSQL Database Health & Slow Query Audit
#              自动化 Supabase / PostgreSQL 慢 SQL、缺失索引与流量体检工具
# Supports: Direct connection string (--db-url), Local output, JSON/Table format
# ==============================================================================

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

DB_URL="${DATABASE_URL:-}"
OUTPUT_FILE="supabase_health_report_$(date +%Y%m%d_%H%M%S).txt"

show_help() {
    cat << 'HELP_EOF'
Supabase / PostgreSQL Database Health & Slow Query Audit Tool
Supabase 数据库健康、慢查询与缺失索引自动体检工具

Usage / 用法:
  bash audit.sh [OPTIONS]

Options / 选项:
  --db <URL>       Postgres connection string (or set DATABASE_URL env)
                   连接串示例: postgresql://postgres.[ref]:[pass]@aws-0-[region].pooler.supabase.com:6543/postgres
  -o, --output     Report output filename (Default: supabase_health_report_<timestamp>.txt)
  -h, --help       Show this help message

What this tool audits:
  1. Top Egress/Row Consumer SQL (流量大户与高频拉取语句)
  2. Slow Queries (耗时最长的慢 SQL)
  3. Missing Indexes & Table Scans (全表扫描与缺失索引排行)
  4. Unused / Redundant Indexes (占用存储的废弃索引)
  5. Largest Tables & Disk Consumers (数据表物理存储空间排行)
  6. Dead Tuples & Table Bloat (死元组与垃圾膨胀分析)
HELP_EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --db)
            DB_URL="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
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

if ! command -v psql >/dev/null 2>&1; then
    echo -e "${RED}Error: 'psql' is required to run automated audits.${NC}"
    echo "Tip: You can also copy the queries directly from 'diagnose-db-health.sql' into the Supabase Dashboard SQL Editor!"
    exit 1
fi

if [[ -z "$DB_URL" ]]; then
    echo -e "${YELLOW}Please provide your Supabase Database Connection URI:${NC}"
    echo "Found in: Supabase Dashboard -> Project Settings -> Database -> Connection string (URI)"
    read -p "Database URI: " DB_URL
fi

if [[ -z "$DB_URL" ]]; then
    echo -e "${RED}Error: Database URL cannot be empty.${NC}"
    exit 1
fi

echo -e "${CYAN}${BOLD}"
echo "============================================================"
echo "    Supabase / Postgres 360° Health & Performance Audit    "
echo "============================================================"
echo -e "${NC}"

SQL_FILE="$(dirname "$0")/diagnose-db-health.sql"

if [[ ! -f "$SQL_FILE" ]]; then
    echo -e "${RED}Error: SQL template file not found: $SQL_FILE${NC}"
    exit 1
fi

echo -e "${BLUE}[*] Running diagnostic queries against database...${NC}"
psql "$DB_URL" -f "$SQL_FILE" | tee "$OUTPUT_FILE"

echo ""
echo -e "${GREEN}${BOLD}🎉 Diagnostic report successfully generated!${NC}"
echo -e "Report saved to: ${CYAN}${OUTPUT_FILE}${NC}"
