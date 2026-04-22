# OpenClaw Mastery: How the Best Agents Get Better

## What Top Power Users Do Differently

Based on 200+ hours of research and real-world usage patterns.

---

## 1. SELF-IMPROVEMENT TECHNIQUES

### The 6-Factor Self-Improvement Flywheel
1. **Track** every interaction, error, and win
2. **Analyze** patterns in behavior
3. **Extract** insights from feedback
4. **Update** system prompts with learnings
5. **Validate** improvements work
6. **Repeat** continuously

### Dynamic Memory System
- Log errors and learnings to structured files
- Agent can reference past mistakes and avoid them
- User can correct and agent updates accordingly

### Structured Feedback Loop
- User corrects → Logged → Agent learns → Next time better
- Real-time adaptation without retraining

---

## 2. ARCHITECTURE PRINCIPLES

### Draw Before Building
Before creating agents, sketch:
- Agent graph (who calls who)
- Data flow (inputs → transforms → outputs)
- Decision points
- Human approval gates
- Failure cascades

### Single Responsibility Rule
- One agent = one task
- If you can't describe it in one sentence, it's doing too much
- Split into two agents with clear handoffs

### Parallelism First
- Independent tasks run concurrently
- 45-second serial → 20-second parallel
- Identify every sequential chain of independent tasks

---

## 3. MODEL ROUTING

### Tiered System
| Task | Model | Cost |
|------|-------|------|
| Routing, yes/no | Haiku/Flash | $0.001 |
| Summarization | Mid-tier | $0.01 |
| Complex reasoning | Frontier | $0.10+ |

### Dedicated Router Agent
- Single entry point for all tasks
- Assigns to appropriate model tier
- One place to change routing logic
- Fallback handling for model errors

---

## 4. TELEGRAM ORGANIZATION

### Use Topics (Threads)
Separate threads for:
- **Errors & Alerts** — Never muted
- **Completed Runs** — Summary of successes
- **Approvals** — Human decisions needed
- **Info** — Low-priority, check on schedule

### Message Template
```
[STATUS] Agent Name
Task: Brief description
Result: One-line outcome
Time: HH:MM:SS
```

---

## 5. SUB-AGENT HANDOFFS

### Structured Communication
- Use JSON for inter-agent communication
- Define explicit output schema in each prompt
- Validate before passing downstream

**Example:**
```
Should return:
{
  "summary": string,
  "confidence_score": number,
  "source_urls": array,
  "key_findings": array
}
```

### Idempotency
- Same input = same output (whether run once or 5 times)
- Check-before-write patterns
- Deduplication with timestamp + task ID

---

## 6. CRON RELIABILITY

### Stagger Schedules
**Bad:** All at :00 (rate limit hits)
**Good:** :00, :07, :15, :23, :34

### Retry Logic (4-part rule)
1. **Retry count:** 3 attempts
2. **Retry delay:** Exponential backoff (1s → 4s → 16s)
3. **Failure notification:** Telegram Errors thread
4. **Recovery behavior:** Fresh start vs pick up where left off

---

## 7. SECURITY PRACTICES

### Never Store Credentials in Prompts
- API keys → Environment variable store
- Reference by variable name in workflows
- Periodic audits of existing workflows

### Quarterly Permission Audit
For each agent ask:
- Does it need write access or just read?
- Is this API still used?
- Are credentials current?
- If compromised, what's the blast radius?

---

## 8. CACHING & OPTIMIZATION

### Cache Repeated Queries
- Daily report generation (same inputs)
- Repeated data classification
- Common lookup patterns
- Can reduce costs 30-50%

### Workflow-Level Caching
- Audit high-frequency workflows
- Identify repeated query patterns
- Set appropriate TTLs

---

## 9. WHAT ACTUALLY WORKS

From 200+ hours of real usage:

### DO:
- ✅ Write everything to files (not just memory)
- ✅ Git commit after significant changes
- ✅ Use sub-agents for parallel research
- ✅ Design architecture before building
- ✅ Single responsibility per agent
- ✅ Structured JSON for handoffs
- ✅ Stagger cron schedules
- ✅ Model routing by task complexity
- ✅ Separate Telegram threads
- ✅ Idempotent agent design

### DON'T:
- ❌ Install random ClawHub skills (review first)
- ❌ Hardcode credentials anywhere
- ❌ Run all crons at same time
- ❌ Let agents have more permissions than needed
- ❌ Skip retry logic on scheduled workflows
- ❌ Skip validation at handoff points

---

## 10. HOW TO APPLY THIS TO ME

### Immediate Changes (Today)
1. Add structured message template to Telegram
2. Set up retry logic on all cron jobs
3. Stagger my scheduled workflows
4. Document agent architecture in files

### This Week
1. Implement model routing for sub-agents
2. Add structured output schema to all handoffs
3. Set up idempotency checks
4. Create quarterly audit reminders

### This Month
1. Build dedicated research agent
2. Build dedicated drafting agent
3. Build validation agent
4. Full architecture diagram

---

## Resources Found

- Reddit r/openclaw (best practices)
- MindStudio 200-hour guide
- LennysNewsletter complete guide
- Composio top OpenClaw skills
- Self-improving agent skill (clawhub)

---

