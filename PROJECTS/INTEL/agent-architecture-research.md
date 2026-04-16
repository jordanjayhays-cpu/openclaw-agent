# Agent Architecture Research — How Axton Can Create Other Agents

_Created: 2026-04-16_
_Purpose: Multi-agent spawning patterns, self-improvement, and implementation guide_

---

## EXECUTIVE SUMMARY

Axton (OpenClaw agent) can already spawn sub-agents. This document research shows:
- **Multi-agent hierarchies work** — LangChain Deep Agents, CrewAI, AutoGen all use spawning
- **OpenClaw supports spawning** — via `openclaw session spawn` CLI
- **Recursive spawning (agent spawning agent) is possible** with proper template setup
- **File-based communication is the key** — agents share context via files, not memory

---

## PART 1: MULTI-AGENT ARCHITECTURES (Industry Research)

### LangChain Deep Agents

LangChain's Deep Agents SDK explicitly supports **subagent spawning**:

```
Key feature: "A built-in task tool enables agents to spawn specialized subagents for context isolation."
```

**Pattern:**
- Main agent has a `task` tool
- Call `task(tool_or_subagent)` to spawn
- Subagent runs in same context but isolated
- Results returned to parent

**Why it works:**
- Virtual filesystem for context management
- Automatic summarization of long conversations
- Subagents inherit permissions from parent

### CrewAI

CrewAI uses **hierarchical process** for agent teams:

```python
crew = Crew(
    agents=[researcher, analyst, executor],
    tasks=[task1, task2, task3],
    process=Process.hierarchical
)
```

**Key concepts:**
- **Agents**: Have roles, goals, tools
- **Tasks**: Assigned to agents, can depend on other tasks
- **Crew**: Orchestrates execution order
- **Hierarchical**: Manager agent delegates to subordinates

**Communication:**
- Tasks have `context` parameter — output of prior tasks becomes input
- Sequential (ordered) or Hierarchical (manager-led)

### AutoGen

AutoGen has **group chat** pattern:

```python
groupchat = GroupChat(
    agents=[assistant1, assistant2, assistant3],
    messages=[],
    max_round=10
)
```

**Communication patterns:**
- **Conversational**: Agents send messages to each other
- **Group chat**: Multi-agent discussion with admin
- **Custom**: Build custom topologies

**Key insight**: AutoGen is event-driven — agents react to messages, don't poll.

---

## PART 2: OPENCLAW-SPECIFIC CAPABILITIES

### How OpenClaw Spawns Agents

Based on existing tools in `/data/workspace/tools/`:

```bash
# Single agent spawn
openclaw session spawn \
  --name "researcher-1" \
  --label "researcher" \
  --cwd /data/workspace \
  --message "You are a researcher. Research topic X." \
  --timeout-seconds 3600

# With subagent yield (agent pauses, waits for result)
openclaw session spawn --yield ...
```

### What Already Works

1. **Parallel spawning** — `batch_spawn.sh` spawns multiple agents in background
2. **Template-based agents** — `agent_factory.sh` creates from SOUL.md templates
3. **File-based memory** — Agents read/write STATE.yaml files
4. **Recursive spawning** — Tested, works (subagent can spawn sub-subagent)
5. **Cron scheduling** — Agents can be scheduled

### OpenClaw Limits

1. **Memory doesn't persist between sessions** — Files are the persistence layer
2. **No built-in agent-to-agent messaging** — Use files instead
3. **Context window shared** — Each agent has its own window
4. **No shared state by default** — Must use shared files

---

## PART 3: SELF-IMPROVING SYSTEMS

### Capability-Evolver Pattern

From `/data/workspace/skills/capability-evolver/`:

```
1. Log execution history → memory/
2. Analyze patterns → identify failures
3. Write improvements → source code or configs
4. Solidify (git commit) → becomes permanent
```

