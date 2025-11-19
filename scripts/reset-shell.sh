#!/usr/bin/env bash
# Nuclear option: Reset shell completely

echo "🔥 Resetting shell environment..."
echo ""

# Clear all aliases
echo "Clearing all aliases..."
unalias -a 2>/dev/null || true

# Clear all functions
echo "Clearing all functions..."
unfunction -m '*' 2>/dev/null || true

# Rehash commands
echo "Rehashing command table..."
hash -r 2>/dev/null || true
rehash 2>/dev/null || true

# Reset PATH to system default
echo "Resetting PATH..."
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Add Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Test basic commands
echo ""
echo "Testing basic commands:"
echo "  brew: $(which brew 2>&1)"
echo "  git: $(which git 2>&1)"
echo "  zsh: $(which zsh 2>&1)"

echo ""
echo "✅ Environment reset complete!"
echo ""
echo "Now starting a fresh zsh shell..."
echo ""

# Start fresh zsh with explicit config
exec /bin/zsh -l

