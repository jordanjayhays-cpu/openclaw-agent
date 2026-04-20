# Weekly Skill Scout — April 20, 2026

## Overview
Scouted [VoltAgent/awesome-openclaw-skills](https://github.com/VoltAgent/awesome-openclaw-skills) focusing on self-improvement, memory, research, and automation. Found 5 skills worth installing.

---

## 1. agent-brain

**URL:** https://clawskills.sh/skills/dobrinalexandru-agent-brain  
**GitHub:** https://github.com/openclaw/skills/tree/main/skills/dobrinalexandru/agent-brain

**What it does:**  
Local-first persistent memory for AI agents using SQLite storage. Uses orchestrated retrieve/extract loops with hybrid search to manage long-term memory.

**Why useful:**  
Jordan's memory system is file-based (MEMORY.md, daily logs). agent-brain adds a proper SQLite-backed memory layer — faster queries, structured storage, and hybrid retrieval without losing the existing file-based approach. Complements the existing memory stack.

**How to install:**
```bash
openclaw skills install dobrinalexandru/agent-brain
# or
npx clawhub@latest install dobrinalexandru/agent-brain
```

---

## 2. active-maintenance

**URL:** https://clawskills.sh/skills/xiaowenzhou-active-maintenance  
**GitHub:** https://github.com/openclaw/skills/tree/main/skills/xiaowenzhou/active-maintenance

**What it does:**  
Automated maintenance cycle: disk usage monitoring, temp file cleanup, and memory deduplication. Distills dense notes into core insights ("memory metabolism"). Logs every cycle to MEMORY/DECISIONS/ for auditability.

**Why useful:**  
Jordan runs heavy research tasks and multiple projects. This skill keeps the workspace healthy automatically — clears temp files after big workloads, deduplicates fragmented memory entries, and condenses verbose notes. Less manual cleanup, more reliable agent performance.

**How to install:**
```bash
openclaw skills install xiaowenzhou/active-maintenance
# or
npx clawhub@latest install xiaowenzhou/active-maintenance
```

---

## 3. arc-memory-pruner

**URL:** https://clawskills.sh/skills/trypto1019-arc-memory-pruner  
**GitHub:** https://github.com/openclaw/skills/tree/main/skills/trypto1019/arc-memory-pruner

**What it does:**  
Prunes and compacts agent memory files to prevent unbounded growth. Enforces line limits, rotates log directories via circular buffer, removes stale state entries by date. Includes dry-run mode to preview changes.

**Why useful:**  
Jordan's daily logs and memory files will grow over time. This skill prevents memory bloat — trim wake-state files, rotate old logs, remove outdated entries. Dry-run mode means Jordan can review before any deletion.

**How to install:**
```bash
openclaw skills install trypto1019/arc-memory-pruner
# or
npx clawhub@latest install trypto1019/arc-memory-pruner
```

---

## 4. agent-deep-research

**URL:** https://clawskills.sh/skills/24601-agent-deep-research  
**GitHub:** https://github.com/openclaw/skills/tree/main/skills/24601/agent-deep-research

**What it does:**  
Runs deep research queries through Google Gemini's research API. Supports grounding queries in local files via RAG (upload to ephemeral file search stores). Works across Claude Code, Amp, Codex, and Gemini CLI.

**Why useful:**  
Jordan researches markets, tools, and business opportunities for his multiple ventures (PISCO, COMARE, Neurotech, etc.). This skill supercharges research with Gemini's deep research mode — grounded in Jordan's local files (contacts, notes, project docs). No separate CLI needed.

**How to install:**
```bash
openclaw skills install 24601/agent-deep-research
# or
npx clawhub@latest install 24601/agent-deep-research
```
**Note:** Requires `GOOGLE_API_KEY`, `GEMINI_API_KEY`, or `GEMINI_DEEP_RESEARCH_API_KEY` env var.

---

## 5. honcho-setup

**URL:** https://clawskills.sh/skills/ajspig-honcho-setup  
**GitHub:** https://github.com/openclaw/skills/tree/main/skills/ajspig/honcho-setup

**What it does:**  
Installs @honcho-ai/openclaw-honcho plugin and migrates legacy workspace memory files to Honcho cloud storage. Uploads USER.md, MEMORY.md, IDENTITY.md, memory/, canvas/ files. Requires explicit user confirmation before upload, archives originals locally first.

**Why useful:**  
Jordan wants "systems that work without him." Honcho cloud memory means Jordan's agent retains full context even across device changes or restarts. Migration is safe — files are archived before upload. Gives Jordan persistent cross-session memory without relying on local files alone.

**How to install:**
```bash
openclaw skills install ajspig/honcho-setup
# or
npx clawhub@latest install ajspig/honcho-setup
```
**Note:** Requires `HONCHO_API_KEY` from https://app.honcho.dev (free tier available). Self-hosted option also supported.

---

## Priority Recommendation

| Rank | Skill | Why First |
|------|-------|-----------|
| 1 | **active-maintenance** | Zero-friction win — runs in background, keeps everything clean |
| 2 | **arc-memory-pruner** | Prevents the slow memory bloat problem Jordan will hit eventually |
| 3 | **agent-deep-research** | Directly accelerates Jordan's #1 activity: researching ventures |
| 4 | **agent-brain** | Next-level memory for multi-project context retention |
| 5 | **honcho-setup** | Best for cross-device/multi-session continuity |
