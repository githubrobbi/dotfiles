##### ─────────────────────────────────────────────────────────────────────
##### Core env bootstrap (Brew → SDKMAN → Python shims) 
##### ─────────────────────────────────────────────────────────────────────

# Homebrew: ensure /opt/homebrew bin/sbin lead PATH (safe even if already set)
if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# SDKMAN: guarded init; make sdk available early without double-sourcing
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Prefer Homebrew Python 3.14 shims for unversioned python/pip
export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:$PATH"


##### ─────────────────────────────────────────────────────────────────────
##### Powerlevel10k instant prompt (keep near top)
##### ─────────────────────────────────────────────────────────────────────

# Suppress instant prompt warnings
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input must go above this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


##### ─────────────────────────────────────────────────────────────────────
##### Locale
##### ─────────────────────────────────────────────────────────────────────

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


##### ─────────────────────────────────────────────────────────────────────
##### direnv (quiet)
##### ─────────────────────────────────────────────────────────────────────

if command -v direnv >/dev/null 2>&1; then
  export DIRENV_LOG_FORMAT=""
  eval "$(direnv hook zsh)"
fi


##### ─────────────────────────────────────────────────────────────────────
##### PATH helpers & zsh options
##### ─────────────────────────────────────────────────────────────────────

# PATH helpers and hygiene
# - Deduplicate automatically (unique elements) while preserving order
# - Append/prepend only if the directory exists
typeset -gU path fpath
path_append_if_exists()  { [ -d "$1" ] && path+=("$1"); }
path_prepend_if_exists() { [ -d "$1" ] && path=("$1" $path); }

# Useful zsh options
setopt HIST_VERIFY          # Edit recalled history line before executing
setopt NO_LIST_BEEP         # No beep when completing with multiple matches
setopt INTERACTIVE_COMMENTS # Allow comments in interactive commands
setopt NO_FLOW_CONTROL      # Disable XON/XOFF (prevents accidental ^S freeze)

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS


##### ─────────────────────────────────────────────────────────────────────
##### SSH agent — adopt/repair if missing, preserve existing behavior
##### ─────────────────────────────────────────────────────────────────────

# v2: adopt running agent; prefer 1Password (new or legacy); reuse saved env; else start fresh
ssh_agent_setup() {
  # Already valid? done.
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

  # Reuse previously saved agent environment (your historical flow)
  if [[ -r "$HOME/.ssh/agent.env" ]]; then
    . "$HOME/.ssh/agent.env" >/dev/null 2>&1
    if ssh-add -l >/dev/null 2>&1; then
      return 0
    else
      rm -f "$HOME/.ssh/agent.env"
    fi
  fi

  # Start new agent; persist for future shells; quietly load default keys
  mkdir -p "$HOME/.ssh"
  ssh-agent -s > "$HOME/.ssh/agent.env"
  . "$HOME/.ssh/agent.env" >/dev/null 2>&1
  command -v ssh-add >/dev/null 2>&1 && ssh-add -A >/dev/null 2>&1 || true
}

ssh_agent_kill() {
  if [[ -r "$HOME/.ssh/agent.env" ]]; then
    . "$HOME/.ssh/agent.env" >/dev/null 2>&1
  fi
  command -v ssh-agent >/dev/null 2>&1 && ssh-agent -k >/dev/null 2>&1
  rm -f "$HOME/.ssh/agent.env"
  # intentionally not unsetting SSH_AUTH_SOCK/SSH_AGENT_PID here
}

# Initialize/repair SSH agent automatically (quiet)
ssh_agent_setup

# Handy aliases
alias ssh-fix='ssh_agent_setup'
alias ssh-agent-restart='ssh_agent_kill && ssh_agent_setup'


##### ─────────────────────────────────────────────────────────────────────
##### LLVM toolchain via Homebrew (if present)
##### ─────────────────────────────────────────────────────────────────────

if command -v brew >/dev/null 2>&1; then
  __llvm_prefix="$(brew --prefix llvm 2>/dev/null)"
  if [[ -n "$__llvm_prefix" && -d "$__llvm_prefix" ]]; then
    export PATH="$__llvm_prefix/bin:$PATH"
    export LDFLAGS="-L$__llvm_prefix/lib${LDFLAGS:+:$LDFLAGS}"
    export CPPFLAGS="-I$__llvm_prefix/include${CPPFLAGS:+:$CPPFLAGS}"
  fi
fi


##### ─────────────────────────────────────────────────────────────────────
##### Oh My Zsh / themes / updates
##### ─────────────────────────────────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 30

# load plugins (zplug if present)
[ -f ~/.zplug.sh ] && source ~/.zplug.sh

# oh-my-zsh core
source "$ZSH/oh-my-zsh.sh"


##### ─────────────────────────────────────────────────────────────────────
##### Key bindings
##### ─────────────────────────────────────────────────────────────────────

