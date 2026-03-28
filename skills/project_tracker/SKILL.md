# Project Tracker Skill

## Description
Update Jordan's MISSION-CONTROL.md with progress, decisions, and next actions.

## Triggers
- "update project [project name]"
- "mark [task] as done"
- "add to mission control"
- "log progress on [project]"
- "what's the status of [project]"

## Projects
1. PISCO — BD for Placewell International (Manila recruitment)
2. COMARE — BD for COMARE (B2B maintenance, Mexico)
3. Dealsmap 2.0 — Profile partner model
4. Google Maps — Influencer aggregation concept
5. New Bali — Digital nomad destination concept
6. Neurotech — Content strategy

## What it does

### Log Progress
When Jordan says "did X today" or "completed Y":
1. Find relevant project in MISSION-CONTROL.md
2. Update status, add to today's log
3. Move tasks to completed if done
4. Surface next actions

### Add Task
When Jordan says "add [task] to [project]":
1. Find project
2. Add to "THIS WEEK" section
3. Update MISSION-CONTROL.md

### Status Check
When Jordan asks "status of [project]":
1. Read MISSION-CONTROL.md
2. Report: what's done, what's next, blockers

### Daily Update
When Jordan gives end-of-day summary:
1. Log to today's progress
2. Update MISSION-CONTROL
3. Surface tomorrow's priorities

## Format for updates
```
## [Project] — [Date]

**Completed:**
- [Task 1]
- [Task 2]

**Progress:**
- [What happened]

**Next:**
- [Next action]

**Blockers:**
- [If any]
```

## Save location
Updates `/data/workspace/MISSION-CONTROL.md`

## Example usage
"Completed outreach to Javier Estrada today"
"Added Digital Nomad meetup to this week"
"Update COMARE — got reply from Farmacias Similares"
"What's the status on PISCO?"
"Log: finished first 5 LinkedIn messages for Dealsmap"
