# Session Search Index

## Table Schema
```sql
CREATE TABLE sessions_fts (
  session_key TEXT PRIMARY KEY,  -- UUID of the session (cron sessions prefixed with "cron-")
  date TEXT,                      -- ISO date (YYYY-MM-DD) of last modification
  content TEXT                    -- All text extracted from the session JSONL
);
CREATE INDEX idx_date ON sessions_fts(date);
```

## DB Location
```
/home/openclaw/.openclaw/workspace/memory/sessions.db
```

## Search Query Examples

### Basic keyword search (LIKE)
```js
const results = db.exec(`
  SELECT session_key, date, substr(content, 1, 200) as preview
  FROM sessions_fts
  WHERE content LIKE '%keyword%'
  ORDER BY date DESC
  LIMIT 20;
`);
```

### Search by session key prefix
```js
const results = db.exec(`
  SELECT session_key, date FROM sessions_fts
  WHERE session_key LIKE 'a6a6070d%'
  LIMIT 5;
```

### Recent sessions
```js
const results = db.exec(`
  SELECT session_key, date FROM sessions_fts
  ORDER BY date DESC LIMIT 10;
```

### Full-text match helper (multi-word OR)
```js
function search(db, terms) {
  const where = terms.map(t => `content LIKE '%${t}%'`).join(' OR ');
  return db.exec(`SELECT session_key, date, substr(content,1,200) FROM sessions_fts WHERE ${where} ORDER BY date DESC`);
}
```

## Notes
- Database is rebuilt on each run (INSERT OR REPLACE). Re-run the indexer to refresh.
- Content extracted from `message.content[].text` fields in JSONL.
- sql.js does not support FTS5 — this uses LIKE-based search which works reliably.
- Total sessions indexed: 36
