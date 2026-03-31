#!/bin/bash
# Auto-Save — Commits all workspace changes to git
# Run this after significant changes, or before shutdown
# Usage: bash tools/auto_save.sh

cd /data/workspace

# Check if there are changes to commit
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to save"
    exit 0
fi

# Commit with timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
git add -A
git commit -m "Auto-save: $TIMESTAMP"

# Try to push (will fail without auth, that's ok - commits still local)
git push origin master 2>&1 || echo "Push failed (auth needed) - commit saved locally"

echo "=== Saved at $TIMESTAMP ==="
git log --oneline -3
