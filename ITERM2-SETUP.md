# iTerm2 Setup Guide

## 🎯 The Problem

Your iTerm2 is using **Monaco 12** font, which doesn't support the Powerline/Nerd Font icons needed for Powerlevel10k theme.

## ✅ The Solution

### 1. Configure iTerm2 Font (Manual - One Time)

**Open iTerm2 → Preferences (⌘,)**

#### **Profiles → Text → Font**
1. Click "Change Font" button
2. Select one of these Nerd Fonts:
   - **MesloLGS NF** (Recommended by p10k)
   - **FiraCode Nerd Font**
   - **JetBrains Mono Nerd Font**
   - **Hack Nerd Font**

3. Set size: **13** or **14**
4. ✅ Enable: **Use ligatures** (for FiraCode)
5. ✅ Enable: **Anti-aliased**

#### **Profiles → Text → Non-ASCII Font**
- ✅ **Uncheck** "Use a different font for non-ASCII text"
  (Let the Nerd Font handle everything)

### 2. Verify Nerd Fonts Are Installed

```bash
# Check installed Nerd Fonts
ls ~/Library/Fonts/ | grep -i nerd

# Should show:
# FiraCodeNerdFont-*.ttf
# HackNerdFont-*.ttf
# JetBrainsMonoNerdFont-*.ttf
# MesloLGSNerdFont-*.ttf
```

### 3. Run Powerlevel10k Configuration

```bash
# Restart your shell
exec zsh

# If p10k doesn't auto-configure, run:
p10k configure
```

This will:
- Test if your font supports icons
- Let you choose your preferred style
- Generate/update `~/.p10k.zsh`

### 4. Test Icons

Run this in your terminal:
```bash
echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
```

You should see: ` ±  ➦ ✘ ⚡ ⚙`

If you see boxes or question marks, the font isn't configured correctly.

## 🎨 Recommended iTerm2 Settings (Optimized for Heavy Development)

### **Profiles → Terminal**
- ✅ **Unlimited scrollback** (CRITICAL for long Maven/Gradle builds, Rust compilation)
- **Scrollback lines:** 0 (unlimited)
- ✅ **Scrollback in alternate screen** (see output in less/vim)
- **Character encoding:** UTF-8
- **Report terminal type:** xterm-256color

**Why unlimited scrollback?**
- Maven builds with `-X` debug flag produce 10,000+ lines
- Gradle builds with `--info` or `--debug` produce massive output
- Rust compilation errors with full backtraces
- Docker/Podman logs from Spend Management PostgreSQL
- TTAPI request/response logs
- You need to scroll back to find the FIRST error, not just the last one

### **Profiles → Window**
- **Transparency:** 5-10% (subtle, not distracting)
- **Blur:** 5-10
- **Columns:** 140-160 (wider for split panes)
- **Rows:** 40-50 (taller for long output)
- **Style:** Normal (or Full Screen for focus)

**Why larger window?**
- Side-by-side: Code editor + terminal
- Split panes: Build output + logs + interactive shell
- Long Java stack traces need width
- Rust error messages are verbose

### **Profiles → Keys**
- **Left Option key:** Esc+ (for Alt-based shortcuts)
- **Right Option key:** Normal (for special characters like €, ©, etc.)
- ✅ **Natural Text Editing** (⌘← goes to start of line, ⌘→ to end)

