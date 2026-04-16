#!/bin/bash
# calendar_check.sh — Check today's calendar events
# Usage: bash tools/calendar_check.sh [--days N]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="/data/workspace/skills/google-calendar"
VENV_DIR="$SKILL_DIR/scripts/venv"

# Source virtualenv if it exists
if [ -f "$VENV_DIR/bin/activate" ]; then
  source "$VENV_DIR/bin/activate"
fi

# Load env vars from openclaw secrets
for var in GOOGLE_CLIENT_ID GOOGLE_CLIENT_SECRET GOOGLE_REFRESH_TOKEN GOOGLE_CALENDAR_ID; do
  export "$var"=$(openclaw secret get "$var" 2>/dev/null || echo "")
done

# Default: today
FROM_DATE="$(date -u +%Y-%m-%dT00:00:00Z)"
TO_DATE="$(date -u +%Y-%m-%dT23:59:59Z)"

if [ "$1" == "--days" ] && [ -n "$2" ]; then
  FROM_DATE="$(date -u +%Y-%m-%dT00:00:00Z)"
  TO_DATE="$(date -u -d "+$2 days" +%Y-%m-%dT23:59:59Z 2>/dev/null || date -d "+$2 days" +%Y-%m-%dT23:59:59Z)"
fi

echo "📅 Calendar — $(date '+%Y-%m-%d')"
echo "================================"

if [ -z "$GOOGLE_REFRESH_TOKEN" ]; then
  echo "❌ Calendar not connected. Run setup first."
  exit 1
fi

python3 "$SKILL_DIR/scripts/google_calendar.py" list \
  --from "$FROM_DATE" \
  --to "$TO_DATE" \
  --max 20 2>/dev/null | python3 -c "
import sys, json
data = json.load(sys.stdin)
for cal_id, events in data.items():
    if not events:
        print('  (no events)')
    for ev in events:
        start = ev.get('start', {})
        dt = start.get('dateTime', start.get('date', 'TBD'))
        summary = ev.get('summary', '(no title)')
        loc = ev.get('location', '')
        print(f'  • {dt} — {summary}' + (f' @ {loc}' if loc else ''))
"