bindkey '[C' forward-word   # alt+left
bindkey '[D' backward-word  # alt+right


##### ─────────────────────────────────────────────────────────────────────
##### PATH additions & Java
##### ─────────────────────────────────────────────────────────────────────

path_append_if_exists "$HOME/bin"
# path_append_if_exists "$HOME/bin/rust/debug"
path_append_if_exists "$HOME/bin/rust/release"
path_append_if_exists "$HOME/.appfabric-bin"

# Java via SDKMAN: stable JAVA_HOME; do NOT call `sdk` in rc files
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"


##### ─────────────────────────────────────────────────────────────────────
##### GitJump helpers
##### ─────────────────────────────────────────────────────────────────────

gg_func() {
  local repo_path
  repo_path=$(go_to cd "$@")
  echo -e "\nWir gehen zu: $repo_path\n"
  echo cd "$repo_path"
  cd "$repo_path"
}

local_func() {
  go_to local "$@"
}

alias g='gg_func'
alias l='local_func'


##### ─────────────────────────────────────────────────────────────────────
##### App aliases & env
##### ─────────────────────────────────────────────────────────────────────

alias awm=appf-webtools-mgr
alias atm=appf-webtools-mgr

export JMETER_HOME=/opt/homebrew/Cellar/jmeter/5.6.3/libexec
export TESTCONTAINERS_ENABLED=false
export DOCKER_HOST="$HOME/.local/share/containers/podman/machine/applehv/podman.sock"
export NODE_EXTRA_CA_CERTS=~/Documents/caadmin.netskope.com.pem

##########
# podman #
##########
# (kept historical notes; warning echo removed earlier)
# export NEXUS_PROXY_URL=https://nexus.intuit.com/nexus
export NEXUS_PROXY_URL=https://artifact.intuit.com/artifactory/maven-proxy


##### ─────────────────────────────────────────────────────────────────────
##### p10k theme / iTerm2 integration
##### ─────────────────────────────────────────────────────────────────────

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme


##### ─────────────────────────────────────────────────────────────────────
##### TTAPI helpers (unchanged; kept verbatim)
##### ─────────────────────────────────────────────────────────────────────

# ttapi zsh helpers (repo or system-wide)
# - use_ttapi_env: set TTAPI_TARGET_ENV and load from direnv if .envrc present, else from ~/.config/ttapi/.env.<env>
# - ttapi_unset: clear TT_*; if in a direnv-enabled repo, reload; otherwise just unset
# - aliases: quick toggles
__ttapi_is_direnv_active() { command -v direnv >/dev/null 2>&1 && [ -f .envrc ]; }
__ttapi_config_home() {
  if [ -n "$TTAPI_CONFIG_HOME" ] && [ -d "$TTAPI_CONFIG_HOME" ]; then
    printf '%s' "$TTAPI_CONFIG_HOME"
  else
    local base="${XDG_CONFIG_HOME:-$HOME/.config}"; printf '%s' "$base/ttapi"
  fi
}
__ttapi_env_path() { local env="$1"; local cfg="$(__ttapi_config_home)"; local f="$cfg/.env.$env"; [ -f "$f" ] && printf '%s' "$f"; }
__ttapi_load_env_file() { [ -f "$1" ] || return 1; set -a; . "$1"; set +a; [ -z "$TT_ENVIRONMENT" ] && export TT_ENVIRONMENT="${TTAPI_TARGET_ENV:-sandbox}"; }

ttapi_unset() {
  unset TT_ENVIRONMENT TT_OAUTH2_CLIENT_ID TT_OAUTH2_CLIENT_SECRET TT_OAUTH2_REFRESH_TOKEN TT_OAUTH2_CLIENT_ID_ENC TT_OAUTH2_CLIENT_SECRET_ENC TT_OAUTH2_REFRESH_TOKEN_ENC
  if __ttapi_is_direnv_active; then direnv reload >/dev/null 2>&1 || true; fi
}

use_ttapi_env() {
  case "$1" in
    sandbox|production)
      export TTAPI_TARGET_ENV="$1"
      if __ttapi_is_direnv_active; then
        direnv reload >/dev/null 2>&1 || true
      else
        ttapi_unset
        local p; p="$(__ttapi_env_path "$1")"
        if [ -n "$p" ]; then __ttapi_load_env_file "$p"; else echo "ttapi: profile not found: $(__ttapi_config_home)/.env.$1" >&2; fi
      fi
      ;;
    *) echo "usage: use_ttapi_env [sandbox|production]" >&2; return 1 ;;
  esac
}

alias tt-sbx='use_ttapi_env sandbox'
alias tt-prod='use_ttapi_env production'
alias tt-unset='ttapi_unset'

