#!/usr/bin/env python3
"""
PK Knowledge Base - Main Interface
==================================
Drop a URL → I fetch, store, summarize
Ask a question → I search and answer

Usage:
    python3 kb.py add "https://url-to-add.com"
    python3 kb.py ask "your question about what you've read"
    python3 kb.py list
    python3 kb.py stats
"""

import sys
import os
import json
import re
import urllib.request
import urllib.error
import hashlib
from datetime import datetime

# Import the modules
sys.path.insert(0, '/data/workspace/tools')
from kb import store_document, init_db
sys.path.insert(0, '/data/workspace/tools')
import kb_semantic as semantic

def search_hybrid(query, top_k=5):
    return semantic.search_hybrid(query, top_k)

KB_DIR = "/data/workspace/PROJECTS/PK-MUSIC/knowledge-base"

def fetch_url(url):
    """Fetch URL content using web_fetch simulation"""
    # Use curl for actual fetching
    import subprocess
    
    try:
        result = subprocess.run([
            'curl', '-s', '-L', '--max-time', '30',
            '-A', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
            url
        ], capture_output=True, text=True, timeout=35)
        
        if result.returncode == 0:
            return result.stdout
        else:
            return None
    except Exception as e:
        print(f"❌ Fetch error: {e}")
        return None

def extract_text_from_html(html):
    """Extract readable text from HTML"""
    if not html:
        return None
    
    # Remove scripts and styles
    html = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL)
    html = re.sub(r'<style[^>]*>.*?</style>', '', html, flags=re.DOTALL)
    
    # Remove HTML tags
    text = re.sub(r'<[^>]+>', ' ', html)
    
    # Clean whitespace
    text = re.sub(r'\s+', ' ', text).strip()
    
    return text if len(text) > 100 else None

def add_url(url):
    """Add URL to knowledge base"""
    print(f"\n🔍 Fetching: {url}")
    
    # Check if already cached
    cache_file = f"{KB_DIR}/cache/{hashlib.md5(url.encode()).hexdigest()[:12]}.json"
    if os.path.exists(cache_file):
        print("📦 Already in cache - use 'kb.py ask' to query it")
        with open(cache_file, 'r') as f:
            data = json.load(f)
        print(f"   Title: {data.get('title', 'Unknown')}")
        return
    
    # Fetch content
    html = fetch_url(url)
    if not html:
        print("❌ Could not fetch URL")
        print("   Tip: Copy the content and paste it directly")
        return
    
    # Extract text
    text = extract_text_from_html(html)
    if not text:
        print("❌ Could not extract content from page")
        return
    
    # Limit content size
    text = text[:50000]
    
    # Store
    doc_id = store_document(url, text)
    
    if doc_id:
        print(f"\n✅ Added to knowledge base!")
        print(f"   You can now ask: \"What is this about?\" or \"Tell me more\"")
    
    return doc_id

def ask_question(question):
    """Search knowledge base and answer question"""
    print(f"\n🔍 Searching: {question}")
    print("=" * 60)
    
    results = search_hybrid(question, top_k=5)
    
    if not results:
        print("\n❌ Nothing found in your knowledge base.")
        print("\n💡 Add content first:")
        print("   python3 kb.py add https://url-to-add.com")
        print("\nOr ask me to add a URL and I'll fetch it for you.")
        return
    
    print(f"\n📚 Found {len(results)} relevant sources:\n")
    
    for i, r in enumerate(results, 1):
        print(f"{i}. {r['title']}")
        print(f"   Relevance: {r['score']*100:.0f}%")
        if r['summary']:
            print(f"   {r['summary'][:200]}...")
        print(f"   Source: {r['url']}")
        print()
    
    # Generate answer using the top results
    if results:
        top = results[0]
        print("💡 Based on your knowledge base:")
        print(f"   \"{top.get('summary', 'No summary available')[:300]}...\"")
        print(f"\n   📄 Source: {top['url']}")
    
    return results

def main():
    if len(sys.argv) < 2:
        print("""
🧠 PK Knowledge Base
====================
Usage:
    python3 kb.py add <url>    Add URL to knowledge base
    python3 kb.py ask <query>  Ask about what you've read
    python3 kb.py list         List all documents
    python3 kb.py stats        Show statistics
    
Examples:
    python3 kb.py add https://article-link.com
    python3 kb.py ask "what do I know about philosophy?"
    python3 kb.py ask "summarize the articles I've saved about AI"
""")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == 'add':
        if len(sys.argv) < 3:
            print("Usage: python3 kb.py add <url>")
            sys.exit(1)
        url = sys.argv[2]
        add_url(url)
    
    elif cmd == 'ask':
        if len(sys.argv) < 3:
            print("Usage: python3 kb.py ask <your question>")
            sys.exit(1)
        question = ' '.join(sys.argv[2:])
        ask_question(question)
    
    elif cmd == 'list':
        conn = sqlite3.connect(f"{KB_DIR}/kb.db")
        c = conn.cursor()
        c.execute('SELECT id, url, title, source_type, created_at FROM documents ORDER BY created_at DESC')
        rows = c.fetchall()
        conn.close()
        
        print(f"\n📚 Knowledge Base ({len(rows)} documents)")
        print("=" * 60)
        for row in rows:
            print(f"\n{row[0]}. {row[2]}")
            print(f"   Type: {row[3]} | Added: {row[4][:10]}")
            print(f"   {row[1][:70]}...")
    
    elif cmd == 'stats':
        import sqlite3
        conn = sqlite3.connect(f"{KB_DIR}/kb.db")
        c = conn.cursor()
        c.execute('SELECT COUNT(*), SUM(LENGTH(content)) FROM documents')
        count, chars = c.fetchone()
        c.execute('SELECT COUNT(*) FROM keywords')
        keywords = c.fetchone()[0]
        conn.close()
        
        print(f"""
📊 Knowledge Base
=================
Documents:  {count or 0}
Keywords:   {keywords or 0}
Characters: {chars or 0:,}
Search:     TF-IDF semantic (pure Python)
""")
    
    else:
        # Treat as a question
        question = ' '.join(sys.argv[1:])
        ask_question(question)

if __name__ == "__main__":
    main()
