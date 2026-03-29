#!/usr/bin/env python3
"""
PK Knowledge Base - Semantic Search with TF-IDF
No external ML libraries needed - pure Python implementation
"""

import sqlite3
import os
import sys
import json
import math
import re
from collections import Counter
from datetime import datetime

KB_DIR = "/data/workspace/PROJECTS/PK-MUSIC/knowledge-base"
DB_PATH = f"{KB_DIR}/kb.db"

# Stopwords - common words to ignore
STOPWORDS = {
    'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
    'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'been',
    'be', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would',
    'could', 'should', 'may', 'might', 'must', 'shall', 'can', 'need',
    'it', 'its', 'this', 'that', 'these', 'those', 'i', 'you', 'he',
    'she', 'we', 'they', 'what', 'which', 'who', 'whom', 'when', 'where',
    'why', 'how', 'all', 'each', 'every', 'both', 'few', 'more', 'most',
    'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same',
    'so', 'than', 'too', 'very', 'just', 'also', 'now', 'here', 'there',
    'then', 'once', 'if', 'because', 'about', 'into', 'through', 'during',
    'before', 'after', 'above', 'below', 'between', 'under', 'again',
    'further', 'while', 'same', 'while', 'up', 'down', 'out', 'off', 'over'
}

def tokenize(text):
    """Convert text to lowercase tokens, removing punctuation"""
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    tokens = text.split()
    return [t for t in tokens if t not in STOPWORDS and len(t) > 2]

def compute_tf(tokens):
    """Term Frequency - how often a term appears"""
    return Counter(tokens)

def compute_idf(documents):
    """Inverse Document Frequency - how unique a term is across all docs"""
    N = len(documents)
    idf = {}
    all_terms = set()
    for doc in documents:
        all_terms.update(doc.keys())
    
    for term in all_terms:
        # Number of docs containing term
        df = sum(1 for doc in documents if term in doc)
        idf[term] = math.log(N / (df + 1)) + 1  # Smoothed
    
    return idf

def compute_tfidf(tf, idf):
    """TF-IDF vector for a document"""
    return {term: freq * idf.get(term, 0) for term, freq in tf.items()}

def cosine_similarity(vec1, vec2):
    """Cosine similarity between two TF-IDF vectors"""
    # Get all terms
    all_terms = set(vec1.keys()) | set(vec2.keys())
    
    # Dot product
    dot_product = sum(vec1.get(t, 0) * vec2.get(t, 0) for t in all_terms)
    
    # Magnitudes
    mag1 = math.sqrt(sum(v**2 for v in vec1.values()))
    mag2 = math.sqrt(sum(v**2 for v in vec2.values()))
    
    if mag1 == 0 or mag2 == 0:
        return 0
    
    return dot_product / (mag1 * mag2)

def search_semantic(query, top_k=5):
    """Search using TF-IDF semantic similarity"""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    c = conn.cursor()
    
    # Get all documents
    c.execute('SELECT id, url, title, content, summary, source_type, created_at FROM documents')
    docs = c.fetchall()
    conn.close()
    
    if not docs:
        return []
    
    # Tokenize query
    query_tokens = tokenize(query)
    query_tf = compute_tf(query_tokens)
    
    # Compute IDF from all documents
    all_doc_tfs = []
    for doc in docs:
        content = doc['content'] or doc['summary'] or ''
        tokens = tokenize(content)
        doc_tf = compute_tf(tokens)
        all_doc_tfs.append(doc_tf)
    
    idf = compute_idf(all_doc_tfs)
    
    # Compute query TF-IDF
    query_tfidf = compute_tfidf(query_tf, idf)
    
    # Score each document
    results = []
    for doc in docs:
        content = doc['content'] or doc['summary'] or ''
        doc_tokens = tokenize(content)
        doc_tf = compute_tf(doc_tokens)
        doc_tfidf = compute_tfidf(doc_tf, idf)
        
        score = cosine_similarity(query_tfidf, doc_tfidf)
        
        if score > 0:
            results.append({
                'id': doc['id'],
                'url': doc['url'],
                'title': doc['title'],
                'summary': doc['summary'],
                'source_type': doc['source_type'],
                'created_at': doc['created_at'],
                'score': score
            })
    
    # Sort by score
    results.sort(key=lambda x: x['score'], reverse=True)
    
    return results[:top_k]

def search_hybrid(query, top_k=5):
    """Combine semantic (TF-IDF) with keyword boost"""
    semantic_results = search_semantic(query, top_k * 2)
    
    # Boost results that match keywords exactly
    query_lower = query.lower()
    for r in semantic_results:
        boost = 0
        title_lower = r['title'].lower()
        summary_lower = r['summary'].lower() if r['summary'] else ''
        
        # Exact phrase match in title
        if query_lower in title_lower:
            boost += 0.3
        
        # Keyword matches
        query_words = query_lower.split()
        for word in query_words:
            if len(word) > 3:
                if word in title_lower:
                    boost += 0.1
                if word in summary_lower:
                    boost += 0.05
        
        r['score'] = r['score'] + boost
    
    semantic_results.sort(key=lambda x: x['score'], reverse=True)
    return semantic_results[:top_k]

def main():
    if len(sys.argv) < 2:
        print("""
PK Knowledge Base - Semantic Search
===================================
Usage:
    python3 kb-semantic.py "your search query"
    python3 kb-semantic.py list          # Show all docs
    python3 kb-semantic.py stats        # Show stats
""")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == 'list':
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute('SELECT id, url, title, source_type FROM documents ORDER BY created_at DESC')
        rows = c.fetchall()
        conn.close()
        
        print(f"\n📚 Knowledge Base ({len(rows)} documents)")
        print("=" * 60)
        for row in rows:
            print(f"\n{row[0]}. {row[2]}")
            print(f"   Type: {row[3]}")
            print(f"   {row[1][:80]}")
    
    elif cmd == 'stats':
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute('SELECT COUNT(*), SUM(LENGTH(content)) FROM documents')
        count, chars = c.fetchone()
        conn.close()
        
        print(f"""
📊 Knowledge Base Stats
========================
Documents: {count or 0}
Total chars: {chars or 0:,}
Search: TF-IDF semantic (pure Python)
""")
    
    else:
        query = ' '.join(sys.argv[1:])
        print(f"\n🔍 Searching: {query}")
        print("=" * 60)
        
        results = search_hybrid(query)
        
        if not results:
            print("\nNo results found. Try different keywords.")
        else:
            print(f"\n✅ Found {len(results)} results:\n")
            for i, r in enumerate(results, 1):
                print(f"{i}. {r['title']}")
                print(f"   Score: {r['score']:.3f}")
                print(f"   {r['summary'][:150]}..." if r['summary'] else "")
                print(f"   {r['url']}")
                print()

if __name__ == "__main__":
    main()
