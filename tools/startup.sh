#!/bin/bash
# Startup — Pull latest from GitHub, restore state
# Run this on every boot/restart
# Usage: bash tools/startup.sh

cd /data/workspace

echo "=== Axton Startup ==="
echo "Pulling from GitHub..."
git pull origin main 2>&1

echo ""
echo "=== Files restored ==="
git log --oneline -3

echo ""
echo "=== Checking for pending commits ==="
git status --short
