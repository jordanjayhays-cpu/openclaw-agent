#!/bin/bash
# NEUROTECH Revenue Machine
# YouTube & Content Creator Revenue
# Target: 10K subs = brand deals

set -e

DATA_DIR="/data/workspace/PROJECTS/neurotech"
TRACKER="$DATA_DIR/content.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[NEUROTECH]${NC} $1"; }
success() { echo -e "${GREEN}[NEUROTECH]${NC} $1"; }
warn() { echo -e "${YELLOW}[NEUROTECH]${NC} $1"; }
error() { echo -e "${RED}[NEUROTECH]${NC} $1"; }

# Constants (YouTube CPM varies $2-10, use $4 avg)
YOUTUBE_CPM=${YOUTUBE_CPM:-4}
WATCH_HOUR_VALUE=${WATCH_HOUR_VALUE:-0.05}

# Init
init() {
    mkdir -p "$DATA_DIR"/{videos,sponsorships,merchandise}
    
    if [[ ! -f "$TRACKER" ]]; then
        cat > "$TRACKER" << 'EOF'
# NEUROTECH Content Tracker

## Revenue Model
| Source | Rate | Notes |
|--------|------|-------|
| YouTube AdSense | ~$4 CPM | Varies by niche |
| Sponsorships | $10-100/post | Per 1K subs |
| Affiliate | 5-20% commission | Neurotech products |
| Merch | 30-50% margin | Custom designs |

## Milestones
- [ ] 1,000 subscribers (monetization eligible)
- [ ] 10,000 subscribers (brand deals start)
- [ ] 100,000 subscribers (serious income)

## Content Performance
| Date | Video | Views | Watch Time | Revenue |
|------|-------|-------|------------|---------|
EOF
    fi
    
    if [[ ! -f "$DATA_DIR/sponsorships/deals.md" ]]; then
        cat > "$DATA_DIR/sponsorships/deals.md" << 'EOF'
# NEUROTECH Sponsorships

| Date | Brand | Offer | Status | Value |
|------|-------|-------|--------|-------|
EOF
    fi
}

# Log video performance
log_video() {
    local title="$1"
    local views="$2"
    local watch_hours="$3"
    
    if [[ -z "$title" || -z "$views" ]]; then
        error "Usage: log-video <title> <views> [watch_hours]"
        return 1
    fi
    
    watch_hours=${watch_hours:-0}
    
    # Estimate revenue
    local cpm=$(echo "$views * $YOUTUBE_CPM / 1000" | bc)
    local watch_value=$(echo "$watch_hours * $WATCH_HOUR_VALUE" | bc)
    local revenue=$(echo "$cpm + $watch_value" | bc)
    
    cat >> "$TRACKER" << EOF
| $(date +%Y-%m-%d) | $title | $views | ${watch_hours}h | \$$(printf "%.2f" $revenue) |
EOF
    success "Logged: '$title' - $views views = \$$(printf "%.2f" $revenue)"
}

# Calculate YouTube revenue
calculate_youtube() {
    local views="${1:-0}"
    local cpm="${2:-$YOUTUBE_CPM}"
    
    local daily=$(echo "scale=2; $views * $cpm / 1000" | bc)
    local monthly=$(echo "scale=2; $daily * 30" | bc)
    local yearly=$(echo "scale=2; $monthly * 12" | bc)
    
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  NEUROTECH YOUTUBE REVENUE"
    echo "═══════════════════════════════════════════"
    echo "  Daily views: $views"
    echo "  CPM: \$$cpm"
    echo ""
    echo "  💰 REVENUE ESTIMATES"
    echo "  Daily:    \$$daily"
    echo "  Monthly:  \$$monthly"
    echo "  Yearly:   \$$yearly"
    echo ""
    echo "  📊 View Milestones:"
    echo "  1K/day → \$4/month"
    echo "  10K/day → \$120/month"
    echo "  100K/day → \$1,200/month"
    echo "═══════════════════════════════════════════"
    echo ""
}

