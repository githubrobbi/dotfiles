#!/usr/bin/env bash
# ============================================================================
# configure-iterm2.sh - Configure iTerm2 with Nerd Fonts and optimal settings
# ============================================================================
# Sets up iTerm2 with proper fonts for Powerlevel10k theme
# ============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    🖥️  iTerm2 Configuration                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# 1. Check if iTerm2 is installed
# ============================================================================
if [ ! -d "/Applications/iTerm.app" ]; then
    log_error "iTerm2 not found at /Applications/iTerm.app"
    echo ""
    echo "Install iTerm2:"
    echo "  brew install --cask iterm2"
    exit 1
fi

log_success "iTerm2 is installed"

# ============================================================================
# 2. Check if Nerd Fonts are installed
# ============================================================================
echo ""
log_info "Checking Nerd Fonts..."

NERD_FONTS=(
    "MesloLGSNerdFont-Regular.ttf"
    "FiraCodeNerdFont-Regular.ttf"
    "JetBrainsMonoNerdFont-Regular.ttf"
    "HackNerdFont-Regular.ttf"
)

FONTS_INSTALLED=0
for font in "${NERD_FONTS[@]}"; do
    if [ -f "$HOME/Library/Fonts/$font" ]; then
        log_success "Found: $font"
        FONTS_INSTALLED=$((FONTS_INSTALLED + 1))
    fi
done

if [ $FONTS_INSTALLED -eq 0 ]; then
    log_error "No Nerd Fonts found!"
    echo ""
    echo "Install Nerd Fonts:"
    echo "  brew install --cask font-meslo-lg-nerd-font"
    echo "  brew install --cask font-fira-code-nerd-font"
    echo "  brew install --cask font-jetbrains-mono-nerd-font"
    echo "  brew install --cask font-hack-nerd-font"
    exit 1
fi

log_success "Found $FONTS_INSTALLED Nerd Font(s)"

# ============================================================================
# 3. Configure iTerm2 Font Settings
# ============================================================================
echo ""
log_info "Configuring iTerm2 font settings..."

# Check if iTerm2 is running
ITERM_RUNNING=false
if pgrep -x "iTerm2" > /dev/null; then
    ITERM_RUNNING=true
    log_warning "iTerm2 is currently running"
    echo ""
    echo "For best results, please:"
    echo "  1. Quit iTerm2 (⌘Q)"
    echo "  2. Run this script again"
    echo "  3. Reopen iTerm2"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Cancelled. Please quit iTerm2 and run again."
        exit 0
    fi
fi

# Set font to MesloLGS NF (recommended by Powerlevel10k)
# Note: These settings apply to the Default profile
FONT_NAME="MesloLGSNF-Regular"
FONT_SIZE=13

log_info "Setting font to: $FONT_NAME $FONT_SIZE"

# Configure font settings via defaults
defaults write com.googlecode.iterm2 "Normal Font" -string "$FONT_NAME $FONT_SIZE"
defaults write com.googlecode.iterm2 "Use Non-ASCII Font" -bool false
defaults write com.googlecode.iterm2 "Use Bold Font" -bool true
defaults write com.googlecode.iterm2 "Use Italic Font" -bool true

log_success "Font configured: $FONT_NAME $FONT_SIZE"

# ============================================================================
# 4. Additional iTerm2 Settings
# ============================================================================
echo ""
log_info "Applying additional iTerm2 settings..."

# Scrollback
defaults write com.googlecode.iterm2 "Scrollback Lines" -int 10000
defaults write com.googlecode.iterm2 "Unlimited Scrollback" -bool true
log_success "Scrollback: Unlimited"

# Window settings
defaults write com.googlecode.iterm2 "Window Type" -int 0
defaults write com.googlecode.iterm2 "Columns" -int 120
defaults write com.googlecode.iterm2 "Rows" -int 35
log_success "Window size: 120x35"

# Disable annoying features
defaults write com.googlecode.iterm2 "PromptOnQuit" -bool false
defaults write com.googlecode.iterm2 "OnlyWhenMoreTabs" -bool true
log_success "Disabled quit confirmation"

# ============================================================================
# 5. Check Powerlevel10k Configuration
# ============================================================================
echo ""
log_info "Checking Powerlevel10k configuration..."

if [ -L "$HOME/.p10k.zsh" ]; then
    log_success ".p10k.zsh is symlinked"
else
    log_warning ".p10k.zsh not found or not symlinked"
    if [ -f "$HOME/dotfiles/zsh/.p10k.zsh" ]; then
        log_info "Re-stowing zsh dotfiles..."
        cd "$HOME/dotfiles" && stow -R zsh
        log_success "Stowed zsh dotfiles"
    fi
fi

if grep -q "powerlevel10k.zsh-theme" "$HOME/.zshrc" 2>/dev/null; then
    log_success "Powerlevel10k theme is loaded in .zshrc"
else
    log_warning "Powerlevel10k theme not found in .zshrc"
fi

# ============================================================================
# 6. Test Icon Support
# ============================================================================
echo ""
log_info "Testing icon support..."
echo ""
echo -e "  ${CYAN}Test icons:${NC} \ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
echo ""
echo "  You should see:  ±  ➦ ✘ ⚡ ⚙"
echo ""
echo "  If you see boxes or question marks, the font isn't working."
echo ""

# ============================================================================
# Summary
# ============================================================================
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ iTerm2 CONFIGURATION COMPLETE                      ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""
log_info "What was configured:"
echo "   ✅ Font: $FONT_NAME $FONT_SIZE"
echo "   ✅ Non-ASCII font: Disabled"
echo "   ✅ Scrollback: Unlimited"
echo "   ✅ Window size: 120x35"
echo "   ✅ Quit confirmation: Disabled"
echo ""

if [ "$ITERM_RUNNING" = true ]; then
    log_warning "iTerm2 is still running!"
    echo ""
    echo "🔄 Next steps:"
    echo "   1. Quit iTerm2 completely (⌘Q)"
    echo "   2. Reopen iTerm2"
    echo "   3. Open a new tab/window"
    echo "   4. You should see Powerlevel10k theme with icons!"
    echo ""
    echo "   If icons don't show, run: p10k configure"
else
    echo "🔄 Next steps:"
    echo "   1. Open iTerm2"
    echo "   2. You should see Powerlevel10k theme with icons!"
    echo "   3. If icons don't show, run: p10k configure"
fi

echo ""
log_info "Manual configuration (if needed):"
echo "   → iTerm2 → Preferences (⌘,)"
echo "   → Profiles → Text → Font"
echo "   → Select: MesloLGS NF Regular 13"
echo ""
log_info "Documentation: ~/dotfiles/ITERM2-SETUP.md"
echo ""

