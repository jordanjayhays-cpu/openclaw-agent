# MASSAGE-PASS Launch Day Playbook
*Generated: 2026-04-21 02:35 UTC — 3 days to launch*

---

## Launch Day: April 24, 2026

### Pre-Launch Checklist (Days 1-3)

**Jordan must complete before launch day:**
- [ ] Purchase domain (massagepass.com or similar)
- [ ] Deploy landing page to domain
- [ ] Wire Formspree (replace `YOUR_FORM_ID` in landing page JS)
- [ ] Set up email platform (ConvertKit recommended — free, 5-min setup)
- [ ] Approve `launch-emails.md` — all 5 emails
- [ ] Confirm pricing: €49/mo Essential, €89/mo Premium
- [ ] Share Notion parent page ID → Axton builds 3 DBs automatically

---

## April 24 — Launch Day Operations

### 6:00 AM UTC (8:00 AM CET) — Wake Up Check
- [ ] Check waitlist count (open `waitlist-dashboard.html`)
- [ ] Confirm domain is live
- [ ] Confirm Formspree is receiving submissions
- [ ] Check email platform is connected

---

### 9:00 AM UTC (11:00 AM CET) — Email 3: Launch Day Blast

**Subject:** It's live. Unlimited massages. One subscription.

Send to: full waitlist
File: `launch-emails.md` → Email 3

```
[Email 3 — Launch Day Blast]

MASSAGE-PASS is LIVE.

€49/month. Unlimited massages at 50+ studios across Madrid.
Chueca, Chamberí, Salamanca, Malasaña, Centro — all included.

Founding member pricing (€24.50/mo) closes April 26.
→ [Get My Pass]

No contracts. Cancel anytime. First month at half price.
```

---

### 9:30 AM UTC — Product Hunt Submission

1. Go to [producthunt.com](https://producthunt.com)
2. Log in (create account if needed)
3. Click "Submit" → URL: `https://massagepass.com` (or landing page URL)
4. Tagline: "All-you-can-massage subscription for urban professionals in Madrid"
5. Description: Copy from `product-hunt-submission.md`
6. Topics: wellness, health, subscription, madrid, self-care

**First comment template** (post immediately after launch):
```
🚀 We're live. Founding member pricing closes April 26.
First 100 members lock in 50% off for life.
Current spots: [check waitlist-dashboard.html]
```

---

### 10:00 AM UTC — Social Posts

**Twitter/X:**
```
MASSAGE-PASS is live. ✅
€49/mo for unlimited massages at 50+ studios across Madrid.
Founding spots closing soon → [link]
```

**LinkedIn:**
```
Thrilled to announce MASSAGE-PASS is officially live.

Urban professionals in Madrid: unlimited massages, one subscription, €49/month.

50+ partner studios. No contracts. Founding pricing closes April 26.

Launched in 72 hours from zero to product-ready. IE IMBA Capstone Project.
→ [link]
```

**Instagram (Feed Post):**
```
Madrid, we're live. 🎉

Unlimited massages. One subscription. €49/month.

50+ studios across the city — Chueca, Chamberí, Salamanca, Malasaña, and more.

Founding member pricing closes April 26.
First 100 members lock in 50% off for life.

→ Link in bio to claim your spot.
```

---

### 11:00 AM UTC — Studio Confirmations

DM all confirmed shops (Mayoac, The Fix Room):
```
Hey [NAME], MASSAGE-PASS just went live. Launch day is today.

Can you confirm:
1. You're set up to receive MASSAGE-PASS members
2. Your booking system is ready for first members

First bookings should come through within 24-48 hours.
Let me know if you need anything from our end.
```

---

### 2:00 PM UTC — Email 4: Afternoon Follow-up

**Subject:** Still on the fence? Here's why 50+ people already said yes.

Send to: full waitlist (non-openers from Email 3)
File: `launch-emails.md` → Email 4

```
[Email 4 — Afternoon Follow-up]

Quick update: 50+ people have already claimed founding member spots.

Madrid's massage market runs €60-90 per session.
MASSAGE-PASS is €49/month for unlimited access.

At 2 visits/month, you're saving €70+ per month vs pay-per-visit.
At 4 visits/month, you're saving €190+ per month.

Founding price (€24.50/mo) closes April 26.
→ [Lock In My Founding Price]
```

---

### 6:00 PM UTC — Evening Status Check

- [ ] Check waitlist dashboard for new signups
- [ ] Check Formspree for captured emails
- [ ] Check email platform for open rates
- [ ] Log new subscribers to `subscribers.json`
- [ ] Update `waitlist-dashboard.html` with real numbers

---

## April 25-26 — Post-Launch Follow-up

### April 25, 9:00 AM UTC — Email 5: Final Close

**Subject:** Last chance: founding member pricing closes tomorrow.

Send to: full waitlist + new signups from launch day
File: `launch-emails.md` → Email 5

```
[Email 5 — Final Close]

Tomorrow (April 26), founding member pricing goes away.

Last chance to lock in 50% off for life:
→ [Claim My Founding Spot]

After April 26: €49/month standard pricing.

Questions? Just reply to this email.
```

---

## Notion DB Updates (After Jordan Shares Parent Page ID)

Once Jordan provides Notion API key + parent page ID, I will:

1. Create `🛒 MASSAGE-PASS: Shops` database
   - Properties: Name, Status, Location, Contact Name, Contact Email, Contact Phone, Rate (€), Commission (%), Notes, Signed Date, Website

2. Create `👥 MASSAGE-PASS: Subscribers` database
   - Properties: Name, Status, Email, Phone, Plan, Join Date, Cancellation Date, Notes, Source

3. Create `📅 MASSAGE-PASS: Bookings` database
   - Properties: Booking ID, Subscriber Name, Subscriber Email, Shop, Status, Request Date, Visit Date, Visit Time, Shop Notified, Shop Confirmed, Subscriber Notified, Notes

4. Update `STATE.yaml` with database IDs

---

## Metrics to Track

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Waitlist signups | 100+ by launch | Formspree / waitlist-dashboard.html |
| Founding spots claimed | 50+ by Apr 24 | waitlist-dashboard.html localStorage |
| Email open rate | 40%+ | ConvertKit/Mailgun dashboard |
| Product Hunt votes | 20+ | PH submission page |
| Studio confirmations | 5+ shops | Manual check with shops |
| Website traffic | 200+ visits | Domain analytics |

---

## Files Reference

- Landing page (recommended): `landing-prelaunch-v3.html` or `landing-final.html`
- Email sequence: `launch-emails.md` (all 5 emails)
- Social posts: `social-launch.md` (Twitter, LinkedIn, IG, FB)
- Product Hunt: `product-hunt-submission.md`
- Waitlist tracker: `waitlist-dashboard.html`
- Analytics: `analytics.html`
- Studio outreach: `shop-outreach.md` + `shop-outreach-v2.md`
- IG assets: `ig-visual-brief.md` (send to designer/Canva)

---

*Logged by Axton at 2026-04-21 02:35 UTC*
*3 days to launch — Jordan's action items are the critical path*