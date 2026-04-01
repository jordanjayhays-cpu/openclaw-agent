# TEAM — Axton's Employee Structure

**Team Lead:** Axton (me)
**Method:** PM Delegation Pattern

## The Team

| Agent | Role | Status |
|-------|------|--------|
| PISCO Agent | Hotel staffing BD | Active |
| COMARE Agent | Mexico maintenance BD | Waiting on ICP |
| MASSAGE-PASS Agent | Marketplace ops | Building MVP |
| PK Agent | Music manager | Waiting on Jordan |
| NEUROTECH Agent | Content creator | Waiting on Jordan |

## How It Works

1. **Axton (me) = Chief of Staff**
   - Coordinates all agents
   - Reports to Jordan
   - Makes decisions within scope
   - Escalates only what's blocked

2. **Each Agent = Project Manager**
   - Reads own STATE.yaml
   - Executes tasks autonomously
   - Spawns sub-agents for research
   - Logs to CRM
   - Reports to Axton

3. **Jordan = Final Decision Maker**
   - Only gets decisions that need him
   - Approves external actions
   - Sets priorities

## Spawning a Team Agent

To start a project agent:
```
Spawn session with:
- SOUL.md from TEAM/{project}/
- Read PROJECTS/{project}/state/STATE.yaml
- Execute tasks from queue
- Report back to main
```

## Coordination Files

```
TEAM/
├── TEAM.md (this file)
├── pisco/SOUL.md
├── comare/SOUL.md
├── massage-pass/SOUL.md
├── pk-music/SOUL.md
└── neurotech/SOUL.md

PROJECTS/
├── PISCO/state/STATE.yaml
├── COMARE/state/STATE.yaml
├── MASSAGE-PASS/state/STATE.yaml
├── PK-MUSIC/state/STATE.yaml
└── NEUROTECH/state/STATE.yaml
```

## Rules

- Main session (Axton) = 0-2 tool calls max
- Spawn agents for execution
- Agents can spawn sub-agents
- Append-only logs
- Git commit after major work
