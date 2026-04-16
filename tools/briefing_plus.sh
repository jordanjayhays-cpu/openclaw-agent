#!/bin/bash
# briefing_plus.sh — Morning briefing with full ready-to-use content
# Usage: ./briefing_plus.sh
# Best run: 8:00 AM daily via cron

set -e
DATE=$(date '+%Y-%m-%d')
DAY=$(date '+%A')
TIMEZONE="Europe/Madrid"

echo "🌅 Building your morning briefing..."

# ============================================
# 1. WEATHER
# ============================================
WEATHER=$(curl -s "https://wttr.in/Madrid?format=j1" 2>/dev/null || echo '{"error":"unavailable"}')
if echo "$WEATHER" | grep -q "error"; then
    WEATHER_TEXT="Weather API unavailable"
else
    TEMP=$(echo "$WEATHER" | grep -o '"temp_C":"[^"]*"' | head -1 | cut -d'"' -f4)
    DESC=$(echo "$WEATHER" | grep -o '"weatherDesc":"[^"]*"' | head -1 | cut -d'"' -f4)
    WEATHER_TEXT="$TEMP°C, $DESC"
fi

# ============================================
# 2. CALENDAR (Google Calendar API)
# ============================================
if [[ -n "$GOOGLE_CALENDAR_TOKEN" ]]; then
    EVENTS=$(curl -s "https://www.googleapis.com/calendar/v3/calendars/primary/events?timeMin=$(date -u +%Y-%m-%dT00:00:00Z)&timeMax=$(date -u +%Y-%m-%dT23:59:59Z)&maxResults=10" \
        -H "Authorization: Bearer $GOOGLE_CALENDAR_TOKEN" 2>/dev/null)
    CALENDAR_TEXT=$(echo "$EVENTS" | grep -o '"summary":"[^"]*"' | cut -d'"' -f4 | head -5 | tr '\n' ', ' || echo "No events")
else
    CALENDAR_TEXT="📅 Set GOOGLE_CALENDAR_TOKEN to enable calendar"
fi

# ============================================
# 3. TOP PRIORITIES (from AUTONOMOUS.md)
# ============================================
if [[ -f /data/workspace/AUTONOMOUS.md ]]; then
    PRIORITIES=$(head -20 /data/workspace/AUTONOUS.md | grep -E "^[*•-] " | head -3 | sed 's/^[*•-] //')
else
    PRIORITIES="No AUTONOMOUS.md found"
fi

# ============================================
# 4. OVERNIGHT EXPERIMENTS
# ============================================
OVERNIGHT_DIR="/data/workspace/PROJECTS/overnight-builds"
if [[ -d "$OVERNIGHT_DIR" ]]; then
    LAST_BUILD=$(ls -t "$OVERNIGHT_DIR" 2>/dev/null | head -1)
    if [[ -n "$LAST_BUILD" ]]; then
        EXPERIMENT_RESULT="Built: $LAST_BUILD"
    else
        EXPERIMENT_RESULT="No overnight builds yet"
    fi
else
    EXPERIMENT_RESULT="Overnight builds directory not set up"
fi

# ============================================
# 5. RECENT LEADS/DEALS (from contacts)
# ============================================
CONTEXT_FILE="/data/workspace/contacts/CONTEXT.md"
if [[ -f "$CONTEXT_FILE" ]]; then
    RECENT_LEADS=$(grep -A2 "HOT\|warm\|urgent" "$CONTEXT_FILE" 2>/dev/null | head -10 || echo "No hot leads")
else
    RECENT_LEADS="No contacts file found"
fi

# ============================================
# BUILD FULL BRIEFING
# ============================================
OUTPUT="/data/workspace/PROJECTS/briefing-$DATE.md"

cat << EOF > "$OUTPUT"
# 🌅 Good morning, Jordan — $DAY, $DATE

---

## 📍 Weather — Madrid ($TIMEZONE)
$WEATHER_TEXT

## 📅 Today's Calendar
$CALENDAR_TEXT

## 🎯 Top 3 Priorities Today
$PRIORITIES

## 🧪 Overnight Experiment
$EXPERIMENT_RESULT

## 🔥 Hot Leads
$RECENT_LEADS

---

## 🐦 TWEETS — Ready to post (just approve)

**Tweet 1 — Motivation:**
\`\`\`
The gap between where you are and where you want to be 
is filled with decisions you keep postponing.

Start today. Not Monday. Not next month. Today.
\`\`\`

**Tweet 2 — Value:**
\`\`\`
Hot take: Most "productivity" advice makes you MORE busy 
and LESS effective.

The 20% of actions that actually move the needle:
→ Deep work before meetings
→ Saying no to almost everything
→ One metric per week

What's your highest-leverage habit?
\`\`\`

**Tweet 3 — Engagement:**
\`\`\`
Building in public is terrifying.

Every mistake is visible. Every failure is documented.

But here's what nobody tells you:
The people who win are the ones who stayed consistent 
when it felt like nobody was watching.

Keep going. Your future self will thank you.
\`\`\`

---

## 💼 LINKEDIN POST — Ready to post

\`\`\`
Last month I almost quit.

Not because the work was hard. 
Because I was doing the wrong work hard.

I was busy. Not productive. 
There's a massive difference.

Then I ran a 30-day experiment:

→ Tracked every hour for 2 weeks
→ Identified what actually moved the needle
→ Cut everything else ruthlessly

Results?

Productivity up 40%.
Time freedom up significantly.
Stress? Down.

The counterintuitive insight:

Productivity isn't about doing more.
It's about eliminating everything that doesn't matter.

What would you do with 2 extra hours every day 
if you knew exactly how to get them?

Drop your biggest time waster in the comments 👇
\`\`\`

---

## 📧 EMAIL — Ready to send

**To:** [RECIPIENT]
**Subject:** Quick question about [TOPIC]

\`\`\`
Hi [Name],

Hope you're having a great [day/week].

I wanted to reach out because [specific reason 
or compliment about their work].

[1-2 sentences on why you're connecting.]

Would you be open to a 15-min call this week? 
I have some ideas on [value you can provide] 
and I'd love to get your perspective.

No pressure if timing is off — just wanted to put 
the invite out there.

Best,
Jordan
\`\`\`

---

## 💡 Decision of the Day
*(Answer this before checking Slack/email)*

**What's the ONE thing that if you complete today, everything else becomes easier?**

---

*Briefing generated at $(date '+%H:%M') UTC*
*Questions? Ask Axton.*
EOF

echo "✅ Briefing complete: $OUTPUT"
echo ""
cat "$OUTPUT"
