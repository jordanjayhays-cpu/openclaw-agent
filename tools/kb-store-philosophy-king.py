#!/usr/bin/env python3
"""Store Philosophy King Last.fm in knowledge base"""
import sys
sys.path.insert(0, '/data/workspace/tools')
from kb import store_document

content = """
Philosophy King music, videos, stats, and photos

Listeners: 1
Scrobbles: 3

Top Tracks:
- Listen Up! (1 listener)

Artist Info:
Philosophy King is a rapper with minimal online presence.
Track: Listen Up!

The artist has 1 listener and 3 scrobbles on Last.fm.
No upcoming events.
No photos.
"""

url = "https://www.last.fm/music/Philosophy%20King"
store_document(url, content, "artist_profile")
