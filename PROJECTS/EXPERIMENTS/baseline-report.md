# Experiment Baseline Report
**Generated:** 2026-04-02 04:22 UTC
**Source:** experiments/, daily logs, memory files

---

## Current State of All Experiments

### experiments/ Directory
Only 1 file found:
- `experiments/improvements.json` — empty shell, no active experiments

```json
{
  "version": "1.0",
  "agent": "self-improvement-digest",
  "experiments": [],
  "applied_improvements": [],
  "sources_checked": []
}
```

**Status: No experiments running.**

---

## What's Working

### PISCO — BD Pipeline
- ✅ **Approach works:** Javier Estrada (NH Hotel) responded positively to cold outreach
- ✅ **Case studies are effective:** NH Collection property data with specific metrics (94% retention, €58K savings) resonated
- ✅ **CRM system established:** crm.db tracking, contacts organized, follow-up log ready
- ✅ **Email drafts are high quality:** Personalized, specific, no fluff
- ✅ **756 messages prepared** across 252 hotels — outreach infrastructure solid

**Evidence:** 1 positive response from 1 HOT lead + warm follow-ups tracked

### COMARE — Research & Positioning
- ✅ **ICP decision made:** Pharmacy (Farmacias del Ahorro) over restaurant/medical
- ✅ **Sharp insight:** 200 new stores/year = high recurring maintenance opportunity
- ✅ **Warm contacts identified:** Gabriel Zavala + Maximiliano Winkler at Farmacias del Ahorro
- ✅ **Outreach drafted:** 3-email sequence + LinkedIn DMs ready for Jordan's approval

**Evidence:** 2 warm contacts added to CRM in one research session

### MASSAGE-PASS — Product Build
- ✅ **Landing page built:** `landing-page.html` — hero, how-it-works, pricing, FAQ (interactive accordion), forms
- ✅ **Forms functional:** Subscriber waitlist + clinic registration (Formspree placeholder + localStorage backup)
- ✅ **Mobile responsive:** Countdown timer, trust bar, mobile fixes
- ✅ **Data model designed:** 2 shops interested (Mayoac, The Fix Room), revenue split defined (75/20/5)
- ✅ **Notion databases drafted:** Shops, Subscribers, Bookings (blocked on API token)

**Evidence:** Landing page is deployable to GitHub Pages immediately

### Agent System — Axton Operations
- ✅ **Memory system working:** Daily logs, MEMORY.md, AUTONOMOUS.md all updating
- ✅ **Git commits happening:** Active version control
- ✅ **Heartbeat checks running:** Morning/evening/night cron checks
- ✅ **Startup sequence:** AGENTS.md bootstrap running correctly

**Evidence:** Multiple daily logs from March 31 - April 2 show continuous operation

---

## What's NOT Working

### MASSAGE-PASS — Blocked on Jordan's Actions
- ❌ **Domain not purchased:** `massagepass.com` still pending (due Apr 7)
- ❌ **Notion API not set up:** `~/.notion-token` missing — blocks all database builds
- ❌ **Formspree not configured:** Forms have placeholder ID — no real submissions captured
- ❌ **No shops live:** Both shops (Mayoac, The Fix Room) are "interested" but not signed
- ❌ **No pricing validated:** $30/month assumption has not been tested with real users

**Impact:** MASSAGE-PASS cannot generate revenue until Jordan completes 3 setup tasks.

### PISCO — Outreach Tracking Gap
- ❌ **Outreach sent before CRM existed:** 756 messages sent March 28-31, not tracked in crm.db
- ❌ **No response tracking:** Which emails were opened? Which got no response? Unknown
- ❌ **Follow-up schedule not enforced:** Some contacts (Concha Pardo, Gabriel Cánaves) were never outreach to despite being identified
- ❌ **Javier email may be wrong:** Low confidence on `jestrada@nh-hotels.com` — NH now owned by Minor Hotels

**Impact:** Cannot measure open rates, click rates, or optimize outreach based on data.

### COMARE — No Sales Motion Yet
- ❌ **Outreach not sent:** Warm contacts (Gabriel Zavala, Maximiliano Winkler) identified but no emails sent
- ❌ **Pricing not established:** No mention of price in outreach draft — how much does COMARE charge?
- ❌ **Email addresses missing:** Warm contacts have no verified email addresses yet

**Impact:** COMARE has zero pipeline despite strong research foundation.

### System — No Experiment Culture
- ❌ **No A/B tests:** Nothing is being tested systematically
- ❌ **No hypothesis tracking:** What's being tested? What succeeded? What failed?
- ❌ **No improvement loop:** experiments/improvements.json is empty — nothing logged

**Impact:** Jordan is building businesses but not learning systematically.

---

## What to Test Next (Priority Order)

### 🔴 HIGH PRIORITY — Revenue-Blocking Tests

**1. PISCO Email Subject Line Test**
- Hypothesis: Personalized subjects (with property name) outperform generic subjects
- Test: Send 10 emails with "NH Collection Barcelona" in subject vs 10 with generic subject
- Measure: Open rate, reply rate
- Status: Needs Jordan to approve first outreach batch

**2. COMARE Pricing Test**
- Hypothesis: Anchored pricing ("from $X/month") generates more leads than "let's talk"
- Test: Email A mentions $500/month, Email B mentions "custom quote"
- Measure: Discovery call request rate
- Status: Needs pricing decision first

**3. MASSAGE-PASS Pricing Tier Test**
- Hypothesis: Three tiers ($20/$30/$50) convert better than single price
- Test: Deploy landing page with 3-tier pricing vs single $30 price
- Measure: Waitlist sign-up rate
- Status: Landing page ready — needs domain + Formspree

### 🟡 MEDIUM PRIORITY — Learning Tests

**4. PISCO Outreach Channel Test**
- Hypothesis: LinkedIn DM outperforms email for hospitality executives
- Test: Send same message via LinkedIn vs email to same contact
- Measure: Response rate
- Status: No mechanism to track this yet

**5. Follow-Up Timing Test**
- Hypothesis: Follow-up on day 3 converts better than day 7
- Test: Track response rates for 3-day vs 7-day follow-ups
- Measure: Reply rate
- Status: Needs systematic tracking in CRM

**6. MASSAGE-PASS Value Prop Test**
- Hypothesis: "Save 40% on massage" outperforms "Membership for massage lovers"
- Test: Two landing page variants with different hero messages
- Measure: Waitlist conversion rate
- Status: Landing page has one variant only

### 🟢 LOW PRIORITY — Future Experiments

**7. PISCO Case Study Format Test**
- Hypothesis: Video case study outperforms written case study
- Test: Create 2-min video for NH Barcelona vs written PDF
- Measure: Javier's engagement (meeting booked?)

**8. COMARE ICP Test**
- Hypothesis: Pharmacies convert faster than restaurants
- Test: Run parallel outreach to both segments, measure discovery call rate
- Status: Pharmacy already chosen — too late to test

---

## Recommended Next Actions

1. **Set up experiment tracking** — Fill in `experiments/improvements.json` with current experiments
2. **Log PISCO outreach results** — Track open/click/reply for every email sent
3. **Unblock MASSAGE-PASS** — Jordan sets up Formspree + buys domain
4. **Decide COMARE pricing** — Anchor on a number before sending outreach
5. **Verify Javier's email** — Hunter.io or LinkedIn Sales Navigator before sending follow-up
6. **Build first experiment** — Pick ONE test (recommend: PISCO subject line A/B)
