#!/bin/bash
# AGENT TEAM — Spawn 3 specialized agents that work together
# RESEARCHER → ANALYST → EXECUTOR pipeline
# Usage: bash tools/agent_team.sh [PROJECT] [TASK]

cd /data/workspace

echo "=== AGENT TEAM ==="
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Project: ${1:-default}"
echo "Task: ${2:-Research and analyze market opportunity}"
echo ""

PROJECT=${1:-default}
TASK=${2:-Research and analyze market opportunity}
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Create shared memory directory
SHARED_DIR="TEAM/$PROJECT/shared"
mkdir -p "$SHARED_DIR"

# Initialize shared state
cat > "$SHARED_DIR/state.yaml" << EOF
project: $PROJECT
team_leader: agent-team-$TIMESTAMP
created: $(date '+%Y-%m-%dT%H:%M:%SZ')
status: initializing
pipeline:
  researcher: pending
  analyst: pending
  executor: pending
results: {}
errors: []
EOF

echo "Shared state initialized at $SHARED_DIR/state.yaml"
echo ""

# =====================================================================
# STEP 1: Spawn RESEARCHER agent
# =====================================================================
echo "[1/3] Spawning RESEARCHER agent..."

RESEARCHER_MSG="You are a RESEARCHER agent specialized in finding information.

PROJECT: $PROJECT
TASK: $TASK
OUTPUT_DIR: $SHARED_DIR

Your job:
1. Read $SHARED_DIR/state.yaml to understand context
2. Research the task thoroughly (web search + fetch)
3. Synthesize findings into $SHARED_DIR/researcher-findings.md
4. Update $SHARED_DIR/state.yaml with your status
5. Report completion

Write your output in Jordan's voice: short, direct, actionable.
Always cite sources.

Mark complete by updating state.yaml:
  pipeline:
    researcher: completed
  results:
    researcher_output: $SHARED_DIR/researcher-findings.md
"

openclaw session spawn \
  --name "researcher-$PROJECT-$TIMESTAMP" \
  --label "researcher-$PROJECT" \
  --cwd /data/workspace \
  --message "$RESEARCHER_MSG" \
  --timeout-seconds 1800 \
  --no-deliver \
  2>&1 &

RESEARCHER_PID=$!
echo "RESEARCHER spawned (PID: $RESEARCHER_PID)"

# Update state
cat > "$SHARED_DIR/state.yaml" << EOF
project: $PROJECT
team_leader: agent-team-$TIMESTAMP
created: $(date '+%Y-%m-%dT%H:%M:%SZ')
status: running
pipeline:
  researcher: running
  analyst: pending
  executor: pending
results: {}
pids:
  researcher: $RESEARCHER_PID
errors: []
EOF

echo "Waiting for RESEARCHER to complete..."
wait $RESEARCHER_PID
RESEARCHER_EXIT=$?

if [ $RESEARCHER_EXIT -eq 0 ]; then
    echo "✓ RESEARCHER completed"
    # Mark as done
    sed -i 's/researcher: running/researcher: completed/' "$SHARED_DIR/state.yaml" 2>/dev/null || true
else
    echo "✗ RESEARCHER failed (exit: $RESEARCHER_EXIT)"
    echo "researcher: failed" >> "$SHARED_DIR/state.yaml"
fi

echo ""

# =====================================================================
# STEP 2: Spawn ANALYST agent (after researcher)
# =====================================================================
echo "[2/3] Spawning ANALYST agent..."

ANALYST_MSG="You are an ANALYST agent specialized in processing data and making recommendations.

PROJECT: $PROJECT
INPUT: Read $SHARED_DIR/researcher-findings.md (from RESEARCHER)
OUTPUT_DIR: $SHARED_DIR

Your job:
1. Read $SHARED_DIR/state.yaml to check if RESEARCHER completed
2. Read $SHARED_DIR/researcher-findings.md
3. Analyze the findings for patterns, opportunities, risks
4. Create $SHARED_DIR/analyst-recommendations.md with:
   - Key insights (top 3)
   - Recommended actions (top 3)
   - Risk factors
   - Next steps
5. Update $SHARED_DIR/state.yaml with your status

Format: Short bullets, Jordan's voice.
Mark complete by updating state.yaml:
  pipeline:
    analyst: completed
  results:
    analyst_output: $SHARED_DIR/analyst-recommendations.md
