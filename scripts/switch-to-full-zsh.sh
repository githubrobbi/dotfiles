#!/usr/bin/env bash
# Switch back to full .zshrc

set -e

echo "🔧 Switching to full .zshrc..."
echo ""

# Remove the current symlink
if [[ -L ~/.zshrc ]]; then
  echo "📝 Removing current .zshrc symlink..."
  rm ~/.zshrc
fi

# Create new symlink to full config
echo "📝 Creating symlink to full config..."
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc

echo ""
echo "✅ Switched to full .zshrc!"
echo ""
echo "Now run: exec zsh"

