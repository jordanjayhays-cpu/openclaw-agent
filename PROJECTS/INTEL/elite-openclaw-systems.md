# Elite OpenClaw Systems — Research Summary

## 10 Elite OpenClaw Setups (What Makes Each Special + What to Copy)

---

### 1. Moltfounders Runbook — "Agent Prompts"
**Source:** moltfounders.com/openclaw-runbook/agent-prompts

**What makes it special:**
- 5 ready-to-use agent configurations (Monitor, Researcher, Communicator, Orchestrator, Coordinator)
- Cross-provider fallback chains (critical: Claude quotas exhaust by provider)
- Model tier selection guide matching complexity to cost

**Key insight:** Never use single-provider fallback chains. If Claude quota exhausts, ALL Claude models fail simultaneously. Always include a different provider as fallback.

**What to copy:**
```json
// Cross-provider fallback pattern
"primary": "anthropic/claude-sonnet-4-5",
"fallbacks": ["kimi-coding/k2p5", "synthetic/hf:zai-org/GLM-4.7", "openrouter/google/gemini-3-flash-preview"]
```

**Install it:** Copy agent .md files to `~/.openclaw/workspace/agents/` and register in openclaw.json

---

### 2. velvet-shark — "OpenClaw after 50 days: 20 real workflows"
**Source:** gist.github.com/velvet-shark/b4c6724c391f612c4de4e9a07b0a74b6

**What makes it special:**
- 20 production prompts used daily
- Discord-first interface, Obsidian vault for notes
- Morning briefing, maintenance cron, heartbeat checks, video research, code deployment

**What to copy:**
- **Heartbeat pattern:** Check email/calendar/services every 30 min, only alert if something needs action — no "all clear" spam
- **Morning briefing:** Twitter scan → top 10 → Obsidian summary → Discord push
- **Backup job:** 4:30am backup with secret-scanning before GitHub push
- **Email DRAFT-ONLY mode:** Read, classify, draft replies — NEVER send directly
- **VPS code deploy from mobile:** SSH → branch → PR → link back

**Prompt examples that work:**
- Morning briefing prompt (concise, 2-min coffee read)
- Deep research launch (parallel subagents per source)
- Maintenance update (cron + restart + error report)
- Heartbeat (30-min checks, severity levels)

---

### 3. hesamsheikh — "Awesome OpenClaw Use Cases" (34 use cases)
**Source:** github.com/hesamsheikh/awesome-openclaw-usecases

**What makes it special:**
- Only submit use cases verified to work for at least 1 day (no vaporware)
- 34 real-world use cases across 5 categories
- Security-conscious (warns about unvetted skills)

**What to copy (unimplemented use cases):**
| Use Case | Why It Matters | Setup Difficulty |
|---|---|---|
| Polymarket Autopilot | Prediction market paper trading, backtesting | Medium |
| Self-Healing Home Server | SSH + cron + auto-recovery at 3am | Medium |
| Second Brain (Supermemory) | Text anything → remember forever, search by context | Easy |
| Event Guest Confirmation | AI voice calls to confirm attendance | Medium |
| Pre-Build Idea Validator | Scan GH/HN/npm before building anything | Medium |
| Phone-Based Personal Assistant | Voice + SMS access from any phone | Easy |
| Family Calendar + Household | Morning briefing for all family members | Easy |
| Habit Tracker + Accountability | Daily check-ins, adapts tone based on your progress | Easy |
| arXiv Paper Reader | Read/analyze papers conversationally | Easy |
| LaTeX Paper Writing | Compile LaTeX conversationally, no local TeX needed | Easy |

---

### 4. Capability Evolver (35,000+ installs)
**Source:** ClawHub — most downloaded skill

**What makes it special:**
- Agent inspects own runtime history, finds failures, autonomously evolves its own code/memory
- Auto-log analysis + self-repair suggestions
- GEP/A2A protocol for reusable evolutionary assets

**What to copy:**
```
clawhub install capability-evolver
```

**Why it matters:** Only skill that makes the agent better over time without manual intervention. Most skills are static; this one is alive.

---

### 5. Self-Improving Agent (15,000+ installs, 132 stars — highest rated)
**Source:** ClawHub

**What makes it special:**
- Logs errors, learnings, user preferences into persistent memory
- Agent gets smarter with every interaction
- 3x more stars than any other skill

**What to copy:**
```
clawhub install self-improving-agent
```

**Insight:** Agents that remember context and adapt to your preferences are "dramatically more useful than stateless ones" (community consensus)

---

