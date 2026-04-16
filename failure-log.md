# Failure Log

## 2026-04-16 — 10:17 UTC (Self-Heal Cron)

**Failures detected:** 3
**Auto-fixes applied:** 2

### Unfixed Failures

**1. 8 failed cron jobs** (could not auto-restart)
These failed with `error` status but the script couldn't re-trigger them properly:

| Cron | Schedule | Last Error |
|------|----------|------------|
| THE EVOLVER | every 4h | error |
| Evening Pulse | cron 0 0 18 * * * | error |
| Overnight Builder | cron 0 0 1 * * * | error |
| Response Optimizer | cron 0 0 5 * * * | error |
| Auto Task Generator | cron 0 30 7 * * * | error |
| Morning Briefing | cron 0 0 8 * * * | error |
| Sunday Mini-App Builder | cron 0 0 2 * * 0 | error |
| Weekly Review | cron 0 0 8 * * 0 | error |

### Fixed by Self-Heal

- **Git uncommitted changes** → committed and pushed (7debee9)
- **1 stale subagent session** → killed

### Action Required

The cron re-trigger logic in `tools/self_heal.sh` only echoes "Attempting to restart" but doesn't execute `openclaw cron run`. Need to fix the script to properly re-trigger failed crons.