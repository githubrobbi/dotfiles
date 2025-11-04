# dotfiles

Symlinked with GNU Stow.

## Quick setup (new Mac)
~~~~bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file=./Brewfile
stow zsh git
~~~~

## Contents
- `zsh/`: `.zshrc`, `.zprofile`, `.zshenv` (loads `~/.zshenv.local`).
- `git/`: `.gitconfig`.

## Notes
- Commits are SSH-signed (repo-local).
- Use `stow --adopt` later to fold stray files into the repo.
