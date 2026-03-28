# AMERICAN OPENCLAW BEST PRACTICES
## How Americans Are Using OpenClaw — Real Systems, Real Setups

**Version:** 1.0
**Date:** March 28, 2026
**Source:** awesome-openclaw-usecases (GitHub), real user workflows, OpenClaw showcase
**Research:** Deep-dive into how Americans are actually using OpenClaw

---

# OPENING: THE AMERICAN APPROACH

Americans don't just use OpenClaw as a chatbot. They turn it into **autonomous employees**.

The patterns are clear:
1. **24/7 operation** — cron jobs, health checks, self-healing
2. **Memory-first** — every action logged, learned from
3. **Kanban thinking** — track everything on boards
4. **Telegram/Discord as control rooms** — dedicated channels for each function
5. **Self-directed** — brain dump goals, agent generates its own tasks

---

# PART 1: THE REAL SYSTEMS (AMERICANS ONLY)

## System 1: THE SELF-DIRECTED EMPLOYEE
**Creator:** Alex Finn and followers
**Used by:** YouTubers, SaaS founders, indie hackers

### What it does:
```
GOAL: Turn OpenClaw into an employee that generates its own work

1. You brain dump ALL your goals once:
   - Career: Grow YouTube to 100k
   - SaaS: Launch by Q3
   - Personal: Read 2 books/month, learn Spanish
   
2. Every morning at 8 AM:
   → Agent generates 4-5 tasks it CAN complete autonomously
   → Executes them
   → Tracks on a Kanban board it builds for you
   
3. BONUS: Every night, agent builds a SURPRISE mini-app MVP
   → You wake up with a new product idea shipped
```

### Best Practices:
```
✅ Brain dump everything first — more context = better daily tasks
✅ Let agent discover tasks you'd never think of
✅ Kanban board = trackable employee
✅ Explicitly tell agent to build MVPs, not overcomplicate
✅ Append-only task logs (prevents race conditions)
   - AUTONOMOUS.md = goals + open backlog (never edit)
   - memory/tasks-log.md = completed tasks (append only)
```

### The Append-Only Pattern:
```markdown
# AUTONOMOUS.md — Goals only, ~50 lines max
# Only main session edits this

GOALS:
- Grow YouTube to 100k
- Scale PISCO revenue to $X

BACKLOG:
- Research NH Hotel expansion
- Draft Neurotech script

---

# memory/tasks-log.md — Completed (append only)
### 2026-03-28
- ✅ TASK-001: Research competitors → research/competitors.md
- ✅ TASK-002: Draft blog post → drafts/post-1.md
- ✅ TASK-003: Build outreach template → outreach/template-1.md
```

---

## System 2: THE YOUTUBE CONTENT FACTORY
**Creator:** Daily YouTube creators
**Used by:** Content creators with 10-100k subscribers

### What it does:
```
HOURLY CRON JOB:
1. Scan breaking AI news (web + X/Twitter)
2. Check against 90-day YouTube catalog (via YouTube Analytics)
3. Semantic dedup — never pitch same idea twice
4. If novel → pitch to Telegram "video ideas" topic with sources

WHEN YOU SHARE A LINK IN SLACK:
1. OpenClaw researches the topic
2. Searches X for related posts
3. Queries your knowledge base
4. Creates Asana card with FULL OUTLINE
```

### Best Practices:
```
✅ SQLite database with vector embeddings for semantic dedup
✅ 90-day catalog prevents re-covering topics
✅ X/Twitter integration for real-time trends
✅ Full outline in Asana — not just topic, but actionable
✅ Telegram topic per function (video ideas, outreach, etc.)
```

### The Pipeline:
```
Research → Pitch → Approve → Outline → Film → Publish → Track → Improve
     ↑                                                        ↓
     └──────────────── Analytics loop ─────────────────────────┘
```

---

## System 3: PERSONAL CRM (AMERICANS DO IT DIFFERENT)
**Creator:** Business professionals
**Used by:** Sales, BD, networkers

