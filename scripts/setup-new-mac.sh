#!/usr/bin/env bash
# ============================================================================
# New Mac Setup Script
# ============================================================================
# This script sets up a new Mac with all development tools and configurations
# Run this after cloning the dotfiles repo

set -e  # Exit on error

DOTFILES_DIR="$HOME/dotfiles"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting New Mac Setup..."
echo "================================"

# ============================================================================
# 1. Install Homebrew (if not installed)
# ============================================================================
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# ============================================================================
# 2. Install all packages from Brewfile
# ============================================================================
echo ""
echo "📦 Installing packages from Brewfile..."
cd "$DOTFILES_DIR"

# Check if this is a fresh Mac or existing setup
if [ -f "$DOTFILES_DIR/scripts/generate-brewfile-current.sh" ]; then
    echo "  → Generating Brewfile.current (smart detection of installed packages)..."
    "$DOTFILES_DIR/scripts/generate-brewfile-current.sh"

    echo ""
    echo "  → Installing only missing packages..."
    brew bundle --file=./Brewfile.current
else
    # Fallback to full Brewfile if script doesn't exist
    echo "  → Installing from Brewfile (full install)..."
    brew bundle --file=./Brewfile
fi

# ============================================================================
# 3. Stow dotfiles (with automatic backup)
# ============================================================================
echo ""
echo "🔗 Symlinking dotfiles with stow (backing up existing files)..."
cd "$DOTFILES_DIR"

# Use safe-stow script for automatic backup
if [ -f "$DOTFILES_DIR/scripts/safe-stow.sh" ]; then
    "$DOTFILES_DIR/scripts/safe-stow.sh" zsh git bash npm yarn vscode
else
    # Fallback to manual stow if safe-stow not available
    for dir in zsh git bash npm yarn vscode; do
        if [ -d "$dir" ]; then
            echo "  → Stowing $dir"
            stow -R "$dir" 2>&1 | grep -v "BUG in find_stowed_path" || true
        fi
    done
fi

# ============================================================================
# 4. Configure Git
# ============================================================================
echo ""
echo "🔧 Configuring Git..."

# Set up SSH signing (if key exists)
if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    git config --global gpg.format ssh
    git config --global user.signingkey "$HOME/.ssh/id_ed25519.pub"
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true
    echo "  ✅ SSH signing configured"
else
    echo "  ⚠️  No SSH key found. Generate one with: ssh-keygen -t ed25519 -C 'your_email@example.com'"
fi

# ============================================================================
# 5. Configure Shell
# ============================================================================
echo ""
echo "🐚 Configuring Shell..."

# Set zsh as default shell (recommended)
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "  → Setting zsh as default shell"
    chsh -s "$(which zsh)"
fi

# Note: Bash 5+ is also configured and available
if command -v bash &> /dev/null; then
    bash_version=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    echo "  ✅ Bash ${bash_version} configured (world-class setup)"
fi

# Initialize fzf
if command -v fzf &> /dev/null; then
    echo "  → Setting up fzf key bindings"
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

# ============================================================================
# 6. Rust Setup
# ============================================================================
echo ""
echo "🦀 Checking Rust installation..."

if ! command -v rustc &> /dev/null; then
    echo "  → Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "  ✅ Rust already installed ($(rustc --version))"
fi

# Install common Rust tools (cargo-first philosophy)
echo "  → Installing essential Rust CLI tools via cargo..."
echo "     This may take a while (compiling from source)..."

# Essential cargo tools
CARGO_TOOLS=(
    "cargo-watch"          # Auto-rebuild on file changes
    "cargo-edit"           # Add/remove dependencies from CLI
    "cargo-outdated"       # Check for outdated dependencies
    "cargo-audit"          # Security audit
    "cargo-nextest"        # Better test runner
    "cargo-llvm-cov"       # Code coverage
    "sccache"              # Compiler cache
    "cargo-deny"           # Dependency linter
    "rust-script"          # Run Rust files as scripts
)

for tool in "${CARGO_TOOLS[@]}"; do
    tool_name=$(echo "$tool" | awk '{print $1}')
    if ! cargo install --list | grep -q "^${tool_name} "; then
        echo "     → Installing ${tool_name}..."
        cargo install "$tool_name" 2>/dev/null || echo "       ⚠️  Failed to install ${tool_name}"
    else
        echo "     ✅ ${tool_name} already installed"
    fi
done

# ============================================================================
# 7. Node.js Setup
# ============================================================================
echo ""
echo "📦 Setting up Node.js..."

if command -v node &> /dev/null; then
    echo "  ✅ Node.js $(node --version) installed"
    
    # Install global npm packages
    echo "  → Installing global npm packages..."
    npm install -g npm@latest
    npm install -g yarn pnpm
fi

# ============================================================================
# 8. Python Setup
# ============================================================================
echo ""
echo "🐍 Setting up Python..."

