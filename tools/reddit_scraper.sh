#!/bin/bash
# Reddit Scraper — Top posts from key subreddits (last 24h)
# Output: PROJECTS/INTEL/reddit-daily.md

OUTPUT="/data/workspace/PROJECTS/INTEL/reddit-daily.md"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M UTC')
SUBREDDITS=("business" "startups" "entrepreneur" "philosophy" "neuroscience" "neurotechnology")

# Header
cat > "$OUTPUT" << EOF
# Reddit Daily Intel
Generated: $TIMESTAMP

---

EOF

scrape_subreddit() {
    local sub=$1
    echo "## r/$sub" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    
    # Fetch top posts from last 24h using Reddit API
    response=$(curl -s --fail "https://www.reddit.com/r/$sub/top.json?t=day&limit=10" \
        -H "User-Agent: AxtonBot/1.0 (social intel scraper)" 2>/dev/null)
    
    if [ $? -ne 0 ] || [ -z "$response" ]; then
        echo "*Could not reach r/$sub — check API access*" >> "$OUTPUT"
        echo "" >> "$OUTPUT"
        return
    fi
    
    # Parse with basic extraction (jq would be ideal, fallback to grep/sed)
    echo "$response" | python3 -c "
import sys, json, re

try:
    data = json.load(sys.stdin)
    posts = data.get('data', {}).get('children', [])
    
    for post in posts[:10]:
        p = post['data']
        title = re.sub(r'[^\w\s\-.,!?]', '', p.get('title', 'N/A'))
        url = p.get('url', 'N/A')
        score = p.get('score', 0)
        num_comments = p.get('num_comments', 0)
        
        # Extract selftext if available
        selftext = p.get('selftext', '')
        insight = ''
        if selftext:
            insight = selftext[:200].replace('\n', ' ') + ('...' if len(selftext) > 200 else '')
        
        print(f'### {title}')
        print(f'- Score: {score} | Comments: {num_comments}')
        if insight:
            print(f'- Key insight: {insight}')
        print(f'- Link: https://reddit.com{p.get(\"permalink\", \"\")}')
        print('')
except Exception as e:
    print(f'Parse error: {e}')
" >> "$OUTPUT" 2>/dev/null
    
    echo "" >> "$OUTPUT"
}

# Scrape each subreddit
for sub in "${SUBREDDITS[@]}"; do
    scrape_subreddit "$sub"
    sleep 1  # Rate limit respect
done

echo "✅ Reddit scraper complete → $OUTPUT"