### What it does:
```
DAILY CRON (6 AM):
1. Scan Gmail + Calendar for past 24 hours
2. Extract new contacts, update existing
3. Log interactions with timestamps + context

MORNING BRIEFING (7 AM):
1. Check today's calendar
2. For each external attendee:
   → Search CRM + email history
   → Deliver briefing: who they are, last contact, what discussed
   → Any follow-up items due?

NATURAL LANGUAGE QUERIES:
- "What do I know about [person]?"
- "Who needs follow-up this week?"
- "When did I last talk to [person]?"
```

### Best Practices:
```
✅ Separate Telegram topic for CRM queries
✅ SQLite database with full interaction history
✅ Relationship warmth scoring (hot/warm/cold)
✅ Proactive follow-up reminders
✅ Meeting prep briefings before every calendar event
```

---

## System 4: HEALTH TRACKER (THE LAZY FITNESS APPROACH)
**Creator:** Biohackers and health optimizers
**Used by:** People who want data without effort

### What it does:
```
TELEGRAM TOPIC: "health-tracker"

CRON JOBS (3x daily):
- 8 AM: "🍳 Log your breakfast"
- 1 PM: "🥗 Log your lunch"
- 7 PM: "🍽️ Log your dinner and any symptoms"

WHEN YOU MESSAGE IN TOPIC:
→ Parse food + symptoms
→ Log to health-log.md with timestamp
→ Confirm what was logged

WEEKLY ANALYSIS (Sunday):
→ Analyze patterns
→ Which foods correlate with symptoms?
→ Time-of-day patterns?
→ Clear triggers?
→ Post analysis to health-tracker
```

### Best Practices:
```
✅ 3x daily prompts remove friction for logging
✅ Natural language parsing — just text what you ate
✅ Pattern analysis = actionable insights
✅ Memory file for known triggers → gets smarter over time
```

---

## System 5: THE SELF-HEALING HOME SERVER
**Creator:** Nathan (@Reef agent)
**Used by:** Tech professionals, homelab operators

### What it does:
```
RUNS ON: Home server (K3s cluster, NixOS, TrueNAS)

15-MINUTE CRON JOBS:
- Check kanban board → continue work

HOURLY:
- Health checks (Gatus, ArgoCD, service endpoints)
- Triage Gmail (label actionable, archive noise)
- Check for unanswered alerts

EVERY 6 HOURS:
- Knowledge base data entry
- Self health check (openclaw doctor, disk, memory, logs)

EVERY 12 HOURS:
- Code quality + documentation audit

DAILY (4 AM):
- Nightly brainstorm (explore connections between notes)

DAILY (8 AM):
- Morning briefing: weather, calendars, system stats, task board

DAILY (1 AM):
- Velocity assessment (process improvements)

WEEKLY:
- Knowledge base QA review
- Infrastructure security audit
```

### Morning Briefing Format:
```markdown
### Weather
- Current conditions and forecast

### Calendars
- Your events today
- Partner's events today
- Conflicts flagged

### System Health
- CPU / RAM / Storage across all machines
- Services: UP/DOWN status
- Recent deployments
- Any alerts in last 24h

### Task Board
- Cards completed yesterday
- Cards in progress
- Blocked items

### Highlights
- Notable from nightly brainstorm
- Emails requiring action
- Upcoming deadlines
```

### Best Practices:
```
✅ 15-minute cron = responsive without overwhelming
✅ Self-diagnostics (openclaw doctor) = catch issues early
✅ Knowledge extraction compounds over time
✅ NEVER let agent push directly to main (PR required)
✅ Mandatory: TruffleHog pre-push secret scanner
```

### Security (MANDATORY):
```
⚠️ AI WILL HARDCODE SECRETS — this is the #1 risk

DEFENSE IN DEPTH:
1. Pre-push hooks: TruffleHog secret scanner
2. Local-first Git: Gitea staging before public GitHub
3. CI scanning: Woodpecker or similar
4. Dedicated 1Password vault for AI (limited scope)
5. Branch protection: PR required for main, agent can't override
```

---

