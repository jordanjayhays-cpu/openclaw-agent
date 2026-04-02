#!/bin/bash
# Revenue Alerter
# Send alerts to Telegram when revenue events happen

set -e

ALERT_LOG="/data/workspace/PROJECTS/alerts/alerter_log.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check for Telegram config
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

# Init
init() {
    mkdir -p "/data/workspace/PROJECTS/alerts"
    
    if [[ ! -f "$ALERT_LOG" ]]; then
        cat > "$ALERT_LOG" << 'EOF'
# Revenue Alert Log

| Timestamp | Event | Details | Notified |
|-----------|-------|---------|----------|
EOF
    fi
}

# Send Telegram message (if configured)
send_telegram() {
    local message="$1"
    
    if [[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]]; then
        echo -e "${YELLOW}[TELEGRAM NOT CONFIGURED]${NC}"
        echo "  Message would be: $message"
        return 1
    fi
    
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$message" \
        -d "parse_mode=HTML" > /dev/null
    
    echo -e "${GREEN}[TELEGRAM]${NC} Message sent"
}

# Alert templates
alert_deal_hot() {
    local project="$1"
    local client="$2"
    local value="$3"
    
    local message="🔥 <b>DEAL HOT!</b>

$project
Client: $client
Value: €$value
Time: $(date +%Y-%m-%d\ %H:%M)"
    
    echo -e "${CYAN}🚨 ALERT: Deal moved to HOT${NC}"
    echo "  Project: $project"
    echo "  Client: $client"
    echo "  Value: €$value"
    
    echo "| $(date +%Y-%m-%d\ %H:%M) | DEAL HOT | $project - $client - €$value | $(send_telegram "$message" && echo 'YES' || echo 'NO') |" >> "$ALERT_LOG"
}

alert_contract_sent() {
    local project="$1"
    local client="$2"
    local contract_num="$3"
    
    local message="📝 <b>CONTRACT SENT</b>

$project
Client: $client
Contract: $contract_num
Time: $(date +%Y-%m-%d\ %H:%M)"
    
    echo -e "${CYAN}📧 ALERT: Contract sent${NC}"
    echo "  Project: $project"
    echo "  Client: $client"
    echo "  Contract: $contract_num"
    
    echo "| $(date +%Y-%m-%d\ %H:%M) | CONTRACT SENT | $project - $client - $contract_num | $(send_telegram "$message" && echo 'YES' || echo 'NO') |" >> "$ALERT_LOG"
}

alert_invoice_paid() {
    local project="$1"
    local invoice_num="$2"
    local amount="$3"
    
    local message="💰 <b>INVOICE PAID!</b>

$project
Invoice: $invoice_num
Amount: €$amount
Time: $(date +%Y-%m-%d\ %H:%M)"
    
    echo -e "${GREEN}💰 ALERT: Invoice PAID${NC}"
    echo "  Project: $project"
    echo "  Invoice: $invoice_num"
    echo "  Amount: €$amount"
    
    echo "| $(date +%Y-%m-%d\ %H:%M) | INVOICE PAID | $project - $invoice_num - €$amount | $(send_telegram "$message" && echo 'YES' || echo 'NO') |" >> "$ALERT_LOG"
}

alert_milestone() {
    local milestone="$1"
    local details="$2"
    
    local message="🎯 <b>MILESTONE REACHED!</b>

$milestone
$details
Time: $(date +%Y-%m-%d\ %H:%M)"
    
    echo -e "${GREEN}🎯 ALERT: Milestone!${NC}"
    echo "  $milestone"
    echo "  $details"
    
    echo "| $(date +%Y-%m-%d\ %H:%M) | MILESTONE | $milestone - $details | $(send_telegram "$message" && echo 'YES' || echo 'NO') |" >> "$ALERT_LOG"
}

alert_new_lead() {
    local project="$1"
    local company="$2"
    local status="$3"
    
    local message="📋 <b>NEW LEAD</b>

$project
Company: $company
Status: $status
Time: $(date +%Y-%m-%d\ %H:%M)"
    
    echo -e "${BLUE}📋 ALERT: New lead${NC}"
    echo "  Project: $project"
    echo "  Company: $company"
    echo "  Status: $status"
    
    echo "| $(date +%Y-%m-%d\ %H:%M) | NEW LEAD | $project - $company - $status | $(send_telegram "$message" && echo 'YES' || echo 'NO') |" >> "$ALERT_LOG"
}

alert_revenue_target() {
    local project="$1"
    local current="$2"
    local target="$3"
    
    local message="🎉 <b>TARGET HIT!</b>

$project
Current: €$current
Target: €$target
Time: $(date +%Y-%m-%d\ %H:%M)"
    
    echo -e "${GREEN}🎉 ALERT: Target reached!${NC}"
    echo "  Project: $project"
    echo "  Current: €$current / Target: €$target"
    
    echo "| $(date +%Y-%m-%d\ %H:%M) | TARGET HIT | $project - €$current / €$target | $(send_telegram "$message" && echo 'YES' || echo 'NO') |" >> "$ALERT_LOG"
}

# Daily summary
daily_summary() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  REVENUE ALERTS — $(date +%Y-%m-%d)"
    echo "═══════════════════════════════════════════"
    echo ""
    
    local today=$(date +%Y-%m-%d)
    local today_alerts=$(grep "$today" "$ALERT_LOG" 2>/dev/null | wc -l || echo "0")
    
    echo "📊 Today's alerts: $today_alerts"
    echo ""
    
    if [[ -f "$ALERT_LOG" ]]; then
        echo "📋 Recent alerts:"
        tail -10 "$ALERT_LOG" | grep "|" | while read line; do
            echo "  $line"
        done
    fi
    
    echo ""
    echo "🔔 To send an alert:"
    echo "  revenue_alerter.sh deal-hot <project> <client> <value>"
    echo "  revenue_alerter.sh contract-sent <project> <client> <num>"
    echo "  revenue_alerter.sh invoice-paid <project> <num> <amount>"
    echo "  revenue_alerter.sh milestone <name> <details>"
    echo ""
}

# Main
case "${1:-help}" in
    init)
        init
        ;;
    deal-hot)
        alert_deal_hot "$2" "$3" "$4"
        ;;
    contract-sent)
        alert_contract_sent "$2" "$3" "$4"
        ;;
    invoice-paid)
        alert_invoice_paid "$2" "$3" "$4"
        ;;
    milestone)
        alert_milestone "$2" "$3"
        ;;
    new-lead)
        alert_new_lead "$2" "$3" "$4"
        ;;
    target)
        alert_revenue_target "$2" "$3" "$4"
        ;;
    summary)
        daily_summary
        ;;
    test)
        echo "Testing Telegram configuration..."
        send_telegram "🧪 Test message from Revenue Alerter"
        ;;
    help)
        echo "Revenue Alerter"
        echo ""
        echo "Usage: revenue_alerter.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init                  Initialize alert log"
        echo "  deal-hot <p> <c> <v>  Alert when deal moves to hot"
        echo "  contract-sent <p> <c> <n>  Alert when contract sent"
        echo "  invoice-paid <p> <n> <a>  Alert when invoice paid"
        echo "  milestone <name> <d>   Alert on milestone"
        echo "  new-lead <p> <co> <s>  Alert on new lead"
        echo "  target <p> <c> <t>    Alert on revenue target"
        echo "  summary               Today's alert summary"
        echo "  test                  Test Telegram setup"
        ;;
esac
