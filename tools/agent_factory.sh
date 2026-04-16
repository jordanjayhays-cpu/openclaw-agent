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
    echo ""
    echo "Types:"
    echo "  RESEARCHERS:   market_researcher, lead_researcher, content_researcher,"
    echo "                 tech_researcher, opportunity_researcher"
    echo "  CREATORS:      email_creator, social_creator, script_creator,"
    echo "                 copy_creator, song_creator"
    echo "  EXECUTORS:     outreach_executor, content_scheduler, data_collector,"
    echo "                 report_builder, pipeline_builder"
    echo "  ANALYSTS:      crm_analyst, experiment_analyst, content_analyst,"
    echo "                 revenue_analyst, market_analyst"
    echo ""
    echo "Examples:"
    echo "  agent_factory.sh pisco market_researcher"
    echo "  agent_factory.sh pisco lead_researcher"
    echo "  agent_factory.sh pk-music song_creator"
    echo "  agent_factory.sh comare crm_analyst"
    exit 1
fi

echo "Spawning $TYPE agent for $PROJECT..."

# Read template (handle underscore naming convention)
TEMPLATE_NAME=$(echo "$TYPE" | tr '[:lower:]' '[:upper:]' | sed 's/_/-/g')
TEMPLATE="TEAM/TEMPLATES/${TEMPLATE_NAME}.md"

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