## System 6: DAILY REDDIT DIGEST
**Creator:** Reddit power users
**Used by:** Researchers, niche hobbyists

### What it does:
```
EVERY DAY AT 5 PM:
→ Scan favorite subreddits (hot/new/top posts)
→ Filter by preferences (saved in memory)
→ Give digest with top performing posts
→ Ask: "Did you like this list?"
→ Update preferences based on feedback

PREFERENCES MEMORY:
- Do NOT include memes
- Focus on: AI news, productivity, philosophy
- Include: OC posts, discussions, AMAs
```

### Best Practices:
```
✅ Separate memory for reddit preferences
✅ Daily cadence = consistent discovery
✅ Feedback loop = learns what you like
✅ Read-only = no risk of unwanted posting
```

---

## System 7: TWITTER/X AUTOMATION (TWEETCLAW)
**Creator:** Social media managers
**Used by:** Creators, brands

### What it does:
```
POST & ENGAGE:
- Compose tweets, reply to threads
- Like, retweet, follow/unfollow
- Send DMs

SEARCH & EXTRACT:
- Search tweets and users
- Extract followers, likers, retweeters
- Export as CSV

GIVEAWAYS:
- Pick random winners from engagement
- Filter: minimum followers, account age, keywords
- Fair selection, configurable

MONITORS:
- Watch accounts for new tweets
- Alert when specific accounts post
- Track follower changes
```

### Best Practices:
```
✅ Managed API = no browser cookies, no scraping
✅ Natural language interface = no dashboard jumping
✅ Giveaway automation = saves hours
✅ Monitor = never miss important posts
```

---

## System 8: AUTONOMOUS PROJECT MANAGEMENT
**Creator:** Engineers, product teams
**Used by:** Indie hackers, small teams

### What it does:
```
STATE.yaml PATTERN — Decentralized coordination

Each project = folder with STATE.yaml:

project: website-redesign
updated: 2026-02-10T14:30:00Z

tasks:
  - id: homepage-hero
    status: in_progress
    owner: pm-frontend
    started: 2026-02-10T12:00:00Z
    notes: "Working on responsive layout"
    
  - id: api-auth
    status: done
    owner: pm-backend
    completed: 2026-02-10T14:00:00Z
    output: "src/api/auth.ts"
    
next_actions:
  - "pm-content: Resume migration now that api-auth is done"
  - "pm-frontend: Review hero with design team"
```

### PM Delegation Pattern:
```
Main session = COORDINATOR ONLY
- 0-2 tool calls max (spawn/send only)
- All execution goes to subagents

WORKFLOW:
1. New task arrives
2. Check PROJECT_REGISTRY.md for existing PM
3. If PM exists → sessions_send(label="pm-xxx", message="[task]")
4. If new project → sessions_spawn(label="pm-xxx", task="[task]")
5. PM executes, updates STATE.yaml, reports back
6. Main agent summarizes to user
```

### Best Practices:
```
✅ Thin main session = fast response (CEO pattern)
✅ Subagents own their STATE.yaml files
✅ Subagents can spawn sub-subagents for parallel work
✅ All state changes committed to git (audit trail)
✅ Label conventions: pm-{project}-{scope}
✅ File-based coordination > message-passing
```

---

## System 9: NEWSLETTER TRIAGE
**Creator:** Inbox zero enthusiasts
**Used by:** Busy professionals

### What it does:
```
SETUP:
- Dedicated Gmail for newsletters
- Subscribe to all newsletters with OpenClaw email
- Unsubscribe from your main email

EVERY DAY AT 8 PM:
→ Read all newsletter emails (past 24 hours)
→ Give digest of most important bits
→ Include links to read more
→ Ask: "Did I pick good bits?"
→ Update memory based on preferences
```

### Best Practices:
```
✅ Separate email = no noise in main inbox
✅ Evening digestion = morning reading
✅ Feedback loop = gets better over time
✅ Only most important bits = actionable
```

---

## System 10: INBOX DECLUTTER
**Creator:** Productivity nerds
**Used by:** Everyone with email overload

