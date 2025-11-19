# Backup & Restore Guide - World-Class Safety

## 🎯 The Problem

When applying dotfiles, you might:
- **Overwrite existing configurations** you want to keep
- **Lose custom settings** you've built up over time
- **Break your environment** and not know how to revert
- **Fear trying new configs** because rollback is hard

## ✅ The Solution

A **world-class backup and restore system** that:
- ✅ **Automatically backs up** existing files before stowing
- ✅ **Creates timestamped snapshots** you can restore anytime
- ✅ **Tracks what was changed** with a manifest file
- ✅ **Provides easy rollback** with a single command
- ✅ **Supports dry-run mode** to preview changes
- ✅ **Never loses your data** - safety first!

## 🚀 Quick Start

### Safe Stow (Recommended)

```bash
# Stow with automatic backup
cd ~/dotfiles
./scripts/safe-stow.sh

# Stow specific packages
./scripts/safe-stow.sh bash zsh

# Preview what would happen (dry run)
./scripts/safe-stow.sh --dry-run
```

**What it does:**
1. ✅ Backs up existing files to `~/.dotfiles-backup/<timestamp>/`
2. ✅ Creates a manifest of what was backed up
3. ✅ Stows your dotfiles (creates symlinks)
4. ✅ Shows you how to restore if needed

### Manual Backup

```bash
# Backup before making changes
./scripts/backup-dotfiles.sh

# Backup specific packages
./scripts/backup-dotfiles.sh bash zsh

# Preview what would be backed up
./scripts/backup-dotfiles.sh --dry-run
```

### Restore from Backup

```bash
# List all backups
./scripts/restore-dotfiles.sh --list

# Restore a specific backup
./scripts/restore-dotfiles.sh 20251119-162500

# Preview restore (dry run)
./scripts/restore-dotfiles.sh --dry-run 20251119-162500
```

## 📁 How It Works

### Backup Structure

```
~/.dotfiles-backup/
├── 20251119-162500/           # Timestamp: YYYYMMDD-HHMMSS
│   ├── manifest.txt           # What was backed up
│   ├── bash/
│   │   ├── .bashrc
│   │   ├── .bash_profile
│   │   └── .inputrc
│   ├── zsh/
│   │   ├── .zshrc
│   │   └── .zshenv
│   └── git/
│       └── .gitconfig
├── 20251119-143000/           # Another backup session
│   └── ...
└── 20251118-091500/           # Older backup
    └── ...
```

### Manifest File

Each backup session includes a `manifest.txt`:

```
# Dotfiles Backup Manifest
# Created: Tue Nov 19 16:25:00 PST 2025
# Session: 20251119-162500

bash|/Users/you/.bashrc|/Users/you/.dotfiles-backup/20251119-162500/bash/.bashrc
bash|/Users/you/.bash_profile|/Users/you/.dotfiles-backup/20251119-162500/bash/.bash_profile
zsh|/Users/you/.zshrc|/Users/you/.dotfiles-backup/20251119-162500/zsh/.zshrc
```

**Format:** `package|source_file|backup_path`

## 🛡️ Safety Features

### 1. **Smart Detection**

The backup script detects:
- ✅ **Real files** - Backed up
- ✅ **External symlinks** - Backed up
- ✅ **Dotfiles symlinks** - Skipped (already managed)
- ✅ **Non-existent files** - Skipped

```bash
# Example output
ℹ  Checking package: bash
✓  Backed up: /Users/you/.bashrc
↪  Already symlinked: /Users/you/.bash_profile
✓  Backed up symlink: /Users/you/.inputrc
```

### 2. **Dry Run Mode**

Preview changes before making them:

```bash
# Preview backup
./scripts/backup-dotfiles.sh --dry-run

# Preview stow
./scripts/safe-stow.sh --dry-run

# Preview restore
./scripts/restore-dotfiles.sh --dry-run 20251119-162500
```

### 3. **Timestamped Backups**

Every backup gets a unique timestamp:
- Format: `YYYYMMDD-HHMMSS`
- Example: `20251119-162500` = Nov 19, 2025 at 4:25:00 PM
- Never overwrites previous backups
- Easy to identify when backup was created

### 4. **Safety on Restore**

When restoring, the script:
1. Checks if current file is a dotfiles symlink
2. If yes, removes the symlink
3. If no, creates a safety backup: `file.before-restore-<timestamp>`
4. Restores the original file from backup

**You never lose data!**

## 📚 Common Workflows

### Workflow 1: Try New Dotfiles (Safe)

```bash
# 1. Backup current config
cd ~/dotfiles
./scripts/backup-dotfiles.sh

# Output:
# ✓ Files backed up: 12
# 📁 Backup location: ~/.dotfiles-backup/20251119-162500
# 🔄 To restore: ./scripts/restore-dotfiles.sh 20251119-162500

# 2. Apply new dotfiles
./scripts/safe-stow.sh

# 3. Test the new config
exec bash -l

# 4a. If you like it - keep it! (do nothing)

# 4b. If you don't like it - restore
./scripts/restore-dotfiles.sh 20251119-162500
```

