# Session Search Index

**Built:** 2026-04-16  
**Sessions indexed:** 30

## Schema

```json
{
  "schema": "sessions_fts_v1",
  "built": "2026-04-16T21:00:00.000Z",
  "count": 30,
  "fields": ["session_key", "date", "content", "tokens"],
  "entries": [
    {
      "session_key": "uuid-string",
      "date": "YYYY-MM-DD",
      "content": "full text of session, truncated at 50k chars",
      "tokens": ["word1", "word2", ...]
    }
  ]
}
```

## Storage

- **File:** `/home/openclaw/.openclaw/workspace/memory/sessions-search.json`
- **Size:** ~2MB (30 sessions with content + tokens)

## Usage

Search is done in-memory with JavaScript (FTS5/SQLite not available in this environment).

```javascript
const idx = JSON.parse(fs.readFileSync(
  '/home/openclaw/.openclaw/workspace/memory/sessions-search.json',
  'utf8'
));

// Search by keyword in content
const results = idx.entries.filter(e => 
  e.content.toLowerCase().includes('your-query')
);

// Search by token (fast prefix match)
const byToken = idx.entries.filter(e => 
  e.tokens.includes('keyword')
);

// Fuzzy match
const fuzzy = idx.entries.filter(e =>
  e.tokens.some(t => t.includes('partial'))
);
```

## Search Examples

| Query | Method |
|-------|--------|
| Exact phrase | `e.content.includes('phrase')` |
| Any word | `e.tokens.includes('word')` |
| Prefix match | `e.tokens.some(t => t.startsWith('pre'))` |
| Date range | `e.date >= '2026-04-01' && e.date <= '2026-04-16'` |

## Rebuild Index

```bash
node /tmp/index-sessions.js
```

This script reads all `.jsonl` files from `~/.openclaw/agents/main/sessions/`, extracts text content and tokens, and writes to `sessions-search.json`.

## Notes

- FTS5 (SQLite full-text search) was not available — used JSON token index instead
- Content truncated at 50,000 chars per session
- Tokens extracted from content (lowercased, >2 chars, deduped, max 500)
- Re-index daily via cron job