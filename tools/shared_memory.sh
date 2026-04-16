#!/bin/bash
# SHARED MEMORY — File-based communication for agents
# Agents write to shared files, other agents read the results
# Usage: bash tools/shared_memory.sh [init|write|read|list|clear]

cd /data/workspace

SHARED_DIR="TEAM/shared-memory"
mkdir -p "$SHARED_DIR"

OP=${1:-list}

case $OP in
    init)
        echo "=== INITIALIZE SHARED MEMORY ==="
        cat > "$SHARED_DIR/_meta.yaml" << EOF
# Shared Memory Meta
created: $(date '+%Y-%m-%dT%H:%M:%SZ')
version: 1.0
agents: []
last_write: $(date '+%Y-%m-%dT%H:%M:%SZ')
EOF

        # Create standard directories
        mkdir -p "$SHARED_DIR/agents"
        mkdir -p "$SHARED_DIR/tasks"
        mkdir -p "$SHARED_DIR/results"
        mkdir -p "$SHARED_DIR/messages"

        echo "✓ Shared memory initialized at $SHARED_DIR"
        echo ""
        echo "Structure:"
        echo "  agents/    — Agent status and heartbeats"
        echo "  tasks/     — Task queue and assignments"
        echo "  results/   — Completed task outputs"
        echo "  messages/  — Inter-agent messages"
        echo ""
        ls -la "$SHARED_DIR/"
        ;;

    write)
        KEY=${2:-test}
        VALUE=${3:-$(cat)}
        FILE="$SHARED_DIR/$KEY.md"

        cat > "$FILE" << EOF
# $KEY
updated: $(date '+%Y-%m-%dT%H:%M:%SZ')
author: $(whoami)

$VALUE
EOF

        # Update meta
        sed -i "s/last_write:.*/last_write: $(date '+%Y-%m-%dT%H:%M:%SZ')/" "$SHARED_DIR/_meta.yaml" 2>/dev/null

        echo "✓ Wrote to $FILE"
        ;;

    read)
        KEY=${2:-test}
        FILE="$SHARED_DIR/$KEY.md"

        if [ -f "$FILE" ]; then
            echo "=== $KEY ==="
            cat "$FILE"
        else
            echo "✗ Key '$KEY' not found"
            exit 1
        fi
        ;;

    list)
        echo "=== SHARED MEMORY CONTENTS ==="
        echo "Directory: $SHARED_DIR"
        echo ""

        if [ ! -f "$SHARED_DIR/_meta.yaml" ]; then
            echo "Not initialized. Run: bash tools/shared_memory.sh init"
            exit 1
        fi

        echo "Meta:"
        head -10 "$SHARED_DIR/_meta.yaml"
        echo ""

        echo "=== Agents ==="
        ls "$SHARED_DIR/agents/" 2>/dev/null || echo "(empty)"
        echo ""

        echo "=== Tasks ==="
        ls "$SHARED_DIR/tasks/" 2>/dev/null || echo "(empty)"
        echo ""

        echo "=== Results ==="
        ls "$SHARED_DIR/results/" 2>/dev/null || echo "(empty)"
        echo ""

        echo "=== Messages ==="
        ls "$SHARED_DIR/messages/" 2>/dev/null || echo "(empty)"
        ;;

    clear)
        echo "=== CLEAR SHARED MEMORY ==="
        echo "This removes all shared memory files."
        read -p "Are you sure? (y/n) " CONFIRM

        if [ "$CONFIRM" = "y" ]; then
            rm -rf "$SHARED_DIR"/*
            echo "✓ Cleared"
        else
            echo "Cancelled"
        fi
        ;;

    agent-register)
        AGENT_NAME=${2:-unknown}
        AGENT_ROLE=${3:-worker}

        cat > "$SHARED_DIR/agents/$AGENT_NAME.yaml" << EOF
# Agent: $AGENT_NAME
name: $AGENT_NAME
role: $AGENT_ROLE
registered: $(date '+%Y-%m-%dT%H:%M:%SZ')
last_heartbeat: $(date '+%Y-%m-%dT%H:%M:%SZ')
status: active
EOF

        echo "✓ Agent '$AGENT_NAME' registered as '$AGENT_ROLE'"
        ;;

    agent-heartbeat)
        AGENT_NAME=${2:-unknown}

        FILE="$SHARED_DIR/agents/$AGENT_NAME.yaml"
        if [ -f "$FILE" ]; then
            sed -i "s/last_heartbeat:.*/last_heartbeat: $(date '+%Y-%m-%dT%H:%M:%SZ')/" "$FILE"
            echo "✓ Heartbeat for '$AGENT_NAME'"
        else
            echo "✗ Agent '$AGENT_NAME' not registered"
            exit 1
        fi
        ;;

    task-create)
        TASK_NAME=${2:-unnamed}
        TASK_DESC=${3:-No description}
        TASK_ASSIGNEE=${4:-unassigned}

        cat > "$SHARED_DIR/tasks/$TASK_NAME.yaml" << EOF
