#!/bin/bash
# AUTO OUTREACH ENGINE — PISCO
# Reads warm leads from CRM, sends personalized emails, logs everything, auto-follows up, stops on reply

set -euo pipefail

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CRM_FILE="${SCRIPT_DIR}/../CRM/warm_leads.csv"
TEMPLATE_FILE="${SCRIPT_DIR}/../TEMPLATES/email_pisco.txt"
LOG_DIR="${SCRIPT_DIR}/../LOGS/outreach"
SENT_DIR="${SCRIPT_DIR}/../SENT"
QUEUE_FILE="${SCRIPT_DIR}/../QUEUE/outreach_queue.csv"
AUTO_FOLLOWUP_DAYS="${AUTO_FOLLOWUP_DAYS:-1,3,5,7,14}"
STOP_ON_REPLY="true"

# === SETUP ===
mkdir -p "$LOG_DIR" "$SENT_DIR" "$QUEUE_FILE" 2>/dev/null || true
QUEUE_DIR="$(dirname "$QUEUE_FILE")"
mkdir -p "$QUEUE_DIR"

# === LOGGING ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/outreach_$(date '+%Y%m%d').log"
}

# === LOAD TEMPLATE ===
load_template() {
    if [[ -f "$TEMPLATE_FILE" ]]; then
        cat "$TEMPLATE_FILE"
    else
        cat << 'TEMPLATE'
Subject: {{subject}}

Hi {{first_name}},

{{personalization}}

{{body}}

{{cta}}

{{signature}}

{{social_proof}}
TEMPLATE
    fi
}

# === PERSONALIZE TEMPLATE ===
personalize() {
    local template="$1"
    local lead="$2"
    
    local first_name=$(echo "$lead" | cut -d',' -f1)
    local company=$(echo "$lead" | cut -d',' -f2)
    local email=$(echo "$lead" | cut -d',' -f3)
    local subject=$(echo "$lead" | cut -d',' -f4)
    local name_only=$(echo "$lead" | cut -d',' -f5)
    local company_only=$(echo "$lead" | cut -d',' -f6)
    
    # Replace placeholders
    template="${template//\{\{first_name\}\}/$first_name}"
    template="${template//\{\{company\}\}/$company}"
    template="${template//\{\{email\}\}/$email}"
    template="${template//\{\{subject\}\}/$subject}"
    template="${template//\{\{name_only\}\}/$name_only}"
    template="${template//\{\{company_only\}\}/$company_only}"
    
    echo "$template"
}

# === SEND EMAIL ===
send_email() {
    local to="$1"
    local subject="$2"
    local body="$3"
    local format="${4:-plain}"  # plain or html
    
    # Use sendmail or mail command
    if command -v sendmail &>/dev/null; then
        if [[ "$format" == "html" ]]; then
            sendmail -H "$SCRIPT_DIR/../CONFIG/smtp" "$to" << EOF
Subject: $subject
Content-Type: text/html

$body
EOF
        else
            sendmail "$to" << EOF
Subject: $subject

$body
EOF
        fi
    elif command -v mail &>/dev/null; then
        echo "$body" | mail -s "$subject" "$to"
    elif command -v msmtp &>/dev/null; then
        echo "$body" | msmtp "$to"
    else
        log "WARNING: No email sending tool found. Would send to $to"
        return 1
    fi
    
    return 0
}

# === CHECK FOR REPLY ===
check_for_reply() {
    local to="$1"
    local log_file="$LOG_DIR/replies_$(date '+%Y%m%d').log"
    
    # Check if replied (would integrate with email inbox parsing)
    # Placeholder: implement email inbox check
    if grep -q "$to.*replied" "$log_file" 2>/dev/null; then
        return 0  # Replied
    fi
    return 1  # Not replied
}

# === LOG SENT EMAIL ===
log_sent() {
    local email="$1"
    local lead_id="$2"
    local subject="$3"
    local followup_day="$4"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp,$email,$lead_id,$subject,$followup_day" >> "$LOG_DIR/sent_$(date '+%Y%m%d').csv"
}

