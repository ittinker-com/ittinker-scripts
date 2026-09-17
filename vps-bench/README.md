# ITTinker VPS Benchmark Toolkit

A comprehensive toolkit that consolidates 15+ VPS benchmarking scripts into a single, interactive, and easy-to-use menu tool.

## Quick Start

```bash
curl -sL https://raw.githubusercontent.com/ittinker-com/ittinker-scripts/main/vps-bench/bench.sh -o bench.sh && bash bench.sh
```

## Features

- **All-in-One**: Over 15 of the best VPS benchmarking tools available from a single menu.
- **Auto Dependency Check**: Checks for `curl` and `wget` and attempts auto-install if root.
- **OOM Protection**: Automatically allocates 2GB of swap space prior to heavy tests like GeekBench (YABS) to avoid Out Of Memory crashes on low RAM VPS.
- **Result Logging**: Test outputs are piped to a timestamped log file (`vps-bench-*.log`) in the working directory.
- **Reference Values**: Post-test reference table helps you instantly interpret Disk I/O, GeekBench, and latency scores.
- **CLI Options**: Support for headless testing (`--quick`, `--all`, `--test N`).

## Usage / Options

Run the script without arguments for the interactive menu:
```bash
bash bench.sh
```

Or use command-line arguments:
```bash
bash bench.sh --quick       # Run quick combo (bench.sh + backtrace + IP check)
bash bench.sh --all         # Run all tests sequentially
bash bench.sh --test 3      # Run specific test number (e.g., YABS)
bash bench.sh --help        # Show help
```

## Included Tools

### Comprehensive Performance
1. **bench.sh**: Classic test
2. **SuperBench**: Focus on China routes
3. **YABS**: Standard Geekbench score and disk testing
4. **LemonBench**: Full comprehensive test
5. **融合怪 ecs.sh**: Highly recommended all-in-one script
6. **UnixBench**: Specialized CPU testing

### Route Tracing
7. **backtrace**: Quick routing path
8. **mtr_trace**: Comprehensive 3-network route trace
9. **NextTrace**: Detailed map and routing information

### IP & Streaming
10. **IP.Check.Place**: Quick IP quality analysis
11. **ipcheck.ing**: Extensive IP checking
12. **Streaming Check**: Regional restriction streaming tests
13. **MediaUnlockTest**: Specific unlock checks

### Speed Test
14. **AutoSpeed**: 3-Network (China) speed test
15. **Speedtest CLI**: Official speedtest tools

## Requirements
- Ubuntu / Debian / CentOS
- Root privileges (recommended for auto-dependency installation and swap creation)

## Related Articles
- [ITTinker: VPS Benchmark Scripts Guide (2026)](https://ittinker.com/posts/20260110-vps-benchmark-scripts-guide/)

## License
MIT License
