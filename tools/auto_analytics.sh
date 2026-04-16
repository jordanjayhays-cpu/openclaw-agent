#!/bin/bash
# AUTO ANALYTICS — Jordan's Business Intelligence
# Tracks open rates, CTR, response rates, generates reports

set -euo pipefail

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANALYTICS_DIR="${SCRIPT_DIR}/../ANALYTICS"
LOGS_DIR="${SCRIPT_DIR}/../LOGS"
DATA_DIR="${ANALYTICS_DIR}/data"
REPORTS_DIR="${ANALYTICS_DIR}/reports"
EMAIL_LOGS="${LOGS_DIR}/outreach/*.csv"
SALES_FILE="${ANALYTICS_DIR}/sales_data.csv"

# === SETUP ===
mkdir -p "$ANALYTICS_DIR" "$DATA_DIR" "$REPORTS_DIR" "$LOGS_DIR" 2>/dev/null || true

# === LOGGING ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${ANALYTICS_DIR}/analytics_$(date '+%Y%m%d').log"
}

# === TRACK OPEN RATES ===
track_opens() {
    local campaign="${1:-all}"
    local total_opens=0
    local total_sent=0
    
    log "=== Tracking Open Rates ==="
    
    for csv in $EMAIL_LOGS; do
        [[ -f "$csv" ]] || continue
        
        # Extract open data (placeholder - would integrate with email tracking)
        opens=$(grep -c "opened" "$csv" 2>/dev/null || echo 0)
        sent=$(wc -l < "$csv" 2>/dev/null || echo 0)
        
        total_opens=$((total_opens + opens))
        total_sent=$((total_sent + sent))
    done
    
    local rate=0
    [[ $total_sent -gt 0 ]] && rate=$((total_opens * 100 / total_sent))
    
    log "Opens: $total_opens / $total_sent ($rate%)"
    echo "$total_opens,$total_sent,$rate" >> "${DATA_DIR}/open_rates.csv"
    echo $rate
}

# === TRACK CTR ===
track_ctr() {
    local campaign="${1:-all}"
    local total_clicks=0
    local total_opens=0
    
    log "=== Tracking Click-Through Rates ==="
    
    # Placeholder - would track link clicks from email platform
    for csv in $EMAIL_LOGS; do
        [[ -f "$csv" ]] || continue
        clicks=$(grep -c "clicked" "$csv" 2>/dev/null || echo 0)
        total_clicks=$((total_clicks + clicks))
    done
    
    local opens=$(track_opens | cut -d',' -f1)
    local rate=0
    [[ $opens -gt 0 ]] && rate=$((total_clicks * 100 / opens))
    
    log "CTR: $total_clicks clicks ($rate%)"
    echo "$total_clicks,$rate" >> "${DATA_DIR}/ctr.csv"
    echo $rate
}

# === TRACK RESPONSE RATES ===
track_responses() {
    local campaign="${1:-all}"
    local total_replies=0
    local total_sent=0
    
    log "=== Tracking Response Rates ==="
    
    for csv in $EMAIL_LOGS; do
        [[ -f "$csv" ]] || continue
        replies=$(grep -c "replied" "$csv" 2>/dev/null || echo 0)
        sent=$(wc -l < "$csv" 2>/dev/null || echo 0)
        total_replies=$((total_replies + replies))
        total_sent=$((total_sent + sent))
    done
    
    local rate=0
    [[ $total_sent -gt 0 ]] && rate=$((total_replies * 100 / total_sent))
    
    log "Responses: $total_replies / $total_sent ($rate%)"
    echo "$total_replies,$total_sent,$rate" >> "${DATA_DIR}/response_rates.csv"
    echo $rate
}

