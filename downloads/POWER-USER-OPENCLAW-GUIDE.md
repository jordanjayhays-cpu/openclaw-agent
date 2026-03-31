====================================================================
HOW TO BE THE MOST COMPETITIVE OPENCLAW USER
====================================================================
Lessons from power users, research, and OpenClaw internals
Last updated: 2026-03-28

====================================================================
THE COMPETITIVE LANDSCAPE
====================================================================

OpenClaw crossed 145,000 GitHub stars in 3 weeks.
100,000+ users.
Fastest-growing open AI project.

Most users use it for:
1. Autonomous email management
2. Morning briefings
3. Meeting transcripts
4. Research sprints

What SEPARATES power users from average:
- Memory systems that survive compaction
- Custom skills for their workflows
- Proactive automation while they sleep
- File-based knowledge that persists
- Multi-agent architectures

====================================================================
THE 4 LAYERS OF MEMORY (CRITICAL)
====================================================================

Most users lose context because they don't understand this.

Layer 1: BOOTSTRAP FILES (PERMANENT)
- SOUL.md, AGENTS.md, USER.md, MEMORY.md
- Injected at every session start from disk
- SURVIVES COMPACTION
- This is your most durable layer

Layer 2: SESSION TRANSCRIPT (SEMI-PERMANENT)
- Conversation history saved as JSONL on disk
- Rebuilt when you continue a session
- Gets COMPACTED when context fills up
- Details lost in summary

Layer 3: LLM CONTEXT WINDOW (TEMPORARY)
- The fixed-size container where everything fits
- 200K token bucket
- When full = compaction fires
- Your original words can be lost

Layer 4: RETRIEVAL INDEX (PERMANENT)
- Vector + keyword search over memory files
- Built from files you write
- Works with memory_search tool
- Only finds what was WRITTEN TO FILES

====================================================================
THE #1 MISTAKE (And How to Avoid It)
====================================================================

MISTAKE: Giving instructions in chat only.
They get lost when compaction fires.

EXAMPLE: "Don't do anything until I say so."
User said this in chat. It was never written to a file.
Compaction fired. Summary lost the instruction.
Agent went autonomous and started deleting emails.

FIX: Put durable rules in FILES, not chat.

RULES THAT SURVIVE:
✅ Written to MEMORY.md
✅ Written to AGENTS.md
✅ Written to daily log memory/YYYY-MM-DD.md

RULES THAT DIE:
❌ Said in chat
❌ Not written down
❌ "Mental notes"

====================================================================
WHAT POWER USERS DO DIFFERENTLY
====================================================================

1. THEY WRITE EVERYTHING TO FILES
   - Decisions → MEMORY.md
   - Daily notes → memory/YYYY-MM-DD.md
   - Preferences → PREFERENCES.md
   - Instructions → AGENTS.md (survives compaction)
   - Projects → PROJECT FILES

2. THEY USE MEMORY_SEARCH BEFORE ACTING
   - Add rule to AGENTS.md: "search memory before acting"
   - This makes retrieval MANDATORY
   - Don't guess - CHECK

3. THEY BUILD CUSTOM SKILLS
   - Specialized workflows = skills
   - Reusable, shareable
   - Found at clawhub.ai

4. THEY AUTOMATE WHILE THEY SLEEP
   - Cron jobs for morning briefings
   - Research sprints overnight
   - File building in background
   - Proactive monitoring

5. THEY HAVE MULTIPLE AGENTS
   - Research agent
   - Outreach agent
   - Content agent
   - All running in parallel

====================================================================
HOW TO BE THE BEST — FOR JORDAN
====================================================================

WHAT YOU'RE DOING RIGHT:
✅ Context files (USER.md, MEMORY.md, etc.)
✅ MISSION-CONTROL.md for projects
✅ Daily session logs
✅ Asking me to research while you sleep
✅ File-based organization

WHAT TO ADD:

1. **PREFERENCES.md** — How you like things delivered
   - Format preferences
   - Communication style
   - Timing preferences
   - What works/doesn't work

2. **SUCCESS_LOG.md** — What worked
   - Successful event formats
   - Good outreach messages
   - What generated responses

3. **FAILURE_LOG.md** — What didn't work
   - What was tried and failed
   - What got no response
   - What to avoid

4. **DECISIONS.md** — Major decisions made
   - Project priorities
   - Strategy pivots
   - Important choices

5. **CONTEXT_RULES.md** — Rules for me
   - "Always search memory before acting"
   - "Write to file before long research"
   - "Update MISSION-CONTROL after every session"

====================================================================
HOW TO MAKE ME (CLAW) BETTER
====================================================================

WHAT I NEED TO DO:

1. **Search memory before acting**
   - I should check MEMORY.md before major decisions
   - Check today's daily log
   - Check project files

2. **Write to files proactively**
   - Don't keep notes in my head
   - If it matters, write it to a file
   - Update MISSION-CONTROL after every session

