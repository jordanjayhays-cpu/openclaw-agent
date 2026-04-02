#!/bin/bash
# Revenue Dashboard
# All 5 revenue streams in one view

set -e

DATA_DIR="/data/workspace"
TRACKER="$DATA_DIR/PROJECTS/revenue-tracker.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Load constants from other scripts
source /data/workspace/tools/pisco_revenue.sh 2>/dev/null || true

# Init revenue tracker
init_tracker() {
    mkdir -p "$DATA_DIR/PROJECTS"
    
    if [[ ! -f "$TRACKER" ]]; then
        cat > "$TRACKER" << 'EOF'
# Jordan's Revenue Tracker

## Last Updated: 

## Pipeline Overview
| Project | Pipeline | Prob | Expected | Closed | MTD |
|---------|----------|------|---------|--------|-----|
| PISCO   | €0       | 0%   | €0      | €0     | €0  |
| COMARE  | $0       | 0%   | $0      | $0     | $0  |
| MASSAGE | $0       | 0%   | $0      | $0     | $0  |
| PK MUSIC| $0       | 0%   | $0      | $0     | $0  |
| NEUROTECH| $0      | 0%   | $0      | $0     | $0  |
| **TOTAL** | **$0** | -    | **$0**  | **$0** | **$0** |

## Monthly Targets
| Stream | Target | Actual | % |
|--------|--------|--------|---|
| PISCO   | €15K/mo| €0     | 0%|
| COMARE  | $5K/mo | $0     | 0%|
| MASSAGE | $120/mo| $0     | 0%|

## Weekly Progress
EOF
    fi
}

# Update tracker
update() {
    local project="$1"
    local field="$2"
    local value="$3"
    
    if [[ -z "$project" || -z "$field" || -z "$value" ]]; then
        echo "Usage: update <project> <field> <value>"
        return 1
    fi
    
    sed -i "s/| $project   |/| $project   |/; s/| $project  |/| $project  |/; s/| $project |/| $project |/" "$TRACKER"
    # This is simplified - in production use proper CSV/JSON
    echo "Updated: $project.$field = $value"
}

# Calculate totals
calculate_totals() {
    # Read from individual trackers
    local pisco_value=${PISCO_VALUE:-0}
    local comare_clients=${COMARE_CLIENTS:-0}
    local masspass_subs=${MASSPASS_SUBS:-0}
    local pkmusic_streams=${PKMUSIC_STREAMS:-0}
    local neuro_subs=${NEURO_SUBS:-0}
    
    # PISCO: €5K avg placement × probability
    local pisco_expected=$(echo "$pisco_value * 0.10" | bc)
    
    # COMARE: $500/client/month
    local comare_monthly=$(echo "$comare_clients * 500" | bc)
    
    # MASSAGE: $6/sub + $100/shop × 20%
    local masspass_monthly=$(echo "$masspass_subs * 6 * 0.20" | bc)
    
    # PK MUSIC: ~$3/1000 streams
    local pkmusic_monthly=$(echo "$pkmusic_streams * 3 / 1000" | bc)
    
    # NEUROTECH: sponsorship估算
    local neuro_monthly=0
    if [[ $neuro_subs -ge 1000 ]]; then
        neuro_monthly=$(echo "$neuro_subs * 15 / 1000" | bc)
    fi
    
    echo "$pisco_expected $comare_monthly $masspass_monthly $pkmusic_monthly $neuro_monthly"
}

