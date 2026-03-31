# IMPROVEMENT PLAN — Axton 2.0
_Based on elite OpenClaw research_

## Top 5 Improvements to Adopt

### 1. Personal CRM (SQLite) — HIGHEST PRIORITY
**What:** SQLite DB with contact tracking, interaction history, natural queries
**Gap:** I have contacts/CONTEXT.md but no DB, no automatic updates

**Build:**
```sql
CREATE TABLE contacts (
  id INTEGER PRIMARY KEY,
  name TEXT,
  company TEXT,
  linkedin TEXT,
  email TEXT,
  warmth TEXT, -- hot/warm/cold
  first_contact TEXT,
  last_contact TEXT,
  interaction_count INTEGER,
  notes TEXT
);

CREATE TABLE interactions (
  id INTEGER PRIMARY KEY,
  contact_id INTEGER,
  type TEXT, -- email/linkedin/call/meeting
  date TEXT,
  summary TEXT
);
```

**New cron: Daily (6 AM)**
- Scan for new contacts
- Update last_contact timestamps
- Log new interactions

### 2. Meeting Prep Briefings — NEXT
**What:** Before Jordan's meetings, brief on attendees
**Gap:** I don't check his calendar or prep

**New cron: 7 AM**
- Check Google Calendar for today's meetings
- For each external attendee:
  - Search CRM for who they are
  - Check email history
  - Deliver briefing to Telegram

### 3. Daily Task Generation — AUTONOMOUS
**What:** I generate 4-5 tasks daily from AUTONOMOUS.md goals
**Gap:** I have goals but don't proactively create tasks

**Morning (8 AM) — After briefing:**
- Read AUTONOMOUS.md goals
- Generate 4-5 specific tasks I can complete today
- Execute them without being asked
- Log completed to tasks-log.md

### 4. Health Tracker Prompts — SCHEDULED
**What:** 3x daily prompts for food/symptoms
**Gap:** I have health-log.md but no scheduled check-ins

**New crons:**
- 9 AM: "🍳 How'd you sleep?"
- 1 PM: "🥗 Lunch log"
- 7 PM: "🍽️ Dinner + symptoms?"

### 5. Second Brain UI — FUTURE
**What:** Next.js searchable dashboard for memories
**Status:** Nice to have, requires building

---

## Implementation Order

1. ✅ Personal CRM SQLite (today)
2. ⏳ Meeting prep briefings (tomorrow)
3. ⏳ Daily task generation (this week)
4. ⏳ Health prompts (this week)
5. ⏳ Second brain UI (next month)

---

## Elite OpenClaws Doing More

**These are lower priority but good to know:**

- n8n workflow orchestration
- TweetClaw (Twitter automation)
- Multi-agent specialized teams
- Polymarket autopaper
- Phone-based voice assistant

---

_Learned from: hesamsheikh/awesome-openclaw-usecases_
