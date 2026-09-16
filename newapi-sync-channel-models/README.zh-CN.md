# New API 渠道模型全量同步脚本

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

用于全量或指定条件自动化同步 New API 上游最新模型列表的轻量级运维脚本。彻底解决手动限定模型列表后，上游模型更迭下线（EOL）导致调用报错、排错困难的问题。

---

## 核心功能

- **自动化分页遍历**：通过管理员接口逐页扫描 New API 渠道列表。
- **精细条件过滤**：支持通过名称关键字模糊匹配（如 `nvidia`）或通过 `CHANNEL_ID_FILTER` 精确指定单渠道 ID。
- **上游实时探针**：调用 `/api/channel/fetch_models/{id}` 实时拉取上游服务商当前真实支持的完整模型清单。
- **智能对比分析**：精确比对本地配置与上游支持列表，高亮输出新增模型数、废弃下线模型数及模型抽样。
- **默认安全预演（Dry Run）**：默认 `DRY_RUN=true` 仅分析展示差异，绝不破坏现有数据。
- **原子自动备份**：`DRY_RUN=false` 真正修改前，自动将变更前的渠道配置快照归档至带时间戳的 `.jsonl` 备份文件。
- **空模型容错保护**：若上游接口偶发异常返回 0 个模型，脚本自动跳过跳出，杜绝误清空现有渠道模型的事故。

---

## 依赖要求

- `bash` (4.0+)
- `curl`
- `jq` (JSON 处理工具)

安装命令：
- **macOS**: `brew install curl jq`
- **Ubuntu/Debian**: `sudo apt update && sudo apt install -y curl jq`
- **Alpine Linux**: `apk add --no-cache bash curl jq`

---

## 使用指南

### 1. 差异预览（Dry Run，默认不改动数据）

```bash
export NEWAPI_URL="https://your-newapi-instance.com"
export NEWAPI_ACCESS_TOKEN="你的管理员访问令牌"
export NEWAPI_USER_ID="1"
export CHANNEL_FILTER="nvidia"   # 过滤名称包含 nvidia 的渠道，留空则匹配全部
export DRY_RUN="true"

./sync-models.sh
```

### 2. 执行全量同步（生效写入）

```bash
export NEWAPI_ACCESS_TOKEN="你的管理员访问令牌"
export DRY_RUN="false"

./sync-models.sh
```

---

## 环境变量说明

| 环境变量 | 默认值 | 作用说明 |
| :--- | :--- | :--- |
| `NEWAPI_URL` | `https://api.ittinker.com` | New API 服务根地址 |
| `NEWAPI_ACCESS_TOKEN` | *(必填)* | 系统管理员令牌 (System Access Token) |
| `NEWAPI_USER_ID` | `1` | 请求头 `New-Api-User` 传递的管理员用户 ID |
| `CHANNEL_FILTER` | `nvidia` | 渠道名称模糊匹配关键词（不区分大小写） |
| `CHANNEL_ID_FILTER` | *(留空)* | 可选：仅处理指定 ID 的渠道 |
| `DRY_RUN` | `true` | 为 `true` 时仅打印对比结果，不调用修改接口 |
| `PAGE_SIZE` | `100` | 每次查询分页获取的渠道数量 |
| `BACKUP_FILE` | `newapi-channel-models-backup-*.jsonl` | 修改前的配置备份存储路径 |

---

## 运行日志示例

以下为真实运行的控制台输出：从原本仅配置 4~5 个模型的受限渠道，一键同步上游 82 个全量模型，并精准移除了已下线废弃的 `deepseek-ai/deepseek-v4-pro-0813`：

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

## 开源协议

MIT License.
