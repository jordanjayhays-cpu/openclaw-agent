#!/bin/bash
# AUTO CLIENT NURTURE — Relationship Automation
# Drip campaigns for warm leads, educational content, check-ins at 30/60/90 days, re-engagement, referrals

set -euo pipefail

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NURTURE_DIR="${SCRIPT_DIR}/../NURTURE"
DRIP_DIR="${NURTURE_DIR}/drip"
CRM_FILE="${SCRIPT_DIR}/../CRM/warm_leads.csv"
NURTURE_LOG="${SCRIPT_DIR}/../LOGS/nurture_$(date '+%Y%m%d').log"
TEMPLATES_DIR="${SCRIPT_DIR}/../TEMPLATES/nurture"

# === SETUP ===
mkdir -p "$DRIP_DIR" "$TEMPLATES_DIR" "$NURTURE_DIR" "${SCRIPT_DIR}/../LOGS" 2>/dev/null || true

# === LOGGING ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$NURTURE_LOG"
}

# === DRIP CAMPAIGNS ===
start_drip() {
    local contact="$1"
    local campaign="$2"
    
    local start_date=$(date '+%Y-%m-%d')
    local campaign_dir="${DRIP_DIR}/${campaign}"
    mkdir -p "$campaign_dir"
    
    echo "$contact,$campaign,$start_date,day_1,pending" >> "${campaign_dir}/subscribers.csv"
    log "Started $contact on $campaign drip"
}

# === SEND NEXT DRIP ===
send_next_drip() {
    local campaign="$1"
    local contact="$2"
    local current_day="$3"
    local status="$4"
    
    local next_email=""
    local next_day=""
    
    case "$campaign" in
        welcome)
            case "$current_day" in
                day_1)  next_email="welcome_1.md"; next_day="day_3" ;;
                day_3)  next_email="welcome_2.md"; next_day="day_7" ;;
                day_7)  next_email="welcome_3.md"; next_day="day_14" ;;
                day_14) next_email="welcome_4.md"; next_day="complete" ;;
            esac
            ;;
        educate)
            case "$current_day" in
                day_1)  next_email="edu_1.md"; next_day="day_5" ;;
                day_5)  next_email="edu_2.md"; next_day="day_10" ;;
                day_10) next_email="edu_3.md"; next_day="day_20" ;;
                day_20) next_email="edu_4.md"; next_day="complete" ;;
            esac
            ;;
        re-engage)
            case "$current_day" in
                day_1)  next_email="reengage_1.md"; next_day="day_7" ;;
                day_7)  next_email="reengage_2.md"; next_day="day_14" ;;
                day_14) next_email="reengage_3.md"; next_day="complete" ;;
            esac
            ;;
    esac
    
    # Send email (placeholder)
    if [[ -n "$next_email" ]] && [[ "$next_email" != "complete" ]]; then
        local template="${TEMPLATES_DIR}/${next_email}"
        if [[ -f "$template" ]]; then
            # Would send via email tool
            log "SEND to $contact: $next_email"
            echo "sent"
        fi
    fi
    
    echo "$next_day"
}

