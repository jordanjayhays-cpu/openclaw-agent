#!/bin/bash
# PK MUSIC Revenue Machine
# Music streaming & royalties tracking
# Target: 100K streams = $300/month

set -e

DATA_DIR="/data/workspace/PROJECTS/pkmusic"
TRACKER="$DATA_DIR/streaming.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[PK MUSIC]${NC} $1"; }
success() { echo -e "${GREEN}[PK MUSIC]${NC} $1"; }
warn() { echo -e "${YELLOW}[PK MUSIC]${NC} $1"; }
error() { echo -e "${RED}[PK MUSIC]${NC} $1"; }

# Constants (industry standard rates)
SPOTIFY_RATE=${SPOTIFY_RATE:-0.003}  # $0.003/stream
APPLE_RATE=${APPLE_RATE:-0.008}       # $0.008/stream
AMAZON_RATE=${AMAZON_RATE:-0.004}     # $0.004/stream
YOUTUBE_RATE=${YOUTUBE_RATE:-0.002}   # $0.002/stream

# Init
init() {
    mkdir -p "$DATA_DIR"/{streams,royalties,merch}
    
    if [[ ! -f "$TRACKER" ]]; then
        cat > "$TRACKER" << 'EOF'
# PK MUSIC Streaming Tracker

## Revenue Model
| Platform | Rate/Stream | 100K streams |
|----------|-------------|--------------|
| Spotify  | $0.003      | $300         |
| Apple    | $0.008      | $800         |
| Amazon   | $0.004      | $400         |
| YouTube  | $0.002      | $200         |

## Targets
- [ ] 1,000 streams (proof of concept)
- [ ] 10,000 streams (~$30/month)
- [ ] 100,000 streams (~$300/month)
- [ ] 1M streams (~$3,000/month)

## Track Streaming History
| Date | Track | Platform | Streams | Revenue |
|------|-------|----------|---------|---------|
EOF
    fi
    
    if [[ ! -f "$DATA_DIR/merch/merch.md" ]]; then
        cat > "$DATA_DIR/merch/merch.md" << 'EOF'
# PK MUSIC Merchandise

## Active Items
| Item | Price | Sold | Revenue |
|------|-------|------|---------|
EOF
    fi
}

# Log streams
log_streams() {
    local track="$1"
    local platform="$2"
    local count="$3"
    
    if [[ -z "$track" || -z "$platform" || -z "$count" ]]; then
        error "Usage: log-streams <track> <platform> <count>"
        return 1
    fi
    
    local rate_var="${platform}_RATE"
    local rate=${!rate_var}
    local revenue=$(echo "$count * $rate" | bc)
    
    cat >> "$TRACKER" << EOF
| $(date +%Y-%m-%d) | $track | $platform | $count | \$$(printf "%.2f" $revenue) |
EOF
    success "Logged: $track on $platform - $count streams = \$$(printf "%.2f" $revenue)"
}

# Calculate royalties
calculate_royalties() {
    local total_streams="${1:-0}"
    
    local spotify=$(echo "scale=2; $total_streams * $SPOTIFY_RATE" | bc)
    local apple=$(echo "scale=2; $total_streams * $APPLE_RATE" | bc)
    local amazon=$(echo "scale=2; $total_streams * $AMAZON_RATE" | bc)
    local youtube=$(echo "scale=2; $total_streams * $YOUTUBE_RATE" | bc)
    
    # Assume 50% Spotify, 25% Apple, 15% Amazon, 10% YouTube
    local total=$(echo "scale=2; $spotify * 0.5 + $apple * 0.25 + $amazon * 0.15 + $youtube * 0.1" | bc)
    
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  PK MUSIC ROYALTY PROJECTION"
    echo "═══════════════════════════════════════════"
    echo "  Based on $total_streams total streams:"
    echo ""
    echo "  Platform  |  Est. Monthly"
    echo "  ─────────────────────────"
    echo "  Spotify   |  \$$spotify"
    echo "  Apple     |  \$$apple"
    echo "  Amazon   |  \$$amazon"
    echo "  YouTube   |  \$$youtube"
    echo "  ─────────────────────────"
    echo "  TOTAL     |  \$$total"
    echo ""
    echo "  📊 At 100K streams: ~\$300/month"
    echo "  📊 At 1M streams: ~\$3,000/month"
    echo "═══════════════════════════════════════════"
    echo ""
}

