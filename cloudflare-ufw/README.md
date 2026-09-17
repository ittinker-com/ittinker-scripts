# Cloudflare UFW Configuration Tool

Automatically manage UFW firewall rules to strictly allow traffic from Cloudflare IPs.

## Quick Start

```bash
# Preview changes (Dry Run - default)
sudo bash setup.sh

# Apply changes
sudo bash setup.sh --apply

# Apply changes AND install auto-update cron job
sudo bash setup.sh --apply --install-cron
```

## Features

- **Automated IP Fetching**: Retrieves official IPv4 and IPv6 ranges dynamically from Cloudflare.
- **Idempotent**: Safe to run multiple times. Cleans up old rules before adding new ones.
- **Dry-Run by Default**: Previews exactly which rules will be deleted and added without making actual changes.
- **Auto-Updates**: Option to install a weekly cron job to keep IP addresses up-to-date automatically.
- **Rule Tracking**: Tags all generated UFW rules with `Cloudflare` for easy identification.

## Usage

```text
Usage: sudo bash setup.sh [OPTIONS]

Options:
  --dry-run          Preview changes without applying (default)
  --apply            Apply changes to UFW rules
  --install-cron     Also install weekly cron job
  --remove           Remove all Cloudflare UFW rules
  --remove-cron      Remove the cron job
  --status           Show current Cloudflare UFW rules
  --help             Show this help
```

## Requirements

- Root (`sudo`) privileges
- OS: Ubuntu / Debian
- UFW (Uncomplicated Firewall) installed and active
- `curl`

## Related Articles

- [VPS First Hour Initialization Guide](https://ittinker.com/posts/20260121-vps-first-hour-init-guide/)

## License

MIT License
