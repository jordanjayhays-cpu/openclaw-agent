# Session Search — FTS5 Index

**Created:** 2026-04-20  
**Status:** Indexed and operational (42 sessions)

---

## Database

- **Path:** `~/.openclaw/workspace/memory/sessions.db`
- **Table:** `sessions_fts` (FTS5 virtual table)

## Schema

```sql
CREATE VIRTUAL TABLE sessions_fts USING fts5(
  session_key TEXT,
  date TEXT,
  content TEXT
);
```

- `session_key` — UUID of the session file (without `.jsonl`)
- `date` — File modification date (YYYY-MM-DD)
- `content` — Extracted text from all lines in the session JSONL (truncated to 8000 chars)

## Sessions Indexed

| Date | Count |
|------|-------|
| 2026-04-20 | 7 |
| 2026-04-19 | 8 |
| 2026-04-18 | 3 |
| 2026-04-17 | 1 |
| 2026-04-16 | 2 |
| 2026-04-13 | 1 |
| 2026-04-06 | 1 |
| 2026-04-02 | 3 |
| 2026-04-01 | 9 |
| 2026-03-31 | 7 |
| **Total** | **42** |

**Source:** `~/.openclaw/agents/main/sessions/*.jsonl` (37 files found and indexed)

---

## Usage

### Python (recommended)

```python
import sqlite3, os

db_path = os.path.expanduser("~/.openclaw/workspace/memory/sessions.db")
conn = sqlite3.connect(db_path)

# Search sessions — FTS5 queries
cur = conn.execute("""
    SELECT session_key, date 
    FROM sessions_fts 
    WHERE sessions_fts MATCH 'Jordan OR PISCO'
    LIMIT 20
""")
for row in cur.fetchall():
    print(row[0], row[1])

# Note: FTS5 MATCH syntax for Python sqlite3 requires running the query 
# differently — see the search wrapper below
conn.close()
```

### FTS5 Query Syntax

- **Single term:** `sessions_fts MATCH 'Jordan'`
- **Phrase:** `sessions_fts MATCH '"exact phrase"'`
- **OR:** `sessions_fts MATCH 'Jordan OR PISCO'`
- **AND:** `sessions_fts MATCH 'Jordan AND PISCO'`
- **Wildcard prefix:** `sessions_fts MATCH 'Jord*'`

**Important:** In Python's `sqlite3`, FTS5 MATCH queries must be executed via `conn.execute()` directly. Some query patterns may return `unable to use function MATCH in the requested context` — if that happens, use the Python wrapper below.

### Python Search Wrapper (robust)

```python
def search_sessions(conn, query, limit=20):
    """Search sessions by keyword/phrase."""
    cur = conn.execute("""
        SELECT session_key, date 
        FROM sessions_fts 
        WHERE sessions_fts MATCH ?
        LIMIT ?
    """, (query, limit))
    return cur.fetchall()

# Example
conn = sqlite3.connect(db_path)
results = search_sessions(conn, 'Jordan')
for sk, date in results:
    print(f"{date} | {sk}")
```

### Raw SQL with FTS5

```sql
-- Basic search
SELECT session_key, date FROM sessions_fts WHERE sessions_fts MATCH 'Jordan';

-- With snippet highlight
SELECT session_key, snippet(sessions_fts, 2, '<b>', '</b>', '...', 30) 
FROM sessions_fts 
WHERE sessions_fts MATCH 'Jordan';
```

---

## Re-indexing

Run daily via cron. Command:

```bash
python3 << 'EOF'
import sqlite3, os, json
from datetime import datetime

db_path = os.path.expanduser("~/.openclaw/workspace/memory/sessions.db")
sess_dir = os.path.expanduser("~/.openclaw/agents/main/sessions/")

conn = sqlite3.connect(db_path)
conn.execute("CREATE VIRTUAL TABLE IF NOT EXISTS sessions_fts USING fts5(session_key, date, content);")

indexed = 0
for fname in os.listdir(sess_dir):
    if not fname.endswith(".jsonl"):
        continue
    fpath = os.path.join(sess_dir, fname)
    session_key = os.path.splitext(fname)[0]
    date_str = datetime.fromtimestamp(os.path.getmtime(fpath)).strftime("%Y-%m-%d")
    try:
        content_parts = []
        with open(fpath, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    obj = json.loads(line)
                    if isinstance(obj, dict):
                        if "content" in obj:
                            content_parts.append(str(obj["content"])[:2000])
                        elif "text" in obj:
                            content_parts.append(str(obj["text"])[:2000])
                        elif "message" in obj and isinstance(obj["message"], str):
                            content_parts.append(obj["message"][:2000])
                        else:
                            content_parts.append(json.dumps(obj)[:1000])
                except:
                    if line:
                        content_parts.append(line[:500])
        content = " ".join(content_parts)[:8000]
        conn.execute("INSERT OR REPLACE INTO sessions_fts (session_key, date, content) VALUES (?, ?, ?)",
                     (session_key, date_str, content))
        indexed += 1
    except Exception as e:
        pass

conn.commit()
conn.close()
print(f"Indexed {indexed} sessions")
EOF
```

---

## Notes

- FTS5 MATCH doesn't work inside subqueries or complex JOINs in Python's sqlite3 module. Use simple SELECT + WHERE.
- `snippet()` function available for result highlighting but may not work in all contexts.
- Content is extracted from JSON lines — text fields like `content`, `text`, `message` are prioritized.
- Git conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) are preserved as-is in content.
- Sessions from `agents/main/sessions/` are indexed — not cron run logs or other JSONL files.