#!/bin/bash
# calendar_prep.sh — Prepare for upcoming meetings
# Lists meetings in next 48h with AI prep prompts per meeting
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

FROM_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
TO_DATE="$(date -u -d "+48 hours" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -d "+48 hours" +%Y-%m-%dT%H:%M:%SZ)"

echo "📋 Meeting Prep — Next 48h"
echo "=========================="

if [ -z "$GOOGLE_REFRESH_TOKEN" ]; then
  echo "❌ Calendar not connected."
  exit 1
fi

TMP=$(python3 "$SKILL_DIR/scripts/google_calendar.py" list \
  --from "$FROM_DATE" \
  --to "$TO_DATE" \
  --max 10 2>/dev/null)

HAS_EVENTS=$(echo "$TMP" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for cal_id, events in data.items():
    if events:
        print('yes')
        break
" 2>/dev/null)

if [ "$HAS_EVENTS" != "yes" ]; then
  echo "  No meetings in the next 48h. You're clear."
  exit 0
fi

echo "$TMP" | python3 -c "
import sys, json, datetime

data = json.load(sys.stdin)
for cal_id, events in data.items():
    for ev in events:
        start = ev.get('start', {})
        dt_str = start.get('dateTime', start.get('date', ''))
        summary = ev.get('summary', '(no title)')
        desc = ev.get('description', '')
        loc = ev.get('location', '')
        attendees = ev.get('attendees', [])

        try:
            dt = datetime.datetime.fromisoformat(dt_str.replace('Z', '+00:00'))
            time_str = dt.strftime('%a %b %d %H:%M')
        except:
            time_str = dt_str

        print(f'\n📌 {time_str} — {summary}')
        if loc:
            print(f'   📍 {loc}')
        if desc:
            print(f'   📝 {desc[:200]}')
        if attendees:
            emails = [a.get('email','') for a in attendees]
            print(f'   👥 {len(emails)} attendee(s):')
            for e in emails:
                print(f'     • {e}')
        else:
            print('   👥 No external attendees')
        print('   🔍 AI prep suggestions:')
        print('     - Research attendee backgrounds before the call')
        print('     - Review shared docs / agenda in description')
        print('     - Prepare 1-2 relevant questions or talking points')
        print('     - Set a 5-min reminder to collect thoughts')
        print('     - If virtual, ensure link is accessible')
"
