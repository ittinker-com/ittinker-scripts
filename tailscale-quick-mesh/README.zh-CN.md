# Tailscale 极速组网与子网路由器一键配置

> 一键安装 Tailscale、开启 Linux 内核 IP 转发、支持无密码 Pre-auth Key 免交互入网以及子网路由 (Subnet Router) 广播。

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

---

## 为什么独立开发者需要 Tailscale？

- **跨云多机秒连**：不同云厂商（AWS、Vultr、阿里云等）的机器瞬间拉进同一内网，内网 IP 直接通信。
- **消灭公网 SSH**：绑定 Tailscale 后可以直接关闭 VPS 的公网 22 端口，只允许内网登录，彻底杜绝爆破脚本。
- **MagicDNS**：直接用机器名 `ssh my-vps` 连接，无需记忆 IP。

---

## 快速使用

```bash
# 1. 普通交互式安装
sudo bash mesh.sh

# 2. 自动化入网并广播局域网网段（当子网路由）
sudo bash mesh.sh --authkey "tskey-auth-xxx" --advertise-routes "192.168.1.0/24"
```

---

## 开源协议

MIT © [ITTinker](https://ittinker.com)