### What it does:
```
GMAIL INTEGRATION via gog CLI

AUTOMATIC TRIAGE:
- Label actionable items
- Archive newsletters and noise
- Flag urgent for immediate attention

CRON-BASED:
→ Runs on schedule, not just when you ask
→ Consistent inbox maintenance
→ You only see what matters
```

---

# PART 2: THE AMERICAN BEST PRACTICES

## Pattern 1: THE BRAIN DUMP FIRST
**Americans do this consistently:**

```markdown
Here are my goals. Remember all of this:

CAREER:
- Grow my YouTube channel to 100k subscribers
- Launch my SaaS product by Q3
- Build a community around AI education

PERSONAL:
- Read 2 books per month
- Learn Spanish

BUSINESS:
- Scale revenue to $10k/month
- Build partnerships with 5 companies
- Automate as much as possible

Use this context for everything you do going forward.
```

**Why it works:**
- Gives the agent FIRM FOUNDATION
- Daily tasks align with larger goals
- Agent generates its own work from the goals

---

## Pattern 2: DEDICATED TELEGRAM TOPICS
**Americans create separate topics for:**

| Topic | Purpose |
|-------|---------|
| `video-ideas` | AI news pitches |
| `personal-crm` | Contact queries |
| `health-tracker` | Food/symptom logging |
| `outreach` | BD leads and follow-ups |
| `content-pipeline` | YouTube workflow |

**Why it works:**
- No confusion about which channel for what
- Easy to mute topics you don't need
- Natural separation of concerns

---

## Pattern 3: APPEND-ONLY LOGS
**The race condition fix:**

```markdown
# ❌ WRONG — edit existing lines
### 2026-03-28
- ✅ TASK-001: Research competitors
- ✅ TASK-002: Draft post

# ✅ RIGHT — append only
### 2026-03-28
- ✅ TASK-001: Research competitors → research/competitors.md
- ✅ TASK-002: Draft post → drafts/post-1.md

### 2026-03-29
- ✅ TASK-003: Outreach email → outreach/email-1.md
```

**Why it works:**
- Multiple agents can append simultaneously
- No silent failures from text mismatches
- Inspired by Git: never rewrite history

---

## Pattern 4: MEMORY-FIRST
**Americans build memory files for:**

| Memory | Contents |
|--------|----------|
| `reddit-preferences.md` | What to include/exclude |
| `health-triggers.md` | Known food triggers |
| `contact-context.md` | Relationship history |
| `project-goals.md` | Objectives + success criteria |

**The key insight:**
> "The agent should get smarter over time, not start fresh every session."

---

## Pattern 5: KANBAN THINKING
**Americans track everything on boards:**

```
TO DO → IN PROGRESS → DONE
   │         │           │
   │         │           └── Agent completes → logged
   │         │
   │         └── Agent working on it → visible
   │
   └── Next task → queued
```

**Tools used:**
- Notion (most popular)
- Built-in Kanban (Next.js app agent builds)
- Todoist
- Asana

---

## Pattern 6: SELF-DOCUMENTING
**Americans make agents document everything:**

```markdown
Log all infrastructure changes to ~/logs/infra-changes.md

When you complete a task:
→ Log what you did
→ Log what the output was
→ Log any issues encountered
```

**Why it works:**
- You can see what the agent has been doing
- Audit trail for accountability
- Easier to course-correct

---

## Pattern 7: THE MORNING BRIEFING
**Almost every American system includes this:**

```markdown
8:00 AM — MORNING BRIEFING
━━━━━━━━━━━━━━━━━━━━━━━━━━

WEATHER:
- Current conditions + forecast

CALENDAR:
- Today's meetings
- Any conflicts?

SYSTEM HEALTH (if server):
- CPU / RAM / Storage
- Services status

TASK BOARD:
- Completed yesterday
- In progress now
- Blocked items

HIGHLIGHTS:
- Notable findings
- Emails needing action
- Upcoming deadlines
```

---

## Pattern 8: SECURITY FIRST
**Americans don't trust the AI with secrets:**

