# ============================================================================
# Work-Specific Configuration
# ============================================================================
# TTAPI helpers, project aliases, and work-related functions
# ============================================================================

# ============================================================================
# Quick Repository Navigation with Fuzzy Finder
# ============================================================================
# Interactive repository switcher with frecency tracking
# Usage:
#   g           → Interactive fuzzy finder (sorted by usage frequency)
#   g <shortcut> → Direct jump (e.g., "g t" → ttapi)
# ============================================================================

# Frecency tracking file
REPO_FRECENCY_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/repo-frecency.txt"

# Repository mapping (shortcut → path)
# Work repos (Intuit): ~/GitHub/*
# Personal repos: ~/Private/GitHub/*
declare -A REPO_MAP=(
  # Work repositories (Intuit)
  [s]="$HOME/GitHub/spend-mgmt"
  [i]="$HOME/GitHub/idx-triage-svc"
  [e]="$HOME/GitHub/ets-event-processor"
  [x]="$HOME/GitHub/exp-mgmt-service"
  [a]="$HOME/GitHub/accounting-automation"
  [u]="$HOME/GitHub/accounting-automation-ui"
  [g]="$HOME/GitHub/globalid"

  # Personal repositories
  [t]="$HOME/Private/GitHub/ttapi"
  [c]="$HOME/Private/GitHub/calculator"
  [d]="$HOME/dotfiles"
  [p]="$HOME/Private/GitHub"
)

# Update frecency score for a repository
__update_frecency() {
  local repo="$1"
  local frecency_file="$REPO_FRECENCY_FILE"

  # Create directory and file if they don't exist
  local frecency_dir=$(/usr/bin/dirname "$frecency_file")
  [[ ! -d "$frecency_dir" ]] && /bin/mkdir -p "$frecency_dir"
  [[ ! -f "$frecency_file" ]] && /usr/bin/touch "$frecency_file"

  # Get current timestamp
  local now=$(/bin/date +%s)

  # Read existing scores
  local temp_file=$(/usr/bin/mktemp)
  local found=0

  while IFS='|' read -r path count last_access; do
    if [[ "$path" == "$repo" ]]; then
      # Increment count and update timestamp
      builtin echo "$path|$((count + 1))|$now" >> "$temp_file"
      found=1
    else
      builtin echo "$path|$count|$last_access" >> "$temp_file"
    fi
  done < "$frecency_file"

  # Add new entry if not found
  if [[ $found -eq 0 ]]; then
    builtin echo "$repo|1|$now" >> "$temp_file"
  fi

  /bin/mv "$temp_file" "$frecency_file"
}

# Get sorted repository list by frecency
__get_sorted_repos() {
  local frecency_file="$REPO_FRECENCY_FILE"
  local now=$(/bin/date +%s)
  local temp_scores=$(/usr/bin/mktemp)

  # Calculate frecency scores for all repos
  for key in ${(k)REPO_MAP}; do
    local repo_path="${REPO_MAP[$key]}"
    local name=$(/usr/bin/basename "$repo_path")
    local count=0
    local last_access=0
    local score=0

    # Get stats from frecency file
    if [[ -f "$frecency_file" ]]; then
      while IFS='|' read -r fpath fcount flast; do
        if [[ "$fpath" == "$repo_path" ]]; then
          count=$fcount
          last_access=$flast
          break
        fi
      done < "$frecency_file"
    fi

    # Calculate score: frequency * recency_weight
    # Recency weight: 1.0 for today, decays over time
    local age=$((now - last_access))
    local days=$((age / 86400))
    local recency_weight=$(/usr/bin/awk "BEGIN {print 1.0 / (1.0 + $days * 0.1)}")
    score=$(/usr/bin/awk "BEGIN {print $count * $recency_weight}")

    # Format: score|shortcut|name|repo_path
    builtin printf "%.2f|%s|%s|%s\n" "$score" "$key" "$name" "$repo_path" >> "$temp_scores"
  done

  # Sort by score (descending) and format for fzf
  /usr/bin/sort -t'|' -k1 -rn "$temp_scores" | while IFS='|' read -r score key name repo_path; do
    builtin printf "%-3s  %s\n" "$key" "$name"
  done

  /bin/rm -f "$temp_scores"
}

