#!/bin/bash
# MASSAGE-PASS Revenue Machine
# Subscription-based massage service
# Jordan's cut: 20%

set -e

DATA_DIR="/data/workspace/PROJECTS/masspass"
TRACKER="$DATA_DIR/subscribers.md"
WAITLIST="$DATA_DIR/waitlist.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[MASS-PASS]${NC} $1"; }
success() { echo -e "${GREEN}[MASS-PASS]${NC} $1"; }
warn() { echo -e "${YELLOW}[MASS-PASS]${NC} $1"; }
error() { echo -e "${RED}[MASS-PASS]${NC} $1"; }

# Constants
SUBSCRIBER_PRICE=${SUBSCRIBER_PRICE:-6}
SHOP_FEE=${SHOP_FEE:-100}
JORDAN_CUT=${JORDAN_CUT:-0.20}
TARGET_SUBS=100

# Init
init() {
    mkdir -p "$DATA_DIR"/{subscribers,shops,revenue}
    
    if [[ ! -f "$TRACKER" ]]; then
        cat > "$TRACKER" << 'EOF'
# MASSAGE-PASS Subscriber Tracker

## Revenue Model
- Subscriber pays: $6/month
- Shop pays: $100/month (featured listing)
- Jordan's cut: 20%

## Projections
- 100 subscribers = $600/month gross → $120 Jordan
- 100 subscribers + 10 shops = $600 + $1,000 = $1,600/month

## Funnel
WAITLIST → LAUNCH → RETAIN

## Active Subscribers
| # | Name | Email | Start Date | Status | Monthly |
|---|------|-------|------------|--------|---------|
EOF
    fi
    
    if [[ ! -f "$WAITLIST" ]]; then
        cat > "$WAITLIST" << 'EOF'
# MASSAGE-PASS Waitlist

| # | Name | Email | Joined | Source | Converted |
|---|------|-------|--------|--------|-----------|
EOF
    fi
}

# Add to waitlist
add_waitlist() {
    local name="$1"
    local email="$2"
    local source="${3:-direct}"
    
    if [[ -z "$name" || -z "$email" ]]; then
        error "Usage: add-waitlist <name> <email> [source]"
        return 1
    fi
    
    local id=$(date +%s)
    cat >> "$WAITLIST" << EOF
| $id | $name | $email | $(date +%Y-%m-%d) | $source | NO |
EOF
    success "Added to waitlist: $name ($email)"
}

# Convert waitlist to subscriber
convert_subscriber() {
    local id="$1"
    
    if [[ -z "$id" ]]; then
        error "Usage: convert-subscriber <waitlist_id>"
        return 1
    fi
    
    local data=$(grep "| $id |" "$WAITLIST")
    local name=$(echo "$data" | cut -d'|' -f3 | tr -d ' ')
    local email=$(echo "$data" | cut -d'|' -f4 | tr -d ' ')
    
    sed -i "s/| $id |/| $id */" "$WAITLIST"
    sed -i "s/| $id |/| $id */" "$WAITLIST"
    echo "| Converted $(date +%Y-%m-%d) |" >> "$WAITLIST"
    
    # Add to subscribers
    local sub_id=$(date +%s)
    cat >> "$TRACKER" << EOF
| $sub_id | $name | $email | $(date +%Y-%m-%d) | ACTIVE | $SUBSCRIBER_PRICE |
EOF
    success "Converted $name to subscriber!"
}

# Add shop
add_shop() {
    local name="$1"
    local contact="$2"
    local email="$3"
    
    if [[ -z "$name" || -z "$contact" || -z "$email" ]]; then
        error "Usage: add-shop <name> <contact> <email>"
        return 1
    fi
    
    local id=$(date +%s)
    local shops_file="$DATA_DIR/shops/shops.md"
    mkdir -p "$DATA_DIR/shops"
    
    if [[ ! -f "$shops_file" ]]; then
        cat > "$shops_file" << 'EOF'
# MASSAGE-PASS Partner Shops

| # | Shop | Contact | Email | Join Date | Fee | Status |
|---|------|---------|-------|-----------|-----|--------|
EOF
    fi
    
    cat >> "$shops_file" << EOF
| $id | $name | $contact | $email | $(date +%Y-%m-%d) | $SHOP_FEE | ACTIVE |
EOF
    success "Added shop: $name - \$$SHOP_FEE/month"
}

# Revenue calculator
calculate_revenue() {
    local subs="${1:-0}"
    local shops="${2:-0}"
    
    local subs_revenue=$(echo "$subs * $SUBSCRIBER_PRICE" | bc)
    local shops_revenue=$(echo "$shops * $SHOP_FEE" | bc)
    local gross=$(echo "$subs_revenue + $shops_revenue" | bc)
    local jordan=$(echo "$gross * $JORDAN_CUT" | bc)
    
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  MASSAGE-PASS REVENUE PROJECTION"
    echo "═══════════════════════════════════════════"
    echo "  Subscribers:      $subs × \$$SUBSCRIBER_PRICE = \$$subs_revenue"
    echo "  Shops:            $shops × \$$SHOP_FEE = \$$shops_revenue"
    echo "  ─────────────────────────────────────"
    echo "  Gross Revenue:   \$$gross/month"
    echo "  Jordan's Cut:    \$$jordan/month (20%)"
    echo "  ─────────────────────────────────────"
    echo "  Annual Jordan:   \$$(echo "$jordan * 12" | bc)"
    echo ""
    echo "  To target (\$$(echo "$TARGET_SUBS * $SUBSCRIBER_PRICE" | bc)/mo):"
    echo "  Need $(( TARGET_SUBS - subs )) more subscribers"
    echo "═══════════════════════════════════════════"
    echo ""
}

# Daily report
daily_report() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  MASSAGE-PASS REPORT — $(date +%Y-%m-%d)"
    echo "═══════════════════════════════════════════"
    echo ""
    
    local sub_count=$(grep -c "ACTIVE" "$TRACKER" 2>/dev/null || true)
    local waitlist_count=$(grep -c "NO" "$WAITLIST" 2>/dev/null || true)
    local shops_count=$(grep -c "ACTIVE" "$DATA_DIR/shops/shops.md" 2>/dev/null || true)
    
    echo "📊 FUNNEL STATUS"
    echo "  Waitlist: $waitlist_count"
    echo "  Active subs: $sub_count"
    echo "  Partner shops: $shops_count"
    echo ""
    
    calculate_revenue "$sub_count" "$shops_count"
    
    echo "🎯 LAUNCH CHECKLIST"
    echo "  ⬜ Pre-launch: Build waitlist to 100+"
    echo "  ⬜ Launch: Email waitlist → convert 20%"
    echo "  ⬜ Retain: Monthly engagement campaigns"
    echo ""
}

# Main
case "${1:-help}" in
    init)
        init
        ;;
    waitlist)
        add_waitlist "$2" "$3" "$4"
        ;;
    convert)
        convert_subscriber "$2"
        ;;
    add-shop)
        add_shop "$2" "$3" "$4"
        ;;
    revenue)
        calculate_revenue "$2" "$3"
        ;;
    report)
        daily_report
        ;;
    help)
        echo "MASSAGE-PASS Revenue Machine"
        echo ""
        echo "Usage: masspass_revenue.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init                  Initialize directories"
        echo "  waitlist <n> <e> [s]  Add to waitlist (name email source)"
        echo "  convert <id>          Convert waitlist → subscriber"
        echo "  add-shop <n> <c> <e>  Add partner shop"
        echo "  revenue [subs] [shops]  Calculate revenue"
        echo "  report                Daily report"
        ;;
esac
