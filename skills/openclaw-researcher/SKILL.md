---
name: openclaw-researcher
description: Automatically researches OpenClaw ecosystem — new skills, techniques, competitor setups, and self-improvement methods from GitHub, ClawHub, Discord, and the community. Fires on schedule and saves findings.
---

# OpenClaw Researcher — Self-Improvement Intelligence

## Purpose
Autonomous research agent that continuously monitors the OpenClaw ecosystem for new capabilities, techniques, and improvements. Keeps Axton sharp by learning from the community.

## Trigger
- Cron job: Every 3 days at 11am Madrid time
- Can also be triggered manually: "Research OpenClaw improvements"

## Research Targets

### 1. ClawHub New Skills
URL: https://clawhub.ai/skills
- Browse newly added or popular skills
- Filter: self-improvement, memory, automation, research
- Save promising skills to `startup-machine/CLAWHUB-NEWS.md`

### 2. GitHub OpenClaw Ecosystem
URLs to check:
- github.com/topics/openclaw
- github.com/VoltAgent/awesome-openclaw-skills
- github.com/openclaw/openclaw (official repo)
- github.com/zeroclaw-labs/zeroclaw
- github.com/NousResearch/hermes-agent

### 3. Community Discussions
- Reddit: r/openclaw, r/ClaudeAI, r/AIAssitants
- Discord: OpenClaw community

## Output Format

```markdown
# OpenClaw Research — YYYY-MM-DD

## New Skills Found
| Skill | What it does | Install command | Useful for |

## Technique Improvements
- What: [description]
- How: [how to use it]
- Source: [URL]

## Community Discoveries
- [Interesting setup or workflow from community]

## Gap Analysis
What Axton is NOT doing that others are:
- [ ] ...

## Action Items
What to build or install next:
1. [Skill name] — install command
2. ...
```

## Storage
- Save full report to: `memory/openclaw-research/YYYY-MM-DD.md`
- Save summary to: `startup-machine/CLAWHUB-NEWS.md`
- If critical finding: alert Jordan via Telegram

## Execution
This skill is called by the cron scheduler. The agent reads this SKILL.md and executes the research loop.