# Navigation function
# Unalias 'g' if it exists (to avoid conflicts with git/gradle aliases)
unalias g 2>/dev/null

g() {
  # Direct shortcut provided
  if [[ $# -gt 0 ]]; then
    local shortcut="$1"
    local target="${REPO_MAP[$shortcut]}"

    if [[ -z "$target" ]]; then
      echo "❌ Unknown shortcut: '$shortcut'"
      echo "💡 Run 'g' without arguments for interactive selection"
      return 1
    fi

    if [[ ! -d "$target" ]]; then
      echo "❌ Directory not found: $target"
      return 1
    fi

    # NOTE: Frecency tracking disabled due to shell corruption issues
    # __update_frecency "$target"
    echo "📂 → $(/usr/bin/basename "$target")"
    builtin cd "$target"
    return 0
  fi

  # Interactive mode with fzf
  if ! command -v fzf &>/dev/null; then
    echo "❌ fzf not found. Install with: brew install fzf"
    return 1
  fi

  # Get sorted list and show in fzf
  local selection=$(__get_sorted_repos | fzf \
    --height=40% \
    --reverse \
    --border \
    --prompt="📂 Repository: " \
    --header="Select repository (sorted by usage)" \
    --preview="echo {} | awk '{print \$2}' | xargs -I{} ls -la \$HOME/GitHub/{} \$HOME/Private/GitHub/{} \$HOME/{} 2>/dev/null | head -20" \
    --preview-window=right:50%:wrap)

  if [[ -z "$selection" ]]; then
    return 0  # User cancelled
  fi

  # Extract shortcut from selection
  local shortcut=$(builtin echo "$selection" | /usr/bin/awk '{print $1}')
  local target="${REPO_MAP[$shortcut]}"

  if [[ -n "$target" && -d "$target" ]]; then
    # NOTE: Frecency tracking disabled due to shell corruption issues
    # __update_frecency "$target"
    echo "📂 → $(/usr/bin/basename "$target")"
    builtin cd "$target"
  fi
}

# ============================================================================
# App Aliases
# ============================================================================

alias awm=appf-webtools-mgr
alias atm=appf-webtools-mgr

# ============================================================================
# TTAPI Helpers
# ============================================================================

# Helper functions
__ttapi_is_direnv_active() { command -v direnv >/dev/null 2>&1 && [[ -f .envrc ]]; }

__ttapi_config_home() {
  if [[ -n "$TTAPI_CONFIG_HOME" && -d "$TTAPI_CONFIG_HOME" ]]; then
    printf '%s' "$TTAPI_CONFIG_HOME"
  else
    local base="${XDG_CONFIG_HOME:-$HOME/.config}"
    printf '%s' "$base/ttapi"
  fi
}

__ttapi_env_path() {
  local env="$1"
  local cfg="$(__ttapi_config_home)"
  local f="$cfg/.env.$env"
  [[ -f "$f" ]] && printf '%s' "$f"
}

__ttapi_load_env_file() {
  [[ -f "$1" ]] || return 1
  set -a
  source "$1"
  set +a
  [[ -z "$TT_ENVIRONMENT" ]] && export TT_ENVIRONMENT="${TTAPI_TARGET_ENV:-sandbox}"
}

# Unset TTAPI environment
ttapi_unset() {
  unset TT_ENVIRONMENT TT_OAUTH2_CLIENT_ID TT_OAUTH2_CLIENT_SECRET \
        TT_OAUTH2_REFRESH_TOKEN TT_OAUTH2_CLIENT_ID_ENC \
        TT_OAUTH2_CLIENT_SECRET_ENC TT_OAUTH2_REFRESH_TOKEN_ENC
  if __ttapi_is_direnv_active; then
    direnv reload >/dev/null 2>&1 || true
  fi
}

# Use TTAPI environment
use_ttapi_env() {
  case "$1" in
    sandbox|production)
      export TTAPI_TARGET_ENV="$1"
      if __ttapi_is_direnv_active; then
        direnv reload >/dev/null 2>&1 || true
      else
        ttapi_unset
        local p
        p="$(__ttapi_env_path "$1")"
        if [[ -n "$p" ]]; then
          __ttapi_load_env_file "$p"
        else
          echo "ttapi: profile not found: $(__ttapi_config_home)/.env.$1" >&2
        fi
      fi
      ;;
    *)
      echo "usage: use_ttapi_env [sandbox|production]" >&2
      return 1
      ;;
  esac
}

