# HEARTBEAT.md — Mexico City Timezone

## Timezone
Mexico City (America/Mexico_City) — UTC-5 in April (no DST)

## Heartbeat Schedule
Run every 30 minutes, **9am–11pm CDMX only**.
Stay quiet overnight (11pm–9am).

## Heartbeat Checklist

### 1. Git Sync
If workspace has uncommitted changes → `bash tools/auto_save.sh`

### 2. Follow-ups
Check contacts/CONTEXT.md for any contact with `Next Action: today`
If found → send Telegram message to Jordan flagging the follow-up

### 3. Stale Tasks
Check AUTONOMOUS.md for tasks older than 3 days with no completion
If found → flag in next message to Jordan

### 4. New Notifications
Check for any new Telegram messages or events that need Jordan's attention
If urgent → message Jordan immediately (don't wait for heartbeat)

### 5. Log
Append timestamp to memory/heartbeats.md

---

## When to Message Jordan (Proactive)

**Message him when:**
- A contact follow-up is due today
- A task has been stale >3 days and needs attention
- The overnight research cron completed (results ready)
- Something broke or needs a decision from him
- Git push failed and needs his attention

**Stay quiet when:**
- It's overnight (11pm–9am CDMX)
- Nothing new since last check (<30 min ago)
- Just completed a task with no blockers

---

## Proactive Messaging Rule
Don't wait for Jordan to ask. If something needs his attention, tell him.
Short message: "Hey Jordan — [X] needs your input on [Y]. Details: [Z]"