### Workflow 2: Update Specific Package

```bash
# Backup and stow just bash
./scripts/safe-stow.sh bash

# Test it
exec bash -l

# Restore if needed
./scripts/restore-dotfiles.sh --list
./scripts/restore-dotfiles.sh <session>
```

### Workflow 3: Clean Install on New Mac

```bash
# Run setup script (uses safe-stow automatically)
./scripts/setup-new-mac.sh

# Backups are created automatically
# Check them with:
./scripts/restore-dotfiles.sh --list
```

### Workflow 4: Experiment Freely

```bash
# Make changes to dotfiles
vim ~/dotfiles/bash/.bashrc

# Test immediately (files are symlinked)
exec bash -l

# Don't like it? Restore from backup
./scripts/restore-dotfiles.sh --list
./scripts/restore-dotfiles.sh <latest-session>

# Or just edit the file again (it's in git!)
cd ~/dotfiles
git diff bash/.bashrc
git checkout bash/.bashrc
```

## 🎯 Advanced Usage

### Force Stow with Conflicts

```bash
# If stow detects conflicts, use --force
./scripts/safe-stow.sh --force bash

# This uses stow's --adopt flag to merge conflicts
```

### Skip Backup (Not Recommended)

```bash
# If you're absolutely sure
./scripts/safe-stow.sh --no-backup bash
```

### Stow Without Restow

```bash
# Don't use -R flag (useful for debugging)
./scripts/safe-stow.sh --no-restow bash
```

### List All Backups with Details

```bash
./scripts/restore-dotfiles.sh --list

# Output:
# 📦 20251119-162500
#    Created: Tue Nov 19 16:25:00 PST 2025
#    Files: 12
#
# 📦 20251119-143000
#    Created: Tue Nov 19 14:30:00 PST 2025
#    Files: 8
```

## 🐛 Troubleshooting

### "Backup session not found"

```bash
# List available sessions
./scripts/restore-dotfiles.sh --list

# Use exact session name
./scripts/restore-dotfiles.sh 20251119-162500
```

### "Stow conflicts detected"

```bash
# Option 1: Use --force to adopt conflicts
./scripts/safe-stow.sh --force bash

# Option 2: Manually resolve
stow -n -v bash  # See what conflicts
rm ~/.bashrc     # Remove conflicting file
./scripts/safe-stow.sh bash
```

### "Want to clean up old backups"

```bash
# Backups are in ~/.dotfiles-backup/
ls -la ~/.dotfiles-backup/

# Remove old backups manually
rm -rf ~/.dotfiles-backup/20251118-*

# Or keep them all (disk space is cheap!)
```

### "Restore failed - backup file not found"

This shouldn't happen, but if it does:
```bash
# Check manifest
cat ~/.dotfiles-backup/<session>/manifest.txt

# Manually copy files
cp -R ~/.dotfiles-backup/<session>/bash/.bashrc ~/
```

## 🎓 The Dotfiles Master Way

1. **Always backup before changes** - Use `safe-stow.sh`
2. **Use dry-run to preview** - See what will happen
3. **Keep backups** - Disk space is cheap, data is precious
4. **Test in new shell** - Don't close your current shell
5. **Commit to git** - Your dotfiles repo is version controlled
6. **Document changes** - Update markdown files
7. **Share knowledge** - Help others with your setup

## 📊 Comparison: Before vs After

| Feature | Manual Stow | Safe Stow |
|---------|-------------|-----------|
| **Backup** | Manual | Automatic |
| **Restore** | Manual | One command |
| **Dry run** | `stow -n` | `--dry-run` |
| **Conflict handling** | Manual | Automatic |
| **Manifest** | None | Yes |
| **Timestamps** | Manual | Automatic |
| **Safety** | ⚠️ Medium | ✅ High |
| **Ease of use** | 😐 OK | 😊 Easy |

## 🔗 Integration

### With setup-new-mac.sh

The main setup script automatically uses `safe-stow.sh`:

```bash
./scripts/setup-new-mac.sh
# Automatically backs up existing files
# Stows all packages safely
# Shows restore command if needed
```

### With Git

Your dotfiles are version controlled:

```bash
# See what changed
git diff

# Revert a file
git checkout bash/.bashrc

# Restore from git history
git log bash/.bashrc
git checkout <commit> bash/.bashrc
```

### With Stow

You can still use stow directly:

```bash
# Manual stow (no backup)
cd ~/dotfiles
stow -R bash

# But safe-stow is recommended!
./scripts/safe-stow.sh bash
```

## 📖 Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
- [Dotfiles Best Practices](https://dotfiles.github.io/)
- [XDG Base Directory Spec](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

---

**Safety First, Experiment Freely!** 🛡️

