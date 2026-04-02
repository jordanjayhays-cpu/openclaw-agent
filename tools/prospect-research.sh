#!/bin/bash
# prospect-research.sh — Finds 3 new decision-makers per night for target ICP
# Run: bash /home/openclaw/.openclaw/workspace/tools/prospect-research.sh

OUTPUT_DIR="/home/openclaw/.openclaw/workspace/startup-machine/prospects"
QUEUE_FILE="$OUTPUT_DIR/outreach-queue.md"
PROSPECTS_JSON="$OUTPUT_DIR/prospects-today.json"
DATE=$(date +%Y-%m-%d)
mkdir -p "$OUTPUT_DIR"

echo "🔍 PROSPECT RESEARCH — $DATE"
echo "================================"

# Target ICPs (rotates daily)
COMARE_TARGETS=("Smart Fit Mexico gym" "Bodytech Mexico fitness" "Golds Gym Mexico" "gym chain Mexico City decision maker" "fitness center Mexico Operations Director")

PISCO_TARGETS=("NH Hotel Spain Director of Operations" "hotel Spain HR Director Filipino staff" "hotel group Spain hiring Filipino" "Melia Hotel Spain operations" "hotel chain UK HR director")

echo "📋 Tonight's targets:"
echo "COMARE: ${COMARE_TARGETS[$((RANDOM % ${#COMARE_TARGETS[@]}))]}"
echo "PISCO: ${PISCO_TARGETS[$((RANDOM % ${#PISCO_TARGETS[@]}))]}"
echo ""

# Use web search via OpenClaw agent to find LinkedIn profiles
# The actual web search happens in the cron agent turn
# This script documents the output format and handles file ops

# Output format for each prospect:
# {
#   "name": "Name",
#   "title": "Title", 
#   "company": "Company",
#   "linkedin": "https://linkedin.com/in/...",
#   "icp": "COMARE|PISCO",
#   "why": "Why to contact them",
#   "message_topic": "What to say first",
#   "found_date": "YYYY-MM-DD"
# }

echo "✅ Prospect research script ready"
echo "📁 Output: $PROSPECTS_JSON"
echo "📝 Outreach queue: $QUEUE_FILE"
echo ""
echo "This script is called by the nightly cron agent."
echo "The agent does the web research and writes results here."
