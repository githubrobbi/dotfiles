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

## 🎨 Recommended iTerm2 Settings

### **Profiles → Colors**
- **Color Presets:** Solarized Dark, Dracula, or Nord
- Download more: [iTerm2 Color Schemes](https://iterm2colorschemes.com/)

### **Profiles → Window**
- **Transparency:** 10-15%
- **Blur:** 10-20
- **Columns:** 120-140
- **Rows:** 35-40

### **Profiles → Terminal**
- **Scrollback lines:** 10000 (or unlimited)
- ✅ **Unlimited scrollback**

### **Profiles → Keys**
- **Left Option key:** Esc+
- **Right Option key:** Normal (for special characters)

### **General → Preferences**
- ✅ **Load preferences from a custom folder or URL:**
  - Set to: `~/.config/iterm2`
  - ✅ **Save changes to folder when iTerm2 quits**

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

