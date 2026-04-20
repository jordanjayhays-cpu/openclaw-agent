#!/bin/bash
# PISCO — Send Email Tool
# Usage: ./send-pisco-email.sh "RECIPIENT_NAME" "EMAIL_ADDRESS" "SUBJECT" "EMAIL_BODY"
# 
# Jordan sends emails through his Telegram bot
# Bot token and chat ID are hardcoded here for simplicity

BOT_TOKEN="8768116245:AAG1kj2x8kQU25U2wXehMxzTpWPls-sXlzA"
CHAT_ID="6463127078"

RECIPIENT="$1"
EMAIL="$2"
SUBJECT="$3"
BODY="$4"

if [ -z "$RECIPIENT" ] || [ -z "$EMAIL" ] || [ -z "$SUBJECT" ] || [ -z "$BODY" ]; then
    echo "Usage: ./send-pisco-email.sh \"Name\" \"email@example.com\" \"Subject\" \"Body text\""
    exit 1
fi

MESSAGE="📧 *PISCO EMAIL — APPROVE TO SEND*

**To:** $RECIPIENT ($EMAIL)
**Subject:** $SUBJECT

---

$BODY

---

Reply *APPROVE* to send this email."

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\": ${CHAT_ID}, \"text\": \"${MESSAGE}\", \"parse_mode\": \"Markdown\"}"

echo ""
echo "✅ Message sent to Telegram. Jordan will approve to send."