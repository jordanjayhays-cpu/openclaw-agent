#!/bin/bash
# AUTO PIPELINE BUILDER — Prospect Generation & Qualification
# Finds new prospects, qualifies them, adds to CRM, scores them, prioritizes for Jordan

set -euo pipefail

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CRM_FILE="${SCRIPT_DIR}/../CRM/contacts.csv"
PROSPECTS_DIR="${SCRIPT_DIR}/../PROSPECTS"
QUALIFIED_DIR="${PROSPECTS_DIR}/qualified"
RAW_DIR="${PROSPECTS_DIR}/raw"
PIPELINE_LOG="${SCRIPT_DIR}/../LOGS/pipeline_$(date '+%Y%m%d').log"
SCORING_MODEL="${SCRIPT_DIR}/../CONFIG/scoring_model.sh"

# === SETUP ===
mkdir -p "$QUALIFIED_DIR" "$RAW_DIR" "$PROSPECTS_DIR" "${SCRIPT_DIR}/../CRM" "${SCRIPT_DIR}/../LOGS" 2>/dev/null || true

# === LOGGING ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$PIPELINE_LOG"
}

# === FIND PROSPECTS ===
find_prospects() {
    local vertical="${1:-}"
    local count="${2:-50}"
    
    log "=== Finding prospects for: ${vertical:-all verticals} ==="
    
    # Source-specific discovery
    case "$vertical" in
        hotels)
            find_hotel_prospects "$count"
            ;;
        music)
            find_music_prospects "$count"
            ;;
        neurotech)
            find_neurotech_prospects "$count"
            ;;
        *)
            find_all_prospects "$count"
            ;;
    esac
}

# === HOTEL PROSPECTS ===
find_hotel_prospects() {
    local count="$1"
    local countries=("Spain" "Portugal" "Germany" "France" "Italy" "Netherlands")
    
    for country in "${countries[@]}"; do
        # Placeholder - would use LinkedIn Sales Navigator, Apollo.io, etc.
        local output_file="${RAW_DIR}/hotels_${country}_$(date '+%Y%m%d').csv"
        
        # Generate prospect list (placeholder)
        cat > "$output_file" << EOF
name,company,website,vertical,source,found_date
Hotel Manager,$country Hotel Chain,$country.hotels.example.com,hotels,apollo,$(date '+%Y-%m-%d')
EOF
        
        log "Found prospects in $country: $output_file"
    done
}

# === MUSIC PROSPECTS ===
find_music_prospects() {
    local count="$1"
    local output_file="${RAW_DIR}/music_prospects_$(date '+%Y%m%d').csv"
    
    # Placeholder - would scrape SoundCloud, Spotify, YouTube for independent artists
    cat > "$output_file" << EOF
name,handle,platform,followers,vertical,source,found_date
Artist Name,@artistname,soundcloud,5000,music,web_scraping,$(date '+%Y-%m-%d')
EOF
    
    log "Found music prospects: $output_file"
}

# === NEUROTECH PROSPECTS ===
find_neurotech_prospects() {
    local count="$1"
    local output_file="${RAW_DIR}/neurotech_prospects_$(date '+%Y%m%d').csv"
    
    # Placeholder - would find YouTubers, podcasters in neuroscience/self-improvement
    cat > "$output_file" << EOF
name,channel,subscribers,vertical,source,found_date
NeuroScience Hub,YouTube,100000,neurotech,youtube_api,$(date '+%Y-%m-%d')
EOF
    
    log "Found neurotech prospects: $output_file"
}

# === ALL PROSPECTS ===
find_all_prospects() {
    find_hotel_prospects 20
    find_music_prospects 20
    find_neurotech_prospects 10
}

# === QUALIFY PROSPECTS ===
qualify_prospect() {
    local prospect_file="$1"
    local score=0
    
    # Load scoring model
    [[ -f "$SCORING_MODEL" ]] && source "$SCORING_MODEL"
    
    # Read prospect data
    local name company website followers source
    IFS=',' read -r name company website followers source < <(head -1 "$prospect_file")
    
    # Scoring logic
    [[ "$source" == *"linkedin"* ]] && score=$((score + 10))
    [[ "$source" == *"apollo"* ]] && score=$((score + 15))
    [[ "$source" == *"referral"* ]] && score=$((score + 25))
    
    # Company size scoring (placeholder)
    [[ -n "$company" ]] && score=$((score + 20))
    
    # Follower/size indicators
    [[ -n "$followers" ]] && [[ "$followers" -gt 10000 ]] && score=$((score + 15))
    
    # Website presence
    [[ -n "$website" ]] && score=$((score + 10))
    
    # Cap at 100
    [[ $score -gt 100 ]] && score=100
    
    echo "$score"
}

