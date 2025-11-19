# ============================================================================
# Work-Specific Configuration (Intuit/TTAPI)
# ============================================================================

# ============================================================================
# Project Shortcuts
# ============================================================================

# Quick navigation to projects
alias ttapi='cd ~/Github/ttapi'
alias dotfiles='cd ~/dotfiles'
alias projects='cd ~/Github'

# ============================================================================
# TTAPI Specific
# ============================================================================

# Cargo watch for TTAPI
alias ttwatch='cargo watch -x check -x test'
alias ttrun='cargo run'
alias tttest='cargo test'
alias ttbuild='cargo build --release'

# ============================================================================
# Intuit Environment
# ============================================================================

# Maven/Nexus
export NEXUS_PROXY_URL=https://artifact.intuit.com/artifactory/maven-proxy

# JMeter
export JMETER_HOME=/opt/homebrew/Cellar/jmeter/5.6.3/libexec

# App-specific
export APP_NAME=ETS_COMPONENT_TEST
export DB_REGION=LOCAL

# ============================================================================
# Work Functions
# ============================================================================

# Start TTAPI development environment
ttstart() {
  echo "Starting TTAPI development environment..."
  cd ~/Github/ttapi || return
  
  # Open in VSCode
  code .
  
  # Start cargo watch in background
  cargo watch -x check -x test &
  
  echo "✅ TTAPI environment ready!"
}

# Clean TTAPI build artifacts
ttclean() {
  cd ~/Github/ttapi || return
  cargo clean
  echo "✅ TTAPI cleaned"
}

# Update TTAPI dependencies
ttupdate() {
  cd ~/Github/ttapi || return
  cargo update
  cargo outdated
  echo "✅ TTAPI dependencies updated"
}

# ============================================================================
# AppFabric (if present)
# ============================================================================

if [ -d "$HOME/.appfabric-bin" ]; then
  alias atm='appf-webtools-mgr'
fi

# ============================================================================
# End of work.bash
# ============================================================================

