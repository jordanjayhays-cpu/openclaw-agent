#!/bin/bash
# AGENT OVERSEER — Monitor worker agents, restart if needed
# One agent watches others and ensures tasks complete
# Usage: bash tools/agent_overseer.sh [PROJECT] [WORKER_COUNT]

cd /data/workspace

echo "=== AGENT OVERSEER ==="
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

PROJECT=${1:-default}
WORKER_COUNT=${2:-3}
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

OVERSEER_DIR="TEAM/$PROJECT/overseer"
mkdir -p "$OVERSEER_DIR"

# Initialize overseer state
cat > "$OVERSEER_DIR/state.yaml" << EOF
overseer: $PROJECT-overseer
created: $(date '+%Y-%m-%dT%H:%M:%SZ')
project: $PROJECT
worker_count: $WORKER_COUNT
status: initializing
workers: []
completed: []
failed: []
restart_count: 0
EOF

echo "Overseer initialized for $PROJECT with $WORKER_COUNT workers"
echo ""

# =====================================================================
# Spawn workers
# =====================================================================
echo "[1/4] Spawning $WORKER_COUNT worker agents..."

WORKER_TYPES=("RESEARCHER" "ANALYST" "BUILDER")
PIDS=()

for i in $(seq 1 $WORKER_COUNT); do
    WORKER_TYPE=${WORKER_TYPES[$((i % 3))]}
    WORKER_NAME="worker-${i}-$TIMESTAMP"

    echo "  Spawning worker-$i ($WORKER_TYPE)..."

    WORKER_MSG="You are WORKER-$i of $WORKER_COUNT for project '$PROJECT'.
You are a $WORKER_TYPE agent.

YOUR TASK:
1. Read $OVERSEER_DIR/state.yaml to see all workers
2. Pick an available task from $OVERSEER_DIR/tasks/
3. Execute the task
4. Write results to $OVERSEER_DIR/results/worker-${i}.md
5. Update $OVERSEER_DIR/state.yaml (mark task complete)

HEARTBEAT: Write to $OVERSEER_DIR/heartbeat-worker-${i}.txt every 60 seconds
Format: timestamp:PID:status

If you fail, write to $OVERSEER_DIR/failed/worker-${i}.md with error details.

Report to overseer on completion.
"

    openclaw session spawn \
      --name "$WORKER_NAME" \
      --label "worker-$i" \
      --cwd /data/workspace \
      --message "$WORKER_MSG" \
      --timeout-seconds 1800 \
      --no-deliver \
      2>&1 &

    PID=$!
    PIDS+=($PID)

    # Register worker
    cat >> "$OVERSEER_DIR/state.yaml" << EOF

- name: worker-$i
  type: $WORKER_TYPE
  pid: $PID
  status: running
  started: $(date '+%Y-%m-%dT%H:%M:%SZ')
EOF

done

echo ""
echo "Workers spawned: ${#PIDS[@]}"
echo ""

# =====================================================================
# Create sample tasks
# =====================================================================
echo "[2/4] Creating tasks..."

mkdir -p "$OVERSEER_DIR/tasks"
mkdir -p "$OVERSEER_DIR/results"
mkdir -p "$OVERSEER_DIR/failed"

cat > "$OVERSEER_DIR/tasks/task-1.yaml" << EOF
# Task 1
name: task-1
description: Research market trends for $PROJECT
priority: high
assignee: worker-1
status: pending
EOF

cat > "$OVERSEER_DIR/tasks/task-2.yaml" << EOF
# Task 2
name: task-2
description: Analyze competitor data
priority: high
assignee: worker-2
status: pending
EOF

cat > "$OVERSEER_DIR/tasks/task-3.yaml" << EOF
# Task 3
name: task-3
description: Build initial prototype
priority: medium
assignee: worker-3
status: pending
EOF

echo "  Created 3 sample tasks"
echo ""

# =====================================================================
# Monitor loop
# =====================================================================
echo "[3/4] Starting monitor loop..."
echo ""

MONITOR_INTERVAL=30
MAX_RESTARTS=3
ELAPSED=0

