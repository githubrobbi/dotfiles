# Bash Setup Guide - World-Class Configuration

## 🎯 The Problem

Your bash configuration was minimal and outdated. Let's transform it into a **world-class, modern bash environment** with cutting-edge features, performance optimizations, and ergonomic workflows.

## ✅ The Solution

### Quick Setup

```bash
# Stow bash configuration
cd ~/dotfiles
stow -R bash

# Reload bash
exec bash -l
```

**What you get:**
- ✅ **300+ lines** of world-class .bashrc
- ✅ **Modular configuration** (aliases, functions, work-specific)
- ✅ **Modern CLI tools** integration (fzf, eza, bat, zoxide, ripgrep)
- ✅ **XDG Base Directory** compliance
- ✅ **Smart history** (50K lines, deduplication, timestamps)
- ✅ **Readline enhancements** (.inputrc with 100+ improvements)
- ✅ **Performance optimized** (lazy loading, guarded sourcing)

## 📁 File Structure

```
bash/
├── .bashrc                    # Main configuration (300+ lines)
├── .bash_profile              # Login shell setup
├── .inputrc                   # Readline configuration
└── .config/
    └── bash/
        ├── aliases.bash       # Modern aliases
        ├── functions.bash     # Utility functions
        └── work.bash          # Work-specific (TTAPI, Intuit)
```

**How it works with Stow:**
- Files in `~/dotfiles/bash/` are symlinked to `~/`
- Changes in bash are automatically reflected in your dotfiles repo
- Sync across machines by committing to git

## 🚀 Key Features

### **1. Smart History (50,000 Lines!)**

```bash
# Old: 500 lines, duplicates, no timestamps
HISTSIZE=500

# New: 50,000 lines, deduplication, timestamps
HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T '
HISTIGNORE='ls:ll:la:cd:pwd:exit:clear:history'
```

**Benefits:**
- Never lose command history
- Search through months of commands
- Timestamps show when you ran commands
- No duplicates cluttering history

### **2. Intelligent History Search**

Press `↑` (Up Arrow) and it searches history based on what you've typed!

```bash
# Type: git
# Press ↑ → Shows: git commit -m "fix bug"
# Press ↑ → Shows: git push origin main
# Press ↑ → Shows: git status
```

**Configured in .inputrc:**
```bash
"\e[A": history-search-backward  # Up arrow
"\e[B": history-search-forward   # Down arrow
```

### **3. Modern CLI Tools Integration**

#### **fzf - Fuzzy Finder**
```bash
# Ctrl+R - Fuzzy search history
# Ctrl+T - Fuzzy find files
# Alt+C - Fuzzy cd to directory

# Catppuccin Mocha theme
export FZF_DEFAULT_OPTS='--color=bg+:#313244,bg:#1e1e2e...'
```

#### **eza - Better ls**
```bash
ls    # Icons, colors, git status
ll    # Long format with git info
la    # Show hidden files
lt    # Tree view (2 levels)
tree  # Full tree view
```

#### **bat - Better cat**
```bash
cat file.txt     # Syntax highlighting, line numbers
less file.txt    # Pager with syntax highlighting
man bash         # Colored man pages!
```

#### **zoxide - Smarter cd**
```bash
z ttapi          # Jump to ~/Github/ttapi
z dot            # Jump to ~/dotfiles
z -              # Go back
```

#### **ripgrep - Better grep**
```bash
rg "pattern"     # Fast, smart search
rg "TODO"        # Find all TODOs
rg -i "error"    # Case-insensitive
```

### **4. XDG Base Directory Compliance**

```bash
# Old: Cluttered home directory
~/.bash_history
~/.lesshst
~/.cache/

# New: Clean, organized
~/.local/state/bash/history
~/.local/state/less/history
~/.cache/
```

### **5. Bash 4+ Features**

