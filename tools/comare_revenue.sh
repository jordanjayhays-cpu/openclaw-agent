#!/bin/bash
# COMARE Revenue Machine
# Maintenance Services for Pharmacies
# Target: 10 clients = $60K/year

set -e

DATA_DIR="/data/workspace/PROJECTS/comare"
TRACKER="$DATA_DIR/clients.md"
INVOICES="$DATA_DIR/invoices"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[COMARE]${NC} $1"; }
success() { echo -e "${GREEN}[COMARE]${NC} $1"; }
warn() { echo -e "${YELLOW}[COMARE]${NC} $1"; }
error() { echo -e "${RED}[COMARE]${NC} $1"; }

# Constants
MONTHLY_RETAINER=${MONTHLY_RETAINER:-500}
TARGET_CLIENTS=10
TARGET_ANNUAL=60000

# Init
init() {
    mkdir -p "$DATA_DIR"/{clients,invoices,service_logs}
    
    if [[ ! -f "$TRACKER" ]]; then
        cat > "$TRACKER" << 'EOF'
# COMARE Client Tracker

## Revenue Model
- Monthly retainer: $500/client
- Annual per client: $6,000
- Target: 10 clients = $60,000/year

## Milestones
- [ ] First client (MVP)
- [ ] 5 clients ($30K/year)
- [ ] 10 clients ($60K/year)

## Active Clients
| # | Pharmacy | Contact | Email | Start Date | Monthly | Status | Notes |
|---|----------|---------|-------|------------|---------|--------|-------|
EOF
    fi
}

# Add client
add_client() {
    local pharmacy="$1"
    local contact="$2"
    local email="$3"
    local start_date="${4:-$(date +%Y-%m-%d)}"
    
    if [[ -z "$pharmacy" || -z "$contact" || -z "$email" ]]; then
        error "Usage: add-client <pharmacy> <contact> <email> [start_date]"
        return 1
    fi
    
    local id=$(date +%s)
    
    cat >> "$TRACKER" << EOF
| $id | $pharmacy | $contact | $email | $start_date | $MONTHLY_RETAINER | ACTIVE | New client |
EOF
    success "Added client: $pharmacy - $MONTHLY_RETAINER/month"
    update_milestones
}

# Update status
update_status() {
    local id="$1"
    local status="$2"
    sed -i "s/| $id |/| $id */" "$TRACKER"
    echo "* Status: $status on $(date +%Y-%m-%d)" >> "$TRACKER"
    success "Client $id → $status"
}

# Revenue calculator (uses awk instead of bc)
calculate_revenue() {
    local clients="${1:-0}"
    local monthly=$(awk "BEGIN {printf \"%.0f\", $clients * $MONTHLY_RETAINER}")
    local annual=$(awk "BEGIN {printf \"%.0f\", $clients * $MONTHLY_RETAINER * 12}")
    local to_target=$(awk "BEGIN {printf \"%.0f\", $TARGET_ANNUAL - $clients * $MONTHLY_RETAINER * 12}")
    local progress=$(awk "BEGIN {printf \"%.1f\", $clients * $MONTHLY_RETAINER * 12 * 100 / $TARGET_ANNUAL}")
    
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  COMARE REVENUE PROJECTION"
    echo "═══════════════════════════════════════════"
    echo "  Clients:     $clients"
    echo "  Monthly:     \$$monthly"
    echo "  Annual:      \$$annual"
    echo "  To target:   \$$to_target to go"
    echo "  Progress:    ${progress}%"
    echo "═══════════════════════════════════════════"
    echo ""
}

# Milestone tracker
update_milestones() {
    local client_count=$(grep -c "ACTIVE" "$TRACKER" 2>/dev/null || true)
    
    if [[ "$client_count" -ge 1 ]]; then
        sed -i 's/- \[ \] First client/- [x] First client/' "$TRACKER" 2>/dev/null
    fi
    if [[ "$client_count" -ge 5 ]]; then
        sed -i 's/- \[ \] 5 clients/- [x] 5 clients/' "$TRACKER" 2>/dev/null
    fi
    if [[ "$client_count" -ge 10 ]]; then
        sed -i 's/- \[ \] 10 clients/- [x] 10 clients/' "$TRACKER" 2>/dev/null
    fi
}

