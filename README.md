# Minfiles

A minimal but powerful dotfiles configuration optimized for server environments and system administration. Features secure defaults, comprehensive monitoring aliases, and smart infrastructure management tools.

## Overview
- 🔒 Security-focused defaults with restrictive permissions
- 🛠️ Comprehensive system monitoring and management tools
- 🔧 Smart detection of available commands and tools
- 📊 Error logging and system status tracking
- 🖥️ Proxmox VE (PVE) integration when available
- 🔑 GPG and SSH management utilities

## Security Features
- Restrictive umask (027) for secure file permissions
- Core dump prevention (ulimit -c 0)
- Secure directory creation (700 permissions)
- Noclobber protection against file overwrites
- Error logging with rotation

## Core Functionality
### System Monitoring
- Enhanced df/du commands
- Memory and CPU usage tracking
- Disk space monitoring
- Process management
- Network connection monitoring

### Infrastructure Management
- Proxmox VE integration
- Container management
- Storage monitoring
- System status tracking

### Network Tools
- SSH management
- Port checking
- Network status monitoring
- IP and connectivity tools

## Installation
```bash
# Clone repository
git clone https://github.com/y37y/minfiles.git

# Backup existing configs
cp ~/.bashrc ~/.bashrc.backup

# Copy new config
cp ~/minfiles/.bashrc ~/.bashrc
```

## Dependencies
### Core Dependencies (usually pre-installed)
- bash
- vim
- basic GNU utilities

### Optional Tools
- ncdu (disk usage analyzer)
- eza (modern ls replacement)
- ripgrep (modern grep replacement)
- fd (modern find replacement)

### Installation on Different Platforms
#### Debian/Ubuntu
```bash
sudo apt update
sudo apt install vim ncdu ripgrep
```

#### Alpine
```bash
apk add vim ncdu ripgrep
```

#### Proxmox
```bash
apt update
apt install vim ncdu ripgrep
```

## Customization
### Local Configurations
- Create `~/.bashrc.local` for machine-specific settings
- Add `.bash` files to `~/.config/bash/conf.d/`

### Available Sections
- System monitoring aliases
- File operation aliases
- Network tools
- PVE management (when available)
- Git integration (optional)
- GPG configuration (optional)

## Usage Examples
### System Monitoring
```bash
monitor_system  # Shows real-time system stats
check_disk_space  # Check volumes over 80% usage
psmem  # Top memory-consuming processes
pscpu  # Top CPU-consuming processes
```

### Network Operations
```bash
portcheck host port  # Check if port is open
myip  # Show public IP
localip  # Show local IPs
ports  # Show listening ports
```

### PVE Management (when available)
```bash
pl  # List containers
pstart_all 100 101 102  # Start multiple containers
sto  # Storage status
```

## Error Handling
The configuration includes automatic error logging:
- Logs are stored in `~/.bash_errors.log`
- Automatic log rotation at 1MB
- Timestamps for all error entries

## Security Notes
- Designed with security in mind for server environments
- Implements restrictive file permissions
- Includes safe operation defaults
- Optional GPG/SSH integration

## Platform Support
- Debian/Ubuntu servers
- Proxmox VE hosts
- Alpine containers
- General Linux environments

