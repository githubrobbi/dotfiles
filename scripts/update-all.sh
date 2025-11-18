#!/usr/bin/env bash
# ============================================================================
# update-all.sh - Update all tools and packages
# ============================================================================
# Updates: Homebrew, Rust, Cargo tools, Node.js, Python packages
# ============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
echo "║                    🔄 UPDATE ALL TOOLS                                   ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# 1. Homebrew
# ============================================================================
log_info "Updating Homebrew..."
if command -v brew &>/dev/null; then
    brew update
    brew upgrade
    brew cleanup
    log_success "Homebrew updated"
else
    log_warning "Homebrew not installed"
fi

# ============================================================================
# 2. Rust
# ============================================================================
echo ""
log_info "Updating Rust toolchain..."
if command -v rustup &>/dev/null; then
    rustup update
    log_success "Rust toolchain updated"
else
    log_warning "Rust not installed"
fi

# ============================================================================
# 3. Cargo Tools
# ============================================================================
echo ""
log_info "Updating Cargo tools..."
if command -v cargo &>/dev/null; then
    # Get list of installed cargo tools
    INSTALLED_TOOLS=$(cargo install --list | grep -E '^[a-z]' | awk '{print $1}' | sort)
    
    if [ -n "$INSTALLED_TOOLS" ]; then
        echo "  → Found $(echo "$INSTALLED_TOOLS" | wc -l | xargs) cargo tools"
        
        # Update each tool
        while IFS= read -r tool; do
            echo "     → Updating $tool..."
            cargo install "$tool" --force 2>/dev/null || log_warning "Failed to update $tool"
        done <<< "$INSTALLED_TOOLS"
        
        log_success "Cargo tools updated"
    else
        log_warning "No cargo tools installed"
    fi
else
    log_warning "Cargo not installed"
fi

# ============================================================================
# 4. Node.js (npm/yarn/pnpm)
# ============================================================================
echo ""
log_info "Updating Node.js packages..."
if command -v npm &>/dev/null; then
    npm update -g
    log_success "npm packages updated"
else
    log_warning "npm not installed"
fi

if command -v yarn &>/dev/null; then
    yarn global upgrade
    log_success "yarn packages updated"
fi

if command -v pnpm &>/dev/null; then
    pnpm update -g
    log_success "pnpm packages updated"
fi

# ============================================================================
# 5. Python (pip/pipx)
# ============================================================================
echo ""
log_info "Updating Python packages..."
if command -v python3 &>/dev/null; then
    python3 -m pip install --upgrade pip setuptools wheel 2>/dev/null || true
    log_success "pip updated"
else
    log_warning "Python not installed"
fi

if command -v pipx &>/dev/null; then
    pipx upgrade-all
    log_success "pipx packages updated"
fi

# ============================================================================
# 6. macOS App Store (if mas is installed)
# ============================================================================
echo ""
if command -v mas &>/dev/null; then
    log_info "Updating App Store apps..."
    mas upgrade
    log_success "App Store apps updated"
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ ALL UPDATES COMPLETE                               ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""
log_info "Updated:"
echo "   ✅ Homebrew packages"
echo "   ✅ Rust toolchain"
echo "   ✅ Cargo tools"
echo "   ✅ Node.js packages"
echo "   ✅ Python packages"
echo ""
log_info "To check versions:"
echo "   → brew list --versions"
echo "   → rustc --version"
echo "   → cargo install --list"
echo "   → node --version && npm --version"
echo "   → python3 --version"
echo ""

