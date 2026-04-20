const initSqlJs = require('sql.js');
const fs = require('fs');
const path = require('path');
const readline = require('readline');

const SESSIONS_DIR = '/home/openclaw/.openclaw/agents/main/sessions/';
const CRON_DIR = '/home/openclaw/.openclaw/cron/runs/';
const DB_PATH = '/home/openclaw/.openclaw/workspace/memory/sessions.db';
const OUTPUT_DIR = '/home/openclaw/.openclaw/workspace/startup-machine/';

fs.mkdirSync(OUTPUT_DIR, { recursive: true });

function extractText(line) {
  try {
    const obj = JSON.parse(line);
    let texts = [];

    // message.content[].text structure (OpenClaw session format)
    if (obj.message && obj.message.content && Array.isArray(obj.message.content)) {
      for (const block of obj.message.content) {
        if (block.text) texts.push(block.text);
      }
    }
    // Direct text field
    if (obj.text) texts.push(obj.text);
    // Direct content field (string)
    if (typeof obj.content === 'string') texts.push(obj.content);
    // message.content as string
    if (typeof obj.message === 'string') texts.push(obj.message);
    // Fallback: stringify content arrays
    if (obj.content && typeof obj.content === 'object') {
      try { texts.push(JSON.stringify(obj.content)); } catch(e) {}
    }

    return texts.join(' ');
  } catch (e) {
    return '';
  }
}

async function processFile(filePath) {
  const parts = [];
  const fileStream = fs.createReadStream(filePath, { encoding: 'utf8' });
  const rl = readline.createInterface({ input: fileStream });
  for await (const line of rl) {
    const text = extractText(line);
    if (text) parts.push(text);
  }
  return parts.join(' ').substring(0, 50000);
}

async function main() {
  const SQL = await initSqlJs();
  const db = new SQL.Database();

  db.run(`CREATE TABLE IF NOT EXISTS sessions_fts (
    session_key TEXT PRIMARY KEY,
    date TEXT,
    content TEXT
  );`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_date ON sessions_fts(date);`);

  const sessionFiles = fs.readdirSync(SESSIONS_DIR).filter(f => f.endsWith('.jsonl'));
  let count = 0;

  for (const file of sessionFiles) {
    const sessionKey = file.replace('.jsonl', '');
    const fullPath = path.join(SESSIONS_DIR, file);
    const stats = fs.statSync(fullPath);
    const date = new Date(stats.mtime).toISOString().split('T')[0];
    const content = await processFile(fullPath);
    if (content.trim()) {
      db.run(`INSERT OR REPLACE INTO sessions_fts(session_key, date, content) VALUES (?, ?, ?);`,
        [sessionKey, date, content]);
      count++;
    }
  }

  const cronFiles = fs.readdirSync(CRON_DIR).filter(f => f.endsWith('.jsonl'));
  for (const file of cronFiles) {
    const sessionKey = 'cron-' + file.replace('.jsonl', '');
    const fullPath = path.join(CRON_DIR, file);
    const stats = fs.statSync(fullPath);
    const date = new Date(stats.mtime).toISOString().split('T')[0];
    const content = await processFile(fullPath);
    if (content.trim()) {
      db.run(`INSERT OR REPLACE INTO sessions_fts(session_key, date, content) VALUES (?, ?, ?);`,
        [sessionKey, date, content]);
      count++;
    }
  }

  const data = db.export();
  fs.writeFileSync(DB_PATH, Buffer.from(data));

  const doc = `# Session Search Index

## Table Schema
\`\`\`sql
CREATE TABLE sessions_fts (
  session_key TEXT PRIMARY KEY,  -- UUID of the session (cron sessions prefixed with "cron-")
  date TEXT,                      -- ISO date (YYYY-MM-DD) of last modification
  content TEXT                    -- All text extracted from the session JSONL
);
CREATE INDEX idx_date ON sessions_fts(date);
\`\`\`

## DB Location
\`\`\`
/home/openclaw/.openclaw/workspace/memory/sessions.db
\`\`\`

## Search Query Examples

### Basic keyword search (LIKE)
\`\`\`js
const results = db.exec(\`
  SELECT session_key, date, substr(content, 1, 200) as preview
  FROM sessions_fts
  WHERE content LIKE '%keyword%'
  ORDER BY date DESC
  LIMIT 20;
\`);
\`\`\`

### Search by session key prefix
\`\`\`js
const results = db.exec(\`
  SELECT session_key, date FROM sessions_fts
  WHERE session_key LIKE 'a6a6070d%'
  LIMIT 5;
\`\`\`

### Recent sessions
\`\`\`js
const results = db.exec(\`
  SELECT session_key, date FROM sessions_fts
  ORDER BY date DESC LIMIT 10;
\`\`\`

### Full-text match helper (multi-word OR)
\`\`\`js
function search(db, terms) {
  const where = terms.map(t => \`content LIKE '%\${t}%'\`).join(' OR ');
  return db.exec(\`SELECT session_key, date, substr(content,1,200) FROM sessions_fts WHERE \${where} ORDER BY date DESC\`);
}
\`\`\`

## Notes
- Database is rebuilt on each run (INSERT OR REPLACE). Re-run the indexer to refresh.
- Content extracted from \`message.content[].text\` fields in JSONL.
- sql.js does not support FTS5 — this uses LIKE-based search which works reliably.
- Total sessions indexed: ${count}
`;
  fs.writeFileSync(path.join(OUTPUT_DIR, 'SESSION-SEARCH.md'), doc);

  console.log(`Indexed ${count} sessions`);
  console.log('Doc written to', path.join(OUTPUT_DIR, 'SESSION-SEARCH.md'));
}

main().catch(console.error);