```bash
# autocd - Type directory name to cd
~/Github/ttapi  # Instead of: cd ~/Github/ttapi

# globstar - Recursive globs
ls **/*.rs      # Find all .rs files recursively

# cdspell - Autocorrect typos
cd ~/Gihub/ttapi  # Autocorrects to ~/Github/ttapi
```

### **6. Smart PATH Management**

```bash
# Deduplicated, ordered PATH
path_prepend() {
  [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

# Priority order:
# 1. ~/.local/bin (user binaries)
# 2. ~/bin (personal scripts)
# 3. ~/.cargo/bin (Rust tools)
# 4. Homebrew
# 5. System paths
```

### **7. Lazy Loading (Performance)**

```bash
# NVM - Only load when needed
nvm() {
  unset -f nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Saves ~500ms on shell startup!
```

### **8. Starship Prompt (Optional)**

If `starship` is installed, you get a beautiful, fast prompt:

```bash
# Install starship
brew install starship

# Reload bash
exec bash -l
```

**Fallback:** Simple but informative Git-aware prompt

```
user@host:~/Github/ttapi (main) $
```

## ⌨️ Readline Enhancements (.inputrc)

### **History Search**
- `↑` / `↓` - Search history based on current input
- `Ctrl+P` / `Ctrl+N` - Alternative history search
- `Ctrl+R` - Reverse search (with fzf if installed)

### **Word Navigation**
- `Ctrl+→` / `Ctrl+←` - Move by word
- `Alt+→` / `Alt+←` - Alternative word movement

### **Line Navigation**
- `Ctrl+A` - Beginning of line
- `Ctrl+E` - End of line
- `Home` / `End` - Beginning/End of line

### **Deletion**
- `Ctrl+W` - Delete word backward
- `Ctrl+K` - Delete to end of line
- `Ctrl+U` - Delete to beginning of line
- `Delete` - Delete character forward

### **Completion**
- `Tab` - Cycle through completions
- `Shift+Tab` - Cycle backward
- Case-insensitive completion
- Colored completion (file types)
- Show all completions immediately

## 📦 Modular Configuration

### **aliases.bash** (200+ lines)

```bash
# Navigation
..    # cd ..
...   # cd ../..

# Git shortcuts
g     # git
gst   # git status
gco   # git checkout
gcm   # git commit -m

# Modern tools
cat   # bat (syntax highlighting)
ls    # eza (icons, colors)
grep  # ripgrep (fast search)

# Docker
d     # docker
dc    # docker-compose
dps   # docker ps

# Kubernetes
k     # kubectl
kgp   # kubectl get pods
```

### **functions.bash** (300+ lines)

```bash
mkcd <dir>           # Create directory and cd into it
up <n>               # Go up N directories
extract <file>       # Extract any archive
ff <pattern>         # Find file by name
gcl <url>            # Git clone and cd
serve [port]         # Start HTTP server
dclean               # Docker cleanup
myip                 # Get public IP
note [text]          # Quick note taking
weather [location]   # Get weather
cheat <command>      # Get cheat sheet
genpass [length]     # Generate password
```

### **work.bash**

```bash
# Project shortcuts
ttapi              # cd ~/Github/ttapi
dotfiles           # cd ~/dotfiles

# TTAPI workflows
ttwatch            # cargo watch -x check -x test
ttstart            # Start TTAPI dev environment
ttclean            # Clean build artifacts
ttupdate           # Update dependencies
```

## 📊 Comparison: Before vs After

| Feature | Before | After |
|---------|--------|-------|
| **Lines of config** | 11 | 300+ |
| **History size** | 500 | 50,000 |
| **History search** | Basic | Intelligent (↑/↓) |
| **Completion** | Basic | Smart, colored, case-insensitive |
| **Modern tools** | None | fzf, eza, bat, zoxide, rg |
| **Modular** | No | Yes (aliases, functions, work) |
| **XDG compliant** | No | Yes |
| **Lazy loading** | No | Yes (NVM, SDKMAN) |
| **Readline config** | None | 100+ enhancements |
| **Git prompt** | No | Yes (with Starship or fallback) |
| **Performance** | Slow | Fast (lazy loading) |
| **Documentation** | None | Comprehensive |

