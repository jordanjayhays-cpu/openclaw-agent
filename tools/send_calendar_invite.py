#!/usr/bin/env python3
"""
Create a Google Calendar invite (.ics file) and send it via email.
"""

import datetime
import argparse

def create_ics(title, start_time, end_time, description, location, organizer_email, attendee_email, timezone="Europe/Dublin"):
    """Create an .ics calendar invite string."""
    
    # Format times in UTC for ICS
    start_str = start_time.strftime("%Y%m%dT%H%M%S")
    end_str = end_time.strftime("%Y%m%dT%H%M%S")
    created = datetime.datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    uid = f"{start_str}-{hash(title)}@openclaw"
    
    ics_content = f"""BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//OpenClaw//Calendar Invite//EN
METHOD:REQUEST
BEGIN:VEVENT
UID:{uid}
DTSTAMP:{created}
DTSTART:{start_str}
DTEND:{end_str}
SUMMARY:{title}
DESCRIPTION:{description}
LOCATION:{location}
ORGANIZER;CN=OpenClaw:mailto:{organizer_email}
ATTENDEE;CN=Test;ROLE=REQ-PARTICIPANT;RSVP=TRUE:mailto:{attendee_email}
STATUS:CONFIRMED
SEQUENCE:0
END:VEVENT
END:VCALENDAR"""
    
    return ics_content

def send_calendar_invite(title, description, start_time, end_time, location, organizer_email, attendee_email, timezone="Europe/Dublin"):
    import smtplib
    from email.mime.text import MIMEText
    from email.mime.multipart import MIMEMultipart
    from email.mime.base import MIMEBase
    from email import encoders
    
    ics_content = create_ics(title, start_time, end_time, description, location, organizer_email, attendee_email, timezone)
    
    msg = MIMEMultipart()
    msg["From"] = organizer_email
    msg["To"] = attendee_email
    msg["Subject"] = f"Meeting Invite: {title}"
    
    # Create the ics attachment
    part = MIMEBase('application', 'octet-stream')
    part.set_payload(ics_content)
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', f'attachment; filename="{title.replace(" ", "_")}.ics"')
    msg.attach(part)
    
    # Also add the invite in the email body
    body = f"""Hi,

You've been invited to a meeting:

Title: {title}
Time: {start_time.strftime('%A, %B %d, %Y at %H:%M')} {timezone}
Location: {location}

Description: {description}

Please click the attached .ics file to add this event to your calendar.

Best,
OpenClaw Agent
"""
    msg.attach(MIMEText(body, "plain"))
    
    # Send via SendGrid SMTP
    SMTP_HOST = "smtp.sendgrid.net"
    SMTP_PORT = 587
    SMTP_USER = "apikey"
    SMTP_PASSWORD = "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"
    
    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
        server.starttls()
        server.login(SMTP_USER, SMTP_PASSWORD)
        server.sendmail(organizer_email, attendee_email, msg.as_string())
    
    print(f"✅ Calendar invite sent to {attendee_email}")

if __name__ == "__main__":
    # Monday 6pm CET = Monday 17:00 CET
    # In March, CET = UTC+1 (winter time)
    # So 17:00 CET = 16:00 UTC
    monday = datetime.datetime(2026, 3, 30, 17, 0, 0)  # March 30, 2026 is Monday
    
    send_calendar_invite(
        title="test meeting",
        description="test meeting",
        start_time=monday,
        end_time=datetime.datetime(2026, 3, 30, 18, 0, 0),  # 1 hour meeting
        location="Google Meet",  # or wherever
        organizer_email="jordan.hays@student.ie.edu",
        attendee_email="jordanjayhays@gmail.com",
        timezone="CET"
    )
