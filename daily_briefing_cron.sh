#!/bin/bash
# Daily Briefing Cron — 8:00 AM CET every day
# Add to crontab: 0 8 * * * /data/workspace/daily_briefing_cron.sh

EMAIL="jordanjayhays@gmail.com"
DATE=$(date '+%A %B %d, %Y')

# Get weather
WEATHER=$(curl -s "wttr.in/Madrid?format=1" | head -1)

# Build message
MSG="Good morning Jordan — $(TZ='Europe/Madrid' date '+%I:%M %P' CET)

WEATHER IN MADRID: $WEATHER

TOP 3 PRIORITIES TODAY:

1. Check MISSION-CONTROL.md
2. Review today's events
3. Execute top priority

This is an automated daily briefing from Claw."

# For now, save to file (email integration needed)
echo "$MSG" > /tmp/briefing.txt
echo "Briefing saved to /tmp/briefing.txt"