## 🚀 Workflows

### **Development Workflow**

```bash
# Navigate to project
z ttapi              # Jump with zoxide

# Start development
ttstart              # Opens VSCode, starts cargo watch

# Search code
rg "TODO"            # Find all TODOs
rg -i "error"        # Case-insensitive search

# Git workflow
gst                  # git status
ga .                 # git add .
gcm "fix bug"        # git commit -m "fix bug"
gp                   # git push
```

### **File Management**

```bash
# Create and enter directory
mkcd new-project

# Find files
ff "*.rs"            # Find all Rust files
fd_dir "src"         # Find directories named src

# Extract archives
extract file.tar.gz

# Backup file
backup important.txt  # Creates important.txt.backup-20251119-162500
```

### **Docker Workflow**

```bash
# List containers
dps                  # docker ps

# Shell into container
dsh container_name   # docker exec -it container_name /bin/bash

# Cleanup
dclean               # Remove stopped containers, dangling images, etc.
```

### **System Administration**

```bash
# Find process
psgrep nginx         # Find nginx processes

# Kill process
killp nginx          # Kill nginx processes

# Disk usage
duh                  # Disk usage with dust (or du)
largest 10           # Find 10 largest files

# System info
sysinfo              # Show system information
```

## 🎨 Customization

### **Change Prompt**

Install Starship for a beautiful prompt:
```bash
brew install starship
exec bash -l
```

Or customize the fallback prompt in `.bashrc`:
```bash
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
```

### **Add Personal Aliases**

Create `~/.bashrc.local`:
```bash
# Personal aliases
alias myproject='cd ~/projects/myproject'

# Personal environment variables
export MY_VAR="value"
```

### **Disable Specific Features**

Comment out in `.bashrc`:
```bash
# Don't want bat to replace cat?
# Comment out in aliases.bash:
# alias cat='bat --paging=never'
```

## 🐛 Troubleshooting

### **History not working?**

```bash
# Check history file location
echo $HISTFILE
# Should be: ~/.local/state/bash/history

# Create directory if missing
mkdir -p ~/.local/state/bash
```

### **Modern tools not working?**

```bash
# Check if tools are installed
command -v fzf bat eza fd rg zoxide

# Install missing tools
brew install fzf bat eza fd ripgrep zoxide
```

### **Completion not working?**

```bash
# Check bash version (need 4+)
bash --version

# Install bash 5 via Homebrew
brew install bash

# Add to /etc/shells
echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells

# Change default shell
chsh -s /opt/homebrew/bin/bash
```

### **Readline features not working?**

```bash
# Check .inputrc is symlinked
ls -la ~/.inputrc

# Should point to: ~/dotfiles/bash/.inputrc

# Re-stow if needed
cd ~/dotfiles && stow -R bash
```

### **Want to revert?**

```bash
cd ~/dotfiles
mv bash/.bashrc bash/.bashrc.new
mv bash/.bashrc.old bash/.bashrc
exec bash -l
```

## 🎓 The Bash Master Way

1. **Use Bash 5+** - Modern features (autocd, globstar, etc.)
2. **Learn history search** - `↑` to search history (game changer!)
3. **Use modern tools** - eza, bat, fzf, zoxide, ripgrep
4. **Learn functions** - mkcd, extract, gcl, serve
5. **Customize locally** - Use ~/.bashrc.local for personal tweaks
6. **Keep it modular** - Separate aliases, functions, work configs
7. **Sync via dotfiles** - Same config on all machines

## 📚 Resources

- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Readline Manual](https://tiswww.case.edu/php/chet/readline/rluserman.html)
- [Starship Prompt](https://starship.rs/)
- [fzf](https://github.com/junegunn/fzf)
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [ripgrep](https://github.com/BurntSushi/ripgrep)

---

**This is the Bash Master Way!** 🎯

