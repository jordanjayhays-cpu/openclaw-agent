# Potential Integrations for OpenClaw

## What the Elite Connects (Ranked by Downloads/Popularity)

### Tier 1 — Critical Foundation (15K+ downloads, no API key needed)

| Integration | Downloads | Skill | What It Does | Effort |
|---|---|---|---|---|
| **Capability Evolver** | 35K | capability-evolver | Agent self-optimization via runtime analysis | Install only |
| **Self-Improving Agent** | 15K | self-improving-agent | Logs errors/preferences to persistent memory | Install only |
| **Summarize** | 10K | summarize | Text/article summarization, no API key | Install only |
| **Obsidian** | 8K | obsidian | Local vault read/write, no network calls | Install only |
| **GitHub (gh CLI)** | 10K | github | Issues, PRs, CI/CD via official gh auth | Install + auth |

### Tier 2 — High Value (8K-14K downloads)

| Integration | Downloads | Skill | What It Does | Effort |
|---|---|---|---|---|
| **Google Workspace (GOG)** | 14K | gog | Gmail, Calendar, Drive, Sheets, Docs unified | OAuth setup |
| **Agent Browser** | 11K | agent-browser | Rust headless browser, web automation | Install only |
| **Tavily Search** | 9K | tavily-search | AI-optimized web search | API key needed |
| **N8N Workflow** | 8K | n8n-workflow-automation | Multi-app automation | Local N8N instance |
| **ElevenLabs Agent** | 7K | elevenlabs-agent | Voice calls + failsafe | API key needed |
| **Todoist** | varies | todoist-cli | Task management with execution transparency | API key |

### Tier 3 — Domain Specific (4K-8K downloads)

| Integration | Downloads | Skill | What It Does | Effort |
|---|---|---|---|---|
| **Reddit** | varies | reddit | Browse/search Reddit for research | OAuth |
| **X/Twitter** | varies | x-twitter | Post, reply, like, retweet, DM, analytics | OAuth |
| **YouTube API** | varies | youtube-api-skill | Channel analytics, video management | OAuth |
| **Vapi AI** | varies | vapi | Phone/SMS voice access | API key |
| **Stock Market Pro** | varies | stock-market-pro | Earnings reports, automated alerts | API key |
| **Polymarket** | varies | polymarket-odds | Prediction market odds + events | API key |
| **arXiv** | varies | arxiv-paper-reader | Paper fetch, browse, AI summaries | Install only |

---

## What the Elite Connects (Use Case Pattern Analysis)

From 34 real-world use cases, the most common integrations:

### Information & Research
- Web search (Tavily/Brave Search)
- Reddit + Twitter (pain point mining)
- Hacker News (trend detection)
- YouTube (transcripts, analytics)
- RSS feeds (109+ sources for tech news)
- Wikipedia API (historical events)

### Productivity & Communications
- Google Workspace (Gmail, Calendar, Drive)
- Email (multiple providers)
- Telegram / WhatsApp / Discord (messaging)
- Notion / Obsidian (knowledge bases)
- Todoist (task tracking)

### Business & Data
- GitHub (code, CI/CD, issue management)
- n8n (multi-app workflow automation)
- Linear / Jira / Todoist (project management)
- Coolify (self-hosted infrastructure)
- Stripe / payment APIs (earnings tracking)

### Voice & Physical World
- Vapi AI (phone/SMS access)
- ElevenLabs (voice calls)
- Email failsafe → voice call escalation

### Content Creation
- YouTube API (analytics, content pipeline)
- Podcast production (guest research, show notes)
- Image generation (stable diffusion, DALL-E)

---

## What We Haven't Implemented (Opportunity Gap)

Based on the awesome-openclaw-usecases and ClawHub analysis:

### High Value, Not Yet in Our Setup
1. **Supermemory** — Text anything, remember forever, search by context
2. **Chromadb Memory** — Vector-powered semantic search over your notes
3. **Personal CRM** — Email + Calendar auto-discovers and tracks contacts
4. **Morning Email Rollup** — Replaces 47 newsletters with 1 Sunday digest
5. **Habit Tracker + Accountability** — Proactive daily check-ins, adapts tone
6. **Phone-Based Personal Assistant** — Voice access from any phone (Vapi)
7. **Family Calendar** — WhatsApp group chat with family calendar
8. **Polymarket Autopilot** — Prediction market paper trading
9. **Pre-Build Idea Validator** — Scan GH/HN/npm before building
10. **LaTeX Paper Writing** — Compile LaTeX conversationally

### Integrations We Should Prioritize for Jordan's Projects

| Jordan's Project | Relevant Integrations |
|---|---|
| **PISCO** (Filipino staff placement) | WhatsApp, Email, Calendar, CRM, Notion |
| **COMARE** (maintenance) | GitHub, n8n, Telegram, Coolify, self-healing |
| **Dealsmap** | Google Sheets, Email, Notion, web scraping |
| **IE Student Life** | Google Calendar, Gmail, Todoist, Reddit |

---

## Easy Wins (Install + Done)

These require zero API keys or complex setup:

```
# Install in one command each
clawhub install capability-evolver
clawhub install self-improving-agent
clawhub install summarize
clawhub install obsidian
clawhub install github
clawhub install todoist-cli
clawhub install proactive-agent
clawhub install brave-search
clawhub install reddit
```

---

## Security Vetting Rules (Before Installing Any Integration)

1. **Read the SKILL.md first** — It's plain text, takes 2 minutes
2. **Check requested permissions** — Does this skill need access it's asking for?
3. **VirusTotal scan** — Every ClawHub page has one now
4. **Author verification** — @steipete (creator) = first-party trust
5. **Docker sandbox** — Run unvetted skills in isolated containers
6. **No hardcoded API keys** — Use environment variables
7. **Start bundled** — 53 skills ship with OpenClaw, zero registry risk

---

## Integration Complexity Scale

| Level | Effort | Examples |
|---|---|---|
| **Zero-config** | Install + enable | Summarize, Obsidian, GitHub (gh CLI) |
| **OAuth only** | Authenticate once | Google Workspace, Reddit, Twitter |
| **API key** | Get + store key | Tavily, ElevenLabs, Vapi, Polymarket |
| **Self-hosted** | Run own infrastructure | n8n, local Chromadb, Coolify |
| **Custom build** | Write SKILL.md | Any proprietary API or internal tool |

---

## Recommended Priority Order for Jordan

1. `capability-evolver` — Self-improving agent (most impactful, zero config)
2. `self-improving-agent` — Memory + personalization (35K others can't be wrong)
3. `google-calendar` + `email` — Already has Google integration
4. `todoist-cli` — Task transparency (know what agent decided + why)
5. `proactive-agent` — Scheduled delivery (morning briefings, reminders)
6. `supermemory` or `chromadb-memory` — Second brain capability
7. `notion-sync` — Already in our skills
8. `n8n-workflow-automation` — Multi-app automation
9. `vapi` — Phone voice access for hands-free operation
10. `polymarket-odds` — If interested in prediction markets