### 6. Growexx Top 10 Skills List
**Source:** growexx.com/blog/top-10-popular-openclaw-skills

**What makes it special:**
- Security ratings for every skill (✅ verified / ⚠️ review required)
- Download counts + API key requirements

**Priority install order:**
1. **Capability Evolver** (35K) — self-optimization, no API key
2. **Self-Improving Agent** (15K) — memory + personalization, no API key
3. **GOG** (14K) — Google Workspace (Gmail, Calendar, Drive, Sheets, Docs)
4. **Agent Browser** (11K) — Rust headless browser, web automation
5. **GitHub Integration** (10K) — issues, PRs, CI/CD via gh CLI
6. **Summarize** (10K) — text summarization, no API key
7. **Tavily Search** (9K) — AI-optimized web search
8. **N8N Workflow** (8K) — multi-app automation
9. **Obsidian** (8K) — local vault, no network calls
10. **ElevenLabs Agent** (7K) — voice calls + failsafe

**Security rule:** Start with bundled skills (53 ship out of box, zero registry risk). Only install from ClawHub after reading source code.

---

### 7. Multiagent Best Practices (dev.to)
**Source:** dev.to/operationalneuralnetwork/openclaw-multiagent-best-practices

**What makes it special:**
- 6 interlocking strategies for multiagent architecture
- 40-60% token reduction via proper decomposition
- Token efficiency, progress tracking, error handling patterns

**What to copy:**
```json
// openclaw.json multiagent config
{
  "agents": {
    "orchestrator": { "maxChildrenPerAgent": 5, "maxSpawnDepth": 2 },
    "researcher": { "model": "openrouter/mimo/v2-flash", "maxTokens": 3000 },
    "writer": { "model": "openrouter/minimax/minimax-m2.5", "maxTokens": 2500 }
  },
  "session": { "maintenance": { "mode": "enforce", "pruneAfter": "24h", "maxEntries": 100 } }
}
```

**Key patterns:**
- Subagents for parallel execution
- Token management: compact sessions, trim large tool outputs, smaller images
- Heartbeat interval shorter than cache TTL (e.g., 55 min for 1-hour Anthropic cache)
- Session pruning to prevent unbounded growth

---

### 8. OpenClaw.rocks "34 Use Cases" Deep Dive
**Source:** openclaw.rocks/blog/openclaw-use-cases

**What makes it special:**
- Pattern analysis: most valuable use cases share 3 properties
- They’re always on, they handle mundanes, they route across multiple systems

**The #1 pattern:**
> "Most valuable ones are always on. Not something you open when you remember. The agent runs continuously in the background, waiting for triggers."

**What to copy:**
- Heartbeat protocol (9am-6pm proactive checks)
- Multi-channel routing (Telegram + WhatsApp + email + calendar from single interface)
- Todoist transparency (agent logs reasoning + execution to tasks)

---

### 9. n8n Workflow Orchestration
**Source:** ClawHub skill by KOwl64

**What makes it special:**
- Agent delegates API calls to visual n8n workflows
- Agent never touches credentials — clean separation
- Every integration is visual and lockable

**What to copy:**
```
clawhub install n8n-workflow-automation
```

**Why it matters:** You get complex multi-app automations without writing custom integrations. n8n handles the workflow execution, OpenClaw handles the decision-making.

---

### 10. Personal CRM (Email + Calendar skill combo)
**Source:** ClawHub (0xterrybit/email + 0xterrybit/calendar)

**What makes it special:**
- Agent automatically discovers and indexes contacts
- Natural language query: "When did I last talk to Sarah about the partnership?"
- Tracks every interaction automatically

**What to copy:**
```
clawhub install email
clawhub install calendar
```

**The magic:** Instead of you remembering what you discussed, the agent remembers for you.

---

## Top 5 Things Beginners Miss That Pros Do

1. **Cross-provider model fallbacks** — Single-provider chains fail completely when quota exhausts
2. **Capability Evolver** — Most people install utility skills; few install the self-improving meta-skill
3. **Heartbeat protocol** — Beginners only respond; pros proactively check email/calendar/services on schedule
4. **Session pruning** — Session stores grow unbounded; pros enforce pruneAfter + maxEntries
5. **Draft-only email mode** — Pros read + classify + draft; never send directly (prompt injection + accountability)

---

## Security Non-Negotiables (from all sources)

- Read skill source code before installing
- Check VirusTotal scan on ClawHub pages
- Never hardcode API keys — use env vars or placeholders
- Run untrusted skills in Docker sandbox
- Start with bundled skills (53 ship with OpenClaw)
