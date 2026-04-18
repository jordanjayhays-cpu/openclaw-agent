# MASSAGE-PASS — Launch Email Sequence
**Status:** Ready to send | **Sequence:** 5 emails | **Platform:** Mailgun/ConvertKit pending

---

## Send Calendar (April 24, 2026 = Launch Day)

| # | Email | Send Date | Timing |
|---|-------|-----------|--------|
| 1 | Waitlist Teaser | Apr 21 (Mon) | 9am |
| 2 | Early Access Offer | Apr 22 (Tue) | 9am |
| 3 | Launch Day Blast | Apr 24 (Thu) | 8am |
| 4 | Launch Day Follow-up | Apr 24 (Thu) | 6pm |
| 5 | Founding Member Close | Apr 26 (Sat) | 9am |

---

## Email 1: Waitlist Teaser (Apr 21 — 3 days out)
**Subject:** 3 days. Something's coming. 🏃‍♂️
**Goal:** Reactivate cold waitlist, build anticipation

```
Hey [First Name],

3 days.

That's how long until something we've been building for months goes live in Madrid.

You signed up for the waitlist. That means you're one of the first to know.

Massage-Pass — unlimited monthly massages at partner studios across the city. €49/month.

We're not the cheapest. We're the easiest.

No calling around. No waiting weeks for an appointment. You subscribe, you book, you go. That's it.

Monday, April 24 — you'll hear from us first.

Until then, a question:

What's the last massage you had? How long ago was it?

Reply and tell me. I read every one.

— Jordan
Founder, Massage-Pass
```

---

## Email 2: Early Access Offer (Apr 22 — 2 days out)
**Subject:** Your 24-hour early access window. 🚪
**Goal:** Convert waitlist → paying members, scarcity on founding price

```
Hey [First Name],

Tomorrow, Massage-Pass goes live.

But you don't have to wait.

For the next 24 hours, you're getting early access. Founding member pricing. First 100 subscribers lock in 50% off month one.

Here's what you get:

✅ Unlimited massage access at 50+ partner studios across Madrid
✅ Swedish, deep tissue, sports recovery — whatever your body needs
✅ Book in 30 seconds, no phone calls
✅ New studios added every week
✅ First month at 50% off — €24.50 instead of €49

After 100 founding members, the price goes up and the deal's gone.

→ [CLAIM FOUNDING MEMBER SPOT]

This isn't a trick. The link is live now. You can subscribe today and be our first member.

Or you can wait until tomorrow and take your chances with everyone else.

Your call.

— Jordan

P.S. If you know someone whose shoulders are as wrecked as mine, forward this to them. Founding member spots don't last.
```

---

## Email 3: Launch Day Blast (Apr 24 — 8am)
**Subject:** 🚀 It's live. Madrid, meet Massage-Pass.
**Goal:** Full launch announcement, push conversions

```
Hey [First Name],

It's live.

Massage-Pass launched 30 minutes ago in Madrid. The whole thing works.

50+ studios. Swedish, deep tissue, sports recovery. Book in 30 seconds. Show up. Feel better.

Founding member pricing is still available — but not for long. We've already claimed [X] of the first 100 spots.

Here's what you get as a founding member:

€49/month → €24.50 for your first month (50% off, locked in forever)
€89/month → €44.50 for Premium (unlimited, every massage type)

After 100 founding members, those prices go up and never come back down.

→ [GET MASSAGE-PASS NOW]

One more thing — if you're on the fence, here's my honest take:

Your body is the only one you've got. The tension in your shoulders from this week isn't going anywhere on its own. €49/month for unlimited massage is cheaper than one acupuncture session.

Book the subscription. Book the massage. You'll thank me.

— Jordan

P.S. If it's not for you — no hard feelings. Just don't wait until your back gives out before you do something about it.
```

---

## Email 4: Launch Day Follow-Up (Apr 24 — 6pm)
**Subject:** 12 hours in. Here's what's happening. 📊
**Goal:** Social proof, urgency, recapture non-openers

```
Hey [First Name],

12 hours.

That's how long Massage-Pass has been live. Here's what happened:

[X] founding members signed up today
[XX] massages booked
[XX] studios active across Madrid

The founding member price is still available — but we're at [XX]/100 spots claimed.

If you were on the fence, here's what I know:

Every single person who has signed up so far was also on the fence. They just made a decision faster.

Your future self — the one with less shoulder tension and fewer headaches — is waiting on the other side of a 30-second booking.

→ [GET MASSAGE-PASS — FOUNDING MEMBER PRICING STILL LIVE]

See you on the table.

— Jordan
```

---

## Email 5: Founding Member Close (Apr 26 — 2 days post-launch)
**Subject:** Last call: founding member window closes Sunday. ⏰
**Goal:** Final push before price goes up, capture remaining waitlist

```
Hey [First Name],

Sunday night. That's when founding member pricing disappears.

After that: €49/month, full price. No 50% discount. No locked-in rate.

If you've been on this list since the beginning — and a lot of you have — you had first access, best price, and the most time to decide.

The people who already signed up made the right call. They're already booking massages.

The window closes Sunday at midnight.

→ [CLAIM YOUR SPOT — 2 DAYS LEFT]

— Jordan

P.S. After Sunday, this sequence is done. I won't email you again unless you reach out first.
```

---

## Email Configuration Notes

**Platform:** ConvertKit or Mailgun (Jordan to decide)
**List segmentation:**
- `waitlist` — people who signed up pre-launch, no payment yet
- `founding_members` — people who subscribed
- `launch_24` — people who showed interest but didn't convert

**Merge fields needed:**
- `{{first_name}}` — from signup
- `{{founders_spots_claimed}}` — dynamic count
- `{{founders_spots_left}}` — dynamic count (100 - claimed)
- `{{pricing_link}}` — UTM-tagged landing page URL

**Unsubscribe:** Required on all emails. One-click unsubscribe in footer.

---

## What Axton Can't Do (needs Jordan)
- Connect email platform (ConvertKit/Mailgun) to waitlist
- Write actual copy for studio partners
- Approve final pricing
- Set up domain email (from: founders@massagepass.io)
- Review and approve before sending

*Last updated: 2026-04-18 18:50 UTC*
