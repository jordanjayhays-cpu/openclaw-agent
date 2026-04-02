#!/bin/bash
# BATCH SPAWN — Spawn multiple agents in parallel
# Usage: bash tools/batch_spawn.sh [task1] [task2] [task3]...

cd /data/workspace

echo "=== BATCH SPAWN ==="
echo "Tasks: $#"
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

TASKS=("$@")
PIDS=()

for i in "${!TASKS[@]}"; do
    TASK="${TASKS[$i]}"
    LABEL="batch-$i-$(date +%s)"
    
    echo "Spawning [$i]: $TASK"
    
    openclaw session spawn \
      --name "$LABEL" \
      --label "$LABEL" \
      --cwd /data/workspace \
      --message "$TASK" \
      --timeout-seconds 3600 \
      --no-deliver \
      2>&1 &
    
    PIDS+=($!)
done

echo ""
echo "=== ALL SPAWNED ==="
echo "Waiting for completions..."

for pid in "${PIDS[@]}"; do
    wait $pid
done

echo ""
echo "=== BATCH COMPLETE ==="
echo "All $# tasks spawned and running."
