#!/usr/bin/env python3
import json
import random

random.seed(42)

# Route definitions with approximate start/end coordinates
ROUTES = {
    "A-1 Madrid-Irún": {"count": 8, "lat_range": (40.3, 43.4), "lng_range": (-3.8, -1.8), "ten_t": True},
    "A-2 Madrid-Barcelona": {"count": 6, "lat_range": (41.0, 41.7), "lng_range": (-3.5, 2.2), "ten_t": True},
    "A-3 Madrid-Valencia": {"count": 5, "lat_range": (39.5, 40.5), "lng_range": (-3.8, -0.3), "ten_t": True},
    "A-4 Madrid-Seville": {"count": 5, "lat_range": (37.4, 40.4), "lng_range": (-6.0, -3.7), "ten_t": True},
    "A-5 Madrid-Badajoz": {"count": 4, "lat_range": (38.9, 40.2), "lng_range": (-7.0, -3.7), "ten_t": False},
    "A-6 Madrid-A Coruña": {"count": 4, "lat_range": (40.3, 43.4), "lng_range": (-8.5, -3.7), "ten_t": False},
    "AP-7 Mediterranean": {"count": 12, "lat_range": (36.5, 42.0), "lng_range": (-0.5, 3.3), "ten_t": True},
    "AP-2 Aragón": {"count": 5, "lat_range": (41.0, 42.0), "lng_range": (-2.5, 0.5), "ten_t": True},
    "A-7 Coastal": {"count": 10, "lat_range": (36.5, 41.5), "lng_range": (-5.5, 3.0), "ten_t": False},
    "N-II Barcelona-Madrid": {"count": 6, "lat_range": (41.0, 41.7), "lng_range": (-3.8, 2.1), "ten_t": False},
    "A-42 Madrid-Toledo": {"count": 4, "lat_range": (39.8, 40.4), "lng_range": (-4.1, -3.7), "ten_t": False},
    "A-52 Madrid-Galicia": {"count": 4, "lat_range": (40.2, 42.5), "lng_range": (-8.0, -3.7), "ten_t": False},
    "A-66 Madrid-Asturias": {"count": 4, "lat_range": (40.5, 43.3), "lng_range": (-6.2, -3.7), "ten_t": False},
}

# Secondary routes (distributed across Spain)
SECONDARY_ROUTES = [
    "A-8 Cantabrian Coast", "A-15 Radial Norte", "A-23 Zaragoza-Lleida", "A-44 Granada-Motril",
    "A-49 Huelva-Seville", "A-58 Extremadura", "A-62 Valladolid-Burgos", "A-67 Palencia-Santander",
    "A-70 Alicante-Cartagena", "A-72 Luarca-Cangas", "A-91 Granada-Murcia", "A-92 Seville-Málaga",
    "A-232 Fuenteestrecho", "A-2606 Jarama", "BU-30 Burgos Ring", "MA-20 Málaga Ring",
    "SE-30 Seville Ring", "Z-40 Zaragoza Ring", "B-30 Barcelona Ring", "M-40 Madrid Ring",
    "M-50 Madrid Outer", "A-1 Secondary Bilbao", "A-2 Secondary Lleida", "A-7 Coastal East",
]

# Grid distribution: 33 Sufficient, 20 Moderate, 574 Congested
GRID_STATUSES = ["Sufficient"] * 33 + ["Moderate"] * 20 + ["Congested"] * 574
random.shuffle(GRID_STATUSES)

# Tier distribution: 185 Tier 1, 321 Tier 2, 121 Tier 3
TIERS = [1] * 185 + [2] * 321 + [3] * 121
random.shuffle(TIERS)

TIER_LABELS = {1: "Iberdrola Upgrade", 2: "Partner Co-location", 3: "New Partner"}
PARTNER_TYPES_T2 = ["Petrol Station", "Shopping Center", "Rest Area", "Hotel"]
PARTNER_TYPES_T3 = ["Petrol Station", "Shopping Center", "Rest Area", "Hotel"]

# Priority distribution: P1-P10
# High (P1-3): ~30%, Medium (P4-6): ~40%, Low (P7-10): ~30%
PRIORITIES = ["P1"] * 40 + ["P2"] * 45 + ["P3"] * 50 + ["P4"] * 60 + ["P5"] * 70 + ["P6"] * 60 + ["P7"] * 80 + ["P8"] * 70 + ["P9"] * 80 + ["P10"] * 72
random.shuffle(PRIORITIES)

def get_grid_mw(grid_status):
    if grid_status == "Sufficient":
        return round(random.uniform(1.5, 3.0), 2)
    elif grid_status == "Moderate":
        return round(random.uniform(0.8, 1.5), 2)
    else:
        return round(random.uniform(0.2, 0.8), 2)

def get_chargers_baseline(priority):
    p = int(priority[1])
    if p <= 3:
        return random.randint(8, 12)
    elif p <= 6:
        return random.randint(4, 8)
    else:
        return random.randint(2, 4)

