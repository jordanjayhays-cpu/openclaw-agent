#!/bin/bash
# DMW Job Orders Auto-Checker
# Runs via cron every hour
# If API is back, fetches South Korea job orders

LOG_FILE="/data/workspace/logs/dmw-check.log"
API_URL="https://master-api.dmw.gov.ph/api/v1/public/approved-job-orders"
API_KEY="RTA0X0lOWFcycm9KU29WTlZxNDUzSDY5enc5OWFxY2ktWkxVdkFwZjEyMjkwNTA2MTE"

echo "=== DMW Check: $(date) ===" >> $LOG_FILE

# Try to fetch from API
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Accept: application/json" \
  -H "x-api-key: $API_KEY" \
  "$API_URL" 2>/dev/null)

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ API BACK! Fetching South Korea jobs..." >> $LOG_FILE
    
    # Save the response
    echo "$BODY" > /data/workspace/PROJECTS/PISCO/dmw-south-korea-raw.json
    
    # Extract Korea companies
    python3 /data/workspace/tools/parse-korea-jobs.py >> $LOG_FILE 2>&1
    
    # Commit results
    cd /data/workspace
    git add PROJECTS/PISCO/dmw-south-korea-raw.json PROJECTS/PISCO/korea-leads.html
    git commit -m "🌏 PISCO: DMW South Korea job orders fetched automatically" >> $LOG_FILE 2>&1
    git push >> $LOG_FILE 2>&1
    
    echo "✅ DONE! Korea jobs updated." >> $LOG_FILE
else
    echo "❌ Still down (HTTP $HTTP_CODE)" >> $LOG_FILE
fi

echo "---" >> $LOG_FILE
