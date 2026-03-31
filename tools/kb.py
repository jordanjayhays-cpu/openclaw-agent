#!/usr/bin/env python3
"""
PK Knowledge Base - Simple Interface
===================================
Usage:
    python3 kb.py add <url>    Add URL
    python3 kb.py ask <query>  Ask question
    python3 kb.py list         List all
    python3 kb.py stats        Stats
"""

import sys
import os
import json
import re
import sqlite3
import math
import subprocess
from collections import Counter
from datetime import datetime

KB_DIR = "/data/workspace/PROJECTS/PK-MUSIC/knowledge-base"
DB_PATH = f"{KB_DIR}/kb.db"

STOPWORDS = {'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
    'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'been',
    'be', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would',
    'could', 'should', 'may', 'might', 'must', 'shall', 'can', 'need',
    'it', 'its', 'this', 'that', 'these', 'those', 'i', 'you', 'he',
    'she', 'we', 'they', 'what', 'which', 'who', 'whom', 'when', 'where',
    'why', 'how', 'all', 'each', 'every', 'both', 'few', 'more', 'most',
    'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same',
    'so', 'than', 'too', 'very', 'just', 'also', 'now', 'here', 'there',
    'then', 'once', 'if', 'because', 'about', 'into', 'through', 'during'}

def tokenize(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    tokens = text.split()
    return [t for t in tokens if t not in STOPWORDS and len(t) > 2]

def compute_tf(tokens):
    return Counter(tokens)

def compute_idf(documents):
    N = len(documents)
    idf = {}
    all_terms = set()
    for doc in documents:
        all_terms.update(doc.keys())
    for term in all_terms:
        df = sum(1 for doc in documents if term in doc)
        idf[term] = math.log(N / (df + 1)) + 1
    return idf

def compute_tfidf(tf, idf):
    return {term: freq * idf.get(term, 0) for term, freq in tf.items()}

def cosine_similarity(vec1, vec2):
    all_terms = set(vec1.keys()) | set(vec2.keys())
    dot_product = sum(vec1.get(t, 0) * vec2.get(t, 0) for t in all_terms)
    mag1 = math.sqrt(sum(v**2 for v in vec1.values()))
    mag2 = math.sqrt(sum(v**2 for v in vec2.values()))
    if mag1 == 0 or mag2 == 0:
        return 0
    return dot_product / (mag1 * mag2)

def search_semantic(query, top_k=5):
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    c = conn.cursor()
    c.execute('SELECT id, url, title, content, summary, source_type, created_at FROM documents')
    docs = c.fetchall()
    conn.close()
    
    if not docs:
        return []
    
    query_tokens = tokenize(query)
    query_tf = compute_tf(query_tokens)
    
    all_doc_tfs = []
    for doc in docs:
        content = doc['content'] or doc['summary'] or ''
        tokens = tokenize(content)
        all_doc_tfs.append(compute_tf(tokens))
    
    idf = compute_idf(all_doc_tfs)
    query_tfidf = compute_tfidf(query_tf, idf)
    
    results = []
    for doc in docs:
        content = doc['content'] or doc['summary'] or ''
        doc_tfidf = compute_tfidf(compute_tf(tokenize(content)), idf)
        score = cosine_similarity(query_tfidf, doc_tfidf)
        if score > 0:
            results.append({
                'id': doc['id'], 'url': doc['url'], 'title': doc['title'],
                'summary': doc['summary'], 'source_type': doc['source_type'],
                'created_at': doc['created_at'], 'score': score
            })
    
    results.sort(key=lambda x: x['score'], reverse=True)
    return results[:top_k]

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

def add_url(url):
    print(f"\n🔍 Fetching: {url}")
    html = fetch_url(url)
    if not html:
        print("❌ Could not fetch. Try adding content directly.")
        return
    text = extract_text(html)
    if not text:
        print("❌ Could not extract content")
        return
    
    # Import and use store_document
    sys.path.insert(0, '/data/workspace/tools')
    from kb import store_document
    store_document(url, text[:50000])
    print("\n✅ Added! Ask me about it now.")

def ask_question(question):
    print(f"\n🔍 Searching: {question}")
    results = search_semantic(question, top_k=5)
    if not results:
        print("\n❌ Nothing found. Add content first:")
        print("   'Add this: https://url.com'")
        return
    print(f"\n📚 Found {len(results)} results:\n")
    for i, r in enumerate(results, 1):
        print(f"{i}. {r['title']} ({r['score']*100:.0f}% match)")
        if r['summary']:
            print(f"   {r['summary'][:150]}...")
        print(f"   {r['url']}\n")

def main():
    if len(sys.argv) < 2:
        print("""
🧠 PK Knowledge Base
====================
Usage:
    kb.py add <url>   Add URL to KB
    kb.py ask <query> Ask about content
    kb.py list        List all docs
    kb.py stats       Show stats
""")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == 'add':
        if len(sys.argv) < 3:
            print("Usage: kb.py add <url>")
            sys.exit(1)
        add_url(sys.argv[2])
    
    elif cmd == 'ask':
        if len(sys.argv) < 3:
            print("Usage: kb.py ask <question>")
            sys.exit(1)
        ask_question(' '.join(sys.argv[2:]))
    
    elif cmd == 'list':
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute('SELECT id, title, source_type, created_at FROM documents')
        for row in c.fetchall():
            print(f"{row[0]}. {row[1]} [{row[2]}]")
        conn.close()
    
    elif cmd == 'stats':
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute('SELECT COUNT(*) FROM documents')
        docs = c.fetchone()[0]
        c.execute('SELECT SUM(LENGTH(content)) FROM documents')
        chars = c.fetchone()[0] or 0
        conn.close()
        print(f"\n📊 KB: {docs} docs, {chars:,} chars\n")

if __name__ == "__main__":
    main()
