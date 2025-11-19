#!/usr/bin/env bash
# ============================================================================
# Safe Stow - Backup Before Stowing
# ============================================================================
# This script safely stows dotfiles by:
# 1. Backing up existing files first
# 2. Running stow with conflict detection
# 3. Providing easy rollback if something goes wrong
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC}  $1"; }
log_success() { echo -e "${GREEN}✓${NC}  $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }
log_error() { echo -e "${RED}✗${NC}  $1"; }

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
SKIP_BACKUP=false
FORCE=false
RESTOW=true

# Parse arguments
PACKAGES=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --no-backup)
      SKIP_BACKUP=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --no-restow)
      RESTOW=false
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [OPTIONS] [PACKAGES...]"
      echo ""
      echo "Safely stow dotfiles with automatic backup."
      echo ""
      echo "Options:"
      echo "  --dry-run      Show what would be done without doing it"
      echo "  --no-backup    Skip backup step (not recommended)"
      echo "  --force        Force stow even if conflicts exist"
      echo "  --no-restow    Don't use -R flag (restow)"
      echo "  --help         Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0                    # Stow all packages with backup"
      echo "  $0 bash zsh           # Stow only bash and zsh"
      echo "  $0 --dry-run          # Preview what would happen"
      echo "  $0 --force bash       # Force stow bash even with conflicts"
      exit 0
      ;;
    *)
      PACKAGES+=("$1")
      shift
      ;;
  esac
done

# Default packages if none specified
if [ ${#PACKAGES[@]} -eq 0 ]; then
  PACKAGES=(bash zsh git vscode npm yarn)
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    🛡️  Safe Stow - Dotfiles Manager                      ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

if [ "$DRY_RUN" = true ]; then
  log_warning "DRY RUN MODE - No changes will be made"
  echo ""
fi

log_info "Dotfiles directory: $DOTFILES_DIR"
log_info "Packages to stow: ${PACKAGES[*]}"
echo ""

# Validate dotfiles directory
if [ ! -d "$DOTFILES_DIR" ]; then
  log_error "Dotfiles directory not found: $DOTFILES_DIR"
  exit 1
fi

cd "$DOTFILES_DIR"

# Step 1: Backup existing files (unless skipped)
if [ "$SKIP_BACKUP" = false ]; then
  log_info "Step 1: Backing up existing files..."
  echo ""
  
  if [ "$DRY_RUN" = true ]; then
    "$SCRIPT_DIR/backup-dotfiles.sh" --dry-run "${PACKAGES[@]}"
  else
    "$SCRIPT_DIR/backup-dotfiles.sh" "${PACKAGES[@]}"
  fi
  
  BACKUP_EXIT_CODE=$?
  if [ $BACKUP_EXIT_CODE -ne 0 ]; then
    log_error "Backup failed with exit code: $BACKUP_EXIT_CODE"
    exit 1
  fi
else
  log_warning "Skipping backup (--no-backup flag)"
  echo ""
fi

# Step 2: Run stow
echo ""
log_info "Step 2: Stowing dotfiles..."
echo ""

STOW_FLAGS=""
if [ "$RESTOW" = true ]; then
  STOW_FLAGS="-R"  # Restow: remove then stow
fi

if [ "$DRY_RUN" = true ]; then
  STOW_FLAGS="$STOW_FLAGS -n"  # Dry run
fi

STOW_SUCCESS=true
for package in "${PACKAGES[@]}"; do
  if [ ! -d "$package" ]; then
    log_warning "  Package not found: $package (skipping)"
    continue
  fi
  
  log_info "  Stowing: $package"
  
  # Run stow and capture output
  if stow $STOW_FLAGS -v "$package" 2>&1 | grep -v "BUG in find_stowed_path"; then
    log_success "  ✓ Stowed: $package"
  else
    if [ "$FORCE" = true ]; then
      log_warning "  ⚠ Conflicts detected, trying with --adopt..."
      if stow --adopt $STOW_FLAGS "$package" 2>&1 | grep -v "BUG in find_stowed_path"; then
        log_success "  ✓ Adopted and stowed: $package"
      else
        log_error "  ✗ Failed to stow: $package"
        STOW_SUCCESS=false
      fi
    else
      log_error "  ✗ Failed to stow: $package (use --force to override)"
      STOW_SUCCESS=false
    fi
  fi
done

# Summary
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                           📊 Summary                                     ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

if [ "$DRY_RUN" = true ]; then
  log_info "This was a dry run - no changes were made"
  echo ""
  echo "Run without --dry-run to apply changes"
else
  if [ "$STOW_SUCCESS" = true ]; then
    log_success "All packages stowed successfully!"
    echo ""
    echo "✅ Your dotfiles are now active"
    echo ""
    echo "🔄 To reload your shell:"
    echo "   exec bash -l    # For bash"
    echo "   exec zsh        # For zsh"
    echo ""
    echo "📋 To see all backups:"
    echo "   ./scripts/restore-dotfiles.sh --list"
    echo ""
    echo "🔙 To restore from backup:"
    echo "   ./scripts/restore-dotfiles.sh <session-name>"
  else
    log_error "Some packages failed to stow"
    echo ""
    echo "💡 Troubleshooting:"
    echo "   1. Check for conflicts: stow -n -v <package>"
    echo "   2. Use --force to adopt conflicting files"
    echo "   3. Manually resolve conflicts and try again"
    echo ""
    echo "🔙 To restore from backup:"
    echo "   ./scripts/restore-dotfiles.sh --list"
  fi
fi

echo ""

