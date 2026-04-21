# OpenClaw Best Practices — Compiled from Reddit, Twitter, Medium & Community
**Date:** April 21, 2026  
**Sources:** Felo search, Reddit r/openclaw, r/AskClaw, Medium, Twitter/X, Facebook groups

---

## 🔥 THE 7 HARD-WON LESSONS (From Medium - Mikhail Shcheglov)

### 1. Use Tiered Model Routing
**Stop feeding everything to your best model.**

Heartbeat checks, cron jobs, routine status pings don't need Claude Sonnet. They need cheap, reliable tool calls.

| Task Type | Model |
|----------|-------|
| Heartbeats, status pings | Haiku, Gemini Flash, local Ollama |
| Complex reasoning | Claude Sonnet/Opus |

**Result:** Token costs dropped from 20,000-40,000 down to ~1,500 per request.

---

### 2. Build Guardrails with Custom SKILL.md Files
Out of the box, OpenClaw loops, repeats, loses context. The fix: custom skill instructions.

**Effective guardrails include:**
- Anti-looping rules (break when repeating)
- Compaction summaries (condense long conversations)
- Task checkpoints (validate before escalating)

**Priority:** workspace skills > local skills > bundled defaults

---

### 3. Background Work Needs Cron Jobs, Not Open Chat
**A common misconception:** Ask OpenClaw to work, close chat, assume it continues.

**Reality:** Sessions are stateful only while connection is open.

**Real background automation:**
- Use OpenClaw's built-in cron scheduler
- Configure isolated session targets
- For deferred tasks → use a task queue (Notion DB, SQLite, or text file)

---

### 4. Integrate ONE Workflow End-to-End First
Don't set up email, calendar, Telegram, scraping all at once.

**Proven approach:**
1. Pick ONE complete workflow
2. Make it work perfectly from trigger to delivery
3. ONLY then add the next integration

---

### 5. Treat Every Workflow as a Product
Emit a small JSON summary for each run:
```json
{"status": "success", "duration": "2.3s", "key_outputs": {...}}
```

Review weekly. Find patterns. Improve.

---

### 6. Tiered Memory Architecture
Don't dump everything into every request.

**Memory layers:**
- Short-term: current session context
- Medium-term: today's notes (memory/YYYY-MM-DD.md)
- Long-term: MEMORY.md curated lessons

Pass only what each task needs. Summarize long context.

---

### 7. Don't Blindly Install ClawHub Skills
Evaluate each skill before adding. Ask:
- Does it conflict with existing skills?
- What's the token cost per run?
- Is it maintained/updated?

---

## 📱 REDDIT COMMUNITY TIPS (r/openclaw, r/AskClaw)

### From r/AskClaw - "How to Make OpenClaw Powerful"
1. **Memory flush before compaction** — don't let context get stale
2. **Route tasks to the right model** — tiered routing (see lesson 1)
3. **Install the Last 30 Days skill** — for memory management
4. **Brain dump full context upfront** — set expectations clearly

### From r/openclaw - Automation Patterns
- **File-backed queue/todo** — not just chat memory
- **Cron/heartbeat to re-check** — progress on a timer
- **Hard stops** — prevent infinite loops
- **One narrow repo task at a time** — focus wins

### From r/openclaw - Local AI Agents (M2 Mac)
- Ollama for local models reduces API costs
- 16GB enough for basic agent tasks
- Docker containerization recommended

---

## 🐦 TWITTER/X COMMUNITY INSIGHTS

### Top Tips from Twitter/X
- Use tiered model routing (cost savings)
- Self-hosted = more control + privacy
- OpenClaw crossed 200,000 GitHub stars (Feb 2026)
- Multi-agent orchestration for complex tasks
- WhatsApp + Telegram integration = 24/7 availability

### Real Use Cases Shared on Twitter
- Morning briefing delivered to WhatsApp
- Inbox zero on autopilot
- Social media scheduling + posting
- Automated travel research
- Flight check-ins

---

## 📋 FACEBOOK GROUP (OpenClaw Users)

### Workflow Optimization Tips
- **Treat workspace as long-term project memory**
  - Include: project structure, coding style, common commands, naming conventions
- **Automation as mindset, not a tool**
  - Think: what do I do repeatedly? Automate it.
- **Start small, iterate**
  - 2-Agent system (Supervisor + Worker) → expand gradually

---

## 🚀 POWER USER WORKFLOW (From Medium - Mohit15856)

### The 5 Workflows That Actually Changed How People Work
1. **Morning Briefing** — daily digest to WhatsApp/Telegram
2. **Inbox Management** — email parsing + action routing
3. **Social Scheduler** — content queue → auto-post
4. **Research Agent** — web search → summarization → save to Notion/GitHub
5. **Calendar Commander** — natural language → calendar events

### Setup Priorities
1. Telegram or WhatsApp connection (your primary channel)
2. Memory system (today's notes + long-term MEMORY.md)
3. One cron job (morning briefing or heartbeat check)
4. THEN add complex workflows

---

## 💡 ACTIONABLE ADVICE FOR JORDAN (Axton)

### Do These Now:
1. [ ] Set up tiered model routing (Kimi for simple, Sonnet for complex)
2. [ ] Install "Last 30 Days" skill for memory management
3. [ ] Configure morning briefing cron job
4. [ ] Create ONE complete workflow before adding more

### Jordan's Current Setup:
- ✅ Telegram bot connected (primary channel)
- ✅ GitHub set up (backup + research)
- ✅ n8n cloud instance (workflow automation)
- ✅ OpenRouter API (Kimi model)
- ⚠️ Google Calendar (needs OAuth fix)
- 📝 Notion API key available (alternative calendar)

### Recommended Next Steps:
1. **Skip Google Calendar OAuth** — use Notion instead
2. **Build Research Bot workflow** — one working thing
3. **Set up morning briefing** — cron job to Telegram
4. **Add tiered routing** — reduce costs

---

## 📊 TOP 10 OPENCLAW AUTOMATIONS (From GAI Perks)

1. Inbox Zero on Autopilot
2. Morning Briefing to WhatsApp
3. Social Media Scheduling
4. Automated Travel Research
5. Calendar Management
6. Meeting Notes Auto-Capture
7. Task Queue with Cron Checking
8. Background Research Agent
9. Email Digest Summarization
10. CRM Update Automation

---

## 🎯 THE GOLDEN RULES

1. **ONE workflow at a time** — get it working, then expand
2. **Tiered model routing** — save tokens, use right model for right task
3. **Cron jobs for background** — not open chat windows
4. **Guardrails in SKILL.md** — prevent loops and context loss
5. **Memory in layers** — short/medium/long-term separation
6. **Review weekly** — JSON summaries help find patterns
7. **Self-host if possible** — more control, better privacy

---

*Compiled by Axton (OpenClaw Agent) on April 21, 2026*
*Sources: Reddit, Twitter/X, Medium, Facebook groups, community discussions*
