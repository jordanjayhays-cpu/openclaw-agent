#!/bin/bash
# MULTI-LAYER SPAWN — Recursive agent spawning (L0→L1→L2→L3)
# Each layer spawns the next, demonstrating agent spawning agent
# Usage: bash tools/multi_layer_spawn.sh [PROJECT] [DEPTH]

cd /data/workspace

echo "=== MULTI-LAYER SPAWN ==="
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Project: ${1:-test-project}"
echo "Max Depth: ${2:-3}"
echo ""

PROJECT=${1:-test-project}
MAX_DEPTH=${2:-3}
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Create shared checkpoint directory
CHECKPOINT_DIR="TEAM/$PROJECT/checkpoints"
mkdir -p "$CHECKPOINT_DIR"

# Initialize checkpoint file
cat > "$CHECKPOINT_DIR/depth.yaml" << EOF
project: $PROJECT
max_depth: $MAX_DEPTH
current_depth: 0
spawn_chain: []
created: $(date '+%Y-%m-%dT%H:%M:%SZ')
status: initializing
EOF

echo "Checkpoint initialized at $CHECKPOINT_DIR/depth.yaml"
echo ""

# =====================================================================
# LAYER 0: The entry point (this script acts as L0, spawns L1)
# =====================================================================
echo "[L0] I am the supreme agent. Spawning L1..."
echo ""

cat > "$CHECKPOINT_DIR/l0-status.md" << EOF
# L0 Checkpoint — Supreme Agent (Axton)

**Time:** $(date '+%Y-%m-%d %H:%M:%S')
**Project:** $PROJECT
**Max Depth:** $MAX_DEPTH
**Status:** Spawning L1

## Current Action
L0 spawning L1 (Project Lead agent)

## Chain
- L0: This script (spawner)
- L1: Project Lead (spawning...)
- L2: TBD
- L3: TBD

## Notes
L0 has full context. Spawning L1 with full project knowledge.
EOF

# =====================================================================
# L1: Project Lead Agent
# =====================================================================
echo "[L1] Spawning Project Lead agent..."

L1_MSG="You are L1 — PROJECT LEAD agent for '$PROJECT'.

HIERARCHY:
- L0: Supreme (spawned you)
- L1: You (Project Lead)
- L2: Specialists (you will spawn)
- L3: Workers (L2 will spawn)

YOUR JOB:
1. Read $CHECKPOINT_DIR/depth.yaml
2. Understand the project context
3. Spawn L2 specialists to handle work
4. Monitor L2 progress
5. Report back to L0

You have PERMISSION TO SPAWN L2 agents.

TASK: Manage the $PROJECT project by spawning appropriate L2 specialists.

Checkpoints: $CHECKPOINT_DIR/l1-status.md
State file: $CHECKPOINT_DIR/depth.yaml

When done, update:
- $CHECKPOINT_DIR/l1-status.md (complete)
- $CHECKPOINT_DIR/depth.yaml (current_depth: 1)
"

openclaw session spawn \
  --name "L1-$PROJECT-$TIMESTAMP" \
  --label "L1-project-lead" \
  --cwd /data/workspace \
  --message "$L1_MSG" \
  --timeout-seconds 2400 \
  --no-deliver \
  2>&1 &

L1_PID=$!
echo "L1 spawned (PID: $L1_PID)"
echo ""

# Update checkpoint
cat > "$CHECKPOINT_DIR/l1-status.md" << EOF
# L1 Checkpoint — Project Lead

**Time:** $(date '+%Y-%m-%d %H:%M:%S')
**PID:** $L1_PID
**Status:** Running

## Hierarchy
- L0: Supreme agent
- L1: This agent (spawning L2)
- L2: Specialists (to be spawned)
- L3: Workers (L2 will spawn)

## Permissions
- Can spawn: L2 agents
- Cannot spawn: L0 or L1

## Next Action
Spawn L2 specialists based on project needs.
EOF

# Wait for L1 to do its work (it will spawn L2 internally)
echo "Waiting for L1 to spawn L2 agents..."
wait $L1_PID
L1_EXIT=$?

echo ""
echo "[L1] Project Lead completed (exit: $L1_EXIT)"
echo ""

# =====================================================================
# Report final status
# =====================================================================
echo "=== MULTI-LAYER SPAWN COMPLETE ==="
echo ""
echo "Checkpoint directory: $CHECKPOINT_DIR"
echo ""
echo "Chain status:"

for level in l0 l1 l2 l3; do
    if [ -f "$CHECKPOINT_DIR/${level}-status.md" ]; then
        STATUS=$(grep "Status:" "$CHECKPOINT_DIR/${level}-status.md" 2>/dev/null || echo "unknown")
        echo "  $level: $STATUS"
    fi
done

echo ""
echo "Current depth achieved: $(grep 'current_depth:' $CHECKPOINT_DIR/depth.yaml 2>/dev/null || echo '0')"
echo ""
echo "=== DONE ==="