# Sponsorship tracker
add_sponsorship() {
    local brand="$1"
    local offer="${2:-0}"
    local status="${3:-PENDING}"
    
    if [[ -z "$brand" ]]; then
        error "Usage: add-sponsorship <brand> [offer] [status]"
        return 1
    fi
    
    cat >> "$DATA_DIR/sponsorships/deals.md" << EOF
| $(date +%Y-%m-%d) | $brand | Sponsorship | $status | \$$offer |
EOF
    success "Added sponsorship: $brand - \$$offer ($status)"
}

# Sponsorship rate calculator
sponsorship_rate() {
    local subs="${1:-0}"
    
    # Industry standard: $10-25 per 1K subs per post
    local low=$(echo "scale=2; $subs * 10 / 1000" | bc)
    local high=$(echo "scale=2; $subs * 25 / 1000" | bc)
    local typical=$(echo "scale=2; $subs * 15 / 1000" | bc)
    
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  SPONSORSHIP RATE ESTIMATES"
    echo "═══════════════════════════════════════════"
    echo "  Subscribers: $subs"
    echo ""
    echo "  💰 Per-Post Rate:"
    echo "  Conservative: \$$low"
    echo "  Typical:      \$$typical"
    echo "  Premium:       \$$high"
    echo ""
    echo "  📊 Milestone Rates:"
    echo "  1K subs → \$15/post"
    echo "  10K subs → \$150/post"
    echo "  100K subs → \$1,500/post"
    echo "═══════════════════════════════════════════"
    echo ""
}

# Track affiliate links
add_affiliate() {
    local product="$1"
    local commission="$2"
    
    if [[ -z "$product" || -z "$commission" ]]; then
        error "Usage: add-affiliate <product> <commission_percent>"
        return 1
    fi
    
    local aff_file="$DATA_DIR/affiliate.md"
    
    if [[ ! -f "$aff_file" ]]; then
        cat > "$aff_file" << 'EOF'
# NEUROTECH Affiliate Links

| Product | Commission | Clicks | Sales | Revenue |
|---------|------------|--------|-------|---------|
EOF
    fi
    
    cat >> "$aff_file" << EOF
| $product | ${commission}% | 0 | 0 | \$0 |
EOF
    success "Added affiliate: $product at ${commission}% commission"
}

# Daily report
daily_report() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  NEUROTECH REPORT — $(date +%Y-%m-%d)"
    echo "═══════════════════════════════════════════"
    echo ""
    
    echo "🎯 CONTENT MILESTONES"
    echo "  ⬜ 1K subscribers (monetization)"
    echo "  ⬜ 10K subscribers (brand deals)"
    echo "  ⬜ 100K subscribers (\$3K+/month)"
    echo ""
    
    echo "💡 REVENUE STREAMS"
    echo "  1. YouTube AdSense"
    echo "  2. Sponsorships"
    echo "  3. Affiliate (neurotech products)"
    echo "  4. Merchandise"
    echo ""
    
    echo "📋 NEXT ACTIONS"
    echo "  ⬜ Set up YouTube channel"
    echo "  ⬜ Create content calendar"
    echo "  ⬜ Research neurotech affiliate programs"
    echo ""
}

# Main
case "${1:-help}" in
    init)
        init
        ;;
    video)
        log_video "$2" "$3" "$4"
        ;;
    youtube)
        calculate_youtube "$2" "$3"
        ;;
    sponsorship)
        add_sponsorship "$2" "$3" "$4"
        ;;
    rate)
        sponsorship_rate "$2"
        ;;
    affiliate)
        add_affiliate "$2" "$3"
        ;;
    report)
        daily_report
        ;;
    help)
        echo "NEUROTECH Revenue Machine"
        echo ""
        echo "Usage: neurotech_revenue.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init                      Initialize directories"
        echo "  video <title> <views> [hrs]  Log video performance"
        echo "  youtube [views] [cpm]     Calculate YouTube revenue"
        echo "  sponsorship <brand> [\$] [status]  Add deal"
        echo "  rate [subs]               Calculate sponsorship rates"
        echo "  affiliate <product> <%>   Add affiliate program"
        echo "  report                    Daily report"
        ;;
esac
