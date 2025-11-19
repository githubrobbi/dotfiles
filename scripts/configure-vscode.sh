#!/usr/bin/env bash

# ============================================================================
# VSCode Configuration Script
# ============================================================================
# Configures VSCode with world-class settings, extensions, and keybindings
# Part of the dotfiles master setup
# ============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1"
}

# ============================================================================
# 1. Check Prerequisites
# ============================================================================
echo ""
log_info "Checking prerequisites..."

# Check if VSCode is installed
if ! command -v code &>/dev/null; then
  log_error "VSCode CLI not found!"
  log_info "Installing VSCode CLI..."
  
  # Check if VSCode app exists
  if [ -d "/Applications/Visual Studio Code.app" ]; then
    # Add code command to PATH
    cat <<'EOF' >>~/.zshrc

# VSCode CLI
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF
    log_success "VSCode CLI path added to .zshrc"
    log_warning "Please run: source ~/.zshrc or restart your terminal"
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  else
    log_error "VSCode is not installed. Please install it first:"
    log_info "  brew install --cask visual-studio-code"
    exit 1
  fi
fi

log_success "VSCode CLI is available"

# ============================================================================
# 2. Stow VSCode Configuration
# ============================================================================
echo ""
log_info "Symlinking VSCode configuration files..."

cd ~/dotfiles || exit 1

# Stow VSCode config (creates symlinks)
if stow -R vscode 2>/dev/null; then
  log_success "VSCode configuration symlinked successfully"
else
  log_warning "Stow encountered conflicts. Trying with --adopt..."
  stow --adopt vscode
  log_success "VSCode configuration adopted and symlinked"
fi

# Verify symlinks
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [ -L "$VSCODE_USER_DIR/settings.json" ]; then
  log_success "settings.json symlinked: $(readlink "$VSCODE_USER_DIR/settings.json")"
else
  log_warning "settings.json is not a symlink"
fi

if [ -L "$VSCODE_USER_DIR/keybindings.json" ]; then
  log_success "keybindings.json symlinked: $(readlink "$VSCODE_USER_DIR/keybindings.json")"
else
  log_warning "keybindings.json is not a symlink"
fi

# ============================================================================
# 3. Install Essential Extensions
# ============================================================================
echo ""
log_info "Installing essential VSCode extensions..."

# Theme & Icons
log_info "Installing theme and icons..."
code --install-extension catppuccin.catppuccin-vsc --force
code --install-extension catppuccin.catppuccin-vsc-icons --force
code --install-extension antfu.icons-carbon --force

# Rust Development
log_info "Installing Rust extensions..."
code --install-extension rust-lang.rust-analyzer --force
code --install-extension vadimcn.vscode-lldb --force
code --install-extension serayuzgur.crates --force
code --install-extension tamasfe.even-better-toml --force

# JavaScript/TypeScript
log_info "Installing JavaScript/TypeScript extensions..."
code --install-extension dbaeumer.vscode-eslint --force
code --install-extension esbenp.prettier-vscode --force
code --install-extension christian-kohler.npm-intellisense --force
code --install-extension christian-kohler.path-intellisense --force

# Python
log_info "Installing Python extensions..."
code --install-extension ms-python.python --force
code --install-extension ms-python.vscode-pylance --force
code --install-extension ms-python.black-formatter --force

# Git & Version Control
log_info "Installing Git extensions..."
code --install-extension eamodio.gitlens --force
code --install-extension mhutchie.git-graph --force
code --install-extension github.vscode-pull-request-github --force

# Docker & Containers
log_info "Installing Docker extensions..."
code --install-extension ms-azuretools.vscode-docker --force
code --install-extension ms-vscode-remote.remote-containers --force

# Markdown
log_info "Installing Markdown extensions..."
code --install-extension yzhang.markdown-all-in-one --force
code --install-extension davidanson.vscode-markdownlint --force

# YAML & Config
log_info "Installing YAML/Config extensions..."
code --install-extension redhat.vscode-yaml --force
code --install-extension dotenv.dotenv-vscode --force

# Shell Scripting
log_info "Installing Shell extensions..."
code --install-extension foxundermoon.shell-format --force
code --install-extension timonwong.shellcheck --force

# Code Quality
log_info "Installing code quality extensions..."
code --install-extension streetsidesoftware.code-spell-checker --force
code --install-extension editorconfig.editorconfig --force
code --install-extension aaron-bond.better-comments --force
code --install-extension usernamehw.errorlens --force

# Productivity
log_info "Installing productivity extensions..."
code --install-extension gruntfuggly.todo-tree --force
code --install-extension alefragnani.bookmarks --force
code --install-extension wmaurer.change-case --force

# AI & Code Assistance (if not already installed)
if ! code --list-extensions | grep -q "augment.vscode-augment"; then
  log_info "Installing Augment extension..."
  code --install-extension augment.vscode-augment --force
fi

log_success "Essential extensions installed!"

# ============================================================================
# 4. Optional Extensions (User Choice)
# ============================================================================
echo ""
log_info "Optional extensions available:"
echo ""
echo "  Java/Kotlin Development:"
echo "    code --install-extension redhat.java"
echo "    code --install-extension fwcd.kotlin"
echo ""
echo "  Go Development:"
echo "    code --install-extension golang.go"
echo ""
echo "  GitHub Copilot (requires subscription):"
echo "    code --install-extension github.copilot"
echo "    code --install-extension github.copilot-chat"
echo ""
echo "  REST API Testing:"
echo "    code --install-extension humao.rest-client"
echo "    code --install-extension rangav.vscode-thunder-client"
echo ""
echo "  Database Tools:"
echo "    code --install-extension mtxr.sqltools"
echo "    code --install-extension mtxr.sqltools-driver-pg"
echo ""

# ============================================================================
# 5. Verify Installation
# ============================================================================
echo ""
log_info "Verifying installation..."

EXTENSION_COUNT=$(code --list-extensions | wc -l | tr -d ' ')
log_success "Total extensions installed: $EXTENSION_COUNT"

# ============================================================================
# 6. Final Instructions
# ============================================================================
echo ""
log_success "VSCode configuration complete!"
echo ""
log_info "Next steps:"
echo "  1. Restart VSCode to apply all settings"
echo "  2. Select theme: Cmd+K Cmd+T → 'Catppuccin Mocha'"
echo "  3. Select icon theme: Preferences → File Icon Theme → 'Catppuccin Mocha'"
echo "  4. Review settings: Cmd+, (or Cmd+K Cmd+R)"
echo "  5. Review keybindings: Cmd+K Cmd+S"
echo ""
log_info "Configuration files are symlinked from ~/dotfiles/vscode/"
log_info "Any changes in VSCode will be reflected in your dotfiles repo!"
echo ""
log_info "See VSCODE-SETUP.md for detailed documentation"
echo ""

