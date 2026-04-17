# Lovable Prompt — Copy This

Build a mobile-first executive dashboard app for Iberdrola's EV charging network expansion in Spain.

APP NAME: "Next Best Charger"

ONE-LINE PITCH: Help an Iberdrola executive instantly find and prioritize the next best charging station to deploy.

---

CORE FEATURE — STATION RANKINGS:
Show a ranked list of 627 proposed charging station locations, sorted by "best next deployment." Each station card shows:
- Station ID + Route name
- Tier: [1] Iberdrola Upgrade / [2] Partner Co-location / [3] New Partner
- Grid Status: 🟢 Sufficient / 🟡 Moderate / 🔴 Congested
- Priority Score: HIGH / MEDIUM / LOW (based on Demand × Grid capacity)
- Chargers needed (150 kW DC)
- Peak MW demand
- Estimated daily sessions
- One tap → full station detail

FILTERS (top of screen, always visible on mobile):
- Search by route or station ID
- Scenario: Conservative (60%) / Baseline (80%) / Aggressive (100%)
- Tier: All / Tier 1 / Tier 2 / Tier 3
- Grid Status: All / Sufficient / Moderate / Congested
- Priority: All / High / Medium / Low

KPI STRIP at top:
- Total recommended locations
- Total chargers needed
- Peak total MW demand
- Tier breakdown (Tier 1: X / Tier 2: Y / Tier 3: Z)

PRIORITY MATRIX VIEW (key differentiator):
A 3×3 grid showing Demand Level vs Grid Capacity:
- Rows: High / Medium / Low demand
- Cols: Sufficient / Moderate / Congested grid
- Each cell shows count of stations
- Tap cell → see all stations in that quadrant

MAP TAB:
- Spain map (use Leaflet or similar)
- Color-coded markers: 🟢 Tier 1 / 🔵 Tier 2 / 🟠 Tier 3
- Grey markers = existing stations
- Tap marker → station card popup

STATION DETAIL VIEW (on tap):
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
- Mobile-first: 44px tap targets, thumb-friendly nav
- Bottom tab bar: List | Matrix | Map

TECH STACK: React/Next.js (Lovable default)

DESIGN INSPIRATION: Clean data density, dark theme, executive clarity. Like a Bloomberg terminal for charging stations.
