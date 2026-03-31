#!/bin/bash
# Self-Improve — Analyzes recent performance and updates my files
# Run: bash tools/self_improve.sh

cd /data/workspace

echo "=== Axton Self-Improvement Check ==="
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# 1. Check FAILURE_LOG for recent entries needing follow-up
echo "[1] Checking FAILURE_LOG..."
LAST_FAILURE=$(tail -5 FAILURE_LOG.md 2>/dev/null)
if [ -n "$LAST_FAILURE" ]; then
    echo "Recent failures noted:"
    echo "$LAST_FAILURE"
fi

# 2. Check SUCCESS_LOG for patterns
echo ""
echo "[2] Checking SUCCESS_LOG..."
grep -c "^- \*\*" SUCCESS_LOG.md 2>/dev/null || echo "0"

# 3. Count files updated today
echo ""
echo "[3] Files updated today:"
find . -name "*.md" -newer ./.openclaw/workspace-state.json 2>/dev/null | grep -v node_modules | head -10

# 4. Check git commits since last session
echo ""
echo "[4] Recent commits:"
git log --oneline -5 2>/dev/null

# 5. Run heartbeat check
echo ""
echo "[5] Running heartbeat check..."
bash tools/heartbeat_check.sh 2>/dev/null

# 6. Commit any improvements
echo ""
echo "[6] Checking for uncommitted improvements..."
git diff --name-only 2>/dev/null

echo ""
echo "=== Done ==="
