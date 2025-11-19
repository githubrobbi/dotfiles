# ============================================================================
# .bash_profile - Login Shell Configuration
# ============================================================================
# This file is sourced by bash for login shells
# On macOS, Terminal.app and iTerm2 start login shells by default
# ============================================================================

# Source .bashrc for interactive shells
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi

# ============================================================================
# Login Shell Specific Configuration
# ============================================================================

# macOS: Add Homebrew to PATH early (for login shells)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# SSH Agent (if not already running)
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  # Check for existing agent
  if [[ -f "$HOME/.ssh/agent.env" ]]; then
    source "$HOME/.ssh/agent.env" >/dev/null 2>&1
  fi
  
  # Start new agent if needed
  if ! ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
    mkdir -p "$HOME/.ssh"
    ssh-agent -s > "$HOME/.ssh/agent.env"
    source "$HOME/.ssh/agent.env" >/dev/null 2>&1
    # Quietly load default keys
    command -v ssh-add &>/dev/null && ssh-add -A >/dev/null 2>&1 || true
  fi
fi

# ============================================================================
# macOS Specific
# ============================================================================

# Set PATH for GUI applications (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Ensure /usr/local/bin is in PATH for GUI apps
  launchctl setenv PATH "$PATH"
fi

# ============================================================================
# End of .bash_profile
# ============================================================================

