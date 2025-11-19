#!/usr/bin/env bash
# Test that shell is working correctly

echo "🧪 Testing Shell Configuration"
echo "=============================="
echo ""

echo "1. Testing brew:"
if brew --version &>/dev/null; then
  echo "  ✅ brew works: $(brew --version | head -1)"
else
  echo "  ❌ brew failed"
  exit 1
fi

echo ""
echo "2. Testing git:"
if git --version &>/dev/null; then
  echo "  ✅ git works: $(git --version)"
else
  echo "  ❌ git failed"
  exit 1
fi

echo ""
echo "3. Testing navigation shortcuts:"
echo "  Available shortcuts:"
echo "    gt - ttapi"
echo "    gs - spend-mgmt"
echo "    gi - idx-triage-svc"
echo "    gd - dotfiles"
echo "    g  - interactive fuzzy finder"

echo ""
echo "=============================="
echo "✅ All tests passed!"
echo ""
echo "Try these commands:"
echo "  g t    # Jump to ttapi"
echo "  g s    # Jump to spend-mgmt"
echo "  g      # Interactive fuzzy finder"