```
⚠️ AI WILL HARDCODE SECRETS — this is documented fact

AMERICAN DEFENSE:
1. Pre-push hooks (TruffleHog)
2. Local Gitea staging → public GitHub
3. CI scanning before any push
4. 1Password CLI for secrets (never hardcode)
5. Branch protection (PR required)
6. Read-only access where possible
```

---

## Pattern 9: CRON-FIRST ARCHITECTURE
**Americans set up scheduled tasks IMMEDIATELY:**

| Frequency | Task |
|-----------|------|
| Every 15 min | Health checks, task continuation |
| Hourly | News scan, email triage |
| Every 6 hours | Knowledge base updates |
| Daily (4 AM) | Nightly brainstorm |
| Daily (8 AM) | Morning briefing |
| Weekly | Pattern analysis, security audit |

---

## Pattern 10: THE THIN MAIN SESSION
**Main agent does MINIMAL work:**

```markdown
RULE: Main session = 0-2 tool calls max

WHAT IT DOES:
- Receives task
- Spawns subagent with scope
- Responds to user
- DONE

WHAT IT DOESN'T DO:
- Execute tasks itself
- Research directly
- Write code
```

**Why it works:**
- Fast response to user
- Parallel execution
- Agent bottleneck avoided

---

# PART 3: WHAT AMERICANS DO THAT JORDAN SHOULD COPY

## High Priority (Do Now)

### 1. Brain Dump Goals to Memory
```
Copy from: Self-Directed Employee
Action: Write Jordan's full goals to AUTONOMOUS.md

CONTENTS:
- PISCO: Scale to $X revenue, land X clients
- COMARE: Get first 10 clients
- Dealsmap: Recruit X profile partners
- Neurotech: Grow YouTube to X
- PK: Build philosophical music catalog
- New Bali: Validate concept, secure property
- Community: Grow to X members
- Personal: Graduate IMBA, build freedom
```

### 2. Append-Only Task Logs
```
Copy from: Autonomous PM
Action: Set up memory/tasks-log.md

RULES:
- Never edit existing lines
- Only append completed tasks
- Include: date, task, output file
```

### 3. Morning Briefing at 8 AM
```
Copy from: Self-Healing Server
Action: Set up cron for 8 AM daily

FORMAT:
- Weather (Madrid)
- Today's priorities (top 3)
- Calendar (meetings, events)
- Task board status
- Alerts/blockers
```

### 4. Dedicated Telegram Topics
```
Copy from: All American systems
Action: Create topics for:
- personal-crm (contact queries)
- pisco-outreach (BD pipeline)
- content-pipeline (YouTube/PK)
- new-bali (research)
```

### 5. Health/Fitness Tracker
```
Copy from: Health Tracker
Action: Set up for Jordan

TRACK:
- Morning: How did you sleep?
- Midday: Energy level?
- Evening: What did you eat? How did you feel?
- Weekly: Patterns analysis

CANVAS:
- Bryan Johnson Blueprint tracking
- Sleep, light, exercise, supplements
```

---

## Medium Priority (Do This Week)

### 6. Self-Directed Daily Tasks
```
Copy from: Self-Directed Employee
Action: Tell Claw to generate 4-5 tasks daily

PROMPT:
"Every morning at 8 AM, come up with 4-5 tasks you can 
complete today that bring me closer to my goals.
Execute them. Track on Kanban."
```

### 7. YouTube Content Pipeline
```
Copy from: YouTube Content Factory
Action: Set up hourly research + pitch

PIPELINE:
1. Hourly: Scan AI/neurotech news
2. Check against 90-day catalog
3. Semantic dedup
4. If novel → pitch to content-pipeline topic
5. Jordan approves → outline created
```

### 8. Personal CRM with Meeting Prep
```
Copy from: Personal CRM
Action: Set up contact tracking

DAILY (6 AM):
- Scan emails, calendar
- Update contacts
- Log interactions

MORNING (7 AM):
- Today's meetings
- Brief on each person
- What to remember

QUERY:
- "What do I know about Javier Estrada?"
- "Who should I follow up with this week?"
```

