#!/bin/bash
# Heartbeat Check — Does useful work on a timer
# Run via cron or manually
# Usage: bash tools/heartbeat_check.sh

cd /data/workspace

echo "=== Axton Heartbeat $(date '+%Y-%m-%d %H:%M') ==="

# 1. Git sync — pull latest from GitHub
echo ""
echo "[1] Syncing with GitHub..."
git pull origin main 2>&1 || echo "Git pull failed (ok if no remote)"

# 2. Check AUTONOMOUS.md for stale tasks
echo ""
echo "[2] Checking for stale tasks..."
# Tasks older than 3 days without completion = flag
grep -n "This Week" AUTONOMOUS.md | tail -1

# 3. Check contacts for follow-ups due today
echo ""
echo "[3] Follow-ups due today:"
TODAY=$(date "+%Y-%m-%d")
grep -i "next action.*$TODAY\|follow up.*$TODAY" contacts/CONTEXT.md || echo "None due today"

# 4. Check memory directory
echo ""
echo "[4] Memory status..."
ls -la memory/ 2>/dev/null | tail -3

# 5. Log this heartbeat
echo ""
echo "[5] Heartbeat logged"
echo "$(date '+%Y-%m-%d %H:%M') - heartbeat OK" >> memory/heartbeats.md 2>/dev/null || echo "No heartbeats file yet"

echo ""
echo "=== Done ==="
