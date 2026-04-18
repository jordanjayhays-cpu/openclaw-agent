# MASSAGE-PASS — Launch Readiness Checklist
**Launch date:** April 24, 2026 (6 days out)

---

## ✅ DONE

- [x] Landing page (`landing.html`) — full prelaunch with hero, FAQ, pricing, dual CTAs, comparison table
- [x] Landing prelaunch variant (`landing-prelaunch.html`) — clean, minimal version
- [x] Countdown timer corrected to April 24, 2026
- [x] Hero badge updated: "EARLY ACCESS — FIRST 100 MEMBERS GET 50% OFF MONTH 1"
- [x] Pricing: €49 Essential / €89 Premium (shown in landing page)
- [x] Early bird: €24.50/month (50% off month 1)
- [x] Waitlist form localStorage persistence (spots counter survives refresh)
- [x] Success confirmation inline on form submission
- [x] Notion DB schemas ready (`notion-db-schema.md`) — 3 databases defined
- [x] Waitlist handler (`waitlist-handler.js`) — Formspree-ready, cross-tab counter sync

---

## ⚠️ MUST DO BEFORE LAUNCH

### 1. Formspree (5 min)
Jordan sets up a free form at https://formspree.io, then:
```
Edit PROJECTS/MASSAGE-PASS/waitlist-handler.js
Change: const FORMSPREE_FORM_ID = 'YOUR_FORMSPREE_FORM_ID';
To:     const FORMSPREE_FORM_ID = 'xpwqvdra';  ← your actual ID
```
All landing page forms will then capture real emails.

### 2. Pricing Sign-off
Landing page shows €49 Essential / €89 Premium.
- Need Jordan confirmation to lock these in
- `pricing.json` was updated but note: it previously said €79

### 3. Domain
- Need `massagepass.io` or similar — Jordan to purchase
- DNS not pointed yet

### 4. Notion API Setup (for backend ops after launch)
Steps:
1. Create integration at https://notion.so/my-integrations
2. `echo "ntn_your_key" > ~/.config/notion/api_key`
3. Create parent page in Notion, share with integration
4. Give Axton the parent page ID → I'll create 3 databases automatically

---

## 🔜 DO AFTER LAUNCH

- [ ] Connect booking flow (shop → time slot → confirmation)
- [ ] Onboard shop partners to Notion Shops database
- [ ] Payment integration (Stripe for subscriptions)
- [ ] Testimonials section (real quotes from beta testers)
- [ ] Email sequence (launch emails in `launch-emails.md`)
- [ ] Analytics tracking (GA4 or plausible.io)

---

## BLOCKERS

| Item | Owner | Status |
|------|-------|--------|
| Formspree ID | Jordan | ⏳ Waiting |
| Pricing sign-off | Jordan | ⏳ Waiting |
| Domain purchase | Jordan | ⏳ Waiting |
| Notion parent page ID | Jordan | ⏳ Waiting |
| Real testimonials | Jordan | ⏳ Waiting |

---

*Last updated: 2026-04-18 14:10 UTC*
