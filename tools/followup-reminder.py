#!/usr/bin/env python3
"""
Follow-up Reminder Generator
Checks outreach status and generates overdue follow-up reminders.
Run: uv run python tools/followup-reminder.py
"""
import json
import os
from datetime import datetime, timedelta

TRACKER_FILE = "/home/openclaw/.openclaw/workspace/PISCO-TRACKER.html"
CONTACTS_FILE = "/home/openclaw/.openclaw/workspace/contacts/CONTEXT.md"
AUTONOMOUS_FILE = "/home/openclaw/.openclaw/workspace/AUTONOMOUS.md"
DAILY_LOG_FILE = "/home/openclaw/.openclaw/workspace/memory/%Y-%m-%d.md"

DAYS_UNTIL_FOLLOWUP = 5

def get_today():
    return datetime.now().strftime("%Y-%m-%d")

def parse_tracker():
    """Extract contacts from PISCO tracker HTML."""
    if not os.path.exists(TRACKER_FILE):
        return []
    
    with open(TRACKER_FILE) as f:
        content = f.read()
    
    # Very simple extraction — just find names and last contact dates
    contacts = []
    
    # Look for rows like: <td>Name</td><td>Last Contact</td><td>Status</td>
    import re
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', content, re.DOTALL)
    for row in rows:
        cells = re.findall(r'<td[^>]*>(.*?)</td>', row, re.DOTALL)
        if len(cells) >= 4:
            name = re.sub(r'<[^>]+>', '', cells[0]).strip()
            last_contact = re.sub(r'<[^>]+>', '', cells[1]).strip()
            status = re.sub(r'<[^>]+>', '', cells[2]).strip()
            if name and name not in ('Name', 'Contact', 'Prospect'):
                contacts.append({
                    'name': name,
                    'last_contact': last_contact,
                    'status': status
                })
    
    return contacts

def days_ago(date_str):
    """Return days since date_str (YYYY-MM-DD or similar)."""
    if not date_str or date_str in ('Never', '—', ''):
        return 999
    try:
        date_str = date_str.split()[0]  # take first part
        d = datetime.strptime(date_str, "%Y-%m-%d")
        return (datetime.now() - d).days
    except:
        return 0

def get_overdue_followups(contacts):
    """Find contacts needing follow-up."""
    overdue = []
    for c in contacts:
        days = days_ago(c['last_contact'])
        if 0 < days <= DAYS_UNTIL_FOLLOWUP:
            overdue.append({**c, 'days_ago': days})
    return sorted(overdue, key=lambda x: -x['days_ago'])

def generate_reminders():
    contacts = parse_tracker()
    overdue = get_overdue_followups(contacts)
    
    today = get_today()
    print(f"Follow-up Check — {today}")
    print("=" * 50)
    print()
    
    if not overdue:
        print("✅ No contacts overdue for follow-up")
        return []
    
    print(f"📋 {len(overdue)} contact(s) need follow-up:\n")
    reminders = []
    
    for c in overdue:
        status_emoji = "🔥" if c['days_ago'] >= 4 else "📅"
        print(f"{status_emoji} {c['name']}")
        print(f"   Last contact: {c['days_ago']} days ago ({c['last_contact']})")
        print(f"   Status: {c['status']}")
        
        # Generate the follow-up message
        msg = generate_followup_message(c)
        print(f"   Suggested follow-up:")
        print(f"   \"{msg}\"")
        print()
        reminders.append({'contact': c, 'message': msg})
    
    return reminders

def generate_followup_message(contact):
    """Generate a brief follow-up message based on status."""
    name = contact['name']
    status = contact['status'].lower()
    
    if 'warm' in status or 'contacted' in status:
        return f"Hi {name.split()[0]}, wanted to follow up on my earlier message about the Filipino staffing pilot. Happy to hop on a quick call this week?"
    elif 'pilot' in status or 'interested' in status:
        return f"Hi {name.split()[0]}, just circling back on the pilot program we discussed. Shall I send over the specifics?"
    elif 'decision' in status or 'proposal' in status:
        return f"Hi {name.split()[0]}, checking in on the proposal. Happy to answer any questions."
    else:
        return f"Hi {name.split()[0]}, following up on my earlier message. Still happy to share more if useful."

def check_autonomous_staleness():
    """Check if AUTONOMOUS.md has stale tasks."""
    if not os.path.exists(AUTONOMOUS_FILE):
        return
    
    with open(AUTONOMOUS_FILE) as f:
        content = f.read()
    
    stale = []
    import re
    # Find tasks with [ ] that haven't been touched in a while
    lines = content.split('\n')
    for line in lines:
        if '[ ]' in line and len(line) < 200:
            # Rough check — if task mentions a date more than 7 days old
            date_match = re.findall(r'\d{4}-\d{2}-\d{2}', line)
            if date_match:
                try:
                    d = datetime.strptime(date_match[0], "%Y-%m-%d")
                    if (datetime.now() - d).days > 7:
                        stale.append(line.strip())
                except:
                    pass
    
    if stale:
        print(f"⚠️ {len(stale)} stale task(s) in AUTONOMOUS.md (>7 days old):")
        for s in stale[:5]:
            print(f"   - {s[:80]}")

def main():
    print()
    print("🔔 FOLLOW-UP REMINDER CHECK")
    print("=" * 50)
    
    reminders = generate_reminders()
    check_autonomous_staleness()
    
    print("=" * 50)
    print()
    
    if reminders:
        print(f"ACTION: Send {len(reminders)} follow-up message(s) this week.")
    
    return reminders

if __name__ == '__main__':
    main()
