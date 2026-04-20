# HEARTBEAT.md — Periodic Self-Maintenance Checklist

_Core rule: If nothing needs attention, reply HEARTBEAT_OK. Don't burn tokens checking things that don't need checking._

---

## Daily Checks (9 AM - 6 PM CET, rotate through)

**Morning (once per day around 9 AM):**
- Run `bash tools/daily_briefing.sh` — send morning status to Jordan via Telegram
- Check AUTONOMOUS.md for today's priorities
- Review contacts/CONTEXT.md for follow-ups due today

**Midday (rotate through every ~3 hours):**
- Check for new GitHub commits or changes
- Review memory/YYYY-MM-DD.md — add session notes if active conversation happened
- Check project files for updates (PISCO/COMARE)

---

## Task Checks (only if AUTONOMOUS.md has stale items)

- Any tasks marked ">3 days old" without update? Flag to Jordan
- Any completed items in AUTONOMOUS.md not marked done?
- Any blocked tasks that can be unblocked?

---

## Auto-Save (every 15 min via cron, but verify during heartbeat)

If auto_save hasn't run in >20 min and significant changes exist:
```bash
bash tools/auto_save.sh
```

---

## Response Triggers (don't check these every heartbeat)

Only act if:
- Jordan asks something specific
- A subagent reports back with results
- A cron job triggered an alert (e.g., GitHub sync failed)

---

## If Nothing Needs Attention

Reply exactly: HEARTBEAT_OK

Do NOT:
- Run calculations or research unprompted
- Generate content without a task
- Check all projects every single heartbeat
- Send status updates unless it's the morning briefing

---

**Remember:** Heartbeats are for maintenance, not for starting new work. Jordan will message you when he needs something.

_Created: 2026-04-20_