#!/bin/bash
# Morning Briefing — Good morning Jordan
# Runs at 9 AM CET via cron
# Usage: bash tools/morning_briefing.sh

cd /data/workspace

echo "=== JORDAN. Good morning. ==="
echo "Date: $(date '+%A, %B %d, %Y')"
echo ""

# Weather (Madrid)
echo "WEATHER (Madrid):"
# curl wttr.in/Madrid?format=3 2>/dev/null || echo "Unable to fetch"
echo "[Fetch weather]"
echo ""

# Today's priorities from AUTONOMOUS.md
echo "TODAY'S PRIORITIES:"
grep -A 10 "This Week" AUTONOMOUS.md | head -12
echo ""

# Tasks completed yesterday
echo "COMPLETED SINCE LAST BRIEFING:"
grep -A 20 "2026-03-31" memory/tasks-log.md | head -15
echo ""

# What I'm working on
echo "IN PROGRESS:"
echo "- PISCO outreach: Finding emails for Concha Pardo, Gabriel Cánaves"
echo "- COMARE: ICP decision pending (pharmacy vs restaurant)"
echo "- Self-improvement: Running daily checks"
echo ""

# Blockers (what needs Jordan)
echo "NEEDS YOU:"
echo "- COMARE ICP decision: Pick pharmacy OR restaurant"
echo "- Approve outreach emails: Ready to send when you say go"
echo "- GitHub push auth: Add token so I can auto-push"
echo ""

# Quick stats
echo "STATS:"
echo "- PISCO contacts: 6 HR decision makers identified"
echo "- Git commits pending push: $(git log --oneline origin/main..HEAD 2>/dev/null | wc -l || echo '0')"
echo ""

echo "=== That's the briefing. Let's go. ==="
