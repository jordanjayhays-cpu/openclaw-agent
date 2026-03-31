#!/bin/bash
# PISCO Follow-Up Automation
# Runs every 6 hours — checks for follow-ups due and queues them

cd /data/workspace

CRM_FILE="PROJECTS/PISCO/pisco-crm.json"
EMAIL_FILE="PROJECTS/PISCO/email-sequence.json"

# Check for prospects needing follow-up
# Logic: email_sent=true, responded=false, follow_ups_sent < 3

NEEDS_FOLLOWUP=$(jq '[.prospects[] | select(.email_sent == true and .responded == false and .follow_ups_sent < 3)]' $CRM_FILE 2>/dev/null)

if [ -z "$NEEDS_FOLLOWUP" ] || [ "$NEEDS_FOLLOWUP" = "[]" ]; then
    echo "No follow-ups due right now."
    exit 0
fi

# For each prospect needing follow-up, log what needs to happen
echo "Follow-ups needed:"
echo "$NEEDS_FOLLOWUP" | jq -r '.[] | "→ \(.name) (\(.company)) - \(.follow_ups_sent) follow-ups sent - Next: \(.next_action)"'

# This script logs what needs to happen
# The actual sending happens when Jordan approves

# Update CRM with follow-up status
# Mark the follow-up as queued
for id in $(echo "$NEEDS_FOLLOWUP" | jq -r '.[].id'); do
    echo "Follow-up queued for prospect ID: $id"
done

echo "Follow-up check complete at $(date)" >> /data/workspace/logs/followups.log
