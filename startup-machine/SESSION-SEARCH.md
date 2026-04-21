# Session Search Index

Full-text search for OpenClaw session data via SQLite.

## Database Location
```
/home/openclaw/.openclaw/workspace/memory/sessions.db
```

## Table Schema

```sql
CREATE TABLE sessions_fts(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_key TEXT,
  date TEXT,
  content TEXT
);

CREATE INDEX idx_session_key ON sessions_fts(session_key);
CREATE INDEX idx_date ON sessions_fts(date);
```

**Note:** sql.js (pure JS SQLite) doesn't support FTS5. Using regular table with LIKE-based search instead.

## Current Index Stats
- **Sessions indexed:** 8
- **Source:** `~/.openclaw/cron/runs/*.jsonl` (cron run logs)

## Usage

### Node.js (sql.js)
```javascript
const initSqlJs = require('sql.js');
const fs = require('fs');

async function search(query) {
  const SQL = await initSqlJs();
  const db = new SQL.Database(fs.readFileSync('/home/openclaw/.openclaw/workspace/memory/sessions.db'));
  
  const results = db.exec(`
    SELECT session_key, date, content 
    FROM sessions_fts 
    WHERE content LIKE '%${query}%'
  `);
  
  db.close();
  return results;
}
```

### Search Examples
```sql
-- Find sessions mentioning "error"
SELECT session_key, date, content FROM sessions_fts WHERE content LIKE '%error%';

-- Find sessions by date
SELECT * FROM sessions_fts WHERE date = '2026-04-21';

-- Find by session key
SELECT * FROM sessions_fts WHERE session_key LIKE '%a65feb37%';
```

## Re-indexing
Run via cron or manually:
```bash
node << 'EOF'
// (use the indexer script above)
EOF
```

## Limitations
- FTS5 not available (sql.js limitation)
- Search uses LIKE (case-sensitive)
- Only cron run logs currently indexed (no full conversation history)
