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
brew bundle --file=./Brewfile

# ============================================================================
# 3. Stow dotfiles
# ============================================================================
echo ""
echo "🔗 Symlinking dotfiles with stow..."
cd "$DOTFILES_DIR"

# Stow each directory
for dir in zsh git bash npm yarn vscode; do
    if [ -d "$dir" ]; then
        echo "  → Stowing $dir"
        stow -v "$dir" 2>&1 | grep -v "BUG in find_stowed_path"
    fi
done

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

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "  → Setting zsh as default shell"
    chsh -s "$(which zsh)"
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

# Install common Rust tools
echo "  → Installing Rust CLI tools..."
cargo install cargo-watch cargo-edit cargo-outdated cargo-audit 2>/dev/null || true

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
# 8. macOS Defaults
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
# 9. iTerm2 Configuration
# ============================================================================
echo ""
echo "🖥️  iTerm2 Configuration..."

if [ -d "/Applications/iTerm.app" ]; then
    echo "  ✅ iTerm2 installed"
    echo "  → Configure iTerm2 to load preferences from: ~/.config/iterm2"
    echo "     (Preferences → General → Preferences → Load preferences from custom folder)"
else
    echo "  ⚠️  iTerm2 not found. Install with: brew install --cask iterm2"
fi

# ============================================================================
# Done!
# ============================================================================
echo ""
echo "================================"
echo "✅ Setup Complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Configure iTerm2 preferences (if using iTerm2)"
echo "  3. Add your SSH key to GitHub: gh ssh-key add ~/.ssh/id_ed25519.pub"
echo "  4. Review and customize ~/.zshenv.local for machine-specific settings"
echo ""
echo "Enjoy your new Mac! 🎉"