alias tt-sbx='use_ttapi_env sandbox'
alias tt-prod='use_ttapi_env production'
alias tt-unset='ttapi_unset'

# ============================================================================
# 1Password CLI Wrappers
# ============================================================================

__ttapi_op_available() { command -v op >/dev/null 2>&1; }
__ttapi_op_signed_in() { op whoami >/dev/null 2>&1; }

__ttapi_op_config() {
  local env="$1"
  local cid csec rtok
  case "$env" in
    sandbox)
      cid="${TTAPI_OP_SANDBOX_CLIENT_ID:-op://TTAPI/Sandbox/client_id}"
      csec="${TTAPI_OP_SANDBOX_CLIENT_SECRET:-op://TTAPI/Sandbox/client_secret}"
      rtok="${TTAPI_OP_SANDBOX_REFRESH_TOKEN:-op://TTAPI/Sandbox/refresh_token}"
      ;;
    production)
      cid="${TTAPI_OP_PRODUCTION_CLIENT_ID:-op://TTAPI/Production/client_id}"
      csec="${TTAPI_OP_PRODUCTION_CLIENT_SECRET:-op://TTAPI/Production/client_secret}"
      rtok="${TTAPI_OP_PRODUCTION_REFRESH_TOKEN:-op://TTAPI/Production/refresh_token}"
      ;;
    *)
      echo "ttapi: unknown env '$env'" >&2
      return 1
      ;;
  esac
  printf '%s|%s|%s' "$cid" "$csec" "$rtok"
}

__ttapi_op_run() {
  local env="$1"
  shift || true
  if ! __ttapi_op_available; then
    echo "ttapi: 1Password CLI 'op' not found" >&2
    return 1
  fi
  if ! __ttapi_op_signed_in; then
    echo "ttapi: please sign in to 1Password CLI (run: op signin)" >&2
    return 1
  fi
  local triple
  triple="$(__ttapi_op_config "$env")" || return 1
  local cid csec rtok
  IFS='|' read -r cid csec rtok <<< "$triple"
  TT_ENVIRONMENT="$env" op run \
    --env "TT_OAUTH2_CLIENT_ID=$cid" \
    --env "TT_OAUTH2_CLIENT_SECRET=$csec" \
    --env "TT_OAUTH2_REFRESH_TOKEN=$rtok" \
    -- "$@"
}

alias tt-sbx-run='__ttapi_op_run sandbox'
alias tt-prod-run='__ttapi_op_run production'

# ============================================================================
# gopass Wrappers
# ============================================================================

__ttapi_gopass_available() { command -v gopass >/dev/null 2>&1; }

__ttapi_gopass_paths() {
  local env="$1"
  local cid csec rtok
  case "$env" in
    sandbox)
      cid="${TTAPI_GOPASS_SANDBOX_CLIENT_ID:-TTAPI/Sandbox/client_id}"
      csec="${TTAPI_GOPASS_SANDBOX_CLIENT_SECRET:-TTAPI/Sandbox/client_secret}"
      rtok="${TTAPI_GOPASS_SANDBOX_REFRESH_TOKEN:-TTAPI/Sandbox/refresh_token}"
      ;;
    production)
      cid="${TTAPI_GOPASS_PRODUCTION_CLIENT_ID:-TTAPI/Production/client_id}"
      csec="${TTAPI_GOPASS_PRODUCTION_CLIENT_SECRET:-TTAPI/Production/client_secret}"
      rtok="${TTAPI_GOPASS_PRODUCTION_REFRESH_TOKEN:-TTAPI/Production/refresh_token}"
      ;;
    *)
      echo "ttapi: unknown env '$env'" >&2
      return 1
      ;;
  esac
  printf '%s|%s|%s' "$cid" "$csec" "$rtok"
}

