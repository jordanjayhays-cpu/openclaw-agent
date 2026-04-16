# Calendar Integration

> Connect Jordan's Google Calendar to OpenClaw for AI-powered meeting management.

## What You Get

- **Daily briefing**: See today's events before you start
- **Meeting prep**: Auto-research + agenda prep before calls
- **Deep work blocks**: Reserve focused time without conflicts
- **AI use cases**: Smart reminders, conflict detection, attendee research

---

## Setup

### 1. Prerequisites

The OAuth app already exists in Jordan's Google Cloud:
- **Client ID**: `263558923582-r1jhdom4aeg9gooja5mvmt7du6o82i36.apps.googleusercontent.com`
- **Client Secret**: `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`

You just need to get the **refresh token**.

### 2. Get Refresh Token

```bash
cd /data/workspace
python3 tools/google_oauth.py
```

Follow the printed instructions — it will give you a URL to visit, then you'll paste the redirect URL back.

Save the `refresh_token` value from the output.

### 3. Store Secrets

```bash
openclaw secret set GOOGLE_REFRESH_TOKEN <your_refresh_token>
openclaw secret set GOOGLE_CALENDAR_ID primary
```

### 4. Install Python deps (if not already)

```bash
source /data/workspace/skills/google-calendar/scripts/venv/bin/activate 2>/dev/null || \
pip install --user google-auth google-auth-oauthlib google-api-python-client
```

### 5. Test

```bash
bash tools/calendar_check.sh
```

---

## Tools

### `tools/calendar_check.sh`
Check today's events. Shows all calendar entries for today.
```bash
bash tools/calendar_check.sh             # today only
bash tools/calendar_check.sh --days 3     # next 3 days
```

### `tools/calendar_prep.sh`
Lists meetings in next 48h and gives AI prep prompts per meeting (research attendees, review agenda, etc.).
```bash
bash tools/calendar_prep.sh
```

### `tools/calendar_block.sh`
Block deep work time. Prompts for confirmation if conflicts detected.
```bash
bash tools/calendar_block.sh             # today 9am-12pm
bash tools/calendar_block.sh tomorrow 14  # tomorrow 2pm-5pm
bash tools/calendar_block.sh 2026-04-20 9 4  # specific date, 4h block
```

---

## API Reference

| Endpoint | Method | What it does |
|---|---|---|
| `/calendars/{id}/events` | GET | List events |
| `/calendars/{id}/events` | POST | Create event |
| `/calendars/{id}/events/{eid}` | PUT | Update event |
| `/calendars/{id}/events/{eid}` | DELETE | Delete event |

**Scopes needed:**
- `https://www.googleapis.com/auth/calendar`
- `https://www.googleapis.com/auth/calendar.events`

---

## AI Calendar Use Cases

### Meeting Prep
Before each meeting, Axton can:
1. Pull attendee list from event
2. Research each attendee (LinkedIn, recent activity)
3. Flag shared history or red flags
4. Review shared docs in event description

### Auto-Scheduling (Future)
- Find open slots across calendars
- Suggest optimal meeting times based on focus windows
- Auto-decline conflicts with response

### Intelligent Reminders
- Default: 10min before
- High priority: 30min + prep prompt
- Deep work blocks: 5min "startup" reminder

### Conflict Detection
- Before creating a block, check for existing events
- Warn if trying to schedule over buffer time

### Meeting Summaries
- After meeting, parse description/agenda
- Draft follow-up email or next steps

### Deep Work Blocking
- Default: 9am-12pm Mon-Fri
- Configurable per Jordan's preference
- Add "do not disturb" context to event

---

## OpenClaw Calendar Skills

Existing skill at `/data/workspace/skills/google-calendar/`
- **list** — upcoming events
- **add** — create event
- **update** — edit event
- **delete** — remove event

The skill is read by the main agent automatically when calendar tasks are requested.

---

## Status

```
calendar_connected: false  ← Set to true once OAuth token obtained
refresh_token: obtained   ← Yes once setup step 2 complete
last_check: never
```
