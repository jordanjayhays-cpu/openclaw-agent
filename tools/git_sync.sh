#!/bin/bash
# Git Sync — Pull latest from openclaw-agent
# Usage: bash tools/git_sync.sh

cd /data/workspace

echo "=== Pulling from GitHub ==="
git pull origin main 2>&1

echo ""
echo "=== Files updated ==="
git diff --name-only HEAD 2>/dev/null || echo "No changes"

echo ""
echo "=== Git Status ==="
git status --short
