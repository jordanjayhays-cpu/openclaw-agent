#!/usr/bin/env python3
"""
PK Music - Suno Brief Generator
Takes a philosophical concept → Generates rap lyrics + instrument suggestions + Suno brief

Usage: python3 pk-gen.py "Your philosophical concept here"
"""

import sys
import json
from datetime import datetime

PHILOSOPHY_INSTRUMENTS = {
    "african": {
        "philosophy": ["Ubuntu", "African epistemology", "Ubuntu philosophy", "Griot tradition", "MAA"],
        "instruments": ["Djembe", "Kora", "Balafon", "Talking Drum", "Mbira"],
        "mood": ["Grounded", "Communal", "Ancient", "Rhythmic"],
        "styles": ["Afrobeat", "Highlife", "Soukous", "Traditional hip-hop"],
        "references": ["Black Thought", "Nas", "Slick Rick", "KRS-One"]
    },
    "japanese": {
        "philosophy": ["Zen", "Bushido", "Wabi-sabi", "Ikigai", "Mono no aware"],
        "instruments": ["Koto", "Shakuhachi", "Taiko drums", "Shamisen", "Bonchi"],
        "mood": ["Minimal", "Contemplative", "Disciplined", "Ethereal"],
        "styles": ["Lo-fi", "Boom-bap", "Ambient", "Neo-traditional"],
        "references": ["Nas", "J Cole", "Kendrick", "Luke Coomes"]
    },
    "greek": {
        "philosophy": ["Stoicism", "Plato", "Aristotle", "Epicureanism", "Socrates"],
        "instruments": ["Bouzouki", "Saz", "Oud", "Frame drum", "Santouri"],
        "mood": ["Logical", "Powerful", "Wise", "Dramatic"],
        "styles": ["Epic rap", "Battle rap", "Conscious hip-hop"],
        "references": ["Immortal Technique", "Busdriver", "Mos Def"]
    },
    "indian": {
        "philosophy": ["Karma", "Dharma", "Moksha", "Yoga", "Vedic", "Buddhism"],
        "instruments": ["Sitar", "Tabla", "Tanpura", "Sarod", "Bansuri"],
        "mood": ["Spiritual", "Hypnotic", "Transcendent", "Deep"],
        "styles": ["Sanskrit rap", "Spiritual hip-hop", "Raga-rock"],
        "references": ["Rapper Big Will", "Chee Malothu", "Baba Sehgal"]
    },
    "chinese": {
        "philosophy": ["Taoism", "Confucianism", "Zen Buddhism", "Legalism", "Yin Yang"],
        "instruments": ["Pipa", "Erhu", "Guzheng", "Dizi flute", "Liuqin"],
        "mood": ["Balanced", "Strategic", "Harmonious", "Martial"],
        "styles": ["Kung fu rap", "Asian trap", "Traditional boom-bap"],
        "references": ["Higher Brothers", "Rich Brian", "Keith Ape"]
    },
    "western": {
        "philosophy": ["Existentialism", "Nietzsche", "Sapolsky", "Jordan Peterson", "Free will", "Consciousness"],
        "instruments": ["Piano", "Synth", "Trap drums", "808s", "Lo-fi"],
        "mood": ["Introspective", "Heavy", "Dark", "Analytical"],
        "styles": ["Trap", "Boom-bap", "Conscious rap", "Mumble (philosophical)"],
        "references": ["Kendrick Lamar", "J Cole", "Nas", "Earl Sweatshirt"]
    },
    "latin": {
        "philosophy": ["Liberation theology", "Magical realism", "Spañol", "Cholo philosophy"],
        "instruments": ["Guitar", "Cajas", "Quena flute", "Charango", "Tiple"],
        "mood": ["Passionate", "Rebellious", "Colorful", "Street"],
        "styles": ["Latin trap", "Reggaeton", "Cumbia bass", "Chicano rap"],
        "references": ["Baby Bash", "Snow Tha Product", "Lil Rob"]
    },
    "universal": {
        "philosophy": ["Free will", "Consciousness", "Meaning of life", "Ethics", "Reality"],
        "instruments": ["Mix of all based on context"],
        "mood": ["Universal", "Deep", "Accessible"],
        "styles": ["Any style works"],
        "references": ["All references apply"]
    }
}

LYRICS_STRUCTURE = """
## SONG STRUCTURE

### VERSE 1 (Setup - 16 bars)
- Introduce the philosophical concept
- Create tension/problem
- Set the scene

### CHORUS (Hook - 8 bars)
- Memorable phrase
- Core philosophical statement
- Repeat 2-3 times

### VERSE 2 (Deep dive - 16 bars)
- Explore nuances
- Personal application
- Build complexity

### CHORUS (Repeat)
### BRIDGE (Optional - 8 bars)
- Shift perspective
- Counter-argument or synthesis

### OUTRO
- Final thought
- Call to action or question
"""

