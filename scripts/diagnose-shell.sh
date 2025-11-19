#!/usr/bin/env bash
# Diagnose shell issues

echo "🔍 Shell Diagnostics"
echo "===================="
echo ""

echo "1. Basic Commands:"
echo "  which brew: $(/usr/bin/which brew 2>&1)"
echo "  which git: $(/usr/bin/which git 2>&1)"
echo "  which zsh: $(/usr/bin/which zsh 2>&1)"
echo ""

echo "2. PATH:"
echo "  $PATH"
echo ""

echo "3. Brew version:"
/opt/homebrew/bin/brew --version 2>&1 | head -1
echo ""

echo "4. Git version:"
/usr/bin/git --version 2>&1
echo ""

echo "5. Zsh version:"
/bin/zsh --version 2>&1
echo ""

echo "6. Config files:"
echo "  ~/.zshrc -> $(readlink ~/.zshrc 2>&1)"
echo "  ~/.zshenv -> $(readlink ~/.zshenv 2>&1)"
echo "  ~/.zprofile -> $(readlink ~/.zprofile 2>&1)"
echo ""

echo "7. Testing zsh with config:"
/bin/zsh -c 'source ~/.zshrc && echo "  ✅ Config loads successfully" && brew --version | head -1' 2>&1
echo ""

echo "8. Checking for problematic aliases:"
/bin/zsh -c 'source ~/.zshrc && alias | grep -E "^(brew|git|grep|mv|mkdir|rm)="' 2>&1 | head -10
echo ""

echo "===================="
echo "✅ Diagnostics complete"

