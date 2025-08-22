# Minfiles

A general-purpose dotfiles configuration for Unix environments and server administration. Provides enhanced shell functionality with smart tool detection and comprehensive aliases.

## Overview
- Security-focused defaults and permissions
- Smart command detection and fallbacks
- Comprehensive system aliases and functions
- Cross-platform compatibility
- System monitoring and management tools

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
  ```

### Development Tools
- Git integration with comprehensive aliases
- Modern tool support (eza, ripgrep, fd, fzf)
- Vim configuration with cross-platform compatibility
- Tmux integration when available

### Optional PVE Integration
When Proxmox VE is detected, additional container management aliases are loaded:
  ```bash
  pl        # List containers
  pstart    # Start container
  pstop     # Stop container
  pen       # Enter container
  ```

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

For complete PVE host setup with system tools and specialized configuration, use [pve-base-setup](https://github.com/y37y/pve-base-setup):

```bash
git clone https://github.com/y37y/pve-base-setup.git
cd pve-base-setup
./base.sh      # Install system tools
./dotfiles.sh  # Install PVE-optimized configuration
```

Note: pve-base-setup includes its own PVE-specific dotfiles optimized for Proxmox administration.

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
- fzf (fuzzy finder)

### Installing Dependencies

#### Debian/Ubuntu
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
- Git integration
- Development tools
- Platform-specific features

## Error Handling
The configuration includes automatic error logging:
- Logs stored in `~/.bash_errors.log`
- Automatic log rotation at 1MB
- Timestamps for all error entries

## Platform Support
- Debian/Ubuntu servers
- Alpine containers
- FreeBSD systems
- macOS (with Homebrew)
- General Linux environments
