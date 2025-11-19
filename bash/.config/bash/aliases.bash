# ============================================================================
# Bash Aliases - Modern & Ergonomic
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

# bat - Better cat
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias less='bat --paging=always'
  alias man='batman'  # bat-extras: colored man pages
fi

# eza - Better ls
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first --git'
  alias la='eza -la --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
  alias tree='eza --tree --icons'
else
  # Fallback to standard ls with colors
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lAh'
fi

# fd - Better find
if command -v fd &>/dev/null; then
  alias find='fd'
fi

# ripgrep - Better grep
if command -v rg &>/dev/null; then
  alias grep='rg'
fi

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

# Reload bash
alias reload='exec bash -l'
alias src='source ~/.bashrc'

# Edit configs
alias bashrc='${EDITOR:-nvim} ~/.bashrc'
alias bashprofile='${EDITOR:-nvim} ~/.bash_profile'
alias vimrc='${EDITOR:-nvim} ~/.config/nvim/init.vim'

# Network
alias myip='curl -s https://api.ipify.org && echo'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'

# System
alias cleanup='brew cleanup && brew autoremove'
alias update='brew update && brew upgrade && brew cleanup'

# Clipboard (macOS)
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
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
alias cc='cargo check'
alias cw='cargo watch'
alias cu='cargo update'

# Maven
alias mci='mvn clean install'
alias mcp='mvn clean package'
alias mct='mvn clean test'
alias mvnci='mvn clean install -DskipTests'

# Gradle
alias gw='./gradlew'
alias gwb='./gradlew build'
alias gwt='./gradlew test'
alias gwc='./gradlew clean'

# npm/yarn/pnpm
alias ni='npm install'
alias nr='npm run'
alias nt='npm test'
alias yi='yarn install'
alias yr='yarn run'
alias yt='yarn test'
alias pi='pnpm install'
alias pr='pnpm run'
alias pt='pnpm test'

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

# Spotlight
alias spotoff='sudo mdutil -a -i off'
alias spoton='sudo mdutil -a -i on'

# ============================================================================
# Safety
# ============================================================================

# Confirm before overwriting
alias cp='cp -i'
alias mv='mv -i'

# Verbose operations
alias chmod='chmod -v'
alias chown='chown -v'

# ============================================================================
# End of aliases.bash
# ============================================================================

