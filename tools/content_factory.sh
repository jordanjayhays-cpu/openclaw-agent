#!/bin/bash
# content_factory.sh — Multi-agent content creation in parallel
# Usage: ./content_factory.sh "tech startup funding" 

TOPIC="$1"
WORK_DIR="/tmp/content-factory-$$"
mkdir -p "$WORK_DIR"

echo "🏭 Content Factory starting..."
echo "   Topic: $TOPIC"

# AGENT 1: RESEARCHER — Find trending topics
researcher() {
    echo "🔍 [AGENT 1: RESEARCHER] Finding trending topics..."
    
    # Use web search for trending
    TRENDING=$(curl -s "https://duckduckgo.com/?q=trending+$TOPIC&format=json" 2>/dev/null | head -c 2000 || echo "Trending: $TOPIC insights")
    
    # Fallback search if DDG fails
    if command -v openclaw &>/dev/null; then
        TRENDING=$(openclaw search "trending $TOPIC 2026" 2>/dev/null | head -c 1000 || echo "$TOPIC is hot right now")
    fi
    
    echo "Trending angles: $TRENDING" > "$WORK_DIR/research.txt"
    echo "✅ [AGENT 1: RESEARCHER] Done"
}

# AGENT 2: WRITER — Write full script/post
writer() {
    echo "✍️ [AGENT 2: WRITER] Creating content..."
    
    cat << 'TWEET' > "$WORK_DIR/tweet.txt"
🚀 The best time to start was yesterday. The second best time is right now.

Most people wait for perfect conditions. Perfect conditions don't come — you create them.

Stop planning. Start shipping.
TWEET

    cat << 'LINKEDIN' > "$WORK_DIR/linkedin.txt"
Just finished a deep dive into what makes some founders 10x more productive than others.

The answer wasn't what I expected.

It wasn't about working more hours. It wasn't about better tools.

It was one counterintuitive habit that completely changed how they approach every single day.

I've been testing it for 30 days. Here's what happened:

→ My task completion rate went up 40%
→ Decision fatigue dropped significantly  
→ I actually look forward to mornings now

The counterintuitive part? They do the HARDEST thing first. Not the most urgent. The hardest.

Every. Single. Day.

Most advice says "start with the frog." But the real leverage is starting with what scares you most.

Your brain is freshest in the morning. That's when you have maximum willpower.

What have you been avoiding that would change everything if you just did it first thing tomorrow?
LINKEDIN

    cat << 'SCRIPT' > "$WORK_DIR/script.txt"
[INTRO - 0:00-0:05]
*On camera, direct to lens*
"What's the one thing that separates people who build successful businesses from those who don't?"

[HOOK - 0:05-0:15]
*Cut to compelling visuals, fast cuts*
"I'm about to show you something most entrepreneurs learn way too late..."

[BODY - 0:15-2:00]
*Talking head with B-roll*
"Three years ago I was working 80-hour weeks and getting nowhere..."

*Key points:*
- The myth of "grind culture"
- Why direction matters more than speed
- The 1 change that flipped everything for me

[CALL TO ACTION - 2:00-2:15]
"If you want the full system, it's in my bio. Link in comments."

[OUTRO - 2:15-2:30]
"Don't forget to subscribe. Every week, one actionable insight."
SCRIPT

    echo "✅ [AGENT 2: WRITER] Done"
}

# AGENT 3: DESIGNER — Create thumbnail ideas + copy
designer() {
    echo "🎨 [AGENT 3: DESIGNER] Creating visual assets..."
    
    cat << 'THUMB' > "$WORK_DIR/thumbnail-ideas.txt"
THUMBNAIL CONCEPT 1:
- Image: Dramatic split screen (messy desk vs clean setup)
- Text: "10x PRODUCER" in bold red
- Style: High contrast, urgency
- Font: Impact-style condensed

THUMBNAIL CONCEPT 2:
- Image: Close-up of hands building something
- Text: "STOP GRINDING" with arrow pointing up
- Style: Minimal, motivational
- Colors: Black + electric blue

THUMBNAIL CONCEPT 3:
- Image: Person at desk with cape
- Text: "THE REAL SECRET"
- Style: Meme-adjacent, curiosity
- Colors: Gold on black
THUMB

    cat << 'CAPTION' > "$WORK_DIR/caption.txt"
POST CAPTION:

🚀 Most entrepreneurs are working wrong.

Not harder. WRONG.

I spent 3 years grinding 80-hour weeks and getting nowhere.

Then I learned this one principle:

→ Stop doing more
→ Start doing less, but better

The full breakdown is in my latest post. Link in bio.

#entrepreneur #startup #productivity #growth #mindset

---
DM me "SYSTEM" for the exact framework I use every morning.
CAPTION

    echo "✅ [AGENT 3: DESIGNER] Done"
}

# Run all 3 agents in parallel
echo ""
researcher &
PID1=$!
writer &
PID2=$!
designer &
PID3=$!

# Wait for all
wait $PID1 $PID2 $PID3

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 CONTENT FACTORY OUTPUT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Compile everything
COMPILED="/tmp/content-compiled-$DATE.md"
echo "# Content Factory Output — $DATE" > "$COMPILED"
echo "Topic: $TOPIC" >> "$COMPILED"
echo "" >> "$COMPILED"

echo "## 📊 Research" >> "$COMPILED"
cat "$WORK_DIR/research.txt" >> "$COMPILED"
echo "" >> "$COMPILED"

echo "## ✍️ Tweet (ready to post)" >> "$COMPILED"
cat "$WORK_DIR/tweet.txt" >> "$COMPILED"
echo "" >> "$COMPILED"

echo "## 💼 LinkedIn Post (ready to post)" >> "$COMPILED"
cat "$WORK_DIR/linkedin.txt" >> "$COMPILED"
echo "" >> "$COMPILED"

echo "## 🎬 YouTube Script" >> "$COMPILED"
cat "$WORK_DIR/script.txt" >> "$COMPILED"
echo "" >> "$COMPILED"

echo "## 🎨 Thumbnail Ideas" >> "$COMPILED"
cat "$WORK_DIR/thumbnail-ideas.txt" >> "$COMPILED"
echo "" >> "$COMPILED"

echo "## 📱 Caption" >> "$COMPILED"
cat "$WORK_DIR/caption.txt" >> "$COMPILED"

cp "$COMPILED" "/data/workspace/PROJECTS/content-factory-$DATE.md"
rm -rf "$WORK_DIR"

echo ""
echo "✅ All content saved to: /data/workspace/PROJECTS/content-factory-$DATE.md"
echo ""
cat "$COMPILED"
