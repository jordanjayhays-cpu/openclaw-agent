#!/bin/bash
# Auto Content Pipeline for Philosophy King
# Generates 7 Twitter posts per week for PK-MUSIC
# Run: ./content_pipeline.sh [week_of]

OUTPUT_DIR="PROJECTS/PK-MUSIC"
CALENDAR_FILE="$OUTPUT_DIR/content-queue.md"
TEMPLATE_FILE="$OUTPUT_DIR/content-template.md"

# Theme categories for Philosophy King
THEMES=(
    "Stoicism" "Existentialism" "Pragmatism" "Mindset" "Discipline"
    "Authenticity" "Digital Philosophy" "Art & Meaning" "Flow State" "Modern Wisdom"
)

# Content hooks (provocative openers)
HOOKS=(
    "Most people will tell you to follow your passion. They're wrong."
    "The Stoics had one word for what most people spend their lives chasing: bullsh*t."
    "You don't need more motivation. You need better questions."
    "Aristotle was right about one thing. Most people are exactly as happy as they decide to be."
    "The obstacle is the way. Marcus Aurelius figured this out 2000 years ago."
    "Stop optimizing for comfort. Comfort is the enemy of growth."
    "Philosophy isn't abstract. It's the operating system for your life."
)

# Call to action styles
CTAS=(
    "Follow for more." "Drop a thought." "Save this." "Repost if this resonates."
    "Philosophy King." "Think deeper." "Question everything."
)

# Generate a single post
generate_post() {
    local theme="${THEMES[$((RANDOM % ${#THEMES[@]}))]}"
    local hook="${HOOKS[$((RANDOM % ${#HOOKS[@]}))]}"
    local cta="${CTAS[$((RANDOM % ${#CTAS[@]}))]}"
    
    cat << POST
---
Theme: $theme
Scheduled: $1
Status: [ ] Draft [x] Approved

$hook

The real question isn't what you want to do — it's what you're willing to sacrifice.

Most people want the outcome without the transformation.

$cta
POST
}

# Generate full week content
generate_week() {
    local week_of="${1:-$(date -v+1w +'%Y-%m-%d')}"
    local day_of_week=("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
    
    echo "# Philosophy King - Content Queue"
    echo ""
    echo "Week of: $week_of"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "---"
    echo ""
    
    for i in {0..6}; do
        generate_post "${day_of_week[$i]} - $week_of"
        echo ""
    done
    
    echo "---"
    echo ""
    echo "## Content Calendar"
    echo ""
    for i in {0..6}; do
        echo "| ${day_of_week[$i]} | ${THEMES[$((RANDOM % ${#THEMES[@]}))]} | [ ] Posted |"
    done
    echo ""
    echo "## Notes"
    echo "- Maintain consistent posting time (12:00 UTC recommended)"
    echo "- Engage with comments within 1 hour of posting"
    echo "- Track engagement metrics weekly"
}

# Main execution
mkdir -p "$OUTPUT_DIR"
generate_week "$1" > "$CALENDAR_FILE"

echo "Generated content calendar: $CALENDAR_FILE"
echo ""
echo "Preview:"
head -30 "$CALENDAR_FILE"
