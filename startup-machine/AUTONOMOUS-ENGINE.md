# AUTONOMOUS EXECUTION ENGINE — Jordan's Business on Autopilot

## The Vision
Jordan focuses ONLY on: decisions, meetings, objections, relationships.
Everything else — automated.

---

## Daily Loop (runs while Jordan sleeps)

### 🌙 NIGHTLY (2am Madrid / 8pm CDMX)
**Research & Prospecting Agent**
- Find 3 new decision-makers for target companies
- Personalize outreach messages (3 variants: initial, follow-up, value-add)
- Save to /home/openclaw/.openclaw/workspace/startup-machine/outreach-queue.md
- Add prospects to Notion COMARE CRM with status "Cold"
- Log: "Tonight's work: [X] prospects found, [Y] messages drafted"

### ☀️ MORNING (9am Madrid)
**Briefing Agent → Telegram**
- Pipeline summary: X Cold, X Warm, X Replied, X Meeting, X Deal
- Tonight's prospects: 3 new decision-makers with messages ready to review
- Follow-ups due: prospects with no reply in 5+ days
- Today's priorities: top 3 actions
- Any urgent items

### 📊 WEEKLY (Monday 9am)
**Pipeline Review Agent**
- Update all CRM statuses based on activity
- Identify stalled prospects (>10 days cold → move to "Lost" or re-engage)
- Report: week-over-week pipeline movement
- Surface: what's working, what's not

### 🧬 NIGHTLY (4am Madrid)
**Evolver Agent**
- Analyze failures (messages with 0 response rate → rework approach)
- Analyze successes (what got replies → do more of that)
- Log learnings to /home/openclaw/.openclaw/workspace/startup-machine/LEARNINGS.md
- Generate 3 proactive questions for Jordan

---

## The Outreach Pipeline (fully automated)

```
Research → Personalize → Queue → Review → Send → Follow-up → Meeting → Deal
     ↓           ↓          ↓       ↓        ↓        ↓          ↓
   While      While      Nightly  Jordan   Jordan   Automated   Jordan
   Jordan     Jordan     batch    reviews  sends    trigger     books
   sleeps     sleeps     to CRM   and     (or I            ↓
                                         approve)
                                             
```

## Key Automation Scripts

### 1. prospect-research.sh
Run nightly: finds 3 new decision-makers for target companies
- Searches LinkedIn for target ICP
- Extracts: name, title, company, LinkedIn URL
- Outputs: JSON for CRM insertion

### 2. personalize-outreach.sh
Run after research: generates personalized messages
- Takes prospect data → generates 3 message variants
- Saves to outreach-queue.md for Jordan review

### 3. update-crm.sh
Run morning: syncs outreach activity to Notion
- Marks "Last Contact" date for sent messages
- Updates status based on reply detection
- Triggers follow-up reminders

### 4. follow-up-agent.sh
Run every 3 days: re-engages cold prospects
- Queries CRM for prospects with "Cold" status, no reply in 5+ days
- Generates follow-up message
- Adds to outreach queue

---

## What Jordan Does (only Jordan)

1. **Review** — 5 min morning: skim outreach queue, approve or edit
2. **Send** — Copy message → LinkedIn/email
3. **Meet** — Book calls, do discovery
4. **Decide** — Price, terms, close
5. **Teach** — When something doesn't work, tell me and I update the system

---

## What I Do (autonomously)

- Find prospects
- Draft messages
- Update CRM
- Research market/pricing
- Track what's working
- Evolve approach
- Keep Jordan informed at the right moments

---

## Success Metrics

| Metric | Target |
|--------|--------|
| New prospects/day | 3 |
| Outreach response rate | >15% |
| Follow-up completion | 100% |
| Pipeline stages updated | Daily |
| Briefing on time | 9am sharp |
| System evolving | Every night |

---

## Current Status (2026-04-02)
- ✅ Notion CRM: Live
- ✅ Morning briefing: Live
- ✅ Nightly evolver: Live
- ✅ Overnight research (COMARE): Live
- 🔄 Operations manual: Building (CEO agent)
- 🔄 Acquisition engine: Building (CMO agent)
- 🔄 Decision-makers research: Building (Researcher agent)
- ⏳ prospect-research.sh: Not built
- ⏳ follow-up-agent.sh: Not built
- ⏳ Outreach queue system: Not built
- ⏳ SendGrid/email integration: Blocked (needs capital)

## Next Build
1. prospect-research.sh — automated LinkedIn research
2. outreach-queue.md — where drafted messages live for Jordan review
3. follow-up-agent.sh — cold prospect re-engagement
