# NEUROMATCH BUSINESS FACTORY 🏭

## The Vision
Build a real, functioning business called **Neuromatch**. 
Each department has its own AI agent that runs that part of the business.
Jordan builds the apps. I run the operations.

---

## DEPARTMENTS

### 🏭 Operations (CEO Agent)
**What it does:** Coordinates all other departments. Holds the north star. Makes sure sales, marketing, product, and finance are aligned.
**Core functions:**
- Meeting scheduler (coordinates all team agents)
- Decision log (tracks all major decisions)
- OKR tracker (what are we building toward this quarter?)
- Weekly standup (autonomous check-in with all departments)
- Competitor monitoring

**File:** `ops/agent.js`

---

### 📢 Marketing (Marketing Agent)
**What it does:** Gets the word out. Brings in leads. Builds brand.
**Core functions:**
- Social post generator (Twitter, LinkedIn, Reddit)
- Blog post writer (SEO-optimized)
- Email newsletter (weekly digest)
- Cold outreach (email templates to prospects)
- Analytics reporter (what's working, what's not)

**File:** `marketing/agent.js`

---

### 💰 Sales (Sales Agent)
**What it does:** Closes deals. Talks to customers. Gets revenue.
**Core functions:**
- Lead qualification (is this person worth our time?)
- Discovery questions (understand the pain point)
- Proposal generator (build a quote/pitch)
- Follow-up sequence (remembers to follow up at the right time)
- CRM update (tracks every deal in pipeline)

**File:** `sales/agent.js`

---

### 🧪 Product (Product Agent)
**What it does:** Builds what customers need. Manages the roadmap.
**Core functions:**
- Feature tracker (what are we building next?)
- Bug queue (what's broken that needs fixing?)
- User feedback collector (from sales + support)
- Spec writer (turns idea into buildable spec for Lovable)
- Release notes writer

**File:** `product/agent.js`

---

### 📊 Finance (Finance Agent)
**What it does:** Tracks money in and money out. Reports on health.
**Core functions:**
- Revenue tracker (what came in, from who, when)
- Expense logger (what went out)
- Invoice generator (creates invoices for clients)
- P&L summary (profit and loss, monthly)
- Burn rate calculator (how long until money runs out)
- Cash flow forecast

**File:** `finance/agent.js`

---

### 👥 HR (HR Agent)
**What it does:** Manages people, hiring, culture.
**Core functions:**
- Job description writer
- Interview question generator
- Onboarding checklist (new hire setup)
- Handbook updater (company policies)
- Performance review template

**File:** `hr/agent.js`

---

### 🎧 Support (Support Agent)
**What it does:** Keeps customers happy. Handles complaints.
**Core functions:**
- Ticket responder (common questions answered automatically)
- Escalation tracker (what needs human eyes?)
- FAQ generator
- Satisfaction tracker (NPS scores)
- Refund approval logic

**File:** `support/agent.js`

---

## COORDINATION LAYER

### 🌐 CEO Dashboard
**What it does:** Pulls updates from every department agent.
**Displays:**
- Sales pipeline status
- Marketing active campaigns
- Product shipped this week
- Finance health (revenue vs burn)
- Support open tickets

**File:** `dashboard/agent.js`

---

## FIRST STEPS

The first department to build is **SALES** because revenue is the most urgent need.

Sales agent workflow:
1. Get a lead (from cold email, inbound, Jordan enters manually)
2. Ask discovery questions
3. Qualify: do they have budget? authority? need? timeline?
4. If qualified → create proposal
5. Follow up until close or dead

---

## FILE STRUCTURE

```
/data/workspace/neuromatch/
├── factory/
│   ├── DEPARTMENTS.md (this file)
│   ├── ops/agent.js        ← CEO agent
│   ├── marketing/agent.js
│   ├── sales/agent.js
│   ├── product/agent.js
│   ├── finance/agent.js
│   ├── hr/agent.js
│   ├── support/agent.js
│   └── dashboard/agent.js  ← CEO dashboard
└── README.md
```

---

## WHAT TO BUILD FIRST

**Sales Agent** — because it's the oxygen of the business. Without revenue, nothing else matters.

Every other department depends on it. Marketing feeds it leads. Product builds what Sales sells. Finance tracks it.

**Start: Sales Agent**
- Takes a lead
- Asks 5 discovery questions
- Generates a proposal
- Schedules a follow-up

That's the first customer factory.

---

*Jordan, which department do you want me to build first?* 🦞
