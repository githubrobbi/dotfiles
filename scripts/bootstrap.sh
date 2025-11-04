#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Ensure Homebrew (Apple silicon)
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages/apps
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Link dotfiles
cd "$DOTFILES_DIR"
stow zsh git

echo "✅ Bootstrap complete. Open a new shell."
