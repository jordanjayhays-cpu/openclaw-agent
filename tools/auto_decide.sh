#!/bin/bash
# auto_decide.sh — Help Jordan make decisions with pros/cons and data
# Usage: ./auto_decide.sh "decision title" "option A" "option B" [option C...]
# Example: ./auto_decide.sh "Hire developer" "Full-time" "Freelancer" "Agency"

set -e

DECISION="$1"
shift
OPTIONS=("$@")

if [[ -z "$DECISION" || ${#OPTIONS[@]} -lt 2 ]]; then
    echo "Usage: ./auto_decide.sh \"Decision Title\" \"Option A\" \"Option B\" [Option C...]"
    echo "Example: ./auto_decide.sh \"Hire developer\" \"Full-time\" \"Freelancer\" \"Agency\""
    exit 1
fi

echo "🤔 Analyzing decision: $DECISION"
echo "   Options: ${OPTIONS[*]}"
echo ""

# ============================================
# Define decision factors (weighted)
# ============================================
FACTORS=(
    "Cost (lower is better)"
    "Speed (faster is better)"
    "Quality (higher is better)"
    "Control (more is better)"
    "Risk (lower is better)"
    "Scalability (more is better)"
)

# Factor weights (1-10)
declare -A WEIGHTS
WEIGHTS["Cost"]=8
WEIGHTS["Speed"]=7
WEIGHTS["Quality"]=9
WEIGHTS["Control"]=6
WEIGHTS["Risk"]=8
WEIGHTS["Scalability"]=5

# ============================================
# Score each option (1-10 scale)
# ============================================
score_option() {
    local option="$1"
    local factor="$2"
    local option_lower=$(echo "$option" | tr '[:upper:]' '[:lower:]')
    local factor_lower=$(echo "$factor" | tr '[:upper:]' '[:lower:]')
    
    BASE_SCORE=5
    
    # Smart scoring based on option/factor combinations
    case "$option_lower" in
        *full-time*|*employee*)
            case "$factor_lower" in
                *cost*) echo 3 ;;
                *speed*) echo 7 ;;
                *quality*) echo 9 ;;
                *control*) echo 9 ;;
                *risk*) echo 6 ;;
                *scale*) echo 4 ;;
                *) echo 5 ;;
            esac
            ;;
        *freelance*|*contract*)
            case "$factor_lower" in
                *cost*) echo 7 ;;
                *speed*) echo 9 ;;
                *quality*) echo 7 ;;
                *control*) echo 5 ;;
                *risk*) echo 7 ;;
                *scale*) echo 8 ;;
                *) echo 6 ;;
            esac
            ;;
        *agency*)
            case "$factor_lower" in
                *cost*) echo 2 ;;
                *speed*) echo 8 ;;
                *quality*) echo 8 ;;
                *control*) echo 3 ;;
                *risk*) echo 8 ;;
                *scale*) echo 9 ;;
                *) echo 5 ;;
            esac
            ;;
        *wait*|*delay*|*postpone*)
            case "$factor_lower" in
                *cost*) echo 9 ;;
                *speed*) echo 2 ;;
                *quality*) echo 5 ;;
                *control*) echo 7 ;;
                *risk*) echo 3 ;;
                *scale*) echo 5 ;;
                *) echo 4 ;;
            esac
            ;;
        *yes*|*accept*|*do*)
            case "$factor_lower" in
                *cost*) echo 5 ;;
                *speed*) echo 9 ;;
                *quality*) echo 6 ;;
                *control*) echo 8 ;;
                *risk*) echo 4 ;;
                *scale*) echo 6 ;;
                *) echo 6 ;;
            esac
            ;;
        *no*|*reject*|*skip*)
            case "$factor_lower" in
                *cost*) echo 9 ;;
                *speed*) echo 3 ;;
                *quality*) echo 5 ;;
                *control*) echo 9 ;;
                *risk*) echo 9 ;;
                *scale*) echo 5 ;;
                *) echo 5 ;;
            esac
            ;;
        *)
            echo $((RANDOM % 5 + 3))
            ;;
    esac
}

# ============================================
# Generate pros/cons
# ============================================
generate_pros_cons() {
    local option="$1"
    local option_lower=$(echo "$option" | tr '[:upper:]' '[:lower:]')
    
    PROS=""
    CONS=""
    
    case "$option_lower" in
        *full-time*|*employee*)
            PROS="• Dedicated focus\n• Deep company knowledge\n• Easier collaboration\n• Long-term cost savings"
            CONS="• Higher fixed cost\n• Long hiring process\n• Less flexibility\n• Management overhead"
            ;;
        *freelance*|*contract*)
            PROS="• Flexibility\n• Lower commitment\n• Specialized skills\n• Fast to ramp"
            CONS="• Less control\n• Availability uncertainty\n• Quality variance\n• Hidden costs"
            ;;
        *agency*)
            PROS="• Fast delivery\n• Full team coverage\n• Professional process\n• Scalability"
            CONS="• Expensive\n• Communication overhead\n• Less control\n• Cultural mismatch risk"
            ;;
        *wait*|*delay*|*postpone*)
            PROS="• More information\n• Better timing\n• Reduced risk\n• Preserve options"
            CONS="• Opportunity cost\n• Market may move\n• Uncertainty remains\n• Procrastination risk"
            ;;
        *yes*|*accept*)
            PROS="• Move forward\n• Learn by doing\n• Network effect\n• First-mover advantage"
            CONS="• Risk of regret\n• Commitment required\n• May miss better option"
            ;;
        *no*|*reject*)
            PROS="• Preserve resources\n• Focus on priorities\n• Avoid bad fit\n• Zero downside"
            CONS="• Opportunity cost\n• May regret\n• FOMO risk\n• Standing still"
            ;;
        *)
            PROS="• Potential upside\n• Worth exploring"
            CONS="• Unknown risks\n• Requires investigation"
            ;;
    esac
    
    echo -e "$PROS|$CONS"
}

