#!/bin/bash
# AUTO CONTENT SCHEDULER — Multi-platform posting
# Posts to Twitter, LinkedIn, Discord from queue, tracks what posted, refills when low

set -euo pipefail

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUEUE_DIR="${SCRIPT_DIR}/../QUEUE"
TWITTER_QUEUE="${QUEUE_DIR}/twitter_queue.md"
LINKEDIN_QUEUE="${QUEUE_DIR}/linkedin_queue.md"
DISCORD_QUEUE="${QUEUE_DIR}/discord_queue.md"
POST_LOG="${SCRIPT_DIR}/../LOGS/content/post_log_$(date '+%Y%m%d').csv"
CONFIG_FILE="${SCRIPT_DIR}/../CONFIG/content_config.sh"

# Load config if exists
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# Default thresholds
TWITTER_MIN_QUEUE="${TWITTER_MIN_QUEUE:-10}"
LINKEDIN_MIN_QUEUE="${LINKEDIN_MIN_QUEUE:-5}"
DISCORD_MIN_QUEUE="${DISCORD_MIN_QUEUE:-5}"

# === SETUP ===
mkdir -p "${SCRIPT_DIR}/../LOGS/content" "$QUEUE_DIR" 2>/dev/null || true

# === LOGGING ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${SCRIPT_DIR}/../LOGS/content/scheduler_$(date '+%Y%m%d').log"
}

# === POST TO TWITTER ===
post_twitter() {
    local content="$1"
    local max_len=280
    
    [[ ${#content} -gt $max_len ]] && {
        log "WARNING: Content exceeds Twitter length limit"
        content="${content:0:$max_len-3}..."
    }
    
    # Check if twitterctl or twurl available
    if command -v twitterctl &>/dev/null; then
        twitterctl tweet "$content" 2>&1 | tee -a "$POST_LOG"
        log "POSTED to Twitter: ${content:0:50}..."
    elif command -v twurl &>/dev/null; then
        twurl -X POST -H api.twitter.com "/1.1/statuses/update.json" -d "status=$content" 2>&1 | tee -a "$POST_LOG"
        log "POSTED to Twitter: ${content:0:50}..."
    elif [[ -f "${SCRIPT_DIR}/../CONFIG/twitter_api.sh" ]]; then
        source "${SCRIPT_DIR}/../CONFIG/twitter_api.sh"
        # Simple curl-based posting
        log "Twitter API configured - implement posting"
    else
        log "WARNING: No Twitter posting tool configured"
        return 1
    fi
    
    return 0
}

# === POST TO LINKEDIN ===
post_linkedin() {
    local content="$1"
    local title="${2:-}"
    
    # Check if linkedin-cli or similar available
    if command -v li &>/dev/null; then
        li post "$content" 2>&1 | tee -a "$POST_LOG"
        log "POSTED to LinkedIn: ${content:0:50}..."
    elif [[ -f "${SCRIPT_DIR}/../CONFIG/linkedin_api.sh" ]]; then
        source "${SCRIPT_DIR}/../CONFIG/linkedin_api.sh"
        # LinkedIn API posting
        log "LinkedIn API configured - implement posting"
    else
        log "WARNING: No LinkedIn posting tool configured"
        return 1
    fi
    
    return 0
}

# === POST TO DISCORD ===
post_discord() {
    local content="$1"
    local webhook_url="${DISCORD_WEBHOOK:-}"
    
    if [[ -z "$webhook_url" ]] && [[ -f "${SCRIPT_DIR}/../CONFIG/discord.sh" ]]; then
        source "${SCRIPT_DIR}/../CONFIG/discord.sh"
    fi
    
    if [[ -n "$webhook_url" ]]; then
        curl -s -X POST "$webhook_url" \
            -H "Content-Type: application/json" \
            -d "{\"content\":\"$content\"}" | tee -a "$POST_LOG"
        log "POSTED to Discord: ${content:0:50}..."
    else
        log "WARNING: No Discord webhook configured"
        return 1
    fi
    
    return 0
}

# === GET NEXT FROM QUEUE ===
get_next() {
    local queue_file="$1"
    local content=""
    
    if [[ -f "$queue_file" ]]; then
        content=$(head -1 "$queue_file")
        # Remove posted item from queue
        sed -i '1d' "$queue_file"
        echo "$content"
    else
        echo ""
    fi
}

# === COUNT QUEUE ===
count_queue() {
    local queue_file="$1"
    if [[ -f "$queue_file" ]]; then
        wc -l < "$queue_file"
    else
        echo 0
    fi
}

# === LOG POST ===
log_post() {
    local platform="$1"
    local content="$2"
    local content_hash=$(echo -n "$content" | md5sum | cut -d' ' -f1)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "$timestamp,$platform,$content_hash" >> "$POST_LOG"
}

# === POST FROM QUEUE ===
post_from_queue() {
    local platform="$1"
    local queue_file="$2"
    local count="${3:-1}"
    local posted=0
    
    local min_queue="${platform}_MIN_QUEUE"
    local current_count=$(count_queue "$queue_file")
    
    # Check if queue needs refill alert
    if [[ $current_count -lt ${!min_queue} ]]; then
        log "ALERT: $platform queue low ($current_count < ${!min_queue})"
    fi
    
    # Post up to count
    for i in $(seq 1 "$count"); do
        local content=$(get_next "$queue_file")
        
        if [[ -z "$content" ]]; then
            log "Queue empty for $platform"
            break
        fi
        
        case "$platform" in
            twitter)
                post_twitter "$content" && log_post "$platform" "$content" && ((posted++))
                ;;
            linkedin)
                post_linkedin "$content" && log_post "$platform" "$content" && ((posted++))
                ;;
            discord)
                post_discord "$content" && log_post "$platform" "$content" && ((posted++))
                ;;
        esac
    done
    
    log "Posted $posted items to $platform"
    echo $posted
}

