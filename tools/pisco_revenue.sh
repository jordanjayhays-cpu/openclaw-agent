#!/bin/bash
# PISCO Revenue Machine
# Business Development for Filipino Staff Placement
# Commission: 10% of deal value

set -e

DATA_DIR="/data/workspace/PROJECTS/pisco"
TRACKER="$DATA_DIR/pipeline.md"
LEADS="$DATA_DIR/leads.md"
CONTACTS="$DATA/workspace/contacts/CONTEXT.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[PISCO]${NC} $1"; }
success() { echo -e "${GREEN}[PISCO]${NC} $1"; }
warn() { echo -e "${YELLOW}[PISCO]${NC} $1"; }
error() { echo -e "${RED}[PISCO]${NC} $1"; }

# Ensure files exist
init() {
    mkdir -p "$DATA_DIR"/{invoices,proposals,contracts,sequences}
    
    if [[ ! -f "$TRACKER" ]]; then
        cat > "$TRACKER" << 'EOF'
# PISCO Pipeline Tracker

## Pipeline Summary
| Date | Lead | Stage | Value | Probability | Expected | Commission | Notes |
|------|------|-------|-------|-------------|----------|------------|-------|
EOF
    fi
    
    if [[ ! -f "$LEADS" ]]; then
        cat > "$LEADS" << 'EOF'
# PISCO Leads CRM

## Lead Status Legend
- [ ] NEW = Just entered
- [W] WARM = Initial contact made
- [H] HOT = Qualified, high intent
- [P] PROPOSAL = Proposal sent
- [N] NEGOTIATION = Contract stage
- [C] CLOSED = Deal won
- [L] LOST = Deal lost

## Active Leads
| # | Company | Contact | Email | Status | Est. Value | Notes |
|---|---------|---------|-------|--------|------------|-------|
EOF
    fi
}

# Add new lead
add_lead() {
    local company="$1"
    local contact="$2"
    local email="$3"
    local value="${4:-50000}"
    
    if [[ -z "$company" || -z "$contact" || -z "$email" ]]; then
        error "Usage: add_lead <company> <contact> <email> [value]"
        return 1
    fi
    
    local id=$(date +%s)
    local date=$(date +%Y-%m-%d)
    
    cat >> "$LEADS" << EOF
| $id | $company | $contact | $email | [ ] NEW | €$value | Added $date |
EOF
    success "Added lead: $company ($contact) - Est. value: €$value"
}

# Update lead stage
update_lead() {
    local id="$1"
    local new_stage="$2"
    
    if [[ -z "$id" || -z "$new_stage" ]]; then
        error "Usage: update_lead <id> <stage>"
        return 1
    fi
    
    sed -i "s/| $id |/| $id */" "$LEADS"
    echo "" >> "$LEADS"
    echo "* Stage updated to: $new_stage on $(date +%Y-%m-%d)" >> "$LEADS"
    success "Lead $id → $new_stage"
}

# Generate personalized pitch
generate_pitch() {
    local company="$1"
    local output_file="$DATA_DIR/pitches/${company// /_}_pitch_$(date +%Y%m%d).md"
    
    mkdir -p "$DATA_DIR/pitches"
    
    cat > "$output_file" << EOF
# PISCO Pitch for $company

**Generated:** $(date +%Y-%m-%d)

## Personalized Opening
As a pharmacy/business owner, you're likely facing:
- Rising labor costs in [Spain/Europe]
- Difficulty finding reliable, skilled staff
- Time spent on HR, payroll, compliance

## The PISCO Solution
We place vetted Filipino professionals in your business:
- English fluency (B2-C1 guaranteed)
- EU work authorization
- 6-month minimum commitment
- 95% retention rate

## Value Proposition
- **Cost:** ~€3,000-8,000 per placement (1 month salary equivalent)
- **Savings:** vs. €50K+ annually for mishires
- **Time:** We handle sourcing, vetting, contracts

## Call to Action
15-minute discovery call this week?
- Option A: [Your calendar link]
- Option B: Reply with your availability

---
*PISCO — Connecting European Businesses with Filipino Talent*
EOF
    
    success "Pitch generated: $output_file"
    echo "$output_file"
}