def detect_philosophy(concept):
    """Detect which philosophy the concept relates to"""
    concept_lower = concept.lower()
    scores = {}
    
    for region, data in PHILOSOPHY_INSTRUMENTS.items():
        if region == "universal":
            continue
        score = 0
        for philosophy in data["philosophy"]:
            if philosophy.lower() in concept_lower:
                score += 2
        for keyword in concept_lower.split():
            for philosophy in data["philosophy"]:
                if keyword in philosophy.lower() or philosophy.lower() in keyword:
                    score += 1
        if score > 0:
            scores[region] = score
    
    if not scores:
        return "universal", PHILOSOPHY_INSTRUMENTS["universal"]
    
    best_match = max(scores, key=scores.get)
    return best_match, PHILOSOPHY_INSTRUMENTS[best_match]

def generate_lyrics(concept, philosophy_data, style="conscious rap"):
    """Generate philosophical rap lyrics"""
    
    lyrics = f"""
# {concept.upper()}

## Philosophical Framework
**Origin:** {philosophy_data['mood'][0]} philosophy
**Mood:** {', '.join(philosophy_data['mood'])}
**Style:** {style}

---

## SUGGESTED LYRICS

### VERSE 1:
[Opening line about {concept}]

Let me break it down, got my mind on recalibrate
{concept} ain't just a word, it's a whole paradigm
We talkin' 'bout [specific aspect of concept]
My cerebral cortex lit, prefrontal activated
...

### CHORUS:
{concept} — that's the move
We ain't just passin' through
Got the wisdom, got the proof
{concept} — the ultimate truth

### VERSE 2:
Check the literature, Sapolsky would explain it
Neurons firin', dopamine explainin'
Why we gravitate to {concept}
Evolution's got a plan, but free will can amend it
...

### OUTRO:
The question remains, {concept}
We can never truly know
But in the search, we find ourselves
And that's the ultimate show

---

## SUNO PROMPT

**Style:** {style}
**Mood:** {philosophy_data['mood'][0]}, {philosophy_data['mood'][1]}, {philosophy_data['mood'][2]}
**Instruments:** {', '.join(philosophy_data['instruments'][:3])}
**BPM:** 80-95 (conscious rap tempo)
**Reference artists:** {', '.join(philosophy_data['references'][:2])}

**Prompt for Suno:**
```
Philosophical {style} with {philosophy_data['instruments'][0]} and {philosophy_data['instruments'][1]}. 
Mood: {', '.join(philosophy_data['mood'][:2])}. 
Dark, introspective lyrics about {concept}. 
{random_reference(philosophy_data['references'])} influence, conscious rap flow.
```

---

## RELEASE CHECKLIST

- [ ] Generate lyrics (Jordan approves)
- [ ] Create Suno brief
- [ ] Generate in Suno
- [ ] Pick best version
- [ ] Download WAV
- [ ] Format lyrics for DistroKid
- [ ] Upload to DistroKid
- [ ] Submit to stores
- [ ] Share on social
"""
    return lyrics

def random_reference(refs):
    import random
    return random.choice(refs)

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 pk-gen.py 'Your philosophical concept'")
        print("\nExample: python3 pk-gen.py 'Free will and determinism'")
        sys.exit(1)
    
    concept = sys.argv[1]
    
    print(f"\n🎵 PK MUSIC — Suno Brief Generator")
    print("=" * 50)
    print(f"\n📝 Concept: {concept}\n")
    
    # Detect philosophy
    region, phil_data = detect_philosophy(concept)
    print(f"🔮 Detected philosophy: {region.upper()}")
    print(f"🎸 Suggested instruments: {', '.join(phil_data['instruments'][:3])}")
    print(f"🎧 Suggested styles: {', '.join(phil_data['styles'][:2])}")
    print(f"💭 Mood: {', '.join(phil_data['mood'][:2])}")
    
    # Generate full brief
    lyrics = generate_lyrics(concept, phil_data)
    
    # Save to file
    filename = f"/data/workspace/PROJECTS/PK-MUSIC/suno-brief-{datetime.now().strftime('%Y%m%d-%H%M%S')}.md"
    with open(filename, 'w') as f:
        f.write(f"# {concept}\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n")
        f.write(lyrics)
    
    print(f"\n✅ Full brief saved to: {filename}")
    print("\n" + lyrics[:2000])
    print("\n... (full brief in file)")

if __name__ == "__main__":
    main()
