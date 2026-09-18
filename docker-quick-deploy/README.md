# Production Docker & Docker Compose Quick Installer

> One-click script to install the latest Docker Engine and Docker Compose V2 with production-grade defaults (log-rotation, live-restore, and permission handling).

[English](README.md) | [中文说明](README.zh-CN.md)

---

## Why This Tool?

The standard `curl -fsSL https://get.docker.com | sh` script has notable shortcomings in production:
1. **Unbounded container logs**: Docker defaults to unlimited log file sizes, which frequently fills up VPS disk space (`/var/lib/docker/containers`).
2. **Daemon restarts kill containers**: By default, restarting or updating the Docker service terminates running containers.
3. **Root requirement**: Forgetting to add standard user accounts to the `docker` group requires continuous `sudo` usage.
4. **Geo-network friction**: Pulling from official Docker repos can hang or fail on mainland Chinese networks without automatic mirror fallback.

`deploy.sh` addresses all of these issues out-of-the-box.

---

## Best Practices Injected

- **Log Rotation**: Automatically sets `max-size: 50m` and `max-file: 3` in `/etc/docker/daemon.json`.
- **Live Restore**: Sets `"live-restore": true`, preventing container downtime during Docker daemon updates.
- **Auto Mirror**: Intelligently tests upstream connectivity and automatically falls back to reliable regional mirrors if Google/Docker is blocked.
- **Non-Root Access**: Automatically adds the invoking user to the `docker` group.

---

## Quick Start

```bash
sudo bash deploy.sh
```

---

## License

MIT © [ITTinker](https://ittinker.com)