# === PROCESS DRIP CAMPAIGNS ===
process_drips() {
    log "=== Processing drip campaigns ==="
    
    for campaign_dir in "${DRIP_DIR}"/*/; do
        [[ -d "$campaign_dir" ]] || continue
        
        local campaign=$(basename "$campaign_dir")
        local subscribers_file="${campaign_dir}subscribers.csv"
        
        [[ -f "$subscribers_file" ]] || continue
        
        local temp_file=$(mktemp)
        
        while IFS=',' read -r contact campaign_name start_date current_day status; do
            [[ "$contact" == "contact" ]] && continue
            
            # Calculate days since start
            local days_since_start=$(($(date -d "$(date '+%Y-%m-%d')" +%s) - $(date -d "$start_date" +%s) / 86400))
            
            # Check if time for next drip
            local should_send=false
            case "$current_day" in
                day_1)  [[ $days_since_start -ge 1 ]] && should_send=true ;;
                day_3)  [[ $days_since_start -ge 3 ]] && should_send=true ;;
                day_5)  [[ $days_since_start -ge 5 ]] && should_send=true ;;
                day_7)  [[ $days_since_start -ge 7 ]] && should_send=true ;;
                day_10) [[ $days_since_start -ge 10 ]] && should_send=true ;;
                day_14) [[ $days_since_start -ge 14 ]] && should_send=true ;;
                day_20) [[ $days_since_start -ge 20 ]] && should_send=true ;;
            esac
            
            if [[ "$should_send" == "true" ]]; then
                local next_day=$(send_next_drip "$campaign" "$contact" "$current_day" "$status")
                echo "$contact,$campaign_name,$start_date,$next_day,pending" >> "$temp_file"
            else
                echo "$contact,$campaign_name,$start_date,$current_day,$status" >> "$temp_file"
            fi
            
        done < "$subscribers_file"
        
        mv "$temp_file" "$subscribers_file"
    done
    
    log "=== Drip processing complete ==="
}

# === CHECK-INS ===
process_checkins() {
    log "=== Processing client check-ins ==="
    
    # 30/60/90 day check-ins
    
    local today=$(date '+%Y-%m-%d')
    
    # Check for 30-day check-ins
    checkin_30_dir="${NURTURE_DIR}/checkins_30.csv"
    [[ ! -f "$checkin_30_dir" ]] && touch "$checkin_30_dir"
    
    # Check for 60-day check-ins
    checkin_60_dir="${NURTURE_DIR}/checkins_60.csv"
    [[ ! -f "$checkin_60_dir" ]] && touch "$checkin_60_dir"
    
    # Check for 90-day check-ins
    checkin_90_dir="${NURTURE_DIR}/checkins_90.csv"
    [[ ! -f "$checkin_90_dir" ]] && touch "$checkin_90_dir"
    
    # Placeholder - would check CRM for clients at milestone dates
    log "Check-ins processed (placeholder)"
}

# === RE-ENGAGEMENT ===
re_engage() {
    local contact="$1"
    
    log "Re-engaging: $contact"
    
    # Start re-engagement drip
    start_drip "$contact" "re-engage"
    
    # Log it
    echo "$(date '+%Y-%m-%d'),$contact" >> "${NURTURE_DIR}/reengagement_log.csv"
}

# === REFERRAL REQUEST ===
request_referral() {
    local contact="$1"
    
    log "Requesting referral from: $contact"
    
    # Placeholder - would send referral request email
    cat << EOF
Subject: Quick favor - who should I talk to?

Hi,

You've been great to work with.

Question: Who do you know that might benefit from what we do?

I'll handle all the heavy lifting - just point me in the right direction.

Thanks,
Jordan
EOF
}

# === EDUCATIONAL CONTENT ===
send_education() {
    local contact="$1"
    local topic="$2"
    
    log "Sending educational content to $contact: $topic"
    
    # Placeholder - would send relevant content based on topic
}

# === MAIN ===
case "${1:-run}" in
    run)
        process_drips
        process_checkins
        ;;
    start)
        start_drip "${2:-}" "${3:-welcome}"
        ;;
    drips)
        process_drips
        ;;
    checkins)
        process_checkins
        ;;
    reengage)
        [[ -n "${2:-}" ]] && re_engage "$2"
        ;;
    referral)
        [[ -n "${2:-}" ]] && request_referral "$2"
        ;;
    educate)
        send_education "${2:-}" "${3:-general}"
        ;;
    status)
        log "=== Nurture Status ==="
        log "Active drip campaigns: $(ls -d "${DRIP_DIR}"/*/ 2>/dev/null | wc -l)"
        log "Total drip subscribers: $(cat "${DRIP_DIR}"/*/subscribers.csv 2>/dev/null | wc -l)"
        ;;
    *)
        echo "Usage: $0 {run|start|drips|checkins|reengage|referral|educate|status}"
        exit 1
        ;;
esac
