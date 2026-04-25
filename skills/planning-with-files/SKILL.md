---
name: planning-with-files
description: Manus-style file-based planning for complex projects. Creates task_plan.md, findings.md, and progress.md in the project directory. Use when Jordan asks to plan, break down, or organize any multi-step project or research task.
user-invocable: true
allowed-tools: "Read Write Edit Bash Glob Grep"
---

# Planning with Files (OpenClaw Adaptation)

Work like Manus: Use persistent markdown files as Jordan's "working memory on disk."

## The Core Pattern

```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)
→ Anything important gets written to disk.
```

## When to Use This

**Use for:**
- Multi-step projects (3+ steps)
- Research tasks
- Building/creating new things
- Tasks spanning many tool calls
- Any complex Jordan project

**Skip for:**
- Simple questions
- Quick lookups
- Single file edits

## The 3 Planning Files

| File | Purpose | Goes In |
|------|---------|---------|
| `task_plan.md` | Phases, goals, progress | Project root |
| `findings.md` | Research, discoveries | Project root |
| `progress.md` | Session log, results | Project root |

## How to Use

### 1. At Start of Complex Task
Check if planning files exist:
```
Read: task_plan.md
Read: progress.md
Read: findings.md
```

### 2. Create Plan First (before doing anything)
Write to `task_plan.md`:
```
# Project Name — Task Plan

## Goal
[One sentence: what we're building/doing]

## Phase 1: [Name]
Status: pending | in_progress | complete
- [ ] Step 1
- [ ] Step 2

## Phase 2: [Name]
Status: pending
- [ ] Step 1

## Key Decisions
- [Decision made]

## Risks
- [Risk identified]
```

### 3. Update Progress After Each Phase
- Mark phase: `pending → in_progress → complete`
- Log to `progress.md`
- Write discoveries to `findings.md`

### 4. The 2-Action Rule
After every 2 research/write operations → save key findings to `findings.md` immediately.

## The 3-Strike Error Protocol

```
ATTEMPT 1: Diagnose & Fix
  → Read error carefully
  → Identify root cause
  → Apply targeted fix

ATTEMPT 2: Alternative Approach
  → Same error? Try different method
  → Different tool? Different library?

ATTEMPT 3: Broader Rethink
  → Question assumptions
  → Search for solutions

AFTER 3 FAILURES: Escalate to Jordan
  → Explain what was tried
  → Share the specific error
  → Ask for guidance
```

## Log ALL Errors

Every error goes in `progress.md`:
```
## Errors
| Error | Attempt | Resolution |
|-------|---------|------------|
| FileNotFoundError | 1 | Created default |
| API timeout | 2 | Added retry logic |
```

## Never Repeat Failures
```
if action_failed:
    next_action != same_action
Track what was tried. Change the approach.
```

## Where Files Go

- **Templates** are in this skill directory (`skills/planning-with-files/templates/`)
- **Planning files** go in the **project directory**
- **Never** write planning files inside the skill directory

## Templates

See the `templates/` subdirectory:
- `templates/task_plan.md` — Phase tracking template
- `templates/findings.md` — Research storage template
- `templates/progress.md` — Session log template