### 9. Newsletter Digest
```
Copy from: Newsletter Triage
Action: Set up evening digest

TIME: 8 PM daily

FORMAT:
- Top 3 articles from each newsletter
- Key insights
- Links to read more
```

### 10. Reddit Research
```
Copy from: Daily Reddit Digest
Action: Set up for Jordan's niches

SUBREDDITS:
- r/neuroscience
- r/neovim
- r/SideProject
- r/digitalnomad
- r/philosophy

TIME: 5 PM daily
```

---

## Lower Priority (Do This Month)

### 11. Self-Healing Infrastructure
```
Copy from: Self-Healing Server
Action: If Jordan gets a Pi

MONITOR:
- Railway server health
- Crontabs running
- Git backups
- Disk space
```

### 12. Twitter Automation
```
Copy from: TweetClaw
Action: If Jordan wants Twitter presence

CAPABILITIES:
- Post tweets
- Monitor competitors
- Track mentions
- Run giveaways
```

### 13. Overnight Mini-App Builder
```
Copy from: Self-Directed Employee (bonus)
Action: If Jordan wants to build tools

OVERNIGHT:
- Agent builds surprise MVP
- Wake up with new product idea
- Test concepts fast
```

---

# PART 4: THE AMERICAN TOOLSTACK

## What Americans Use (Most Popular)

| Tool | Purpose | Popularity |
|------|---------|------------|
| **Telegram** | Primary control interface | #1 by far |
| **Discord** | Alternative (gamers/Gen Z) | #2 |
| **Notion** | Knowledge base + CRM | #1 for docs |
| **SQLite** | Lightweight databases | #1 for local |
| **Gitea** | Private Git staging | Security-conscious |
| **1Password CLI** | Secrets management | Mandatory |
| **TruffleHog** | Secret scanning | Pre-push hooks |
| **gog CLI** | Gmail + Calendar | Email integration |
| **TweetClaw** | Twitter automation | Social managers |
| **K8s/K3s** | Self-hosting | Tech users |
| **Next.js** | Kanban + web apps | Developers |
| **Asana** | Task management | Project tracking |

---

## Jordan's American Toolstack (Recommended)

### Must Have (Copy Now):
```
COMMUNICATION:
✅ Telegram (already using)
✅ WhatsApp (for The Middle Way community)

EMAIL:
✅ SendGrid (already set up)
✅ gog CLI (for Gmail/Google Calendar when OAuth done)

KNOWLEDGE:
✅ Notion (need to set up)
✅ File-based (memory/workspace)

CRM:
✅ Notion API (when set up)
✅ File-based for now

CONTENT:
✅ YouTube API (need to set up)
✅ Spotify API (need to set up)
✅ Canva API (nice to have)
```

### Nice to Have (This Month):
```
MONITORING:
- Railway deployment monitoring
- Git backup verification

AUTOMATION:
- n8n (for complex workflows)
- Make.com (visual automation)

SOCIAL:
- TweetClaw (if Twitter becomes priority)
- Reddit API (research)
```

---

# PART 5: THE JORDAN SYSTEM — AMERICAN-STYLE

## What Jordan Should Build (American Best Practices)

### Morning Routine (8 AM Daily)
```markdown
MORNING BRIEFING — Jordan
━━━━━━━━━━━━━━━━━━━━━━━━━━

📅 DATE: March 29, 2026
🌤️ WEATHER: Madrid — Sunny, 14°C

🎯 TOP 3 PRIORITIES:
1. [From PISCO] Connect with Javier Estrada
2. [From Neurotech] Film Video #1
3. [From PK] Upload Memento Mori

📅 CALENDAR:
- 10:00 AM: Digital Nomad Meetup
- No other meetings today

📊 PROJECT STATUS:
🅿️ PISCO: Outreach queue — 5 messages ready
🅲 COMARE: Waiting on ICP decision
🅳 Dealsmap: Post Upwork ad needed
🅽 Neurotech: Script ready, awaiting film
🅱 New Bali: Research compiled, meetup today

⚠️ ACTION NEEDED:
- COMARE ICP decision
- Post Upwork ad

💭 INSIGHT:
"NH Hotel expansion = PISCO opportunity.
Consider asking Javier about hotel contacts in Spain."

━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 Claw | 8:00 AM CET
```

