# Minfiles

A minimal but powerful dotfiles configuration optimized for both general Unix environments and server administration, with special support for Proxmox VE environments.

## Overview
- Security-focused defaults and permissions
- Smart command detection and fallbacks
- Comprehensive system aliases and functions
- Proxmox VE integration and tooling
- System monitoring and management
- Fast and lightweight setup

## Features

### Core Shell Features
- Smart command detection and fallbacks
- Comprehensive alias system
- History management with timestamps
- XDG base directory compliance
- Error logging with rotation

### Security Features
- Restrictive umask (027) for secure file permissions
- Core dump prevention (ulimit -c 0)
- Secure directory creation (700 permissions)
- Safe operation aliases (rm, cp, mv)
- Noclobber protection

### System Tools
- Enhanced monitoring commands
  ```bash
  df        # Enhanced disk free with human readable
  free      # Memory status
  psmem     # Process by memory usage
  pscpu     # Process by CPU usage
  psme      # User processes
  ```
- Network utilities
  ```bash
  myip      # Public IP
  localip   # Local IPs
  ports     # Show listening ports
  netwatch  # Monitor connections
  ```

### Proxmox VE Integration
- Container management
  ```bash
  pl        # List containers
  pstart    # Start container
  pstop     # Stop container
  pen       # Enter container
  ```
- System administration
  ```bash
  sto       # Storage status
  pvlog     # PVE proxy logs
  dfp       # Physical disk usage
  ```
- Batch operations
  ```bash
  pstart_all 100 101 102  # Start multiple containers
  pstop_all 100 101 102   # Stop multiple containers
  ```

### Development Tools
- Vim configuration with plugins
  - FZF integration
  - Git support
  - Modern themes
- Version control helpers
- Search utilities (ripgrep, fd)

## Installation

```bash
# Clone to Projects directory
mkdir -p ~/Projects
git clone https://github.com/y37y/minfiles.git ~/Projects/minfiles

# Setup dotfiles
ln -s ~/Projects/minfiles/.bashrc ~/.bashrc
source ~/.bashrc

# Optional: Install vim plugins
cd ~/Projects/minfiles/setup
./vim.sh
```

## For PVE Hosts

Use [pve-base-setup](https://github.com/y37y/pve-base-setup) for complete PVE host configuration including these dotfiles:

```bash
git clone https://github.com/y37y/pve-base-setup.git
cd pve-base-setup
./base.sh      # Install system tools
./dotfiles.sh  # Install minfiles automatically
```

## Dependencies

### Core Dependencies
- bash
- vim
- git (for setup)

### Optional Tools
- ncdu (disk usage analyzer)
- eza (modern ls replacement)
- ripgrep (modern grep replacement)
- fd (modern find replacement)

### Installing Dependencies

#### Debian/Ubuntu/Proxmox
```bash
sudo apt install vim ripgrep fd-find fzf ncdu
```

#### Alpine
```bash
apk add vim ripgrep fd fzf ncdu
```

## Customization

### Local Configurations
- Create `~/.bashrc.local` for machine-specific settings
- Add `.bash` files to `~/.config/bash/conf.d/`

### Available Sections
- System monitoring aliases
- File operation aliases
- Network tools
- PVE management
- Git integration
- Development tools

## Error Handling
The configuration includes automatic error logging:
- Logs stored in `~/.bash_errors.log`
- Automatic log rotation at 1MB
- Timestamps for all error entries

## Platform Support
- Debian/Ubuntu servers
- Proxmox VE hosts
- Alpine containers
- General Linux environments
