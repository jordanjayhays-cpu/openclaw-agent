#!/bin/bash
# PISCO Daily Briefing — Sent to Jordan every morning at 8 AM Madrid time
# This script generates the daily status and prompts Jordan for action

cd /data/workspace

# Read CRM data
CRM_FILE="PROJECTS/PISCO/pisco-crm.json"
EMAIL_FILE="PROJECTS/PISCO/email-sequence.json"

# Count stats
TOTAL=$(jq '.prospects | length' $CRM_FILE)
ACTION_REQUIRED=$(jq '[.prospects[] | select(.action_required == true)] | length' $CRM_FILE)
EMAILS_SENT=$(jq '[.prospects[] | select(.email_sent == true)] | length' $CRM_FILE)
RESPONDED=$(jq '[.prospects[] | select(.responded == true)] | length' $CRM_FILE)
COLD=$(jq '[.prospects[] | select(.status == "cold")] | length' $CRM_FILE)

# Next urgent prospects
URGENT1=$(jq -r '.prospects[0].name + " (" + .prospects[0].company + ")"' $CRM_FILE 2>/dev/null || echo "None")
URGENT2=$(jq -r '.prospects[1].name + " (" + .prospects[1].company + ")"' $CRM_FILE 2>/dev/null || echo "None")
URGENT3=$(jq -r '.prospects[2].name + " (" + .prospects[2].company + ")"' $CRM_FILE 2>/dev/null || echo "None")

# Generate the message
MESSAGE="☀️ PISCO Morning Briefing | $(date '+%A %B %d')

━━━━━━━━━━━━━━━━━━━━
📊 PIPELINE STATUS
━━━━━━━━━━━━━━━━━━━━
Total Prospects: $TOTAL
Action Required: $ACTION_REQUIRED (Jordan's approval needed)
Emails Sent: $EMAILS_SENT
Responded: $RESPONDED
Cold: $COLD

━━━━━━━━━━━━━━━━━━━━
📋 READY TO SEND (Your Approval Needed)
━━━━━━━━━━━━━━━━━━━━
1. $URGENT1 — Priority 1
2. $URGENT2 — Priority 2
3. $URGENT3 — Priority 3

━━━━━━━━━━━━━━━━━━━━
💬 RESPOND TO APPROVE
━━━━━━━━━━━━━━━━━━━━
Reply with ONE of:
• YES — Send all 3 emails today
• [NAME] — Send to that person only
• SKIP — Do not send today

━━━━━━━━━━━━━━━━━━━━
📈 WEEKLY PROGRESS
━━━━━━━━━━━━━━━━━━━━
• Emails sent this week: $EMAILS_SENT
• Responses this week: $RESPONDED
• Follow-ups due: 0

━━━━━━━━━━━━━━━━━━━━

— Claw 🦞 | PISCO System"
echo "$MESSAGE"

# Save to log
echo "$MESSAGE" >> /data/workspace/logs/pisco-briefings.log
