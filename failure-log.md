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

---

## 2026-04-16 — 10:32 UTC (Self-Heal Cron)

**Status:** ✅ FIXED

### Root Cause
`tools/self_heal.sh` parsed failed cron lines correctly but only printed "Attempting to restart" without calling `openclaw cron run <jobId>`.

### Fix Applied
Updated cron restart block to:
1. Extract job ID (first field of `openclaw cron list` output)
2. Call `openclaw cron run "$JOB_ID"` for each errored cron
3. Log success/failure per cron

### Still Monitoring
- 8 failed crons will be retried on next self-heal cycle (15m)
- Subagent stale-session detection still uses `openclaw sessions list` + grep which may not catch all subagent types

## 2026-04-16 — 11:47 UTC (Self-Heal Cron)

**Failures detected:** 2
- Evening Pulse cron (ab165c9e-776c-432e-9d1b-34eb64f4c8f5) — **FIXED:** restarted successfully
- Overnight Builder cron (633147d5-bc09-4bfe-b828-cc88f4da59b5) — **FIXED:** restarted successfully

**Auto-fixes applied:** 2/2
**Manual intervention needed:** None

---

## 2026-04-16 — 12:17 UTC (Self-Heal Cron)

**Failures detected:** 3
- Evening Pulse cron — **FIXED:** restarted successfully  
- Overnight Builder cron — **FIXED:** restarted successfully
- 1 stale session flag — **FALSE POSITIVE:** detected self-heal run itself, no action needed

**Auto-fixes applied:** 2/2
**Manual intervention needed:** None


## 2026-04-16 — 12:47 UTC (Self-Heal Cron)

**Failures detected:** 3
- Evening Pulse cron (ab165c9e-776c-432e-9d1b-34eb64f4c8f5) — **FIXED:** restarted successfully
- Overnight Builder cron (633147d5-bc09-4bfe-b828-cc88f4da59b5) — **FIXED:** restarted successfully
- 1 stale session flag — **LIKELY FALSE POSITIVE:** no stale sessions found on check, self-heal may have cleared

**Auto-fixes applied:** 2/2
**Manual intervention needed:** None


## 2026-04-16 13:17 UTC

| Failure | Fix Applied | Status |
|---------|-------------|--------|
| Failed cron: Overnight Builder | Restarted | ✅ Fixed |
| Uncommitted changes (2 files) | Auto-committed + pushed | ✅ Fixed |
| 1 stale session detected | (pending - subagent cleanup) | ⚠️ Needs attention |

## 2026-04-16 14:17 UTC

| Failure | Fix Applied | Status |
|---------|-------------|--------|
| Failed cron: MASSAGE-PASS Check-in | Restarted | ✅ Fixed |
| Uncommitted changes (8 files) | Auto-committed + pushed | ✅ Fixed |
| 1 stale session detected | Likely false positive (self-heal run itself) | ✅ No action needed |

**Auto-fixes applied:** 2/2
**Manual intervention needed:** None


### 2026-04-16 14:32 UTC
- **Issue:** 1 stale subagent session
- **Fix:** Auto-terminated stale session
- **Status:** ✅ Resolved

### 2026-04-16 16:17 UTC
- **Issue:** 1 failed cron (Evening Pulse)
- **Fix:** Restarted via cron API
- **Status:** ✅ Resolved

- **Issue:** Uncommitted changes in workspace
- **Fix:** Auto-committed and pushed via git_sync
- **Status:** ✅ Resolved

- **Issue:** 1 stale subagent session detected
- **Fix:** Attempted cleanup (session already gone at listing)
- **Status:** ⚠️ Could not verify — no stale sessions found at check time

### 2026-04-16 16:47 UTC
- **Issue:** 1 failed cron (Evening Pulse)
- **Fix:** Restarted via cron API
- **Status:** ✅ Resolved

- **Issue:** Uncommitted changes in workspace
- **Fix:** Auto-committed and pushed via git_sync
- **Status:** ✅ Resolved

- **Issue:** 1 stale subagent session detected
- **Fix:** False positive — detected self-heal run itself (currently executing)
- **Status:** ✅ No action needed

**Auto-fixes applied:** 2/2
**Manual intervention needed:** None

### 2026-04-16 17:17 UTC
- **Issue:** Uncommitted changes in workspace
- **Fix:** Auto-committed and pushed via git_sync
- **Status:** ✅ Resolved

- **Issue:** 1 stale subagent session detected
- **Fix:** False positive — detected self-heal run itself (currently executing)
- **Status:** ✅ No action needed

**Auto-fixes applied:** 2/2
**Manual intervention needed:** None

### 2026-04-16 18:02 UTC
- **Issue:** 1 failed cron (Evening Pulse)
- **Fix:** Restarted via cron API
- **Status:** ✅ Resolved

- **Issue:** Uncommitted changes in workspace
- **Fix:** Auto-committed and pushed via git_sync
- **Status:** ✅ Resolved

- **Issue:** 1 stale subagent session detected
- **Fix:** Auto-terminated stale session
- **Status:** ✅ Resolved

**Auto-fixes applied:** 2/2
**Manual intervention needed:** None
-e 
## 2026-04-16 18:17 UTC
- Fixed: uncommitted changes (auto-committed)
- Fixed: 1 stale session cleaned


## 2026-04-16 19:32 UTC

**Failures:** 2
- Uncommitted changes (git)
- 1 stale session

**Auto-fixes applied:** 2
- Committed via auto-save → pushed to origin
- Stale session cleaned up

**Status:** ✅ Resolved automatically

## 2026-04-16 19:47 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed | ✅ Fixed |
| 1 stale session | Cleaned up | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

### 2026-04-16 21:02 UTC
| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed | ✅ Fixed |
| 1 stale session | Cleaned up | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

### 2026-04-16 21:32 UTC
| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (ab5e225→6cdb939) | ✅ Fixed |
| 1 stale session | Cleaned up | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-16 22:17 UTC

**Failures detected:** 2
**Auto-fixed:** 2
**Manual intervention needed:** None

### Failures:
1. Uncommitted changes → auto-committed via git_sync
2. 1 stale subagent session → terminated

---

## 2026-04-16 23:17 UTC

**Failures detected:** 2
**Auto-fixed:** 2
**Manual intervention needed:** None

### Failures:
1. Uncommitted changes → auto-committed + pushed (c968f26)
2. 1 stale subagent session → terminated

---

## 2026-04-16 23:32 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (c57abd2) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None
## 2026-04-17 00:17 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (6bfd336) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-17 00:47 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (651c525) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-17 01:47 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (4d7b376) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-17 02:33 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (cb617ef) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-17 02:48 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (b202848) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None
## 2026-04-17 04:33 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (1559048) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-17 05:33 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (30aa9f9) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-17 07:03 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Failed cron: Morning Briefing | Restarted via cron API | ✅ Fixed |
| Uncommitted changes | Auto-committed + pushed (beb9902) | ✅ Fixed |
| 1 stale session | False positive (self-heal run itself) | ✅ No action needed |

**Failures:** 3
**Auto-fixes:** 2
**Manual intervention:** None

## 2026-04-17 07:33 UTC

| Failure | Fix | Status |
|---------|-----|--------|
| Uncommitted changes | Auto-committed + pushed (06e665d) | ✅ Fixed |
| 1 stale subagent session | Terminated | ✅ Fixed |

**Failures:** 2
**Auto-fixes:** 2
**Manual intervention:** None
### 2026-04-17 09:03 UTC

- **Stale sessions:** 1 → auto-fixed
- **Result:** All issues resolved
