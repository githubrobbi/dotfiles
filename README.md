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
4. ✅ **Backs up existing dotfiles** (automatic safety!)
5. ✅ Symlinks dotfiles via stow
6. ✅ Configures Git with SSH signing
7. ✅ Installs Rust toolchain (via rustup)
8. ✅ Installs all cargo tools (cargo-first!)
9. ✅ Sets up Node.js + global packages
10. ✅ Sets up Python + pip/pipx
11. ✅ Configures macOS defaults
12. ✅ Configures iTerm2
13. ✅ Configures VSCode with extensions

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
- **BACKUP-RESTORE.md** - 🛡️ **Backup & restore guide** (world-class safety)
- **BASH-SETUP.md** - Bash configuration guide (world-class setup)
- **ITERM2-SETUP.md** - iTerm2 configuration guide (fonts, theme, settings)
- **VSCODE-SETUP.md** - VSCode configuration guide (settings, extensions, keybindings)
- **ZSHRC-REFACTOR.md** - Zsh configuration documentation
- **GIT-REFACTOR.md** - Git configuration documentation
- **scripts/setup-new-mac.sh** - 🎯 **Main setup script** (orchestrates everything)
- **scripts/safe-stow.sh** - 🛡️ **Safe stow** (backup before stowing)
- **scripts/backup-dotfiles.sh** - Backup existing dotfiles
- **scripts/restore-dotfiles.sh** - Restore from backup
- **scripts/generate-brewfile-current.sh** - Smart script to generate Brewfile.current
- **scripts/update-all.sh** - Update all tools (brew, rust, cargo, node, python)
- **scripts/configure-iterm2.sh** - Configure iTerm2 with Nerd Fonts for Powerlevel10k
- **scripts/configure-vscode.sh** - Configure VSCode with extensions and settings

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

- `bash/`: Bash 5+ configuration (world-class setup)
  - `.bashrc` - Main configuration (300+ lines)
  - `.bash_profile` - Login shell setup
  - `.inputrc` - Readline enhancements
  - `.config/bash/` - Modular configs (aliases, functions, work)
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

## iTerm2 Configuration

### Quick Fix (If Icons Don't Show)
```bash
# Run the configuration script
./scripts/configure-iterm2.sh

# Or manually:
# 1. iTerm2 → Preferences (⌘,)
# 2. Profiles → Text → Font
# 3. Select: MesloLGS NF Regular 13
# 4. Restart iTerm2
```

See **ITERM2-SETUP.md** for detailed configuration guide.

## VSCode Configuration

### Quick Setup
```bash
# Run the configuration script
./scripts/configure-vscode.sh

# Or manually:
# 1. Stow VSCode config: cd ~/dotfiles && stow vscode
# 2. Install extensions: code --install-extension <extension-id>
# 3. Restart VSCode
```

**What you get:**
- ✅ **485 lines** of world-class settings
- ✅ **30+ extensions** (Rust, JS/TS, Python, Git, Docker, etc.)
- ✅ **Catppuccin Mocha** theme (matches iTerm2!)
- ✅ **MesloLGS NF** font (Nerd Font with ligatures)
- ✅ **Format on save** for all languages
- ✅ **Git integration** with SSH signing
- ✅ **Custom keybindings** optimized for productivity
- ✅ **Rust snippets** and language-specific configs

See **VSCODE-SETUP.md** for detailed configuration guide.

## Bash Configuration

### Quick Setup
```bash
# Stow bash configuration
cd ~/dotfiles && stow bash

# Reload bash
exec bash -l
```

**What you get:**
- ✅ **300+ lines** of world-class .bashrc
- ✅ **Modular configuration** (aliases, functions, work-specific)
- ✅ **Modern CLI tools** integration (fzf, eza, bat, zoxide, ripgrep)
- ✅ **XDG Base Directory** compliance
- ✅ **Smart history** (50K lines, deduplication, timestamps)
- ✅ **Readline enhancements** (.inputrc with 100+ improvements)
- ✅ **Intelligent history search** (↑/↓ arrows search based on input)
- ✅ **Bash 4+ features** (autocd, globstar, cdspell)
- ✅ **Performance optimized** (lazy loading, guarded sourcing)

See **BASH-SETUP.md** for detailed configuration guide.

## 🛡️ Backup & Restore (World-Class Safety)

### Quick Start

```bash
# Safe stow with automatic backup
cd ~/dotfiles
./scripts/safe-stow.sh

# List all backups
./scripts/restore-dotfiles.sh --list

# Restore from backup
./scripts/restore-dotfiles.sh 20251119-162500
```

**What you get:**
- ✅ **Automatic backups** before any stow operation
- ✅ **Timestamped snapshots** (never lose data)
- ✅ **Easy rollback** with one command
- ✅ **Dry-run mode** to preview changes
- ✅ **Manifest tracking** of what was backed up
- ✅ **Smart detection** (skips already-symlinked files)

### Common Workflows

**Try new dotfiles safely:**
```bash
# 1. Backup current config
./scripts/backup-dotfiles.sh

# 2. Apply new dotfiles
./scripts/safe-stow.sh bash

# 3. Test it
exec bash -l

# 4. Restore if you don't like it
./scripts/restore-dotfiles.sh <session-name>
```

**Preview before applying:**
```bash
# See what would be backed up
./scripts/backup-dotfiles.sh --dry-run

# See what would be stowed
./scripts/safe-stow.sh --dry-run
```

**Backup structure:**
```
~/.dotfiles-backup/
├── 20251119-162500/    # Timestamped session
│   ├── manifest.txt    # What was backed up
│   ├── bash/
│   ├── zsh/
│   └── git/
└── 20251119-143000/    # Another session
```

See **BACKUP-RESTORE.md** for comprehensive guide.

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
