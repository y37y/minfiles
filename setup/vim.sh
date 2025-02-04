#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}Setting up Vim environment...${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
for cmd in git curl; do
    if ! command_exists "$cmd"; then
        echo -e "${RED}$cmd is required but not installed. Please install it first.${NC}"
        exit 1
    fi
done

# Install or update FZF
setup_fzf() {
    echo -e "${BLUE}Setting up FZF...${NC}"
    if [ -d ~/.fzf ]; then
        echo "Updating existing FZF installation..."
        cd ~/.fzf
        git pull
        ./install --bin
    else
        echo "Installing FZF from GitHub..."
        git clone --depth 1 https://github.com/junegunn/fzf ~/.fzf
        ~/.fzf/install --bin
    fi

    # Make FZF globally available
    if [ -w /usr/local/bin ]; then
        cp ~/.fzf/bin/fzf /usr/local/bin/
        chmod 755 /usr/local/bin/fzf
    else
        echo -e "${RED}Cannot write to /usr/local/bin. FZF will only be available in ~/.fzf/bin/${NC}"
    fi
}

# Create vim directories
setup_vim_dirs() {
    echo -e "${BLUE}Creating vim directories...${NC}"
    mkdir -p ~/.vim/{pack/{plugins,themes}/start,backup,swap,undo}
    chmod 700 ~/.vim/{backup,swap,undo}
}

# Define plugins to install
declare -A plugins=(
    ["auto-pairs"]="https://github.com/jiangmiao/auto-pairs.git"
    ["nerdtree"]="https://github.com/preservim/nerdtree.git"
    ["vim-airline"]="https://github.com/vim-airline/vim-airline.git"
    ["vim-airline-themes"]="https://github.com/vim-airline/vim-airline-themes.git"
    ["vim-fugitive"]="https://github.com/tpope/vim-fugitive.git"
    ["fzf"]="https://github.com/junegunn/fzf.git"
    ["fzf.vim"]="https://github.com/junegunn/fzf.vim.git"
)

# Define themes to install
declare -A themes=(
    ["catppuccin"]="https://github.com/catppuccin/vim.git"
    ["tokyonight"]="https://github.com/ghifarit53/tokyonight-vim.git"
    ["dracula"]="https://github.com/dracula/vim.git"
)

# Function to install/update git repositories
install_git_repos() {
    local type=$1
    local dir=$2
    shift 2
    local -n repos=$1

    echo -e "${BLUE}Installing/updating $type...${NC}"
    cd "$dir" || exit 1
    
    for repo_name in "${!repos[@]}"; do
        if [ -d "$repo_name" ]; then
            echo -e "${GREEN}Updating $repo_name...${NC}"
            ( cd "$repo_name" && git pull )
        else
            echo -e "${GREEN}Installing $repo_name...${NC}"
            git clone "${repos[$repo_name]}" "$repo_name"
        fi
    done
}

# Setup shell integration for FZF
setup_shell_integration() {
    echo -e "${BLUE}Setting up shell integration...${NC}"
    
    # Remove old FZF sourcing lines if they exist
    sed -i '/source.*fzf\/shell\/key-bindings.bash/d' ~/.bashrc
    sed -i '/source.*fzf\/shell\/completion.bash/d' ~/.bashrc
    
    # Add new FZF sourcing lines
    echo "source ~/.fzf/shell/key-bindings.bash" >> ~/.bashrc
    echo "source ~/.fzf/shell/completion.bash" >> ~/.bashrc
}

# Copy vimrc
setup_vimrc() {
    echo -e "${BLUE}Setting up vimrc...${NC}"
    if [ -f "$PROJECT_ROOT/vim/.vimrc" ]; then
        cp "$PROJECT_ROOT/vim/.vimrc" ~/.vimrc
    else
        echo -e "${RED}vimrc not found in minfiles!${NC}"
        return 1
    fi
}

# Main installation process
main() {
    # Setup FZF
    setup_fzf

    # Setup Vim directories
    setup_vim_dirs

    # Install plugins and themes
    install_git_repos "plugins" ~/.vim/pack/plugins/start plugins
    install_git_repos "themes" ~/.vim/pack/themes/start themes

    # Setup shell integration
    setup_shell_integration

    # Setup vimrc
    setup_vimrc

    echo -e "${GREEN}Vim setup complete!${NC}"
    echo "
Installed components:
- FZF (Fuzzy Finder)
- Vim plugins:
  - auto-pairs: Auto close brackets
  - nerdtree: File explorer
  - vim-airline: Status bar and themes
  - vim-fugitive: Git integration
  - fzf.vim: FZF integration
- Themes:
  - Catppuccin
  - Tokyo Night
  - Dracula

Next steps:
1. Run 'source ~/.bashrc' to load FZF shell integration
2. Restart vim for changes to take effect

Note: If you see any git-related warnings, they can be safely ignored
for regular vim usage."
}

# Run the installation
main
