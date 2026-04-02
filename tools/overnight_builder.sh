#!/bin/bash
# Overnight Builder — Build things while Jordan sleeps
# Runs at 1 AM CET via cron
# Usage: bash tools/overnight_builder.sh

cd /data/workspace

echo "=== OVERNIGHT BUILDER ==="
echo "Started: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Check what's in the overnight queue
if [ ! -f PROJECTS/overnight-queue.md ]; then
    echo "No overnight queue. Creating..."
    cat > PROJECTS/overnight-queue.md << 'EOF'
# Overnight Queue — Things to Build While Jordan Sleeps

## Rules
- Only build things that don't need Jordan's input
- If it requires a decision, skip it
- Report completed work to overnight-log.md

## Current Queue

### HIGH PRIORITY
- [ ] Research competitors for MASSAGE-PASS landing page
- [ ] Draft landing page HTML for MASSAGE-PASS
- [ ] Find emails for PISCO cold contacts (Concha, Gabriel, Yolanda)

### MEDIUM PRIORITY  
- [ ] Draft COMARE outreach email sequence
- [ ] Build PISCO case study document
- [ ] Research PK Music distribution options

### LOW PRIORITY
- [ ] Clean up project files
- [ ] Update STATE.yaml from last session
- [ ] Research Neurotech content ideas

---

_Last updated: 2026-04-01_
EOF
fi

# Read queue and execute
echo "Reading overnight queue..."
cat PROJECTS/overnight-queue.md

# Log this run
echo ""
echo "=== Logging overnight run ==="
echo "$(date '+%Y-%m-%d %H:%M') - Overnight builder started" >> PROJECTS/overnight-log.md

echo ""
echo "=== COMPLETE ==="
echo "Review overnight-log.md for results"
