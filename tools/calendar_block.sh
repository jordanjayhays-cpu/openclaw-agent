#!/bin/bash
# calendar_block.sh — Block deep work time on Jordan's calendar
# Usage: bash tools/calendar_block.sh [date] [start_hour] [duration_hours]
# Examples:
#   bash tools/calendar_block.sh today       # blocks 9am-12pm today
#   bash tools/calendar_block.sh tomorrow 14  # blocks 2pm-5pm tomorrow
#   bash tools/calendar_block.sh 2026-04-20 9 4  # blocks 4h starting 9am on that date
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="/data/workspace/skills/google-calendar"
VENV_DIR="$SKILL_DIR/scripts/venv"

if [ -f "$VENV_DIR/bin/activate" ]; then
  source "$VENV_DIR/bin/activate"
fi

for var in GOOGLE_CLIENT_ID GOOGLE_CLIENT_SECRET GOOGLE_REFRESH_TOKEN GOOGLE_CALENDAR_ID; do
  export "$var"=$(openclaw secret get "$var" 2>/dev/null || echo "")
done

DATE="${1:-today}"
START_HOUR="${2:-9}"
DURATION="${3:-3}"

# Resolve date
if [ "$DATE" == "today" ]; then
  DATE="$(date +%Y-%m-%d)"
elif [ "$DATE" == "tomorrow" ]; then
  DATE="$(date -d tomorrow +%Y-%m-%d 2>/dev/null || date -d "+1 day" +%Y-%m-%d)"
fi

# Build ISO times
START="${DATE}T$(printf '%02d' $START_HOUR):00:00"
END_HOUR=$((START_HOUR + DURATION))
END="${DATE}T$(printf '%02d' $END_HOUR):00:00"

echo "🔒 Blocking Deep Work Time"
echo "========================="
echo "  Date:  $DATE"
echo "  Time:  ${START_HOUR}:00 – ${END_HOUR}:00"
echo "  Duration: ${DURATION}h"

if [ -z "$GOOGLE_REFRESH_TOKEN" ]; then
  echo "❌ Calendar not connected."
  exit 1
fi

# Check for conflicts first
python3 "$SKILL_DIR/scripts/google_calendar.py" list \
  --from "${DATE}T00:00:00" \
  --to "${DATE}T23:59:59" \
  --max 20 2>/dev/null | python3 -c "
import sys, json
data = json.load(sys.stdin)
for cal_id, events in data.items():
    for ev in events:
        start = ev.get('start', {})
        end = ev.get('end', {})
        dt_start = start.get('dateTime', '')
        dt_end = end.get('dateTime', '')
        if dt_start and dt_end:
            print(f'  ⚠️  Conflict: {ev.get(\"summary\",\"(no title)\")} @ {dt_start}')
" || true

echo ""
read -p "Create block? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

python3 "$SKILL_DIR/scripts/google_calendar.py" add \
  --title "🔒 Deep Work Block" \
  --start "$START" \
  --end "$END" \
  --desc "Auto-blocked for focused deep work. Minimize distractions — no meetings, no Slack." \
  --location "" \
  --attendees "" 2>/dev/null

echo ""
echo "✅ Deep work block created: ${DATE} ${START_HOUR}:00–${END_HOUR}:00"
