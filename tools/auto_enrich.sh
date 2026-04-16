#!/bin/bash
# AUTO LEAD ENRICHER — Pipeline Automation
# Takes cold leads, finds LinkedIn, finds email, finds company info, updates CRM

set -euo pipefail

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEADS_DIR="${SCRIPT_DIR}/../LEADS"
CRM_FILE="${SCRIPT_DIR}/../CRM/contacts.csv"
ENRICH_LOG="${SCRIPT_DIR}/../LOGS/enrich_$(date '+%Y%m%d').log"
ENRICHED_DIR="${SCRIPT_DIR}/../LEADS/enriched"
API_CONFIG="${SCRIPT_DIR}/../CONFIG/enrich_api.sh"

# === SETUP ===
mkdir -p "$ENRICHED_DIR" "${SCRIPT_DIR}/../LOGS" "${SCRIPT_DIR}/../CRM" 2>/dev/null || true

# === LOGGING ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$ENRICH_LOG"
}

# === FIND LINKEDIN ===
find_linkedin() {
    local name="$1"
    local company="$2"
    
    if command -v linkedin-search &>/dev/null; then
        linkedin-search "$name" "$company" 2>/dev/null
    elif [[ -f "$API_CONFIG" ]]; then
        source "$API_CONFIG"
        echo ""
    else
        local encoded_name=$(echo "$name" | sed 's/ /%20/g')
        echo "https://www.linkedin.com/search/results/all/?keywords=$encoded_name%20$company"
    fi
}

# === FIND EMAIL ===
find_email() {
    local name="$1"
    local company="$2"
    
    if command -v hunter &>/dev/null; then
        hunter find "$name" "$company" 2>/dev/null
    elif [[ -f "$API_CONFIG" ]]; then
        source "$API_CONFIG"
        echo ""
    else
        local first=$(echo "$name" | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
        local last=$(echo "$name" | cut -d' ' -f2 | tr '[:upper:]' '[:lower:]')
        local domain=$(echo "$company" | sed 's/ /./g' | tr '[:upper:]' '[:lower:]')
        echo "${first}.${last}@${domain}.com"
    fi
}

# === FIND COMPANY INFO ===
find_company_info() {
    local company="$1"
    
    if command -v clearbit &>/dev/null; then
        clearbit company "$company" 2>/dev/null
    elif [[ -f "$API_CONFIG" ]]; then
        source "$API_CONFIG"
        echo ""
    else
        echo "{\"company\":\"$company\",\"industry\":\"\",\"size\":\"\",\"revenue\":\"\",\"website\":\"\"}"
    fi
}

# === ENRICH LEAD ===
enrich_lead() {
    local lead_file="$1"
    local name=$(basename "$lead_file" .csv)
    
    log "Enriching lead: $name"
    
    local name_val company_val website_val phone_val source_val
    IFS=',' read -r name_val company_val website_val phone_val source_val < <(head -1 "$lead_file")
    
    local linkedin=$(find_linkedin "$name_val" "$company_val")
    log "  LinkedIn: $linkedin"
    
    local email=$(find_email "$name_val" "$company_val")
    log "  Email: $email"
    
    local company_info=$(find_company_info "$company_val")
    log "  Company: $company_info"
    
    local enriched_file="${ENRICHED_DIR}/${name}_$(date '+%Y%m%d').json"
    cat > "$enriched_file" << EOF
{
    "name": "$name_val",
    "company": "$company_val",
    "website": "$website_val",
    "phone": "$phone_val",
    "source": "$source_val",
    "enriched": {
        "linkedin": "$linkedin",
        "email": "$email",
        "company_info": $company_info,
        "enriched_at": "$(date '+%Y-%m-%d %H:%M:%S')"
    }
}
EOF
    
    log "  Saved: $enriched_file"
    echo "$enriched_file"
}

# === UPDATE CRM ===
update_crm() {
    local enriched_file="$1"
    
    if [[ ! -f "$CRM_FILE" ]]; then
        touch "$CRM_FILE"
    fi
    
    local name=$(jq -r '.name' "$enriched_file" 2>/dev/null || grep -o '"name": "[^"]*"' "$enriched_file" | cut -d'"' -f4)
    local email=$(jq -r '.enriched.email' "$enriched_file" 2>/dev/null || echo "")
    local linkedin=$(jq -r '.enriched.linkedin' "$enriched_file" 2>/dev/null || echo "")
    local company=$(jq -r '.company' "$enriched_file" 2>/dev/null || grep -o '"company": "[^"]*"' "$enriched_file" | cut -d'"' -f4)
    
    # Append to CRM (CSV format)
    echo "$name,$company,,$email,$linkedin,,warm,$(date '+%Y-%m-%d')" >> "$CRM_FILE"
    log "Updated CRM: $name"
}

# === PROCESS LEADS ===
process_leads() {
    local batch="${1:-10}"
    local count=0
    
    log "=== Starting lead enrichment (max $batch) ==="
    
    for lead_file in "$LEADS_DIR"/*.csv 2>/dev/null; do
        [[ -f "$lead_file" ]] || continue
        
        enrich_lead "$lead_file" | while read -r enriched_file; do
            update_crm "$enriched_file"
        done
        
        ((count++))
        [[ $count -ge $batch ]] && break
    done
    
    log "=== Enrichment complete: $count leads processed ==="
}

# === MAIN ===
case "${1:-run}" in
    run)
        process_leads "${2:-10}"
        ;;
    enrich)
        [[ -n "${2:-}" ]] && enrich_lead "$2"
        ;;
    status)
        log "=== Enrichment Status ==="
        log "Leads directory: $LEADS_DIR"
        log "Files to process: $(ls "$LEADS_DIR"/*.csv 2>/dev/null | wc -l)"
        log "Enriched today: $(ls "$ENRICHED_DIR"/*$(date '+%Y%m%d')*.json 2>/dev/null | wc -l)"
        ;;
    *)
        echo "Usage: $0 {run|status} [batch_size]"
        exit 1
        ;;
esac
