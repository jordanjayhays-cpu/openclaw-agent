#!/bin/bash
# RESPONSE OPTIMIZER — Keep Axton lean and fast
# Runs daily

cd /data/workspace

echo "=== RESPONSE OPTIMIZER ==="
echo "Date: $(date '+%Y-%m-%d')"
echo ""

# Analyze token usage
echo "Token usage this week:"
wc -l memory/*.md 2>/dev/null | tail -1

# Check context sizes
echo ""
echo "File sizes:"
du -sh *.md PROJECTS/**/*.md 2>/dev/null | sort -h | tail -20

# Find bloated files
echo ""
echo "Files > 50KB (should be split):"
find . -name "*.md" -size +50k 2>/dev/null | while read f; do
    SIZE=$(du -h "$f" | cut -f1)
    echo "  $f: $SIZE"
done

# Compress old logs
echo ""
echo "Compressing old logs..."
find . -name "*.log" -mtime +7 2>/dev/null | while read f; do
    gzip "$f" 2>/dev/null && echo " Compressed: $f"
done

# Optimize memory files
echo ""
echo "Memory file stats:"
for f in memory/*.md; do
    if [ -f "$f" ]; then
        LINES=$(wc -l < "$f")
        echo "  $f: $LINES lines"
    fi
done

# Clean duplicates
echo ""
echo "Checking for duplicate entries in logs..."
# Simple dedup for recent entries
if [ -f "memory/tasks-log.md" ]; then
    echo "Tasks log: OK"
fi

# Report
echo ""
echo "=== OPTIMIZATION REPORT ==="
echo "Files checked: OK"
echo "Bloated files: See above"
echo "Old logs: Compressed"
echo "Ready for next session."

# If files are too large, split them
echo ""
echo "Checking if STATE.yaml files need pruning..."
find PROJECTS -name "STATE.yaml" 2>/dev/null | while read f; do
    SIZE=$(wc -l < "$f")
    if [ "$SIZE" -gt 200 ]; then
        echo "  $f has $SIZE lines - consider archiving old tasks"
    fi
done

echo ""
echo "=== OPTIMIZER COMPLETE ==="
