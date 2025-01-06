# Minfiles

A minimal but powerful dotfiles configuration focusing on simplicity and cross-platform compatibility. Includes optimized configurations for bash, vim, and tmux.

## Features

### Bash Configuration (.bashrc)
- 🛡️ Secure default settings with enhanced permissions and security checks
- 🔄 Intelligent history management with duplicates removal
- 🚀 Modern CLI tool integration (eza, ripgrep, fd, fzf)
- 🔑 Comprehensive GPG and SSH configuration
- 🌳 Git-aware prompt with system monitoring
- 📁 XDG Base Directory support
- 🧹 Automated cleanup routines

### Vim Configuration (.vimrc)
- Minimal yet functional vim setup
- Basic key mappings and settings

### Tmux Configuration
- Session management
- Custom key bindings
- Status bar customization

## Installation

1. Clone the repository:
```bash
git clone https://github.com/y37y/minfiles.git
```

2. Create symbolic links:
```bash
ln -sf ~/minfiles/.bashrc ~/.bashrc
ln -sf ~/minfiles/.vimrc ~/.vimrc
ln -sf ~/minfiles/tmux ~/.config/tmux
```

## Dependencies

### Required
- bash
- vim
- tmux

### Optional (Recommended)
- eza (modern ls replacement)
- ripgrep (modern grep replacement)
- fd (modern find replacement)
- fzf (fuzzy finder)

### Installation of Dependencies

#### Ubuntu/Debian
```bash
sudo apt install ripgrep fd-find fzf tmux gpg
```

#### Arch Linux
```bash
sudo pacman -S ripgrep fd fzf eza tmux gnupg
```

#### macOS
```bash
brew install ripgrep fd fzf eza tmux gnupg
```

## Structure

```
.
├── .bashrc          # Bash configuration
├── .vimrc           # Vim configuration
├── tmux/            # Tmux configuration
└── .gitmodules      # Git submodules
```

## Customization

- Local bash customizations: Create `~/.bashrc.local`
- Additional configurations: Add `.bash` files to `~/.config/bash/conf.d/`

## Features in Detail

### Bash Aliases and Functions
- System monitoring
- File operations
- Network tools
- Git operations
- GPG management
- Development tools

### Security Features
- Secure file permissions (umask 027)
- Auto-logout after inactivity
- GPG and SSH integration
- Core dump protection

### System Maintenance
- Automatic temp file cleanup
- Cache management
- Error logging
