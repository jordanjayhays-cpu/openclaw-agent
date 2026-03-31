#!/bin/bash
# CRM Query — Natural language contact queries
# Usage: bash tools/crm_query.sh "who needs follow up"

cd /data/workspace

QUERY="$1"

if [ -z "$QUERY" ]; then
    echo "Usage: bash tools/crm_query.sh <question>"
    echo "Examples:"
    echo "  bash tools/crm_query.sh 'hot contacts'"
    echo "  bash tools/crm_query.sh 'who needs follow up'"
    echo "  bash tools/crm_query.sh 'all contacts'"
    exit 1
fi

python3 << 'EOF'
import sqlite3
import sys

db = sqlite3.connect('/data/workspace/crm.db')
query = sys.argv[1] if len(sys.argv) > 1 else ""

if "hot" in query.lower() or "follow up" in query.lower() or "needs" in query.lower():
    print("🔥 HOT LEADS — Follow up needed:")
    print("-" * 40)
    cur = db.execute("SELECT name, company, linkedin, last_contact, notes FROM contacts WHERE warmth='hot' OR warmth='warm'")
    for row in cur:
        print(f"\n{row[0]} — {row[1]}")
        print(f"  LinkedIn: {row[2]}")
        print(f"  Last contact: {row[3] or 'Never'}")
        print(f"  Notes: {row[4]}")

elif "all" in query.lower() or "list" in query.lower():
    print("📋 ALL CONTACTS:")
    print("-" * 40)
    cur = db.execute("SELECT name, company, warmth, last_contact FROM contacts ORDER BY CASE warmth WHEN 'hot' THEN 1 WHEN 'warm' THEN 2 WHEN 'cold' THEN 3 END")
    for row in cur:
        warmth_emoji = "🔥" if row[2] == "hot" else "❄️" if row[2] == "cold" else "🌡️"
        print(f"{warmth_emoji} {row[0]} — {row[1]} ({row[2]})")

elif "javier" in query.lower():
    print("👤 JAVIER ESTRADA")
    print("-" * 40)
    row = db.execute("SELECT * FROM contacts WHERE name LIKE '%Javier%'").fetchone()
    if row:
        print(f"Company: {row[2]}")
        print(f"LinkedIn: {row[3]}")
        print(f"Email: {row[4]}")
        print(f"Warmth: {row[5]} 🔥")
        print(f"First contact: {row[6]}")
        print(f"Last contact: {row[7]}")
        print(f"Interactions: {row[8]}")
        print(f"Notes: {row[9]}")

else:
    print("Query not recognized. Try: 'hot contacts', 'all contacts', or a name.")

db.close()
EOF
