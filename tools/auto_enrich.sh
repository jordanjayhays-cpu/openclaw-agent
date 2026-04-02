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
    
    # Check for LinkedIn search tool
    if command -v linkedin-search &>/dev/null; then
        linkedin-search "$name" "$company" 2>/dev/null
    elif [[ -f "$API_CONFIG" ]]; then
        source "$API_CONFIG"
        # Would use LinkedIn API or scraping service
        echo ""
    else
        # Manual search URL generation
        local encoded_name=$(echo "$name" | sed 's/ /%20/g')
        echo "https://www.linkedin.com/search/results/all/?keywords=$encoded_name%20$company"
    fi
}

# === FIND EMAIL ===
find_email() {
    local name="$1"
    local company="$2"
    
    # Check for email finding service
    if command -v hunter &>/dev/null; then
        hunter find "$name" "$company" 2>/dev/null
    elif command -v emailhunter &>/dev/null; then
        emailhunter "$name" "$company" 2>/dev/null
    elif [[ -f "$API_CONFIG" ]]; then
        source "$API_CONFIG"
        # Would use NeverBounce, Hunter.io, or similar
        echo ""
    else
        # Placeholder pattern
        local first=$(echo "$name" | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
        local last=$(echo "$name" | cut -d' ' -f2 | tr '[:upper:]' '[:lower:]')
        local domain=$(echo "$company" | sed 's/ /./g' | tr '[:upper:]' '[:lower:]')
        echo "${first}.${last}@${domain}.com"
    fi
}

# === FIND COMPANY INFO ===
find_company_info() {
    local company="$1"
    
    # Check for company lookup service
    if command -v clearbit &>/dev/null; then
        clearbit company "$company" 2>/dev/null
    elif [[ -f "$API_CONFIG" ]]; then
        source "$API_CONFIG"
        # Would use Clearbit, ZoomInfo, or similar
        echo ""
    else
        # Basic info placeholders
        cat << EOF
{"company":"$company","industry":"","size":"","revenue":"","website":""}
EOF
    fi
}

# === ENRICH LEAD ===
enrich_lead() {
    local lead_file="$1"
    local name=$(basename "$lead_file" .csv)
    
    log "Enriching lead: $name"
    
    # Read lead data
    local name company website phone source
    read -r name company website phone source < <(head -1 "$lead_file" | tr ',' ' ')
    
    # Find LinkedIn
    local linkedin=$(find_linkedin "$name" "$company")
    log "  LinkedIn: $linkedin"
    
    # Find Email
    local email=$(find_email "$name" "$company")
    log "  Email: $email"
    
    # Find Company Info
    local company_info=$(find_company_info "$company")
    log "  Company: $company_info"
    
    # Create enriched record
    local enriched_file="${ENRICHED_DIR}/${name}_$(date '+%Y%m%d').json"
    cat > "$enriched_file" << EOF
{
    "name": "$name",
    "company": "$company",
    "website": "$website",
    "phone": "$phone",
    "source": "$source",
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
    local