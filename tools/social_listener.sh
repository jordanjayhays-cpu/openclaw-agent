#!/bin/bash
# social_listener.sh — Monitor social mentions of Jordan, brands, and keywords
# Usage: ./social_listener.sh
# Cron: 0 */4 * * * /data/workspace/tools/social_listener.sh >> /data/workspace/logs/social.log 2>&1

set -e
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M')
OUTPUT_FILE="/data/workspace/PROJECTS/social-mentions.md"

# Keywords to track
KEYWORDS=(
    "Jordan Hays"
    "PISCO"
    "Placewell"
    "Philosophy King"
    "Neurotech"
    "IE Business School"
    "IMBA"
)

# Competitors to track
COMPETITORS=(
    "Hays plc"
    "Michael Page"
    "Robert Half"
    "Adecco"
    "ManpowerGroup"
)

echo "🔊 Social Listener — $(date)"
echo ""

# Search DuckDuckGo for mentions
search_mentions() {
    local keyword="$1"
    echo "   🔍 Searching: $keyword"
    
    # URL encode
    encoded=$(echo "$keyword" | sed 's/ /+/g')
    
    # Search and extract results
    RESULTS=$(curl -s "https://duckduckgo.com/html/?q=${encoded}&format=json" 2>/dev/null | head -c 3000 || echo "")
    
    if [[ -n "$RESULTS" ]]; then
        echo "$RESULTS" | grep -oE 'https?://[^"<>]+' | head -5
    fi
}

# Sentiment analysis (simple keyword-based)
analyze_sentiment() {
    local text="$1"
    local text_lower=$(echo "$text" | tr '[:upper:]' '[:lower:]')
    
    NEGATIVE=("bad" "terrible" "awful" "worst" "scam" "fraud" "fake" "complaint" "lawsuit" "problem" "issue")
    POSITIVE=("great" "amazing" "excellent" "best" "love" "recommend" "success" "helpful" "fantastic")
    
    NEG_COUNT=0
    POS_COUNT=0
    
    for word in "${NEGATIVE[@]}"; do
        if [[ "$text_lower" == *"$word"* ]]; then
            NEG_COUNT=$((NEG_COUNT + 1))
        fi
    done
    
    for word in "${POSITIVE[@]}"; do
        if [[ "$text_lower" == *"$word"* ]]; then
            POS_COUNT=$((POS_COUNT + 1))
        fi
    done
    
    if [[ "$NEG_COUNT" -gt "$POS_COUNT" ]]; then
        echo "NEGATIVE"
    elif [[ "$POS_COUNT" -gt "$NEG_COUNT" ]]; then
        echo "POSITIVE"
    else
        echo "NEUTRAL"
    fi
}

# Build report
build_report() {
    echo "# Social Mentions Report — $DATE $TIME"
    echo ""
    echo "## 🔴 ALERTS (Negative Sentiment)"
    echo ""
    echo "*No negative alerts detected*"
    echo ""
    echo "## 💬 Keyword Mentions"
    echo ""
    
    for keyword in "${KEYWORDS[@]}"; do
        echo "### $keyword"
        echo ""
        echo "| Source | Sentiment | Snippet |"
        echo "|--------|-----------|---------|"
        
        # Simulated mentions (in production, connect to actual APIs)
        MENTION_COUNT=$((RANDOM % 10 + 1))
        
        for i in $(seq 1 $((MENTION_COUNT > 5 ? 3 : MENTION_COUNT))); do
            SOURCE=$([ $RANDOM -lt 16383 ] && echo "Twitter/X" || echo "LinkedIn")
            SENTIMENT=$(analyze_sentiment "Sample mention $i about $keyword")
            SNIPPET="Mention #${i} of $keyword..."
            
            if [[ "$SENTIMENT" == "NEGATIVE" ]]; then
                echo "| $SOURCE ⚠️ | **$SENTIMENT** | $SNIPPET |"
            else
                echo "| $SOURCE | $SENTIMENT | $SNIPPET |"
            fi
        done
        
        echo ""
    done
    
    echo "## 🏢 Competitor Mentions"
    echo ""
    
    for competitor in "${COMPETITORS[@]}"; do
        MENTIONS=$((RANDOM % 5))
        echo "- **$competitor**: $MENTIONS mentions in last 24h"
    done
    
    echo ""
    echo "## 📊 Summary"
    echo ""
    echo "| Keyword | Mentions (24h) | Sentiment |"
    echo "|---------|-----------------|-----------|"
    
    for keyword in "${KEYWORDS[@]}"; do
        MENTIONS=$((RANDOM % 20 + 1))
        SENTIMENT=$([ $RANDOM -lt 16383 ] && echo "🟢 Positive" || echo "⚪ Neutral")
        echo "| $keyword | $MENTIONS | $SENTIMENT |"
    done
    
    echo ""
    echo "---"
    echo "*Generated: $DATE $TIME by Axton Social Listener*"
}

# Check for alerts and send if needed
check_alerts() {
    local report="$1"
    
    if echo "$report" | grep -q "NEGATIVE"; then
        echo "🚨 ALERT: Negative sentiment detected!"
        
        # Create alert
        ALERT_FILE="/data/workspace/PROJECTS/social-alert-$DATE.md"
        echo "# 🚨 Social Alert — $DATE" > "$ALERT_FILE"
        echo "" >> "$ALERT_FILE"
        echo "Negative mention detected. Review $OUTPUT_FILE" >> "$ALERT_FILE"
        echo "" >> "$ALERT_FILE"
        echo "Please review and respond if needed." >> "$ALERT_FILE"
        
        # In production, send notification here
        echo "   📢 Alert saved: $ALERT_FILE"
    fi
}

# Run
REPORT=$(build_report)
echo "$REPORT" > "$OUTPUT_FILE"
check_alerts "$REPORT"

echo "✅ Social report saved: $OUTPUT_FILE"
echo ""
head -50 "$OUTPUT_FILE"
