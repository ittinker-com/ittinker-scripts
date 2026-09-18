# 零依赖极简 VPS 健康检查与告警脚本

> 专为独立开发者设计的极简无服务监控工具。纯原生 Bash 编写，无需常驻守护进程，超阈值时即刻推送 Telegram / Discord / 飞书 告警。

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

---

## 解决的痛点

独立开发者手里通常有几台便宜的 VPS，随时可能面临：
- 某项服务内存泄漏，导致 OOM 导致 SSH 都连不上；
- 日志或临时文件悄悄打满硬盘；
- 被人持续暴力破解导致 CPU 飙升。

搭建 Zabbix 或 Prometheus 又太耗机器资源。本脚本依靠 Crontab 定时触发，运行完毕立即退出，资源占用近乎为 0。

---

## 支持的通知渠道

- **Telegram 机器人**：配置 `TG_BOT_TOKEN` 与 `TG_CHAT_ID`
- **Discord 频道**：配置 `DISCORD_WEBHOOK_URL`
- **飞书 / 企业微信群机器人**：配置 `FEISHU_WEBHOOK_URL`

---

## 快速使用

### 1. 终端试运行
```bash
export TG_BOT_TOKEN="你的TG机器人Token"
export TG_CHAT_ID="你的ChatID"
# 或者设置飞书 Webhook:
# export FEISHU_WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/..."

bash monitor.sh
```

### 2. 加入 Crontab 定时任务（每 10 分钟检测一次）
```bash
(crontab -l 2>/dev/null; echo "*/10 * * * * TG_BOT_TOKEN=\"xxx\" TG_CHAT_ID=\"yyy\" /root/monitor.sh > /dev/null 2>&1") | crontab -
```

---

## 开源协议

MIT © [ITTinker](https://ittinker.com)
