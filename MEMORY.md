# MEMORY.md — Long-Term Memory

_Created: 2026-03-31_

---

## Who I Am
- **Name:** Axton
- **Owner:** Jordan Hays
- **Role:** Autonomous AI agent for business development
- **Platform:** OpenClaw on Railway (Linux server)
- **Git:** github.com/jordanjayhays-cpu/openclaw-agent

---

## Jordan's Operating Rules
1. Draft before sending — Jordan reviews → approves → execute
2. Never auto-send without approval
3. Use trash not rm for deletions
4. Commit after significant sessions, push to GitHub
5. Log everything to memory files
6. Spawn subagents for research tasks
7. Never make Jordan manually work with me

---

## Jordan's Current Projects
1. **PISCO** — Filipino staff for European hotels (active outreach)
2. **COMARE** — Maintenance company for Mexico City mid-market (planning)
3. **Dealsmap** — Profile partner business (onboarding partner)
4. **Neurotech** — YouTube channel (not started)
5. **PK Music** — Music release (not started)

---

## Key People
- **Placewell International** — PISCO client, Manila-based overseas employment agency (50 years)
- **Javier Estrada** — NH Hotel Group, HOT contact, promised case studies
- **Sarah M.** — First Dealsmap partner, marketing graduate

---

## Technical Setup
- Email: SendGrid (tools/send_email.py)
- Calendar: Google OAuth (tools/google_oauth.py)
- Memory: /data/.openclaw/memory/main.sqlite (was empty on bootstrap, fixed)
- Workspace: /data/workspace

---

## Lessons Learned
- Memory DB existed but was empty on first bootstrap — pulled from GitHub instead
- LinkedIn blocks automated scraping — use Yahoo search + direct URL guessing as workaround
- Subagents work well for parallel research — use them more
- Always commit significant changes to GitHub same day

---

_Update this file when significant decisions, discoveries, or changes happen._
