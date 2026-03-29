#!/usr/bin/env python3
"""
Notion Sync - Reads Jordan's Notion pages
Tokens loaded from environment variables only (not in git)
"""

import os
import json
import urllib.request
import urllib.parse
import urllib.error

# Get token from environment
NOTION_TOKEN = os.environ.get("NOTION_TOKEN_2", "")

if not NOTION_TOKEN:
    print("ERROR: NOTION_TOKEN_2 not set in environment")
    exit(1)

HEADERS = {
    "Authorization": f"Bearer {NOTION_TOKEN}",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json"
}

def api_get(url):
    req = urllib.request.Request(url, headers=HEADERS)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode())
    except urllib.error.HTTPError as e:
        return {"error": True, "message": f"HTTP {e.code}: {e.reason}"}
    except Exception as e:
        return {"error": True, "message": str(e)}

def get_page(page_id):
    return api_get(f"https://api.notion.com/v1/pages/{page_id}")

def get_blocks(page_id):
    return api_get(f"https://api.notion.com/v1/blocks/{page_id}/children")

def extract_text(block):
    btype = block.get('type')
    content = block.get(btype, {}).get('rich_text', [])
    return ''.join([c.get('plain_text', '') for c in content])

PAGES = {
    "massage-pass": "1d9efcda373d80469c94c0c07e33b2ed",
    "google-maps": "1eeefcda373d8085a488c31e17b326ca",
}

print("🔄 Notion Sync")
print("=" * 40)

for name, page_id in PAGES.items():
    print(f"\n📄 {name}")
    page = get_page(page_id)
    if page.get('error'):
        print(f"❌ {page['message']}")
        continue
    
    title = "Untitled"
    props = page.get('properties', {})
    if 'title' in props:
        title_parts = props['title'].get('title', [])
        if title_parts:
            title = title_parts[0].get('text', {}).get('content', 'Untitled')
    
    print(f"✅ {title}")
    print(f"   Last edited: {page.get('last_edited_time', 'Unknown')}")

print("\n✅ Done")
