# EXTERNAL RESEARCH — AI Agent Improvement Sources

## Sources Found

### 1. NousResearch/hermes-agent — "The agent that grows with you"
**URL:** github.com/NousResearch/hermes-agent
**What it does:** Self-improving agent with built-in learning loop

**Features I should copy:**
- **Agent-curated memory** — periodic nudges to remember important things
- **Autonomous skill creation** — creates new skills after complex tasks WITHOUT being asked
- **Skills self-improve during use** — learns what works
- **FTS5 session search** — full-text search across ALL past conversations
- **Honcho dialectic user modeling** — builds a model of the user over time
- **Multi-platform** — Telegram, Discord, Slack, WhatsApp, Signal + CLI

**How it works:**
```bash
hermes agent-curated memory    # agent nudges itself to remember
hermes skill create            # autonomous skill creation after complex tasks
hermes search "previous conversation about X"  # FTS5 cross-session recall
```

**What I can steal:**
1. FTS5 session search → implement as "session recall" tool
2. Autonomous skill creation → after complex tasks, I should CREATE skills without being asked
3. Periodic self-nudges → "did you remember to log X?"

---

### 2. VoltAgent/awesome-openclaw-skills — 5,200+ skills
**URL:** github.com/VoltAgent/awesome-openclaw-skills
**What:** Curated list of ClawHub skills (filtered spam, duplicates, low-quality)

**Categories relevant to me:**
- Self-improvement
- Memory systems
- Research automation
- Outreach
- Cron/scheduling
- Multi-channel messaging

**How to use:** Browse this list for new skills to install. Check every week.

---

### 3. zeroclaw-labs/zeroclaw — Rust OpenClaw alternative
**URL:** github.com/zeroclaw-labs/zeroclaw
**What:** Lightweight alternative (5MB RAM vs 55MB for OpenClaw)
**Status:** Early development
**Note:** Not ready to switch but the architecture is interesting

---

### 4. EvoMap/evolver — Self-evolution engine (already installed)
**URL:** github.com/EvoMap/evolver
**Status:** ✅ Already running nightly at 4am

---

### 5. awesome-openclaw-usecases — Jordan's collection
**URL:** github.com/hesamsheikh/awesome-openclaw-usecases
**What:** Community collection of OpenClaw workflows
**Status:** Already referenced in workspace

---

## Top 5 Improvements to Build (from external research)

| # | Improvement | Source | Effort |
|---|-------------|--------|--------|
| 1 | **FTS5 session search** — search all past conversations | hermes-agent | Medium |
| 2 | **Autonomous skill creation** — build skills after complex tasks | hermes-agent | Medium |
| 3 | **Weekly skill browser** — check awesome list for new skills | awesome-openclaw-skills | Low |
| 4 | **Memory nudges** — periodic reminders to log important things | hermes-agent | Low |
| 5 | **User model (Honcho)** — build a model of Jordan over time | hermes-agent | High |

---

## Next Actions

1. **This week:** Implement FTS5 session search — need to set up SQLite FTS5
2. **This week:** Build "autonomous skill creator" — after complex tasks, I create skills proactively
3. **Weekly:** Browse awesome-openclaw-skills for new improvements
4. **This month:** Explore Honcho integration for user modeling

---

_Last updated: 2026-04-02_
