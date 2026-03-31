#!/bin/bash
# Capability Evolver - Self-Improvement Loop
# Runs every 6 hours via cron

cd /data/workspace

# Run the capability evolver if installed
if [ -f "$HOME/.openclaw/skills/capability-evolver/index.js" ]; then
    echo "Running Capability Evolver..."
    node "$HOME/.openclaw/skills/capability-evolver/index.js" --review >> /data/workspace/logs/evolver.log 2>&1
    echo "Evolver run complete at $(date)" >> /data/workspace/logs/evolver.log
else
    echo "Capability Evolver not installed yet"
fi
