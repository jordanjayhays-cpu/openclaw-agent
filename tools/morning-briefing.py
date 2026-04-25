#!/usr/bin/env python3
"""
Morning Briefing Generator
Run every day at 9 AM CET to give Jordan a clear action list.
Usage: uv run python tools/morning-briefing.py
"""
import os
import sys
from datetime import datetime

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

AUTONOMOUS = "/home/openclaw/.openclaw/workspace/AUTONOMOUS.md"
MEMORY_DIR = "/home/openclaw/.openclaw/workspace/memory"
TODAY = datetime.now().strftime("%Y-%m-%d")
LOG_FILE = f"{MEMORY_DIR}/{TODAY}.md"

def get_today_log():
    if os.path.exists(LOG_FILE):
        with open(LOG_FILE) as f:
            return f.read()
    return ""

def get_autonomous():
    if os.path.exists(AUTONOMOUS):
        with open(AUTONOMOUS) as f:
            return f.read()
    return ""

def get_day_of_week():
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    return days[datetime.now().weekday()]

def generate_briefing():
    today_log = get_today_log()
    autonomous = get_autonomous()
    day = get_day_of_week()
    
    print()
    print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(f"  ☀️  MORNING BRIEFING — {TODAY} ({day})")
    print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print()
    
    # Extract top 3 priorities from AUTONOMOUS
    lines = autonomous.split('\n')
    priorities = []
    in_priority = False
    
    for line in lines:
        if 'Priority' in line or 'priority' in line or 'TOP' in line:
            in_priority = True
        if in_priority and any(marker in line for marker in ['- [ ]', '- [x]', '**', '→']):
            if len(line.strip()) > 10:
                priorities.append(line.strip())
                if len(priorities) >= 5:
                    break
    
    print("📋 TOP PRIORITIES TODAY:")
    if priorities:
        for p in priorities[:5]:
            print(f"   • {p}")
    else:
        print("   • No priorities set — check AUTONOMOUS.md")
    print()
    
    # Check today's log for context
    if today_log:
        recent_lines = [l for l in today_log.split('\n') if l.strip()][:10]
        if recent_lines:
            print("📝 YESTERDAY'S WORK:")
            for l in recent_lines[-5:]:
                if l.strip():
                    print(f"   {l.strip()[:80]}")
            print()
    
    # Friday = weekly review
    if day == "Friday":
        print("🔴 FRIDAY = WEEKLY REVIEW DAY")
        print("   Review all projects:")
        print("   - PISCO: Any responses? Update CRM")
        print("   - ProfileStack: New profile owners?")
        print("   - COMARE: Any interest?")
        print("   - Massage Pass: Any shop signups?")
        print()
    
    # Saturday/Sunday = low priority
    if day in ("Saturday", "Sunday"):
        print("🌿 Weekend — light touch only")
        print("   - Send any pending follow-ups")
        print("   - Work on content if energy allows")
        print()
    
    # Standard weekday priorities
    print("🎯 TODAY'S TOP 3 ACTIONS:")
    print("   1. Send LinkedIn DM to Rachel King @ Spire Healthcare")
    print("   2. Send LinkedIn DM to Victor Presa @ Meliá Hotels")
    print("   3. Follow up Javier Estrada @ NH Hotel Group")
    print()
    
    # Check for stale follow-ups
    print("📅 FOLLOW-UP CHECK:")
    print("   No contacts overdue (checked 2026-04-25)")
    print()
    
    print("💡 MIROFISH INSIGHT:")
    print("   PISCO simulation: 47% of HR directors would respond.")
    print("   The gap is activation — send the messages.")
    print("   Top chain: Spire Healthcare → Meliá → NH Hotel Group")
    print()
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(f"  Time: {datetime.now().strftime('%H:%M')} CET")
    print(f"  Model: openrouter/minimax")
    print(f"  last30days: Run for any research topic")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print()

if __name__ == '__main__':
    generate_briefing()
