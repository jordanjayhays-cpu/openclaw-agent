#!/usr/bin/env python3
"""
PK Track Organizer - Add tracks to catalog
Usage: python3 pk-add.py "Track Name" "Album" "Concept"
"""

import sys
import json
from datetime import datetime

CATALOG_FILE = "/data/workspace/PROJECTS/PK-MUSIC/catalog.json"

ALBUMS = [
    "Animal Within",
    "The Anthem of the Individual", 
    "The Anxious Generation",
    "Running to Stay Still",
    "NEW"  # Unassigned
]

def load_catalog():
    try:
        with open(CATALOG_FILE, 'r') as f:
            return json.load(f)
    except:
        return {"tracks": [], "last_updated": None}

def save_catalog(catalog):
    catalog["last_updated"] = datetime.now().isoformat()
    with open(CATALOG_FILE, 'w') as f:
        json.dump(catalog, f, indent=2)

def add_track(name, album, concept, references=""):
    catalog = load_catalog()
    
    track = {
        "name": name,
        "album": album if album in ALBUMS else "NEW",
        "concept": concept,
        "references": references,
        "added": datetime.now().isoformat(),
        "content_ready": False,
        "suno_brief": False
    }
    
    # Check if track already exists
    for i, t in enumerate(catalog["tracks"]):
        if t["name"].lower() == name.lower():
            catalog["tracks"][i] = track
            print(f"🔄 Updated: {name}")
            save_catalog(catalog)
            return
    
    catalog["tracks"].append(track)
    print(f"✅ Added: {name}")
    print(f"   Album: {album}")
    print(f"   Concept: {concept[:100]}...")
    save_catalog(catalog)

def list_tracks(album=None):
    catalog = load_catalog()
    
    if album:
        tracks = [t for t in catalog["tracks"] if t["album"] == album]
        print(f"\n📀 {album} ({len(tracks)} tracks)")
    else:
        tracks = catalog["tracks"]
        print(f"\n📚 All Tracks ({len(tracks)} total)")
    
    print("=" * 50)
    for t in tracks:
        print(f"  • {t['name']} ({t['album']})")

def main():
    if len(sys.argv) < 2:
        print("""
PK Track Organizer
==================
Usage:
    python3 pk-add.py list                    # List all tracks
    python3 pk-add.py list "Album Name"       # List tracks by album
    python3 pk-add.py "Track" "Album" "Concept"   # Add track
    python3 pk-add.py "Track"                 # Add to NEW
    
Examples:
    python3 pk-add.py "Breaking the Chains" "The Anthem of the Individual" "Liberation philosophy"
    python3 pk-add.py list
    python3 pk-add.py list "The Anxious Generation"
""")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == "list":
        album = sys.argv[2] if len(sys.argv) > 2 else None
        list_tracks(album)
    else:
        name = cmd
        album = sys.argv[2] if len(sys.argv) > 2 else "NEW"
        concept = sys.argv[3] if len(sys.argv) > 3 else ""
        add_track(name, album, concept)

if __name__ == "__main__":
    main()
