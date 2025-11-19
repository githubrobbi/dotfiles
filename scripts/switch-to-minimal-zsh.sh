#!/usr/bin/env bash
# Switch to minimal .zshrc for debugging

set -e

echo "🔧 Switching to minimal .zshrc..."
echo ""

# Remove the symlink
if [[ -L ~/.zshrc ]]; then
  echo "📝 Removing current .zshrc symlink..."
  rm ~/.zshrc
fi

# Create new symlink to minimal config
echo "📝 Creating symlink to minimal config..."
ln -s ~/dotfiles/zsh/.zshrc.minimal ~/.zshrc

echo ""
echo "✅ Switched to minimal .zshrc!"
echo ""
echo "Now run: exec zsh"
echo ""
echo "To switch back to full config, run:"
echo "  ~/dotfiles/scripts/switch-to-full-zsh.sh"

