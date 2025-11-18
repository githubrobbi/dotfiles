# Development Tools Reference

This document lists all the tools installed via the Brewfile and their usage.

## 🦀 Rust-Powered Modern CLI Tools

These are blazing-fast replacements for traditional Unix tools, written in Rust:

### File & Directory Navigation
- **`bat`** - Better `cat` with syntax highlighting
  ```bash
  bat file.rs              # View with syntax highlighting
  bat -A file.txt          # Show all characters (like cat -A)
  ```

- **`exa`** / **`eza`** - Better `ls` (colorful, git-aware)
  ```bash
  exa -la                  # List all with details
  exa --tree               # Tree view
  exa --git                # Show git status
  ```

- **`fd`** - Better `find` (faster, simpler syntax)
  ```bash
  fd pattern               # Find files matching pattern
  fd -e rs                 # Find all .rs files
  fd -H pattern            # Include hidden files
  ```

- **`ripgrep (rg)`** - Better `grep` (incredibly fast)
  ```bash
  rg "pattern"             # Search in current directory
  rg -i "pattern"          # Case-insensitive search
  rg -t rust "pattern"     # Search only in Rust files
  ```

- **`zoxide (z)`** - Better `cd` (learns your habits)
  ```bash
  z dotfiles               # Jump to ~/dotfiles
  zi                       # Interactive selection
  ```

### Text Processing
- **`sd`** - Better `sed` (simpler syntax)
  ```bash
  sd 'old' 'new' file.txt  # Replace text
  sd -p 'regex' 'new' *.rs # Replace with regex in multiple files
  ```

### System Monitoring
- **`procs`** - Better `ps` (colorful, tree view)
  ```bash
  procs                    # List all processes
  procs rust               # Filter by name
  procs --tree             # Tree view
  ```

- **`bottom (btm)`** - Better `top` (beautiful TUI)
  ```bash
  btm                      # Launch interactive monitor
  btm --basic              # Basic mode
  ```

- **`dust`** - Better `du` (disk usage analyzer)
  ```bash
  dust                     # Show disk usage
  dust -d 3                # Limit depth to 3
  ```

### Development Tools
- **`tokei`** - Code statistics
  ```bash
  tokei                    # Count lines of code
  tokei --sort lines       # Sort by lines
  ```

- **`hyperfine`** - Benchmarking tool
  ```bash
  hyperfine 'command1' 'command2'  # Compare performance
  hyperfine --warmup 3 'cargo build'
  ```

- **`git-delta`** - Better git diff viewer
  ```bash
  # Automatically used by git (configured in .gitconfig)
  git diff                 # Beautiful diffs
  git log -p               # Beautiful commit logs
  ```

## 🔧 Essential Development Tools

### Version Control
- **`git`** - Version control
- **`gh`** - GitHub CLI
  ```bash
  gh repo clone owner/repo
  gh pr create
  gh issue list
  ```

### Shell & Prompt
- **`zsh`** - Modern shell
- **`powerlevel10k`** - Beautiful, fast prompt
- **`starship`** - Alternative cross-shell prompt

### Fuzzy Finding
- **`fzf`** - Fuzzy finder (integrates with shell)
  ```bash
  # Ctrl+R - Search command history
  # Ctrl+T - Search files
  # Alt+C  - Change directory
  vim $(fzf)               # Open file in vim
  ```

### Data Processing
- **`jq`** - JSON processor
  ```bash
  cat data.json | jq '.field'
  curl api.com | jq -r '.items[]'
  ```

- **`yq`** - YAML processor
  ```bash
  cat config.yaml | yq '.database.host'
  ```

### Terminal Multiplexer
- **`tmux`** - Terminal multiplexer
  ```bash
  tmux                     # Start new session
  tmux attach              # Attach to session
  # Ctrl+B then % - Split vertically
  # Ctrl+B then " - Split horizontally
  ```

### Editor
- **`neovim`** - Modern vim
  ```bash
  nvim file.txt
  ```

## 🔐 Security & Secrets

- **`gnupg`** - GPG encryption
- **`gopass`** - Password manager
  ```bash
  gopass show service/password
  gopass insert service/password
  ```

- **`age`** - Modern encryption
  ```bash
  age -e -r recipient file.txt > file.txt.age
  age -d file.txt.age > file.txt
  ```

- **`sops`** - Secrets management
  ```bash
  sops -e secrets.yaml > secrets.enc.yaml
  sops -d secrets.enc.yaml
  ```

## 🌐 Languages & Runtimes

- **`node`** - Node.js runtime
- **`python@3.12`** - Python 3.12
- **`go`** - Go language
- **`rustup`** - Rust toolchain manager
  ```bash
  rustup update            # Update Rust
  rustup default stable    # Set default toolchain
  rustup component add clippy rustfmt
  ```

## 🎨 GUI Applications

- **iTerm2** - Best terminal for macOS
- **Visual Studio Code** - Code editor
- **Docker Desktop** - Container platform
- **Rectangle** - Window management (free)
  - `Ctrl+Opt+Left` - Left half
  - `Ctrl+Opt+Right` - Right half
  - `Ctrl+Opt+F` - Fullscreen

## 🔤 Fonts

Nerd Fonts with icons for terminal:
- **Fira Code Nerd Font** - Ligatures + icons
- **JetBrains Mono Nerd Font** - Clean, modern
- **Meslo LG Nerd Font** - Recommended for p10k
- **Hack Nerd Font** - Classic monospace

### Setting Font in iTerm2
1. iTerm2 → Preferences → Profiles → Text
2. Font: Select "MesloLGS NF" (or any Nerd Font)
3. Size: 13-14pt recommended

## 🚀 Productivity Tools

- **`autojump`** - Quick directory navigation
  ```bash
  j dotfiles               # Jump to directory
  ```

- **`tldr`** - Simplified man pages
  ```bash
  tldr tar                 # Quick examples
  tldr git-commit
  ```

- **`direnv`** - Per-directory environment variables
  ```bash
  # Create .envrc in project directory
  echo 'export DATABASE_URL=...' > .envrc
  direnv allow .
  ```

## 📦 Cargo Tools (Rust)

Install additional Rust tools with cargo:

```bash
# Development helpers
cargo install cargo-watch      # Auto-rebuild on file changes
cargo install cargo-edit        # Add/remove dependencies from CLI
cargo install cargo-outdated    # Check for outdated dependencies
cargo install cargo-audit       # Security audit

# Usage examples
cargo watch -x test             # Run tests on file change
cargo add serde                 # Add dependency
cargo rm tokio                  # Remove dependency
cargo outdated                  # Check outdated deps
cargo audit                     # Security audit
```

## 🎯 Quick Start Aliases

Add these to your `.zshrc` for convenience:

```bash
# Modern replacements
alias cat='bat'
alias ls='exa -la'
alias find='fd'
alias grep='rg'
alias ps='procs'
alias top='btm'
alias du='dust'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
```

## 📚 Learning Resources

- Rust Book: https://doc.rust-lang.org/book/
- Rust by Example: https://doc.rust-lang.org/rust-by-example/
- iTerm2 Docs: https://iterm2.com/documentation.html
- tmux Cheat Sheet: https://tmuxcheatsheet.com/
- fzf Examples: https://github.com/junegunn/fzf#usage

## 🔄 Keeping Tools Updated

```bash
# Update Homebrew packages
brew update && brew upgrade

# Update Rust
rustup update

# Update npm global packages
npm update -g

# Update cargo tools
cargo install-update -a  # Requires: cargo install cargo-update
```

