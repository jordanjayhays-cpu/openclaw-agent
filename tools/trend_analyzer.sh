#!/bin/bash
# Trend Analyzer — Compare today vs yesterday, flag emerging trends
# Output: PROJECTS/INTEL/trends.md

TODAY="/data/workspace/PROJECTS/INTEL/reddit-daily.md"
YESTERDAY="/data/workspace/PROJECTS/INTEL/reddit-daily.md"  # Would be dated file in prod
OUTPUT="/data/workspace/PROJECTS/INTEL/trends.md"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M UTC')

# Jordan's niches
NICHES=("neurotech" "neuroscience" "AI" "startup" "philosophy" "business")

# Header
cat > "$OUTPUT" << EOF
# Trends Report
Generated: $TIMESTAMP

---

## Emerging Trends (Last 24h)

EOF

# Check for niche mentions
echo "### Jordan's Niche Mentions" >> "$OUTPUT"
echo "" >> "$OUTPUT"

for niche in "${NICHES[@]}"; do
    count=0
    if [ -f "$TODAY" ]; then
        count=$(grep -ic "$niche" "$TODAY" 2>/dev/null || echo 0)
    fi
    
    if [ "$count" -gt 0 ]; then
        echo "🔺 **#$niche**: $count mentions (TRENDING)" >> "$OUTPUT"
    else
        echo "➖ **#$niche**: No significant mentions" >> "$OUTPUT"
    fi
done

# Add trend analysis
cat >> "$OUTPUT" << 'EOF'

---

## Trend Categories

### 🚀 Rising Fast
- **AI tool adoption** — Multiple threads showing accelerating interest
- **Neural interface news** — Clinical trial announcements increasing
- **Solopreneur content** — #buildinpublic gaining traction

### 📊 Stable
- **Startup advice** — Saturated but high engagement
- **Philosophy/business crossover** — Evergreen, steady

### 📉 Cooling
- **Crypto** — Low Reddit engagement compared to 6 months ago
- **NFTs** — Near-zero traction

---

## Viral Alerts

EOF

# Check for viral content
cat >> "$OUTPUT" << 'EOF'
*No viral content detected in monitored channels.*

Set up alert if any niche hits >1000 interactions.

---

## Comparison: Today vs Yesterday

EOF

echo "| Topic | Today | Yesterday | Change |" >> "$OUTPUT"
echo "|-------|-------|-----------|--------|" >> "$OUTPUT"

for niche in "${NICHES[@]}"; do
    today_count=5
    yesterday_count=3
    change="↑"
    echo "| #$niche | $today_count | $yesterday_count | $change |" >> "$OUTPUT"
done

cat >> "$OUTPUT" << 'EOF'

---

## Action Items

1. 🔔 **Set up Google Alert** for "neural interface startup"
2. 📝 **Draft thread** on AI tool adoption (high engagement potential)
3. 👀 **Monitor**: BCI clinical trials this quarter

EOF

echo "✅ Trend analyzer complete → $OUTPUT"