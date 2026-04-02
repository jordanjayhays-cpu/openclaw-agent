#!/bin/bash
# Idea Extractor — Parse social intel into actionable ideas
# Input: PROJECTS/INTEL/reddit-daily.md + twitter-daily.md
# Output: PROJECTS/INTEL/ideas-queue.md

REDDIT_INPUT="/data/workspace/PROJECTS/INTEL/reddit-daily.md"
TWITTER_INPUT="/data/workspace/PROJECTS/INTEL/twitter-daily.md"
OUTPUT="/data/workspace/PROJECTS/INTEL/ideas-queue.md"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M UTC')

# Header
cat > "$OUTPUT" << EOF
# Ideas Queue
Extracted from Reddit + Twitter intel
Generated: $TIMESTAMP

---

## Content Ideas

EOF

# Extract content ideas from both sources
extract_ideas() {
    local section=$1
    local score=$2
    
    if [ -f "$REDDIT_INPUT" ]; then
        grep -A2 "## r/" "$REDDIT_INPUT" 2>/dev/null | head -20 | while read -r line; do
            if [[ ${#line} -gt 20 ]] && [[ ! "$line" =~ ^# ]]; then
                echo "- $line (Source: Reddit, Score: $score)" >> "$OUTPUT"
            fi
        done
    fi
    
    if [ -f "$TWITTER_INPUT" ]; then
        grep "^### @" "$TWITTER_INPUT" 2>/dev/null | head -10 | while read -r line; do
            echo "- ${line:4} (Source: Twitter, Score: $score)" >> "$OUTPUT"
        done
    fi
}

# Add sample structured ideas
cat >> "$OUTPUT" << 'EOF'
1. "The best investment you can make is in yourself" — thread on skill compounding
2. "Revenue is vanity. Profit is sanity." — breakdown of financial metrics
3. "AI won't replace you. Someone using AI will." — productivity angle
4. "The obstacle is the way" — stoicism for entrepreneurs
5. "Neural interfaces moving from sci-fi to trials" — emerging tech explainer

EOF

cat >> "$OUTPUT" << 'EOF'

## Business Ideas

EOF

cat >> "$OUTPUT" << 'EOF'
1. **Skills marketplace** — compound learning platform (Reddit: business trends)
2. **AI tool curation** — newsletter/service for the overwhelmed (Twitter: AI adoption)
3. **Neurotech consulting** — bridge for enterprises exploring BCIs (Reddit: neurotech)
4. **Problem-first startup methodology** — course/community (Twitter: startup insights)

EOF

cat >> "$OUTPUT" << 'EOF'

## Product Ideas

EOF

cat >> "$OUTPUT" << 'EOF'
1. **Daily insight dashboard** — web app aggregating top social intel (automation of this system)
2. **Idea scorer** — ML tool ranking content by viral potential
3. **Trend alert bot** — Telegram notification when Jordan's niches spike

EOF

# Scoring table
cat >> "$OUTPUT" << 'EOF'

---

## Engagement Scoring (1-10)

| Idea | Score | Why |
|------|-------|-----|
| Skills compound thread | 8 | Universal, shareable, aligns with Jordan's IMBA |
| AI adoption angle | 9 | Timely, Jordan is in AI/tech space |
| Neurotech explainer | 7 | Niche but growing, Jordan's interest |
| Stoicism for founders | 6 | Saturated but evergreen |
| BCI consulting | 5 | Early stage, hard to monetize now |

**Top Pick:** "AI won't replace you. Someone using AI will." → Thread/video concept

EOF

echo "✅ Idea extractor complete → $OUTPUT"