# === SCORE PROSPECT ===
score_prospect() {
    local name="$1"
    local company="$2"
    local vertical="$3"
    
    local score=50  # Base score
    
    # Source scoring
    score=$((score + 10))
    
    # Vertical fit scoring
    case "$vertical" in
        hotels)
            [[ "$company" == *"hotel"* ]] && score=$((score + 20))
            [[ "$company" == *"resort"* ]] && score=$((score + 20))
            [[ "$company" == *"NH"* ]] && score=$((score + 30))
            ;;
        music)
            score=$((score + 15))
            ;;
        neurotech)
            score=$((score + 15))
            ;;
    esac
    
    # Company indicators
    [[ -n "$company" ]] && score=$((score + 10))
    
    # Limit score
    [[ $score -gt 100 ]] && score=100
    [[ $score -lt 0 ]] && score=0
    
    echo $score
}

# === ADD TO CRM ===
add_to_crm() {
    local name="$1"
    local company="$2"
    local email="$3"
    local linkedin="$4"
    local score="$5"
    local vertical="$6"
    
    # Ensure CRM exists
    [[ ! -f "$CRM_FILE" ]] && echo "name,company,email,linkedin,status,score,vertical,last_contacted" > "$CRM_FILE"
    
    # Check if already exists
    if grep -q "$email" "$CRM_FILE" 2>/dev/null; then
        log "Already in CRM: $name <$email>"
        return 1
    fi
    
    # Add to CRM
    echo "$name,$company,$email,$linkedin,cold,$score,$vertical,$(date '+%Y-%m-%d')" >> "$CRM_FILE"
    log "Added to CRM: $name ($score pts)"
}

# === PRIORITIZE ===
prioritize() {
    local limit="${1:-20}"
    
    log "=== Prioritizing top $limit prospects ==="
    
    if [[ ! -f "$CRM_FILE" ]]; then
        log "No CRM data found"
        return
    fi
    
    # Sort by score descending, filter cold leads
    grep "cold" "$CRM_FILE" | sort -t',' -k5 -rn | head -"$limit" | \
        while IFS=',' read -r name company email linkedin status score vertical last_contacted; do
            echo "[$score] $name - $company ($vertical)"
        done
}

# === BUILD PIPELINE ===
build_pipeline() {
    local batch_size="${1:-50}"
    
    log "=== Building pipeline (batch: $batch_size) ==="
    
    # Find new prospects
    find_prospects "" "$batch_size"
    
    # Process and qualify
    for prospect_file in "$RAW_DIR"/*.csv 2>/dev/null; do
        [[ -f "$prospect_file" ]] || continue
        
        while IFS=',' read -r name company website followers source found_date; do
            [[ "$name" == "name" ]] && continue
            
            # Score
            local score=$(score_prospect "$name" "$company" "$vertical")
            
            # Add to CRM
            add_to_crm "$name" "$company" "" "" "$score" "$vertical"
            
        done < <(tail -n +2 "$prospect_file")
        
        # Move to qualified
        mv "$prospect_file" "$QUALIFIED_DIR/"
    done
    
    log "=== Pipeline built ==="
}

# === MAIN ===
case "${1:-run}" in
    run)
        build_pipeline "${2:-50}"
        ;;
    find)
        find_prospects "${2:-}" "${3:-50}"
        ;;
    qualify)
        [[ -n "${2:-}" ]] && qualify_prospect "$2"
        ;;
    score)
        score_prospect "${2:-}" "${3:-}" "${4:-}"
        ;;
    prioritize)
        prioritize "${2:-20}"
        ;;
    status)
        log "=== Pipeline Status ==="
        log "Raw prospects: $(ls "$RAW_DIR"/*.csv 2>/dev/null | wc -l)"
        log "Qualified prospects: $(ls "$QUALIFIED_DIR"/*.csv 2>/dev/null | wc -l)"
        log "Total CRM contacts: $(wc -l < "$CRM_FILE" 2>/dev/null || echo 0)"
        ;;
    *)
        echo "Usage: $0 {run|find|qualify|score|prioritize|status}"
        exit 1
        ;;
esac
