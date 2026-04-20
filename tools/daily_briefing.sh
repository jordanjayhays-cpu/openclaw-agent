#!/bin/bash
# Daily Morning Briefing for Jordan
# Sends to Telegram every morning at 9:00 AM Madrid time

BOT_TOKEN="8768116245:AAG1kj2x8kQU25U2wXehMxzTpWPls-sXlzA"
CHAT_ID="6463127078"

# Get current date in Madrid timezone
DATE=$(TZ="Europe/Madrid" date +"%A, %B %d")

# Quick status checks
PISCO_PROGRESS=$(cat /home/openclaw/.openclaw/workspace/PROJECTS/PISCO/OUTREACH-PROGRESS.md 2>/dev/null | grep -c "✅" || echo "0")
COMARE_PROGRESS=$(cat /home/openclaw/.openclaw/workspace/PROJECTS/COMARE/PROSPECTS-200.md 2>/dev/null | grep -c "Decision Maker" || echo "0")

# Get git commit count this week
cd /home/openclaw/.openclaw/workspace
GIT_LOG=$(git log --oneline --since="7 days ago" 2>/dev/null | wc -l)
GIT_LAST=$(git log -1 --oneline --format="%s" 2>/dev/null | head -c 80)

MESSAGE="🌅 Good morning Jordan — $DATE

📊 PROJECT STATUS:
• PISCO: $PISCO_PROGRESS items tracked (research complete, 756 messages ready)
• COMARE: $COMARE_PROGRESS prospects researched
• Recent work: $GIT_LAST

🎯 TODAY'S PRIORITY:
What are you working on first? Let me know and I'll get started.

🤖 This briefing automated — I run every morning at 9 AM Madrid time."

curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d "chat_id=$CHAT_ID&text=$MESSAGE&parse_mode=HTML"

echo "[$(date)] Daily briefing sent"