#!/bin/bash
# AUTO REVENUE TRACKER — Financial Intelligence
# Tracks pipeline value, closed deals, projects monthly revenue, weekly forecast, alerts on changes

set -euo pipefail

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REVENUE_DIR="${SCRIPT_DIR}/../REVENUE"
PIPELINE_FILE="${REVENUE_DIR}/pipeline.csv"
CLOSED_FILE="${REVENUE_DIR}/closed.csv"
FORECAST_FILE="${REVENUE_DIR}/forecast.csv"
ALERTS_FILE="${REVENUE_DIR}/alerts_$(date '+%Y%m%d').md"
REVENUE_LOG="${SCRIPT_DIR}/../LOGS/revenue_$(date '+%Y%m%d').log"

# === SETUP ===
mkdir -p "$REVENUE_DIR" "${SCRIPT_DIR}/../LOGS" 2>/dev/null || true

# Ensure files exist
[[ ! -f "$PIPELINE_FILE" ]] && echo "date,project,value,stage,probability,expected_close" > "$PIPELINE_FILE"
[[ ! -f "$CLOSED_FILE" ]] && echo "date,project,value,client,vertical" > "$CLOSED_FILE"
[[ ! -f "$FORECAST_FILE" ]] && echo "month,projected,actual,variance" > "$FORECAST_FILE"

# === LOGGING ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$REVENUE_LOG"
}

# === TRACK PIPELINE ===
track_pipeline() {
    local project="$1"
    local value="$2"
    local stage="$3"
    local probability="${4:-50}"
    local expected_close="${5:-}"
    
    local timestamp=$(date '+%Y-%m-%d')
    
    # Add to pipeline
    echo "$timestamp,$project,$value,$stage,$probability,$expected_close" >> "$PIPELINE_FILE"
    log "Pipeline updated: $project = €$value ($stage)"
}

# === TRACK CLOSED DEALS ===
track_closed() {
    local project="$1"
    local value="$2"
    local client="$3"
    local vertical="$4"
    
    local timestamp=$(date '+%Y-%m-%d')
    
    echo "$timestamp,$project,$value,$client,$vertical" >> "$CLOSED_FILE"
    log "CLOSED: $project = €$value"
}

# === CALCULATE PIPELINE VALUE ===
pipeline_value() {
    local stage="${1:-all}"
    
    local total=0
    while IFS=',' read -r date project value stage_col prob close; do
        [[ "$date" == "date" ]] && continue
        [[ -z "$date" ]] && continue
        
        if [[ "$stage" == "all" ]] || [[ "$stage" == "$stage_col" ]]; then
            # Use weighted value (value * probability)
            local weighted=$((value * prob / 100))
            total=$((total + weighted))
        fi
    done < <(tail -n +2 "$PIPELINE_FILE")
    
    echo $total
}

# === CALCULATE CLOSED REVENUE ===
closed_revenue() {
    local period="${1:-month}"  # day, week, month, year
    
    local total=0
    local date_filter=""
    
    case "$period" in
        day)
            date_filter=$(date '+%Y-%m-%d')
            ;;
        week)
            date_filter=$(date -d "monday this week" '+%Y-%m-%d')
            ;;
        month)
            date_filter=$(date '+%Y-%m')
            ;;
        year)
            date_filter=$(date '+%Y')
            ;;
    esac
    
    while IFS=',' read -r date project value client vertical; do
        [[ "$date" == "date" ]] && continue
        [[ -z "$date" ]] && continue
        
        if [[ "$date" == *"$date_filter"* ]]; then
            total=$((total + value))
        fi
    done < <(tail -n +2 "$CLOSED_FILE")
    
    echo $total
}

# === PROJECT MONTHLY REVENUE ===
project_monthly() {
    local month="${1:-$(date '+%Y-%m')}"
    local current_revenue=$(closed_revenue month)
    local pipeline_weighted=$(pipeline_value)
    
    # Calculate expected from pipeline based on close dates
    local expected=0
    while IFS=',' read -r date project value stage prob close_date; do
        [[ "$date" == "date" ]] && continue
        
        if [[ "$close_date" == *"$month"* ]]; then
            expected=$((expected + value * prob / 100))
        fi
    done < <(tail -n +2 "$PIPELINE_FILE")
    
    local projected=$((current_revenue + expected))
    
    log "Monthly projection for $month: €$projected (actual: €$current_revenue + expected: €$expected)"
    echo "$projected"
}

