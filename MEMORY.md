# MEMORY.md — Long-Term Memory

*Last updated: 2026-04-25*

---

## Jordan Hays

**Full name:** Jordan Hays
**Contact:** Telegram (primary channel)
**Time zone:** Europe/Madrid (CET)

### Jordan's Current Situation (2026-04-25)

**Financial:**
- Was struggling, now actively building income streams
- Has 3 projects in various stages: PISCO, COMARE, Dealsmap, ProfileStack
- Needs to graduate IMBA with 3 working projects (~210 days left)

**Emotional:**
- Focused on execution over perfection
- Wants systems that work and remember everything
- Values ownership of projects

**Skills:**
- Uses Lovable/Cursor for coding
- Comfortable with GitHub now (fixed sync, branch protection on main)

---

## Neuromatch — Jordan's Company

**What it is:**
Jordan wants to build a real company called **Neuromatch**.
Not just an app — a *business factory* with AI agents for each department.

**Vision:**
- Each department = its own AI agent
- Agents feed into each other (marketing → sales → product → finance)
- Company is the product. Agents are workers. Jordan is owner.
- The factory builds all his other app ideas.

**Built so far:**
- `/data/workspace/neuromatch/factory/DEPARTMENTS.md` — full blueprint
- `/data/workspace/neuromatch/factory/sales/agent.js` — Sales agent ✅
- `/data/workspace/neuromatch/factory/marketing/agent.js` — Marketing agent ✅
- `/data/workspace/neuromatch/factory/product/agent.js` — Product agent ✅
- `/data/workspace/neuromatch/factory/ops/dashboard.js` — CEO Dashboard ✅

**Run the dashboard:**
```bash
cd /data/workspace/neuromatch/factory/ops
node dashboard.js
```

**Still to build:**
- Finance Agent
- HR Agent
- Support Agent

---

## Jordan's Projects

### Active: PISCO
**What it is:** BD service for placing Filipino staff in European hotels
**Status:** Outreach in progress, has MIRO scripts working
**Key contacts:** Javier Estrada (NH), Luis Zamora (Iberostar), Yolanda de la Plaza (Room Mate)
**MIRO scripts:**
- `MIRO-PISCO-RUN3.py` — main PISCO outreach runner
- `MIRO-PROFILESTACK.py` — ProfileStack outreach
- `MIRO-OUTREACH.py` — generic outreach

**Predictions:**
- 6% first email response rate
- 10% after follow-up
- 1.8% pilot conversion

### Active: ProfileStack
**What it is:** LinkedIn profile optimization service (EUR 199/mo)
**Target MRR:** EUR 7,500 by month 6
**Status:** Go-to-market research done, LinkedIn post draft ready
**Location:** `/home/openclaw/.openclaw/workspace/ProfileStack/GO-TO-MARKET-RESEARCH.md`

### Active: MiroFish
**What it is:** Product analytics SaaS (local dev setup)
**Status:** Fully running
- Frontend: localhost:3001
- Backend: localhost:5001
**Location:** `/home/openclaw/.openclaw/workspace/MiroFish/`

### Active: COMARE
**What it is:** Maintenance company (Filipino staff in Spain)
**Status:** Planning phase, ICP decision pending (pharmacies OR restaurants)

### Active: Dealsmap
**What it is:** Deal marketplace
**Status:** Not launched, pending Upwork posting

### Research: Idea Agent
- Location: `/home/openclaw/.openclaw/workspace/idea-agent/`
- Status: Built, Jordan hasn't run it yet
- Purpose: Scrapes web for problems → generates app ideas

### Ideas: 100 app ideas (numbered list)
Jordan shared a list of 100 app ideas. Main ones discussed:
1. ReplyForge — email template AI
2. SubSink — subscription canceler
3. FocusGuard — website blocker
4. InvoiceGhost — invoice chaser
5. ReviewRequest — review asker
... (rest listed in `/home/openclaw/.openclaw/workspace/memory/2026-04-21.md`)

---

## API Keys & Services

All API keys saved to:
- `/home/openclaw/.openclaw/workspace/.env`
- `/home/openclaw/.openclaw/workspace/MiroFish/.env`

**Working services:**
- **OpenRouter:** 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
- **Felo web search:** fk-AO9iq37Z3jWpsIox3vGeigoUF68xxgYDuTH6K2ngETO8laVf
- **ScrapeCreators API:** iBax9goSYPF7FaoUPFhuDalYMdbV (25,063 credits remaining)
- **Notion API:** [REDACTED — saved in .env]
- **LocalGraphBuilder:** Built, no Zep API needed

---

## Skills Installed

- **last30days:** Installed and working with YouTube, TikTok, Reddit, Instagram, Hacker News
- **notion:** Notion API integration
- **google-calendar:** Google Calendar integration
- **email-daily-summary:** Email account login and daily summaries
- **telegram-bot:** Telegram bot control
- **weather:** Weather forecasts via wttr.in or Open-Meteo

