# LinkedIn Outreach Skill

## When to Use

Trigger phrases:
- `linkedin dm`, `send dm`, `linkedin message`
- `outreach to [name]`, `linkedin outreach`
- `follow up [name]`, `sequence for [prospect]`
- `generate dm`, `write linkedin message`

This skill generates personalized LinkedIn DMs for Jordan's projects. **All DMs are drafted for Jordan's review and approval before sending.**

---

## Project Context

### PISCO — Filipino BPO Staff Placement
**What:** Staff Filipino talent to European hotels and healthcare facilities
**Value prop:** Cost savings (60-70% vs local), English fluency, 24/7 coverage, cultural fit
**Target:** Hotel GMs, HR Directors, Healthcare Administrators, Operations Managers
**Countries:** Spain, Germany, UK, Netherlands primarily

### ProfileStack — LinkedIn Profile Rental Marketplace
**What:** Rent LinkedIn profiles for lead generation and sales outreach
**Value prop:** Bypass connection limits, access warm audiences, bypass filters
**Target:** Sales teams, recruiters, BD professionals, agency founders
**Two sides:** Supply (profile owners earn passive income) + Demand (buyers get outreach capacity)

### COMARE — Mexico Maintenance BD
**What:** Business development for maintenance services in Mexico
**Target:** Gyms, pharmacies, retail chains, office buildings
**Language:** Primarily Spanish outreach

### Massage Pass — Madrid Massage Platform
**What:** Aggregates and promotes massage shops in Madrid
**Target:** Wellness centers, massage studios, physiotherapy clinics in Madrid
**Language:** Spanish for local, English for expat-focused

---

## LinkedIn DM Rules

1. **Under 300 characters** — LinkedIn shows preview text; short = readable
2. **No opening pleasantries** — Skip: “I hope you're well”, “Hope this finds you well”, “How are you?”
3. **Lead with value or shared context** — Hook in the first line
4. **Clear CTA** — Always include what you want them to do next
5. **Personalize every message** — Use their name, company, title, or a specific detail
6. **One message = one goal** — Don't cram multiple asks
7. **Match their language** — Spanish speakers get Spanish DMs
8. **No emojis in cold outreach** — Warm/follow-up can use sparingly

---

## How to Generate a DM

When Jordan asks for a LinkedIn DM, extract:
- **Prospect name**
- **Company**
- **Title/role**
- **Country**
- **Project** (PISCO / ProfileStack / COMARE / Massage Pass)
- **Warm or cold** (warm = shared connection or prior interaction)
- **Follow-up?** (if yes, include step number)

Then reference `templates/dm-templates.md` and customize for that prospect.

---

## Output Format

When generating a DM, return:

```
[Draft DM — Jordan reviews before sending]

To: [Name] | [Title] @ [Company]
Project: [PISCO / ProfileStack / COMARE / Massage Pass]
Type: [Cold / Warm / Follow-up #X]

---
[DM text here — under 300 chars]
---

Char count: [X]/300
CTA: [What's the next step]
Notes: [Any personalization details used]
```

---

## Follow-Up Sequence Framework

For any prospect that doesn't respond:

**Follow-up 1 (3-5 days):**
Acknowledge no response, add new piece of value, restate CTA

**Follow-up 2 (7-10 days):**
Different angle or new insight, softer ask

**Follow-up 3 (14-21 days):**
Break pattern, ask if timing is wrong, offer to reconnect later

---

## Quick Reference

| Project | Language | Key Pain Point |
|---------|----------|----------------|
| PISCO Hotels | EN/ES | Staff shortages, cost overruns |
| PISCO Healthcare | EN | 24/7 coverage gaps, cost |
| ProfileStack Supply | EN | Earn from existing network |
| ProfileStack Demand | EN | Scale outreach without limits |
| COMARE | ES | Equipment downtime, maintenance costs |
| Massage Pass | ES | Customer acquisition |

---

## Files

- `SKILL.md` — This file (skill instructions)
- `templates/dm-templates.md` — All DM templates by project and type