#!/bin/bash
# Log Interaction — Record a contact interaction
# Usage: bash tools/crm_log.sh "Javier Estrada" "linkedin" "Sent intro message"

cd /data/workspace

NAME="$1"
TYPE="$2"
SUMMARY="$3"

if [ -z "$NAME" ] || [ -z "$TYPE" ] || [z "$SUMMARY" ]; then
    echo "Usage: bash tools/crm_log.sh 'Name' 'type' 'summary'"
    echo "Type: email, linkedin, call, meeting, message"
    exit 1
fi

python3 << EOF
import sqlite3
from datetime import datetime

db = sqlite3.connect('/data/workspace/crm.db')

# Find contact
contact = db.execute("SELECT id, name FROM contacts WHERE name LIKE ?", (f'%{NAME}%',)).fetchone()

if not contact:
    print(f"Contact not found: {NAME}")
    exit(1)

contact_id, name = contact
today = datetime.now().strftime('%Y-%m-%d')

# Log interaction
db.execute("INSERT INTO interactions (contact_id, type, date, summary) VALUES (?, ?, ?, ?)",
    (contact_id, TYPE, today, SUMMARY))

# Update last_contact and interaction_count
db.execute("UPDATE contacts SET last_contact=?, interaction_count=interaction_count+1 WHERE id=?",
    (today, contact_id))

db.commit()
print(f"✅ Logged: {TYPE} with {name} — {SUMMARY}")

# Show updated contact
row = db.execute("SELECT name, last_contact, interaction_count FROM contacts WHERE id=?", (contact_id,)).fetchone()
print(f"   Last contact: {row[1]} | Total interactions: {row[2]}")

db.close()
EOF
