#!/bin/bash
# FAST SPAWN — Spawn agents with minimal overhead
# Usage: bash tools/fast_spawn.sh [label] [message] [runtime]

cd /data/workspace

LABEL=$1
MESSAGE=$2
RUNTIME=${3:-1800}

if [ -z "$LABEL" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: fast_spawn.sh [label] [message] [runtime_seconds]"
    exit 1
fi

echo "=== FAST SPAWN ==="
echo "Label: $LABEL"
echo "Runtime: $RUNTIME seconds"
echo ""

openclaw session spawn \
  --name "$LABEL" \
  --label "$LABEL" \
  --cwd /data/workspace \
  --message "$MESSAGE" \
  --timeout-seconds $RUNTIME \
  --no-deliver \
  2>&1

echo ""
echo "Spawned: $LABEL"
