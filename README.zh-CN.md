# ITTinker 自动化与运维脚本工具箱

> 面向 ITTinker 平台的开源自动化脚本、DevOps 工作流与日常运维工具集合。

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

---

## 工具目录清单

| 工具目录 | 工具名称 | 简要说明 |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API 渠道模型同步脚本** | 自动从上游探针获取最新可用模型，支持精确对比分析、Dry Run 预演与快照备份。 |

---

## 规范约定

- 每个独立工具或运维工作流存放于各自专用的子目录中。
- 目录名采用全小写加横杠（kebab-case）的英文命名规则。
- 每个工具目录均配备默认的英文 `README.md` 与多语言说明文档（如 `README.zh-CN.md`），并具备可执行的脚本文件。
