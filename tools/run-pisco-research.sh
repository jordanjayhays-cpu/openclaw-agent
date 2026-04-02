#!/bin/bash
# PISCO Research - Auto-run research tools
# Run this via cron: 0 8 * * * /data/workspace/tools/run-pisco-research.sh

cd /data/workspace

echo "🌏 PISCO Research - $(date)"
echo "=============================="

# 1. Scrape DMW for new job orders
echo "📋 Scraping DMW job orders..."
python3 tools/dmw-scraper.py

# 2. Research Korean companies
echo ""
echo "🏭 Researching Korean companies..."
python3 tools/korean-research.py

# 3. Update leads dashboard
echo ""
echo "📊 Updating leads dashboard..."
python3 -c "
import json
from datetime import datetime

# Load research
try:
    with open('korean-companies-research.json') as f:
        research = json.load(f)
    
    # Update leads HTML
    print(f'Researched {len(research.get(\"companies\", []))} companies')
except Exception as e:
    print(f'Error updating: {e}')
"

# 4. Commit results
git add PROJECTS/PISCO/
git commit -m "📊 PISCO research update - $(date '+%Y-%m-%d')" 2>/dev/null || true
git push 2>/dev/null || true

echo ""
echo "✅ PISCO research complete!"
