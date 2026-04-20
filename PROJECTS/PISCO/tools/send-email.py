#!/usr/bin/env python3
"""
PISCO — Send Email Tool
Jordan sends approval requests via Telegram

Usage:
    python3 send-email.py "Name" "email@example.com" "Subject" "Body text"
    
Or run interactively:
    python3 send-email.py
"""

import json
import sys
import os

BOT_TOKEN = "8768116245:AAG1kj2x8kQU25U2wXehMxzTpWPls-sXlzA"
CHAT_ID = "6463127078"
TELEGRAM_API = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"

def send_to_telegram(message):
    """Send message to Jordan via Telegram"""
    import urllib.request
    import urllib.parse
    
    data = json.dumps({
        "chat_id": CHAT_ID,
        "text": message,
        "parse_mode": "Markdown"
    }).encode('utf-8')
    
    req = urllib.request.Request(
        TELEGRAM_API,
        data=data,
        headers={"Content-Type": "application/json"}
    )
    
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read())

def build_email_message(recipient, email, subject, body):
    """Build the Telegram message for Jordan's approval"""
    return f"""📧 *PISCO EMAIL — READY TO SEND*

**To:** {recipient}
**Email:** {email}
**Subject:** {subject}

---

{body}

---

Reply *APPROVE* to send this email."""

def main():
    if len(sys.argv) < 5:
        # Interactive mode
        print("PISCO Email Tool — Jordan's Email Sender")
        print("=" * 40)
        recipient = input("Recipient name: ")
        email = input("Email address: ")
        subject = input("Subject: ")
        print("\nEmail body (type your message, end with empty line or Ctrl+D):")
        lines = []
        try:
            while True:
                line = input()
                lines.append(line)
        except EOFError:
            pass
        body = "\n".join(lines)
    else:
        recipient, email, subject, body = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
    
    if not recipient or not email:
        print("Error: recipient and email required")
        sys.exit(1)
    
    message = build_email_message(recipient, email, subject, body)
    
    print("\nSending to Telegram for Jordan's approval...")
    try:
        result = send_to_telegram(message)
        if result.get("ok"):
            print("✅ Email sent to Telegram! Jordan will approve to send.")
        else:
            print(f"❌ Error: {result}")
    except Exception as e:
        print(f"❌ Failed to send: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()