**Key insight:** Self-improvement requires:
- Audit trail (what failed)
- Mutation rules (don't break everything)
- Rollback capability (git reset)
- Human review option (--review flag)

### Self-Replication Concept

From `/data/workspace/SELF_REPLICATION.md`:

```
L0: Supreme (Axton) — spawns L1
L1: Project Lead (PISCO Agent) — spawns L2
L2: Specialist (RESEARCHER) — spawns L3
L3: Worker (DATA-COLLECTOR) — no spawning
```

**Self-replication checklist:**
- [x] SOUL.md system (identity)
- [x] STATE.yaml system (project state)
- [x] Multi-agent spawning
- [x] TEMPLATES/ directory
- [ ] Self-improvement loop active
- [ ] Agent factory script
- [ ] Weekly soul update

---

## PART 4: AGENT TEMPLATES & FACTORIES

### Template System (Already Implemented)

Location: `/data/workspace/TEAM/TEMPLATES/`

| Template | Purpose | Spawns |
|----------|---------|--------|
| RESEARCHER | Find info, synthesize | DATA-COLLECTOR |
| ANALYST | Data analysis, CRM | None |
| OUTREACH | Cold email, LinkedIn | FOLLOW-UP |
| BUILDER | HTML, docs, systems | None |
| CREATOR | Content, posts | None |
| ENRICHER | Data enrichment | None |
| MONITOR | Watch metrics | None |
| NURTURER | Follow-up sequences | None |
| SALES | Close deals | None |
| SCHEDULER | Calendar management | None |

### Agent Factory Script

```bash
# Usage
bash tools/agent_factory.sh [PROJECT] [TYPE]

# Example
bash tools/agent_factory.sh piscoskills researcher
```

**What it does:**
1. Reads TEMPLATES/[TYPE].md
2. Copies to TEAM/[PROJECT]/SOUL.md
3. Creates/updates PROJECTS/[PROJECT]/state/STATE.yaml
4. Spawns the agent via `openclaw session spawn`

---

## PART 5: COMMUNICATION BETWEEN AGENTS

### File-Based Communication (Preferred)

**Best pattern for OpenClaw:**

```
Parent Agent
  → Spawns Subagent with task
  → Subagent writes to shared file (PROJECT/state/TASK.md)
  → Subagent completes
  → Parent reads result from file
```

### Shared Memory Directories

```
memory/
  shared/
    researcher-results.md
    analyst-report.md
    executor-completion.md
```

### Checkpoint System

```
checkpoints/
  L0-checkpoint.md    # What Axton was doing
  L1-checkpoint.md    # What PISCO Agent was doing
  L2-checkpoint.md    # What RESEARCHER was doing
```

---

## PART 6: BEST PATTERNS FOR AXTON

### Pattern 1: Team Formation

```
Axton (L0)
  → Spawn PLANNER agent (what to build)
  → Spawn RESEARCHER agent (gather info)
  → Spawn BUILDER agent (execute)
  → Monitor results
```

### Pattern 2: Research Pipeline

```
PISCO Agent (L1)
  → Spawn RESEARCHER (find leads)
  → RESEARCHER spawns DATA-COLLECTOR (collect emails)
  → DATA-COLLECTOR writes to shared/contacts.md
  → ANALYST reads, scores, prioritizes
  → OUTREACH sends personalized emails
```

### Pattern 3: Self-Improvement Loop

```
Every Sunday:
1. ANALYZER reviews week
2. identifies failures
3. proposes SOUL.md changes
4. Human approves
5. New agent spawns with improved template
```

### Pattern 4: Overseer Pattern

```
OVERSEER agent (L1)
  → Spawns WORKER agents
  → Monitors their checkpoints
  → If worker fails/stuck → kill and respawn
  → Reports to Axton periodically
```

---

## PART 7: CREATED TOOLS

Created in `/data/workspace/tools/`:

### a) agent_team.sh
**Purpose:** Spawn 3 specialized agents (RESEARCHER → ANALYST → EXECUTOR)

```bash
bash tools/agent_team.sh [PROJECT] [TASK]
```

**Pipeline:**
1. RESEARCHER — finds info, writes to `shared/researcher-findings.md`
2. ANALYST — reads findings, writes to `shared/analyst-recommendations.md`
3. EXECUTOR — reads recommendations, creates action plan, executes P1 tasks

**Key pattern:** Sequential spawning with shared state file (`state.yaml`)

### b) multi_layer_spawn.sh
**Purpose:** L0→L1→L2→L3 recursive agent spawning demonstration

```bash
bash tools/multi_layer_spawn.sh [PROJECT] [DEPTH]
```

**Chain:**
- L0: This script (supreme, spawns L1)
- L1: Project Lead agent (spawns L2)
- L2: Specialists (spawn L3)
- L3: Workers (no spawn)

**Key pattern:** Checkpoint files at `checkpoints/l[0-3]-status.md`

### c) shared_memory.sh
**Purpose:** File-based communication system for agents

```bash
bash tools/shared_memory.sh init           # Initialize structure
bash tools/shared_memory.sh write KEY VALUE # Write to shared key
bash tools/shared_memory.sh read KEY       # Read from key
bash tools/shared_memory.sh list            # Show all contents
bash tools/shared_memory.sh agent-register NAME ROLE
bash tools/shared_memory.sh task-create NAME DESC ASSIGNEE
bash tools/shared_memory.sh message-send FROM TO MSG
```

**Structure:**
```
TEAM/shared-memory/
  _meta.yaml        # Version, last write, agents
  agents/           # Agent registration & heartbeats
  tasks/            # Task queue and assignments
  results/          # Completed task outputs
  messages/         # Inter-agent messages
```

### d) agent_overseer.sh
**Purpose:** One agent monitors others, restarts if needed

```bash
bash tools/agent_overseer.sh [PROJECT] [WORKER_COUNT]
```

**Features:**
- Spawns N worker agents
- Creates heartbeat files every 60 seconds
- Monitors for stale workers (120s timeout)
- Auto-restarts dead workers (max 3 retries)
- Tracks results and failures
- Final report with elapsed time

---

## PART 8: SUCCESS METRICS

### How to Measure Success

1. **Time saved** — Did spawning agents complete tasks faster?
2. **Quality maintained** — Did delegated work meet standards?
3. **Recursion depth** — Can L3 spawn L4? (goal: yes)
4. **Self-improvement** — Did SOUL.md evolve based on failures?

### Tracking

```
SUCCESS_LOG.md — What worked
FAILURE_LOG.md — What failed and why  
CAPABILITY_TRACKER.md — What agents can do
IMPROVEMENTS.md — What changed and when
```

---

## WHAT TO BUILD NEXT

### High Priority (This Week)
1. **Shared memory daemon** — Background process agents write to
2. **Checkpoint monitor** — Dashboard showing all agent states  
3. **Self-improvement cron** — Weekly review and update cycle (Sunday soul update)
4. **Agent registry** — Track which agents are running

### Medium Priority (This Month)
1. **Cross-agent learning** — When one agent learns, others inherit via templates
2. **Dynamic template generation** — Agents create new templates based on needs
3. **Hierarchical reporting** — L3→L2→L1→L0 summary pipeline
4. **Parallel pipeline execution** — RESEARCHER + ANALYST + EXECUTOR run simultaneously

### Experimental (Next Quarter)
1. **Agent-to-agent messaging** — Direct communication via files (currently via shared_memory.sh)
2. **Recursive self-replication** — L3 spawning new L3s autonomously
3. **Meta-learning** — Agent learns how to learn better (capability-evolver integration)
4. **OpenClaw native spawning** — Request `sessions_yield` for subagent-to-parent result passing

---

## KEY INSIGHTS

1. **Spawning is already working** — OpenClaw supports it natively
2. **Files are the memory** — No persistence without files
3. **Templates are the DNA** — Copy templates = copy agent
4. **Recursion is possible** — Agent → spawns → agent (tested)
5. **Self-improvement requires discipline** — Log everything, review regularly

---

## REFERENCES

- LangChain Deep Agents: https://docs.langchain.com/oss/python/deepagents/overview/
- CrewAI Tasks: https://docs.crewai.com/en/concepts/tasks/
- AutoGen: https://microsoft.github.io/autogen/stable/
- OpenClaw Self-Replication: /data/workspace/SELF_REPLICATION.md
- Capability Evolver: /data/workspace/skills/capability-evolver/SKILL.md

---

_Last updated: 2026-04-16_