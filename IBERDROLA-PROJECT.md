# Iberdrola EV Charging Network — Project Documentation

## What This Project Is

**Iberdrola Sustainability Datathon** — Team Electric Dragon
- **Team:** Jules Doctora, Manuel Mapa, Jordan Hays, Yi Long, Silvia Mendoza, Almutasem Falatah
- **Goal:** Recommend where Iberdrola should deploy next-best EV charging stations across Spain
- **Timeline:** Data analysis → Strategy → Executive dashboard

---

## Project Structure

```
IBERDROLA/
├── Iberdrola_-_Case_Strategy.pdf          # Full strategy document
├── IE-Iberdrola_Datathon_Marzo_2026.pdf  # Datathon details
├── network_dashboard_revised.html         # Interactive dashboard (REFERENCE)
└── EV-Charging-App/                       # App being built in Lovable
```

---

## The Data — What We Had

- **4,801 existing charging stations** across Spain
- **627 proposed new locations** for deployment
- **3 deployment tiers:**
  - **Tier 1** (green): Upgrade existing Iberdrola stations
  - **Tier 2** (blue): Partner co-location (e.g., shopping malls, petrol stations)
  - **Tier 3** (orange): New partner needed from scratch
- **Grid capacity constraints:** Sufficient / Moderate / Congested
- **Priority matrix:** High/Med/Low demand × Grid status
- **EV fleet forecast:** 550K now → 5.5M by 2030 (EU target)

---

## The Problem We're Solving

**Executive question:** "Which charging station should we deploy NEXT?"

An Iberdrola executive needs to:
1. See ranked recommendations at a glance
2. Filter by tier, grid status, priority
3. Understand the tradeoffs
4. Make a decision in < 2 minutes from their phone

---

## The Dashboard (Reference) — What It Looks Like

The `network_dashboard_revised.html` is the ANALYST version — dense, data-heavy, for the team. It has:
- Spain map with 627 proposed stations + 4,801 existing
- Scenario toggles (Conservative 60% / Baseline 80% / Aggressive 100%)
- Priority matrix (Demand × Grid)
- KPIs: total locations, chargers, peak MW, P80 daily sessions
- Day-of-week demand charts
- Grid capacity breakdown

---

## The App — What We're Building in Lovable

**Name:** "Next Best Charger"

**User:** Iberdrola executive, mobile-first, on the go

**One feature:** Ranked list of the 627 recommended stations, filterable and tappable

### Three Views:

**1. LIST VIEW** (default)
- Ranked by priority (High demand + Sufficient grid = top)
- Each card: Station ID, Tier badge, Grid status, Priority, Chargers, MW
- Filters: Scenario, Tier, Grid Status, Priority, Search

**2. MATRIX VIEW** (key differentiator)
- 3×3 grid: Demand (High/Med/Low) × Grid (Sufficient/Moderate/Congested)
- Cell = count of stations
- Tap cell → filtered list of stations in that quadrant

**3. MAP VIEW**
- Spain map with colored markers
- Tap marker → station card popup

### KPI Strip (all views)
- Total locations
- Total chargers needed
- Peak MW demand
- Tier breakdown

---

## How to Use Lovable — Step by Step

### Step 1: Get the Prompt Ready

Copy the prompt below (or use the one in this folder).

### Step 2: Go to Lovable

1. Open **lovable.dev** in your browser
2. Sign in with GitHub or Google
3. Click **"Create New Project"**
4. Choose **"Import from prompt"** or paste the prompt in the chat

### Step 3: Paste the Prompt

