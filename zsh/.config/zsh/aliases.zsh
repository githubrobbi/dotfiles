# ============================================================================
# Aliases - Modern & Ergonomic
# ============================================================================

# ============================================================================
# Navigation
# ============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Quick directory access
alias ~='cd ~'
alias -- -='cd -'

# ============================================================================
# Git Aliases (Enhanced)
# ============================================================================
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gst='git status'
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstp='git stash pop'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

# ============================================================================
# Modern CLI Tools
# ============================================================================

# Safer rm (use trash if available)
if command -v trash &>/dev/null; then
  alias rm='trash'
fi

# Disk usage
if command -v dust &>/dev/null; then
  alias du='dust'
fi

# Process viewer
if command -v procs &>/dev/null; then
  alias ps='procs'
fi

# System monitor
if command -v btm &>/dev/null; then
  alias top='btm'
  alias htop='btm'
fi

# ============================================================================
# Utilities
# ============================================================================

# Reload zsh
alias reload='exec zsh'
alias src='source ~/.zshrc'

# Edit configs
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias zshenv='${EDITOR:-nvim} ~/.zshenv'
alias vimrc='${EDITOR:-nvim} ~/.config/nvim/init.vim'

# Network
alias myip='curl -s https://api.ipify.org && echo'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'

# System
alias cleanup='brew cleanup && brew autoremove'
alias update='brew update && brew upgrade && brew cleanup'

# Clipboard
alias pbcopy='pbcopy'
alias pbpaste='pbpaste'
alias copy='pbcopy'
alias paste='pbpaste'

# Quick file operations
alias mkdir='mkdir -p'
alias md='mkdir -p'
alias rd='rmdir'

# ============================================================================
# Development
# ============================================================================

# Docker/Podman
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kl='kubectl logs'
alias kd='kubectl describe'

# Cargo (Rust)
alias c='cargo'
alias cb='cargo build'
alias cbr='cargo build --release'
alias cr='cargo run'
alias crr='cargo run --release'
alias ct='cargo test'
alias cc='cargo check'
alias cw='cargo watch'
alias cu='cargo update'

# Maven
alias m='mvn'
alias mci='mvn clean install'
alias mcp='mvn clean package'
alias mct='mvn clean test'
alias spotless='mvn spotless:apply'

# ============================================================================
# Productivity
# ============================================================================

# Quick notes
alias note='${EDITOR:-nvim} ~/notes/$(date +%Y-%m-%d).md'

# Weather
alias weather='curl wttr.in'

# Cheat sheets
alias cheat='curl cheat.sh'

# ============================================================================
# Fun
# ============================================================================

# Random
alias please='sudo'
alias fucking='sudo'
alias wtf='dmesg'
alias oneko='oneko -tofocus -speed 20'

# ============================================================================
# macOS Specific
# ============================================================================

# Show/hide hidden files in Finder
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

# Flush DNS cache
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Empty trash
alias emptytrash='sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash'

# Lock screen
alias afk='pmset displaysleepnow'

