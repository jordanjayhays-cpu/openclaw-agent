# SKILL INSTALLATION PLAN
## What to Install, Why, and Step-by-Step

---

## THE DECISION (Jordan Decides)

I've researched. Here's what I recommend:

**3 Skills to Install Today:**
1. Capability Evolver — Self-improvement
2. Felo Search — Research with citations
3. Felo Slides — AI PPTX generation

**Optional (High Value Later):**
- ElevenLabs Agent — Voice output
- Database Query — Pipeline tracking

---

## WHY THESE 3

### CAPABILITY EVOLVER
**What:** Most downloaded skill (35K installs). I analyze my own failures and improve.
**Why:** Compounding moat. Every session I'm better than before.
**Time:** 5 min install
**Cost:** Free

### FELO SEARCH
**What:** Real-time AI search with SOURCE CITATIONS. Not just links — answers with references.
**Why:** Research I do = backed by sources. Not my opinions.
**Time:** 10 min install + free API key
**Cost:** Free during open access

### FELO SLIDES
**What:** AI generates PPTX from prompts. "Build me a 10-slide deck" → done in 30 seconds.
**Why:** Can't build pitch decks for PISCO/COMARE clients any other way.
**Time:** 5 min install (uses same Felo API key)
**Cost:** Free during open access

---

## STEP-BY-STEP PLAN

### PHASE 1: CAPABILITY EVOLVER (5 min)

**Step 1.1:** Open terminal

**Step 1.2:** Run:
```bash
npx clawhub@latest install capability-evolver
```

**Step 1.3:** Wait 30 seconds. Done.

---

### PHASE 2: FELO SEARCH + SLIDES (15 min)

**Step 2.1:** Get FREE API key from felo.ai
- Go to felo.ai
- Sign up (free)
- Settings → API Keys → Create
- Copy the key

**Step 2.2:** Install both skills:
```bash
npx clawhub@latest install felo-search
npx clawhub@latest install felo-slides
```

**Step 2.3:** Set environment variable:
```bash
export FELO_API_KEY=your_key_here
```

**Step 2.4:** Done. Test: "Search for latest PISCO news"

---

## THE EXACT COMMANDS (Copy-Paste)

```bash
# 1. Capability Evolver
npx clawhub@latest install capability-evolver

# 2. Felo Search
npx clawhub@latest install felo-search

# 3. Felo Slides
npx clawhub@latest install felo-slides
```

Then:
- Get API key from felo.ai
- Add to environment

---

## WHAT HAPPENS AFTER

```
CAPABILITY EVOLVER:
- I run: node ~/.openclaw/skills/capability-evolver/index.js
- It analyzes what failed this week
- I apply fixes automatically
- Every session: better than before

FELO SEARCH:
- "Search for hotel staffing trends Spain 2026"
- I get: AI answer WITH source links
- Not guesses. Facts.

FELO SLIDES:
- "Build me a 10-slide pitch deck for NH Hotel"
- I generate PPTX in 30 seconds
- Download link + edit in browser
```

---

## WHAT JORDAN GETS

```
BEFORE:
- Research = my opinions
- Pitch decks = can't build
- Self-improvement = manual

AFTER:
- Research = sources I can cite
- Pitch decks = 30 seconds
- Self-improvement = automatic every session
```

---

## THE COMPOUNDING EFFECT

```
Week 1: Installed. Working.
Week 2: I analyzed 10 failures. Fixed 7.
Week 3: I generated 5 pitch decks for Jordan.
Week 4: I found 3 improvements on my own.
Month 2: I'm noticeably sharper. More useful.
Month 6: Jordan has an agent that learned 500+ lessons.
Competitor: Starts at zero.
```

---

## RISK ASSESSMENT

| Skill | Risk | Mitigation |
|-------|------|------------|
| Capability Evolver | Medium — self-modifying code | Use --review flag first |
| Felo Search | Low — read-only search | Free API, no cost |
| Felo Slides | Low — generates files | Uses Felo's servers, not ours |

---

## JORDAN'S DECISION

```
Say YES to:
1. Capability Evolver
2. Felo Search
3. Felo Slides

Say NO to:
1. [Your call]

Or modify the plan.
```

---

_Created by Claw 🦞_
_Deep Research + Plan_
_March 29, 2026_
