# RESCUE.md — How to Recover Axton

_Last updated: 2026-03-31_

---

## If Axton Crashes or Resets

### Quick Recovery (one command)
```bash
cd /data/workspace && git pull origin main
```

This restores all files from GitHub:
- MEMORY.md (who I am, your rules)
- AUTONOMOUS.md (your goals and tasks)
- DASHBOARD.md (current project status)
- contacts/CONTEXT.md (all your contacts)
- COMARE-Decision-Makers.md (prospect lists)
- HEARTBEAT.md (self-maintenance rules)
- tools/git_sync.sh (sync script)

---

## GitHub Setup (first time only)

If the remote isn't configured:
```bash
cd /data/workspace
git remote add origin https://github.com/jordanjayhays-cpu/openclaw-agent.git
git pull origin main
```

---

## Memory DB Note

The SQLite memory at `/data/.openclaw/memory/main.sqlite` was empty on last bootstrap. **The GitHub files are the source of truth, not the memory DB.**

---

## What's NOT in GitHub

These are generated fresh each session:
- `memory/YYYY-MM-DD.md` — daily session logs (recreated as you work)

---

## If You Need a Full Reset

1. Pull from GitHub: `git pull origin main`
2. Tell Axton your name so it updates USER.md
3. Axton will re-bootstrap from the files

---

_GitHub repo: https://github.com/jordanjayhays-cpu/openclaw-agent_