__ttapi_gopass_run() {
  local env="$1"
  shift || true
  if ! __ttapi_gopass_available; then
    echo "ttapi: 'gopass' CLI not found" >&2
    return 1
  fi
  local triple
  triple="$(__ttapi_gopass_paths "$env")" || return 1
  local cid_path csec_path rtok_path
  IFS='|' read -r cid_path csec_path rtok_path <<< "$triple"
  local cid csec rtok
  cid="$(gopass show -o "$cid_path")" || { echo "ttapi: missing $cid_path" >&2; return 1; }
  csec="$(gopass show -o "$csec_path")" || { echo "ttapi: missing $csec_path" >&2; return 1; }
  rtok="$(gopass show -o "$rtok_path")" || { echo "ttapi: missing $rtok_path" >&2; return 1; }
  TT_ENVIRONMENT="$env" \
  TT_OAUTH2_CLIENT_ID="$cid" \
  TT_OAUTH2_CLIENT_SECRET="$csec" \
  TT_OAUTH2_REFRESH_TOKEN="$rtok" \
    "$@"
}

alias tt-sbx-gopass-run='__ttapi_gopass_run sandbox'
alias tt-prod-gopass-run='__ttapi_gopass_run production'

# Profile-specific gopass wrappers
__ttapi_gopass_custom_run() {
  local env="$1"
  local base="$2"
  shift 2 || true
  if ! __ttapi_gopass_available; then
    echo "ttapi: 'gopass' CLI not found" >&2
    return 1
  fi
  local cid csec rtok
  cid="$(gopass show -o "$base/client_id")" || { echo "ttapi: missing $base/client_id" >&2; return 1; }
  csec="$(gopass show -o "$base/client_secret")" || { echo "ttapi: missing $base/client_secret" >&2; return 1; }
  rtok="$(gopass show -o "$base/refresh_token")" || { echo "ttapi: missing $base/refresh_token" >&2; return 1; }
  TT_ENVIRONMENT="$env" \
  TT_OAUTH2_CLIENT_ID="$cid" \
  TT_OAUTH2_CLIENT_SECRET="$csec" \
  TT_OAUTH2_REFRESH_TOKEN="$rtok" \
    "$@"
}

alias tt_sandbox='__ttapi_gopass_custom_run sandbox TTAPI/Sandbox'
alias tt_robbi='__ttapi_gopass_custom_run production TTAPI/Robert'
alias tt_sky='__ttapi_gopass_custom_run production TTAPI/Sky'

# ============================================================================
# Spend Management Project Aliases
# ============================================================================

alias spend_cd='cd /Users/rnio/GitHub/spend-mgmt'
alias spend_eiam='eiamCli login; eiamCli getAWSTempCredentials -a 432647000723 -r PowerUser -p profile_1234'
alias spend_db_init='podman play kube podman-postgre-pod.yaml'
alias spend_db_start='podman machine start; podman start postgre-sql-spend-mgmt-db'
alias spend_db_stop='podman stop postgre-sql-spend-mgmt-db'
alias spend_run='spend_cd; mvn clean spring-boot:run -s settings.xml -f app/core/pom.xml'
alias spend_run_initial='spend_cd; mvn -s settings.xml clean install; mvn spring-boot:run -s settings.xml -f app/core/pom.xml'
alias spend_spotless='spend_cd; cd app; spotless'
alias spend_health='curl -k https://localhost:8443/health/full'

# ============================================================================
# Maven Optimizations
# ============================================================================

# Parallel Maven builds with optimized settings
alias mbuild='MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED -Xmx4g -XX:+UseParallelGC" mvnd -T 1.5C'
alias m15='MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED -Xmx4g -XX:+UseParallelGC" mvn -T 1.5C'

