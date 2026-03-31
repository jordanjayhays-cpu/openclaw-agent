#!/usr/bin/env python3
"""
PK Knowledge Base - RAG System
Takes URLs → Fetches content → Stores with embeddings → Queries naturally

Usage:
    python3 kb-ingest.py "https://url-to-ingest.com"
    python3 kb-query.py "your question about what you've read"
"""

import sqlite3
import os
import sys
import json
import hashlib
from datetime import datetime

KB_DIR = "/data/workspace/PROJECTS/PK-MUSIC/knowledge-base"
DB_PATH = f"{KB_DIR}/kb.db"

def init_db():
    """Initialize the knowledge base database"""
    os.makedirs(KB_DIR, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    c.execute('''
        CREATE TABLE IF NOT EXISTS documents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT UNIQUE,
            title TEXT,
            content TEXT,
            content_hash TEXT,
            source_type TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_accessed TIMESTAMP,
            access_count INTEGER DEFAULT 0
        )
    ''')
    
    c.execute('''
        CREATE TABLE IF NOT EXISTS chunks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            doc_id INTEGER,
            chunk_text TEXT,
            chunk_index INTEGER,
            embedding_id TEXT,
            FOREIGN KEY (doc_id) REFERENCES documents(id)
        )
    ''')
    
    c.execute('CREATE INDEX IF NOT EXISTS idx_url ON documents(url)')
    c.execute('CREATE INDEX IF NOT EXISTS idx_created ON documents(created_at)')
    
    conn.commit()
    conn.close()
    print(f"✅ Knowledge base initialized at {DB_PATH}")

def url_to_filename(url):
    """Convert URL to safe filename for caching"""
    h = hashlib.md5(url.encode()).hexdigest()[:12]
    return f"{KB_DIR}/cache/{h}.txt"

def get_cached_content(url):
    """Get content from cache if exists and recent (24h)"""
    filepath = url_to_filename(url)
    cache_file = filepath + ".meta"
    
    if os.path.exists(filepath) and os.path.exists(cache_file):
        try:
            with open(cache_file, 'r') as f:
                meta = json.load(f)
            # Check if cache is fresh (24h)
            cached_time = datetime.fromisoformat(meta['cached_at'])
            if (datetime.now() - cached_time).seconds < 86400:
                with open(filepath, 'r') as f:
                    return f.read(), meta['title']
        except:
            pass
    return None, None

def cache_content(url, content, title):
    """Cache content to disk"""
    filepath = url_to_filename(url)
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    
    with open(filepath, 'w') as f:
        f.write(content)
    
    meta = {
        'url': url,
        'title': title,
        'cached_at': datetime.now().isoformat()
    }
    with open(filepath + ".meta", 'w') as f:
        json.dump(meta, f)
    
    return filepath

def chunk_text(text, chunk_size=500, overlap=50):
    """Split text into overlapping chunks"""
    chunks = []
    start = 0
    text = text.replace('\r\n', '\n').replace('\r', '\n')
    
    while start < len(text):
        end = start + chunk_size
        chunk = text[start:end]
        
        # Don't cut in the middle of a sentence
        if end < len(text) and chunk[-1] not in '.\n!?':
            # Find last sentence boundary
            last_punct = max(chunk.rfind('.'), chunk.rfind('!'), chunk.rfind('?'))
            if last_punct > chunk_size - 100:
                end = last_punct + 1
                chunk = text[start:end]
        
        chunks.append(chunk.strip())
        start = end - overlap
    
    return [c for c in chunks if len(c) > 50]  # Filter tiny chunks

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 kb-ingest.py <url>")
        sys.exit(1)
    
    url = sys.argv[1]
    print(f"\n🔍 Ingesting: {url}")
    
    # Initialize DB
    init_db()
    
    # Check cache
    content, title = get_cached_content(url)
    if content:
        print(f"📦 Using cached content: {title}")
    else:
        print("🌐 Fetching content (not cached)")
        # For now, we need to use web_fetch externally
        print("⚠️ Use web_fetch first, then call kb-add.py with the content")
        sys.exit(1)

if __name__ == "__main__":
    main()