# Log service
log_service() {
    local client="$1"
    local service_type="$2"
    local date=$(date +%Y-%m-%d)
    local log_file="$DATA_DIR/service_logs/${client// /_}_log.md"
    
    echo "| $date | $service_type | Completed |" >> "$log_file"
    success "Logged service for $client: $service_type"
}

# Generate invoice
generate_invoice() {
    local client="$1"
    local month="${2:-$(date +%Y-%m)}"
    local amount="${3:-$MONTHLY_RETAINER}"
    
    mkdir -p "$INVOICES"
    local invoice_file="$INVOICES/${client// /_}_${month}.md"
    
    cat > "$invoice_file" << EOF
# INVOICE

**COMARE Maintenance Services**
Date: $(date +%Y-%m-%d)
Due: $(date -d "+30 days" +%Y-%m-%d)

---

**Bill To:** $client
**Period:** $month

| Service | Amount |
|---------|--------|
| Monthly Maintenance | $amount |
| **Total** | **$$amount** |

---

Payment details: [BANK DETAILS]
Reference: COMARE-$month

*Thank you for your business!*
EOF
    success "Invoice generated: $invoice_file"
    echo "$invoice_file"
}

# Daily report
daily_report() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  COMARE REVENUE REPORT — $(date +%Y-%m-%d)"
    echo "═══════════════════════════════════════════"
    echo ""
    
    local client_count=$(grep -c "ACTIVE" "$TRACKER" 2>/dev/null || true)
    local monthly=$(awk "BEGIN {printf \"%.0f\", $client_count * $MONTHLY_RETAINER}")
    local annual=$(awk "BEGIN {printf \"%.0f\", $client_count * $MONTHLY_RETAINER * 12}")
    local gap=$(awk "BEGIN {printf \"%.0f\", $TARGET_ANNUAL - $client_count * $MONTHLY_RETAINER * 12}")
    
    echo "📊 CLIENT METRICS"
    echo "  Active clients: $client_count / $TARGET_CLIENTS"
    echo "  Monthly revenue: \$$monthly"
    echo "  Annual revenue: \$$annual"
    echo "  Target gap: \$$gap"
    echo ""
    
    echo "🎯 MILESTONES"
    if [[ "$client_count" -ge 1 ]]; then
        echo "  ✅ First client achieved!"
    else
        echo "  ⬜ First client (MVP)"
    fi
    if [[ "$client_count" -ge 5 ]]; then
        echo "  ✅ 5 clients (\$30K/year)"
    else
        echo "  ⬜ 5 clients (\$30K/year)"
    fi
    if [[ "$client_count" -ge 10 ]]; then
        echo "  ✅ 10 clients (\$60K/year)"
    else
        echo "  ⬜ 10 clients (\$60K/year)"
    fi
    echo ""
}

# Main
case "${1:-help}" in
    init)
        init
        ;;
    add-client)
        add_client "$2" "$3" "$4" "$5"
        ;;
    status)
        update_status "$2" "$3"
        ;;
    revenue)
        calculate_revenue "${2:-1}"
        ;;
    invoice)
        generate_invoice "$2" "$3" "$4"
        ;;
    log)
        log_service "$2" "$3"
        ;;
    report)
        daily_report
        ;;
    help)
        echo "COMARE Revenue Machine"
        echo ""
        echo "Usage: comare_revenue.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init                Initialize COMARE directories"
        echo "  add-client          Add new client (pharmacy contact email [date])"
        echo "  status <id> <stat>  Update client status"
        echo "  revenue [clients]   Calculate revenue projection"
        echo "  invoice <client> [month] [amount]  Generate invoice"
        echo "  log <client> <type>  Log service performed"
        echo "  report              Daily revenue report"
        ;;
esac
