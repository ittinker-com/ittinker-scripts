#!/usr/bin/env bash
set -u

# ============================================================
# New API 渠道模型全量同步脚本 / New API Channel Models Sync
#
# 功能：
# 1. 获取所有渠道 / List all channels with pagination
# 2. 按名称过滤，例如 nvidia / Filter channels by name
# 3. 调用 /api/channel/fetch_models/{id} / Fetch upstream models
# 4. 获取该渠道上游完整模型列表 / Retrieve complete upstream models
# 5. 对比当前 models / Diff against existing model bindings
# 6. DRY_RUN=false 时，仅提交 id + models 更新 / Update channels if DRY_RUN=false
#
# 依赖 / Requirements:
#   curl
#   jq
#
# 兼容 / Compatibility:
#   macOS
#   Linux
# ============================================================

# =========================
# 配置 / Configurations
# =========================

NEWAPI_URL="${NEWAPI_URL:-https://api.ittinker.com}"
NEWAPI_ACCESS_TOKEN="${NEWAPI_ACCESS_TOKEN:-}"
NEWAPI_USER_ID="${NEWAPI_USER_ID:-1}"

# 渠道名称包含这个字符串才处理，留空则处理全部渠道
CHANNEL_FILTER="${CHANNEL_FILTER:-nvidia}"

# 可选：只处理指定渠道 ID
CHANNEL_ID_FILTER="${CHANNEL_ID_FILTER:-}"

# true  = 只预览 (Dry Run)
# false = 真正修改 (Apply Changes)
DRY_RUN="${DRY_RUN:-true}"

PAGE_SIZE="${PAGE_SIZE:-100}"
BACKUP_FILE="${BACKUP_FILE:-newapi-channel-models-backup-$(date +%Y%m%d-%H%M%S).jsonl}"

# =========================
# 基础检查 / Preflight Checks
# =========================

if [[ -z "$NEWAPI_ACCESS_TOKEN" ]]; then
  echo "ERROR: NEWAPI_ACCESS_TOKEN is not set / 未设置"
  echo
  echo "Please set your access token first:"
  echo 'export NEWAPI_ACCESS_TOKEN="your_system_access_token"'
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl not found / 找不到 curl"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq not found / 找不到 jq"
  echo
  echo "macOS:"
  echo "  brew install jq"
  echo
  echo "Ubuntu/Debian:"
  echo "  sudo apt install -y jq"
  exit 1
fi

NEWAPI_URL="${NEWAPI_URL%/}"

# =========================
# HTTP Helpers
# =========================

api_get() {
  local path="$1"

  curl \
    --silent \
    --show-error \
    --fail \
    --connect-timeout 15 \
    --max-time 90 \
    -H "Authorization: Bearer ${NEWAPI_ACCESS_TOKEN}" \
    -H "New-Api-User: ${NEWAPI_USER_ID}" \
    -H "Content-Type: application/json" \
    "${NEWAPI_URL}${path}"
}

api_put() {
  local path="$1"
  local body="$2"

  curl \
    --silent \
    --show-error \
    --fail \
    --connect-timeout 15 \
    --max-time 90 \
    -X PUT \
    -H "Authorization: Bearer ${NEWAPI_ACCESS_TOKEN}" \
    -H "New-Api-User: ${NEWAPI_USER_ID}" \
    -H "Content-Type: application/json" \
    --data "$body" \
    "${NEWAPI_URL}${path}"
}

# =========================
# 工具函数 / Utility Functions
# =========================

join_by_comma() {
  awk '
    BEGIN { first=1 }
    NF {
      if (!first) {
        printf ","
      }
      printf "%s", $0
      first=0
    }
    END {
      printf "\n"
    }
  '
}

normalize_models_string() {
  local models="$1"

  printf '%s\n' "$models" \
    | tr ',' '\n' \
    | sed '/^[[:space:]]*$/d' \
    | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
    | sort -u
}

# =========================
# 获取渠道 / Channel Fetching
# =========================

get_channels_page() {
  local page="$1"
  api_get "/api/channel/?p=${page}&page_size=${PAGE_SIZE}"
}

