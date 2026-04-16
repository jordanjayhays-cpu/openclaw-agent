#!/bin/bash
# inbox_declutter.sh — Scan newsletters, extract key info, digest for Jordan
# Usage: ./inbox_declutter.sh
# Requires: Gmail API setup or IMAP credentials

OUTPUT_FILE="/data/workspace/PROJECTS/inbox-digest.md"
DATE=$(date '+%Y-%m-%d')

# For Gmail API — set GMAIL_TOKEN in env or use gcloud ADC
# For IMAP fallback — set IMAP_HOST, IMAP_USER, IMAP_PASS

digest_newsletter() {
    local subject="$1"
    local from="$2"
    local body="$3"
    
    # Extract 2 key points per newsletter using simple heuristics
    KEY_POINTS=$(echo "$body" | grep -E "^[*•]|[A-Z][a-z]+: " | head -3 | sed 's/^[*•]//' | tr '\n' '|' | sed 's/|/  • /g')
    
    if [[ -z "$KEY_POINTS" ]]; then
        KEY_POINTS="• $(echo "$body" | head -c 200 | fold -w 60 | head -1)..."
    fi
    
    echo "- **$subject** (from: $from)"
    echo "  $KEY_POINTS"
}

# Check for Gmail API
if command -v curl &>/dev/null && [[ -n "$GMAIL_TOKEN" ]]; then
    # Use Gmail API to fetch newsletters
    NEWSLETTERS=$(curl -s "https://gmail.googleapis.com/gmail/v1/users/me/messages?q=is:unread category:promotions -category:social" \
        -H "Authorization: Bearer $GMAIL_TOKEN" 2>/dev/null | grep -o '"id":"[^"]*"' | head -10)
    
    echo "# Inbox Digest — $DATE" > "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Scanned: $(echo "$NEWSLETTERS" | wc -l) promotional emails" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    for msg_id in $NEWSLETTERS; do
        MSG_ID=$(echo "$msg_id" | cut -d'"' -f4)
        MSG=$(curl -s "https://gmail.googleapis.com/gmail/v1/users/me/messages/$MSG_ID" \
            -H "Authorization: Bearer $GMAIL_TOKEN")
        SUBJECT=$(echo "$MSG" | grep -o '"subject":"[^"]*"' | head -1 | cut -d'"' -f4)
        FROM=$(echo "$MSG" | grep -o '"from":"[^"]*"' | head -1 | cut -d'"' -f4)
        SNIPPET=$(echo "$MSG" | grep -o '"snippet":"[^"]*"' | cut -d'"' -f4)
        
        digest_newsletter "$SUBJECT" "$FROM" "$SNIPPET" >> "$OUTPUT_FILE"
        
        # Mark as read + archive (remove from INBOX)
        curl -s -X POST "https://gmail.googleapis.com/gmail/v1/users/me/messages/$MSG_ID/modify" \
            -H "Authorization: Bearer $GMAIL_TOKEN" \
            -d '{"removeLabelIds": ["INBOX"], "addLabelIds": ["TRASH"]}' > /dev/null
    done
    
elif command -v curl &>/dev/null && [[ -n "$IMAP_HOST" ]]; then
    # IMAP fallback
    echo "# Inbox Digest — $DATE" > "$OUTPUT_FILE"
    echo "(IMAP mode not fully implemented — requires openssl + imap)" >> "$OUTPUT_FILE"
else
    echo "# Inbox Digest — $DATE" > "$OUTPUT_FILE"
    echo "⚠️ No email access configured. Set GMAIL_TOKEN or IMAP_* vars." >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "## Newsletter Digest" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "*Configure Gmail API or IMAP to enable inbox decluttering.*" >> "$OUTPUT_FILE"
fi

echo "📧 Digest saved to $OUTPUT_FILE"
cat "$OUTPUT_FILE"
