#!/usr/bin/env python3
"""
Knowledge Base - Main Interface
================================
Two separate RAG systems:
1. General: Articles, philosophy, research, web content
2. PK Music: Tracks, albums, music concepts

Usage:
    kb add <url>              → Add to GENERAL knowledge base
    kb add pk <url>           → Add to PK MUSIC knowledge base
    kb ask <question>         → Search GENERAL
    kb ask pk <question>       → Search PK MUSIC  
    kb list                   → List both
    kb stats                  → Show stats for both
"""

import sys
import os
import re
import sqlite3
import math
import subprocess
from collections import Counter
from datetime import datetime

# Two separate knowledge bases
KB_GENERAL = "/data/workspace/knowledge-base"
KB_PK = "/data/workspace/PROJECTS/PK-MUSIC/knowledge-base"

STOPWORDS = {'that','with','from','this','have','were','they','been','would','could','should',
    'their','there','which','what','about','more','than','then','when','where','each','also',
    'only','such','into','over','both','same','very','just','must','even','will','from',
    'have','were','they','been','your','some','any','all','but','not','for','are','was',
    'has','her','him','his','she','here','out','new','old','use','using','used'}

def init_db(kb_dir):
    os.makedirs(kb_dir, exist_ok=True)
    db = f"{kb_dir}/kb.db"
    conn = sqlite3.connect(db)
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT UNIQUE NOT NULL, title TEXT,
        content TEXT, summary TEXT, source_type TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)''')
    c.execute('''CREATE TABLE IF NOT EXISTS keywords (
        id INTEGER PRIMARY KEY AUTOINCREMENT, doc_id INTEGER, keyword TEXT,
        frequency INTEGER DEFAULT 1, FOREIGN KEY (doc_id) REFERENCES documents(id))''')
    c.execute('CREATE INDEX IF NOT EXISTS idx_keywords ON keywords(keyword)')
    conn.commit()
    conn.close()
    return db

def tokenize(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    tokens = text.split()
    return [t for t in tokens if t not in STOPWORDS and len(t) > 2]

def compute_tf(tokens):
    return Counter(tokens)

def compute_idf(all_doc_tfs):
    N = len(all_doc_tfs)
    idf = {}
    all_terms = set()
    for doc in all_doc_tfs:
        all_terms.update(doc.keys())
    for term in all_terms:
        df = sum(1 for doc in all_doc_tfs if term in doc)
        idf[term] = math.log(N / (df + 1)) + 1
    return idf

def compute_tfidf(tf, idf):
    return {term: freq * idf.get(term, 0) for term, freq in tf.items()}

def cosine_sim(vec1, vec2):
    all_terms = set(vec1.keys()) | set(vec2.keys())
    dot = sum(vec1.get(t, 0) * vec2.get(t, 0) for t in all_terms)
    mag1 = math.sqrt(sum(v**2 for v in vec1.values()))
    mag2 = math.sqrt(sum(v**2 for v in vec2.values()))
    if mag1 == 0 or mag2 == 0:
        return 0
    return dot / (mag1 * mag2)

def search_kb(query, kb_dir, top_k=5):
    db = f"{kb_dir}/kb.db"
    if not os.path.exists(db):
        return []
    
    conn = sqlite3.connect(db)
    conn.row_factory = sqlite3.Row
    c = conn.cursor()
    c.execute('SELECT id, url, title, content, summary, source_type FROM documents')
    docs = c.fetchall()
    conn.close()
    
    if not docs:
        return []
    
    query_tokens = tokenize(query)
    query_tf = compute_tf(query_tokens)
    
    all_doc_tfs = []
    for doc in docs:
        content = doc['content'] or doc['summary'] or ''
        all_doc_tfs.append(compute_tf(tokenize(content)))
    
    idf = compute_idf(all_doc_tfs)
    query_tfidf = compute_tfidf(query_tf, idf)
    
    results = []
    for doc in docs:
        content = doc['content'] or doc['summary'] or ''
        doc_tfidf = compute_tfidf(compute_tf(tokenize(content)), idf)
        score = cosine_sim(query_tfidf, doc_tfidf)
        if score > 0:
            results.append({
                'id': doc['id'], 'url': doc['url'], 'title': doc['title'],
                'summary': doc['summary'], 'source_type': doc['source_type'], 'score': score
            })
    
    results.sort(key=lambda x: x['score'], reverse=True)
    return results[:top_k]

def store_doc(url, content, title, source_type, kb_dir):
    db = init_db(kb_dir)
    clean = re.sub(r'\s+', ' ', content).strip()[:50000]
    
    conn = sqlite3.connect(db)
    c = conn.cursor()
    c.execute('INSERT OR REPLACE INTO documents (url, title, content, summary, source_type) VALUES (?, ?, ?, ?, ?)',
        (url, title, clean, clean[:300], source_type))
    doc_id = c.lastrowid
    words = [w for w in tokenize(clean) if len(w) > 3]
    for kw, _ in Counter(words).most_common(15):
        c.execute('INSERT OR IGNORE INTO keywords (doc_id, keyword) VALUES (?, ?)', (doc_id, kw))
    conn.commit()
    conn.close()
    return doc_id

def fetch_url(url):
    try:
        result = subprocess.run([
            'curl', '-s', '-L', '--max-time', '30',
            '-A', 'Mozilla/5.0', url
        ], capture_output=True, text=True, timeout=35)
        return result.stdout if result.returncode == 0 else None
    except:
        return None

def extract_text(html):
    if not html:
        return None
    html = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL)
    html = re.sub(r'<style[^>]*>.*?</style>', '', html, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', ' ', html)
    text = re.sub(r'\s+', ' ', text).strip()
    return text if len(text) > 100 else None

def get_stats(kb_dir):
    db = f"{kb_dir}/kb.db"
    if not os.path.exists(db):
        return 0, 0
    conn = sqlite3.connect(db)
    c = conn.cursor()
    c.execute('SELECT COUNT(*), SUM(LENGTH(content)) FROM documents')
    count, chars = c.fetchone()
    conn.close()
    return count or 0, chars or 0

def main():
    if len(sys.argv) < 2:
        print("""
🧠 Knowledge Base - Two Systems
================================

GENERAL (articles, philosophy, research):
    kb add <url>         Add URL
    kb ask <question>    Search GENERAL

PK MUSIC (tracks, albums):
    kb add pk <url>     Add to PK
    kb ask pk <query>   Search PK

OTHER:
    kb list             List all docs
    kb stats            Show stats

Examples:
    kb add https://article.com
    kb ask "what do I know about Nietzsche?"
    kb add pk https://youtube.com/track
    kb ask pk "tracks about freedom"
""")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == 'add':
        if len(sys.argv) < 3:
            print("Usage: kb add <url>")
            sys.exit(1)
        url = sys.argv[2]
        kb_dir = KB_GENERAL
        print(f"\n🌐 Fetching: {url}")
        html = fetch_url(url)
        if not html:
            print("❌ Could not fetch. Try pasting content directly.")
            return
        text = extract_text(html)
        if not text:
            print("❌ Could not extract content")
            return
        store_doc(url, text[:50000], url.split('/')[-1][:50], 'web_content', kb_dir)
        print("✅ Added to GENERAL knowledge base")
    
    elif cmd == 'ask':
        if len(sys.argv) < 3:
            print("Usage: kb ask <question>")
            sys.exit(1)
        query = ' '.join(sys.argv[2:])
        kb_dir = KB_GENERAL
        results = search_kb(query, kb_dir)
        if not results:
            print(f"\n❌ Nothing found in GENERAL for: {query}")
            print("   Try: kb add <url> to add content")
            return
        print(f"\n🔍 GENERAL search: {query}")
        print("=" * 60)
        for i, r in enumerate(results, 1):
            print(f"\n{i}. {r['title']} ({r['score']*100:.0f}%)")
            if r['summary']:
                print(f"   {r['summary'][:150]}...")
    
    elif cmd == 'list':
        for name, kb_dir in [("GENERAL", KB_GENERAL), ("PK MUSIC", KB_PK)]:
            db = f"{kb_dir}/kb.db"
            if os.path.exists(db):
                conn = sqlite3.connect(db)
                c = conn.cursor()
                c.execute('SELECT title, source_type FROM documents')
                rows = c.fetchall()
                conn.close()
                print(f"\n📚 {name} ({len(rows)} docs)")
                for row in rows:
                    print(f"   • {row[0][:60]}")
    
    elif cmd == 'stats':
        g_count, g_chars = get_stats(KB_GENERAL)
        p_count, p_chars = get_stats(KB_PK)
        print(f"""
📊 Knowledge Bases
==================
GENERAL:   {g_count} docs, {g_chars:,} chars
PK MUSIC:  {p_count} docs, {p_chars:,} chars
""")
    
    else:
        print(f"Unknown command: {cmd}")

if __name__ == "__main__":
    main()
