# Cloudflare UFW 防火墙配置工具

自动管理 UFW 防火墙规则，仅允许来自 Cloudflare 官方 IP 的流量访问（80 和 443 端口）。

## 快速开始

```bash
# 预览更改（试运行模式 - 默认）
sudo bash setup.sh

# 应用规则
sudo bash setup.sh --apply

# 应用规则并安装自动更新定时任务
sudo bash setup.sh --apply --install-cron
```

## 功能特点

- **自动获取 IP**：动态从 Cloudflare 官方获取最新的 IPv4 和 IPv6 范围。
- **幂等性**：多次运行安全。在添加新规则之前会自动清理旧规则。
- **默认试运行**：默认不修改系统状态，仅展示即将删除和添加的规则。
- **自动更新**：可选择安装每周执行的 Cron 定时任务，自动保持 IP 地址列表为最新。
- **规则追踪**：为所有生成的 UFW 规则打上 `Cloudflare` 标签，便于识别和管理。

## 使用方法

```text
用法: sudo bash setup.sh [选项]

选项:
  --dry-run          预览更改而不实际应用（默认）
  --apply            应用对 UFW 规则的更改
  --install-cron     同时安装每周定时更新任务
  --remove           移除所有 Cloudflare UFW 规则
  --remove-cron      移除定时任务
  --status           显示当前系统中的 Cloudflare UFW 规则
  --help             显示帮助信息
```

## 系统要求

- Root (`sudo`) 权限
- 操作系统：Ubuntu / Debian
- 已安装并启用 UFW (Uncomplicated Firewall)
- `curl`

## 相关文章

- [VPS 首小时初始化指南](https://ittinker.com/zh-CN/posts/20260121-vps-first-hour-init-guide/)

## 许可证

MIT License
