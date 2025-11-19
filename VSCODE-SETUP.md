# VSCode Setup Guide - World-Class Configuration

## 🎯 The Problem

Your VSCode is using default settings with minimal configuration. Let's transform it into a **world-class development environment** optimized for Rust, JavaScript/TypeScript, Python, Java/Kotlin, and more.

## ✅ The Solution

### 1. Automated Setup (Recommended)

```bash
# Run the configuration script
cd ~/dotfiles
./scripts/configure-vscode.sh
```

**What the script does:**
1. ✅ Checks if VSCode CLI is available
2. ✅ Symlinks configuration files via GNU Stow
3. ✅ Installs 30+ essential extensions
4. ✅ Configures theme (Catppuccin Mocha)
5. ✅ Sets up keybindings
6. ✅ Configures language-specific settings

### 2. Manual Setup

```bash
cd ~/dotfiles

# Symlink VSCode config
stow -R vscode

# Install extensions manually
code --install-extension catppuccin.catppuccin-vsc
code --install-extension rust-lang.rust-analyzer
# ... (see extensions.json for full list)
```

## 📁 File Structure

```
vscode/
└── Library/
    └── Application Support/
        └── Code/
            └── User/
                ├── settings.json          # Main settings (485 lines!)
                ├── keybindings.json       # Custom keybindings
                ├── extensions.json        # Recommended extensions
                └── snippets/
                    └── rust.json          # Rust snippets
```

**How it works with Stow:**
- Files in `~/dotfiles/vscode/Library/...` are symlinked to `~/Library/...`
- Changes in VSCode are automatically reflected in your dotfiles repo
- Sync across machines by committing to git

## 🎨 Theme & Appearance

### **Catppuccin Mocha Theme**
- **Why?** Modern, easy on the eyes, excellent syntax highlighting
- **Matches:** Your iTerm2 theme (consistent experience)
- **Alternatives:** Dracula, Nord, One Dark Pro

### **Font Configuration**
```json
"editor.fontFamily": "'MesloLGS NF', 'JetBrains Mono', 'Fira Code'",
"editor.fontSize": 14,
"editor.fontLigatures": true,
"editor.lineHeight": 1.6,
"editor.letterSpacing": 0.5
```

**Why MesloLGS NF?**
- Same font as iTerm2 (consistency!)
- Supports Nerd Font icons
- Excellent ligatures for code

### **Terminal Integration**
```json
"terminal.integrated.fontFamily": "'MesloLGS NF'",
"terminal.integrated.fontSize": 13,
"terminal.integrated.shell.osx": "/bin/zsh",
"terminal.integrated.scrollback": 10000
```

## 🚀 Key Features

### **1. Format on Save (All Languages)**
```json
"editor.formatOnSave": true,
"editor.formatOnPaste": true,
"editor.codeActionsOnSave": {
  "source.fixAll": "explicit",
  "source.organizeImports": "explicit"
}
```

**What this does:**
- Auto-formats code when you save (Ctrl+S)
- Organizes imports automatically
- Fixes linting issues automatically
- Removes trailing whitespace

### **2. Smart File Management**
```json
"files.autoSave": "onFocusChange",
"files.trimTrailingWhitespace": true,
"files.trimFinalNewlines": true,
"files.insertFinalNewline": true
```

**Benefits:**
- Never lose work (auto-save when switching files)
- Clean commits (no trailing whitespace)
- Consistent line endings (LF, not CRLF)

### **3. Git Integration**
```json
"git.autofetch": true,
"git.enableCommitSigning": true,
"git.rebaseWhenSync": true,
"git.pruneOnFetch": true
```

**Features:**
- Auto-fetch from remote every 3 minutes
- SSH commit signing (matches your .gitconfig!)
- Always rebase (clean history)
- Auto-prune deleted branches

### **4. Intelligent Code Completion**
```json
"editor.inlineSuggest.enabled": true,
"editor.suggestSelection": "first",
"editor.snippetSuggestions": "top",
"editor.tabCompletion": "on"
```

**Features:**
- Inline suggestions (like GitHub Copilot)
- Snippets appear first
- Tab to accept suggestions
- Smart auto-imports

### **5. Multi-Cursor & Selection**
```json
"editor.multiCursorModifier": "ctrlCmd",
"editor.find.seedSearchStringFromSelection": "selection",
"editor.linkedEditing": true
```

**Shortcuts:**
- `Cmd+D` - Select next occurrence
- `Cmd+Shift+L` - Select all occurrences
- `Cmd+Alt+Up/Down` - Add cursor above/below
- Auto-rename matching HTML/JSX tags

### **6. Bracket Pair Colorization**
```json
"editor.bracketPairColorization.enabled": true,
"editor.guides.bracketPairs": "active",
"editor.guides.indentation": true
```

**Benefits:**
- Color-coded brackets (easier to match)
- Indent guides (see code structure)
- Active bracket pair highlighting

