# LeadPulse — Warm Outreach Tracker

**One-file CRM for Jordan's sales pipeline. Track leads, follow-ups, and warm streaks.**

---

## 🎯 What it does

- **Pipeline Kanban**: 4-column board (Cold → Warm → Hot → Booked)
- **Lead Management**: Add/edit/delete with name, company, email, source, confidence, notes
- **Follow-up Scheduler**: Visual due dates with overdue highlighting
- **🔥 Warm Streak**: Daily outreach streak counter (bumped each time you add a lead)
- **Stats Header**: Total leads, hot count, due today — always visible
- **Filter + Search**: Filter by status, search by name/company/email
- **Export CSV**: One-click export of entire pipeline
- **Keyboard shortcut**: Press `N` anywhere to quick-add a lead

---

## 🚀 How to run

**Option A — Open directly:**
```bash
open PROJECTS/overnight-builds/2026-04-16/index.html
```

**Option B — Deploy to Vercel (instant):**
```bash
cd PROJECTS/overnight-builds/2026-04-16
npx vercel
```

**Option C — Deploy to Netlify:**
```bash
cd PROJECTS/overnight-builds/2026-04-16
npx netlify deploy --prod
```

---

## 📦 What's included

```
2026-04-16/
├── index.html      # The entire app (HTML + CSS + JS, no build step)
├── README.md       # This file
└── PROJECT.md      # Build notes & decisions
```

---

## 🗃️ Data & Privacy

- All data stored in **browser LocalStorage** — no server, no account
- Data persists across sessions on the same browser/device
- To clear: open browser dev tools → Application → LocalStorage → Clear
- Seeded with 5 sample PISCO leads on first load (delete them freely)

---

## ⌨️ Keyboard shortcuts

| Key | Action |
|-----|--------|
| `N` | Open "Add New Lead" modal (when not in a form field) |

---

## 🧩 Stack

- **Vanilla JS** (no framework, no build step)
- **Tailwind CSS** via CDN
- **Inter** font via Google Fonts
- **LocalStorage** for persistence
- Single HTML file → deployable anywhere

---

## ✅ Build notes

- Built in ~45 min (10:52 AM UTC start)
- Seeded with Jordan's real PISCO leads as sample data
- Streak bumps when you add a lead; resets if you miss a day
- Fully responsive (mobile → kanban scrolls horizontally)
- No backend needed — purely client-side

---

## 📌 Next possible additions (not MVP scope)

- [ ] Import from CSV
- [ ] Bulk status change
- [ ] Reminder notifications (browser push)
- [ ] Sync across devices (Supabase/Stripe auth)
- [ ] Activity log per lead (calls, emails sent)
- [ ] Win/loss analytics charts
- [ ] Tags/labels for segmentation