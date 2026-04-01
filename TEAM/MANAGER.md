# AGENT MANAGEMENT — How I Run the Team

## Principle
Each project moves forward every day. No project goes dark.

## Daily Flow

### Morning (8 AM CET)
- Collect status from all agents
- Update TEAM/STATUS.md
- Brief Jordan

### Midday (12 PM CET)
- Each agent checks own queue
- Executes one task
- Updates STATE.yaml

### Evening (6 PM CET)
- Evening pulse with Jordan
- Flag blockers

### Overnight (1 AM CET)
- Full queue sweep
- Research, drafting, building

### Weekly (Sunday 2 AM)
- Mini-app for highest priority project
- Full status review
- Update goals

## Agent Check-In Protocol

Each agent (PISCO, COMARE, etc.) follows:

```
1. Read own STATE.yaml
2. Pick top uncompleted task
3. Execute
4. Update CRM (contact, log interaction)
5. Update STATE.yaml (mark done or note blocker)
6. If blocked: escalate to Axton
```

## Escalation Rules

Agent escalates to me when:
- Needs Jordan's decision
- Needs external approval (email, money, etc.)
- Blocked for >24h
- Contact needs personal touch

## Coordination

All agents coordinate via:
- STATE.yaml (project state)
- crm.db (contacts)
- tasks-log.md (completed work)

No agent talks to another directly. All through me.

## Status Tracking

```
TEAM/STATUS.md — Live dashboard of all projects
PROJECTS/{project}/state/STATE.yaml — Per project state
```

## Cron Schedule Per Project

| Project | Check-in | Deep Work |
|---------|----------|-----------|
| PISCO | Every 6h | 1 AM |
| COMARE | Every 8h | When ICP decided |
| MASSAGE-PASS | Every 4h | 1 AM |
| PK-MUSIC | Daily | Sunday 2 AM |
| NEUROTECH | Daily | Jordan-dependent |
