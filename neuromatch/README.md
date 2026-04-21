# 🏭 NEUROMATCH BUSINESS FACTORY

Jordan's company. Built with AI agents, one department at a time.

## The Vision

Build a real, functioning business where each department runs on AI agents.
Jordan builds the apps. Agents run the operations.

---

## DEPARTMENTS

| Department | Status | What it does |
|------------|--------|--------------|
| 🏭 Ops | Planning | CEO agent — coordinates everything |
| 📢 Marketing | Planning | Gets the word out, brings leads |
| 💰 Sales | **BUILT** ✅ | Takes leads → qualifies → proposes → closes |
| 🧪 Product | Planning | Manages roadmap, specs for Lovable |
| 📊 Finance | Planning | Tracks money in/out, invoices, burn |
| 👥 HR | Planning | Hiring, onboarding, culture |
| 🎧 Support | Planning | Keeps customers happy |

---

## QUICK START

### Add a lead
```bash
cd /data/workspace/neuromatch/factory/sales
npm install
node agent.js add "John Smith" "Acme Corp" "john@acme.com"
```

### List all leads
```bash
node agent.js list
```

### Run discovery for a lead
```bash
node agent.js discover [lead-id]
```

### Generate proposal
```bash
node agent.js proposal [lead-id]
```

---

## WHAT TO DO NEXT

1. **Add your first lead** — anyone you know who might need something built
2. **Run discovery** — answer the 5 questions for that lead
3. **Generate proposal** — if qualified, send them the proposal
4. **Get first customer** — celebrate, then do it again

---

## FILE STRUCTURE

```
/data/workspace/neuromatch/
├── factory/
│   ├── DEPARTMENTS.md
│   ├── ops/
│   ├── marketing/
│   ├── sales/          ← FIRST TO BUILD ✅
│   │   ├── agent.js
│   │   ├── package.json
│   │   └── leads.json  ← created on first run
│   ├── product/
│   ├── finance/
│   ├── hr/
│   └── support/
└── README.md
```

---

## WHAT JORDAN ACTUALLY NEEDS

1. ✅ Sales agent (done)
2. Marketing agent (next)
3. Product agent
4. CEO dashboard (pulls everything together)

Every department feeds into Sales because **revenue is oxygen**.

---

*Built with Jordan. Owned by Jordan.*
