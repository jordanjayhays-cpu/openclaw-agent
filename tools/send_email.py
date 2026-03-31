#!/usr/bin/env python3
"""
Send email via SendGrid SMTP relay.
Usage: python3 send_email.py --to recipient@example.com --subject "Subject" --body "Body"
"""

import smtplib
import argparse
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

SMTP_HOST = "smtp.sendgrid.net"
SMTP_PORT = 587
SMTP_USER = "apikey"
SMTP_PASSWORD = "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"
FROM_EMAIL = "jordan.hays@student.ie.edu"  # Update this to your verified sender

def send_email(to_email, subject, body):
    msg = MIMEMultipart()
    msg["From"] = FROM_EMAIL
    msg["To"] = to_email
    msg["Subject"] = subject
    msg.attach(MIMEText(body, "plain"))

    try:
        with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USER, SMTP_PASSWORD)
            server.sendmail(FROM_EMAIL, to_email, msg.as_string())
        print(f"✅ Email sent to {to_email}")
        return True
    except Exception as e:
        print(f"❌ Failed to send email: {e}")
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send email via SendGrid")
    parser.add_argument("--to", required=True, help="Recipient email address")
    parser.add_argument("--subject", required=True, help="Email subject")
    parser.add_argument("--body", required=True, help="Email body")
    args = parser.parse_args()
    send_email(args.to, args.subject, args.body)
