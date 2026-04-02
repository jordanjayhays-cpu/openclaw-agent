# STARTUP MACHINE — OPERATIONS MANUAL
**Owner:** Jordan Hays | **Runtime:** OpenClaw (Railway) | **Last Updated:** 2026-04-02

---

## EXECUTIVE SUMMARY

You have 7 months left in your MBA. You are building 6 projects that must generate revenue **without you being the bottleneck**. The machine below is designed so that when you sleep, the business moves forward.

**The core loop:**
> AI does research → drafts → queues → you approve → AI executes or you push send → replies come back → AI handles → you close

---

## SECTION 1: WHAT AUTONOMOUS REVENUE OPERATIONS LOOK LIKE

### The Revenue Machine (as designed)

```
┌─────────────────────────────────────────────────────────────┐
│                     WHILE YOU SLEEP                          │
│  • Axton monitors email replies (SendGrid webhook)           │
│  • Axton drafts follow-ups, queues them for AM approval     │
│  • PISCO outreach sequence runs (LinkedIn + email)           │
│  • COMARE CRM updates from Notion                           │
│  • Dealsmap partner onboarding auto-responds                 │
│  • Memory files sync to GitHub (auto_save every 15 min)      │
│  • Heartbeat runs, flags stale tasks                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                      WHEN YOU WAKE                           │
│  • Morning briefing: 3 priority actions, inbox summary      │
│  • You approve queued drafts (5 min)                        │
│  • You take meetings / calls (your only unreplaceable job) │
│  • You close deals                                          │
└─────────────────────────────────────────────────────────────┘
```

### What Axton Does Without Asking (Autonomously)
- Research companies, contacts, decision makers
- Draft emails, LinkedIn messages, WhatsApp scripts
- Update CRM (Notion COMARE database)
- Log all activity to memory files
- Monitor outreach sequences, flag stalled deals
- Run heartbeat checks, auto-save to GitHub
- Surface stale tasks and follow-up reminders

### What Needs Your Approval (Jordan-only)
- Sending any external message (email, LinkedIn, WhatsApp)
- Signing contracts or agreements
- Financial transactions
- Accepting meeting invitations
- Sharing your personal data externally

**Rule:** You are the firewall and the closer. Everything else runs through Axton.

---

## SECTION 2: EXACT DAILY / WEEKLY / MONTHLY WORKFLOWS

### DAILY (Every Morning — 5 Minutes)

**You do:**
1. Open Telegram → Axton sends morning briefing automatically
2. Read: Weather + 3 priority actions for the day
3. Approve queued drafts (reply "SEND" or "REVISE")
4. Execute: send emails, make calls, take meetings

**Axton does automatically at 7:00 AM CET:**
```
→ Runs morning_briefing.sh
→ Checks AUTONOMOUS.md for today's tasks
→ Checks contacts/CONTEXT.md for follow-ups due today
→ Sends briefing to Telegram
```

### WEEKLY (Sunday Night or Monday Morning — 20 Minutes)

| Day | Action |
|-----|--------|
| **Monday** | Review week: Axton generates status report on all 6 projects |
| **Monday** | Approve new outreach sequences queued over weekend |
| **Wednesday** | Mid-week pulse: 5 hottest leads, any blockers |
| **Friday** | Week review: Log wins/failures to LESSONS.md |

**Weekly status report covers:**
- PISCO: Outreach sent, responses received, pipeline stage
- COMARE: CRM updates, new prospects, meetings booked
- Dealsmap: Partners onboarded, leads assigned
- PK Music: Songs generated, catalog size
- Neurotech: Videos posted, views, subscriber count
- Massage Pass: MVP status, waitlist signups

### MONTHLY (First Saturday — 45 Minutes)

| Project | Review Focus |
|---------|-------------|
| **PISCO** | Revenue from Placewell ($X this month), new hotel logos, conversion rate |
| **COMARE** | Clients signed, revenue, pipeline value |
| **Dealsmap** | MRR from partners, partner count vs target |
| **PK Music** | Streams, revenue, catalog growth |
| **Neurotech** | YouTube revenue, subscribers, newsletter list |
| **Massage Pass** | MVP launch status, waitlist, first paying customer? |

