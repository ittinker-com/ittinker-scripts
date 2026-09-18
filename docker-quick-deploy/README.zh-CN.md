# 生产级 Docker & Docker Compose 一键安装配置工具

> 一键安装官方最新 Docker CE 与 Docker Compose V2，自带日志限额轮转、免停机平滑重启与普通用户免 sudo 最佳实践。

[English Documentation](README.md) | [中文说明](README.zh-CN.md)

---

## 为什么不直接用官方一键脚本？

直接跑官方 `get.docker.com` 经常在生产环境埋雷：
1. **日志打爆硬盘**：Docker 默认不做日志轮转上限，运行数月后容器日志能吞掉几十 GB 磁盘造成系统崩溃。
2. **守护进程重载导致容器全挂**：默认情况下，重启 Docker 服务会导致所有正在运行的容器被直接 Kill。
3. **每次命令都要输 sudo**：未自动给当前常用非 root 用户添加用户组。
4. **国内外源访问困难**：在国内机房安装时卡在国外 apt/yum 源。

本脚本自带 2026 年生产级配置模板，一步到位。

---

## 内置最佳实践

- **日志轮转防爆盘**：自动配置 `/etc/docker/daemon.json` 单容器日志最大 50MB，最多保留 3 个归档。
- **免停机重载 (Live Restore)**：开启 `"live-restore": true`，后续升级 Docker 守护进程时不杀掉运行中的业务容器。
- **智能源选择**：自动嗅探服务器所处网络环境，智能选择官方源或阿里云稳定镜像源。
- **用户组赋权**：自动将当前普通运维用户加入 `docker` 组。

---

## 快速使用

```bash
sudo bash deploy.sh
```

---

## 开源协议

MIT © [ITTinker](https://ittinker.com)
