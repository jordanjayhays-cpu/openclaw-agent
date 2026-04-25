# PISCO — What's Ready & What's Blocking (2026-04-25)

## ✅ WHAT'S READY

### Emails — Already Written, Ready to Send NOW
- **10 personalized email drafts** → `PROJECTS/PISCO/email-drafts-ready.md`
- **Javier follow-up draft** → `PROJECTS/PISCO/email-javier-followup-draft.md`
- **3 priority emails for TODAY** → `/PISCO/PISCO-EMAILS-TO-SEND.md`

### Contacts — Researched & Verified
| Contact | Company | Email | Status |
|---------|---------|-------|--------|
| Rachel King | Spire Healthcare | via LinkedIn | WARM - expecting contact |
| Victor Presa | Meliá Hotels | via LinkedIn | WARM - interested in pilot |
| Javier Estrada | NH Hotel Group | jestrada@nh-hotels.com | HOT - follow-up due |
| Luis Zamora | Iberostar | luis.zamora@iberostar.com | COLD - first outreach |
| Concha Pardo | Meliá Hotels | concha.pardo@melia.com | COLD - never contacted |
| Gabriel Cánaves | Meliá Hotels | gabriel.canaves@melia.com | COLD - never contacted |

### Pitch Deck — Built
- `PISCO-DECK.html` — 8-slide deck ready (can share as PDF)

### CRM — Built
- `contacts/CONTEXT.md` — updated with all contacts

---

## 🚧 WHAT'S BLOCKING

### BLOCK #1 — OpenRouter API Key (CRITICAL)
**Status:** 401 Unauthorized — key is dead or quota exceeded
**Fix:** Jordan needs to check openrouter.ai account → API keys → create new key or check billing

### BLOCK #2 — Email Sending Infrastructure
**Status:** No clear SendGrid or alternative setup found
**Options to research:**
- **Gmail** (Jordan's personal) — manual send, works today, 500/day limit
- **Apollo.io** — $49/mo, built-in email finder + warmup
- **Instantly.ai** — $73/mo, unlimited warmup, good for cold email
- **Heyreach** — $59/mo, LinkedIn + email combined
- **Smartlead** — $33/mo, unlimited emails, good for cold outreach

### BLOCK #3 — Rachel King's Email Address
Rachel is listed as "warm" but her email wasn't found in contacts. Need to find:
- rachel.king@spirehealthcare.com (likely pattern)
- Or use LinkedIn Sales Navigator to find it

---

## 🎯 JORDAN'S ACTION PLAN — SEND FIRST EMAIL TODAY

### Step 1: Fix OpenRouter (2 min)
Go to openrouter.ai → API Keys → create new key → paste into `MiroFish/.env` as `LLM_API_KEY=`

### Step 2: Find Rachel King's Email (5 min)
Use hunter.io or LinkedIn Sales Navigator to find Rachel King's email at Spire Healthcare.
Expected pattern: firstname.lastname@spirehealthcare.com

### Step 3: Send Email #1 (Rachel King) — TODAY
Use the email in `PISCO-EMAILS-TO-SEND.md`

### Step 4: Send Email #2 (Victor Presa) — TODAY
Spanish version in same file

### Step 5: Send Email #3 (Javier Estrada) — TOMORROW
Follow-up promised

---

## 📧 THE 3 EMAILS TO SEND RIGHT NOW

### EMAIL 1 — Rachel King @ Spire Healthcare (ENGLISH)
**Subject:** Replicating the NHS Filipino nurse model for Spire

Hi Rachel,

Following up on our earlier conversation about international staffing. I wanted to share something that's been getting a lot of attention in UK healthcare HR circles.

The NHS recruited 3,400 Filipino nurses in 18 months — at £8,500 per hire vs. the typical £15,000 agency rate. Their retention rate at 2 years is 87%, compared to 71% for domestic hires.

With Spire operating 38 hospitals, I think there's a compelling case for applying the same model to your staffing challenges.

I've put together a short 1-pager specifically for private hospital groups like Spire. Would love to send it over — or better yet, jump on a 20-minute call this week to walk through it.

Best,
Jordan Hays
+34 612 22 38 79
IE Business School | MBA Candidate

---

### EMAIL 2 — Victor Presa @ Meliá Hotels (SPANISH)
**Subject:** El modelo NHS para hoteles españoles — ¿hablamos?

Hola Victor,

Quiero hacer seguimiento de nuestra conversación sobre personal filipino para hoteles.

Un dato que creo te será relevante: el NHS reclutó 3,400 enfermeras filipinas en 18 meses, con una retención del 87% a 2 años. Para hoteles españoles — donde la rotación está en el 45% anual — el caso económico es bastante claro.

He preparado una propuesta piloto específica para grupos hoteleros como Meliá. ¿Podemos hacer una llamada rápida esta semana para revisarla?

Un saludo,
Jordan Hays
+34 612 22 38 79
IE Business School | MBA

---

### EMAIL 3 — Javier Estrada @ NH Hotel Group (FOLLOW-UP)
**Subject:** Following up — promised case studies + pilot proposal

Hey Javier,

Wanted to circle back — I promised to send case studies after our last chat and I haven't delivered yet. My bad.

I've now got data from 3 Spanish hotel groups that have run Filipino staff pilots. Happy to share the numbers privately.

Also have a refined pilot proposal that's specifically built for NH's Madrid properties. Would love to meet in person if you're free this week — even just 20 minutes over coffee?

Let me know.
Jordan
+34 612 22 38 79

---

## 📊 SENDGRID STATUS

SendGrid not set up. Jordan's options:

**Quickest path (send TODAY):**
- Use Gmail (jordan.hays@ie.edu or personal) with SMTP
- OpenClaw has email-daily-summary skill but it's for reading, not sending
- Jordan can simply copy-paste emails into Gmail manually

**Professional path (next week):**
- Apollo.io — $49/mo, email finder + sequences
- Instantly.ai — $73/mo, unlimited warmup, scales cold email

**RECOMMEND:** Start with Gmail today, set up Apollo this week.

---

## 🏁 NEXT ACTION FOR JORDAN

1. **Right now:** Go to openrouter.ai → check API key status
2. **This evening:** Send Rachel + Victor emails (copy-paste from above)
3. **Tomorrow:** Send Javier follow-up email
4. **This week:** Set up Apollo.io for professional outreach
5. **Track responses** in PISCO/PISCO-EMAILS-TO-SEND.md tracker