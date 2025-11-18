# ============================================================================
# .zshrc - World-Class Zsh Configuration
# ============================================================================
# Modular, performant, cutting-edge zsh setup
# ============================================================================

# ============================================================================
# Performance Profiling (uncomment to debug slow startup)
# ============================================================================
# zmodload zsh/zprof

# ============================================================================
# 1. Powerlevel10k Instant Prompt (MUST be at the top)
# ============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Suppress instant prompt warnings
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ============================================================================
# 2. Environment Variables (Early Bootstrap)
# ============================================================================

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Editor preferences
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

# Less configuration
export LESS='-R -F -X -i -M -w -z-4'
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"

# ============================================================================
# 3. PATH Management (Deduplicated, Ordered)
# ============================================================================

# PATH helpers - deduplicate automatically
typeset -gU path fpath cdpath manpath

# Helper functions
path_prepend() { [[ -d "$1" ]] && path=("$1" $path) }
path_append()  { [[ -d "$1" ]] && path+=("$1") }

# Homebrew (Apple Silicon)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Python 3.14 (unversioned python/pip)
path_prepend "/opt/homebrew/opt/python@3.14/libexec/bin"

# Rust/Cargo
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Local bins
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
path_append "$HOME/bin/rust/release"
path_append "$HOME/.appfabric-bin"
path_prepend "$HOME/.codeium/windsurf/bin"

# LLVM (if installed via brew)
if command -v brew &>/dev/null; then
  __llvm_prefix="$(brew --prefix llvm 2>/dev/null)"
  if [[ -n "$__llvm_prefix" && -d "$__llvm_prefix" ]]; then
    path_prepend "$__llvm_prefix/bin"
    export LDFLAGS="-L$__llvm_prefix/lib${LDFLAGS:+:$LDFLAGS}"
    export CPPFLAGS="-I$__llvm_prefix/include${CPPFLAGS:+:$CPPFLAGS}"
  fi
  unset __llvm_prefix
fi

# ============================================================================
# 4. Zsh Options (Best Practices)
# ============================================================================

# History
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY          # Write timestamp to history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_FIND_NO_DUPS         # Don't display duplicates in search
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicate entries
setopt HIST_IGNORE_DUPS          # Don't record duplicate consecutive entries
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries
setopt HIST_VERIFY               # Don't execute immediately upon history expansion
setopt INC_APPEND_HISTORY        # Write to history file immediately
setopt SHARE_HISTORY             # Share history between sessions

# Directory navigation
setopt AUTO_CD                   # cd by typing directory name
setopt AUTO_PUSHD                # Push directories onto stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_MINUS               # Swap meaning of +/-
setopt PUSHD_SILENT              # Don't print directory stack

# Completion
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt AUTO_LIST                 # List choices on ambiguous completion
setopt AUTO_MENU                 # Show completion menu on tab
setopt COMPLETE_IN_WORD          # Complete from both ends of word
setopt LIST_PACKED               # Compact completion lists

# Misc
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shell
setopt NO_BEEP                   # No beep
setopt NO_FLOW_CONTROL           # Disable ^S/^Q flow control
setopt PROMPT_SUBST              # Enable parameter expansion in prompts

# ============================================================================
# 5. Oh My Zsh Configuration
# ============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # We use Powerlevel10k

# Update settings
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 30

# Plugins (carefully selected for performance)
plugins=(
  # Core
  git
  sudo
  command-not-found

  # Modern tools
  fzf
  zoxide

  # Completion
  docker
  docker-compose
  kubectl

  # Java/Kotlin
  mvn
  gradle

  # Custom
  zsh-autosuggestions
)

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# ============================================================================
# 6. Modern CLI Tool Integrations
# ============================================================================

# fzf - Fuzzy finder
if command -v fzf &>/dev/null; then
  # Use fd instead of find
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
  
  # Use bat for preview
  if command -v bat &>/dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
  fi
  
  # Catppuccin Mocha theme
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

# zoxide - Smarter cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# direnv - Per-directory environment
if command -v direnv &>/dev/null; then
  export DIRENV_LOG_FORMAT=""  # Quiet
  eval "$(direnv hook zsh)"
fi

# bat - Better cat
if command -v bat &>/dev/null; then
  export BAT_THEME="Catppuccin-mocha"
  export BAT_STYLE="numbers,changes,header"
  alias cat='bat --paging=never'
  alias less='bat --paging=always'
fi

# eza - Better ls
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first --git'
  alias la='eza -la --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
  alias tree='eza --tree --icons'
fi

# ripgrep - Better grep
if command -v rg &>/dev/null; then
  export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
fi

# ============================================================================
# 7. Language & Tool Environments
# ============================================================================

# SDKMAN (Java, Maven, Gradle, etc.)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"

# Rust
if command -v sccache &>/dev/null; then
  export RUSTC_WRAPPER="$(command -v sccache)"
fi
export RUST_LOG="${RUST_LOG:-error,tt=off}"

# Node.js
export NODE_EXTRA_CA_CERTS=~/Documents/caadmin.netskope.com.pem

# Docker/Podman
export DOCKER_HOST="$HOME/.local/share/containers/podman/machine/applehv/podman.sock"
export TESTCONTAINERS_ENABLED=false

# Maven/Nexus
export NEXUS_PROXY_URL=https://artifact.intuit.com/artifactory/maven-proxy
export JMETER_HOME=/opt/homebrew/Cellar/jmeter/5.6.3/libexec

# App-specific
export APP_NAME=ETS_COMPONENT_TEST
export DB_REGION=LOCAL

# ============================================================================
# 8. Load Modular Configs (if they exist)
# ============================================================================

# SSH agent configuration
[[ -f "$HOME/.config/zsh/ssh-agent.zsh" ]] && source "$HOME/.config/zsh/ssh-agent.zsh"

# Work-specific aliases and functions
[[ -f "$HOME/.config/zsh/work.zsh" ]] && source "$HOME/.config/zsh/work.zsh"

# Personal aliases and functions
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"

# Machine-specific overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ============================================================================
# 9. Key Bindings (Modern & Ergonomic)
# ============================================================================

# Emacs-style bindings (most common)
bindkey -e

# Better word navigation
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^[[1;5D' backward-word     # Ctrl+Left
bindkey '^[[C' forward-word         # Alt+Right
bindkey '^[[D' backward-word        # Alt+Left

# History search
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^P' history-search-backward    # Ctrl+P
bindkey '^N' history-search-forward     # Ctrl+N

# Delete
bindkey '^[[3~' delete-char         # Delete key
bindkey '^H' backward-delete-char   # Backspace

# ============================================================================
# 10. Powerlevel10k Theme
# ============================================================================

# Load p10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Load Powerlevel10k theme
if [[ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# iTerm2 shell integration
[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# ============================================================================
# Performance Profiling (uncomment to see results)
# ============================================================================
# zprof