while [ $ELAPSED -lt 300 ]; do
    echo "--- Monitor check (${ELAPSED}s) ---"

    # Check each worker
    for i in $(seq 1 $WORKER_COUNT); do
        HEARTBEAT_FILE="$OVERSEER_DIR/heartbeat-worker-${i}.txt"
        WORKER_PID=${PIDS[$((i-1))]}

        if [ -f "$HEARTBEAT_FILE" ]; then
            LAST_HEARTBEAT=$(cat "$HEARTBEAT_FILE" 2>/dev/null | head -1)
            AGE=$(echo "$LAST_HEARTBEAT" | cut -d: -f1 2>/dev/null || echo "0")

            if [ -n "$AGE" ]; then
                LAST_TIME=$(date +%s)
                HB_TIME=$(date -d "$AGE" +%s 2>/dev/null || echo $LAST_TIME)
                STALE=$((LAST_TIME - HB_TIME))

                if [ $STALE -gt 120 ]; then
                    echo "  ⚠ Worker-$i stale (${STALE}s since heartbeat)"

                    # Check if process still running
                    if ! kill -0 $WORKER_PID 2>/dev/null; then
                        echo "  ✗ Worker-$i dead (PID $WORKER_PID)"
                        RESTART_COUNT=$(grep "restart_count:" "$OVERSEER_DIR/state.yaml" | grep -o "[0-9]*" || echo "0")

                        if [ "$RESTART_COUNT" -lt "$MAX_RESTARTS" ]; then
                            echo "  → Restarting worker-$i..."

                            # Restart worker
                            openclaw session spawn \
                              --name "worker-${i}-restart-${TIMESTAMP}" \
                              --label "worker-$i-restart" \
                              --cwd /data/workspace \
                              --message "You are WORKER-$i (restarted). Continue task execution." \
                              --timeout-seconds 1800 \
                              --no-deliver \
                              2>&1 &

                            NEW_PID=$!

                            # Update state
                            sed -i "s/pid: $WORKER_PID/pid: $NEW_PID/" "$OVERSEER_DIR/state.yaml"
                            sed -i "s/restart_count:.*/restart_count: $((RESTART_COUNT+1))/" "$OVERSEER_DIR/state.yaml"

                            PIDS[$((i-1))]=$NEW_PID
                            echo "  ✓ Restarted (new PID: $NEW_PID)"
                        else
                            echo "  ✗ Max restarts reached for worker-$i"
                            sed -i "s/status: running/status: failed_max_restarts/" "$OVERSEER_DIR/state.yaml"
                        fi
                    fi
                else
                    echo "  ✓ Worker-$i healthy"
                fi
            fi
        else
            echo "  ? Worker-$i no heartbeat yet"
        fi
    done

    # Check for completed tasks
    COMPLETED=0
    for f in "$OVERSEER_DIR/results/worker-"*.md; do
        if [ -f "$f" ]; then
            COMPLETED=$((COMPLETED + 1))
        fi
    done

    echo "  Progress: $COMPLETED/$WORKER_COUNT tasks completed"
    echo ""

    # Break if all done
    if [ $COMPLETED -eq $WORKER_COUNT ]; then
        echo "All workers completed!"
        break
    fi

    sleep $MONITOR_INTERVAL
    ELAPSED=$((ELAPSED + MONITOR_INTERVAL))
done

# =====================================================================
# Final report
# =====================================================================
echo ""
echo "[4/4] Final report..."
echo ""

echo "=== OVERSEER REPORT ==="
echo "Project: $PROJECT"
echo "Workers: $WORKER_COUNT"
echo ""

# Count results
RESULTS=$(ls "$OVERSEER_DIR/results/"*.md 2>/dev/null | wc -l || echo "0")
FAILED=$(ls "$OVERSEER_DIR/failed/"*.md 2>/dev/null | wc -l || echo "0")

echo "Completed: $RESULTS"
echo "Failed: $FAILED"
echo ""

if [ "$RESULTS" -gt 0 ]; then
    echo "Results:"
    for f in "$OVERSEER_DIR/results/"*.md; do
        if [ -f "$f" ]; then
            WORKER=$(basename "$f" .md)
            echo "  - $WORKER"
        fi
    done
    echo ""
fi

if [ "$FAILED" -gt 0 ]; then
    echo "Failed workers:"
    for f in "$OVERSEER_DIR/failed/"*.md; do
        if [ -f "$f" ]; then
            echo "---"
            cat "$f"
        fi
    done
    echo ""
fi

# Update final state
cat > "$OVERSEER_DIR/state.yaml" << EOF
overseer: $PROJECT-overseer
final_report: true
project: $PROJECT
completed: $RESULTS
failed: $FAILED
elapsed_seconds: $ELAPSED
finalized: $(date '+%Y-%m-%dT%H:%M:%SZ')
EOF

echo "=== OVERSEER COMPLETE ==="
echo "State: $OVERSEER_DIR/state.yaml"
echo "Results: $OVERSEER_DIR/results/"