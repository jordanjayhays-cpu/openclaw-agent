#!/bin/bash
# heartbeat.sh — Proactive health check for OpenClaw
# Run via cron: */30 * * * * /data/workspace/tools/heartbeat.sh

WORKSPACE="${WORKSPACE:-/data/workspace}"
LOG="$WORKSPACE/memory/heartbeats/$(date +%Y-%m-%d).md"

mkdir -p "$(dirname "$LOG")"

echo "---" >> "$LOG"
echo "Heartbeat: $(date '+%Y-%m-%d %H:%M UTC')" >> "$LOG"

# Check 1: Is the gateway running?
if ! openclaw gateway status 2>/dev/null | grep -q "running"; then
    echo "⚠️  Gateway not running — restart needed" >> "$LOG"
fi

# Check 2: Disk space (flag if >85%)
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 85 ]; then
    echo "⚠️  Disk at ${DISK_USAGE}% — above 85% threshold" >> "$LOG"
fi

# Check 3: Recent session errors (last hour)
LATEST_SESSION=$(openclaw sessions list --json 2>/dev/null | head -5)
if echo "$LATEST_SESSION" | grep -qi "error\|failed\|timeout"; then
    echo "⚠️  Recent session errors detected" >> "$LOG"
fi

# Check 4: Auto-save if significant changes since last save
if [ -f "$WORKSPACE/tools/auto_save.sh" ]; then
    LAST_SAVE=$(stat -c %Y "$WORKSPACE/.git/FETCH_HEAD" 2>/dev/null || echo "0")
    NOW=$(date +%s)
    AGE=$((NOW - LAST_SAVE))
    if [ "$AGE" -gt 3600 ]; then
        bash "$WORKSPACE/tools/auto_save.sh" &>/dev/null
        echo "Auto-saved workspace" >> "$LOG"
    fi
fi

echo "Heartbeat complete" >> "$LOG"
