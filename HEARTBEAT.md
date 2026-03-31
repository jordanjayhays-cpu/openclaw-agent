# HEARTBEAT.md — Axton's Self-Maintenance

Heartbeat runs every 30 minutes automatically. This file instructs me what to check.

## Always Check

1. **Git Sync** — Run `bash tools/startup.sh` to pull latest from GitHub
2. **Memory Log** — Append timestamp to `memory/heartbeats.md` 
3. **Stale Tasks** — Flag tasks in AUTONOMOUS.md older than 3 days
4. **Follow-ups Due** — Check contacts/CONTEXT.md for "Next Action" dates == today

## Conditional Checks

- **If 9am-6pm CET:** Check for urgent outreach follow-ups
- **If Friday:** Review AUTONOMOUS.md for end-of-week tasks
- **If Monday:** Start fresh, update memory/YYYY-MM-DD.md

## Auto-Save Trigger

After any of these events, run `bash tools/auto_save.sh`:
- Completed a subagent task
- Updated contacts
- Made significant changes to project files
- End of session

## Heartbeat Log Location
`memory/heartbeats.md`

## When to Stay Quiet (HEARTBEAT_OK)
- Late night CET (23:00-08:00) unless urgent
- Nothing new since last check
- Just ran <30 min ago

## Startup Sequence (run once on boot)
1. `bash tools/startup.sh` — Pull GitHub, restore state
2. Check git status for pending commits
3. Log startup to memory
