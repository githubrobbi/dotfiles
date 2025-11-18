# dotfiles

Personal dotfiles for macOS development environment. Symlinked with GNU Stow.

## Philosophy

- **Rust tools via cargo first**: Prefer `cargo install` for Rust-based CLI tools
- **Brew for system tools**: Use Homebrew for system-wide tools and non-Rust packages
- **Stow for dotfiles**: Use GNU Stow to symlink dotfiles into place
- **SSH signing**: All commits are signed with SSH keys

## Quick Setup

### New Mac (Complete Setup)
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Clone dotfiles
git clone git@github.com:githubrobbi/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install all tools
brew bundle --file=Brewfile.superset

# Install Rust (if not via brew)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install cargo tools
cargo install cargo-watch cargo-edit cargo-outdated cargo-audit

# Stow dotfiles
stow zsh git bash npm yarn vscode
```

### Existing Mac (Minimal Install)
```bash
cd ~/dotfiles
brew bundle --file=Brewfile.current  # Only install missing tools
```

## Files

- **Brewfile** - Main Brewfile (superset)
- **Brewfile.superset** - Complete tool list for brand new Mac
- **Brewfile.current** - Minimal additions for existing setup
- **README-TOOLS.md** - Comprehensive tool reference guide
- **scripts/setup-new-mac.sh** - Automated setup script

## Contents

- `bash/`: Bash configuration
- `git/`: `.gitconfig`, `.gitignore_global`
- `npm/`: NPM configuration
- `scripts/`: Setup and utility scripts
- `vscode/`: VS Code settings
- `yarn/`: Yarn configuration
- `zsh/`: `.zshrc`, `.zprofile`, `.zshenv`, `.p10k.zsh` (Powerlevel10k)

## Tools Installed

### Core Development
- git, gh, git-delta, zsh, powerlevel10k, starship, stow

### Rust Ecosystem (via cargo)
- rustup, cargo, rustc
- cargo-watch, cargo-edit, cargo-outdated, cargo-audit
- cargo-nextest, cargo-llvm-cov, cargo-deny, sccache, rust-script

### Modern CLI (Rust-powered, via brew)
- bat, eza, fd, ripgrep, sd, procs, bottom, dust, tokei, hyperfine, zoxide

### Languages & Runtimes
- Node.js, Python 3.14, Go

### Security & Secrets
- gnupg, gopass, age, sops

### Productivity
- fzf, jq, yq, tree, tmux, neovim, autojump, tldr, direnv

### GUI Applications
- iTerm2, Visual Studio Code, Docker, Rectangle

## Updating

```bash
# Update Homebrew packages
brew update && brew upgrade

# Update Rust toolchain
rustup update

# Update cargo tools
cargo install-update -a  # requires: cargo install cargo-update
```

## Git Signing

This repo uses SSH signing for commits.

```bash
# Configure git signing (already set locally in this repo)
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub

# Add signing key to GitHub
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing
```

## Notes

- Commits are SSH-signed (configured locally in this repo)
- Use `stow --adopt` to fold stray files into the repo
- See `README-TOOLS.md` for detailed tool usage and examples
