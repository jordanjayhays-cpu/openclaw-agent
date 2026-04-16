# Overnight Mini-App: LEADPULSE
**Date:** 2026-04-16
**Time:** ~1 hour build

## What it is
A warm outreach tracker for Jordan's sales/prospect pipeline.
Track leads, schedule follow-ups, see what's hot.

## Stack
- Single HTML file (Vanilla JS, Tailwind via CDN)
- LocalStorage persistence
- Deploy: static hosting (Vercel/Netlify)

## Features
1. Add/Edit/Delete leads (name, company, email, status, source, notes)
2. Status pipeline: Cold → Warm → Hot → Booked → Won/Lost
3. Follow-up date scheduler with visual reminders
4. Pipeline kanban view (4 columns)
5. Warm streak counter (consecutive days with outreach)
6. Quick-add shortcut (keyboard)
7. Export to CSV

## Why this one
- Jordan does constant outreach for PISCO + COMARE leads
- No good lightweight CRM that isn't overkill
- Solves immediate pain: "who did I last email, when, and what's hot"
- Single HTML = easy deploy, no backend needed

## Success metric
Jordan can open it, add a lead, and see it in pipeline in under 2 min.