### **7. File Nesting**
```json
"explorer.fileNesting.enabled": true,
"explorer.fileNesting.patterns": {
  "*.ts": "${capture}.js, ${capture}.d.ts, ${capture}.js.map",
  "package.json": "package-lock.json, yarn.lock, pnpm-lock.yaml",
  "Cargo.toml": "Cargo.lock"
}
```

**Result:**
```
📁 src/
  📄 main.ts
    ├─ main.js
    ├─ main.d.ts
    └─ main.js.map
  📄 package.json
    ├─ package-lock.json
    └─ yarn.lock
```

## 🦀 Rust Development

### **rust-analyzer Configuration**
```json
"rust-analyzer.check.command": "clippy",
"rust-analyzer.check.extraArgs": ["--all-targets"],
"rust-analyzer.inlayHints.enable": true,
"rust-analyzer.lens.run.enable": true
```

**Features:**
- **Clippy** instead of cargo check (better lints)
- **Inlay hints** - See types inline
- **Code lenses** - Run/Debug buttons above functions
- **Auto-imports** - Automatically add `use` statements

### **Rust Extensions**
- `rust-lang.rust-analyzer` - Language server
- `vadimcn.vscode-lldb` - Debugger
- `serayuzgur.crates` - Cargo.toml version management
- `tamasfe.even-better-toml` - TOML syntax highlighting

### **Rust Snippets**
- `println` - `println!("message: {:?}", variable);`
- `dbg` - `dbg!(&variable);`
- `test` - `#[test] fn test_name() { }`
- `amain` - `#[tokio::main] async fn main() { }`
- `struct` - Full struct with derives
- `enum` - Full enum with derives

## 🌐 JavaScript/TypeScript Development

### **Prettier + ESLint**
```json
"[typescript]": {
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true
},
"prettier.singleQuote": true,
"prettier.trailingComma": "es5",
"prettier.printWidth": 100
```

**Extensions:**
- `esbenp.prettier-vscode` - Code formatter
- `dbaeumer.vscode-eslint` - Linter
- `christian-kohler.npm-intellisense` - NPM package autocomplete
- `christian-kohler.path-intellisense` - File path autocomplete

## 🐍 Python Development

### **Black + Flake8**
```json
"[python]": {
  "editor.defaultFormatter": "ms-python.black-formatter",
  "editor.formatOnSave": true,
  "editor.rulers": [88, 120]
},
"python.linting.flake8Enabled": true
```

**Extensions:**
- `ms-python.python` - Python language support
- `ms-python.vscode-pylance` - Fast language server
- `ms-python.black-formatter` - Code formatter
- `ms-python.flake8` - Linter

## ☕ Java/Kotlin Development

### **Red Hat Java + Kotlin**
```json
"[java]": {
  "editor.defaultFormatter": "redhat.java",
  "editor.formatOnSave": true,
  "editor.tabSize": 4
},
"java.configuration.updateBuildConfiguration": "automatic"
```

**Extensions:**
- `redhat.java` - Java language support
- `vscjava.vscode-java-debug` - Debugger
- `vscjava.vscode-maven` - Maven integration
- `fwcd.kotlin` - Kotlin language support

## ⌨️ Keyboard Shortcuts

### **File Navigation**
- `Cmd+P` - Quick open file
- `Cmd+Shift+P` - Command palette
- `Cmd+Shift+F` - Find in files
- `Cmd+Shift+E` - Explorer
- `Cmd+Shift+G` - Source control
- `Cmd+B` - Toggle sidebar
- `Cmd+J` - Toggle panel

### **Editor Navigation**
- `Cmd+1-5` - Switch to editor tab 1-5
- `Ctrl+Tab` - Next editor
- `Ctrl+Shift+Tab` - Previous editor
- `Alt+Cmd+Left/Right` - Navigate back/forward

### **Terminal**
- `Ctrl+\`` - Toggle terminal
- `Ctrl+Shift+\`` - New terminal
- `Cmd+K` - Clear terminal (when focused)

### **Code Editing**
- `Cmd+D` - Select next occurrence
- `Cmd+Shift+L` - Select all occurrences
- `Alt+Up/Down` - Move line up/down
- `Shift+Alt+Up/Down` - Copy line up/down
- `Cmd+Shift+K` - Delete line
- `Cmd+/` - Toggle comment

### **Code Navigation**
- `F12` - Go to definition
- `Cmd+F12` - Go to implementation
- `Shift+F12` - Find all references
- `Alt+F12` - Peek definition
- `F2` - Rename symbol

### **Code Actions**
- `Cmd+.` - Quick fix
- `Shift+Alt+F` - Format document
- `Ctrl+Shift+R` - Refactor

### **Debugging**
- `F5` - Start/Continue debugging
- `Shift+F5` - Stop debugging
- `F9` - Toggle breakpoint
- `F10` - Step over
- `F11` - Step into
- `Shift+F11` - Step out

## 🔌 Essential Extensions (Auto-Installed)

### **Theme & Icons**
- Catppuccin Mocha (theme)
- Catppuccin Icons (file icons)
- Icons Carbon (product icons)

