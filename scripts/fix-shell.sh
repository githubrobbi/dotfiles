#!/usr/bin/env bash
# Fix shell by removing problematic aliases and starting fresh

echo "🔧 Fixing shell configuration..."
echo ""

# Unalias problematic commands in current shell
echo "Removing problematic aliases from current session..."
unalias mkdir 2>/dev/null && echo "  ✅ Removed mkdir alias"
unalias rm 2>/dev/null && echo "  ✅ Removed rm alias"
unalias mv 2>/dev/null && echo "  ✅ Removed mv alias"
unalias cp 2>/dev/null && echo "  ✅ Removed cp alias"

echo ""
echo "✅ Current session fixed!"
echo ""
echo "Now starting a fresh zsh shell..."
echo "Type 'exit' to return to this shell, or just close the terminal."
echo ""

# Start fresh zsh
exec zsh

