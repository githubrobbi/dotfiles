#!/usr/bin/env bash
# ============================================================================
# Backup Existing Dotfiles - World-Class Safety
# ============================================================================
# This script backs up existing dotfiles before stowing new ones
# Creates timestamped backups and a manifest for easy restoration
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
BACKUP_DIR="$HOME/.dotfiles-backup"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_SESSION_DIR="$BACKUP_DIR/$TIMESTAMP"
MANIFEST_FILE="$BACKUP_SESSION_DIR/manifest.txt"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [OPTIONS] [PACKAGES...]"
      echo ""
      echo "Backup existing dotfiles before stowing."
      echo ""
      echo "Options:"
      echo "  --dry-run    Show what would be backed up without doing it"
      echo "  --help       Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0                    # Backup all packages"
      echo "  $0 bash zsh           # Backup only bash and zsh"
      echo "  $0 --dry-run          # Preview what would be backed up"
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
echo "║                    🛡️  Dotfiles Backup Utility                           ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

if [ "$DRY_RUN" = true ]; then
  log_warning "DRY RUN MODE - No files will be backed up"
  echo ""
fi

log_info "Backup session: $TIMESTAMP"
log_info "Backup location: $BACKUP_SESSION_DIR"
log_info "Packages to check: ${PACKAGES[*]}"
echo ""

# Create backup directory structure
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$BACKUP_SESSION_DIR"
  echo "# Dotfiles Backup Manifest" > "$MANIFEST_FILE"
  echo "# Created: $(date)" >> "$MANIFEST_FILE"
  echo "# Session: $TIMESTAMP" >> "$MANIFEST_FILE"
  echo "" >> "$MANIFEST_FILE"
fi

BACKED_UP_COUNT=0
SKIPPED_COUNT=0
CONFLICT_COUNT=0

# Function to backup a file
backup_file() {
  local source_file="$1"
  local package="$2"
  
  if [ ! -e "$source_file" ]; then
    return 0  # File doesn't exist, nothing to backup
  fi
  
  # Check if it's already a symlink to our dotfiles
  if [ -L "$source_file" ]; then
    local link_target=$(readlink "$source_file")
    if [[ "$link_target" == *"$DOTFILES_DIR"* ]]; then
      log_info "  ↪ Already symlinked: $source_file"
      ((SKIPPED_COUNT++))
      return 0
    fi
  fi
  
  # This is a real file or external symlink - back it up!
  local relative_path="${source_file#$HOME/}"
  local backup_path="$BACKUP_SESSION_DIR/$package/$relative_path"
  
  if [ "$DRY_RUN" = true ]; then
    log_warning "  [DRY RUN] Would backup: $source_file"
    ((CONFLICT_COUNT++))
  else
    mkdir -p "$(dirname "$backup_path")"
    
    if [ -L "$source_file" ]; then
      # Preserve symlink
      cp -P "$source_file" "$backup_path"
      log_success "  ✓ Backed up symlink: $source_file"
    else
      # Copy file/directory
      cp -R "$source_file" "$backup_path"
      log_success "  ✓ Backed up: $source_file"
    fi
    
    # Add to manifest
    echo "$package|$source_file|$backup_path" >> "$MANIFEST_FILE"
    ((BACKED_UP_COUNT++))
  fi
}

# Function to get files that would be stowed for a package
get_stow_targets() {
  local package="$1"
  local package_dir="$DOTFILES_DIR/$package"
  
  if [ ! -d "$package_dir" ]; then
    return
  fi
  
  # Find all files in the package directory
  find "$package_dir" -type f -o -type l | while read -r file; do
    # Convert package path to home path
    local relative_path="${file#$package_dir/}"
    echo "$HOME/$relative_path"
  done
}

# Process each package
for package in "${PACKAGES[@]}"; do
  log_info "Checking package: $package"
  
  if [ ! -d "$DOTFILES_DIR/$package" ]; then
    log_warning "  Package directory not found: $DOTFILES_DIR/$package"
    continue
  fi
  
  # Get all files that would be stowed
  while IFS= read -r target_file; do
    backup_file "$target_file" "$package"
  done < <(get_stow_targets "$package")
  
  echo ""
done

# Summary
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                         📊 Backup Summary                                ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo "  Files that would be backed up: $CONFLICT_COUNT"
  echo "  Files already symlinked: $SKIPPED_COUNT"
  echo ""
  log_info "Run without --dry-run to perform the backup"
else
  echo "  ✅ Files backed up: $BACKED_UP_COUNT"
  echo "  ↪  Files already symlinked: $SKIPPED_COUNT"
  echo ""
  
  if [ $BACKED_UP_COUNT -gt 0 ]; then
    log_success "Backup complete!"
    echo ""
    echo "📁 Backup location:"
    echo "   $BACKUP_SESSION_DIR"
    echo ""
    echo "📋 Manifest file:"
    echo "   $MANIFEST_FILE"
    echo ""
    echo "🔄 To restore these files later:"
    echo "   ./scripts/restore-dotfiles.sh $TIMESTAMP"
    echo ""
    echo "📚 To list all backups:"
    echo "   ./scripts/restore-dotfiles.sh --list"
  else
    log_info "No files needed backup (all already symlinked)"
  fi
fi

echo ""