### **Git & Version Control**
- GitLens (supercharged Git)
- Git Graph (visual commit history)
- GitHub Pull Requests

### **Docker & Containers**
- Docker (container management)
- Remote - Containers (dev containers)
- Kubernetes Tools

### **Markdown**
- Markdown All in One
- Markdown Lint
- Markdown Mermaid (diagrams)

### **Code Quality**
- Error Lens (inline errors)
- Code Spell Checker
- EditorConfig
- Better Comments

### **Productivity**
- TODO Tree (find all TODOs)
- Bookmarks (mark important lines)
- Change Case (convert case)

## 📊 Comparison: Before vs After

| Feature | Before | After |
|---------|--------|-------|
| **Settings** | ~50 lines | 485 lines (comprehensive) |
| **Extensions** | 4 | 30+ (curated) |
| **Theme** | Default | Catppuccin Mocha |
| **Font** | Default | MesloLGS NF (Nerd Font) |
| **Format on Save** | No | Yes (all languages) |
| **Auto-imports** | No | Yes |
| **Git Integration** | Basic | Advanced (signing, rebase) |
| **Keybindings** | Default | Optimized |
| **Snippets** | None | Rust, JS, TS, Python |
| **File Nesting** | No | Yes |
| **Bracket Colors** | No | Yes |
| **Inlay Hints** | No | Yes (Rust, TS) |
| **Code Lenses** | No | Yes (Rust) |

## 🚀 Workflows

### **Rust Development (TTAPI)**
1. Open project: `code ~/Github/ttapi`
2. Terminal: `Ctrl+\`` → `cargo watch -x check -x test`
3. Edit code with inlay hints and auto-imports
4. Run tests: Click "Run Test" code lens
5. Debug: Set breakpoint (F9) → F5
6. Commit: `Cmd+Shift+G` → Stage → Commit (SSH signed!)

### **Full Stack Development**
1. Split editor: `Cmd+\` (vertical split)
2. Left: Frontend code (TypeScript/React)
3. Right: Backend code (Rust/Java)
4. Bottom: Terminal (3 splits)
   - Terminal 1: Frontend dev server
   - Terminal 2: Backend server
   - Terminal 3: Interactive shell

### **Git Workflow**
1. View changes: `Cmd+Shift+G`
2. Stage files: Click `+` or `Cmd+Enter`
3. Commit: Type message → `Cmd+Enter`
4. Push: Click `...` → Push
5. View history: GitLens sidebar or Git Graph

## 🔧 Customization

### **Change Theme**
```bash
Cmd+K Cmd+T → Select theme
```

**Recommended themes:**
- Catppuccin Mocha (installed)
- Dracula Official
- Nord
- One Dark Pro

### **Change Font**
Edit `settings.json`:
```json
"editor.fontFamily": "'JetBrains Mono', 'Fira Code', monospace"
```

### **Disable Format on Save**
Edit `settings.json`:
```json
"editor.formatOnSave": false
```

### **Add Custom Snippets**
1. `Cmd+Shift+P` → "Configure User Snippets"
2. Select language
3. Add snippet:
```json
"My Snippet": {
  "prefix": "mysnip",
  "body": ["code here"],
  "description": "My custom snippet"
}
```

## 🐛 Troubleshooting

### **Extensions not installing**
```bash
# Check VSCode CLI
code --version

# Reinstall extension
code --install-extension <extension-id> --force
```

### **Settings not applying**
```bash
# Check symlink
ls -la ~/Library/Application\ Support/Code/User/settings.json

# Should point to: ~/dotfiles/vscode/Library/Application Support/Code/User/settings.json

# Re-stow if needed
cd ~/dotfiles && stow -R vscode
```

### **Rust-analyzer not working**
```bash
# Check rust-analyzer is installed
rustup component add rust-analyzer

# Restart VSCode
Cmd+Q → Reopen
```

### **Format on save not working**
1. Check default formatter is set for the language
2. `Cmd+Shift+P` → "Format Document With..." → Select formatter
3. Check `settings.json` for `[language]` specific settings

## 🎓 The VSCode Master Way

1. **Use Nerd Fonts** - Icons in file explorer, terminal, editor
2. **Format on save** - Never manually format again
3. **Learn keybindings** - 10x faster than mouse
4. **Use snippets** - Type less, code more
5. **Leverage extensions** - Don't reinvent the wheel
6. **Sync via dotfiles** - Same config on all machines
7. **Commit settings** - Version control your editor config

## 📚 Resources

- [VSCode Documentation](https://code.visualstudio.com/docs)
- [VSCode Keybindings](https://code.visualstudio.com/docs/getstarted/keybindings)
- [Catppuccin Theme](https://github.com/catppuccin/vscode)
- [rust-analyzer](https://rust-analyzer.github.io/)
- [Prettier](https://prettier.io/)
- [ESLint](https://eslint.org/)

---

**This is the VSCode Master Way!** 🎯

