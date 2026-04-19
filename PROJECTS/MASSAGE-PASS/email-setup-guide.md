# MASSAGE-PASS — Email Platform Setup Guide

**Urgency: HIGH** — Email 1 goes out April 21 (2 days away)

---

## Your Situation

The 5-email launch sequence is fully drafted in `launch-emails.md`.
You need an email platform to send it. Here's the fastest path.

---

## Option 1: ConvertKit (Recommended — 5 min setup)

**Why:** Easiest for someone new to email marketing. Free up to 300 subscribers.

### Steps

1. Go to [convertkit.com](https://convertkit.com) → Create free account
2. Create a **Form** called "MASSAGE-PASS Waitlist" (this captures emails)
3. Go to **Sequences** → Create new sequence "MASSAGE-PASS Launch"
4. Add all 5 emails (copy from `launch-emails.md`)
5. Set send schedule per the calendar in that file:
   - Email 1: Apr 21, 9am
   - Email 2: Apr 22, 9am
   - Email 3: Apr 24, 8am
   - Email 4: Apr 24, 6pm
   - Email 5: Apr 26, 9am
6. Connect the form → sequence (new subscribers enter automatically)
7. Import your waitlist: go to **Subscribers** → **Import** → upload CSV

### CSV Format for Import
```csv
email,first_name
jane@example.com,Jane
pedro@example.com,Pedro
```

---

## Option 2: Mailgun (Free — 10 min setup)

**Why:** Free up to 5,000 emails/month. More technical but more control.

### Steps

1. Go to [mailgun.com](https://mailgun.com) → Create free account
2. Verify your domain (or use their sandbox for testing)
3. Go to **Campaigns** → Create campaign "MASSAGE-PASS Launch"
4. Add subscribers manually or via CSV upload
5. Add emails as template blocks (copy from `launch-emails.md`)
6. Schedule per the send calendar in `launch-emails.md`
7. Set up tracking: open tracking is automatic

### Sandbox Mode (Testing)
```
Sandbox domain:	sandboxXXXXXXXX.mailgun.org
API key:	      (shown in Mailgun dashboard)
```
⚠️ Sandbox limits you to 5 authorized recipients. Use for testing only.

---

## Option 3: Beehiiv (Free — 5 min setup)

**Why:** Newer, clean UI, built for newsletters. Free up to 2,500 subscribers.

### Steps

1. Go to [beehiiv.com](https://beehiiv.com) → Create account
2. Create a **Publication** called "MASSAGE-PASS"
3. Go to **Audience** → Import your waitlist CSV
4. Go to **Automations** → Create sequence (same 5-email schedule)
5. Set up your custom domain (optional — do later)

---

## Quick Comparison

| Platform | Free Tier | Best For | Setup Time |
|----------|-----------|----------|------------|
| ConvertKit | 300 subscribers | Beginners, ease | 5 min |
| Mailgun | 5,000/mo emails | Control, volume | 10 min |
| Beehiiv | 2,500 subscribers | Newsletter vibes | 5 min |

**My rec for you:** ConvertKit. Fastest to get live.

---

## Importing Your Waitlist

If you have emails in Formspree or a spreadsheet, export to CSV first:
```
email,first_name,source,signup_date
maria@gmail.com,Maria,landing-page,2026-04-18
```

All platforms accept CSV import.

---

## One Thing Before You Send

Add an **unsubscribe link** to every email. It's legally required (GDPR/CAN-SPAM).
In ConvertKit/Beehiiv it's automatic. In Mailgun, add this to each email footer:
```
<a href="%unsubscribe_url%">Unsubscribe</a>
```

---

## What I Can't Do For You

- [ ] Create your email platform account (Jordan task)
- [ ] Import your waitlist CSV (Jordan task)
- [ ] Review + approve `launch-emails.md` before first send
- [ ] Press send

---

## After You Set Up the Platform

Once you have an API key or account, tell me and I'll:
1. Build the Formspree → Notion pipeline for real subscriber capture
2. Update the landing page form to connect to your platform
3. Set up automated welcome email for new subscribers

---

*Created by Axton — Day 5 Check-in (Apr 19, 2026)*
