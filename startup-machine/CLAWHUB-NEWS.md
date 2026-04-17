# ClawHub New Skills & News — Apr 16, 2026

## New Skills Found
| Skill | What it does | Install |
|-------|-------------|---------|
| **mvanhorn/last30days-skill** | Research any topic across Reddit, X, YouTube, HN, Polymarket & web — synthesizes grounded summary | `npx clawhub@latest install last30days` (if on ClawHub) |
| **kepano/obsidian-skills** | Teaches agent to use Obsidian Markdown, Bases, JSON Canvas, CLI | Clone from GitHub |
| **VoltAgent/awesome-openclaw-skills** | Curated collection of 5,400+ skills from official registry | N/A — browse at github.com/VoltAgent/awesome-openclaw-skills |
| **safishamsi/graphify** | Turn any folder of code, docs, papers, images, videos into queryable knowledge graph | Clone from GitHub |
| **1Panel-dev/1Panel** | VPS control panel with native OpenClaw agent support + Ollama | Clone from GitHub |

## Technique Improvements

### Hermes Agent Self-Improvement Loop (NousResearch)
Hermes creates skills from experience and self-improves them during use — OpenClaw doesn't have this native loop yet. The agent actively nudges itself to persist knowledge after complex tasks.
- **Status:** Not in OpenClaw core
- **Relevance:** Could inform capability-evolver skill design

### FTS5 Cross-Session Memory Search
Hermes has full-text search across all past conversations with LLM summarization for recall. OpenClaw memory is file-based (MEMORY.md, daily logs) but lacks FTS.
- **Status:** Not in OpenClaw core
- **Relevance:** gap — OpenClaw could benefit from semantic search of memory

### Voice Mode Real-Time
Hermes supports real-time voice in CLI, Telegram, Discord, Discord VC. OpenClaw has TTS capability (ElevenLabs) but not real-time voice receive.
- **Status:** Not in OpenClaw core
- **Relevance:** gap for voice interaction

### Daytona/Modal Serverless Backends
Hermes runs on serverless infra that hibernates when idle — near-zero cost when not in use. OpenClaw runs as a persistent daemon.
- **Status:** Not in OpenClaw core
- **Relevance:** potential cost optimization for Jordan's always-on setup

### MCP Integration Deep
Hermes connects to any MCP server with tool filtering. OpenClaw has MCP support too, but Hermes docs show richer patterns.
- **Status:** Both have it; Hermes docs more mature
- **Relevance:** good for extending both platforms

## Community Discoveries

### Hermes Agent Migration Path
`hermes claw migrate` imports OpenClaw config automatically — Jordan's OpenClaw setup is portable if he ever wants to try Hermes.

### CowAgent (WeChat alternative)
zhayujie/CowAgent is a lighter-weight alternative that runs on WeChat, Feishu, DingTalk, QQ — relevant if Jordan ever targets Chinese platforms.

### nanoclaw (containerized OpenClaw)
qwibitai/nanoclaw runs OpenClaw in Docker containers — security isolation, easier deployment. Alternative to bare-metal OpenClaw.

### zeroclaw / openfang (competing agent OS)
Two Rust-based agent operating systems: zeroclaw (fast/small) and openfang. Ecosystem is fragmenting toward Rust for performance-critical agent infra.

### OpenViking Context Database
volcengine/OpenViking builds a context database that unifies memory/resources/skills via filesystem paradigm — interesting for Jordan's multi-project memory needs.

### 1Panel VPS Control Panel
Modern VPS panel with native OpenClaw deployment + Ollama — if Jordan ever self-hosts on a VPS, this would simplify management significantly.

### Graphify Knowledge Graph
If Jordan wants to analyze his deals/projects/research as queryable graphs, graphify is the tool.

## Gap Analysis — What Axton is NOT doing

1. **Self-improving skills** — Hermes actively rewrites and creates skills from experience. Axton loads static skills but doesn't self-evolve them.
2. **Cross-session FTS** — No full-text search of conversation history. Memory is file-based and linear.
3. **Real-time voice** — Can send TTS audio but can't receive voice input.
4. **Serverless/idle hibernate** — Always-on daemon costs compute when idle. No Daytona/Modal-style cost optimization.
5. **DingTalk/Feishu/WeCom** — Not targeting Chinese platforms (CowAgent's strength).
6. **Atropos RL training** — Research-ready trajectory generation for training models — not relevant for Jordan but notable for the ecosystem.
7. **Hermes migration** — Axton has no import path from/to Hermes. `hermes claw migrate` works, but no reverse (OpenClaw importing Hermes skills).

## Action Items

- [ ] Consider installing **last30days-skill** for social/news research (fits Jordan's Neurotech/Maps content work)
- [ ] Explore **1Panel** if Jordan ever self-hosts OpenClaw on a VPS
- [ ] Evaluate **graphify** for deal/project knowledge graph (Dealsmap, PISCO, etc.)
- [ ] Document **hermes claw migrate** as an exit option — Jordan should know it's there
- [ ] Monitor Hermes Agent for voice mode and self-improvement loop features that could be ported to OpenClaw skills
- [ ] Track **nanoclaw** containerized deployment as potential alternative for secure/portable setup
