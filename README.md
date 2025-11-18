# dotfiles

Personal dotfiles for macOS development environment. Symlinked with GNU Stow.

## Philosophy

- **Rust tools via cargo first**: Prefer `cargo install` for Rust-based CLI tools
- **Brew for system tools**: Use Homebrew for system-wide tools and non-Rust packages
- **Stow for dotfiles**: Use GNU Stow to symlink dotfiles into place
- **SSH signing**: All commits are signed with SSH keys

## Quick Setup

### New Mac (Automated - Recommended!)
```bash
# 1. Clone this repo
git clone git@github.com:githubrobbi/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run the setup script (does everything!)
./scripts/setup-new-mac.sh
```

**What the setup script does:**
1. ✅ Installs Homebrew (if needed)
2. ✅ Generates Brewfile.current (smart detection)
3. ✅ Installs only missing brew packages
4. ✅ Symlinks dotfiles via stow
5. ✅ Configures Git with SSH signing
6. ✅ Installs Rust toolchain (via rustup)
7. ✅ Installs all cargo tools (cargo-first!)
8. ✅ Sets up Node.js + global packages
9. ✅ Sets up Python + pip/pipx
10. ✅ Configures macOS defaults
11. ✅ Configures iTerm2

### New Mac (Manual Setup)
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

# Install cargo tools (see Brewfile.superset for full list)
cargo install cargo-watch cargo-edit cargo-outdated cargo-audit cargo-nextest cargo-llvm-cov sccache cargo-deny rust-script

# Stow dotfiles
stow zsh git bash npm yarn vscode
```

### Existing Mac (Minimal Install)
```bash
cd ~/dotfiles

# Generate Brewfile.current (checks what's already installed)
./scripts/generate-brewfile-current.sh

# Review what will be installed
cat Brewfile.current

# Install only missing tools
brew bundle --file=Brewfile.current
```

## Files

- **Brewfile** - Main Brewfile (superset for new Macs)
- **Brewfile.superset** - Complete tool list for brand new Mac (same as Brewfile)
- **Brewfile.current** - AUTO-GENERATED minimal additions for existing setup
- **README-TOOLS.md** - Comprehensive tool reference guide
- **scripts/setup-new-mac.sh** - 🎯 **Main setup script** (orchestrates everything)
- **scripts/generate-brewfile-current.sh** - Smart script to generate Brewfile.current
- **scripts/update-all.sh** - Update all tools (brew, rust, cargo, node, python)

## How It Works

The **dotfiles master approach** uses a smart script to make installations resilient:

1. **Brewfile.superset** - The source of truth (assumes fresh Mac, nothing installed)
2. **generate-brewfile-current.sh** - Reads superset, checks what's installed (brew, system, cargo)
3. **Brewfile.current** - AUTO-GENERATED file with only missing packages

This approach:
- ✅ Checks brew database, system binaries, cargo packages, app bundles
- ✅ Idempotent - run anytime, always accurate
- ✅ Transparent - review before installing
- ✅ No conflicts - skips tools installed outside brew
- ✅ Works with cargo-first philosophy

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

### Update Everything (Automated)
```bash
# Update all tools at once
./scripts/update-all.sh
```

This updates:
- ✅ Homebrew packages
- ✅ Rust toolchain
- ✅ All cargo tools
- ✅ Node.js packages (npm/yarn/pnpm)
- ✅ Python packages (pip/pipx)
- ✅ App Store apps (if mas installed)

### Update Manually
```bash
# Update Homebrew packages
brew update && brew upgrade

# Update Rust toolchain
rustup update

# Update cargo tools (one by one)
cargo install <tool-name> --force

# Or install cargo-update for batch updates
cargo install cargo-update
cargo install-update -a
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
