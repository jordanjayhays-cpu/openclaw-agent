#!/bin/bash
# Second Brain CLI - Query Jordan's semantic memory
# Usage: ./second_brain.sh [command] [args]

DB_PATH="PROJECTS/second-brain/second-brain.db"

case "${1:-search}" in
    search)
        if [ -z "$2" ]; then
            echo "Usage: $0 search <query>"
            exit 1
        fi
        python3 << PYEOF
import sqlite3
import sys
conn = sqlite3.connect('$DB_PATH')
c = conn.cursor()
query = '%' + ' '.join(sys.argv[2:]) + '%'
c.execute('''SELECT id, category, tags, substr(content, 1, 200), created_at 
             FROM memories WHERE content LIKE ? ORDER BY access_count DESC LIMIT 10''', (query,))
for row in c.fetchall():
    print(f"[{row[0]}] {row[1]} | {row[2]} | {row[4]}")
    print(f"   {row[3]}...")
    print()
conn.close()
PYEOF
        ;;

    add)
        shift
        CONTENT="$1"
        CATEGORY="${2:-general}"
        TAGS="${3:-}"
        python3 << PYEOF
import sqlite3
conn = sqlite3.connect('$DB_PATH')
c = conn.cursor()
c.execute('INSERT INTO memories (content, category, tags) VALUES (?, ?, ?)',
          ('''$CONTENT''', '$CATEGORY', '$TAGS'))
conn.commit()
print(f"Added memory with ID: {c.lastrowid}")
conn.close()
PYEOF
        ;;

    tags)
        python3 << PYEOF
import sqlite3
conn = sqlite3.connect('$DB_PATH')
c = conn.cursor()
c.execute('SELECT name, color FROM tags ORDER BY name')
for row in c.fetchall():
    print(f"{row[1]} {row[0]}")
conn.close()
PYEOF
        ;;

    stats)
        python3 << PYEOF
import sqlite3
conn = sqlite3.connect('$DB_PATH')
c = conn.cursor()
c.execute('SELECT COUNT(*) FROM memories')
total = c.fetchone()[0]
c.execute('SELECT category, COUNT(*) FROM memories GROUP BY category')
cats = c.fetchall()
c.execute('SELECT COUNT(*) FROM connections')
conns = c.fetchone()[0]
print(f"Total memories: {total}")
print(f"Connections: {conns}")
print("\nBy category:")
for cat, cnt in cats:
    print(f"  {cat}: {cnt}")
conn.close()
PYEOF
        ;;

    connect)
        python3 << PYEOF
import sqlite3
conn = sqlite3.connect('$DB_PATH')
c = conn.cursor()
c.execute('INSERT INTO connections (memory_id_1, memory_id_2) VALUES (?, ?)',
          (int('$2'), int('$3')))
conn.commit()
print(f"Connected memory $2 <-> $3")
conn.close()
PYEOF
        ;;

    recall)
        python3 << PYEOF
import sqlite3
conn = sqlite3.connect('$DB_PATH')
c = conn.cursor()
c.execute('UPDATE memories SET access_count = access_count + 1, accessed_at = CURRENT_TIMESTAMP WHERE id = ?', (int('$2'),))
conn.commit()
c.execute('SELECT content, category, tags FROM memories WHERE id = ?', (int('$2'),))
row = c.fetchone()
if row:
    print(f"[{row[1]}] {row[2]}")
    print(row[0])
conn.close()
PYEOF
        ;;

    *)
        echo "Second Brain CLI"
        echo "Commands: search, add, tags, stats, connect, recall"
        ;;
esac
