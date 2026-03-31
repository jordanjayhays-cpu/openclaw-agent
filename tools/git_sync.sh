#!/bin/bash
# Git Sync — Pull latest from openclaw-agent
# Usage: bash tools/git_sync.sh

cd /data/workspace
git pull origin main 2>&1

echo "--- Files updated ---"
git diff --name-only HEAD
