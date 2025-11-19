# ============================================================================
# .bashrc - World-Class Bash Configuration
# ============================================================================
# Author: World-Class Bash Master
# Philosophy: Modern, Fast, Modular, Ergonomic
# Inspired by: zsh/.zshrc patterns
# ============================================================================

# ============================================================================
# 1. Early Exit for Non-Interactive Shells
# ============================================================================
[[ $- != *i* ]] && return

# ============================================================================
# 2. Shell Options (Bash 4+)
# ============================================================================

# History
shopt -s histappend              # Append to history, don't overwrite
shopt -s cmdhist                 # Save multi-line commands as one
HISTSIZE=50000                   # Memory history size
HISTFILESIZE=100000              # File history size
HISTCONTROL=ignoreboth:erasedups # Ignore duplicates and spaces
HISTTIMEFORMAT='%F %T '          # Timestamp format
HISTIGNORE='ls:ll:la:cd:pwd:exit:clear:history'

# Directory navigation
shopt -s autocd 2>/dev/null      # cd by typing directory name (Bash 4+)
shopt -s cdspell                 # Autocorrect typos in cd
shopt -s dirspell 2>/dev/null    # Autocorrect typos in directory completion (Bash 4+)
shopt -s cdable_vars             # cd to variable values

# Globbing
shopt -s globstar 2>/dev/null    # ** recursive glob (Bash 4+)
shopt -s nocaseglob              # Case-insensitive globbing
shopt -s extglob                 # Extended pattern matching
shopt -s dotglob                 # Include hidden files in globs

# Completion
shopt -s no_empty_cmd_completion # Don't complete on empty line
shopt -s checkwinsize            # Update LINES and COLUMNS after each command

# Job control
set -o notify                    # Report status of background jobs immediately

# ============================================================================
# 3. Environment Variables
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

# Bash history location (XDG compliant)
export HISTFILE="${XDG_STATE_HOME}/bash/history"
mkdir -p "$(dirname "$HISTFILE")"

# Ripgrep configuration
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# ============================================================================
# 4. PATH Management (Deduplicated, Ordered)
# ============================================================================

# PATH helper functions
path_prepend() {
  [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

path_append() {
  [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"
}

# Homebrew (Apple Silicon first, then Intel)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# User binaries
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# Rust/Cargo
path_prepend "$HOME/.cargo/bin"

# Go
if [[ -d "$HOME/go/bin" ]]; then
  export GOPATH="$HOME/go"
  path_prepend "$GOPATH/bin"
fi

# Python (pipx)
path_append "$HOME/.local/bin"

# Node.js (global npm packages)
path_prepend "$HOME/.npm-global/bin"

# Work-specific paths
path_append "$HOME/.appfabric-bin"

# ============================================================================
# 5. Prompt Configuration
# ============================================================================

# Enable color support
if [[ -x /usr/bin/tput ]] && tput setaf 1 &>/dev/null; then
  export CLICOLOR=1
  export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
  export LS_COLORS='di=1;34:ln=1;36:so=1;31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43'
fi

# Git prompt support
if [[ -f /opt/homebrew/etc/bash_completion.d/git-prompt.sh ]]; then
  source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto"
  export GIT_PS1_SHOWCOLORHINTS=1
fi

# Starship prompt (if installed)
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
else
  # Fallback: Simple but informative prompt
  # Format: [user@host dir (git-branch)] $
  if type -t __git_ps1 &>/dev/null; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
  else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  fi
fi

# ============================================================================
# 6. Bash Completion
# ============================================================================

# Enable programmable completion
if ! shopt -oq posix; then
  # Homebrew bash-completion@2 (Bash 4+)
  if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    source /opt/homebrew/etc/profile.d/bash_completion.sh
  # Fallback to bash-completion@1
  elif [[ -f /opt/homebrew/etc/bash_completion ]]; then
    source /opt/homebrew/etc/bash_completion
  # System bash completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

# ============================================================================
# 7. Modern CLI Tool Integrations
# ============================================================================

# fzf - Fuzzy finder
if [[ -f ~/.fzf.bash ]]; then
  source ~/.fzf.bash
elif [[ -f /opt/homebrew/opt/fzf/shell/completion.bash ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.bash
  source /opt/homebrew/opt/fzf/shell/completion.bash
fi

# zoxide - Smarter cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# direnv - Per-directory environment
if command -v direnv &>/dev/null; then
  export DIRENV_LOG_FORMAT=""  # Quiet
  eval "$(direnv hook bash)"
fi

# bat - Better cat
if command -v bat &>/dev/null; then
  export BAT_THEME="Catppuccin-mocha"
  export BAT_STYLE="numbers,changes,header"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# eza - Better ls (aliases loaded from modular config)
# fd - Better find (already configured via FZF_DEFAULT_COMMAND)
# ripgrep - Better grep (configured via RIPGREP_CONFIG_PATH)

# ============================================================================
# 8. Language & Tool Environments
# ============================================================================

# Rust
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# NVM (Node Version Manager) - Lazy load for performance
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# SDKMAN (Java/Kotlin/Gradle/Maven)
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# Java (prefer JDK 11 if available)
if command -v /usr/libexec/java_home &>/dev/null; then
  export JAVA_HOME="$(/usr/libexec/java_home -v 11 2>/dev/null || /usr/libexec/java_home 2>/dev/null)"
  path_prepend "$JAVA_HOME/bin"
fi

# Python
export PYTHONDONTWRITEBYTECODE=1  # Don't create .pyc files
export PYTHONUNBUFFERED=1         # Unbuffered output

# ============================================================================
# 9. Work-Specific Configuration
# ============================================================================

# Intuit/Work environment
export NEXUS_PROXY_URL=https://artifact.intuit.com/artifactory/maven-proxy
export JMETER_HOME=/opt/homebrew/Cellar/jmeter/5.6.3/libexec

# App-specific
export APP_NAME=ETS_COMPONENT_TEST
export DB_REGION=LOCAL

# ============================================================================
# 10. Load Modular Configs (if they exist)
# ============================================================================

# Bash-specific aliases and functions
[[ -f "$XDG_CONFIG_HOME/bash/aliases.bash" ]] && source "$XDG_CONFIG_HOME/bash/aliases.bash"
[[ -f "$XDG_CONFIG_HOME/bash/functions.bash" ]] && source "$XDG_CONFIG_HOME/bash/functions.bash"
[[ -f "$XDG_CONFIG_HOME/bash/work.bash" ]] && source "$XDG_CONFIG_HOME/bash/work.bash"

# Machine-specific overrides
[[ -f "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"

# ============================================================================
# 11. iTerm2 Shell Integration
# ============================================================================
[[ -e "$HOME/.iterm2_shell_integration.bash" ]] && source "$HOME/.iterm2_shell_integration.bash"

# ============================================================================
# End of .bashrc
# ============================================================================