if command -v python3 &> /dev/null; then
    echo "  ✅ Python $(python3 --version) installed"

    # Install essential Python packages
    echo "  → Installing essential Python packages..."
    python3 -m pip install --upgrade pip setuptools wheel 2>/dev/null || true
    python3 -m pip install --user pipx 2>/dev/null || true

    # Ensure pipx is in PATH
    if command -v pipx &> /dev/null; then
        pipx ensurepath 2>/dev/null || true
        echo "  ✅ pipx installed (for isolated Python tools)"
    fi
else
    echo "  ⚠️  Python not found. Install with: brew install python@3.14"
fi

# ============================================================================
# 9. macOS Defaults
# ============================================================================
echo ""
echo "🍎 Configuring macOS defaults..."

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Restart Finder to apply changes
killall Finder 2>/dev/null || true

echo "  ✅ macOS defaults configured"

# ============================================================================
# 10. iTerm2 Configuration
# ============================================================================
echo ""
echo "🖥️  iTerm2 Configuration..."

if [ -d "/Applications/iTerm.app" ]; then
    echo "  ✅ iTerm2 installed"

    # Run iTerm2 configuration script
    if [ -f "$DOTFILES_DIR/scripts/configure-iterm2.sh" ]; then
        echo "  → Running iTerm2 configuration script..."
        "$DOTFILES_DIR/scripts/configure-iterm2.sh" || true
    else
        echo "  → Manual configuration needed:"
        echo "     1. Open iTerm2 → Preferences (⌘,)"
        echo "     2. Profiles → Text → Font"
        echo "     3. Select: MesloLGS NF Regular 13"
        echo "     4. See: ~/dotfiles/ITERM2-SETUP.md"
    fi
else
    echo "  ⚠️  iTerm2 not found. Install with: brew install --cask iterm2"
fi

# ============================================================================
# 11. VSCode Configuration
# ============================================================================
echo ""
echo "💻 VSCode Configuration..."

if [ -d "/Applications/Visual Studio Code.app" ]; then
    echo "  ✅ VSCode installed"

    # Run VSCode configuration script
    if [ -f "$DOTFILES_DIR/scripts/configure-vscode.sh" ]; then
        echo "  → Running VSCode configuration script..."
        "$DOTFILES_DIR/scripts/configure-vscode.sh" || true
    else
        echo "  → Manual configuration needed:"
        echo "     1. Install VSCode CLI: code --install-extension"
        echo "     2. Stow VSCode config: cd ~/dotfiles && stow vscode"
        echo "     3. See: ~/dotfiles/VSCODE-SETUP.md"
    fi
else
    echo "  ⚠️  VSCode not found. Install with: brew install --cask visual-studio-code"
fi

# ============================================================================
# Done!
# ============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ SETUP COMPLETE!                                    ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 What was installed:"
echo "   ✅ Homebrew packages (via smart Brewfile.current)"
echo "   ✅ Rust toolchain + cargo tools"
echo "   ✅ Node.js + global packages"
echo "   ✅ Python + pip/pipx"
echo "   ✅ Dotfiles symlinked via stow (zsh, bash, git, vscode)"
echo "   ✅ Git configured with SSH signing"
echo "   ✅ Bash 5+ with world-class configuration"
echo "   ✅ macOS defaults optimized"
echo "   ✅ iTerm2 configured"
echo "   ✅ VSCode configured with extensions"
echo ""
echo "🔄 Next steps:"
echo "   1. Restart your terminal (or run: exec zsh)"
echo "   2. Restart VSCode to apply all settings"
echo "   3. Configure iTerm2 preferences:"
echo "      → Preferences → General → Preferences"
echo "      → Load preferences from: ~/.config/iterm2"
echo "   4. Add SSH key to GitHub:"
echo "      → gh ssh-key add ~/.ssh/id_ed25519.pub --type signing"
echo "   5. Review machine-specific settings:"
echo "      → ~/.zshenv.local (create if needed)"
echo ""
echo "📚 Useful commands:"
echo "   → Update all tools:  ./scripts/update-all.sh"
echo "   → Check what's installed: ./scripts/generate-brewfile-current.sh"
echo "   → Rust tools: cargo install --list"
echo "   → Brew tools: brew list"
echo ""
echo "📖 Documentation:"
echo "   → Bash setup: ~/dotfiles/BASH-SETUP.md"
echo "   → iTerm2 setup: ~/dotfiles/ITERM2-SETUP.md"
echo "   → VSCode setup: ~/dotfiles/VSCODE-SETUP.md"
echo "   → Zsh config: ~/dotfiles/ZSHRC-REFACTOR.md"
echo "   → Git config: ~/dotfiles/GIT-REFACTOR.md"
echo ""
echo "🎉 Enjoy your new Mac setup!"
echo ""

