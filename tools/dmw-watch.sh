#!/bin/bash
# Watch for DMW to come back - runs in background
while true; do
    /data/workspace/tools/check-dmw.sh
    if [ -f /data/workspace/PROJECTS/PISCO/dmw-south-korea-raw.json ]; then
        echo "DMW data fetched! Stopping watch."
        break
    fi
    echo "Sleeping 1 hour before next check..."
    sleep 3600
done