# === REFILL QUEUE (placeholder for AI content generation) ===
refill_queue() {
    local platform="$1"
    local target_count="${2:-20}"
    local current_count=$(count_queue "${QUEUE_DIR}/${platform}_queue.md")
    local needed=$((target_count - current_count))
    
    if [[ $needed -gt 0 ]]; then
        log "Refilling $platform queue: need $needed items"
        
        # Placeholder: Call AI content generator
        # In production, this would trigger content generation
        for i in $(seq 1 "$needed"); do
            echo "[REFILL] Generated $platform content item $i at $(date)" >> "${QUEUE_DIR}/${platform}_queue.md"
        done
        
        log "Refilled $platform queue with $needed items"
    fi
}

# === POSTING SCHEDULE ===
get_schedule() {
    local hour=$(date '+%H')
    
    case "$hour" in
        06|07) echo "twitter" ;;
        09|10) echo "twitter,linkedin" ;;
        12|13) echo "twitter" ;;
        15|16) echo "twitter,discord" ;;
        18|19) echo "twitter,linkedin" ;;
        *)     echo "" ;;
    esac
}

# === MAIN ===
case "${1:-run}" in
    run)
        log "=== Starting content scheduler ==="
        
        local schedule=$(get_schedule)
        
        for platform in $schedule; do
            case "$platform" in
                twitter)   post_from_queue "twitter" "$TWITTER_QUEUE" 3 ;;
                linkedin)  post_from_queue "linkedin" "$LINKEDIN_QUEUE" 1 ;;
                discord)   post_from_queue "discord" "$DISCORD_QUEUE" 2 ;;
            esac
        done
        
        # Check and refill if needed
        for queue in twitter linkedin discord; do
            refill_queue "$queue" 20
        done
        
        log "=== Content scheduler complete ==="
        ;;
    refill)
        refill_queue "${2:-twitter}" "${3:-20}"
        ;;
    status)
        log "=== Content Queue Status ==="
        log "Twitter: $(count_queue "$TWITTER_QUEUE") items"
        log "LinkedIn: $(count_queue "$LINKEDIN_QUEUE") items"
        log "Discord: $(count_queue "$DISCORD_QUEUE") items"
        ;;
    post)
        local platform="${2:-twitter}"
        local queue_file="${QUEUE_DIR}/${platform}_queue.md"
        post_from_queue "$platform" "$queue_file" "${3:-1}"
        ;;
    *)
        echo "Usage: $0 {run|refill|status|post}"
        exit 1
        ;;
esac