# === SCHEDULE FOLLOWUP ===
schedule_followup() {
    local email="$1"
    local lead_id="$2"
    local followup_day="$3"
    local subject="$4"
    
    # Calculate followup date
    local followup_date=$(date -d "+${followup_day} days" '+%Y-%m-%d' 2>/dev/null || date -v+${followup_day}d '+%Y-%m-%d')
    
    # Add to followup queue
    echo "$followup_date,$email,$lead_id,$subject" >> "$QUEUE_DIR/followup_queue.csv"
    log "Scheduled followup for $email in $followup_day days"
}

# === PROCESS WARM LEADS ===
process_leads() {
    local batch_size="${1:-10}"
    local count=0
    
    log "=== Starting outreach batch (max $batch_size leads) ==="
    
    while IFS=, read -r first_name company email subject name_only company_only status last_contacted; do
        # Skip header
        [[ "$first_name" == "first_name" ]] && continue
        
        # Skip if not warm
        [[ "$status" != "warm" ]] && continue
        
        # Skip if contacted recently (within 7 days)
        if [[ -n "$last_contacted" ]]; then
            local days_since=$(($(date -d "$(date '+%Y-%m-%d')" +%s) - $(date -d "$last_contacted" +%s) / 86400))
            [[ $days_since -lt 7 ]] && continue
        fi
        
        # Check for reply (stop if replied)
        if [[ "$STOP_ON_REPLY" == "true" ]] && check_for_reply "$email"; then
            log "$email has replied - removing from outreach queue"
            continue
        fi
        
        # Personalize and send
        local template=$(load_template)
        local body=$(personalize "$template" "$first_name,$company,$email,$subject,$name_only,$company_only")
        
        if send_email "$email" "$subject" "$body" "plain"; then
            log "SENT to $email: $subject"
            log_sent "$email" "$company" "$subject" "0"
            
            # Schedule followups
            IFS=',' read -ra DAYS <<< "$AUTO_FOLLOWUP_DAYS"
            for day in "${DAYS[@]}"; do
                schedule_followup "$email" "$company" "$day" "$subject"
            done
        else
            log "FAILED to send to $email"
        fi
        
        ((count++))
        [[ $count -ge $batch_size ]] && break
        
    done < "$CRM_FILE"
    
    log "=== Batch complete: $count emails sent ==="
}

# === PROCESS FOLLOWUP QUEUE ===
process_followups() {
    local today=$(date '+%Y-%m-%d')
    local temp_file=$(mktemp)
    
    log "=== Checking followup queue ==="
    
    while IFS=, read -r followup_date email lead_id subject; do
        [[ "$followup_date" == "followup_date" ]] && continue
        
        if [[ "$followup_date" == "$today" ]]; then
            # Check again for reply
            if check_for_reply "$email"; then
                log "$email has replied - skipping followup"
                continue
            fi
            
            # Send followup
            local followup_body="Following up on my previous email about $subject.

Have you had a chance to review?

Happy to answer any questions.

Best,
Jordan"
            
            if send_email "$email" "Re: $subject" "$followup_body" "plain"; then
                log "FOLLOWUP sent to $email"
            fi
        else
            # Keep in queue for later
            echo "$followup_date,$email,$lead_id,$subject" >> "$temp_file"
        fi
        
    done < "$QUEUE_DIR/followup_queue.csv" 2>/dev/null || true
    
    # Update queue
    mv "$temp_file" "$QUEUE_DIR/followup_queue.csv"
}

# === MAIN ===
case "${1:-run}" in
    run)
        process_leads "${2:-10}"
        ;;
    followup)
        process_followups
        ;;
    status)
        log "=== Outreach Status ==="
        log "CRM file: $CRM_FILE"
        log "Sent today: $(wc -l < "$LOG_DIR/sent_$(date '+%Y%m%d').csv" 2>/dev/null || echo 0)"
        log "Pending followups: $(wc -l < "$QUEUE_DIR/followup_queue.csv" 2>/dev/null || echo 0)"
        ;;
    *)
        echo "Usage: $0 {run|followup|status}"
        exit 1
        ;;
esac

log "=== Outreach engine complete ==="
