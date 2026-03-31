#!/bin/bash
# Morning briefing for Jordan
# Runs at 8 AM CET (07:00 UTC) weekdays

DATE=$(date +%Y-%m-%d)
MEMORY_FILE="/home/openclaw/.openclaw/workspace/openclaw-agent/memory/${DATE}.md"
MISSION_FILE="/home/openclaw/.openclaw/workspace/openclaw-agent/MISSION-CONTROL.md"

echo "=== Morning Briefing - $DATE ==="
echo ""
echo "Date: $DATE"
echo ""
echo "=== Mission Control ==="
if [ -f "$MISSION_FILE" ]; then
  head -30 "$MISSION_FILE"
fi
echo ""
echo "=== Today's Memory ==="
if [ -f "$MEMORY_FILE" ]; then
  tail -20 "$MEMORY_FILE"
else
  echo "No memory file for today yet."
fi
echo ""
echo "=== Projects Status ==="
cd /home/openclaw/.openclaw/workspace/openclaw-agent
if [ -f PROJECTS/PISCO/OUTREACH-PROGRESS.md ]; then
  grep -E "^\|" PROJECTS/PISCO/OUTREACH-PROGRESS.md | head -10
fi

# ============================================
# CRON ENTRY (add to crontab -e):
# 0 7 * * 1-5 /home/openclaw/.openclaw/workspace/openclaw-agent/cron/morning-briefing.sh
# ============================================