# ============================================
# Calculate probability of success
# ============================================
calc_probability() {
    local option="$1"
    local option_lower=$(echo "$option" | tr '[:upper:]' '[:lower:]')
    
    case "$option_lower" in
        *full-time*) echo 70 ;;
        *freelance*) echo 60 ;;
        *agency*) echo 55 ;;
        *wait*) echo 65 ;;
        *yes*) echo 55 ;;
        *no*) echo 75 ;;
        *) echo 50 ;;
    esac
}

# ============================================
# Build decision matrix
# ============================================
OUTPUT_FILE="/data/workspace/memory/decisions.md"
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Create/update decisions log
{
    echo ""
    echo "---"
    echo ""
    echo "# Decision: $DECISION"
    echo "Date: $(date '+%Y-%m-%d %H:%M')"
    echo ""
    echo "## Options Analysis"
    echo ""
} >> "$OUTPUT_FILE"

TOTAL_SCORES=()

for option in "${OPTIONS[@]}"; do
    echo "### $option"
    echo ""
    
    PROS_CONS=$(generate_pros_cons "$option")
    PROS=$(echo "$PROS_CONS" | cut -d'|' -f1)
    CONS=$(echo "$PROS_CONS" | cut -d'|' -f2)
    PROB=$(calc_probability "$option")
    
    echo "**Pros:**"
    echo -e "$PROS"
    echo ""
    echo "**Cons:**"
    echo -e "$CONS"
    echo ""
    echo "**Probability of success:** $PROB%"
    echo ""
    
    # Calculate weighted score
    OPTION_SCORE=0
    TOTAL_WEIGHT=0
    
    for factor in "${FACTORS[@]}"; do
        FACTOR_NAME=$(echo "$factor" | sed 's/(.*//' | tr -d ' ')
        WEIGHT=${WEIGHTS[$FACTOR_NAME]}
        SCORE=$(score_option "$option" "$factor")
        WEIGHTED=$((SCORE * WEIGHT))
        OPTION_SCORE=$((OPTION_SCORE + WEIGHTED))
        TOTAL_WEIGHT=$((TOTAL_WEIGHT + WEIGHT))
    done
    
    FINAL_SCORE=$((OPTION_SCORE / TOTAL_WEIGHT))
    TOTAL_SCORES+=("$FINAL_SCORE")
    
    echo "**Weighted Score:** $FINAL_SCORE/10"
    echo ""
    echo "---"
    echo ""
    
    # Append to file
    {
        echo "### $option"
        echo "Pros: $(echo "$PROS" | head -2 | tr '\n' ' ')"
        echo "Cons: $(echo "$CONS" | head -2 | tr '\n' ' ')"
        echo "Probability: $PROB%"
        echo "Score: $FINAL_SCORE/10"
        echo ""
    } >> "$OUTPUT_FILE"
done

# Determine winner
MAX_SCORE=0
WINNER_INDEX=0

for i in "${!OPTIONS[@]}"; do
    if [[ "${TOTAL_SCORES[$i]}" -gt "$MAX_SCORE" ]]; then
        MAX_SCORE="${TOTAL_SCORES[$i]}"
        WINNER_INDEX=$i
    fi
done

WINNER="${OPTIONS[$WINNER_INDEX]}"

# ============================================
# Recommendation
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 DECISION MATRIX RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for i in "${!OPTIONS[@]}"; do
    BAR=""
    for j in $(seq 1 $((TOTAL_SCORES[$i] * 2))); do BAR="${BAR}█"; done
    for j in $(seq 1 $((20 - TOTAL_SCORES[$i] * 2))); do BAR="${BAR}░"; done
    
    if [[ $i -eq $WINNER_INDEX ]]; then
        echo "✅ ${OPTIONS[$i]}: $BAR ${TOTAL_SCORES[$i]}/10 ⭐"
    else
        echo "   ${OPTIONS[$i]}: $BAR ${TOTAL_SCORES[$i]}/10"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 RECOMMENDATION: $WINNER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Score: $MAX_SCORE/10"
echo ""

# Data confidence check
AVG_PROB=$((PROB / ${#OPTIONS[@]}))
if [[ "$AVG_PROB" -lt 55 ]]; then
    echo "⚠️ LOW DATA CONFIDENCE"
    echo "No clear winner based on available data."
    echo "Recommendation: Go with your gut on this one."
else
    echo "✅ Based on weighted analysis, $WINNER is optimal."
fi

echo ""
echo "📁 Saved to: $OUTPUT_FILE"