---

## What Jordan Wants From Me

**Top priority:** Become a top 1% agent. Memory. Proactivity. Action without asking.

**Specific wants:**
1. Don't ask so many questions — take action
2. Remember everything without him repeating
3. Build things without waiting for permission
4. Be proactive, not reactive
5. Focus on making HIM better, not just building projects

---

## Key Lessons About Jordan

1. **He hates explaining twice.** If he said it once, I should remember it.
2. **He wants action, not questions.** When he says "build X", I should build it, not ask what it should do.
3. **He thinks big but gets stuck.** 100 ideas but nothing shipped. My job is to help him ship.
4. **He's in survival mode.** Not theoretical. Income now > perfect later.
5. **He values ownership.** "I want it to be something of my own."

---

## GitHub Sync

- **Repo:** github.com/jordanjayhays-cpu/openclaw-agent
- **Status:** Fixed — branch protection on main, submodules removed
- **Protocol:** git add -A → commit → push after significant changes

---

## Files

- `/home/openclaw/.openclaw/workspace/MEMORY.md` — this file
- `/home/openclaw/.openclaw/workspace/memory/2026-04-25.md` — today's session notes
- `/home/openclaw/.openclaw/workspace/.learnings/` — corrections and errors log
- `/home/openclaw/.openclaw/workspace/neuromatch/` — Neuromatch company files
- `/home/openclaw/.openclaw/workspace/idea-agent/` — idea scraper
- `/home/openclaw/.openclaw/workspace/MiroFish/` — MiroFish project
- `/home/openclaw/.openclaw/workspace/ProfileStack/` — ProfileStack project

---

*Update this file after every significant conversation. Jordan deserves an agent that never makes him repeat himself.*


## April 26, 2026 — Massive Build Day

### What's Live Now
- massage-pass/index.html — full booking UI, OpenStreetMap, 12 studios
- SUPPLY-FIRST.html — partner signup (needs Web3Forms key)
- passport.html — loyalty stamp card + walk-in QR
- PROJECTS/COMARE/gym-map.html — ICP-scored gym/pharmacy map
- ProfileStack/calculator.html — profile valuation tool

### Skills Installed Today
- send-email-programmatically (besoeasy/open-skills GitHub)
- free-geocoding-and-maps (Nominatim OSM - no API key)

### Still Blocked
- Web3Forms key (needed for partner form submissions)
- Supabase service_role key (booking storage)
- Jordan to approach 3 Madrid massage studios this week

## Supabase Key Saved: Sun Apr 26 08:06:46 UTC 2026
- URL: https://jglftdstrowwckwqmpue.supabase.co
- Service Role Key: saved to MASSAGE-PASS/.env
- Partners table: needs creation via SUPABASE-SETUP.sql


## April 26, 2026 — Supabase Key Received + Workflow Diagrams Built

### Supabase Connected
- URL: https://jglftdstrowwckwqmpue.supabase.co
- Service Role Key: saved in MASSAGE-PASS/.env
- Form: SUPPLY-FIRST.html updated to POST directly to Supabase partners table
- Table setup SQL: SUPABASE-SETUP.sql (Jordan needs to paste into Supabase SQL Editor)

### What's Live
- massage-pass/index.html — booking platform (12 studios, OpenStreetMap, loyalty stamps)
- massage-pass/workflows.html — visual workflow diagrams (customer + partner)
- SUPPLY-FIRST.html — partner signup form (Subabase-connected)
- PROJECTS/COMARE/gym-map.html — COMARE prospect map (16 prospects)
- passport.html — digital stamp card
- ProfileStack/calculator.html — profile valuation tool
- Hourly cron job active → Jordan gets Telegram updates every hour

### Partner Form Flow (Critical Path)
1. Studio fills SUPPLY-FIRST.html
2. Data POSTed to Supabase partners table
3. Jordan checks dashboard (supabase.com)
4. Jordan WhatsApps studio to close

### Jordan's Blockers Remaining
1. Paste SUPABASE-SETUP.sql into Supabase SQL Editor (ONE-TIME, 2 min)
2. Approach 3 Madrid studios this week

### Skills Built Today
- send-email-programmatically (besoeasy/open-skills GitHub)
- free-geocoding-and-maps (Nominatim OSM)


## Sub-Agent Roster (Updated April 26, 2026)

| Agent | Name | Role |
|-------|------|------|
| Axton | (me) | Main coordinator — decides, orchestrates, speaks to Jordan |
| Claxton | (existing) | Code/engineering — writes code, ships files |
| Scoxton | (new) | Research — prospect research, data mining, competitive intel |
| Haxton | (pending build) | Outreach — emails, DMs, copy, sequences |
| Synxton | (pending build) | Ops — automation, n8n, cron |

Scoxton skill: skills/scoxton/SKILL.md + scoxton-run.js

