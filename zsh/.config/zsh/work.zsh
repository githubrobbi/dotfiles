# ============================================================================
# Work-Specific Configuration
# ============================================================================
# TTAPI helpers, project aliases, and work-related functions
# ============================================================================

# ============================================================================
# GitJump Helpers
# ============================================================================

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

