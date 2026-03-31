#!/bin/bash
# Morning Briefing via Telegram — 8 AM CET weekdays
# Uses OpenClaw's built-in Telegram to send

DATE=$(date +%Y-%m-%d)
TIME_CET=$(TZ='Europe/Madrid' date '+%I:%M %P' CET)

# Read memory
MEMORY_FILE="/home/openclaw/.openclaw/workspace/openclaw-agent/memory/${DATE}.md"
MEMORY_CONTENT=""
if [ -f "$MEMORY_FILE" ]; then
  MEMORY_CONTENT=$(tail -15 "$MEMORY_FILE")
else
  MEMORY_CONTENT="No session logged yet today."
fi

# Build briefing
MSG="☀️ Good morning Jordan — $TIME_CET

DATE: $DATE

📋 TOP 3 PRIORITIES:
1. Check MISSION-CONTROL.md
2. Execute today's outreach
3. Review responses

📊 PROJECT STATUS:
• PISCO: 756 messages ready, 0 sent
• COMARE: Awaiting ICP decision  
• Dealsmap: Profile partner model

📅 THIS WEEK:
• Apr 1: Send Day 1 Spain emails
• Apr 3: Follow-up non-responders
• Apr 7: Break-up sequence

💡 QUICK INSIGHT:
You have everything ready. Execution > planning.

— Claw 🦞"

# Save to file for OpenClaw to pick up
echo "$MSG" > /tmp/morning-briefing.txt
echo "Briefing saved: $(date)"