extract_channels() {
  jq -c '
    (.data // .) as $d
    |
    if ($d | type) == "array" then
      $d[]
    elif (($d.items? // null) | type) == "array" then
      $d.items[]
    elif (($d.data? // null) | type) == "array" then
      $d.data[]
    elif (($d.channels? // null) | type) == "array" then
      $d.channels[]
    else
      empty
    end
  '
}

# =========================
# 获取上游模型 / Upstream Models Fetching
# =========================

fetch_models() {
  local channel_id="$1"

  api_get "/api/channel/fetch_models/${channel_id}" \
    | jq -r '
        (.data // .) as $d
        |
        if ($d | type) == "array" then
          $d[]
        elif (($d.models? // null) | type) == "array" then
          $d.models[]
        elif (($d.data? // null) | type) == "array" then
          $d.data[]
        else
          empty
        end
        |
        if type == "string" then
          .
        elif type == "object" then
          (.id // .name // .model // empty)
        else
          empty
        end
      ' \
    | sed '/^[[:space:]]*$/d' \
    | sort -u
}

# =========================
# 更新渠道 / Channel Updating
# =========================

update_channel_models() {
  local channel_id="$1"
  local models="$2"

  local payload
  payload="$(
    jq -n \
      --argjson id "$channel_id" \
      --arg models "$models" \
      '{
        id: $id,
        models: $models
      }'
  )"

  api_put "/api/channel/" "$payload"
}

# =========================
# 备份 / Backup
# =========================

backup_channel() {
  local channel="$1"

  echo "$channel" \
    | jq -c '{
        id: .id,
        name: .name,
        models: .models
      }' \
    >> "$BACKUP_FILE"
}

# =========================
# 主程序 / Main Execution
# =========================

echo "============================================================"
echo "New API Model Synchronizer / 模型同步"
echo "============================================================"
echo "New API:       $NEWAPI_URL"
echo "User ID:       $NEWAPI_USER_ID"
echo "Filter:        ${CHANNEL_FILTER:-ALL}"
echo "Channel ID:    ${CHANNEL_ID_FILTER:-ALL}"
echo "Dry run:       $DRY_RUN"
echo "Page size:     $PAGE_SIZE"
echo "Backup file:   $BACKUP_FILE"
echo "============================================================"
echo

changed=0
unchanged=0
skipped=0
failed=0
processed=0

page=0

while true; do
  echo "Reading channels, page $page / 读取渠道，第 $page 页..."

  if ! response="$(get_channels_page "$page")"; then
    echo "ERROR: Failed to fetch channel list / 获取渠道列表失败"
    exit 1
  fi

  channels="$(echo "$response" | extract_channels)"
  count="$(printf '%s\n' "$channels" | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' ')"

  if [[ "$count" -eq 0 ]]; then
    break
  fi

  while IFS= read -r channel; do
    [[ -z "$channel" ]] && continue

    id="$(echo "$channel" | jq -r '.id')"
    name="$(echo "$channel" | jq -r '.name // ""')"

    # ID 过滤
    if [[ -n "$CHANNEL_ID_FILTER" ]]; then
      if [[ "$id" != "$CHANNEL_ID_FILTER" ]]; then
        continue
      fi
    fi

    # 名称过滤
    if [[ -n "$CHANNEL_FILTER" ]]; then
      if ! printf '%s\n' "$name" | grep -qi -- "$CHANNEL_FILTER"; then
        skipped=$((skipped + 1))
        continue
      fi
    fi

    processed=$((processed + 1))

    echo
    echo "------------------------------------------------------------"
    echo "#$id $name"

    tmp_models="$(mktemp)"
    tmp_current="$(mktemp)"
    tmp_new="$(mktemp)"

    cleanup_tmp() {
      rm -f "$tmp_models" "$tmp_current" "$tmp_new"
    }

    # 获取上游完整模型
    if ! fetch_models "$id" > "$tmp_models"; then
      echo "ERROR: Failed to fetch upstream models / 获取上游模型失败"
      failed=$((failed + 1))
      cleanup_tmp
      continue
    fi

    model_count="$(sed '/^[[:space:]]*$/d' "$tmp_models" | wc -l | tr -d ' ')"

    # 安全保护：如果上游返回 0 个，跳过修改
    if [[ "$model_count" -eq 0 ]]; then
      echo "SKIP: Upstream returned 0 models, skipping / 上游返回 0 个模型，不做任何修改"
      skipped=$((skipped + 1))
      cleanup_tmp
      continue
    fi

    # 当前配置的模型
    current_models="$(echo "$channel" | jq -r '.models // ""')"
    normalize_models_string "$current_models" > "$tmp_current"
    sort -u "$tmp_models" > "$tmp_new"

    current_count="$(sed '/^[[:space:]]*$/d' "$tmp_current" | wc -l | tr -d ' ')"

    # 无变化检测
    if cmp -s "$tmp_current" "$tmp_new"; then
      echo "OK: Models already match upstream ($model_count models) / 已经完整，共 $model_count 个模型"
      unchanged=$((unchanged + 1))
      cleanup_tmp
      continue
    fi

    # 差异统计
    added_count="$(comm -13 "$tmp_current" "$tmp_new" | wc -l | tr -d ' ')"
    removed_count="$(comm -23 "$tmp_current" "$tmp_new" | wc -l | tr -d ' ')"

    echo "CHANGE: Current $current_count -> Upstream $model_count models"
    echo "Added / 新增: $added_count"
    echo "Removed / 移除: $removed_count"

    if [[ "$added_count" -gt 0 ]]; then
      echo
      echo "Sample added models / 新增模型示例："
      comm -13 "$tmp_current" "$tmp_new" | head -20
    fi

    if [[ "$removed_count" -gt 0 ]]; then
      echo
      echo "Sample removed models / 上游已不存在的模型示例："
      comm -23 "$tmp_current" "$tmp_new" | head -20
    fi

    new_models="$(cat "$tmp_new" | join_by_comma)"

    # Dry Run 检查
    if [[ "$DRY_RUN" == "true" ]]; then
      echo
      echo "DRY RUN: No changes applied / 预览模式，未做实际修改"
      changed=$((changed + 1))
      cleanup_tmp
      continue
    fi

    # 实际修改与备份
    backup_channel "$channel"
    echo
    echo "Updating channel models / 正在更新..."

    if ! update_response="$(update_channel_models "$id" "$new_models")"; then
      echo "ERROR: HTTP update request failed / HTTP 更新请求失败"
      failed=$((failed + 1))
      cleanup_tmp
      continue
    fi

    success="$(
      echo "$update_response" \
        | jq -r '
            if type == "object" and has("success")
            then .success
            else true
            end
          ' 2>/dev/null || echo "true"
    )"

    if [[ "$success" == "false" ]]; then
      echo "ERROR: API returned error / API 返回失败："
      echo "$update_response" | jq . 2>/dev/null || echo "$update_response"
      failed=$((failed + 1))
      cleanup_tmp
      continue
    fi

    echo "UPDATED: Successfully synchronized / 成功更新"
    changed=$((changed + 1))
    cleanup_tmp

  done <<< "$channels"

  # 如果指定单个 ID 且已处理，退出翻页
  if [[ -n "$CHANNEL_ID_FILTER" && "$processed" -gt 0 ]]; then
    break
  fi

  if [[ "$count" -lt "$PAGE_SIZE" ]]; then
    break
  fi

  page=$((page + 1))
done

# =========================
# 汇总 / Summary
# =========================

echo
echo
echo "============================================================"
echo "Done / 完成"
echo "============================================================"
echo "Processed Channels / 处理渠道: $processed"
echo "Changed / 有变化:             $changed"
echo "Unchanged / 无变化:           $unchanged"
echo "Skipped / 跳过:               $skipped"
echo "Failed / 失败:                $failed"
echo "============================================================"

if [[ "$DRY_RUN" == "true" ]]; then
  echo
  echo "Current mode is DRY RUN. No changes were made to the remote service."
  echo "Set DRY_RUN=false to apply updates."
else
  echo
  echo "Configuration backup saved to / 修改前配置备份："
  echo "$BACKUP_FILE"
fi
