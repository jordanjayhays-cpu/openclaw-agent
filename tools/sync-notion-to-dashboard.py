#!/usr/bin/env python3
"""
Notion → Dashboard Sync
Pulls data from Notion → Updates dashboard JSON
Runs via cron: python3 /data/workspace/tools/sync-notion-to-dashboard.py
"""

import json
import sqlite3
import os
from datetime import datetime

# Paths
KB_GENERAL = "/data/workspace/knowledge-base"
KB_PK = "/data/workspace/PROJECTS/PK-MUSIC/knowledge-base"
DASHBOARD_JSON = "/data/workspace/PROJECTS/dashboard-data.json"
MASSSAGE_PASS_DB = "/data/workspace/PROJECTS/MASSAGE-PASS/data.json"

def get_kb_stats(kb_dir):
    db = f"{kb_dir}/kb.db"
    if not os.path.exists(db):
        return 0, 0
    conn = sqlite3.connect(db)
    c = conn.cursor()
    c.execute('SELECT COUNT(*), SUM(LENGTH(content)) FROM documents')
    count, chars = c.fetchone()
    conn.close()
    return count or 0, chars or 0

def get_massage_pass_data():
    if not os.path.exists(MASSSAGE_PASS_DB):
        return {"subscribers": 0, "shops": 0, "transactions": 0}
    with open(MASSSAGE_PASS_DB, 'r') as f:
        data = json.load(f)
    return {
        "subscribers": len(data.get("subscribers", [])),
        "shops": len(data.get("shops", [])),
        "transactions": len(data.get("transactions", []))
    }

def sync():
    print(f"🔄 Syncing at {datetime.now().isoformat()}")
    
    # Get KB stats
    general_count, _ = get_kb_stats(KB_GENERAL)
    pk_count, _ = get_kb_stats(KB_PK)
    mp_data = get_massage_pass_data()
    
    # Build dashboard data
    dashboard_data = {
        "last_synced": datetime.now().isoformat(),
        "knowledge_bases": {
            "general": {"docs": general_count},
            "pk_music": {"docs": pk_count}
        },
        "massage_pass": mp_data,
        "projects": {
            "pisco": {"status": "active"},
            "comare": {"status": "research"},
            "ego_death_pod": {"status": "ready"},
            "pk_music": {"status": "active"},
            "neurotech": {"status": "active"},
            "massage_pass": {"status": "concept"},
            "google_maps": {"status": "concept"},
            "new_bali": {"status": "concept"},
            "video_agency": {"status": "interest"},
            "cybersecurity": {"status": "interest"},
            "ai_content": {"status": "concept"}
        }
    }
    
    # Save
    with open(DASHBOARD_JSON, 'w') as f:
        json.dump(dashboard_data, f, indent=2)
    
    print(f"✅ Synced: General KB {general_count} docs, PK KB {pk_count} docs, Massage Pass {mp_data['subscribers']} subscribers")

if __name__ == "__main__":
    sync()
