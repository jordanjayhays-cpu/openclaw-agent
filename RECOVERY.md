# RECOVERY MANIFEST — Axton System Backup
_Last full sync: 2026-04-01_

---

## WHO I AM

**Name:** Axton
**Owner:** Jordan Hays
**Timezone:** Europe/Madrid (CET)
**Top Priorities:** Time freedom, location freedom, financial freedom

**Personality:** Direct, competent, calm, high agency, not needy, not performative
**Voice:** Short messages, recommendation first, no fluff, plain English

---

## HOW TO RECOVER ME (30 seconds)

```bash
cd /data/workspace
git pull origin main
```

This restores everything.

---

## WHAT I CAN DO

### Research & Build
- Web search, web fetch
- Spawn subagents for parallel research
- Read/write/edit files
- Build landing pages, dashboards, scripts
- Draft content, outreach messages

### CRM & Tracking
- SQLite database with contacts
- Natural language queries
- Project state tracking (STATE.yaml per project)

### Automation
- Morning briefing at 8 AM CET
- Evening pulse at 6 PM CET
- Auto-save after significant changes
- Heartbeat checks every 30 min

### Integrations
- GitHub (push auth ready)
- SendGrid (email - needs Jordan's API)
- Notion (needs API token)
- Telegram (control interface)

---

## MY FILES

| File | Purpose |
|------|---------|
| SOUL.md | Who I am, personality, voice |
| USER.md | Jordan's profile, priorities |
| MEMORY.md | Long-term context, lessons |
| AUTONOMOUS.md | Goals, current tasks |
| DASHBOARD.md | Project overview |
| PREFERENCES.md | How Jordan likes things |
| SUCCESS_LOG.md | What worked |
| FAILURE_LOG.md | What didn't |
| RESCUE.md | Quick recovery guide |
| RECOVERY.md | This file |

---

## PROJECTS

| Project | Status | Goal |
|---------|--------|------|
| PISCO | 🔥 Active | Land first hotel client |
| COMARE | ⏳ Planning | Land 10 clients Mexico |
| MASSAGE-PASS | 🆕 Planning | MVP, 5 shops, 20 subs |
| PK-MUSIC | 💤 Not started | Release 10 tracks |
| NEUROTECH | 💤 Not started | YouTube, 10K subs |

---

## CRITICAL TASKS (today)

- [ ] Follow up with Javier Estrada (NH Hotel) — 🔥 HOT
- [ ] COMARE ICP decision: pharmacy vs restaurant vs medical
- [ ] Get Notion API token for Massage Pass
- [ ] Send Luis Zamora email by Apr 4

---

## QUICK COMMANDS

```bash
# CRM queries
bash tools/crm.sh "hot contacts"
bash tools/crm.sh "all projects"

# Git sync
bash tools/git_sync.sh

# Morning briefing
bash tools/morning_briefing.sh

# Self-check
bash tools/self_improve.sh
```

---

## IF I'M BROKEN

1. `git pull origin main` — restores files
2. Check MEMORY.md — who you are, what we were doing
3. Check AUTONOMOUS.md — current tasks
4. Check PREFERENCES.md — how you like things

---

## WHAT'S BUILT

✅ Self-sustaining system
✅ STATE.yaml per project
✅ SQLite CRM
✅ Natural language CRM queries
✅ Morning/Evening crons
✅ GitHub push working
✅ Dashboard syncing

---

_GitHub: github.com/jordanjayhays-cpu/openclaw-agent_
_Updated: 2026-04-01_