def get_daily_p80(priority):
    p = int(priority[1])
    if p <= 3:
        return random.randint(40, 90)
    elif p <= 6:
        return random.randint(20, 40)
    else:
        return random.randint(5, 20)

def generate_coordinate(route_info):
    lat = random.uniform(route_info["lat_range"][0], route_info["lat_range"][1])
    lng = random.uniform(route_info["lng_range"][0], route_info["lng_range"][1])
    return round(lat, 6), round(lng, 6)

# Generate stations
stations = []
station_idx = 0
grid_idx = 0
tier_idx = 0
priority_idx = 0

# Main corridor stations
for route_name, route_info in ROUTES.items():
    for i in range(route_info["count"]):
        lat, lng = generate_coordinate(route_info)
        tier = TIERS[tier_idx % len(TIERS)]
        tier_idx += 1
        grid_status = GRID_STATUSES[grid_idx % len(GRID_STATUSES)]
        grid_idx += 1
        priority = PRIORITIES[priority_idx % len(PRIORITIES)]
        priority_idx += 1
        chargers_baseline = get_chargers_baseline(priority)
        
        station = {
            "id": f"STAT-{str(station_idx+1).zfill(3)}",
            "route": route_name,
            "lat": lat,
            "lng": lng,
            "tier": tier,
            "tier_label": TIER_LABELS[tier],
            "grid_status": grid_status,
            "grid_mw": get_grid_mw(grid_status),
            "priority": priority,
            "chargers_baseline": chargers_baseline,
            "chargers_aggressive": chargers_baseline + 4,
            "peak_mw": round(chargers_baseline * 0.15 * 0.8, 2),
            "daily_p80": get_daily_p80(priority),
            "ten_t": route_info["ten_t"],
            "partner_type": "Iberdrola" if tier == 1 else random.choice(PARTNER_TYPES_T2 if tier == 2 else PARTNER_TYPES_T3)
        }
        stations.append(station)
        station_idx += 1

# Secondary route stations (~550 remaining)
secondary_count = 627 - len(stations)
for i in range(secondary_count):
    route_name = random.choice(SECONDARY_ROUTES)
    # Generate reasonable coordinates for secondary routes
    lat = round(random.uniform(36.5, 43.5), 6)
    lng = round(random.uniform(-9.3, 3.3), 6)
    
    tier = TIERS[tier_idx % len(TIERS)]
    tier_idx += 1
    grid_status = GRID_STATUSES[grid_idx % len(GRID_STATUSES)]
    grid_idx += 1
    priority = PRIORITIES[priority_idx % len(PRIORITIES)]
    priority_idx += 1
    chargers_baseline = get_chargers_baseline(priority)
    
    ten_t_routes = ["A-1", "A-2", "A-3", "A-4", "AP-7", "AP-2"]
    ten_t = any(rt in route_name for rt in ten_t_routes)
    
    station = {
        "id": f"STAT-{str(station_idx+1).zfill(3)}",
        "route": route_name,
        "lat": lat,
        "lng": lng,
        "tier": tier,
        "tier_label": TIER_LABELS[tier],
        "grid_status": grid_status,
        "grid_mw": get_grid_mw(grid_status),
        "priority": priority,
        "chargers_baseline": chargers_baseline,
        "chargers_aggressive": chargers_baseline + 4,
        "peak_mw": round(chargers_baseline * 0.15 * 0.8, 2),
        "daily_p80": get_daily_p80(priority),
        "ten_t": ten_t,
        "partner_type": "Iberdrola" if tier == 1 else random.choice(PARTNER_TYPES_T2 if tier == 2 else PARTNER_TYPES_T3)
    }
    stations.append(station)
    station_idx += 1

# Write to file
with open("/home/openclaw/.openclaw/workspace/IBERDROLA/stations.json", "w") as f:
    json.dump(stations, f, indent=2)

# Print summary
print(f"Generated {len(stations)} stations")
print(f"\nTier distribution:")
tier_counts = {1: 0, 2: 0, 3: 0}
for s in stations:
    tier_counts[s["tier"]] += 1
for t, c in tier_counts.items():
    print(f"  Tier {t}: {c}")

print(f"\nGrid status distribution:")
grid_counts = {"Sufficient": 0, "Moderate": 0, "Congested": 0}
for s in stations:
    grid_counts[s["grid_status"]] += 1
for g, c in grid_counts.items():
    print(f"  {g}: {c}")

print(f"\nPriority distribution:")
priority_counts = {}
for s in stations:
    priority_counts[s["priority"]] = priority_counts.get(s["priority"], 0) + 1
for p in sorted(priority_counts.keys()):
    print(f"  {p}: {priority_counts[p]}")

print(f"\nTEN-T core: {sum(1 for s in stations if s['ten_t'])}")
print(f"\nSample stations (first 5):")
for s in stations[:5]:
    print(f"  {s['id']}: {s['route']} ({s['lat']}, {s['lng']})")
