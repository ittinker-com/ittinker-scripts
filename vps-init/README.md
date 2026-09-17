# VPS Initialization Script

> An interactive, all-in-one shell script for initializing a fresh Ubuntu/Debian VPS.

This script consolidates all the best practices from the ITTinker blog into one easy-to-use tool, securing your new server within the first hour of deployment.

## Quick Start
```bash
wget -qO- https://raw.githubusercontent.com/ittinker-com/ittinker-scripts/main/vps-init/init.sh | sudo bash
```
*(Or clone this repository and run `sudo bash init.sh`)*

## Features
- **System Update:** Upgrades all packages and cleans up apt cache
- **Essential Tools:** Installs `curl`, `wget`, `git`, `vim`, `htop`, `ufw`, `fail2ban`, etc.
- **User Management:** Creates a non-root sudo user securely
- **SSH Hardening:** Changes default port, disables root login, enforces key-based auth
- **Firewall Setup:** Configures UFW with essential ports open
- **Network Optimization:** Enables TCP BBR for better throughput
- **Security:** Configures fail2ban to prevent SSH brute-force attacks
- **Localization:** Sets the system timezone

## Usage

Run the script interactively:
```bash
sudo bash init.sh
```

### Options
```text
  --step N        Run only step N (1-8)
  --user NAME     Set username (default: ittinker)
  --port PORT     Set SSH port (default: 22000)
  --tz TIMEZONE   Set timezone (default: Asia/Shanghai)
  --yes           Skip confirmations
  --help          Show help message
```

### Examples
Non-interactive initialization with custom values:
```bash
sudo bash init.sh --user admin --port 2233 --tz America/New_York --yes
```

Run only the SSH hardening step:
```bash
sudo bash init.sh --step 4
```

## Requirements
- OS: Ubuntu 20.04+ or Debian 11+
- Privileges: `root` access required

## Related Articles
- [VPS First Hour Initialization Guide](https://ittinker.com/posts/20260121-vps-first-hour-init-guide/)

## License
MIT
