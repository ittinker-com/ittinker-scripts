# ITTinker VPS 综合测试工具箱

一个将超过15款主流 VPS 测试脚本整合到单个交互式菜单工具中的全面测试套件。

## 快速开始

```bash
curl -sL https://raw.githubusercontent.com/ittinker-com/ittinker-scripts/main/vps-bench/bench.sh -o bench.sh && bash bench.sh
```

## 功能特点

- **全能集成**: 单一菜单集合超过15个市面上最好的VPS跑分工具。
- **自动检查依赖**: 自动检查 `curl` 和 `wget`，如为 root 权限可自动安装。
- **内存防溢出 (OOM Protection)**: 运行 GeekBench (YABS) 等高负载测试前，自动创建并挂载2GB的临时 Swap 空间，防止小内存 VPS 崩溃。
- **日志记录**: 测试结果自动记录并保存到当前目录下的时间戳日志文件 (`vps-bench-*.log`)。
- **参考指标**: 测试完成后自动显示基准参考表，帮助您迅速解读磁盘 I/O、跑分以及延迟。
- **命令行选项**: 支持静默/快速测试 (`--quick`, `--all`, `--test N`)。

## 使用方法 / 选项

无参数运行以显示交互式菜单：
```bash
bash bench.sh
```

使用命令行参数直接运行：
```bash
bash bench.sh --quick       # 运行快速组合测试 (bench.sh + backtrace + IP检测)
bash bench.sh --all         # 依次运行所有测试
bash bench.sh --test 3      # 运行指定编号的测试 (如 YABS)
bash bench.sh --help        # 查看帮助说明
```

## 包含的测试脚本

### 综合性能
1. **bench.sh**: 经典测试脚本
2. **SuperBench**: 国内测速为主
3. **YABS**: 标准 Geekbench 跑分及硬盘测试
4. **LemonBench**: 柠檬全面测试
5. **融合怪 ecs.sh**: 极力推荐的综合脚本 ⭐
6. **UnixBench**: 专注 CPU 测试

### 回程路由
7. **backtrace**: 快速回程路由 ⭐
8. **mtr_trace**: 三网路由追踪
9. **NextTrace**: 详细地图与路由信息

### IP & 流媒体检测
10. **IP.Check.Place**: IP 质量快速分析 ⭐
11. **ipcheck.ing**: 详细 IP 检测
12. **Streaming Check**: 流媒体解锁检测
13. **MediaUnlockTest**: 更多平台解锁检测

### 测速专区
14. **AutoSpeed**: 三网测速
15. **Speedtest CLI**: 官方 Speedtest 测试

## 系统要求
- Ubuntu / Debian / CentOS
- 推荐 Root 权限 (以便自动安装缺失依赖和创建临时 Swap)

## 相关文章
- [ITTinker: VPS 常用测速/跑分脚本汇总 (2026)](https://ittinker.com/zh-CN/posts/20260110-vps-benchmark-scripts-guide/)

## 开源协议
MIT License