# === WEEKLY FORECAST ===
weekly_forecast() {
    local report_file="${REVENUE_DIR}/forecast_$(date '+%Y%m%d').md"
    
    log "=== Generating weekly revenue forecast ==="
    
    local current_month_revenue=$(closed_revenue month)
    local pipeline_val=$(pipeline_value)
    local monthly_projection=$(project_monthly)
    local weekly_actual=$(closed_revenue week)
    
    # Days left in month
    local days_left=$(($(date -d "$(date -d '+1 month' +%Y-%m-01) -1 day' +%d) - $(date +%d) + 1))
    
    # Daily rate needed
    local daily_rate_needed=0
    [[ $days_left -gt 0 ]] && daily_rate_needed=$((($monthly_projection - $current_month_revenue) / days_left))
    
    cat > "$report_file" << EOF
# Weekly Revenue Forecast
**Generated:** $(date '+%Y-%m-%d %H:%M:%S')

## This Month

| Metric | Value |
|--------|-------|
| Closed to Date | €$current_month_revenue |
| Pipeline (weighted) | €$pipeline_val |
| Monthly Projection | €$monthly_projection |
| Weekly Closed | €$weekly_actual |

## Pace Analysis

- Days left in month: $days_left
- Daily rate needed: €$daily_rate_needed
- On track: $([[ $current_month_revenue -ge $((monthly_projection * $(date +%d) / 30)) ]] && echo "YES" || echo "NO")

## Pipeline by Stage

$(pipeline_by_stage)

## Alerts

$(check_alerts)

---
*Forecast generated automatically*
EOF
    
    log "Forecast saved: $report_file"
    send_forecast "$report_file"
}

# === PIPELINE BY STAGE ===
pipeline_by_stage() {
    for stage in "discovery" "qualification" "proposal" "negotiation" "closing"; do
        local stage_val=$(pipeline_value "$stage")
        echo "| $stage | €$stage_val |"
    done
}

# === CHECK ALERTS ===
check_alerts() {
    local alerts=""
    
    # Check for large deals closing this week
    while IFS=',' read -r date project value stage prob close_date; do
        [[ "$date" == "date" ]] && continue
        
        if [[ "$close_date" == "$(date -d '+7 days' '+%Y-%m-%d')"* ]] && [[ $value -gt 10000 ]]; then
            alerts="${alerts}\n- Large deal (€$value) closing soon: $project"
        fi
    done < <(tail -n +2 "$PIPELINE_FILE")
    
    # Check for stalled deals
    # (would compare close dates vs stages)
    
    # Check for revenue drops
    local prev_week=$(closed_revenue week)
    local this_week=$(closed_revenue week)
    if [[ $this_week -lt $((prev_week / 2)) ]]; then
        alerts="${alerts}\n- Revenue dropped significantly week over week"
    fi
    
    [[ -z "$alerts" ]] && echo "No alerts" || echo -e "$alerts"
}

# === ALERT ON CHANGES ===
alert_change() {
    local metric="$1"
    local old_value="$2"
    local new_value="$3"
    
    local change_pct=0
    [[ $old_value -gt 0 ]] && change_pct=$((($new_value - $old_value) * 100 / $old_value))
    
    if [[ ${change_pct#-} -gt 20 ]]; then
        log "ALERT: $metric changed by ${change_pct}% (€$old_value -> €$new_value)"
        
        cat >> "$ALERTS_FILE" << EOF
# Revenue Alert: $(date '+%Y-%m-%d %H:%M:%S')

**Metric:** $metric  
**Change:** ${change_pct}%  
**From:** €$old_value  
**To:** €$new_value  

---
EOF
    fi
}

# === SEND FORECAST ===
send_forecast() {
    local report_file="$1"
    
    # Placeholder - would send to Jordan
    log "Would send $report_file to Jordan"
}

# === DASHBOARD ===
dashboard() {
    cat << EOF
=== REVENUE DASHBOARD ===
Generated: $(date '+%Y-%m-%d %H:%M:%S')

PIPELINE:
- Total Pipeline: €$(pipeline_value)
- Discovery: €$(pipeline_value discovery)
- Qualification: €$(pipeline_value qualification)
- Proposal: €$(pipeline_value proposal)
- Negotiation: €$(pipeline_value negotiation)
- Closing: €$(pipeline_value closing)

CLOSED REVENUE:
- Today: €$(closed_revenue day)
- This Week: €$(closed_revenue week)
- This Month: €$(closed_revenue month)
- This Year: €$(closed_revenue year)

PROJECTIONS:
- Monthly Projection: €$(project_monthly)

STATUS: $([[ $(closed_revenue month) -ge $(project_monthly) ]] && echo "ON TRACK" || echo "BEHIND TARGET")
EOF
}

# === MAIN ===
case "${1:-run}" in
    run|dashboard)
        dashboard
        ;;
    add-pipeline)
        track_pipeline "${2:-}" "${3:-0}" "${4:-discovery}" "${5:-50}" "${6:-}"
        ;;
    add-closed)
        track_closed "${2:-}" "${3:-0}" "${4:-}" "${5:-}"
        ;;
    forecast|weekly)
        weekly_forecast
        ;;
    status)
        log "=== Revenue Status ==="
        log "Pipeline: €$(pipeline_value)"
        log "This Month: €$(closed_revenue month)"
        log "Projection: €$(project_monthly)"
        ;;
    *)
        echo "Usage: $0 {run|add-pipeline|add-closed|forecast|status}"
        echo "  add-pipeline: <project> <value> <stage> <probability> <expected_close>"
        echo "  add-closed: <project> <value> <client> <vertical>"
        exit 1
        ;;
esac