### Evening Routine (6 PM Daily)
```markdown
EVENING PULSE — What did Jordan accomplish?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REPLY WITH:
"What I did today: [X]"
"What I'm working on: [Y]"
"Blockers: [Z]"

EXAMPLE:
"Evening pulse: Had great call with Javier.
He wants to meet next week. COMARE = pharmacies.
Filmed half of Neurotech intro."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Weekly Review (Sunday)
```markdown
WEEKLY REVIEW — Jordan
━━━━━━━━━━━━━━━━━━━━━━

WEEK OF: March 22-28, 2026

✅ ACCOMPLISHED:
- PISCO: 3 new decision makers identified
- Neurotech: Script #1 written
- Community: WhatsApp community created
- PK: Executive report built

📊 PIPELINE:
- PISCO: 5 warm leads
- COMARE: ICP decision pending
- Dealsmap: Upwork post drafted

🎯 NEXT WEEK:
1. COMARE ICP decision → start outreach
2. Film Neurotech Video #1
3. Post Upwork ad
4. Attend Digital Nomad Meetup

💭 LESSONS:
- Morning briefings work well
- Need faster decision-making on ICP

━━━━━━━━━━━━━━━━━━━━━━
```

---

# PART 6: THE COMMANDMENTS (American Best Practices)

## The American Rules for OpenClaw

```
1. BRAIN DUMP FIRST
   You can't expect the agent to read your mind.
   Tell it everything you want. Then tell it more.

2. MEMORY IS EVERYTHING
   The agent should get smarter over time.
   Never start fresh. Build on what came before.

3. CRON IS KING
   Set it and forget it. The best American systems
   run while you sleep.

4. TELEGRAM IS THE CONTROL ROOM
   One message = one action in the right channel.
   Everything has its place.

5. APPEND ONLY
   Never edit history. Only add to it.
   This prevents race conditions and silent failures.

6. SECURITY IS NOT OPTIONAL
   The AI WILL hardcode secrets.
   Pre-push hooks. 1Password. Local Git staging.

7. THIN MAIN SESSION
   The main agent should never do the work.
   It should only coordinate the workers.

8. KANBAN EVERYTHING
   If it's not on the board, it doesn't exist.
   Track. Always track.

9. BRIEFINGS EVERY MORNING
   You should wake up knowing exactly what to do.
   Let the agent figure out what you need to know.

10. SECURITY FIRST, ALWAYS
    AI assistants will hardcode secrets.
    They don't have the same instincts humans do.
    Enforce guardrails or get burned.
```

---

# CLOSING

**The American approach in one sentence:**

> "Tell me your goals once, and I'll spend every day finding tasks that bring you closer to them — executing while you sleep."

**The key differences from how Jordan currently uses OpenClaw:**

| Current | American Way |
|---------|-------------|
| Reactive | Proactive |
| Task-based | Goal-based |
| Manual | Autonomous |
| Files scattered | Memory-first |
| Single agent | Multi-agent |
| Ad-hoc | Cron-driven |

**Jordan's system, American-style:**

```
EVERY MORNING (8 AM):
→ Briefing ready (weather + priorities + calendar)
→ 4-5 tasks auto-generated from goals
→ Agents executing in parallel
→ Board updated in real-time

WHILE JORDAN SLEEPS:
→ Research runs
→ Outreach sequences
→ Content queued
→ CRM updated

EVERY EVENING (6 PM):
→ Jordan pulses: "I did X"
→ Logged + learned from
→ Tomorrow's briefing prepped

EVERY WEEK:
→ Pattern analysis
→ What worked?
→ What didn't?
→ System improves
```

---

_Created by Claw 🦞 | Research from awesome-openclaw-usecases, real American workflows_
_Version 1.0 | March 28, 2026_
