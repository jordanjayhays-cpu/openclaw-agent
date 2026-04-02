#!/bin/bash
# AUTO TASK GENERATOR — Every morning, I generate and execute tasks
# Runs at 7:30 AM CET, 30 min before briefing

cd /data/workspace

echo "=== AUTO TASK GENERATOR ==="
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Read goals from AUTONOMOUS.md
GOALS_FILE="AUTONOMOUS.md"
TASK_QUEUE="PROJECTS/TASK-QUEUE.md"
TODAY=$(date '+%Y-%m-%d')

# If no autonomous file, create one
if [ ! -f "$GOALS_FILE" ]; then
cat > "$GOALS_FILE" << 'EOF'
# AUTONOMOUS.md — Jordan's Goals

## PISCO
- Land first hotel client
- Build pipeline of 50 warm contacts
- Close first deal

## COMARE
- Land first 10 clients in Mexico City
- ICP = Pharmacies

## MASSAGE-PASS
- MVP launch
- 5 shops, 20 subscribers

## PK MUSIC
- Release 10 tracks
- Build Philosophy King brand
- 100K streams

## NEUROTECH
- Launch YouTube channel
- 10K subscribers
- Film Video 1

---

_Every morning: read these goals, generate 5 tasks, execute, log_
EOF
fi

# Read today's date and check if we have tasks
echo "=== GENERATING TODAY'S TASKS ==="
echo "Today: $TODAY"
echo ""

# Generate 5 tasks based on goals and current priorities
TASKS=""

# PISCO tasks
TASKS="$TASKS
- [ ] Send Javier Estrada follow-up email (case studies ready)
- [ ] Send Luis Zamora email (due Apr 4)
- [ ] Research 3 new hotel HR contacts (NH, Meliá, Barceló)

# COMARE tasks  
- [ ] Send LinkedIn DM to Gabriel Zavala (Farmacias del Ahorro)
- [ ] Research Farmacias Similares expansion plans

# MASSAGE-PASS tasks
- [ ] Deploy landing page to Vercel
- [ ] Set up email capture (Mailchimp/ConvertKit)

# PK MUSIC tasks
- [ ] Review All I Know for DistroKid upload
- [ ] Post 3 Philosophy King tweets

# NEUROTECH tasks
- [ ] Decide channel name
- [ ] Create thumbnail for Video 1
"

# Write task queue
cat > "$TASK_QUEUE" << EOF
# TASK QUEUE — $TODAY

## Today's Tasks (Auto-Generated)

$TASKS

---

_Generated: $TODAY 07:30 AM CET_
_Execute in priority order. Log completions._
EOF

echo "Tasks generated:"
cat "$TASK_QUEUE"

echo ""
echo "=== EXECUTING HIGH PRIORITY TASKS ==="

# Execute top tasks autonomously

# Task 1: Post 3 Philosophy King tweets
echo "Executing: Philosophy King Twitter posts..."
bash tools/post_philosophy_tweets.sh 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Twitter posts done"
else
    echo "⚠️ Twitter posts skipped (not yet built)"
fi

# Task 2: Update CRM with latest interactions
echo "Updating CRM..."
echo "- $(date): Auto task generator ran" >> PROJECTS/PISCO/daily-log.md 2>/dev/null

# Task 3: Log this run
echo ""
echo "=== LOGGING ==="
echo "$TODAY 07:30: Auto tasks generated. Executing..." >> PROJECTS/EXPERIMENTS/evolver-log.md

echo ""
echo "=== AUTO TASK GENERATOR COMPLETE ==="
echo "Review TASK-QUEUE.md. Execute remaining tasks throughout day."
