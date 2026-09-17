# ITTinker 自动化与运维脚本工具箱

> 面向 ITTinker 平台的开源自动化脚本、DevOps 工作流与日常运维工具集合。

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

---

## 工具目录清单

| 工具目录 | 工具名称 | 简要说明 |
| :--- | :--- | :--- |
| [`newapi-sync-channel-models/`](./newapi-sync-channel-models/) | **New API 渠道模型同步脚本** | 自动从上游探针获取最新可用模型，支持精确对比分析、Dry Run 预演与快照备份。 |
| [`vps-init/`](./vps-init/) | **VPS 一键初始化脚本** | 从裸机到生产可用的完整初始化：系统更新、用户创建、SSH 加固、防火墙、BBR 加速、fail2ban 防暴力破解。 |
| [`vps-bench/`](./vps-bench/) | **VPS 测评工具箱** | 交互式菜单整合 15+ 测评脚本：综合性能、回程路由、IP 质量、流媒体解锁、三网测速。 |
| [`ssh-key-setup/`](./ssh-key-setup/) | **SSH 密钥一键配置** | 引导式 SSH 密钥配置：生成密钥、上传到服务器、配置 SSH Config 与 Agent、多账号支持。 |
| [`cloudflare-ufw/`](./cloudflare-ufw/) | **Cloudflare UFW 防火墙配置** | 自动配置 UFW 仅允许 Cloudflare IP 访问 80/443 端口，支持预览模式和每周定时更新。 |
| [`cloudflare-domain-baseline/`](./cloudflare-domain-baseline/) | **Cloudflare 域名最佳实践基线配置** | 一键为指定域名注入生产级黄金配置：Full Strict 严格 SSL、HSTS 响应头、www 规范化 301 重定向、静态资源强缓存、Bot 防爬。 |

---

## 规范约定

- 每个独立工具或运维工作流存放于各自专用的子目录中。
- 目录名采用全小写加横杠（kebab-case）的英文命名规则。
- 每个工具目录均配备默认的英文 `README.md` 与多语言说明文档（如 `README.zh-CN.md`），并具备可执行的脚本文件。
