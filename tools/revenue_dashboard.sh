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
EOF
    fi
}

# Safe count of lines matching pattern
safe_count() {
    local pattern="$1"
    local file="$2"
    local count
    count=$(grep -c "$pattern" "$file" 2>/dev/null || true)
    echo "${count:-0}"
}

# Daily dashboard
daily_dashboard() {
    local date=$(date +%Y-%m-%d)
    
    # Read latest from trackers
    local pisco_pipe=0
    local comare_count=$(safe_count "ACTIVE" "$DATA_DIR/PROJECTS/comare/clients.md")
    local masspass_count=$(safe_count "ACTIVE" "$DATA_DIR/PROJECTS/masspass/subscribers.md")
    
    # Calculate values
    local pisco_exp=0
    local comare_month=0
    local masspass_month=0
    
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
    echo "║  📊 TODAY'S SNAPSHOT"
    echo "║  ─────────────────────────────────────────────────────────────"
    echo "║  PISCO:      Pipeline €${pisco_pipe} | Prob: 30% | Exp: €$pisco_exp"
    echo "║  COMARE:     ${comare_count}/10 clients | \$${comare_month}/mo"
    echo "║  MASSAGE:    ${masspass_count} subs | \$${masspass_month}/mo"
    echo "║  PK MUSIC:   Update: bash tools/pkmusic_revenue.sh streams"
    echo "║  NEUROTECH:  Update: bash tools/neurotech_revenue.sh rate"
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
    local comare_count=$(safe_count "ACTIVE" "$DATA_DIR/PROJECTS/comare/clients.md")
    local masspass_count=$(safe_count "ACTIVE" "$DATA_DIR/PROJECTS/masspass/subscribers.md")
    
    # Simple integer math for display
    local comare_week=$((comare_count * 500 * 7 / 30))
    local masspass_week=$((masspass_count * 6 * 7 / 30 * 20 / 100))
    
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  WEEKLY REVENUE PROJECTION"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "This Week | Next Week | This Month | Annualized"
    echo "──────────────────────────────────────────────"
    echo "COMARE:   \$$comare_week | \$$comare_week | \$$((comare_count * 500)) | \$$((comare_count * 500 * 12))"
    echo "MASSAGE:  \$$masspass_week | \$$masspass_week | \$$((masspass_count * 6 * 20 / 100)) | \$$((masspass_count * 6 * 12 * 20 / 100))"
    echo ""
}

# Monthly actuals
monthly_actuals() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  MONTHLY ACTUALS — $(date +%B %Y)"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Revenue Source | Target | Actual | Variance"
    echo "────────────────────────────────────────────"
    echo "PISCO          | €15K  | €0     | €15000"
    echo "COMARE         | \$5K  | \$0     | \$5000"
    echo "MASSAGE        | \$120 | \$0     | \$120"
    echo "────────────────────────────────────────────"
    echo "TOTAL          | €\$20K | €0     | €20000"
    echo ""
}

# Main
case "${1:-help}" in
    init)
        init_tracker
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
        echo "  daily     Today's snapshot"
        echo "  weekly    Weekly projection"
        echo "  monthly   Monthly actuals"
        echo "  all       Full report"
        ;;
esac
