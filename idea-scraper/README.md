# 🔴 Idea Scraper Agent

Scrapes the web for **problems people are actively searching for solutions to** and generates app ideas.

## What it does

1. Scrapes Google Trends for trending searches
2. Scrapes Reddit for problems people complain about
3. Scrapes AlsoAsked for real questions people ask
4. Categorizes by topic
5. Generates app ideas based on real demand signals

## Setup

```bash
cd /data/workspace/idea-scraper
npm install
npx playwright install chromium
```

## Run

```bash
node agent.js
```

## Output

You'll get categorized app ideas like:

```
🔹 PRODUCTIVITY (47 related searches)
   1. Auto-scheduler that blocks time for deep work
   2. Distraction blocker with smart breaks
   3. Unified inbox for all your notifications

🔹 COMMUNICATION (23 related searches)
   1. Email parser that drafts replies in your style
   2. LinkedIn outreach message generator
   3. Slack summary for when you were away
```

## Sources scraped

- Google Trends realtime
- Reddit: r/SideProject, r/indiehackers, r/Entrepreneur, r/startups, r/SaaS
- AlsoAsked.com

## Why this works

Instead of guessing what to build, you build what people are **already searching for solutions to**. That's validated demand.
