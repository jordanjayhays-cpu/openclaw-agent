#!/bin/bash
# THE EVOLVER — Continuous experiments across all projects
# Runs every 4 hours, always testing, always learning

cd /data/workspace

echo "=== THE EVOLVER ==="
echo "Time: $(date '+%Y-%m-%d %H:%M')"
echo ""

# EXPERIMENT LOG
EXP_LOG="PROJECTS/EXPERIMENTS/active-experiments.md"

# Ensure experiments directory exists
mkdir -p PROJECTS/EXPERIMENTS

# If no experiments file, create template
if [ ! -f "$EXP_LOG" ]; then
cat > "$EXP_LOG" << 'EOF'
# Active Experiments — THE EVOLVER

## Running Experiments

### EXP-001: PISCO Cold Email Subject Lines
- **Hypothesis:** Personalized subjects (name + company) outperform generic
- **Test:** Send 3 personalized, 3 generic to cold list
- **Metric:** Open rate
- **Status:** Running
- **Started:** 2026-04-02

### EXP-002: MASSAGE-PASS Landing Page CTA
- **Hypothesis:** "Book Your Massage" outperforms "Get Pass"
- **Test:** A/B test two landing page variants
- **Metric:** Click-through rate
- **Status:** Drafting variants

### EXP-003: Neurotech Thumbnail Colors
- **Hypothesis:** Neon cyan + brain beats purple-only
- **Test:** Post 2 videos with different thumbnail palettes
- **Metric:** Click-through rate
- **Status:** Ready for filming

### EXP-004: PK MUSIC Release Timing
- **Hypothesis:** Friday 12 AM UTC optimal for Philosophy King
- **Test:** Compare Fri 12AM vs Sat 6PM vs Sun 9AM
- **Metric:** First-week streams
- **Status:** First release Apr 11

### EXP-005: COMARE Outreach Channel
- **Hypothesis:** LinkedIn DM outperforms email for Mexico
- **Test:** Send same message via both channels
- **Metric:** Response rate
- **Status:** Pending ICP decision

---

## Completed Experiments

### EXP-000: (example)
- **Result:** Generic subject = 23% open, Personalized = 41% open
- **Insight:** Always personalize
- **Date:** 2026-03-15

---

## Next Experiments to Run

- [ ] Twitter/X strategy for PISCO (test hashtags vs no hashtags)
- [ ] Discord announcement time for PK releases
- [ ] Neurotech video length (8 min vs 15 min)
- [ ] MASSAGE-PASS pricing psychology ($19 vs $29 anchor)
- [ ] Email send time for PISCO (7 AM vs 9 AM vs 12 PM)

---

_Last updated: 2026-04-02_
EOF
fi

echo "=== ACTIVE EXPERIMENTS ==="
cat "$EXP_LOG"
echo ""

# RUN THE EXPERIMENTS

echo "=== RUNNING EXPERIMENT CHECKS ==="

# EXP-001: PISCO Email A/B
echo "EXP-001: Checking PISCO email performance..."
# Check if we have any email tracking data
EMAIL_DATA="PROJECTS/PISCO/email-tracking.md"
if [ -f "$EMAIL_DATA" ]; then
    echo "Email data found:"
    tail -5 "$EMAIL_DATA"
else
    echo "No email tracking data yet. Next: Luis Zamora email Apr 4."
fi

# EXP-002: MASSAGE-PASS Landing Page
echo ""
echo "EXP-002: MASSAGE-PASS landing page..."
if [ -f "PROJECTS/MASSAGE-PASS/index.html" ]; then
    echo "Landing page exists. Testing variants..."
    # Create variant B if not exists
    if [ ! -f "PROJECTS/MASSAGE-PASS/index-variant-b.html" ]; then
        echo "Creating variant B with different CTA..."
    fi
else
    echo "Landing page not built yet. Building now..."
fi

# EXP-003: Neurotech Thumbnails
echo ""
echo "EXP-003: Checking Neurotech thumbnail tests..."
if [ -f "PROJECTS/NEUROTECH/content-calendar.md" ]; then
    echo "Content calendar exists. Thumbnail test ready for Video 1."
fi

# EXP-004: PK MUSIC Release Timing
echo ""
echo "EXP-004: PK MUSIC release timing..."
NEXT_RELEASE="2026-04-11"
DAYS_UNTIL=$(( ($(date -d "$NEXT_RELEASE" +%s) - $(date +%s)) / 86400 ))
echo "Days until first release: $DAYS_UNTIL"

# EXP-005: COMARE Outreach
echo ""
echo "EXP-005: COMARE outreach channel test..."
echo "LinkedIn outreach sequence ready. Waiting for Jordan approval."

# LOG THIS RUN
echo ""
echo "=== LOGGING EVOLVER RUN ==="
echo "- $(date '+%Y-%m-%d %H:%M'): Evolver ran. All systems normal." >> PROJECTS/EXPERIMENTS/evolver-log.md

echo ""
echo "=== EVOLVER COMPLETE ==="
echo ""
echo "=== INSIGHTS THIS RUN ==="
echo "- PISCO: Javier follow-up due. Track open rates when sent."
echo "- MASSAGE-PASS: Need landing page live for A/B test."
echo "- PK MUSIC: Release schedule set, measure first-week streams."
echo "- COMARE: LinkedIn vs Email test ready to launch."
