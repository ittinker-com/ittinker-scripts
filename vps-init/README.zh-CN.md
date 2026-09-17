# VPS 初始化脚本

> 一个交互式、全合一的 Ubuntu/Debian VPS 初始化 Shell 脚本。

此脚本将 ITTinker 博客中的最佳实践整合为一个易用的工具，帮助您在部署新服务器的第一小时内快速完成安全加固。

## 快速开始
```bash
wget -qO- https://raw.githubusercontent.com/ittinker-com/ittinker-scripts/main/vps-init/init.sh | sudo bash
```
*(或者克隆本仓库并运行 `sudo bash init.sh`)*

## 功能特性
- **系统更新:** 更新所有软件包并清理 apt 缓存
- **必备工具:** 安装 `curl`, `wget`, `git`, `vim`, `htop`, `ufw`, `fail2ban` 等工具
- **用户管理:** 安全地创建非 root 的 sudo 用户
- **SSH 加固:** 修改默认端口，禁用 root 登录，强制开启公钥认证
- **防火墙设置:** 配置 UFW 并仅开放必要端口
- **网络优化:** 开启 TCP BBR 拥塞控制以提升吞吐量
- **安全防护:** 配置 fail2ban 防止 SSH 暴力破解
- **本地化:** 设置系统时区

## 使用方法

交互式运行脚本：
```bash
sudo bash init.sh
```

### 选项
```text
  --step N        仅运行第 N 步 (1-8)
  --user NAME     设置用户名 (默认: ittinker)
  --port PORT     设置 SSH 端口 (默认: 22000)
  --tz TIMEZONE   设置时区 (默认: Asia/Shanghai)
  --yes           跳过所有确认提示
  --help          显示帮助信息
```

### 示例
非交互式运行，使用自定义参数：
```bash
sudo bash init.sh --user admin --port 2233 --tz America/New_York --yes
```

仅运行 SSH 加固步骤：
```bash
sudo bash init.sh --step 4
```

## 环境要求
- 操作系统: Ubuntu 20.04+ 或 Debian 11+
- 权限: 必须使用 `root` 权限运行

## 相关文章
- [VPS 首小时初始化指南](https://ittinker.com/zh-CN/posts/20260121-vps-first-hour-init-guide/)

## 开源协议
MIT
