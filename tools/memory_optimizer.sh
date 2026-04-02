#!/bin/bash
# Memory Optimizer - Compress, deduplicate, and index Jordan's memory files
# Run: ./memory_optimizer.sh

MEMORY_DIR="memory"
INDEX_FILE="$MEMORY_DIR/.index"
TRASH_DIR=".memory_trash"
LOG_FILE="SUCCESS_LOG/memory_optimizer.log"

echo "=== Memory Optimizer ==="
echo "Started: $(date)"
mkdir -p "$TRASH_DIR" "SUCCESS_LOG"

optimized=0
duplicates=0
compressed=0

# Create index of all memory files
create_index() {
    echo "Creating memory index..."
    > "$INDEX_FILE"
    
    for f in "$MEMORY_DIR"/*.md "$MEMORY_DIR"/**/*.md 2>/dev/null; do
        [ -f "$f" ] || continue
        size=$(stat -f%z "$f" 2>/dev/null || stat -c%s "$f" 2>/dev/null)
        words=$(wc -w < "$f" 2>/dev/null || echo 0)
        hash=$(md5sum "$f" 2>/dev/null | cut -d' ' -f1 || cat "$f" | md5)
        echo "$f|$size|$words|$hash" >> "$INDEX_FILE"
    done
    
    echo "Indexed $(wc -l < "$INDEX_FILE") files"
}

# Find and remove duplicate content
deduplicate() {
    echo "Scanning for duplicates..."
    
    declare -A hashes
    for f in "$MEMORY_DIR"/*.md 2>/dev/null; do
        [ -f "$f" ] || continue
        
        hash=$(md5sum "$f" 2>/dev/null | cut -d' ' -f1)
        
        if [ -n "${hashes[$hash]}" ]; then
            echo "Duplicate found: $f == ${hashes[$hash]}"
            mv "$f" "$TRASH_DIR/$(basename $f).dup.$(date +%s)"
            ((duplicates++))
        else
            hashes[$hash]="$f"
        fi
    done
}

# Compress old memory files
compress_old() {
    echo "Compressing old files..."
    
    cutoff=$(date -d '30 days ago' +%s 2>/dev/null || date -v-30d +%s)
    
    for f in "$MEMORY_DIR"/*.md; do
        [ -f "$f" ] || continue
        
        file_date=$(stat -f%Sm -t%s "$f" 2>/dev/null || stat -c%Y "$f" 2>/dev/null)
        
        if [ "$file_date" -lt "$cutoff" ] && [ ! -f "${f}.gz" ]; then
            gzip -k "$f"
            ((compressed++))
            echo "Compressed: $f"
        fi
    done
}

# Merge fragmented files
merge_fragments() {
    echo "Checking for fragmentable content..."
    
    # Find date-stamped files that might be session logs
    for f in "$MEMORY_DIR"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].md; do
        [ -f "$f" ] || continue
        
        # Check if file is very small (< 200 bytes) - likely fragment
        size=$(wc -c < "$f")
        if [ "$size" -lt 200 ]; then
            # Check for larger file with same date prefix
            date_prefix=$(basename "$f" .md)
            larger_file=$(ls "$MEMORY_DIR"/${date_prefix}*.md 2>/dev/null | head -1)
            if [ -f "$larger_file" ] && [ "$larger_file" != "$f" ]; then
                echo "Small fragment $f may belong to $larger_file - marking for review"
                echo "$f: small fragment, may need merge" >> "$TRASH_DIR/fragments_to_review.txt"
            fi
        fi
    done
}

# Clean empty files
clean_empty() {
    echo "Removing empty files..."
    for f in "$MEMORY_DIR"/*.md; do
        [ -f "$f" ] || continue
        if [ ! -s "$f" ]; then
            mv "$f" "$TRASH_DIR/empty_$(basename $f).$(date +%s)"
            echo "Removed empty: $f"
        fi
    done
}

# Generate summary
generate_summary() {
    total_files=$(find "$MEMORY_DIR" -name "*.md" 2>/dev/null | wc -l)
    total_size=$(du -sh "$MEMORY_DIR" 2>/dev/null | cut -f1)
    
    echo ""
    echo "=== Optimization Complete ==="
    echo "Files indexed: $(wc -l < "$INDEX_FILE")"
    echo "Duplicates removed: $duplicates"
    echo "Files compressed: $compressed"
    echo "Total memory files: $total_files"
    echo "Total size: $total_size"
    
    echo "$(date): optimized $total_files files, $duplicates duplicates, $compressed compressed" >> "$LOG_FILE"
}

# Main execution
create_index
deduplicate
compress_old
merge_fragments
clean_empty
generate_summary

echo ""
echo "Index saved to: $INDEX_FILE"
echo "Removed files in: $TRASH_DIR"
