#!/bin/bash
# phone_assistant.sh — Axton Phone Assistant
# Usage: ./phone_assistant.sh "HOT lead responded" "Sarah from TechCorp replied to your email"
# Requires: TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER, JORDAN_PHONE in env

set -e

ALERT_TYPE="$1"
DETAILS="$2"

# Config
TWILIO_ACCOUNT_SID="${TWILIO_ACCOUNT_SID}"
TWILIO_AUTH_TOKEN="${TWILIO_AUTH_TOKEN}"
TWILIO_PHONE_NUMBER="${TWILIO_PHONE_NUMBER}"
JORDAN_PHONE="${JORDAN_PHONE}"

if [[ -z "$TWILIO_ACCOUNT_SID" || -z "$TWILIO_AUTH_TOKEN" ]]; then
    echo "⚠️  Twilio credentials not configured. Set TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER, JORDAN_PHONE"
    exit 1
fi

# Build message
MESSAGE="This is Axton. You have $ALERT_TYPE urgent. $DETAILS. Reply yes or no."

# Make the call via Twilio
RESPONSE=$(curl -s -X POST "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/Calls.json" \
    --data-urlencode "To=$JORDAN_PHONE" \
    --data-urlencode "From=$TWILIO_PHONE_NUMBER" \
    --data-urlencode "Twiml=<Response><Say voice='alice'>$MESSAGE</Say><Gather numDigits='1' method='POST'><Say voice='alice'>Press 1 for yes, 2 for no.</Say></Gather></Response>" \
    -u "$TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN")

SID=$(echo "$RESPONSE" | grep -o '"sid":"[^"]*"' | head -1 | cut -d'"' -f4)

if [[ -n "$SID" ]]; then
    echo "📞 Call initiated: $SID"
    echo "   Message: $MESSAGE"
    # Log
    echo "[$(date)] CALLED Jordan | $ALERT_TYPE | $DETAILS | SID: $SID" >> /data/workspace/memory/phone-calls.md
else
    echo "❌ Call failed: $RESPONSE"
fi
