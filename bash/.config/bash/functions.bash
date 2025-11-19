# ============================================================================
# Bash Functions - Productivity & Utilities
# ============================================================================

# ============================================================================
# Navigation & File Management
# ============================================================================

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Go up N directories
up() {
  local d=""
  local limit="${1:-1}"
  for ((i=1; i<=limit; i++)); do
    d="../$d"
  done
  cd "$d" || return
}

# Extract any archive
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find file by name
ff() {
  if command -v fd &>/dev/null; then
    fd "$@"
  else
    find . -type f -iname "*$1*"
  fi
}

# Find directory by name
fd_dir() {
  if command -v fd &>/dev/null; then
    fd --type d "$@"
  else
    find . -type d -iname "*$1*"
  fi
}

# ============================================================================
# Git Functions
# ============================================================================

# Git clone and cd into directory
gcl() {
  git clone "$1" && cd "$(basename "$1" .git)" || return
}

# Git commit with message
gcmsg() {
  git commit -m "$*"
}

# Git add all and commit
gac() {
  git add --all && git commit -m "$*"
}

# Git add all, commit, and push
gacp() {
  git add --all && git commit -m "$*" && git push
}

# Git branch cleanup (delete merged branches)
gbclean() {
  git branch --merged | grep -v "\*" | grep -v "main\|master\|develop" | xargs -n 1 git branch -d
}

# Git undo last commit (keep changes)
gundo() {
  git reset --soft HEAD~1
}

# Git show file history
ghistory() {
  git log --follow -p -- "$1"
}

# ============================================================================
# Development Functions
# ============================================================================

# Start a simple HTTP server
serve() {
  local port="${1:-8000}"
  if command -v python3 &>/dev/null; then
    python3 -m http.server "$port"
  elif command -v python &>/dev/null; then
    python -m SimpleHTTPServer "$port"
  else
    echo "Python not found"
  fi
}

# Find process by name
psgrep() {
  if command -v procs &>/dev/null; then
    procs "$@"
  else
    ps aux | grep -v grep | grep -i -e VSZ -e "$@"
  fi
}

# Kill process by name
killp() {
  local pid
  pid=$(ps aux | grep -v grep | grep "$@" | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "Killing process $pid"
    kill -9 "$pid"
  else
    echo "No process found matching: $@"
  fi
}

# ============================================================================
# Docker Functions
# ============================================================================

# Docker cleanup
dclean() {
  echo "Removing stopped containers..."
  docker container prune -f
  echo "Removing dangling images..."
  docker image prune -f
  echo "Removing unused volumes..."
  docker volume prune -f
  echo "Removing unused networks..."
  docker network prune -f
}

# Docker stop all containers
dstop() {
  docker stop $(docker ps -aq)
}

# Docker remove all containers
drm_all() {
  docker rm $(docker ps -aq)
}

# Docker shell into container
dsh() {
  docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# ============================================================================
# Network Functions
# ============================================================================

# Get public IP
myip() {
  curl -s https://api.ipify.org && echo
}

# Get local IP
localip() {
  ipconfig getifaddr en0 || hostname -I | awk '{print $1}'
}

# Port check
port() {
  lsof -i :"$1"
}

# ============================================================================
# System Functions
# ============================================================================

# Disk usage of current directory
duh() {
  if command -v dust &>/dev/null; then
    dust
  else
    du -h --max-depth=1 | sort -hr
  fi
}

# Find largest files
largest() {
  local num="${1:-10}"
  find . -type f -exec du -h {} + | sort -rh | head -n "$num"
}

# System info
sysinfo() {
  echo "=== System Information ==="
  echo "Hostname: $(hostname)"
  echo "OS: $(uname -s)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(uname -m)"
  echo "Uptime: $(uptime)"
  echo "Shell: $SHELL ($BASH_VERSION)"
  echo "User: $USER"
  echo "Home: $HOME"
  echo "PWD: $PWD"
}

# ============================================================================
# Productivity Functions
# ============================================================================

# Quick note
note() {
  local note_file="$HOME/notes/$(date +%Y-%m-%d).md"
  mkdir -p "$HOME/notes"
  if [ -n "$1" ]; then
    echo "$(date +%H:%M:%S) - $*" >> "$note_file"
  else
    ${EDITOR:-nvim} "$note_file"
  fi
}

# Timer
timer() {
  local seconds="${1:-60}"
  echo "Timer set for $seconds seconds"
  sleep "$seconds" && echo "Time's up!" && osascript -e 'beep 3'
}

# Countdown
countdown() {
  local seconds="${1:-10}"
  while [ "$seconds" -gt 0 ]; do
    echo -ne "$seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo "Time's up!"
}

# ============================================================================
# Search Functions
# ============================================================================

# Search in files
search() {
  if command -v rg &>/dev/null; then
    rg "$@"
  else
    grep -r "$@" .
  fi
}

# Search in history
h() {
  if [ -n "$1" ]; then
    history | grep "$@"
  else
    history
  fi
}

# ============================================================================
# Backup Functions
# ============================================================================

# Backup file
backup() {
  cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Restore backup
restore() {
  if [ -f "$1" ]; then
    cp "$1" "${1%.backup-*}"
  else
    echo "Backup file not found: $1"
  fi
}

# ============================================================================
# macOS Specific Functions
# ============================================================================

# Open current directory in Finder
o() {
  if [ -n "$1" ]; then
    open "$1"
  else
    open .
  fi
}

# Quick Look
ql() {
  qlmanage -p "$@" &>/dev/null
}

# ============================================================================
# Misc Functions
# ============================================================================

# Weather
weather() {
  local location="${1:-}"
  curl "wttr.in/$location"
}

# Cheat sheet
cheat() {
  curl "cheat.sh/$1"
}

# Generate random password
genpass() {
  local length="${1:-20}"
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c "$length" && echo
}

# ============================================================================
# End of functions.bash
# ============================================================================

