# ============================================================================
# SSH Agent Configuration
# ============================================================================
# Intelligent SSH agent management with 1Password support
# ============================================================================

# SSH agent setup - adopt running agent, prefer 1Password, or start new
ssh_agent_setup() {
  # Already valid? Done.
  if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]]; then
    return 0
  fi

  # Try to adopt an existing ssh-agent socket
  local pid sock
  pid="$(pgrep -x ssh-agent | head -n1)"
  if [[ -n "$pid" ]]; then
    sock="$(lsof -a -p "$pid" -U 2>/dev/null | awk 'NR>1{print $9; exit}')"
    if [[ -S "$sock" ]]; then
      export SSH_AUTH_SOCK="$sock"
      return 0
    fi
  fi

  # Prefer 1Password agent (new path first, then legacy)
  local op_new="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  local op_old="$HOME/.1password/agent.sock"
  if [[ -S "$op_new" ]]; then
    export SSH_AUTH_SOCK="$op_new"
    return 0
  elif [[ -S "$op_old" ]]; then
    export SSH_AUTH_SOCK="$op_old"
    return 0
  fi

  # Reuse previously saved agent environment
  if [[ -r "$HOME/.ssh/agent.env" ]]; then
    source "$HOME/.ssh/agent.env" >/dev/null 2>&1
    if ssh-add -l >/dev/null 2>&1; then
      return 0
    else
      rm -f "$HOME/.ssh/agent.env"
    fi
  fi

  # Start new agent; persist for future shells; quietly load default keys
  mkdir -p "$HOME/.ssh"
  ssh-agent -s > "$HOME/.ssh/agent.env"
  source "$HOME/.ssh/agent.env" >/dev/null 2>&1
  command -v ssh-add &>/dev/null && ssh-add -A >/dev/null 2>&1 || true
}

# Kill SSH agent
ssh_agent_kill() {
  if [[ -r "$HOME/.ssh/agent.env" ]]; then
    source "$HOME/.ssh/agent.env" >/dev/null 2>&1
  fi
  command -v ssh-agent &>/dev/null && ssh-agent -k >/dev/null 2>&1
  rm -f "$HOME/.ssh/agent.env"
}

# Initialize SSH agent automatically (quiet)
ssh_agent_setup

# Handy aliases
alias ssh-fix='ssh_agent_setup'
alias ssh-agent-restart='ssh_agent_kill && ssh_agent_setup'

