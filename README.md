# Minfiles

A minimal but powerful dotfiles configuration optimized for both modern and traditional Unix environments. Features extensive alias configurations, modern CLI tool integration, and smart fallbacks.

## Overview

- 🔧 Smart fallbacks between modern and traditional tools
- 🚀 Extensive alias collection for rapid navigation and operations
- 🛡️ Safe file operation defaults
- 🎨 Color-enabled output where supported
- 🔄 Intelligent history management
- 🌲 Git integration in prompt

## Features

### Core Functionality
- Modern CLI tool support (eza, ripgrep, fd, fzf) with fallbacks
- Comprehensive alias system for common operations
- Safe defaults for file operations
- XDG Base Directory support
- Automatic command existence checking
- Local configuration support

### Alias Categories
- Navigation (`z`, `cdl`, directory traversal)
- File operations (safe defaults)
- Git operations (extensive shortcuts)
- Config editing (SSH, hosts file)
- System monitoring
- Network operations

### Configurations
- `.bashrc`: Enhanced bash configuration
- `.vimrc`: Vim configuration
- `tmux/`: Tmux configuration

## Installation

### Option 1: Direct Copy (Recommended)
```bash
# Clone repository
git clone https://github.com/y37y/minfiles.git

# Backup existing configs
cp ~/.bashrc ~/.bashrc.backup
cp ~/.vimrc ~/.vimrc.backup

# Copy new configs
cp ~/minfiles/.bashrc ~/.bashrc
cp ~/minfiles/.vimrc ~/.vimrc
cp -r ~/minfiles/tmux ~/.config/
```

### Option 2: Source Method
Add to your existing ~/.bashrc:
```bash
# Add to end of ~/.bashrc
[ -f ~/minfiles/.bashrc ] && source ~/minfiles/.bashrc
```

## Dependencies

### Core Dependencies
- bash
- vim
- tmux

### Optional Modern CLI Tools
- eza (modern ls replacement)
- ripgrep (modern grep replacement)
- fd (modern find replacement)
- fzf (fuzzy finder)
- ncdu (disk usage analyzer)

### Installation of Dependencies

#### Ubuntu/Debian
```bash
sudo apt install ripgrep fd-find fzf tmux gpg ncdu
```

#### Arch Linux
```bash
sudo pacman -S ripgrep fd fzf eza tmux gnupg ncdu
```

#### macOS
```bash
brew install ripgrep fd fzf eza tmux gnupg ncdu
```

## Customization

### Local Customizations
- Create `~/.bashrc.local` for machine-specific settings
- Add `.bash` files to `~/.config/bash/conf.d/`

### Config Editing Aliases
- `vb`: Edit bashrc
- `vv`: Edit vimrc
- `vc`/`vsc`: Edit SSH config
- `vh`: Edit hosts file

### Navigation Aliases
- `z`: cd
- `cdl`: cd and list
- `..`, `...`, `....`: Directory traversal
- `-` or `b`: Previous directory

### File Operation Aliases
- Safe defaults for `rm`, `cp`, `mv`
- Enhanced listing with colors
- Modern alternatives when available

## Usage Examples

### Basic Navigation
```bash
z ~/projects    # Change directory
cdl documents   # Change and list
b              # Go back to previous directory
```

### File Operations
```bash
la              # List all with details (eza if available)
rmf old_dir     # Safe recursive remove
cpr src dest    # Recursive copy with confirmation
```

### Git Operations
```bash
glog            # Enhanced git log
gdf             # Git diff
gpristine       # Reset to pristine state
```

## Maintenance

The configuration automatically:
- Manages history with duplicates removal
- Sets safe file operation defaults
- Provides color output where supported
- Checks for command availability before setting aliases
