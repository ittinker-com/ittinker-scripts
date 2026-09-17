# SSH Key Setup & Configuration Wizard

An interactive, all-in-one wizard to generate SSH key pairs, upload them to remote servers, configure `~/.ssh/config`, and set up the SSH agent. Designed for your local machine to simplify secure SSH access management.

## Quick Start

Run the wizard interactively:
```bash
bash setup.sh
```

## Features

- **Interactive Workflow**: Step-by-step guidance for setting up SSH access.
- **Ed25519 Support**: Automatically generates secure Ed25519 keys.
- **Multi-Server Management**: Easily configure multiple servers and Host aliases.
- **Auto Permissions**: Fixes `~/.ssh` and key file permissions automatically.
- **Cross-Platform**: Supports macOS, Linux, and WSL/Git Bash on Windows.
- **Config Management**: Safely backs up and updates `~/.ssh/config` for alias login.

## Usage / Options

You can also run specific steps non-interactively using the following flags:

```text
Usage: bash setup.sh [OPTIONS]

Options:
  --generate          Only generate key pair (Step 1)
  --upload HOST       Upload key to HOST (Step 2)
  --config            Only update SSH config (Step 3)
  --agent             Only configure SSH Agent (Step 4)
  --test ALIAS        Test connection to ALIAS (Step 5)
  --key FILE          Use specific key file
  --port PORT         SSH port (default: 22)
  --user USER         Remote username (default: root)
  --help              Show this help
```

## Examples

**1. Full Interactive Setup:**
```bash
./setup.sh
```

**2. Generate Key Only:**
```bash
./setup.sh --generate --key ~/.ssh/github_ed25519
```

**3. Upload Existing Key:**
```bash
./setup.sh --upload 192.168.1.100 --key ~/.ssh/id_ed25519 --user admin --port 2222
```

**4. Test Connection:**
```bash
./setup.sh --test my-vps
```

## Requirements

- Local computer (macOS, Linux, or Windows with Git Bash/WSL)
- `ssh`, `ssh-keygen`, and `ssh-agent` commands available in your path

## Related Articles

- [Complete Guide to SSH Key Login](https://ittinker.com/posts/20260731-ssh-key-login-complete-guide/)

## License

MIT License
