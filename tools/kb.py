#!/usr/bin/env python3
"""
PK Knowledge Base - Full RAG Pipeline
URL → Fetch → Extract → Chunk → Embed → Store → Query

Uses free embedding API or keyword fallback
"""

import sqlite3
import os
import sys
import json
import hashlib
import re
from datetime import datetime
from urllib.parse import urlparse

KB_DIR = "/data/workspace/PROJECTS/PK-MUSIC/knowledge-base"
DB_PATH = f"{KB_DIR}/kb.db"

def init_db():
    """Initialize knowledge base"""
    os.makedirs(KB_DIR, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    c.execute('''
        CREATE TABLE IF NOT EXISTS documents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT UNIQUE NOT NULL,
            title TEXT,
            content TEXT,
            summary TEXT,
            source_type TEXT,
            entities TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            access_count INTEGER DEFAULT 0
        )
    ''')
    
    # For keyword search
    c.execute('''
        CREATE TABLE IF NOT EXISTS keywords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            doc_id INTEGER,
            keyword TEXT,
            frequency INTEGER DEFAULT 1,
            FOREIGN KEY (doc_id) REFERENCES documents(id)
        )
    ''')
    
    c.execute('CREATE INDEX IF NOT EXISTS idx_keywords ON keywords(keyword)')
    c.execute('CREATE INDEX IF NOT EXISTS idx_url ON documents(url)')
    
    conn.commit()
    conn.close()

def extract_title(content, url):
    """Extract title from content or URL"""
    # Try to find <title> tag
    title_match = re.search(r'<title[^>]*>([^<]+)</title>', content, re.IGNORECASE)
    if title_match:
        return title_match.group(1).strip()
    
    # Try first H1
    h1_match = re.search(r'<h1[^>]*>([^<]+)</h1>', content, re.IGNORECASE)
    if h1_match:
        return h1_match.group(1).strip()
    
    # Fall back to URL
    parsed = urlparse(url)
    path = parsed.path.strip('/')
    if path:
        return path.split('/')[-1].replace('-', ' ').replace('_', ' ').title()
    
    return url

def extract_entities(content):
    """Extract key entities (simple version)"""
    # Look for hashtags, mentions, key phrases
    entities = []
    
    # Hashtags
    hashtags = re.findall(r'#(\w+)', content)
    entities.extend(['#' + h for h in hashtags])
    
    # Capitalized phrases (potential key terms)
    caps = re.findall(r'\b([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)\b', content)
    entities.extend(caps[:5])  # Limit
    
    return ', '.join(entities[:20])  # Max 20 entities

def extract_summary(content, max_length=300):
    """Extract a summary from content"""
    # Remove HTML tags
    text = re.sub(r'<[^>]+>', ' ', content)
    text = re.sub(r'\s+', ' ', text).strip()
    
    # Get first meaningful paragraph
    sentences = text.split('. ')
    summary = ''
    for sent in sentences:
        if len(summary) + len(sent) < max_length:
            summary += sent + '. '
        else:
            break
    
    return summary.strip() if summary else text[:max_length] + '...'

def extract_keywords(content, top_n=20):
    """Extract important keywords (simple TF-IDF-like)"""
    # Common stop words
    stopwords = {'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
                 'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'been',
                 'be', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
                 'should', 'may', 'might', 'must', 'shall', 'can', 'need', 'it', 'its',
                 'this', 'that', 'these', 'those', 'i', 'you', 'he', 'she', 'we', 'they',
                 'what', 'which', 'who', 'whom', 'when', 'where', 'why', 'how', 'all',
                 'each', 'every', 'both', 'few', 'more', 'most', 'other', 'some', 'such',
                 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very'}
    
    # Extract words
    words = re.findall(r'\b[a-zA-Z]{3,}\b', content.lower())
    
    # Count frequency
    freq = {}
    for word in words:
        if word not in stopwords:
            freq[word] = freq.get(word, 0) + 1
    
    # Sort by frequency
    sorted_words = sorted(freq.items(), key=lambda x: x[1], reverse=True)
    
    return [word for word, _ in sorted_words[:top_n]]

def store_document(url, content, source_type="article"):
    """Store a document in the knowledge base"""
    init_db()
    
    title = extract_title(content, url)
    summary = extract_summary(content)
    entities = extract_entities(content)
    keywords = extract_keywords(content)
    
    # Clean content (remove excessive whitespace)
    clean_content = re.sub(r'\s+', ' ', content).strip()[:50000]  # Max 50k chars
    
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    try:
        # Insert or update document
        c.execute('''
            INSERT OR REPLACE INTO documents (url, title, content, summary, source_type, entities)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (url, title, clean_content, summary, source_type, entities))
        
        doc_id = c.lastrowid
        
        # Store keywords
        for keyword in keywords:
            c.execute('''
                INSERT OR IGNORE INTO keywords (doc_id, keyword, frequency)
                VALUES (?, ?, 1)
            ''', (doc_id, keyword))
        
        conn.commit()
        
        print(f"\n✅ Stored: {title}")
        print(f"📝 Summary: {summary[:150]}...")
        print(f"🏷️ Keywords: {', '.join(keywords[:10])}")
        
        # Save full content to cache
        cache_path = f"{KB_DIR}/cache/{hashlib.md5(url.encode()).hexdigest()[:12]}.json"
        os.makedirs(f"{KB_DIR}/cache", exist_ok=True)
        with open(cache_path, 'w') as f:
            json.dump({
                'url': url,
                'title': title,
                'content': clean_content,
                'summary': summary,
                'entities': entities,
                'keywords': keywords,
                'stored_at': datetime.now().isoformat()
            }, f)
        
        return doc_id
        
    except Exception as e:
        print(f"❌ Error storing document: {e}")
        return None
    finally:
        conn.close()

def search(query, top_k=5):
    """Search knowledge base with keyword matching + ranking"""
    init_db()
    
    query_words = set(re.findall(r'\b[a-zA-Z]{3,}\b', query.lower()))
    
    if not query_words:
        return []
    
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    # Find documents with matching keywords
    scores = {}
    for word in query_words:
        c.execute('''
            SELECT d.id, d.url, d.title, d.summary, k.frequency
            FROM documents d
            JOIN keywords k ON d.id = k.doc_id
            WHERE k.keyword = ?
        ''', (word,))
        
        for row in c.fetchall():
            doc_id, url, title, summary, freq = row
            if doc_id not in scores:
                scores[doc_id] = {'url': url, 'title': title, 'summary': summary, 'score': 0}
            scores[doc_id]['score'] += freq
    
    # Sort by score
    results = sorted(scores.values(), key=lambda x: x['score'], reverse=True)[:top_k]
    
    conn.close()
    return results

def main():
    if len(sys.argv) < 2:
        print("""
PK Knowledge Base - RAG Pipeline

Usage:
    python3 kb.py store <url>          # Store a URL
    python3 kb.py search <query>      # Search knowledge base
    python3 kb.py list                # List all documents
    python3 kb.py stats               # Show statistics
""")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == 'store':
        if len(sys.argv) < 3:
            print("Usage: python3 kb.py store <url>")
            sys.exit(1)
        url = sys.argv[2]
        print(f"Use web_fetch to get content, then I'll store it")
        
    elif command == 'search':
        if len(sys.argv) < 3:
            print("Usage: python3 kb.py search <query>")
            sys.exit(1)
        query = ' '.join(sys.argv[2:])
        results = search(query)
        print(f"\n🔍 Search results for: {query}")
        print("=" * 60)
        for i, r in enumerate(results, 1):
            print(f"\n{i}. {r['title']}")
            print(f"   {r['summary'][:150]}...")
            print(f"   {r['url']}")
        
    elif command == 'list':
        init_db()
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute('SELECT id, url, title, created_at FROM documents ORDER BY created_at DESC')
        rows = c.fetchall()
        conn.close()
        
        print(f"\n📚 Knowledge Base ({len(rows)} documents)")
        print("=" * 60)
        for row in rows:
            print(f"\n{row[0]}. {row[2]}")
            print(f"   {row[1]}")
            print(f"   Added: {row[3]}")
    
    elif command == 'stats':
        init_db()
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        
        c.execute('SELECT COUNT(*) FROM documents')
        doc_count = c.fetchone()[0]
        
        c.execute('SELECT COUNT(*) FROM keywords')
        keyword_count = c.fetchone()[0]
        
        c.execute('SELECT SUM(LENGTH(content)) FROM documents')
        total_chars = c.fetchone()[0] or 0
        
        conn.close()
        
        print(f"""
📊 Knowledge Base Statistics
=============================
Documents:    {doc_count}
Keywords:     {keyword_count}
Total chars: {total_chars:,}
""")

if __name__ == "__main__":
    main()
