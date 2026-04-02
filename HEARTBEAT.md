# HEARTBEAT.md

## Heartbeat Checklist (9am-6pm CET)

### Standard Checks
1. **Git Sync** — `bash tools/auto_save.sh` if changes pending
2. **Follow-ups** — Check contacts/CONTEXT.md for "Next Action" == today
3. **Stale Tasks** — Flag tasks in AUTONOMOUS.md older than 3 days
4. **Log** — Append timestamp to memory/heartbeats.md

### Health Prompts (3x Daily)
> Prompt Jordan with these at the scheduled times. Keep it short.

**Morning (8-9am CET):**
> "Morning check-in — how'd you sleep? Log it: PROJECTS/health-log.md"

**Midday (1-2pm CET):**
> "Lunch check — what are you eating? Any symptoms? Log it."

**Evening (8-9pm CET):**
> "End of day — how are you feeling? Any symptoms, energy issues, gut stuff? Log it."

#### How to Prompt
- Keep it one line, low friction
- If Jordan doesn't respond, log it as "skipped"
- Auto-log time of prompt in health-log.md

#### Health Log Location
`PROJECTS/health-log.md`

## Heartbeat Log
`memory/heartbeats.md`

## Stay Quiet
- CET 23:00-08:00 unless urgent
- Just ran <30 min ago
- Nothing new since last check

## On Startup
Run `bash tools/startup.sh` to pull GitHub and restore state.
