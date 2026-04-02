#!/bin/bash
# CRM Query — Natural language queries against SQLite CRM
# Usage: bash tools/crm.sh "question"

cd /data/workspace

QUERY="$1"

python3 << 'EOF'
import sqlite3
import sys
from datetime import datetime, timedelta

db = sqlite3.connect('/data/workspace/crm.db')
query = sys.argv[1] if len(sys.argv) > 1 else ""

def format_contact(row, show_all=False):
    warmth_emoji = {"hot": "🔥", "warm": "🌡️", "cold": "❄️"}.get(row[7], "⚪")
    print(f"\n{warmth_emoji} {row[1]} — {row[2]}")
    if show_all or "detail" in query.lower():
        print(f"   Email: {row[4] or 'N/A'}")
        print(f"   LinkedIn: {row[3] or 'N/A'}")
        print(f"   Phone: {row[5] or 'N/A'}")
        print(f"   Project: {row[6]}")
        print(f"   Warmth: {row[7]}")
        print(f"   First contact: {row[8]}")
        print(f"   Last contact: {row[9] or 'Never'}")
        print(f"   Interactions: {row[10]}")
        print(f"   Notes: {row[11]}")

if not query:
    print("Usage: bash tools/crm.sh <question>")
    print("\nExamples:")
    print("  bash tools/crm.sh 'hot contacts'")
    print("  bash tools/crm.sh 'pisco contacts'")
    print("  bash tools/crm.sh 'needs follow up'")
    print("  bash tools/crm.sh 'all projects'")
    print("  bash tools/crm.sh 'javier detail'")
    print("  bash tools/crm.sh 'add: John Smith, Acme Corp, john@acme.com, hot'")
    exit(0)

# Parse commands
if query.lower().startswith("add:"):
    parts = query[4:].split(",")
    if len(parts) >= 4:
        name, company, email, warmth = [p.strip() for p in parts[:4]]
        today = datetime.now().strftime('%Y-%m-%d')
        db.execute("INSERT INTO contacts (name, company, email, warmth, first_contact, last_contact, project) VALUES (?, ?, ?, ?, ?, ?, ?)",
            (name, company, email, warmth, today, today, "general"))
        db.commit()
        print(f"✅ Added: {name} ({company}) — {warmth}")
    else:
        print("Usage: add: Name, Company, Email, Warmth")
        
elif "hot" in query.lower() and "contact" in query.lower():
    print("🔥 HOT CONTACTS:")
    print("-" * 40)
    rows = db.execute("SELECT * FROM contacts WHERE warmth='hot' ORDER BY last_contact DESC").fetchall()
    if not rows:
        print("  No hot contacts yet")
    for row in rows:
        format_contact(row)

elif "warm" in query.lower() and "contact" in query.lower():
    print("🌡️ WARM CONTACTS:")
    print("-" * 40)
    rows = db.execute("SELECT * FROM contacts WHERE warmth='warm' ORDER BY last_contact DESC").fetchall()
    if not rows:
        print("  No warm contacts yet")
    for row in rows:
        format_contact(row)
        
elif "needs follow" in query.lower():
    print("⏰ CONTACTS NEEDING FOLLOW-UP:")
    print("-" * 40)
    week_ago = (datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d')
    rows = db.execute("SELECT * FROM contacts WHERE warmth IN ('hot','warm') AND (last_contact < ? OR last_contact IS NULL) ORDER BY warmth DESC", (week_ago,)).fetchall()
    if not rows:
        print("  All contacts recently touched")
    for row in rows:
        format_contact(row)

elif "pisco" in query.lower():
    print("🅿️ PISCO CONTACTS:")
    print("-" * 40)
    rows = db.execute("SELECT * FROM contacts WHERE project='PISCO' ORDER BY warmth DESC").fetchall()
    for row in rows:
        format_contact(row)

elif "comare" in query.lower():
    print("🔧 COMARE CONTACTS:")
    print("-" * 40)
    rows = db.execute("SELECT * FROM contacts WHERE project='COMARE' ORDER BY warmth DESC").fetchall()
    for row in rows:
        format_contact(row)

elif "massage" in query.lower():
    print("💆 MASSAGE PASS:")
    print("-" * 40)
    rows = db.execute("SELECT * FROM contacts WHERE project='MASSAGE-PASS' ORDER BY warmth DESC").fetchall()
    for row in rows:
        format_contact(row)

elif "all" in query.lower() and "contact" in query.lower():
    print("📋 ALL CONTACTS:")
    print("-" * 40)
    rows = db.execute("SELECT * FROM contacts ORDER BY CASE warmth WHEN 'hot' THEN 1 WHEN 'warm' THEN 2 WHEN 'cold' THEN 3 END, name").fetchall()
    for row in rows:
        format_contact(row)

elif "project" in query.lower():
    print("🚀 PROJECTS:")
    print("-" * 40)
    rows = db.execute("SELECT name, status, goal, updated FROM projects ORDER BY CASE status WHEN 'active' THEN 1 WHEN 'planning' THEN 2 WHEN 'blocked' THEN 3 END").fetchall()
    for row in rows:
        status_icon = {"active": "🟢", "planning": "🟡", "blocked": "🔴", "done": "✅"}.get(row[1], "⚪")
        print(f"{status_icon} {row[0]}: {row[1]}")
        print(f"   Goal: {row[2]}")
        print(f"   Updated: {row[3]}")
        print()

elif "stat" in query.lower() or "summary" in query.lower():
    print("📊 CRM SUMMARY:")
    print("-" * 40)
    total = db.execute("SELECT COUNT(*) FROM contacts").fetchone()[0]
    hot = db.execute("SELECT COUNT(*) FROM contacts WHERE warmth='hot'").fetchone()[0]
    warm = db.execute("SELECT COUNT(*) FROM contacts WHERE warmth='warm'").fetchone()[0]
    cold = db.execute("SELECT COUNT(*) FROM contacts WHERE warmth='cold'").fetchone()[0]
    projects = db.execute("SELECT COUNT(*) FROM projects").fetchone()[0]
    print(f"  Total contacts: {total}")
    print(f"  🔥 Hot: {hot}")
    print(f"  🌡️ Warm: {warm}")
    print(f"  ❄️ Cold: {cold}")
    print(f"  Projects: {projects}")

else:
    # Try to find by name
    rows = db.execute("SELECT * FROM contacts WHERE name LIKE ?", (f'%{query}%',)).fetchall()
    if rows:
        print(f"🔍 Results for '{query}':")
        for row in rows:
            format_contact(row, show_all=True)
    else:
        print(f"Couldn't understand: '{query}'")
        print("Try: hot contacts, pisco, all contacts, needs follow up, add: Name, Company, Email, Warmth")

db.close()
EOF