"

openclaw session spawn \
  --name "analyst-$PROJECT-$TIMESTAMP" \
  --label "analyst-$PROJECT" \
  --cwd /data/workspace \
  --message "$ANALYST_MSG" \
  --timeout-seconds 1200 \
  --no-deliver \
  2>&1 &

ANALYST_PID=$!
echo "ANALYST spawned (PID: $ANALYST_PID)"

# Update state
cat > "$SHARED_DIR/state.yaml" << EOF
project: $PROJECT
team_leader: agent-team-$TIMESTAMP
created: $(date '+%Y-%m-%dT%H:%M:%SZ')
status: running
pipeline:
  researcher: completed
  analyst: running
  executor: pending
results:
  researcher_output: $SHARED_DIR/researcher-findings.md
pids:
  analyst: $ANALYST_PID
errors: []
EOF

echo "Waiting for ANALYST to complete..."
wait $ANALYST_PID
ANALYST_EXIT=$?

if [ $ANALYST_EXIT -eq 0 ]; then
    echo "✓ ANALYST completed"
    sed -i 's/analyst: running/analyst: completed/' "$SHARED_DIR/state.yaml" 2>/dev/null || true
else
    echo "✗ ANALYST failed (exit: $ANALYST_EXIT)"
fi

echo ""

# =====================================================================
# STEP 3: Spawn EXECUTOR agent (after analyst)
# =====================================================================
echo "[3/3] Spawning EXECUTOR agent..."

EXECUTOR_MSG="You are an EXECUTOR agent specialized in taking action.

PROJECT: $PROJECT
INPUT: Read $SHARED_DIR/analyst-recommendations.md (from ANALYST)
OUTPUT_DIR: $SHARED_DIR

Your job:
1. Read $SHARED_DIR/state.yaml to check pipeline
2. Read $SHARED_DIR/analyst-recommendations.md
3. Based on recommendations, create an action plan:
   - List specific actions to take
   - Assign priorities (P1/P2/P3)
   - Set deadlines
4. Create $SHARED_DIR/executor-action-plan.md
5. Execute first P1 action if possible (draft email, create doc, etc.)
6. Update $SHARED_DIR/state.yaml with:
   - What you executed
   - What remains for human approval

Mark complete by updating state.yaml:
  pipeline:
    executor: completed
  results:
    executor_output: $SHARED_DIR/executor-action-plan.md
    actions_executed: [list]
    actions_pending_approval: [list]
"

openclaw session spawn \
  --name "executor-$PROJECT-$TIMESTAMP" \
  --label "executor-$PROJECT" \
  --cwd /data/workspace \
  --message "$EXECUTOR_MSG" \
  --timeout-seconds 1200 \
  --no-deliver \
  2>&1 &

EXECUTOR_PID=$!
echo "EXECUTOR spawned (PID: $EXECUTOR_PID)"

echo "Waiting for EXECUTOR to complete..."
wait $EXECUTOR_PID
EXECUTOR_EXIT=$?

if [ $EXECUTOR_EXIT -eq 0 ]; then
    echo "✓ EXECUTOR completed"
else
    echo "✗ EXECUTOR failed (exit: $EXECUTOR_EXIT)"
fi

echo ""

# =====================================================================
# FINAL: Summarize results
# =====================================================================
echo "=== AGENT TEAM COMPLETE ==="
echo ""
echo "Results available at: $SHARED_DIR/"
echo ""

if [ -f "$SHARED_DIR/researcher-findings.md" ]; then
    echo "📊 RESEARCHER output:"
    head -10 "$SHARED_DIR/researcher-findings.md"
    echo "..."
    echo ""
fi

if [ -f "$SHARED_DIR/analyst-recommendations.md" ]; then
    echo "📈 ANALYST recommendations:"
    head -15 "$SHARED_DIR/analyst-recommendations.md"
    echo "..."
    echo ""
fi

if [ -f "$SHARED_DIR/executor-action-plan.md" ]; then
    echo "✅ EXECUTOR action plan:"
    head -15 "$SHARED_DIR/executor-action-plan.md"
    echo "..."
    echo ""
fi

echo "Full state: $SHARED_DIR/state.yaml"
echo ""
echo "=== DONE ==="