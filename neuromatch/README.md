# 🏭 NEUROMATCH BUSINESS FACTORY

Jordan's company. Built with AI agents, one department at a time.

**Status:** Sales ✅ | Marketing ✅ | Product 🔨 | CEO Dashboard 📋

---

## THE VISION

Build a real company where each department runs on AI agents.
Jordan builds the apps. Agents run the operations.
The factory gets smarter with each department added.

---

## DEPARTMENTS

| # | Department | Status | What it does |
|---|-----------|--------|--------------|
| 1 | 🏭 Ops (CEO) | 📋 Planning | Coordinates all departments |
| 2 | 📢 Marketing | ✅ BUILT | Generates content for all channels |
| 3 | 💰 Sales | ✅ BUILT | Takes leads → qualifies → proposes → closes |
| 4 | 🧪 Product | 🔨 Next | Manages roadmap → specs for Lovable |
| 5 | 📊 Finance | 📋 Planning | Tracks money, invoices, burn rate |
| 6 | 👥 HR | 📋 Planning | Hiring, onboarding, culture |
| 7 | 🎧 Support | 📋 Planning | Customer happiness, tickets |

---

## QUICK START

### Run Sales Agent
```bash
cd /data/workspace/neuromatch/factory/sales
node agent.js add "John Smith" "Acme Corp" "john@acme.com"
node agent.js list
node agent.js discover [lead-id]
node agent.js proposal [lead-id]
```

### Run Marketing Agent
```bash
cd /data/workspace/neuromatch/factory/marketing
node agent.js generate "AppName" "category" "problem" "one-liner"
node agent.js list
node agent.js reddit-communities
```

### Generate Content for an Idea
```bash
node agent.js generate "ReplyForge" "productivity" "writing follow-up emails" "AI writes emails in your style"
```

This generates:
- Twitter/X post
- LinkedIn post
- Reddit post
- Cold email template
- Blog post outline

---

## WORKFLOW

```
MARKETING generates content
       ↓
Content posted → leads come in
       ↓
SALES qualifies lead → discovery → proposal
       ↓
If won → PRODUCT builds it
       ↓
SUPPORT keeps customer happy
       ↓
FINANCE tracks the money
       ↓
OPS (CEO) coordinates everything
```

---

## FILE STRUCTURE

```
/data/workspace/neuromatch/
├── factory/
│   ├── DEPARTMENTS.md          ← Full blueprint
│   ├── sales/
│   │   ├── agent.js            ← ✅ BUILT
│   │   ├── package.json
│   │   └── leads.json          ← Created on first lead
│   ├── marketing/
│   │   ├── agent.js            ← ✅ BUILT
│   │   ├── package.json
│   │   └── posts/
│   │       └── posts.json      ← Generated content
│   ├── product/                ← 🔨 TODO
│   ├── ops/                    ← 📋 TODO
│   ├── finance/                ← 📋 TODO
│   ├── hr/                    ← 📋 TODO
│   └── support/              ← 📋 TODO
└── README.md
```

---

## NEXT: PRODUCT AGENT

Product Agent takes sales requests and turns them into specs for Lovable.

Features:
- Feature tracker (what are we building?)
- Spec writer (turns "they want X" into "build X with Y")
- Bug queue (what's broken?)
- Release notes

---

## WHAT JORDAN ACTUALLY NEEDS

1. ✅ Sales agent (done)
2. ✅ Marketing agent (done)
3. 🔨 Product agent (next — builds the specs)
4. 📋 CEO dashboard (coordinates all three)
5. 📋 Finance, HR, Support (later)

---

## THE COMPOUND EFFECT

Each agent makes the others better:
- Marketing feeds Sales with leads
- Sales tells Product what to build
- Product tells Marketing what to promote
- Finance tells Ops if we're winning

The factory becomes smarter than any single agent.

---

*Built with Jordan. Owned by Jordan.*
*Every department added = 10x more capable.*
