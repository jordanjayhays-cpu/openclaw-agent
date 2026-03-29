# TIER 1 SETUP — FREE AUTOMATION STACK
## How to Set Up Each Tool

---

## STEP 1: Install Duxsoup (Chrome Extension)

```
1. Go to: duxsoup.com
2. Click "Add to Chrome" (free tier available)
3. Create free account
4. Log into LinkedIn on Chrome
5. In Duxsoup: Click "Auto-funnel" → Set up connection requests
6. Target: "HR Director" + "NH Hotel" + "Madrid"
7. Send 50/day max on free tier

This is MANUAL proxy for LinkedIn.
Jordan does the browsing.
I (Claw) prepare the lists.

What you do:
- Install Duxsoup
- Log into LinkedIn
- Select prospects from my list
- Click "Auto-visit + connect"

Time per day: 5 minutes
```

---

## STEP 2: Set Up Notion CRM (Free)

```
1. Go to: notion.so
2. Create workspace (free)
3. Create these pages:

PAGE 1: PISCO Pipeline
TABLE with columns:
- Company
- Contact Name
- Title
- LinkedIn
- Email
- Stage (Lead, Contacted, Responded, Meeting, Contract, Signed)
- Last Contact
- Next Action
- Notes

PAGE 2: Pod Members
TABLE with columns:
- Name
- Email
- Join Date
- Paid (Yes/No)
- Last Session
- Notes

PAGE 3: Daily Check-ins
 DATABASE with:
- Date
- Question
- Answer
- Reflection

PAGE 4: Weekly Reviews
 DATABASE with:
- Week
- Wins
- Losses
- Learnings
- Next Week

What I do:
- Update the Notion tables after each interaction
- Query Notion to see pipeline status
- Log everything
```

---

## STEP 3: Set Up n8n on Railway (Free automation)

```
Railway already runs OpenClaw.
n8n can run on the same server.

INSTALLATION:

1. SSH into Railway server
2. Run:
   docker pull n8nio/n8n
3. Run:
   docker run -d --name n8n \
     -p 5678:5678 \
     -v n8n_data:/home/node/.n8n \
     n8nio/n8n

4. Access at: http://YOUR_RAILWAY_IP:5678

SETUP:
1. First time: Create account
2. Create webhook URL for Telegram bot
3. Connect to Notion
4. Connect to LinkedIn (via Duxsoup API)
5. Connect to SendGrid

WORKFLOWS TO BUILD:

Workflow 1: Email Response → Notion
- New email response from prospect
- Parse intent (hot/warm/cold)
- Add to Notion pipeline
- Alert Jordan via Telegram

Workflow 2: Call Complete → Summary
- Jordan finishes call
- Sends voice note to Telegram
- n8n triggers
- I transcribe (via Whisper API)
- Save to Notion
- Update contacts

Workflow 3: Payment Received → Pipeline Update
- Payment hits PayPal
- n8n detects
- Update Notion Pod Members
- Send thank you message
- Schedule onboarding
```

---

## STEP 4: Connect Google Meet (Free tier)

```
Google Meet has free transcription:
1. Start Google Meet
2. Click "Activities" → "Record attendance"
3. During call: Click "Turn on transcripts"
4. After call: Transcript saved to Google Drive

What I do:
- Jordan sends me the transcript
- I extract key points
- I update contacts/CONTEXT.md
- I identify action items

Or:
Use Google Docs voice typing:
1. Open Google Doc
2. Tools → Voice typing
3. Start call, leave doc open
4. Transcribes in real-time
5. Send me the doc
```

---

## STEP 5: PayPal Setup (Already have)

```
You already have PayPal.

What to set up:
1. Create PayPal.Me link (paypal.me/jordanjayhays)
2. Share link in Pod messages
3. Payment notifications → email to me
4. I track in Notion

Merchant instructions:
- Activate PayPal.Me
- Set up payment buttons on Notion
- Invoice manually via PayPal

Cost: 3.5% per transaction (still cheapest for <$100/mo volume)
```

---

## QUICK START CHECKLIST

```
□ Install Duxsoup Chrome extension
□ Create Notion workspace
□ Create PISCO Pipeline table
□ Create Pod Members table
□ Deploy n8n on Railway
□ Set up PayPal.Me
□ Connect Telegram to n8n (webhook)
□ Test: prospect email → Notion update

TIME TO SETUP: 2-3 hours
COST: $0
```

---

## WHAT HAPPENS AFTER SETUP

```
Jordan:
- Uses Duxsoup to send LinkedIn requests (5 min/day)
- Logs into Notion to see pipeline
- Sends me voice notes after calls
- Shares PayPal.Me link

Me:
- Monitors emails for responses
- Updates Notion pipeline
- Processes voice notes
- Tracks Pod payments
- Follows up automatically

Result:
- Outreach runs daily
- Pipeline updates automatically
- Jordan just shows up to calls
```

---

_Created by Claw 🦞_
_Tier 1 Setup Guide_
_March 29, 2026_
