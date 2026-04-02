#!/bin/bash
# AGENT FACTORY — Spawn new agents from templates
# Usage: bash tools/agent_factory.sh [PROJECT] [TYPE]

cd /data/workspace

echo "=== AGENT FACTORY ==="
echo "Time: $(date '+%Y-%m-%d %H:%M')"
echo ""

PROJECT=$1
TYPE=$2

if [ -z "$PROJECT" ] || [ -z "$TYPE" ]; then
    echo "Usage: agent_factory.sh [PROJECT] [TYPE]"
    echo "Types: researcher, outreach, builder, analyst, creator"
    echo ""
    echo "Examples:"
    echo "  agent_factory.sh piscoskills researcher"
    echo "  agent_factory.sh comare outreach"
    echo "  agent_factory.sh massagpass builder"
    exit 1
fi

echo "Spawning $TYPE agent for $PROJECT..."

# Read template
TEMPLATE="TEAM/TEMPLATES/$(echo $TYPE | tr '[:lower:]' '[:upper:]').md"

if [ ! -f "$TEMPLATE" ]; then
    echo "ERROR: Template $TEMPLATE not found"
    exit 1
fi

echo "Template: $TEMPLATE"
echo ""

# Create project agent directory
AGENT_DIR="TEAM/$PROJECT"
mkdir -p "$AGENT_DIR"

# Copy template as agent SOUL
cp "$TEMPLATE" "$AGENT_DIR/SOUL.md"

# Create state file if not exists
if [ ! -f "PROJECTS/$PROJECT/state/STATE.yaml" ]; then
    mkdir -p "PROJECTS/$PROJECT/state"
    cat > "PROJECTS/$PROJECT/state/STATE.yaml" << EOF
project: $PROJECT
updated: $(date '+%Y-%m-%dT%H:%M:%SZ')
status: active

tasks: []
contacts: []
next_actions: []
EOF
fi

echo "=== AGENT CREATED ==="
echo "Project: $PROJECT"
echo "Type: $TYPE"
echo "SOUL: $AGENT_DIR/SOUL.md"
echo ""

# Spawn the agent
openclaw session spawn \
  --name "$PROJECT-$TYPE" \
  --label "$PROJECT-$TYPE" \
  --message "You are the $TYPE agent for $PROJECT. 
Read your SOUL.md at TEAM/$PROJECT/SOUL.md.
Read project state at PROJECTS/$PROJECT/state/STATE.yaml.
Execute your specialization.
Report completion." \
  --cwd /data/workspace \
  2>&1

echo ""
echo "Agent spawned and working."
