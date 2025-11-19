#!/usr/bin/env bash
# ============================================================================
# Restore Dotfiles from Backup - World-Class Safety
# ============================================================================
# This script restores dotfiles from a previous backup
# Can list all backups, restore specific sessions, or restore individual files
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
BACKUP_DIR="$HOME/.dotfiles-backup"
DRY_RUN=false
LIST_MODE=false
SESSION=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --list|-l)
      LIST_MODE=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [OPTIONS] [SESSION]"
      echo ""
      echo "Restore dotfiles from a previous backup."
      echo ""
      echo "Options:"
      echo "  --list       List all available backup sessions"
      echo "  --dry-run    Show what would be restored without doing it"
      echo "  --help       Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0 --list                    # List all backups"
      echo "  $0 20251119-162500           # Restore specific backup"
      echo "  $0 --dry-run 20251119-162500 # Preview restore"
      exit 0
      ;;
    *)
      SESSION="$1"
      shift
      ;;
  esac
done

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    🔄 Dotfiles Restore Utility                           ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  log_error "No backup directory found at: $BACKUP_DIR"
  echo ""
  echo "Run ./scripts/backup-dotfiles.sh first to create backups"
  exit 1
fi

# List mode
if [ "$LIST_MODE" = true ]; then
  log_info "Available backup sessions:"
  echo ""
  
  if [ ! "$(ls -A $BACKUP_DIR)" ]; then
    log_warning "No backups found"
    exit 0
  fi
  
  # List all backup sessions with details
  for session_dir in "$BACKUP_DIR"/*; do
    if [ -d "$session_dir" ]; then
      session_name=$(basename "$session_dir")
      manifest="$session_dir/manifest.txt"
      
      if [ -f "$manifest" ]; then
        file_count=$(grep -c '^[^#]' "$manifest" || echo "0")
        created=$(grep "^# Created:" "$manifest" | cut -d: -f2- | xargs)
        
        echo "  📦 $session_name"
        echo "     Created: $created"
        echo "     Files: $file_count"
        echo ""
      else
        echo "  📦 $session_name (no manifest)"
        echo ""
      fi
    fi
  done
  
  echo "To restore a backup, run:"
  echo "  ./scripts/restore-dotfiles.sh <session-name>"
  echo ""
  exit 0
fi

# Restore mode - need a session
if [ -z "$SESSION" ]; then
  log_error "No backup session specified"
  echo ""
  echo "Usage: $0 <session-name>"
  echo ""
  echo "To see available backups, run:"
  echo "  $0 --list"
  exit 1
fi

SESSION_DIR="$BACKUP_DIR/$SESSION"
MANIFEST_FILE="$SESSION_DIR/manifest.txt"

# Validate session
if [ ! -d "$SESSION_DIR" ]; then
  log_error "Backup session not found: $SESSION"
  echo ""
  echo "Available sessions:"
  ls -1 "$BACKUP_DIR" 2>/dev/null || echo "  (none)"
  echo ""
  echo "Run '$0 --list' for more details"
  exit 1
fi

if [ ! -f "$MANIFEST_FILE" ]; then
  log_error "Manifest file not found: $MANIFEST_FILE"
  echo ""
  echo "This backup session may be corrupted"
  exit 1
fi

# Show session info
log_info "Restoring from session: $SESSION"
echo ""

if [ "$DRY_RUN" = true ]; then
  log_warning "DRY RUN MODE - No files will be restored"
  echo ""
fi

# Read manifest and restore files
RESTORED_COUNT=0
SKIPPED_COUNT=0

while IFS='|' read -r package source_file backup_path; do
  # Skip comments and empty lines
  [[ "$package" =~ ^#.*$ ]] && continue
  [[ -z "$package" ]] && continue
  
  if [ "$DRY_RUN" = true ]; then
    log_info "  [DRY RUN] Would restore: $source_file"
    ((RESTORED_COUNT++))
  else
    # Check if current file is a symlink to dotfiles
    if [ -L "$source_file" ]; then
      local link_target=$(readlink "$source_file")
      if [[ "$link_target" == *"dotfiles"* ]]; then
        log_warning "  Removing dotfiles symlink: $source_file"
        rm "$source_file"
      fi
    elif [ -e "$source_file" ]; then
      # File exists and is not our symlink - back it up first
      local safety_backup="$source_file.before-restore-$(date +%Y%m%d-%H%M%S)"
      mv "$source_file" "$safety_backup"
      log_warning "  Existing file moved to: $safety_backup"
    fi
    
    # Restore from backup
    if [ -e "$backup_path" ]; then
      mkdir -p "$(dirname "$source_file")"
      cp -R "$backup_path" "$source_file"
      log_success "  ✓ Restored: $source_file"
      ((RESTORED_COUNT++))
    else
      log_error "  ✗ Backup file not found: $backup_path"
      ((SKIPPED_COUNT++))
    fi
  fi
done < "$MANIFEST_FILE"

# Summary
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                        📊 Restore Summary                                ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo "  Files that would be restored: $RESTORED_COUNT"
  echo ""
  log_info "Run without --dry-run to perform the restore"
else
  echo "  ✅ Files restored: $RESTORED_COUNT"
  if [ $SKIPPED_COUNT -gt 0 ]; then
    echo "  ⚠️  Files skipped: $SKIPPED_COUNT"
  fi
  echo ""
  
  if [ $RESTORED_COUNT -gt 0 ]; then
    log_success "Restore complete!"
    echo ""
    log_warning "Your dotfiles symlinks have been removed"
    echo ""
    echo "🔄 To re-apply dotfiles, run:"
    echo "   cd ~/dotfiles && stow -R bash zsh git vscode"
    echo ""
    echo "💡 Or to switch back to dotfiles without restoring:"
    echo "   cd ~/dotfiles && stow -R bash zsh git vscode"
  fi
fi

echo ""

