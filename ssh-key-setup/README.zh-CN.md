# SSH Key Setup & Configuration Wizard (SSH密钥配置向导)

一个交互式的一站式向导工具，用于在本地计算机上生成 SSH 密钥对、上传公钥到远程服务器、配置 `~/.ssh/config` 文件以及设置 SSH Agent。旨在简化安全的 SSH 访问管理。

## 快速开始

运行交互式向导：
```bash
bash setup.sh
```

## 功能特点

- **交互式工作流**：逐步引导设置 SSH 访问。
- **Ed25519 支持**：自动生成安全的 Ed25519 密钥。
- **多服务器管理**：轻松配置多台服务器和 Host 别名。
- **自动修复权限**：自动修复 `~/.ssh` 和密钥文件的权限问题。
- **跨平台**：支持 macOS、Linux 以及 Windows 上的 WSL/Git Bash。
- **配置管理**：安全地备份和更新 `~/.ssh/config`，实现别名免密登录。

## 用法 / 选项

你也可以使用命令行参数运行特定步骤：

```text
Usage: bash setup.sh [OPTIONS]

Options:
  --generate          仅生成密钥对 (Step 1)
  --upload HOST       上传公钥到 HOST (Step 2)
  --config            仅更新 SSH config (Step 3)
  --agent             仅配置 SSH Agent (Step 4)
  --test ALIAS        测试与 ALIAS 的连接 (Step 5)
  --key FILE          使用指定的密钥文件
  --port PORT         SSH 端口 (默认: 22)
  --user USER         远程用户名 (默认: root)
  --help              显示帮助信息
```

## 示例

**1. 完整的交互式设置：**
```bash
./setup.sh
```

**2. 仅生成密钥：**
```bash
./setup.sh --generate --key ~/.ssh/github_ed25519
```

**3. 上传已有密钥：**
```bash
./setup.sh --upload 192.168.1.100 --key ~/.ssh/id_ed25519 --user admin --port 2222
```

**4. 测试连接：**
```bash
./setup.sh --test my-vps
```

## 运行要求

- 本地计算机 (macOS, Linux, 或装有 Git Bash/WSL 的 Windows)
- 系统路径中包含 `ssh`, `ssh-keygen`, `ssh-agent` 命令

## 相关文章

- [SSH 密钥免密登录完全指南](https://ittinker.com/zh-CN/posts/20260731-ssh-key-login-complete-guide/)

## 许可证

MIT License