**Monthly decisions:**
- Kill or pivot any project not hitting milestones
- Allocate focus hours for next month
- Approve any new tools or spend

---

## SECTION 3: WHAT DATA TO TRACK AND WHY

### Revenue Metrics (Track Monthly)

| Metric | Why It Matters |
|--------|----------------|
| **MRR per project** | Are you building income or just busy? |
| **Pipeline value** | COMARE and PISCO deals in flight → forecast revenue |
| **CAC (cost to acquire customer)** | Are you spending too much to win deals? |
| **Time to close** | How many weeks from first contact to signed contract? |
| **Revenue per hour invested** | Is this worth your time vs a job? |

### Activity Metrics (Track Weekly)

| Metric | For What |
|--------|----------|
| **Outreach sent** | Are you in market? Numbers game. |
| **Response rate** | Is your message working? Below 10% = rewrite. |
| **Meetings booked** | Are you advancing deals? |
| **Drafts queued** | Is Axton delivering or bottlenecking on you? |
| **Follow-ups sent** | Sequence discipline = revenue. |

### Project-Specific Data

**PISCO:**
- Hotels contacted → Responses → Meetings → Proposals → Signed
- Placewell revenue share ($X per placement)
- Target: 3 hotel chains signed in 7 months

**COMARE:**
- Prospects in CRM → Stages (Cold → Warm → Meeting → Proposal → Deal)
- COMARE pays Jordan a BD retainer or success fee
- Target: 10 clients in Mexico City

