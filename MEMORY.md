# MEMORY.md — Jordan's Projects & Context

## Jordan Hays — Core Info
- **Phone**: +34 646 312 707
- **WhatsApp**: restoring after restore from cloud tonight
- **Timezone**: Madrid (UTC+2)
- **Language**: English (but targeting Spanish market for Massage Pass)

## Active Projects

### 1. Massage Pass / Hilom
**What it is**: SaaS platform — studios pay €69-99/month for a WhatsApp AI agent that handles bookings 24/7. Customer-facing app where customers discover studios and book via WhatsApp.

**Brand name**: Massage Pass (preferred) — hilom.io also considered
**Domain**: massagepass.co OR massageclub.io (both available, hilom.io available too)

**Supabase**: https://jglftdstrowwckwqmpue.supabase.co
- partners table: id, studio_name, phone, email, address, city, status, notes, created_at
- leads table: id, name, email, company, service_type, message, source, status, created_at
- bookings table: id, studio_id, customer_name, customer_phone, service, date, status, created_at

**Key pages** (live on GitHub Pages):
- Studio signup form: https://jordanjayhays-cpu.github.io/openclaw-agent/vercel-massage-pass/
- Jordan's studio dashboard: https://jordanjayhays-cpu.github.io/openclaw-agent/MASSAGE-PASS/dashboard-jordan.html
- Customer landing: https://jordanjayhays-cpu.github.io/openclaw-agent/MASSAGE-PASS/landing-customer.html
- Shop signup: https://jordanjayhays-cpu.github.io/openclaw-agent/MASSAGE-PASS/shop.html
- Dashboard Universe: https://jordanjayhays-cpu.github.io/openclaw-agent/DASHBOARD-UNIVERSE.html

**n8n webhook**: https://neuromatch.app.n8n.cloud/webhook/massage-pass-new-partner (active)
**n8n workflow ID**: dMjvYUbrVIpdzSJy

**Status**: Form → webhook → Jordan Telegram alert works. Supabase save partially broken (n8n not inserting to Supabase — needs Supabase Insert node in n8n). WhatsApp AI not yet connected.

**Demo studio**: Yi Long Studios | +34635569364 | status: pending

### 2. ProfileStack
**What it is**: Rent LinkedIn profiles to businesses for HeyReach outreach. Profile owners earn €75-150/month passive. Jordan takes cut.

**Landing page**: https://jordanjayhays-cpu.github.io/openclaw-agent/ProfileStack/ (just rebuilt tonight — form saves to Supabase leads table)

**Domain needed**: hilom.io or massageclub.io or similar — NOT massagepass.com (owned by adult content company)

**Lead form**: Working — POSTs to Supabase leads table with anon key. Fields: name, email, company, service_type, message, source, status.

### 3. PISCO
**What it is**: BD service placing Filipino staff in European hotels. Outreach to NH Hotels, Iberostar, Room Mate.

**Contacts**:
- Javier Estrada — jestrada@nh-hotels.com — NH Hotel Group
- Luis Zamora — luis.zamora@iberostar.com — Iberostar
- Yolanda de la Plaza — ydelaplaza@roommate.es — Room Mate

**Files**:
- /home/openclaw/.openclaw/workspace/PISCO/outreach-cron.js — ready to run
- /home/openclaw/.openclaw/workspace/PISCO/partners_outreach.json — contact tracker
- /home/openclaw/.openclaw/workspace/PISCO/README.md — email templates

**Status**: Cron built, Mailgun not configured. Needs Mailgun API key + domain in .env to fire.

## Jordan's Goals
1. Get 3 Madrid studios to say yes to Massage Pass → platform is live
2. Close NH Hotels, Iberostar, Room Mate for PISCO
3. First ProfileStack client at €199/month
4. Build the WhatsApp AI agent for Massage Pass (needs Twilio + WhatsApp sandbox)
5. Eventually build customer-facing massage booking app

## Key Decisions Made
- Brand name: Massage Pass (not Hilom yet — decided tonight)
- hilom.com is taken (adult content company), hilom.io IS available
- massagepass.com is taken (Men's Fantasies Inc — adult content), massagepass.co is available
- massageclub.io, kneadclub.io, velora.io, hilom.io — all available
- WhatsApp AI: Twilio sandbox approach chosen but blocked on Jordan restoring WhatsApp
- Supabase = database, Notion = Jordan's personal notes, n8n = automation layer
- Sell SaaS first, customer app second

## Jordan's Preferences
- Hates repeating himself — builds first, ask later
- Don't push third-party app changes without full research first
- Prefers user-friendly editing (Lovable for UI, Axton for backend)
- No cold-calling until verified on Google Maps
- No spending on infrastructure until earning

## Tonight's Mistakes (to not repeat)
- Pushed WhatsApp Business without understanding session limits → Jordan logged out of WhatsApp Web
- Lost WhatsApp restore from iCloud — set back Jordan's setup
- Built ProfileStack with wrong concept twice
- Broken dashboards — many HTML files on GitHub are old/don't work

## API Keys in .env
- SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY, SUPABASE_PUBLISHABLE_KEY, SUPABASE_PASSWORD
- TWILIO_API_KEY, TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN
- MAILGUN_API_KEY, MAILGUN_DOMAIN (MISSING — needed for PISCO)
- N8N_API_KEY (active)
- OPENROUTER_API_KEY

## Installed Skills
- playwright-scraper-skill ✅
- playwright-mcp ✅
- apify-openclaw-plugin ⚠️ (SDK version mismatch — broken)
- synxton (on-demand only — runs when Jordan says "check n8n")
- haxton (never fully built)

## Self-Watcher
- Running at: /home/openclaw/.openclaw/workspace/self-watcher/watcher.js
- Loop PID: 2696458
- Runs every 15 minutes via background loop
- Tasks: PISCO outreach, Supabase partner check, Massage Pass signup check

## Command Center
- https://jordanjayhays-cpu.github.io/openclaw-agent/command-center.html (just built tonight)
- Unified hub for all dashboards
- Many old dashboard links are broken — only links confirmed working are listed above

## What's Broken Right Now
- WhatsApp AI agent (Twilio sandbox not activated — Jordan needs to restore WhatsApp first)
- n8n Supabase insert (workflow fires but doesn't save to partners table)
- PISCO email cron (Mailgun keys missing)
- Apify plugin (SDK version mismatch)
- Most old HTML files in GitHub repos are non-functional or outdated

## What Works Right Now
- Studio signup form → n8n webhook → Jordan gets Telegram ✅
- ProfileStack lead form → Supabase ✅
- Jordan's studio dashboard loads from Supabase ✅
- Self-watcher background loop running ✅
- PISCO outreach cron script (ready, needs Mailgun) ✅
- Command Center dashboard (just built) ✅
