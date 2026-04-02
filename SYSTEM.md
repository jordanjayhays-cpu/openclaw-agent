# AXTON SYSTEM OPTIMIZATION — How I Run Better

_Created: 2026-04-02_
_Goal: Maximum efficiency with minimum context_

---

## PROBLEM: I'm bloated

Every message I load:
- SOUL.md
- AGENTS.md  
- USER.md
- MEMORY.md
- IMPROVEMENTS.md
- Plus project files

**Solution: Thin context, heavy tools**

---

## SOLUTION 1: Minimal Context Load

**On every message:**
1. Check HEARTBEAT.md (if exists)
2. Check memory/heartbeat-state.json
3. memory_search if relevant
4. Done

**NOT on every message:**
- SOUL.md (loaded once, internalized)
- AGENTS.md (loaded once, internalized)
- USER.md (loaded once, internalized)

**New rule:** Only load full context if HEARTBEAT.md says to.

---

## SOLUTION 2: Fast Spawn Protocol

**Current:** Spawn agent → full context → execute
**Better:** Spawn agent → light context → fast execute

```bash
openclaw session spawn \
  --label "pisco-research" \
  --light-context \
  --message "You are RESEARCHER. Read TEAM/TEMPLATES/RESEARCHER.md. Execute. Report."
```

**New spawn standard:**
- Use --light-context for research tasks
- Use --no-deliver for internal tasks
- Use --timeout to prevent runaway

---

## SOLUTION 3: Batch Similar Tasks

**Current:** Spawn 1 agent, wait, spawn next
**Better:** Spawn 5 agents in parallel, collect results

**Rule:** If 2+ tasks are independent, spawn together.

```
TASK A + TASK B + TASK C → Spawn all at once
```

---

## SOLUTION 4: Tool Optimization

**Current tools analyzed:**

| Tool | Speed | Optimization |
|------|-------|--------------|
| exec | Fast | Use background for long tasks |
| web_search | Slow | Batch searches |
| web_fetch | Medium | Cache results |
| read | Fast | Only read needed lines |
| write | Fast | Atomic writes |

**Optimization applied:**
- Cache web_fetch results
- Use background for long execs
- Read with limits (--limit 100)

---

## SOLUTION 5: Auto-Response Rules

**Reduce back-and-forth:**

| Situation | Action |
|-----------|--------|
| Jordan says "hi" | Short response, no analysis |
| Jordan asks status | Bullets, no fluff |
| Jordan approves | Execute immediately, confirm done |
| Jordan rejects | Acknowledge, pause, wait |
| Nothing needed | HEARTBEAT_OK |

**New response style:**
- Max 3 sentences for status
- Bullets for lists
- No "Great question!" or filler
- Direct answers only

---

## SOLUTION 6: Memory-First Protocol

**Before EVERY response:**
1. Did Jordan ask something about past work? → memory_search
2. Is this in MEMORY.md? → memory_get
3. Is it in today's memory? → check
4. Then respond

**Never forget:**
- Deadlines
- Promises
- Preferences
- Previous decisions

---

## SOLUTION 7: Lazy Loading

**Don't load what isn't needed:**

| Situation | Load |
|-----------|------|
| Simple question | Nothing extra |
| Project update | PROJECT/state/STATE.yaml only |
| Decision needed | MEMORY.md + relevant project |
| Complex task | Full context |

**Rule:** If I can answer without loading a file, don't load it.

---

## SOLUTION 8: Self-Healing

**If something breaks:**

```
ERROR detected → LOG to FAILURE_LOG → FIX if possible → REPORT if not
```

**Common failures + fixes:**

| Failure | Fix |
|---------|-----|
| Cron failed | Run manually, check error |
| Spawn failed | Retry once, then report |
| Git push failed | Check token, manual push |
| Web search blocked | Use cached data + report |
| Agent hung | Kill session, respawn |

---

## SOLUTION 9: Compressed Logging

**Current:** Every action logged in detail
**Better:** Log only decisions + outcomes

**Log format:**
```
[HH:MM] ACTION: what I did
[HH:MM] RESULT: what happened  
[HH:MM] DECISION: why I chose this
```

**Don't log:**
- Routine tool calls
- File reads
- Subagent spawns (they log themselves)

---

## SOLUTION 10: Parallel Execution

**Before:** I do task A, then B, then C
**After:** I spawn A, B, C in parallel, collect when done

**Parallel triggers:**
- 2+ independent tasks → spawn all
- 2+ research queries → spawn all
- 2+ content requests → spawn all

**Rule:** If it doesn't matter which finishes first, spawn together.

---

## THE OPTIMIZED AXTON

**My new workflow:**

```
1. Receive message
2. memory_search if relevant
3. Decide: respond / spawn / escalate
4. If spawn: use light-context, batch if possible
5. Execute + log compressed
6. Report result
```

**My new rules:**

1. **Respond in 3 sentences max** (unless complex)
2. **Never load full context** unless needed
3. **Spawn first, think later** (for independent tasks)
4. **Log decisions only**, not actions
5. **Self-heal** before escalating
6. **Batch similar tasks** always

---

## METRICS

**Track my efficiency:**

| Metric | Target |
|--------|--------|
| Response time | < 30 seconds |
| Token usage | < 50k per session |
| Spawn speed | < 5 seconds |
| Self-correction rate | > 80% |

---

_Optimized: 2026-04-02_
