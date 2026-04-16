#!/bin/bash
# SELF-HEAL — Detect and fix common failures automatically
# Runs on cron every 15 minutes

cd /data/workspace

echo "=== SELF-HEAL ==="
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

FAILURES=0
FIXES=0

# Check 1: Failed crons
echo "Checking failed crons..."
FAILED_CRONS=$(openclaw cron list 2>&1 | grep "error" | wc -l)
if [ "$FAILED_CRONS" -gt 0 ]; then
    echo "⚠️ $FAILED_CRONS failed cron(s) detected"
    # Re-run failed crons
    openclaw cron list 2>&1 | grep " error " | while read line; do
        JOB_ID=$(echo "$line" | awk '{print $1}')
        JOB_NAME=$(echo "$line" | awk '{print $2, $3}')
        echo "Restarting: $JOB_NAME ($JOB_ID)"
        openclaw cron run "$JOB_ID" 2>&1
        if [ $? -eq 0 ]; then
            echo "✓ $JOB_NAME restarted"
        else
            echo "✗ $JOB_NAME restart failed"
        fi
    done
    ((FAILURES++))
fi

# Check 2: Git sync issues
echo ""
echo "Checking git status..."
cd /data/workspace
git status --porcelain > /tmp/git_status.txt
if [ -s /tmp/git_status.txt ]; then
    echo "⚠️ Uncommitted changes. Committing..."
    git add -A
    git commit -m "Auto-save: $(date '+%Y-%m-%d %H:%M')" 2>&1
    git push origin master 2>&1
    ((FAILURES++))
    ((FIXES++))
fi

# Check 3: Memory files
echo ""
echo "Checking memory..."
if [ ! -f "MEMORY.md" ]; then
    echo "⚠️ MEMORY.md missing. Creating..."
    touch MEMORY.md
    ((FAILURES++))
fi

# Check 4: CRM accessibility
echo ""
echo "Checking CRM..."
if [ ! -f "crm.db" ]; then
    echo "⚠️ CRM missing. Creating..."
    # Recreate CRM
    sqlite3 crm.db "CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY, name TEXT, company TEXT, linkedin TEXT, email TEXT, phone TEXT, project TEXT, warmth TEXT, first_contact TEXT, last_contact TEXT, interaction_count INTEGER DEFAULT 0, notes TEXT);"
    ((FAILURES++))
fi

# Check 5: Subagent status
echo ""
echo "Checking subagents..."
STALE=$(openclaw sessions list 2>&1 | grep -c "stale\|hung\|error" || echo 0)
if [ "$STALE" -gt 0 ]; then
    echo "⚠️ $STALE stale session(s)"
    # Kill stale sessions
    openclaw sessions list 2>&1 | grep "stale" | while read line; do
        SESSION_KEY=$(echo "$line" | awk '{print $1}')
        openclaw session kill "$SESSION_KEY" 2>&1
    done
    ((FAILURES++))
    ((FIXES++))
fi

# Check 6: Disk space
echo ""
echo "Checking disk..."
DISK_USAGE=$(df /data/workspace | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "⚠️ Disk at $DISK_USAGE%. Consider cleanup."
    ((FAILURES++))
fi

# Check 7: Heartbeat state
echo ""
echo "Checking heartbeat state..."
if [ ! -f "memory/heartbeat-state.json" ]; then
    echo "Creating heartbeat state..."
    mkdir -p memory
    echo '{"lastChecks": {}, "lastFull": null}' > memory/heartbeat-state.json
fi

# Log results
echo ""
echo "=== SELF-HEAL REPORT ==="
echo "Failures detected: $FAILURES"
echo "Auto-fixes applied: $FIXES"
echo ""

# Log to failure log if issues found
if [ "$FAILURES" -gt 0 ]; then
    echo "---" >> PROJECTS/EXPERIMENTS/failure-log.md
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Self-heal ran. Failures: $FAILURES, Fixes: $FIXES" >> PROJECTS/EXPERIMENTS/failure-log.md
fi

echo "=== SELF-HEAL COMPLETE ==="