# Generate follow-up sequence
generate_sequence() {
    local company="$1"
    local output_file="$DATA_DIR/sequences/${company// /_}_sequence.md"
    
    mkdir -p "$DATA_DIR/sequences"
    
    cat > "$output_file" << 'EOF'
# PISCO Follow-Up Sequence

## Day 1 — Initial Email
Subject: Quick question about [company]
Body: [Personalized intro, value prop, calendar link]

## Day 4 — Value Add
Subject: Case study: [Similar company] saved €X
Body: Relevant case study, no ask

## Day 8 — Breakup Email
Subject: Did I miss you?
Body: Short, offer to resend materials

## Day 12 — Final Touch
Subject: One last thing
Body: New angle or offer, end with clear CTA

---
Tracked in: PROJECTS/pisco/pipeline.md
EOF
    
    success "Sequence generated: $output_file"
    echo "$output_file"
}

# Calculate commission
calculate_commission() {
    local placement_value="$1"
    local commission_rate="${2:-0.10}"
    
    if [[ -z "$placement_value" ]]; then
        error "Usage: calculate_commission <placement_value> [rate]"
        return 1
    fi
    
    local commission=$(echo "$placement_value * $commission_rate" | bc)
    printf "%.2f" "$commission"
}

# Add deal to pipeline
add_to_pipeline() {
    local lead="$1"
    local value="$2"
    local probability="$3"
    local date=$(date +%Y-%m-%d)
    
    if [[ -z "$lead" || -z "$value" || -z "$probability" ]]; then
        error "Usage: add_to_pipeline <lead> <value> <probability>"
        return 1
    fi
    
    local expected=$(echo "$value * $probability / 100" | bc)
    local commission=$(calculate_commission "$value")
    
    cat >> "$TRACKER" << EOF
| $date | $lead | ACTIVE | €$value | $probability% | €$expected | €$commission | New opportunity |
EOF
    success "Added to pipeline: $lead - €$value (€$expected expected, €$commission commission)"
}

# Daily report
daily_report() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  PISCO REVENUE REPORT — $(date +%Y-%m-%d)"
    echo "═══════════════════════════════════════════"
    echo ""
    
    if [[ -f "$LEADS" ]]; then
        echo "📋 LEAD SUMMARY"
        local total=$(grep -c "|" "$LEADS" | tail -1)
        local new=$(grep -c "\[ \] NEW" "$LEADS" 2>/dev/null || echo 0)
        local warm=$(grep -c "\[W\]" "$LEADS" 2>/dev/null || echo 0)
        local hot=$(grep -c "\[H\]" "$LEADS" 2>/dev/null || echo 0)
        echo "  Total leads: $total"
        echo "  New: $new | Warm: $warm | Hot: $hot"
        echo ""
    fi
    
    echo "💰 COMMISSION CALCULATOR"
    echo "  Formula: 10% of placement value"
    echo "  Example: €50K placement = €5,000 commission"
    echo ""
    echo "📊 Use 'pisco_revenue.sh leads' to view CRM"
    echo "📊 Use 'pisco_revenue.sh pipeline' to view deals"
    echo ""
}

# Main command router
case "${1:-help}" in
    init)
        init
        ;;
    add-lead)
        add_lead "$2" "$3" "$4" "$5"
        ;;
    update)
        update_lead "$2" "$3"
        ;;
    pitch)
        generate_pitch "$2"
        ;;
    sequence)
        generate_sequence "$2"
        ;;
    commission)
        calculate_commission "$2" "$3"
        ;;
    pipeline)
        add_to_pipeline "$2" "$3" "$4"
        ;;
    report)
        daily_report
        ;;
    help)
        echo "PISCO Revenue Machine"
        echo ""
        echo "Usage: pisco_revenue.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init              Initialize PISCO directories"
        echo "  add-lead          Add new lead (company contact email [value])"
        echo "  update <id> <stage>  Update lead stage"
        echo "  pitch <company>   Generate personalized pitch"
        echo "  sequence <company>  Generate follow-up sequence"
        echo "  commission <value> [rate]  Calculate Jordan's 10% cut"
        echo "  pipeline <lead> <value> <prob>  Add to pipeline"
        echo "  report            Daily revenue report"
        ;;
esac