```
Build a mobile-first executive dashboard app for Iberdrola's EV charging network expansion in Spain.

APP NAME: "Next Best Charger"

ONE-LINE PITCH: Help an Iberdrola executive instantly find and prioritize the next best charging station to deploy.

CORE FEATURE — STATION RANKINGS:
Show a ranked list of 627 proposed charging station locations, sorted by "best next deployment." Each station card shows:
- Station ID + Route name
- Tier: [1] Iberdrola Upgrade / [2] Partner Co-location / [3] New Partner
- Grid Status: 🟢 Sufficient / 🟡 Moderate / 🔴 Congested
- Priority Score: HIGH / MEDIUM / LOW
- Chargers needed (150 kW DC)
- Peak MW demand
- Estimated daily sessions
- One tap → full station detail

FILTERS:
- Search by route or station ID
- Scenario: Conservative (60%) / Baseline (80%) / Aggressive (100%)
- Tier: All / Tier 1 / Tier 2 / Tier 3
- Grid Status: All / Sufficient / Moderate / Congested
- Priority: All / High / Medium / Low

KPI STRIP:
- Total recommended locations
- Total chargers needed
- Peak total MW demand
- Tier breakdown

PRIORITY MATRIX VIEW:
A 3×3 grid: Demand Level vs Grid Capacity
Rows: High / Medium / Low demand
Cols: Sufficient / Moderate / Congested grid
Each cell = count of stations
Tap cell → see all stations in that quadrant

MAP TAB:
Spain map with color-coded markers
🟢 Tier 1 / 🔵 Tier 2 / 🟠 Tier 3
Grey = existing stations
Tap marker → station card

STATION DETAIL VIEW:
- Station ID, route, coordinates
- Tier + rationale
- Grid status + available MW
- Chargers recommended (by scenario)
- Priority score + reasoning
- Daily sessions estimate
- "Add to deployment plan" button

DESIGN:
- Dark theme: background #0D1117, cards #161B22
- Accent: Spanish green #52B788
- Font: Inter or Segoe UI
- Mobile-first: 44px tap targets
- Bottom tab bar: List | Matrix | Map

TECH STACK: React/Next.js (Lovable default)
```

### Step 4: Review & Iterate

Lovable will generate a first version. Review it on your phone:

**Check:**
- [ ] Does it load on mobile?
- [ ] Are filters visible at top?
- [ ] Can you tap a station card?
- [ ] Does the map show markers?
- [ ] Is the KPI strip visible?

**If something is wrong:**
- Type feedback in Lovable chat: "Make the filter buttons bigger" or "The map isn't loading markers"
- Lovable will regenerate

### Step 5: Add Real Data

The app needs the 627 station dataset. In Lovable, you can:
1. Create a `stations.json` file with the data
2. Import it into the app
3. Connect it to the ranking and map logic

**Data format needed:**
```json
{
  "id": "STAT-001",
  "route": "A-1 Madrid-Irún",
  "lat": 40.4168,
  "lng": -3.7038,
  "tier": 1,
  "tier_label": "Iberdrola Upgrade",
  "grid_status": "Sufficient",
  "grid_mw": 2.4,
  "priority": "High",
  "chargers_baseline": 8,
  "chargers_aggressive": 12,
  "peak_mw": 1.2,
  "daily_sessions_p80": 45
}
```

### Step 6: Deploy

When it looks good, Lovable has a **"Publish"** button:
- It generates a shareable URL
- You can add it to your presentation
- Executives can open it on their phones

---

## Files in This Project

| File | Description |
|------|-------------|
| `IBERDROLA-PROJECT.md` | This file — full project documentation |
| `LOVABLE-PROMPT.md` | The exact prompt to paste into Lovable |
| `Iberdrola_-_Case_Strategy.pdf` | Strategy document |
| `IE-Iberdrola_Datathon_Marzo_2026.pdf` | Datathon details |
| `network_dashboard_revised.html` | Reference dashboard (analyst version) |
| `EV-Charging-App/` | (Created by Lovable) |

---

## Key Numbers to Reference

| Metric | Value |
|--------|-------|
| Total proposed locations | 627 |
| Tier 1 (Iberdrola upgrade) | 185 |
| Tier 2 (Partner co-location) | 321 |
| Tier 3 (New partner) | 121 |
| Existing stations | 4,801 |
| Chargers per station (avg) | 4-12 |
| Charger power | 150 kW DC |
| EU mandate | 1 fast charger every 60 km on TEN-T by 2025 |
| Spain EV fleet (now) | ~550,000 |
| Spain EV fleet (2030 target) | 5.5 million |

---

## Team Contact

- **Jordan Hays** — IE IMBA student, responsible for executive dashboard
- **Lovable project link:** (add your Lovable project URL here after creating)

---

_Last updated: 2026-04-17_