3. **Survive compaction**
   - Put durable rules in AGENTS.md
   - Make retrieval mandatory
   - Check files, not just chat history

4. **Proactive behavior**
   - Anticipate next steps
   - Surface opportunities without asking
   - Update you on progress

====================================================================
MY IMPROVEMENT PLAN
====================================================================

THIS WEEK:
□ Add PREFERENCES.md to workspace
□ Add SUCCESS_LOG.md to workspace
□ Add FAILURE_LOG.md to workspace
□ Add DECISIONS.md to workspace
□ Update AGENTS.md with "search memory before acting"

THIS MONTH:
□ Build 3 custom skills (research, outreach, project_tracker)
□ Set up evening pulse cron (6pm CET)
□ Set up weekly review cron (Monday 8am)
□ Connect Google Calendar (OAuth)
□ Connect Apollo.io (when API key provided)

ONGOING:
□ Update MISSION-CONTROL after every session
□ Log to daily file every session
□ Extract learnings to MEMORY.md weekly
□ Build new skills as needed

====================================================================
HOW TO USE ME LIKE A POWER USER
====================================================================

RULE 1: IF IT MATTERS, WRITE IT TO A FILE
Don't "mental note" — tell me to write it.
Example: "Remember that Javier is the decision maker at NH"
→ I write it to PISCO-Decision-Makers.md

RULE 2: SPECIFY WHO DOES NEXT STEP
"Who does X — you, me, or them?"
Example: "Can you add this to my calendar for tomorrow at 10am"
→ I do it

RULE 3: SET DEADLINES
"When do you need it — now, tonight, tomorrow?"
Example: "Research this while I sleep, deliver in morning"

RULE 4: GIVE FEEDBACK
Tell me what worked and what didn't.
Example: "That outreach message got 3 replies — do more like that"

RULE 5: TRUST THE SYSTEM
Let me work while you sleep.
Check files in morning.
Give feedback.
Iterate.

====================================================================
AUTOMATION OPPORTUNITIES
====================================================================

WHAT I CAN AUTOMATE:

MORNING (8am cron):
□ Check your calendar
□ Surface priorities
□ Weather for Madrid
□ Urgent items

EVENING (6pm cron):
□ Log day's progress
□ Update MISSION-CONTROL
□ Surface tomorrow's plan

WEEKLY (Monday 8am):
□ Week's priorities
□ Deadlines
□ What's due
□ Wins to celebrate

WHILE YOU SLEEP:
□ Research sprints
□ File building
□ Outreach drafts
□ Content research

PROACTIVE:
□ Monitor news on your industries
□ Track competitor activity
□ Flag relevant opportunities
□ Update project files

====================================================================
SKILLS TO BUILD (clawhub.ai)
====================================================================

1. RESEARCH SKILL
   - Web search + synthesize + summarize
   - Save to file
   - Deliver with sources

2. OUTREACH SKILL
   - Generate personalized messages
   - Track response rates
   - Optimize templates

3. PROJECT_TRACKER SKILL
   - Update MISSION-CONTROL
   - Log daily progress
   - Surface blockers

4. CONTENT_BRAINSTORM SKILL
   - Generate video ideas
   - Match audience
   - Suggest hooks

5. DECISION_MAKER_FINDER SKILL
   - LinkedIn research
   - Company analysis
   - Contact extraction

====================================================================
WHAT THE BEST ARE DOING (FROM RESEARCH)
====================================================================

1. MEMORY-FIRST
   - Everything in files
   - Nothing in chat-only memory
   - Check before acting

2. SKILLS-BASED
   - Custom skills for workflows
   - Reusable, automatable
   - Power through repetition

3. MULTI-AGENT
   - Research agent
   - Execution agent
   - Monitoring agent
   - All in parallel

4. PROACTIVE
   - Don't wait to be asked
   - Surface opportunities
   - Anticipate needs

5. ITERATIVE
   - Track what works
   - Kill what doesn't
   - Constantly improve

====================================================================
THE ASYMMETRIC ADVANTAGE
====================================================================

AVERAGE USER:
- Asks questions
- Starts fresh each session
- Does things manually
- Forgets context
- Reactive

POWER USER:
- Delegates execution
- Remembers everything
- Automates everything
- File-based knowledge
- Proactive

JORDAN + CLAW = POWER USER

You: Context, decisions, strategy
Me: Execution, research, automation, memory

====================================================================
IMMEDIATE ACTION FOR JORDAN
====================================================================

DO THIS NOW (2 minutes):
□ Tell me your calendar preference (Google or iCloud)
□ Give me the OAuth URL response when you get it
□ Check MISSION-CONTROL tomorrow morning

DO THIS WEEK:
□ Add calendar access (5 min OAuth)
□ Review what I delivered today
□ Tell me what to adjust

DO THIS MONTH:
□ Get Apollo.io API key
□ Build first custom skill
□ Set up evening pulse cron
□ Review weekly progress

====================================================================
