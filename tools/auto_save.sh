#!/bin/bash
# Auto-save workspace to GitHub
# Commits significant changes, pushes to remote
# Run via cron or heartbeat

WORKSPACE="/home/openclaw/.openclaw/workspace"
cd "$WORKSPACE" || exit 1

BOT_TOKEN="8768116245:AAG1kj2x8kQU25U2wXehMxzTpWPls-sXlzA"
CHAT_ID="6463127078"

# Check for changes
if git diff --quiet 2>/dev/null && git status --porcelain | grep -q "^??.*modified"; then
    echo "No significant changes to commit"
    exit 0
fi

# Add all changes
git add -A

# Commit with timestamp
COMMIT_MSG="Auto-save: $(date '+%Y-%m-%d %H:%M UTC')"
git commit -m "$COMMIT_MSG" 2>/dev/null

# Push to GitHub
PUSH_RESULT=$(git push origin main 2>&1)
PUSH_OK=$?

if [ $PUSH_OK -eq 0 ]; then
    echo "[$(date)] Pushed to GitHub successfully"
else
    echo "[$(date)] GitHub push failed: $PUSH_RESULT"
    # Send warning to Telegram
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
      -d "chat_id=$CHAT_ID&text=⚠️ GitHub sync failed. Check workspace." \
      2>/dev/null
fi

# Also update workspace file listing for dashboard
ls -la "$WORKSPACE" | head -20 > "$WORKSPACE/.workspace-snapshot.txt"
git add "$WORKSPACE/.workspace-snapshot.txt" 2>/dev/null
git commit -m "Workspace snapshot $(date '+%Y-%m-%d')" 2>/dev/null
git push origin main 2>/dev/null

exit 0