# Task: $TASK_NAME
name: $TASK_NAME
description: $TASK_DESC
assignee: $TASK_ASSIGNEE
created: $(date '+%Y-%m-%dT%H:%M:%SZ')
status: pending
priority: medium
EOF

        echo "✓ Task '$TASK_NAME' created (assigned to: $TASK_ASSIGNEE)"
        ;;

    task-complete)
        TASK_NAME=${2:-}
        RESULT=${3:-Completed}

        FILE="$SHARED_DIR/tasks/$TASK_NAME.yaml"
        if [ -f "$FILE" ]; then
            sed -i 's/status:.*/status: completed/' "$FILE"
            sed -i "s/completed:.*/completed: $(date '+%Y-%m-%dT%H:%M:%SZ')/" "$FILE" 2>/dev/null || true

            # Move to results
            mv "$FILE" "$SHARED_DIR/results/$TASK_NAME.yaml"
            echo "✓ Task '$TASK_NAME' completed and moved to results"
        else
            echo "✗ Task '$TASK_NAME' not found"
            exit 1
        fi
        ;;

    message-send)
        FROM=${2:-sender}
        TO=${3:-recipient}
        MSG=${4:-Hello}

        TIMESTAMP=$(date +%Y%m%d-%H%M%S)
        FILE="$SHARED_DIR/messages/${TIMESTAMP}_${FROM}_to_${TO}.md"

        cat > "$FILE" << EOF
# Message: $FROM → $TO
from: $FROM
to: $TO
timestamp: $(date '+%Y-%m-%dT%H:%M:%SZ')
read: false

## Message
$MSG
EOF

        echo "✓ Message sent from '$FROM' to '$TO'"
        echo "File: $FILE"
        ;;

    message-read)
        AGENT_NAME=${2:-}

        echo "=== Messages for '$AGENT_NAME' ==="
        echo ""

        for f in "$SHARED_DIR/messages/"*_${AGENT_NAME}.md "$SHARED_DIR/messages/"*_to_${AGENT_NAME}.md; do
            if [ -f "$f" ]; then
                echo "---"
                cat "$f"
                echo ""

                # Mark as read
                sed -i 's/read: false/read: true/' "$f" 2>/dev/null || true
            fi
        done
        ;;

    *)
        echo "SHARED MEMORY — File-based agent communication"
        echo ""
        echo "Usage: bash tools/shared_memory.sh [command] [args...]"
        echo ""
        echo "Commands:"
        echo "  init                    Initialize shared memory structure"
        echo "  list                    Show all shared memory contents"
        echo "  clear                   Clear all shared memory"
        echo ""
        echo "  write KEY VALUE         Write to a key"
        echo "  read KEY                Read from a key"
        echo ""
        echo "  agent-register NAME ROLE Register a new agent"
        echo "  agent-heartbeat NAME    Update agent heartbeat"
        echo ""
        echo "  task-create NAME DESC ASSIGNEE  Create a task"
        echo "  task-complete NAME      Mark task complete"
        echo ""
        echo "  message-send FROM TO MSG Send a message"
        echo "  message-read AGENT      Read messages for agent"
        ;;
esac