# Add merch item
add_merch() {
    local item="$1"
    local price="$2"
    
    if [[ -z "$item" || -z "$price" ]]; then
        error "Usage: add-merch <item> <price>"
        return 1
    fi
    
    cat >> "$DATA_DIR/merch/merch.md" << EOF
| $item | \$$price | 0 | \$0 |
EOF
    success "Added merch: $item - \$$price"
}

# Log merch sale
log_merch_sale() {
    local item="$1"
    local quantity="${2:-1}"
    
    if [[ -z "$item" ]]; then
        error "Usage: log-merch-sale <item> [quantity]"
        return 1
    fi
    
    # Find price and update
    local price=$(grep "| $item |" "$DATA_DIR/merch/merch.md" | head -1 | cut -d'|' -f3 | tr -d ' $')
    local sold=$(grep "| $item |" "$DATA_DIR/merch/merch.md" | head -1 | cut -d'|' -f4 | tr -d ' $')
    local new_sold=$(echo "$sold + $quantity" | bc)
    local revenue=$(echo "$price * $new_sold" | bc)
    
    sed -i "s/| $item | \$$price | $sold |/|$item | \$$price | $new_sold | \$$revenue |/" "$DATA_DIR/merch/merch.md"
    success "Logged sale: $quantity× $item = \$$(echo "$price * $quantity" | bc)"
}

# DistroKid integration note
distrokid_status() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  DISTROKID INTEGRATION"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "  📋 Setup Steps:"
    echo "  1. Upload tracks to DistroKid"
    echo "  2. Connect Spotify for Artists"
    echo "  3. Enable YouTube Content ID"
    echo "  4. Monitor via DistroKid dashboard"
    echo ""
    echo "  🔗 Links:"
    echo "  - DistroKid: https://distrokid.com"
    echo "  - Spotify for Artists: https://artists.spotify.com"
    echo ""
    echo "  ⬜ TODO: Add API key for auto-sync"
    echo "═══════════════════════════════════════════"
    echo ""
}

# Daily report
daily_report() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  PK MUSIC REPORT — $(date +%Y-%m-%d)"
    echo "═══════════════════════════════════════════"
    echo ""
    
    if [[ -f "$TRACKER" ]]; then
        local total=$(tail -20 "$TRACKER" | grep "|" | wc -l)
        echo "📊 Recent entries: $total"
    fi
    
    echo ""
    echo "🎯 STREAMING TARGETS"
    echo "  ⬜ 1K streams (POC)"
    echo "  ⬜ 10K streams (\$30/mo)"
    echo "  ⬜ 100K streams (\$300/mo)"
    echo "  ⬜ 1M streams (\$3K/mo)"
    echo ""
    echo "💰 MERCH OPPORTUNITIES"
    echo "  ⬜ T-shirts, hoodies, vinyl"
    echo ""
}

# Main
case "${1:-help}" in
    init)
        init
        ;;
    streams)
        log_streams "$2" "$3" "$4"
        ;;
    royalties)
        calculate_royalties "$2"
        ;;
    merch)
        add_merch "$2" "$3"
        ;;
    sale)
        log_merch_sale "$2" "$3"
        ;;
    distrokid)
        distrokid_status
        ;;
    report)
        daily_report
        ;;
    help)
        echo "PK MUSIC Revenue Machine"
        echo ""
        echo "Usage: pkmusic_revenue.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init                Initialize directories"
        echo "  streams <t> <p> <c>  Log streams (track platform count)"
        echo "  royalties [total]   Calculate projection"
        echo "  merch <item> <\$>     Add merch item"
        echo "  sale <item> [qty]    Log merch sale"
        echo "  distrokid           Show DistroKid setup"
        echo "  report              Daily report"
        ;;
esac
