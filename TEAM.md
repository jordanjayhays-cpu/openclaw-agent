# TEAM.md — Jordan's AI Team

A coordinated multi-agent system for Jordan. Four agents, one mission: make money.

## The Team

| Agent | Role | Focus | Model |
|-------|------|-------|-------|
| **Milo** | Strategy Lead | Where we're going, what matters | Opus |
| **Josh** | Business & Growth | Numbers, ROI, pipeline | Sonnet |
| **Marketing** | Market Research | Trends, content, outreach | Gemini |
| **Dev** | Implementation | Code, systems, deployment | Opus/Codex |

## Coordination Pattern

All agents share a single workspace at `/workspace/`

Communication flow:
```
Jordan → Milo (decides priority)
Milo → Dev (builds)
Milo → Josh (models)  
Milo → Marketing (researches)
All → TEAM.yaml (state)
All → GitHub (persistence)
```

## Shared State: TEAM.yaml

All agents write to `team/TEAM.yaml` — single source of truth.

```yaml
# TEAM.yaml — Jordan's Team Coordination
project: solo-founder-income-machine
updated: 2026-04-21T06:27:00Z

mission: Build location-independent income before MBA ends (7 months)

active_projects:
  pisco:
    status: outreach-ready
    priority: 1
    goal: First commission June 2026
  neuromatch:
    status: platform-built
    priority: 2
    goal: First patient Q3 2026

todays_focus:
  primary: PISCO email outreach
  secondary: Validate Neuromatch positioning
  background: None

pisco_state:
  emails_drafted: 13
  emails_sent: 0
  responses: 0
  meetings: 0
  commissions: 0

neuromatch_state:
  platform: built
  facilities: 0
  radiologists: 0
  patients: 0

team_status:
  milo: active
  josh: monitoring
  marketing: research-ready
  dev: build-ready
```

## Agent Communication

### When you need a specific agent:
- `@milo` — strategic decisions, prioritization
- `@josh` — numbers, pricing, business model questions
- `@marketing` — content, trends, outreach copy
- `@dev` — code, technical implementation

### When any agent has an update:
They update `team/TEAM.yaml` and commit to GitHub.

## Daily Rhythm

| Time | Agent | Action |
|------|-------|--------|
| Morning | Milo | Review TEAM.yaml, set day's priority |
| 9 AM | Josh | Pull pipeline metrics, report to Milo |
| 10 AM | Marketing | Surface 3 trend-based ideas |
| Ongoing | Dev | Execute on current priority |
| Evening | Milo | Summarize progress, update TEAM.yaml |

## The Rule

**Milo runs the show.** Jordan talks to Milo. Milo delegates to the team. The team updates TEAM.yaml and reports back to Milo. Jordan gets a daily summary.

---

*Created: 2026-04-21*
*Jordan's AI Team*