### **Profiles → Colors**
- **Color Presets:** Solarized Dark, Dracula, Nord, or Catppuccin
- Download more: [iTerm2 Color Schemes](https://iterm2colorschemes.com/)
- **Minimum contrast:** 0.5 (readable but not harsh)
- **Cursor boost:** 0.3 (easier to find cursor)

### **Profiles → Text**
- **Font:** MesloLGS NF Regular 13-14 (Nerd Font for icons)
- ✅ **Anti-aliased** (smoother text)
- ✅ **Use ligatures** (if using FiraCode - makes code prettier)
- ✅ **Use thin strokes** (better on Retina displays)
- ❌ **Use different font for non-ASCII** (let Nerd Font handle everything)

### **Profiles → Session**
- ✅ **Automatically log session input to files** (optional - for debugging)
- **Log directory:** `~/.local/state/iterm2/logs`
- ❌ **Prompt before closing** (disabled for speed)

### **Advanced → Performance**
- ✅ **Redraw on key down** (faster response)
- ❌ **Use low-fi for ASCII input** (disabled - we want full quality)
- ✅ **GPU rendering** (smoother scrolling)

### **General → Preferences**
- ✅ **Load preferences from a custom folder or URL:**
  - Set to: `~/.config/iterm2`
  - ✅ **Save changes to folder when iTerm2 quits**
  - This syncs your iTerm2 config via dotfiles!

### **General → Selection**
- ✅ **Copy to pasteboard on selection** (optional - auto-copy selected text)
- ✅ **Applications in terminal may access clipboard** (for tmux/vim)
- ✅ **Triple-click selects full wrapped lines** (better for long output)
- ✅ **Trim whitespace when copying** (cleaner code snippets)

### **General → Window**
- ✅ **Adjust window when changing font size** (⌘+ / ⌘-)
- ✅ **Zoom maximizes vertically only** (better for terminals)
- ❌ **Native full screen windows** (disabled - faster switching)

### **Keys → Hotkey**
- ✅ **Create a dedicated hotkey window** (optional)
  - Hotkey: ⌥Space (Option+Space)
  - **Pin hotkey window** (always on top)
  - **Animate showing and hiding** (smooth transition)
  - Perfect for quick commands while coding!

## 🚀 iTerm2 for Your Development Workflows

### **Rust Development (TTAPI)**
- **Unlimited scrollback** - Rust compiler errors are VERBOSE
- **Wide window (140+ cols)** - Error messages span multiple lines
- **Split panes** - `cargo watch` in one pane, tests in another
- **Hotkey window** - Quick `cargo check` while coding

**Example workflow:**
```bash
# Pane 1: Watch for changes
cargo watch -x check -x test

# Pane 2: Interactive development
cargo run

# Pane 3: Logs
tail -f logs/ttapi.log
```

### **Java/Kotlin Development (Spend Management)**
- **HUGE scrollback** - Maven builds with `-X` produce 50,000+ lines
- **Tall window (40+ rows)** - Java stack traces are LONG
- **Session logging** - Save build output for debugging
- **Command-click URLs** - Click on file paths in stack traces

**Example workflow:**
```bash
# Pane 1: Database
spend_db_start

# Pane 2: Application
spend_run

# Pane 3: Health checks & testing
spend_health
curl -k https://localhost:8443/api/endpoint

# Pane 4: Logs
tail -f logs/spend-mgmt.log
```

### **Git Workflows**
- **Wide window** - See full commit messages and diffs
- **Unlimited scrollback** - Review entire git log
- **Copy/paste optimized** - Copy commit hashes, branch names

**Example workflow:**
```bash
# Pane 1: Interactive rebase
git rebase -i HEAD~10

# Pane 2: Status & diff
git status
git diff

# Pane 3: Log
git log --oneline --graph --all
```

### **Split Pane Layouts**

**Layout 1: Development (3 panes)**
```
┌─────────────────────────────────────┐
│  Build/Watch (cargo watch, mvn)     │
├─────────────────────────────────────┤
│  Interactive Shell  │  Logs/Output  │
└─────────────────────────────────────┘
```

**Layout 2: Full Stack (4 panes)**
```
┌──────────────────┬──────────────────┐
│  Database        │  Application     │
├──────────────────┼──────────────────┤
│  Tests/API       │  Logs            │
└──────────────────┴──────────────────┘
```

**Keyboard shortcuts:**
- ⌘D - Split vertically
- ⌘⇧D - Split horizontally
- ⌘[ / ⌘] - Switch panes
- ⌘⌥Arrow - Navigate panes
- ⌘⇧Enter - Maximize current pane

## 🔧 Advanced: Export/Import Profile

### Export Current Profile
```bash
# In iTerm2: Profiles → Other Actions → Save Profile as JSON
# Save to: ~/dotfiles/iterm2/profile.json
```

### Import Profile
```bash
# In iTerm2: Profiles → Other Actions → Import JSON Profiles
# Select: ~/dotfiles/iterm2/profile.json
```

## 🚀 Quick Fix (Right Now)

1. **⌘,** (Open Preferences)
2. **Profiles → Text → Font → Change Font**
3. Select: **MesloLGS NF Regular 13**
4. Close Preferences
5. **⌘Q** (Quit iTerm2)
6. Reopen iTerm2
7. Run: `exec zsh`

You should now see the Powerlevel10k theme with icons! 🎉

## 📋 Checklist

- [ ] Nerd Fonts installed (4 fonts via brew)
- [ ] iTerm2 font set to a Nerd Font
- [ ] Non-ASCII font option disabled
- [ ] `.p10k.zsh` symlinked to home directory
- [ ] Powerlevel10k theme loaded in `.zshrc`
- [ ] Icons display correctly

## 🐛 Troubleshooting

### Icons show as boxes/question marks
- Font not set to a Nerd Font
- Non-ASCII font is overriding
- Font cache needs refresh (restart iTerm2)

### Theme not loading
```bash
# Check if p10k is sourced
grep -n "powerlevel10k" ~/.zshrc

# Should show line 241:
# source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
```

### `.p10k.zsh` not found
```bash
# Check symlink
ls -la ~/.p10k.zsh

# Should point to: dotfiles/zsh/.p10k.zsh
# If not, re-stow:
cd ~/dotfiles && stow -R zsh
```

## 🎓 The iTerm2 Master Way

1. **Always use Nerd Fonts** - They include all Powerline glyphs + 1000s of icons
2. **Disable Non-ASCII font** - Let one font handle everything
3. **Use ligatures** - Makes code more readable (especially with FiraCode)
4. **Save preferences to dotfiles** - Sync across machines
5. **Use profiles** - Different profiles for different tasks
6. **Learn keyboard shortcuts** - ⌘D (split vertical), ⌘⇧D (split horizontal)

## 📚 Resources

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [iTerm2 Documentation](https://iterm2.com/documentation.html)
- [iTerm2 Color Schemes](https://iterm2colorschemes.com/)

