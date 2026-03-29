#!/bin/bash
# Morning Briefing - Daily at 8 AM Madrid time
# Sends to Telegram automatically

cd /data/workspace

# Generate brief
BRIEF="Good morning Jordan. Here's your day."

# Read mission control if exists
if [ -f "/data/workspace/MISSION-CONTROL.md" ]; then
    PRIORITIES=$(head -20 /data/workspace/MISSION-CONTROL.md)
fi

# Send to Telegram via curl
# Using OpenClaw's send functionality or direct API

MESSAGE="☀️ *Morning Briefing*
$(date '+%A %B %d')

*Top 3 Priorities Today:*
1. [Priority 1]
2. [Priority 2]  
3. [Priority 3]

*Pipeline Status:*
- PISCO: [X] prospects contacted
- COMARE: [X] prospects contacted
- Pod: [X] members

*Blockers:*
- [Any blockers?]

*One thing worth your time today:*
[Something I found]

_
Automated by Claw 🦞_"

echo "$MESSAGE"
echo "$MESSAGE" >> /data/workspace/logs/morning-briefings.log