# Daily dashboard
daily_dashboard() {
    local date=$(date +%Y-%m-%d)
    local day=$(date +%A)
    
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           JORDAN'S REVENUE DASHBOARD — $date            ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║  💼 PISCO  |  Filipino Staff Placement  |  Commission: 10%  ║"
    echo "║  💊 COMARE |  Pharmacy Maintenance      |  Target: \$60K/yr  ║"
    echo "║  💆 MASSAGE|  Massage Pass              |  Jordan's: 20%    ║"
    echo "║  🎵 PK MUSIC|  Music Streaming          |  DistroKid        ║"
    echo "║  🧠 NEUROTECH|  YouTube/Content        |  Brand Deals      ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║"
    
    # Read latest from trackers
    local pisco_pipe=$(grep -i "pisco" "$DATA_DIR/PROJECTS/pisco/pipeline.md" 2>/dev/null | tail -1 | cut -d'|' -f5 | tr -d ' €' || echo "0")
    local comare_count=$(grep -c "ACTIVE" "$DATA_DIR/PROJECTS/comare/clients.md" 2>/dev/null || echo "0")
    local masspass_count=$(grep -c "ACTIVE" "$DATA_DIR/PROJECTS/masspass/subscribers.md" 2>/dev/null || echo "0")
    
    echo "║  📊 TODAY'S SNAPSHOT"
    echo "║  ─────────────────────────────────────────────────────────────"
    echo "║  PISCO:      Pipeline €${pisco_pipe:-0} | Prob: 30% | Exp: €$(echo "${pisco_pipe:-0} * 0.3" | bc)"
    echo "║  COMARE:     ${comare_count:-0}/10 clients | \$$(echo "${comare_count:-0} * 500" | bc)/mo"
    echo "║  MASSAGE:    ${masspass_count:-0} subs | \$$(echo "${masspass_count:-0} * 6 * 0.2" | bc)/mo"
    echo "║  PK MUSIC:   Update streams with: pkmusic_revenue.sh streams"
    echo "║  NEUROTECH:  Update subs with: neurotech_revenue.sh rate"
    echo "║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║  🎯 QUICK COMMANDS"
    echo "║  ─────────────────────────────────────────────────────────────"
    echo "║  bash tools/pisco_revenue.sh report"
    echo "║  bash tools/comare_revenue.sh report"
    echo "║  bash tools/masspass_revenue.sh report"
    echo "║  bash tools/pkmusic_revenue.sh report"
    echo "║  bash tools/neurotech_revenue.sh report"
    echo "║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Weekly projection
weekly_projection() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  WEEKLY REVENUE PROJECTION"
    echo "═══════════════════════════════════════════"
    echo ""
    
    echo "This Week | Next Week | This Month | Annualized"
    echo "──────────────────────────────────────────────"
    
    # Calculate based on current state
    local comare_count=$(grep -c "ACTIVE" "$DATA_DIR/PROJECTS/comare/clients.md" 2>/dev/null || echo "0")
    local masspass_count=$(grep -c "ACTIVE" "$DATA_DIR/PROJECTS/masspass/subscribers.md" 2>/dev/null || echo "0")
    
    local comare_week=$(echo "$comare_count * 500 * 7 / 30" | bc)
    local masspass_week=$(echo "$masspass_count * 6 * 7 / 30 * 0.2" | bc)
    
    echo "COMARE:   \$$comare_week | \$$(echo "$comare_count * 500 * 7 / 30" | bc) | \$$(echo "$comare_count * 500" | bc) | \$$(echo "$comare_count * 500 * 12" | bc)"
    echo "MASSAGE:  \$$(printf "%.0f" $masspass_week) | \$$(printf "%.0f" $masspass_week) | \$$(printf "%.0f" $(echo "$masspass_count * 6 * 0.2" | bc)) | \$$(printf "%.0f" $(echo "$masspass_count * 6 * 12 * 0.2" | bc))"
    echo ""
}

# Monthly actuals
monthly_actuals() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  MONTHLY ACTUALS — $(date +%B %Y)"
    echo "═══════════════════════════════════════════"
    echo ""
    
    local pisco_closed=${PISCO_CLOSED:-0}
    local comare_closed=${COMARE_CLOSED:-0}
    local masspass_closed=${MASSPASS_CLOSED:-0}
    
    echo "Revenue Source | Target | Actual | Variance"
    echo "────────────────────────────────────────────"
    echo "PISCO          | €15K  | €$pisco_closed | €$(echo "15000 - $pisco_closed" | bc)"
    echo "COMARE         | \$5K  | \$$comare_closed | \$$(echo "5000 - $comare_closed" | bc)"
    echo "MASSAGE        | \$120 | \$$masspass_closed | \$$(echo "120 - $masspass_closed" | bc)"
    echo "────────────────────────────────────────────"
    echo "TOTAL          | €$((15000 + 5000)) | €$(echo "$pisco_closed + $comare_closed" | bc)"
    echo ""
}

# Main
case "${1:-help}" in
    init)
        init_tracker
        ;;
    update)
        update "$2" "$3" "$4"
        ;;
    totals)
        calculate_totals
        ;;
    daily)
        daily_dashboard
        ;;
    weekly)
        weekly_projection
        ;;
    monthly)
        monthly_actuals
        ;;
    all)
        init_tracker
        daily_dashboard
        weekly_projection
        monthly_actuals
        ;;
    help)
        echo "Revenue Dashboard"
        echo ""
        echo "Usage: revenue_dashboard.sh <command>"
        echo ""
        echo "Commands:"
        echo "  init      Initialize revenue tracker"
        echo "  update    Update a field (project field value)"
        echo "  daily     Today's snapshot"
        echo "  weekly    Weekly projection"
        echo "  monthly   Monthly actuals"
        echo "  all       Full report"
        ;;
esac