# 1Password CLI wrappers (optional)
__ttapi_op_available() { command -v op >/dev/null 2>&1; }
__ttapi_op_signed_in() { op whoami >/dev/null 2>&1; }
__ttapi_op_config() {
  local env="$1"; local cid csec rtok
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
    *) echo "ttapi: unknown env '$env'" >&2; return 1 ;;
  esac
  printf '%s|%s|%s' "$cid" "$csec" "$rtok"
}
__ttapi_op_run() {
  local env="$1"; shift || true
  if ! __ttapi_op_available; then echo "ttapi: 1Password CLI 'op' not found" >&2; return 1; fi
  if ! __ttapi_op_signed_in; then echo "ttapi: please sign in to 1Password CLI (run: op signin)" >&2; return 1; fi
  local triple; triple="$(__ttapi_op_config "$env")" || return 1
  local cid csec rtok
  IFS='|' read -r cid csec rtok <<EOF
$triple
EOF
  TT_ENVIRONMENT="$env" op run \
    --env "TT_OAUTH2_CLIENT_ID=$cid" \
    --env "TT_OAUTH2_CLIENT_SECRET=$csec" \
    --env "TT_OAUTH2_REFRESH_TOKEN=$rtok" \
    -- "$@"
}
alias tt-sbx-run='__ttapi_op_run sandbox'
alias tt-prod-run='__ttapi_op_run production'

# gopass wrappers (optional)
__ttapi_gopass_available() { command -v gopass >/dev/null 2>&1; }
__ttapi_gopass_paths() {
  local env="$1"; local cid csec rtok
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
    *) echo "ttapi: unknown env '$env'" >&2; return 1 ;;
  esac
  printf '%s|%s|%s' "$cid" "$csec" "$rtok"
}
__ttapi_gopass_run() {
  local env="$1"; shift || true
  if ! __ttapi_gopass_available; then echo "ttapi: 'gopass' CLI not found" >&2; return 1; fi
  local triple; triple="$(__ttapi_gopass_paths "$env")" || return 1
  local cid_path csec_path rtok_path
  IFS='|' read -r cid_path csec_path rtok_path <<EOF
$triple
EOF
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
  local env="$1"; local base="$2"; shift 2 || true
  if ! __ttapi_gopass_available; then echo "ttapi: 'gopass' CLI not found" >&2; return 1; fi
  local cid csec rtok
  cid="$(gopass show -o "$base/client_id")"       || { echo "ttapi: missing $base/client_id" >&2; return 1; }
  csec="$(gopass show -o "$base/client_secret")"  || { echo "ttapi: missing $base/client_secret" >&2; return 1; }
  rtok="$(gopass show -o "$base/refresh_token")"  || { echo "ttapi: missing $base/refresh_token" >&2; return 1; }
  TT_ENVIRONMENT="$env" \
  TT_OAUTH2_CLIENT_ID="$cid" \
  TT_OAUTH2_CLIENT_SECRET="$csec" \
  TT_OAUTH2_REFRESH_TOKEN="$rtok" \
    "$@"
}
alias tt_sandbox='__ttapi_gopass_custom_run sandbox TTAPI/Sandbox'
alias tt_robbi='__ttapi_gopass_custom_run production TTAPI/Robert'
alias tt_sky='__ttapi_gopass_custom_run production TTAPI/Sky'


##### ─────────────────────────────────────────────────────────────────────
##### Rust / build / project aliases
##### ─────────────────────────────────────────────────────────────────────

export RUST_LOG="${RUST_LOG:-error,tt=off}"
if command -v sccache >/dev/null 2>&1; then
  export RUSTC_WRAPPER="$(command -v sccache)"
fi

# Maven
alias spotless='mvn spotless:apply'

# Spend Management commands
alias spend_cd='cd /Users/rnio/GitHub/spend-mgmt'
alias spend_eiam='eiamCli login; eiamCli getAWSTempCredentials -a 432647000723 -r PowerUser -p profile_1234'
alias spend_db_init='podman play kube podman-postgre-pod.yaml'
alias spend_db_start='podman machine start; podman start postgre-sql-spend-mgmt-db'
alias spend_db_stop='podman stop postgre-sql-spend-mgmt-db'
alias spend_run='spend_cd; mvn clean spring-boot:run -s settings.xml -f app/core/pom.xml'
alias spend_run_initial='spend_cd; mvn -s settings.xml clean install; mvn spring-boot:run -s settings.xml -f app/core/pom.xml'
alias spend_spotless='spend_cd; cd app; spotless'
alias spend_health='curl -k https://localhost:8443/health/full'

# Added by Windsurf
path_prepend_if_exists "$HOME/.codeium/windsurf/bin"
alias mbuild='MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED -Xmx4g -XX:+UseParallelGC" mvnd -T 1.5C'
alias m15='MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED -Xmx4g -XX:+UseParallelGC" mvn -T 1.5C'

export APP_NAME=ETS_COMPONENT_TEST
export DB_REGION=LOCAL

# Local bin for pipx etc.
path_append_if_exists "$HOME/.local/bin"