# === GENERATE WEEKLY REPORT ===
weekly_report() {
    local week_start=$(date -d "monday this week" '+%Y-%m-%d')
    local week_end=$(date -d "sunday this week" '+%Y-%m-%d')
    local report_file="${REPORTS_DIR}/weekly_$(date '+%Y%m%d').md"
    
    log "=== Generating Weekly Report ==="
    
    local open_rate=$(track_opens)
    local ctr=$(track_ctr)
    local response_rate=$(track_responses)
    
    # Calculate pipeline value
    local pipeline=0
    if [[ -f "$SALES_FILE" ]]; then
        pipeline=$(tail -1 "$SALES_FILE" | cut -d',' -f5)
    fi
    
    cat > "$report_file" << EOF
# Weekly Analytics Report
**Week:** $week_start - $week_end  
**Generated:** $(date '+%Y-%m-%d %H:%M:%S')

## Email Performance

| Metric | Value |
|--------|-------|
| Open Rate | $open_rate% |
| Click-Through Rate | $ctr% |
| Response Rate | $response_rate% |

## Pipeline

| Stage | Value |
|-------|-------|
| Pipeline | €$pipeline |

## Recommendations

1. **Open Rate:** $(if [[ $open_rate -gt 30 ]]; then echo "Good - above industry average"; else echo "Test new subject lines"; fi)
2. **CTR:** $(if [[ $ctr -gt 5 ]]; then echo "Strong - keep optimizing content"; else echo "Review CTA placement"; fi)
3. **Response Rate:** $(if [[ $response_rate -gt 5 ]]; then echo "Healthy - nurture further"; else echo "Need better personalization"; fi)

---
*Report generated automatically*
EOF
    
    log "Weekly report saved: $report_file"
    
    # Send to Jordan (placeholder)
    send_report "$report_file"
}

# === GENERATE MONTHLY REPORT ===
monthly_report() {
    local month=$(date '+%Y-%m')
    local report_file="${REPORTS_DIR}/monthly_${month}.md"
    
    log "=== Generating Monthly Report ==="
    
    # Aggregate monthly data
    local total_opens=0 total_sent=0 total_clicks=0 total_replies=0
    
    for csv in "${DATA_DIR}"/*.csv 2>/dev/null; do
        [[ -f "$csv" ]] || continue
        # Aggregate logic here
    done
    
    cat > "$report_file" << EOF
# Monthly Analytics Report
**Month:** $month  
**Generated:** $(date '+%Y-%m-%d %H:%M:%S')

## Summary

This month we focused on:
- PISCO outreach optimization
- LinkedIn content cadence
- Lead enrichment pipeline

## Key Metrics

- Open Rate: TBD
- CTR: TBD  
- Response Rate: TBD
- New Leads: TBD
- Pipeline Value: TBD

## Top Performing Content

1. TBD
2. TBD
3. TBD

## Next Month Priorities

1. Scale what works
2. Kill what doesn't
3. Test new channels

---
*Report generated automatically*
EOF
    
    log "Monthly report saved: $report_file"
    send_report "$report_file"
}

# === SEND REPORT TO JORDAN ===
send_report() {
    local report_file="$1"
    
    # Placeholder - would send via email or Telegram
    log "Would send $report_file to Jordan"
}

# === DASHBOARD DATA ===
dashboard() {
    cat << EOF
=== ANALYTICS DASHBOARD ===
Generated: $(date '+%Y-%m-%d %H:%M:%S')

EMAIL METRICS:
- Open Rate: $(track_opens)%
- CTR: $(track_ctr)%
- Response Rate: $(track_responses)%

PIPELINE:
- Value: €$(tail -1 "$SALES_FILE" 2>/dev/null | cut -d',' -f5 || echo 0)

CONTENT:
- Twitter Queue: $(wc -l < "${SCRIPT_DIR}/../QUEUE/twitter_queue.md" 2>/dev/null || echo 0)
- LinkedIn Queue: $(wc -l < "${SCRIPT_DIR}/../QUEUE/linkedin_queue.md" 2>/dev/null || echo 0)
EOF
}

# === MAIN ===
case "${1:-run}" in
    run)
        track_opens
        track_ctr
        track_responses
        ;;
    opens)   track_opens "${2:-all}" ;;
    ctr)     track_ctr "${2:-all}" ;;
    replies) track_responses "${2:-all}" ;;
    weekly)  weekly_report ;;
    monthly) monthly_report ;;
    dashboard) dashboard ;;
    *)
        echo "Usage: $0 {run|opens|ctr|replies|weekly|monthly|dashboard}"
        exit 1
        ;;
esac