**Dealsmap:**
- Profile partners onboarded (Sarah M. = #1)
- Leads delivered to partners → partner revenue
- Jordan takes 20% of partner earnings
- Target: 25 partners (15 PISCO markets + 10 COMARE Mexico)

**PK Music:**
- Songs in catalog (currently 0)
- Streaming revenue per song
- Target: 50-song catalog → $500/month passive

**Neurotech:**
- YouTube subscribers
- Views per video
- Newsletter subscribers
- Target: 10K subscribers → YouTube ad revenue + newsletter sponsorships

**Massage Pass:**
- Waitlist signups
- Businesses signed up
- MVP launched? Y/N
- Target: First paying customer in 90 days

### Data Storage

| What | Where |
|------|-------|
| Contacts & pipeline | contacts/CONTEXT.md + Notion COMARE CRM |
| Project status | DASHBOARD.md + MISSION-CONTROL.md |
| Tasks & backlog | AUTONOMOUS.md |
| Financial | money/ (spreadsheet — Jordan maintains) |
| Daily logs | memory/YYYY-MM-DD.md |
| Long-term memory | MEMORY.md |
| Lessons learned | LESSONS.md |

---

## SECTION 4: SLEEP vs AWAKE — WHAT HAPPENS WHEN

### While You Sleep (22:00 — 07:00 CET)

**Axton runs these autonomously:**

| Time | Task |
|------|------|
| **22:00** | Auto-save: commit + push workspace to GitHub |
| **22:15** | Heartbeat: check AUTONOMOUS.md, flag stale tasks |
| **22:30** | COMARE CRM: sync Notion, log any new entries |
| **23:00** | Auto-save |
| **Every 15 min** | Auto-save loop until morning |
| **06:00** | Generate morning briefing (priority actions, weather, calendar) |
| **07:00** | Send morning briefing to Telegram |

**What does NOT happen while you sleep:**
- No emails sent (requires your approval)
- No LinkedIn actions (requires your profile)
- No calls or WhatsApp messages
- No financial decisions
- No new outreach sequences launched

### When You Wake (07:00 — 23:00 CET)

**Your job — in order of importance:**

1. **CLOSE DEALS** — Meetings, calls, contract signings (highest leverage)
2. **APPROVE DRAFTS** — 5 min to say "SEND" or "REVISE"
3. **MAKE DECISIONS** — The 6 projects need weekly direction from you
4. **EXECUTE OUTREACH** — Send the emails/messages Axton drafted
5. **STUDY** — IMBA classes, assignments

**Axton's daytime job:**
- Research (spawn subagents for parallel work)
- Drafting (emails, scripts, pitch content)
- CRM updates
- Follow-up reminders
- Answer your questions
- Surface blockers

---

## SECTION 5: THE 3 BIGGEST BOTTLENECKS RIGHT NOW

### BOTTLENECK #1: YOU ARE THE ONLY ONE WHO CAN SEND MESSAGES

**Problem:** Every outreach sequence requires you to hit send. Axton drafts but can't execute. With IMBA + 6 projects, you have no margin.

**Why it's the #1 blocker:** Even if every hotel responds tomorrow saying "yes, let's meet," you can't scale past your own hour count.

**Fix (in order of speed):**

| Option | Effort | Cost | Timeline |
|--------|--------|------|----------|
| **A. HeyReach.io** — auto-send LinkedIn | 1 hour setup | $49/mo | This week |
| **B. SendGrid warmup** — email sequences | 2 hours setup | Free (existing SendGrid) | This week |
| **C. Virtual assistant (VA)** — Philippines | Ongoing | $400-600/mo | 2-4 weeks |
| **D. Profile partner model (Dealsmap)** — let partners send | Ongoing | Revenue share | 4-8 weeks |

**Immediate action:** Set up HeyReach for LinkedIn outreach. This frees 2-3 hours/week immediately.

---

### BOTTLENECK #2: PISCO AND COMARE BOTH NEED DECISIONS BEFORE THEY CAN ADVANCE

**Problem:**
- PISCO: Missing email addresses for Concha Pardo, Gabriel Cánaves, Patricia Jaén
- COMARE: Jordan has not decided ICP (pharmacies vs restaurants vs medical vs gyms)
- COMARE: No email for Dr. Simi or any pharmacy chain decision-maker

**Why it's critical:** Both BD projects are stuck waiting for Jordan to either (a) give a decision or (b) do 10 minutes of research.

**Without these decisions:**
- No outreach can be personalized
- No sequence can be finalized
- Axton drafts into the void

**Fix — This Week:**

| Decision | Unblocks |
|----------|----------|
| COMARE ICP: Pharmacies OR Restaurants | 20 personalized email drafts |
| PISCO email research for Meliá contacts | 3 personalized outreach chains |

**Immediate action (10 min):** "Axton, I'll do pharmacies for COMARE. Find me 10 pharmacy chains in Mexico City with 10+ locations and 1 contact at each."

---

### BOTTLENECK #3: ZERO REVENUE PROJECTS THAT COULD GENERATE REVENUE THIS MONTH

**Problem:** 4 of 6 projects (Neurotech, PK Music, Massage Pass, New Bali) haven't generated a single dollar. You're spread thin across 6 projects with only PISCO (through Placewell) and Dealsmap (partner model) having any revenue potential in the short term.

**The math problem:**
- PISCO: 3-month sales cycle for hotels (you're 0 months in)
- COMARE: 1-2 month sales cycle (you're 0 months in)
- Dealsmap: Fastest to revenue — partners pay when they earn
- PK Music: Passive once catalog built — but catalog is empty
- Neurotech: YouTube takes 6-12 months to monetize
- Massage Pass: MVP not built
- New Bali: Concept only

**Revenue reality check:**

| Project | Can it make $ this month? | What needs to happen |
|---------|---------------------------|----------------------|
| Dealsmap | YES | Get 5 partners → partners find leads → you earn 20% |
| PK Music | YES | Generate 10 songs → upload to Spotify → earn streaming |
| Neurotech | NO | Build audience first (6+ months) |
| Massage Pass | MAYBE | Build MVP first |
| PISCO | POSSIBLE | If Javier closes (he's HOT) |
| COMARE | POSSIBLE | If ICP decision made + first outreach sent |

**Fix — Focus allocation:**

```
WEEK 1-4: Dealsmap + PK Music (fastest revenue)
WEEK 5+: PISCO outreach (longer cycle but highest ticket)
WEEK 8+: COMARE (Mexico BD is crowded, needs patience)
MONTH 3+: Neurotech YouTube (start filming, build audience)
MONTH 4+: Massage Pass MVP
```

**Immediate action:** This week — generate 10 PK Music songs in Suno. This is the fastest path to revenue with zero dependency on other people.

---

## SECTION 6: PROJECT-SPECIFIC OPERATING PROCEDURES

### PISCO (Active)
**Revenue model:** BD retainer from Placewell + success fee per placement
**Owner for outreach:** Jordan (LinkedIn profile) + Axton (drafts)
**Pipeline:** contacts/CONTEXT.md
**Next action:** Follow up Javier Estrada → get case studies → send to him

### COMARE (Stalled — ICP decision needed)
**Revenue model:** BD retainer from COMARE owner
**Owner for ICP decision:** Jordan (must decide this week)
**Pipeline:** Notion COMARE CRM (database ID: 336efcda-373d-8106-aad3-c8cd26f9f677)
**Next action:** Jordan decides: Pharmacies OR Restaurants

### Dealsmap 2.0 (Partner model)
**Revenue model:** 20% of partner earnings
**Owner for partner recruitment:** Jordan (Upwork) + Axton (onboarding)
**Pipeline:** contacts/CONTEXT.md (Sarah M. = #1 partner)
**Next action:** Post Upwork ad → recruit 4 more partners → assign PISCO/COMARE leads

### PK Music (Content → Revenue)
**Revenue model:** Spotify streaming royalties + YouTube ad revenue
**Owner for generation:** Jordan (Suno account) — Axton cannot generate songs
**Pipeline:** Catalog tracked in memory
**Next action:** Jordan generates 10 songs in Suno → sends links to Axton → Axton catalogs + drafts YouTube intros

### Neurotech (Audience → Revenue)
**Revenue model:** YouTube ad revenue + newsletter sponsorships
**Owner for content:** Jordan (films) + Axton (scripts, SEO)
**Pipeline:** YouTube analytics
**Next action:** Film Video #1 "Neuralink: First Human Results" (script ready in TODO.md)

### Massage Pass (MVP stage)
**Revenue model:** TBD (platform fee? subscription?)
**Pipeline:** Waitlist in memory
**Next action:** Build landing page MVP (Axton can do HTML/CSS) → collect waitlist emails

---

## SECTION 7: THE ONE-PAGE WEEKLY RHYTHM

```
MONDAY (20 min)
├── Read: Axton's weekly status report (auto-generated Sunday)
├── Decide: This week's focus project (pick 1-2, not all 6)
├── Approve: Any queued outreach sequences
└── Action: Send first outreach of the week

WEDNESDAY (10 min)
├── Pulse check: Any hot responses?
├── Follow-ups: Any stalled conversations?
└── Adjust: Reallocate hours if needed

FRIDAY (15 min)
├── Log: What worked / what didn't → LESSONS.md
├── Prep: Queue anything for weekend/next week
└── Celebrate: Small wins, log to SUCCESS_LOG.md
```

---

## SECTION 8: CRITICAL PATH — WHAT TO DO THIS WEEK

### Priority 1: Decisions (Jordan must do — 30 min total)
- [ ] COMARE ICP: Pharmacies OR Restaurants (pick one, Axton will find contacts)
- [ ] Find emails for Concha Pardo, Gabriel Cánaves (PISCO Meliá outreach)
- [ ] Generate 10 PK Music songs in Suno (or tell Axton to remind you)

### Priority 2: Outreach (Jordan executes — 2 hours)
- [ ] Send follow-up to Javier Estrada (NH Hotel — HOT lead)
- [ ] Send follow-up to Luis Zamora (Iberostar — by Apr 4)
- [ ] Post Upwork ad for Dealsmap partners

### Priority 3: Content (Jordan films — 1 hour)
- [ ] Film Neurotech Video #1 (script already in TODO.md)

---

## APPENDIX: FILES THAT MATTER

| File | Purpose |
|------|---------|
| AUTONOMOUS.md | Your task list — update daily |
| DASHBOARD.md | Project status at a glance |
| contacts/CONTEXT.md | Every person you've talked to |
| MISSION-CONTROL.md | Deep project status |
| MEMORY.md | Long-term context (survives resets) |
| LESSONS.md | What failed and why |
| RESCUE.md | One-command recovery if Axton crashes |
| startup-machine/OPERATIONS-MANUAL.md | This file |

---

**Bottom line:** You're building 6 projects but your highest-leverage move this week is (1) decide COMARE ICP, (2) post Upwork for Dealsmap, (3) generate PK songs. Everything else either requires decisions you haven't made or people who haven't responded yet.

The machine works when you feed it decisions. Axton does the rest.

---

_Last updated: 2026-04-02 | by Axton (subagent)_
