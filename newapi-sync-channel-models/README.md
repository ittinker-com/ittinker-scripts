# New API Upstream Channel Models Synchronizer

[English](README.md) | [中文说明](README.zh-CN.md)

A lightweight and safe bash automation script to synchronize upstream models into New API channel configurations. It solves the issue where manually configured models on channels become outdated or deprecated over time.

---

## Key Features

- **Automated Discovery**: Iterates through New API channels via paginated administrative APIs.
- **Selective Filtering**: Filter channels by keyword (e.g. `nvidia`) or target a specific channel by ID (`CHANNEL_ID_FILTER`).
- **Upstream Introspection**: Automatically queries `/api/channel/fetch_models/{id}` to discover valid models currently exposed by the upstream provider.
- **Diff & Analysis**: Displays precise statistics of newly added and deprecated/removed models with preview samples.
- **Dry-Run by Default**: Runs in inspection mode (`DRY_RUN=true`) by default to prevent unintentional updates.
- **Atomic Rollback Backup**: Automatically writes pre-update snapshots to a timestamped JSON Lines (`.jsonl`) file before executing any modifications.
- **Safe Fallback**: Skips updates automatically if upstream returns 0 models to prevent emptying active channels.

---

## Requirements

- `bash` (4.0+ recommended)
- `curl`
- `jq` (Command-line JSON processor)

Install dependencies:
- **macOS**: `brew install curl jq`
- **Ubuntu/Debian**: `sudo apt update && sudo apt install -y curl jq`
- **Alpine Linux**: `apk add --no-cache bash curl jq`

---

## Usage

### 1. Dry Run (Preview Changes)

```bash
export NEWAPI_URL="https://your-newapi-instance.com"
export NEWAPI_ACCESS_TOKEN="your_system_access_token"
export NEWAPI_USER_ID="1"
export CHANNEL_FILTER="nvidia"   # Filter by name, or leave empty for all
export DRY_RUN="true"

./sync-models.sh
```

### 2. Apply Changes (Sync Upstream Models)

```bash
export NEWAPI_ACCESS_TOKEN="your_system_access_token"
export DRY_RUN="false"

./sync-models.sh
```

---

## Environment Variables

| Variable | Default | Description |
| :--- | :--- | :--- |
| `NEWAPI_URL` | `https://api.ittinker.com` | Base URL of the target New API service |
| `NEWAPI_ACCESS_TOKEN` | *(Required)* | Root or admin access token for API authentication |
| `NEWAPI_USER_ID` | `1` | Admin user ID sent in the `New-Api-User` header |
| `CHANNEL_FILTER` | `nvidia` | Filter channel names containing this string (case-insensitive) |
| `CHANNEL_ID_FILTER` | *(Empty)* | Process only a specific channel ID |
| `DRY_RUN` | `true` | When `true`, displays diff without modifying data |
| `PAGE_SIZE` | `100` | Number of channels fetched per page |
| `BACKUP_FILE` | `newapi-channel-models-backup-*.jsonl` | Filepath for JSONL pre-change backups |

---

## Example Output

Here is an actual execution log showing channel models synchronized from 4 upstream models to 82, automatically cleaning up deprecated models such as `deepseek-ai/deepseek-v4-pro-0813`:

```text
============================================================
New API 模型同步
============================================================
New API:       https://llmapi.ittinker.com
User ID:       1
Filter:        nvidia
Channel ID:    ALL
Dry run:       false
Page size:     100
Backup file:   newapi-channel-models-backup-20260916-140347.jsonl
============================================================

读取渠道，第 0 页...

------------------------------------------------------------
#5 nvidia-test-01
CHANGE: 当前 4 个 -> 上游 82 个
新增: 80
移除: 2

新增模型示例：
01-ai/yi-large
adept/fuyu-8b
ai21labs/jamba-1.5-large-instruct
aisingapore/sea-lion-7b-instruct
...

上游已不存在的模型示例：
deepseek-ai/deepseek-v4-pro-0813
minimaxai/minimax-m3

正在更新...
UPDATED: 成功
```

---

## License

MIT License. Open source for community use.
