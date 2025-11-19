# Quick Reference - Dotfiles Commands

## 🚀 Setup & Installation

```bash
# New Mac - Full Setup
./scripts/setup-new-mac.sh

# Existing Mac - Minimal Install
./scripts/generate-brewfile-current.sh
brew bundle --file=Brewfile.current
```

## 🛡️ Backup & Restore

```bash
# Safe stow (with automatic backup)
./scripts/safe-stow.sh                    # All packages
./scripts/safe-stow.sh bash zsh           # Specific packages
./scripts/safe-stow.sh --dry-run          # Preview

# Manual backup
./scripts/backup-dotfiles.sh              # Backup all
./scripts/backup-dotfiles.sh bash         # Backup bash only
./scripts/backup-dotfiles.sh --dry-run    # Preview

# Restore
./scripts/restore-dotfiles.sh --list      # List backups
./scripts/restore-dotfiles.sh <session>   # Restore specific
./scripts/restore-dotfiles.sh --dry-run <session>  # Preview
```

## 📦 Package Management

```bash
# Update everything
./scripts/update-all.sh

# Homebrew
brew update && brew upgrade
brew cleanup

# Rust
rustup update
cargo install <tool> --force

# Cargo tools batch update
cargo install cargo-update
cargo install-update -a
```

## 🔗 Stow Operations

```bash
# Stow (create symlinks)
cd ~/dotfiles
stow bash                    # Stow bash
stow -R bash                 # Restow (remove then stow)
stow -D bash                 # Unstow (remove symlinks)
stow -n bash                 # Dry run (preview)

# Stow all packages
stow bash zsh git vscode npm yarn

# Safe stow (recommended)
./scripts/safe-stow.sh bash
```

## 🐚 Shell Configuration

```bash
# Reload shell
exec bash -l                 # Bash
exec zsh                     # Zsh

# Edit configs
vim ~/dotfiles/bash/.bashrc
vim ~/dotfiles/zsh/.zshrc

# Test config without applying
bash -c 'source ~/dotfiles/bash/.bashrc'
zsh -c 'source ~/dotfiles/zsh/.zshrc'
```

## 🖥️ iTerm2

```bash
# Configure iTerm2
./scripts/configure-iterm2.sh

# Manual font setup
# iTerm2 → Preferences → Profiles → Text → Font
# Select: MesloLGS NF Regular 13
```

## 💻 VSCode

```bash
# Configure VSCode
./scripts/configure-vscode.sh

# Install extensions manually
code --install-extension <extension-id>

# List installed extensions
code --list-extensions
```

## 🔍 Useful Commands

```bash
# Check what's installed
brew list                    # Homebrew packages
cargo install --list         # Cargo tools
npm list -g --depth=0        # Global npm packages

# Find files
fd <pattern>                 # Fast find
rg <pattern>                 # Fast grep

# Navigation
z <dir>                      # Jump to directory (zoxide)
.. / ... / ....              # Go up directories

# Git shortcuts
gst                          # git status
gco <branch>                 # git checkout
gcm "message"                # git commit -m
gp                           # git push
```

## 📁 Directory Structure

```
~/dotfiles/
├── bash/                    # Bash config
│   ├── .bashrc
│   ├── .bash_profile
│   ├── .inputrc
│   └── .config/bash/
├── zsh/                     # Zsh config
├── git/                     # Git config
├── vscode/                  # VSCode config
├── scripts/                 # Setup scripts
│   ├── setup-new-mac.sh
│   ├── safe-stow.sh
│   ├── backup-dotfiles.sh
│   ├── restore-dotfiles.sh
│   └── update-all.sh
└── *.md                     # Documentation

~/.dotfiles-backup/          # Backup location
├── 20251119-162500/
│   ├── manifest.txt
│   └── <backed-up-files>
└── <other-sessions>/
```

## 🎯 Common Workflows

### Try New Config Safely
```bash
./scripts/backup-dotfiles.sh
./scripts/safe-stow.sh bash
exec bash -l
# If you don't like it:
./scripts/restore-dotfiles.sh <session>
```

### Update Everything
```bash
./scripts/update-all.sh
```

### Add New Tool
```bash
# Rust tool (preferred)
cargo install <tool>

# Homebrew tool
brew install <tool>

# Update Brewfile
echo 'brew "<tool>"' >> Brewfile
```

### Sync to New Machine
```bash
git clone git@github.com:githubrobbi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/setup-new-mac.sh
```

## 📚 Documentation

- **BACKUP-RESTORE.md** - Backup & restore guide
- **BASH-SETUP.md** - Bash configuration
- **ITERM2-SETUP.md** - iTerm2 setup
- **VSCODE-SETUP.md** - VSCode setup
- **ZSHRC-REFACTOR.md** - Zsh configuration
- **GIT-REFACTOR.md** - Git configuration
- **README-TOOLS.md** - Tool reference

## 🆘 Troubleshooting

### Stow Conflicts
```bash
# Preview conflicts
stow -n -v bash

# Force adopt
./scripts/safe-stow.sh --force bash

# Manual resolution
rm ~/.bashrc
./scripts/safe-stow.sh bash
```

### History Not Working
```bash
# Check history file
echo $HISTFILE

# Create directory
mkdir -p ~/.local/state/bash
```

### Modern Tools Not Found
```bash
# Check if installed
command -v fzf bat eza fd rg zoxide

# Install missing
brew install fzf bat eza fd ripgrep zoxide
```

### Restore Backup
```bash
# List all backups
./scripts/restore-dotfiles.sh --list

# Restore specific
./scripts/restore-dotfiles.sh 20251119-162500
```

## 💡 Pro Tips

1. **Always use safe-stow** - Automatic backups save lives
2. **Use dry-run first** - Preview before applying
3. **Keep backups** - Disk space is cheap
4. **Test in new shell** - Don't close current shell
5. **Commit changes** - Git is your friend
6. **Read the docs** - Comprehensive guides available
7. **Experiment freely** - Easy to restore!

---

**Quick help:** `<script> --help` for any script

