# ============================================================================
# Brewfile - Complete Setup for Brand New Mac
# ============================================================================
# Assumes NOTHING is installed - this is a fresh Mac.
# Brewfiles only check brew's database, not system binaries.
# ============================================================================

# ============================================================================
# Core Development Tools
# ============================================================================

# Version Control
brew "git"
brew "gh"              # GitHub CLI
brew "git-delta"       # Better git diff viewer

# Shell & Terminal
brew "zsh"
brew "powerlevel10k"
brew "starship"        # Alternative prompt (optional)

# Package Management
brew "stow"            # Dotfile symlink manager

# ============================================================================
# Rust Development Ecosystem
# ============================================================================

# Rust toolchain - RECOMMENDED: Install via rustup.rs instead of brew
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# brew "rustup-init"   # Alternative: install via brew (not recommended)

# Rust-powered CLI tools (modern replacements)
brew "bat"             # Better cat with syntax highlighting
brew "eza"             # Better ls (exa fork, maintained)
brew "fd"              # Better find
brew "ripgrep"         # Better grep (rg)
brew "sd"              # Better sed
brew "procs"           # Better ps
brew "bottom"          # Better top (btm)
brew "dust"            # Better du
brew "tokei"           # Code statistics
brew "hyperfine"       # Benchmarking tool
brew "zoxide"          # Better cd (z)

# Build tools
brew "cmake"
brew "pkg-config"

# ============================================================================
# Modern CLI Essentials
# ============================================================================

brew "fzf"             # Fuzzy finder
brew "jq"              # JSON processor
brew "yq"              # YAML processor
brew "tree"            # Directory tree viewer
brew "wget"
brew "curl"
brew "htop"            # Process viewer
brew "tmux"            # Terminal multiplexer
brew "neovim"          # Modern vim

# ============================================================================
# Languages & Runtimes
# ============================================================================

brew "node"            # Node.js
brew "python@3.14"     # Python 3.14 (latest)
brew "go"              # Go language

# ============================================================================
# Security & Secrets
# ============================================================================

brew "gnupg"
brew "gopass"          # Password manager
brew "age"             # Modern encryption tool
brew "sops"            # Secrets management

# ============================================================================
# Productivity Tools
# ============================================================================

brew "autojump"        # Quick directory navigation
brew "tldr"            # Simplified man pages
brew "direnv"          # Per-directory environment variables

# ============================================================================
# GUI Applications (Casks)
# ============================================================================

cask "iterm2"          # Best terminal for macOS
cask "visual-studio-code"
cask "docker"          # Docker Desktop (NOTE: may conflict if installed outside brew)
cask "rectangle"       # Window management (free)
# cask "alfred"        # Spotlight replacement (optional)
# cask "obsidian"      # Note-taking (optional)

# ============================================================================
# Fonts (for iTerm2 & terminal)
# ============================================================================
# Note: homebrew/cask-fonts tap is deprecated, fonts are now in homebrew/cask

cask "font-fira-code-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-meslo-lg-nerd-font"
cask "font-hack-nerd-font"
