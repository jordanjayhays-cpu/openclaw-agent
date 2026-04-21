"""
April 15 — Datathon-Compliant Deliverables + Enhanced Analysis
================================================================
Produces EXACTLY what the datathon requires:
  File_1.csv — Global KPIs (1 summary row)
  File_2.csv — Proposed charging locations (6 columns, grid_status ∈ {Sufficient, Moderate, Congested})
  File_3.csv — Friction points (Moderate + Congested only, with distributor_network)

ALSO produces enhanced analysis:
  recommendations_3tier.csv — Strategic deployment tiers
  priority_matrix.csv — Demand × Grid priority matrix

Sources of truth:
  - Road geometry: complete_road_network_final.json (99 roads, OSRM-routed)
  - Grid: Endesa (1838 substations) + Viesgo (3619 pts) + Begasa + e-Redes
  - i-DE: NOT available in our data — locations in i-DE territory assigned based on
    inverse-distance-weighted nearest Endesa/Viesgo node, documented as assumption
  - EV fleet: datos.gob.es fork → 1,543,080 (baseline 2027)
  - Existing stations: OSM ev_charging (4801)
  - Charger standard: 150 kW per charger (fixed per datathon rules)

Electric Dragon | IE-Iberdrola Datathon 2026
"""
import os, sys, json, time, warnings, csv, re, math
import numpy as np
import pandas as pd
from math import radians, sin, cos, sqrt, atan2
warnings.filterwarnings('ignore')
sys.stdout.reconfigure(line_buffering=True)

BASE = r'C:\Users\mandy\Desktop\Hackathon'
REV = os.path.join(BASE, 'April 13 Revised Outputs')
OUT = os.path.join(BASE, 'April 20 Revisions')
os.makedirs(OUT, exist_ok=True)

print("=" * 72)
print("  APRIL 15 — DATATHON-COMPLIANT DELIVERABLES")
print("=" * 72)

# ================================================================
# UTILITIES
# ================================================================
def haversine_km(lat1, lon1, lat2, lon2):
    R = 6371.0
    dlat = radians(lat2 - lat1); dlon = radians(lon2 - lon1)
    a = sin(dlat/2)**2 + cos(radians(lat1))*cos(radians(lat2))*sin(dlon/2)**2
    return R * 2 * atan2(sqrt(a), sqrt(1 - a))

def interpolate_along_route(waypoints, interval_km=50):
    points = []
    accumulated = 0.0
    for i in range(len(waypoints) - 1):
        lat1, lon1 = waypoints[i]
        lat2, lon2 = waypoints[i + 1]
        seg_dist = haversine_km(lat1, lon1, lat2, lon2)
        if seg_dist < 0.001: continue
        pos = 0.0
        while pos + (interval_km - accumulated) <= seg_dist:
            pos += (interval_km - accumulated)
            t = pos / seg_dist
            points.append((round(lat1 + t*(lat2-lat1), 6), round(lon1 + t*(lon2-lon1), 6)))
            accumulated = 0.0
        accumulated += (seg_dist - pos)
    return points

def total_route_km(waypoints):
    return sum(haversine_km(waypoints[i][0], waypoints[i][1],
                            waypoints[i+1][0], waypoints[i+1][1])
               for i in range(len(waypoints) - 1))

def snap_to_nearest(lat, lon, candidates, max_km=10):
    best_idx, best_dist = None, max_km + 1
    for i, (clat, clon) in enumerate(candidates):
        d = haversine_km(lat, lon, clat, clon)
        if d < best_dist:
            best_idx, best_dist = i, d
    return (best_idx, best_dist) if best_dist <= max_km else (None, None)

# ================================================================
# 1. LOAD ROAD NETWORK (99 roads, already OSRM-fixed)
# ================================================================
print("\n[1] Loading road network...")
with open(os.path.join(REV, 'complete_road_network_final.json')) as f:
    net = json.load(f)

ALL_ROADS = {}
for name, coords in net['roads'].items():
    ALL_ROADS[name] = [(c[0], c[1]) for c in coords]

print(f"  {len(ALL_ROADS)} roads loaded")

road_geometries = {}
for name, pts in ALL_ROADS.items():
    road_geometries[name] = [[lat, lon] for lat, lon in pts]

# ================================================================
# 2. LOAD ALL GRID CAPACITY DATA (Endesa + Viesgo + Begasa + e-Redes)
# ================================================================
print("\n[2] Loading grid capacity from ALL distributors...")

grid_points = []  # [{lat, lon, capacity_mw, distributor}]

# --- ENDESA ---
endesa = pd.read_csv(os.path.join(BASE, 'grid_capacity/endesa_demanda_202603.csv'), sep=';', encoding='latin-1')
endesa['utm_x'] = endesa['Coordenada UTM X'].astype(str).str.replace(',','.').astype(float)
endesa['utm_y'] = endesa['Coordenada UTM Y'].astype(str).str.replace(',','.').astype(float)
endesa['cap_mw'] = pd.to_numeric(endesa['Capacidad firme disponible (MW)'].astype(str).str.replace(',','.'), errors='coerce').fillna(0)

def utm_to_latlon(x, y, zone=30):
    e2 = 0.00669437999014; a = 6378137.0; e_prime2 = e2/(1-e2)
    k0, FN, FE = 0.9996, 0, 500000
    M = (y-FN)/k0
    mu = M/(a*(1-e2/4-3*e2**2/64-5*e2**3/256))
    e1 = (1-(1-e2)**0.5)/(1+(1-e2)**0.5)
    phi = mu + (3*e1/2-27*e1**3/32)*np.sin(2*mu) + (21*e1**2/16-55*e1**4/32)*np.sin(4*mu) + 151*e1**3/96*np.sin(6*mu)
    N = a/(1-e2*np.sin(phi)**2)**0.5
    T = np.tan(phi)**2; C = e_prime2*np.cos(phi)**2
    D = (x-FE)/(N*k0)
    lat = phi - (N*np.tan(phi)/(a*(1-e2)/(1-e2*np.sin(phi)**2)**1.5))*(D**2/2-(5+3*T+10*C-4*C**2-9*e_prime2)*D**4/24)
    lon = np.radians((zone-1)*6-180+3) + (D-(1+2*T+C)*D**3/6+(5-2*C+28*T-3*C**2+8*e_prime2+24*T**2)*D**5/120)/np.cos(phi)
    return np.degrees(lat), np.degrees(lon)

endesa_count = 0
for _, row in endesa.iterrows():
    try:
        lat, lon = utm_to_latlon(row['utm_x'], row['utm_y'])
        grid_points.append({'lat': lat, 'lon': lon, 'capacity_mw': row['cap_mw'], 'distributor': 'Endesa'})
        endesa_count += 1
    except: continue
print(f"  Endesa: {endesa_count} substations")

# --- VIESGO (viesgo_ev_charging_viesgo.csv) ---
viesgo = pd.read_csv(os.path.join(BASE, 'grid_capacity/viesgo_ev_charging_viesgo.csv'), sep=';', encoding='latin-1')
viesgo = viesgo.dropna(subset=['latitud', 'longitud'])
# potencia_max_admisible is in kW → convert to MW
# Group by location (lat/lon) to get max capacity per point
viesgo_grouped = viesgo.groupby(['latitud','longitud']).agg({'potencia_max_admisible':'max','provincia':'first'}).reset_index()
viesgo_count = 0
for _, row in viesgo_grouped.iterrows():
    grid_points.append({
        'lat': row['latitud'], 'lon': row['longitud'],
        'capacity_mw': row['potencia_max_admisible'] / 1000,  # kW to MW
        'distributor': 'Viesgo'
    })
    viesgo_count += 1
print(f"  Viesgo: {viesgo_count} locations")

# --- e-Redes (also Viesgo group) ---
try:
    eredes = pd.read_csv(os.path.join(BASE, 'grid_capacity/viesgo_ev_charging_eredes.csv'), sep=';', encoding='latin-1')
    eredes = eredes.dropna(subset=['latitud', 'longitud'])
    eredes_grouped = eredes.groupby(['latitud','longitud']).agg({'potencia_max_admisible':'max'}).reset_index()
    eredes_count = 0
    for _, row in eredes_grouped.iterrows():
        grid_points.append({
            'lat': row['latitud'], 'lon': row['longitud'],
            'capacity_mw': row['potencia_max_admisible'] / 1000,
            'distributor': 'Viesgo'  # e-Redes is part of Viesgo group
        })
        eredes_count += 1
    print(f"  e-Redes (Viesgo): {eredes_count} locations")
except Exception as e:
    print(f"  e-Redes: skipped ({e})")

# --- BEGASA ---
try:
    begasa = pd.read_csv(os.path.join(BASE, 'grid_capacity/begasa_ev_charging.csv'), sep=';', encoding='latin-1')
    begasa = begasa.dropna(subset=['latitud', 'longitud'])
    begasa_grouped = begasa.groupby(['latitud','longitud']).agg({'potencia_max_admisible':'max'}).reset_index()
    begasa_count = 0
    for _, row in begasa_grouped.iterrows():
        grid_points.append({
            'lat': row['latitud'], 'lon': row['longitud'],
            'capacity_mw': row['potencia_max_admisible'] / 1000,
            'distributor': 'Endesa'  # Begasa is part of Endesa group
        })
        begasa_count += 1
    print(f"  Begasa (Endesa): {begasa_count} locations")
except Exception as e:
    print(f"  Begasa: skipped ({e})")

print(f"  TOTAL grid points: {len(grid_points)}")

# --- i-DE (Iberdrola distribution) ---
def utm30n_to_latlon(easting, northing):
    """Convert UTM Zone 30N (EPSG:25830) to WGS84 lat/lon."""
    k0 = 0.9996
    a = 6378137.0
    e2 = 0.00669437999014
    e_prime2 = e2 / (1 - e2)
    false_easting = 500000.0
    zone_cm = -3.0  # central meridian zone 30N

    x = easting - false_easting
    y = northing

    M = y / k0
    mu = M / (a * (1 - e2/4 - 3*e2**2/64 - 5*e2**3/256))

    e1 = (1 - math.sqrt(1 - e2)) / (1 + math.sqrt(1 - e2))
    phi1 = (mu + (3*e1/2 - 27*e1**3/32)*math.sin(2*mu)
               + (21*e1**2/16 - 55*e1**4/32)*math.sin(4*mu)
               + (151*e1**3/96)*math.sin(6*mu)
               + (1097*e1**4/512)*math.sin(8*mu))

    N1 = a / math.sqrt(1 - e2*math.sin(phi1)**2)
    T1 = math.tan(phi1)**2
    C1 = e_prime2 * math.cos(phi1)**2
    R1 = a*(1-e2) / (1 - e2*math.sin(phi1)**2)**1.5
    D = x / (N1 * k0)

    lat = phi1 - (N1*math.tan(phi1)/R1)*(
        D**2/2
        - (5 + 3*T1 + 10*C1 - 4*C1**2 - 9*e_prime2)*D**4/24
        + (61 + 90*T1 + 298*C1 + 45*T1**2 - 252*e_prime2 - 3*C1**2)*D**6/720
    )
    lon = (
        D
        - (1 + 2*T1 + C1)*D**3/6
        + (5 - 2*C1 + 28*T1 - 3*C1**2 + 8*e_prime2 + 24*T1**2)*D**5/120
    ) / math.cos(phi1)

    lat_deg = math.degrees(lat)
    lon_deg = math.degrees(lon) + zone_cm
    return round(lat_deg, 5), round(lon_deg, 5)

try:
    ide_path = os.path.join(BASE, 'grid_capacity/2026_03_05_R1-001_Demanda.xlsx')
    ide_df = pd.read_excel(ide_path, engine='openpyxl')
    ide_df['utm_x'] = ide_df['Coordenada UTM X'].astype(str).str.replace(',', '.').astype(float)
    ide_df['utm_y'] = ide_df['Coordenada UTM Y'].astype(str).str.replace(',', '.').astype(float)
    ide_df['cap_mw'] = pd.to_numeric(
        ide_df['Capacidad firme disponible (MW)'].astype(str).str.replace(',', '.'),
        errors='coerce'
    ).fillna(0)
    # Only keep rows with positive capacity
    ide_df = ide_df[ide_df['cap_mw'] > 0]
    ide_count = 0
    for _, row in ide_df.iterrows():
        try:
            lat, lon = utm30n_to_latlon(row['utm_x'], row['utm_y'])
            grid_points.append({'lat': lat, 'lon': lon, 'capacity_mw': row['cap_mw'], 'distributor': 'i-DE'})
            ide_count += 1
        except Exception:
            continue
    print(f"  i-DE: {ide_count} substations (from XLSX)")
except Exception as e:
    print(f"  i-DE: skipped ({e})")

# --- NATURGY (R1-002: Galicia + Central Spain + Madrid) ---
try:
    import zipfile as _zf, io as _io
    _nat_zip = os.path.join(OUT, 'other_grid_capacity.zip')
    with _zf.ZipFile(_nat_zip, 'r') as _z:
        with _z.open('Naturgy/2026_04_01_R1-002_demanda.xlsx') as _f:
            nat_df = pd.read_excel(_io.BytesIO(_f.read()), sheet_name='2026_04_01_R1-002_demanda')
    nat_df['utm_x'] = pd.to_numeric(nat_df['Coordenada UTM X [1]'], errors='coerce')
    nat_df['utm_y'] = pd.to_numeric(nat_df['Coordenada UTM Y [1]'], errors='coerce')
    nat_df['cap_mw'] = pd.to_numeric(nat_df['Capacidad firme disponible (MW) [2]'], errors='coerce').fillna(0)
    nat_df = nat_df.dropna(subset=['utm_x', 'utm_y'])
    nat_df = nat_df[nat_df['cap_mw'] > 0]   # keep only substations with measured capacity (mirrors i-DE treatment)
    # Naturgy uses UTM Zone 30N (same as i-DE) for all provinces including Galicia
    nat_count = 0
    for _, row in nat_df.iterrows():
        try:
            lat, lon = utm30n_to_latlon(row['utm_x'], row['utm_y'])
            if 35.5 < lat < 44.5 and -10 < lon < 5:   # Spain bounds check
                grid_points.append({'lat': lat, 'lon': lon, 'capacity_mw': row['cap_mw'], 'distributor': 'Naturgy'})
                nat_count += 1
        except Exception:
            continue
    print(f"  Naturgy (R1-002): {nat_count} substations added")
except Exception as e:
    print(f"  Naturgy: skipped ({e})")

print(f"  TOTAL grid points (all distributors): {len(grid_points)}")

# ================================================================
# 3. PLACE STATIONS AT 50km INTERVALS
# ================================================================
print("\n[3] Placing stations at 50km intervals...")

INTERVAL_KM = 50
candidate_points = []
station_id = 1

for name in sorted(ALL_ROADS.keys()):
    wps = ALL_ROADS[name]
    km = total_route_km(wps)
    if km < 40:
        continue
    points = interpolate_along_route(wps, INTERVAL_KM)
    if not points:
        mid = len(wps) // 2
        points = [wps[mid]]
    for lat, lon in points:
        candidate_points.append({
            'latitude': lat, 'longitude': lon,
            'route': name,
            'route_km': round(km, 1),
        })
        station_id += 1

print(f"  {len(candidate_points)} candidate points on {len(set(c['route'] for c in candidate_points))} roads")

# Snap to road geometry
for cp in candidate_points:
    geom = road_geometries.get(cp['route'], [])
    if not geom:
        cp['snapped_lat'] = cp['latitude']
        cp['snapped_lon'] = cp['longitude']
        continue
    best_d = float('inf')
    best_lat, best_lon = cp['latitude'], cp['longitude']
    step = max(1, len(geom) // 2000)
    for glat, glon in geom[::step]:
        d = haversine_km(cp['latitude'], cp['longitude'], glat, glon)
        if d < best_d:
            best_d = d
            best_lat, best_lon = glat, glon
    cp['snapped_lat'] = round(best_lat, 6)
    cp['snapped_lon'] = round(best_lon, 6)

# ================================================================
# 4. ASSIGN GRID STATUS + DISTRIBUTOR
# ================================================================
print("\n[4] Assigning grid status and distributor...")

# Grid thresholds (documented in Analytical Report):
# Based on charger power requirements (150 kW per charger):
#   Sufficient: ≥ 1.8 MW (can support 12+ chargers = full hub)
#   Moderate: 0.6–1.8 MW (supports 4–11 chargers, limited expansion)
#   Congested: < 0.6 MW (below minimum viable 4-charger station)
THRESH_SUFFICIENT = 1.8  # MW
THRESH_MODERATE = 0.6    # MW

grid_locs = [(g['lat'], g['lon']) for g in grid_points]
grid_caps = [g['capacity_mw'] for g in grid_points]
grid_dist = [g['distributor'] for g in grid_points]

# Expand search radius to 100km to minimize "Unknown"
# (datathon only allows Sufficient/Moderate/Congested)
for cp in candidate_points:
    lat, lon = cp['snapped_lat'], cp['snapped_lon']
    idx, dist = snap_to_nearest(lat, lon, grid_locs, max_km=100)
    if idx is not None:
        cap = grid_caps[idx]
        cp['nearest_grid_mw'] = round(cap, 3)
        cp['grid_dist_km'] = round(dist, 1)
        cp['distributor_network'] = grid_dist[idx]
        if cap >= THRESH_SUFFICIENT:
            cp['grid_status'] = 'Sufficient'
        elif cap >= THRESH_MODERATE:
            cp['grid_status'] = 'Moderate'
        else:
            cp['grid_status'] = 'Congested'
    else:
        # Fallback: assign Congested (conservative assumption for missing data)
        # This is documented as an assumption — no grid data within 100km
        cp['nearest_grid_mw'] = 0.0
        cp['grid_dist_km'] = None
        cp['grid_status'] = 'Congested'
        cp['distributor_network'] = 'i-DE'  # most likely i-DE territory (gap in our data)

for st in ['Sufficient', 'Moderate', 'Congested']:
    c = sum(1 for cp in candidate_points if cp['grid_status'] == st)
    print(f"  {st}: {c}")

# Add data_quality field
for cp in candidate_points:
    cp['data_quality'] = 'measured' if cp.get('nearest_grid_mw', 0) > 0 else 'unknown'

# Distributor distribution
for d in ['Endesa', 'Viesgo', 'i-DE', 'Naturgy']:
    c = sum(1 for cp in candidate_points if cp.get('distributor_network') == d)
    if c: print(f"  {d}: {c}")

# ================================================================
# 3b. SPATIAL DEDUPLICATION — remove true co-located duplicates only
# ================================================================
# WHY: The 50-km interpolation runs independently per road. Where two named
# routes share an identical waypoint (e.g. A-7 and N-340 overlap at a junction),
# the interpolation can land two candidates at literally the same lat/lon.
# Proposing two stations at the same physical point is a data artefact, not a
# real network need.
#
# WHAT WE REMOVE: candidates whose snapped location is within DEDUP_RADIUS_KM
# of an already-selected candidate on a different route.  1 km is chosen to
# catch exact and near-exact co-location while preserving all genuinely
# separate stations — including parallel corridors like A-2 / N-2 (which run
# close but serve distinct traffic: one is the toll autopista, the other the
# free national road through towns).
#
# PRIORITY when two candidates collide (< 1 km):
#   TEN-T routes > A- highways > AP- toll roads > N- national roads
# The higher-priority route keeps the slot; the colliding candidate is dropped.
# This means TEN-T coverage is never sacrificed to a parallel N- road.
DEDUP_RADIUS_KM = 1.0

print(f"\n[3b] Removing co-located duplicates (< {DEDUP_RADIUS_KM} km, same physical point)...")

_TENT = {'AP-7','A-7','A-2','A-4','A-6','A-8','AP-1','AP-68','A-3','A-62','AP-71'}

def _route_prio(r):
    if r in _TENT:                                      return 0  # TEN-T corridors
    if r.startswith('A-') and not r.startswith('AP-'): return 1  # A- highways
    if r.startswith('AP-'):                             return 2  # AP- toll roads
    return 3                                                       # N- national roads

_before = len(candidate_points)
_sorted = sorted(candidate_points, key=lambda cp: (_route_prio(cp['route']), cp['route']))
_selected, _sel_locs = [], []
for cp in _sorted:
    lat, lon = cp['snapped_lat'], cp['snapped_lon']
    if all(haversine_km(lat, lon, d[0], d[1]) >= DEDUP_RADIUS_KM for d in _sel_locs):
        _selected.append(cp)
        _sel_locs.append((lat, lon))
candidate_points = _selected
_removed = _before - len(candidate_points)
print(f"  {_before} -> {len(candidate_points)} stations ({_removed} true duplicates removed)")

# ================================================================
# 5. COMPUTE CHARGER ALLOCATION (P80 demand, grid-capped)
# ================================================================
print("\n[5] Computing charger allocation...")

# MITMA traffic proxy
mitma_path = os.path.join(BASE, 'mitma_data/estudios_rutas/geometria/Geometria_tramos_2023_2024/rt_tramo_val.csv')
mitma_df = pd.read_csv(mitma_path, usecols=['nombre'], dtype=str, low_memory=False)
def get_road_id(nombre):
    if pd.isna(nombre): return None
    m = re.match(r'((?:A|AP|N|C)-\d+)', nombre.strip())
    return m.group(1) if m else None
mitma_df['road'] = mitma_df['nombre'].apply(get_road_id)
mitma_counts = mitma_df.dropna(subset=['road']).groupby('road').size().to_dict()

VEHICLES_PER_SEGMENT = 2234
all_route_traffic = {rn: mitma_counts.get(rn, 100) * VEHICLES_PER_SEGMENT for rn in ALL_ROADS}
total_traffic = sum(all_route_traffic.values())

# Load DOW patterns and normalize to multiplier factors (around 1.0)
dow_path = os.path.join(BASE, 'output/network_dashboard/route_day_of_week.json')
with open(dow_path) as f:
    route_dow_raw = json.load(f)

# The DOW file contains absolute traffic volumes per day — normalize to factors
route_dow = {}
for rn, dow_data in route_dow_raw.items():
    if isinstance(dow_data, dict) and len(dow_data) > 0:
        vals = list(dow_data.values())
        avg_val = sum(vals) / len(vals)
        if avg_val > 10:  # absolute values, not factors — normalize
            route_dow[rn] = {d: v / avg_val for d, v in dow_data.items()}
        else:
            route_dow[rn] = dow_data
    else:
        route_dow[rn] = dow_data

BASELINE_FLEET = 1_543_080  # datos.gob.es fork output
CURRENT_FLEET = 543_337
CHARGE_PROB = 0.40
DAYS = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
CHARGER_KW = 150
ENERGY_PER_STOP = 210 * 0.1775  # 37.3 kWh
CHARGE_TIME_H = ENERGY_PER_STOP / CHARGER_KW
CHARGER_FLOOR = 2                    # minimum viable: 1 operational + 1 backup
CHARGER_CEILING = 100                # effectively uncapped — demand drives count
UTIL_HOURS = 20                      # 04:00–00:00 operational window
EFFICIENCY = 0.70                    # updated from 0.60: mature network benchmark
PEAK_HOUR_FACTOR = 0.106             # 18:00-19:00 peak = 2.5x avg / 23.59 sum of 24h factors
UTIL_TARGET_PEAK = 0.90
FORECAST_YEAR = 2027

# Financial model parameters (from Iberdrola_Single_Station_Viability_Model_1.xlsx)
TARIFF_EUR_KWH       = 0.58          # DC retail price (€/kWh)
ENERGY_COST_EUR_KWH  = 0.18          # wholesale electricity (€/kWh)
OM_EUR_CHARGER_MONTH = 900           # O&M per charger per month
CPMS_EUR_MONTH       = 420           # CPMS platform flat fee per station per month
INSURANCE_EUR_YR     = 4800          # site insurance per station per year
ANCILLARY_EUR_MONTH  = 150           # lighting, CCTV per station per month
GRID_ACCESS_EUR_KW_YR = 35           # REE grid access fee per kW contracted per year
HW_COST_EUR_CHARGER  = 28_000        # charger hardware + installation per unit
CIVIL_EUR_STATION    = 65_000        # civil & groundworks (Tier 3 greenfield only)
CANOPY_EUR_STATION   = 45_000        # canopy, signage, CCTV
GRID_CONN_EUR        = 120_000       # grid connection works (Congested only — upgrade cost)
EU_GRANT_RATE        = 0.30          # CEF-AFIF + MOVES III combined grant coverage
DEBT_SHARE           = 0.50          # % of net capex funded by debt
DEBT_RATE            = 0.045         # blended borrowing cost
LOAN_TENOR           = 10            # years
TAX_RATE             = 0.25
WACC                 = 0.07
DEPR_HW_YRS          = 10
DEPR_CIVIL_YRS       = 25

SESSIONS_PER_CHARGER_HOUR = 1.0 / CHARGE_TIME_H
SESSIONS_PER_CHARGER = UTIL_HOURS / CHARGE_TIME_H * EFFICIENCY

# ── FINANCIAL UTILIZATION RATE (separate from demand-based charger sizing) ──
# Charger sizing (above) uses fleet-route demand to determine HOW MANY chargers
# to install per location. Financial projections use a SEPARATE conservative
# utilization rate so revenue does not inherit the demand model's high P80
# session count — which is designed for sizing headroom, not revenue forecasting.
#
# FIN_UTIL_RATE = 0.12 means financial projections assume 12% of theoretical
# charger throughput capacity is realized as paid sessions.
# Theoretical = SESSIONS_PER_CHARGER ≈ 56 sessions/charger/day (at 100%)
# @ 12% → ~6.7 sessions/charger/day
# Industry benchmark (Year 1, new highway DCFC station, Europe): 5–12 sessions/charger/day
# Sources: McKinsey EV Charging 2024, BloombergNEF EMEA DCFC report 2024
FIN_UTIL_RATE = 0.12

# Monthly seasonal traffic multipliers for Spanish highway corridors
# Based on DGT traffic intensity data — summer peak (Jul/Aug), winter trough (Jan/Feb)
MONTHLY_FACTORS = {
    1: 0.75, 2: 0.80, 3: 0.90, 4: 1.00, 5: 1.05, 6: 1.10,
    7: 1.30, 8: 1.35, 9: 1.05, 10: 0.95, 11: 0.80, 12: 0.85
}

def daily_sessions(fleet, route):
    """Returns list of 7 daily session counts (Mon-Sun) for this route."""
    share = all_route_traffic.get(route, 0) / total_traffic
    base = fleet * share / 7 * CHARGE_PROB
    dow = route_dow.get(route, {'Mon':0.95,'Tue':0.92,'Wed':0.93,'Thu':0.97,'Fri':1.13,'Sat':1.06,'Sun':1.04})
    if isinstance(dow, dict):
        return [round(base * dow.get(d, 1.0)) for d in DAYS]
    return [round(base)] * 7

def daily_sessions_stats(fleet, route):
    """
    Returns (p80, avg) across 84 data points (12 months × 7 DOW).
    Captures seasonal variation (summer highway peak) + DOW patterns.
    Previous version: P80 across 7 DOW values only — missed seasonal variance.
    """
    share = all_route_traffic.get(route, 0) / total_traffic
    base = fleet * share / 7 * CHARGE_PROB
    dow = route_dow.get(route, {'Mon':0.95,'Tue':0.92,'Wed':0.93,'Thu':0.97,'Fri':1.13,'Sat':1.06,'Sun':1.04})

    all_values = []
    for month, m_factor in MONTHLY_FACTORS.items():
        if isinstance(dow, dict):
            for d in DAYS:
                all_values.append(base * dow.get(d, 1.0) * m_factor)
        else:
            for _ in DAYS:
                all_values.append(base * m_factor)

    p80 = round(np.percentile(all_values, 80))
    avg = round(sum(all_values) / len(all_values))
    return p80, avg

# Per-road demand and charger allocation
roads_with_stations = set(cp['route'] for cp in candidate_points)
demand_by_road = {}

for route in roads_with_stations:
    p80, avg = daily_sessions_stats(BASELINE_FLEET, route)
    n_locs = sum(1 for cp in candidate_points if cp['route'] == route)

    p80_per_loc  = p80 / max(1, n_locs)
    avg_per_loc  = avg / max(1, n_locs)

    # Method 1: P80-day approach — size so chargers handle the P80 day's total volume
    chargers_p80 = max(CHARGER_FLOOR, int(np.ceil(p80_per_loc / SESSIONS_PER_CHARGER)))
    chargers_p80 = min(chargers_p80, CHARGER_CEILING)

    # Method 2: Peak-hour 90% utilization approach
    # Peak hour demand = 10.6% of P80 day sessions
    # Chargers needed so that peak hour hits exactly 90% utilization
    peak_hour_demand = p80_per_loc * PEAK_HOUR_FACTOR
    chargers_peak = max(CHARGER_FLOOR, int(np.ceil(peak_hour_demand / (SESSIONS_PER_CHARGER_HOUR * UTIL_TARGET_PEAK))))
    chargers_peak = min(chargers_peak, CHARGER_CEILING)

    # Final recommendation: take the higher (ensures we meet both daily capacity AND peak-hour target)
    chargers_per_loc = max(chargers_p80, chargers_peak)

    demand_by_road[route] = {
        'p80': p80, 'avg': avg, 'n_locs': n_locs,
        'chargers_per_loc': chargers_per_loc,
        'chargers_demand_p80': chargers_p80,
        'chargers_peak_hr':    chargers_peak,
        'chargers_floor':      CHARGER_FLOOR,
    }

# Per-station demand fields
for cp in candidate_points:
    rd = demand_by_road.get(cp['route'], {})
    n_locs = max(1, rd.get('n_locs', 1))
    cp['daily_sessions_p80'] = round(rd.get('p80', 0) / n_locs)
    cp['daily_sessions_avg'] = round(rd.get('avg', 0) / n_locs)
    cp['chargers_floor']      = CHARGER_FLOOR
    cp['chargers_demand_p80'] = rd.get('chargers_demand_p80', CHARGER_FLOOR)
    cp['chargers_peak_hr']    = rd.get('chargers_peak_hr',    CHARGER_FLOOR)

# Assign chargers per location (capped by grid)
for cp in candidate_points:
    rd = demand_by_road.get(cp['route'], {})
    demand_chargers = rd.get('chargers_per_loc', CHARGER_FLOOR)

    # Grid cap based on available MW
    grid_mw = cp.get('nearest_grid_mw', 0)
    max_from_grid = int(grid_mw * 1000 / CHARGER_KW) if grid_mw > 0 else 0

    if cp['grid_status'] == 'Sufficient':
        cp['n_chargers_proposed'] = demand_chargers
    elif cp['grid_status'] == 'Moderate':
        cp['n_chargers_proposed'] = min(demand_chargers, max(CHARGER_FLOOR, max_from_grid))
    else:  # Congested — propose what demand requires (grid upgrade flagged separately)
        cp['n_chargers_proposed'] = demand_chargers

    cp['estimated_demand_kw'] = cp['n_chargers_proposed'] * CHARGER_KW

    # Daily utilization (sessions vs daily charger capacity)
    cp['utilization_pct'] = round(
        cp['daily_sessions_p80'] / max(1, cp['n_chargers_proposed'] * SESSIONS_PER_CHARGER) * 100, 1
    )

    # Peak-hour utilization at proposed charger count
    peak_sessions = cp['daily_sessions_p80'] * PEAK_HOUR_FACTOR
    cp['util_peak_hour_pct'] = round(
        peak_sessions / max(1, cp['n_chargers_proposed'] * SESSIONS_PER_CHARGER_HOUR) * 100, 1
    )

    # Scenario variants
    cp['chargers_cons'] = max(CHARGER_FLOOR, int(np.floor(cp['n_chargers_proposed'] * 0.8)))
    cp['chargers_base'] = cp['n_chargers_proposed']
    cp['chargers_aggr'] = min(CHARGER_CEILING, int(np.ceil(cp['n_chargers_proposed'] * 1.2)))

    # Investment cost (legacy field; gross_capex computed after tier assignment)
    cp['cost_eur'] = cp['n_chargers_proposed'] * HW_COST_EUR_CHARGER

total_chargers = sum(cp['n_chargers_proposed'] for cp in candidate_points)
print(f"  Total chargers proposed: {total_chargers}")
print(f"  Avg per location: {total_chargers/len(candidate_points):.1f}")

# ================================================================
# 6. LOAD EXISTING STATIONS + PARTNER SITES (for 3-tier)
# ================================================================
print("\n[6] Loading existing stations for 3-tier classification...")

existing = pd.read_csv(os.path.join(BASE, 'ev_charging/osm_ev_charging_spain.csv'))
existing['is_iberdrola'] = existing['operator'].fillna('').str.contains('berdrola', case=False)
iber = existing[existing['is_iberdrola']]
print(f"  Existing stations: {len(existing)} (Iberdrola: {len(iber)})")

# Build a single array of all sampled road points for fast proximity check
all_road_pts = []
for rname, geom in road_geometries.items():
    step = max(1, len(geom) // 100)
    for glat, glon in geom[::step]:
        all_road_pts.append((glat, glon))
road_arr = np.array(all_road_pts)  # shape (N, 2)
road_lat_r = np.radians(road_arr[:, 0])
road_lon_r = np.radians(road_arr[:, 1])
print(f"  Road sample points for proximity: {len(road_arr)}")

def fast_near_road(lats, lons, max_km):
    """Vectorized check: for each point, is it within max_km of ANY road sample point?"""
    R = 6371.0
    # Approx degree threshold for bbox pre-filter (generous)
    deg_thresh = max_km / 80.0  # ~111 km/deg, use 80 for safety margin
    results = np.zeros(len(lats), dtype=bool)
    for i in range(len(lats)):
        lat_i, lon_i = lats[i], lons[i]
        # Bbox pre-filter
        mask = ((np.abs(road_arr[:, 0] - lat_i) < deg_thresh) &
                (np.abs(road_arr[:, 1] - lon_i) < deg_thresh))
        if not mask.any():
            continue
        # Haversine on filtered subset
        rlat = np.radians(lat_i)
        rlon = np.radians(lon_i)
        dlat = road_lat_r[mask] - rlat
        dlon = road_lon_r[mask] - rlon
        a = np.sin(dlat/2)**2 + np.cos(rlat) * np.cos(road_lat_r[mask]) * np.sin(dlon/2)**2
        dist = R * 2 * np.arctan2(np.sqrt(a), np.sqrt(1 - a))
        if dist.min() <= max_km:
            results[i] = True
    return results

# Find Iberdrola stations near roads (within 10km)
iber_lats = iber['lat'].values
iber_lons = iber['lon'].values
iber_mask = fast_near_road(iber_lats, iber_lons, 10.0)
iber_near = []
for idx in np.where(iber_mask)[0]:
    iber_near.append({'lat': float(iber_lats[idx]), 'lon': float(iber_lons[idx]),
                      'name': iber.iloc[idx].get('name','')})
print(f"  Iberdrola near network: {len(iber_near)}")

# Load partner sites — vectorized proximity check (within 5km)
partner_csv = os.path.join(BASE, 'output/network_dashboard/osm_fuel_rest_areas.csv')
partners = pd.read_csv(partner_csv)
p_lats = partners['lat'].values
p_lons = partners['lon'].values
partner_mask = fast_near_road(p_lats, p_lons, 5.0)
near_partners = []
for idx in np.where(partner_mask)[0]:
    near_partners.append({'lat': float(p_lats[idx]), 'lon': float(p_lons[idx]),
                          'name': partners.iloc[idx].get('name',''),
                          'type': partners.iloc[idx].get('type','fuel')})
print(f"  Partners near roads: {len(near_partners)}")

# ================================================================
# 7. CLASSIFY 3 TIERS
# ================================================================
print("\n[7] Classifying 3-tier recommendations...")

iber_coords = [(s['lat'], s['lon']) for s in iber_near]
partner_coords = [(p['lat'], p['lon']) for p in near_partners]

for cp in candidate_points:
    lat, lon = cp['snapped_lat'], cp['snapped_lon']

    # Tier 1: existing Iberdrola within 10km
    iidx, idist = snap_to_nearest(lat, lon, iber_coords, max_km=10)
    if iidx is not None:
        cp['tier'] = 1
        cp['tier_label'] = 'Upgrade Iberdrola'
        cp['target_name'] = iber_near[iidx].get('name', 'Iberdrola Station')
        continue

    # Tier 2: partner within 5km
    pidx, pdist = snap_to_nearest(lat, lon, partner_coords, max_km=5)
    if pidx is not None:
        cp['tier'] = 2
        cp['tier_label'] = 'Partner Co-location'
        cp['target_name'] = near_partners[pidx].get('name', 'Partner Site')
        continue

    # Tier 3: new
    cp['tier'] = 3
    cp['tier_label'] = 'New Partner'
    cp['target_name'] = 'New site needed'

for t in [1, 2, 3]:
    c = sum(1 for cp in candidate_points if cp['tier'] == t)
    labels = {1:'Upgrade Iberdrola', 2:'Partner Co-location', 3:'New Partner'}
    print(f"  Tier {t} ({labels[t]}): {c}")

# ================================================================
# 7c. PARTNER PROXIMITY FILTER
# ================================================================
print("\n[7c] Filtering stations with no partner within 10km...")

# Vectorized partner proximity check at 10km radius
partner_arr = np.array([[p['lat'], p['lon']] for p in near_partners]) if near_partners else np.zeros((0,2))

def has_partner_within_10km(lat, lon):
    if len(partner_arr) == 0:
        return False
    deg_thresh = 10 / 80.0
    mask = ((np.abs(partner_arr[:, 0] - lat) < deg_thresh) &
            (np.abs(partner_arr[:, 1] - lon) < deg_thresh))
    if not mask.any():
        return False
    R = 6371.0
    rlat, rlon = np.radians(lat), np.radians(lon)
    dlat = np.radians(partner_arr[mask, 0]) - rlat
    dlon = np.radians(partner_arr[mask, 1]) - rlon
    a = np.sin(dlat/2)**2 + np.cos(rlat)*np.cos(np.radians(partner_arr[mask, 0]))*np.sin(dlon/2)**2
    dist = R * 2 * np.arctan2(np.sqrt(a), np.sqrt(1-a))
    return bool(dist.min() <= 10.0)

for cp in candidate_points:
    cp['has_partner_10km'] = has_partner_within_10km(cp['snapped_lat'], cp['snapped_lon'])

# Split: viable (has partner) vs no-partner (remote)
viable_points   = [cp for cp in candidate_points if cp['has_partner_10km']]
no_partner_pts  = [cp for cp in candidate_points if not cp['has_partner_10km']]

print(f"  Viable (partner within 10km): {len(viable_points)}")
print(f"  Removed (no partner within 10km): {len(no_partner_pts)}")
print(f"  Note: removed stations shown as separate layer in dashboard")

# ── FINANCIAL MODEL (per viable station, annual, from P&L tab) ──────────────
# NOTE: sessions_yr uses FIN_UTIL_RATE, NOT the demand model's daily_sessions_p80.
# daily_sessions_p80 is a P80 design-day estimate used for charger sizing headroom.
# Using it × 365 would imply every day is a high-demand day — significantly
# overstating annual revenue. Financial projections use a conservative utilization
# rate (FIN_UTIL_RATE = 12%) applied to theoretical charger throughput capacity.
for cp in viable_points:
    n = cp['n_chargers_proposed']
    sessions_yr = n * SESSIONS_PER_CHARGER * FIN_UTIL_RATE * 365

    # Revenue
    revenue_yr = sessions_yr * ENERGY_PER_STOP * TARIFF_EUR_KWH

    # Operating costs
    energy_cost_yr   = sessions_yr * ENERGY_PER_STOP * ENERGY_COST_EUR_KWH
    grid_access_yr   = n * CHARGER_KW * GRID_ACCESS_EUR_KW_YR
    om_yr            = n * OM_EUR_CHARGER_MONTH * 12
    cpms_yr          = CPMS_EUR_MONTH * 12
    insurance_yr     = INSURANCE_EUR_YR
    ancillary_yr     = ANCILLARY_EUR_MONTH * 12
    total_opex_yr    = energy_cost_yr + grid_access_yr + om_yr + cpms_yr + insurance_yr + ancillary_yr

    ebitda_yr        = revenue_yr - total_opex_yr
    ebitda_margin    = round(ebitda_yr / max(1, revenue_yr) * 100, 1)

    # Capex (tiered by site type)
    hw_capex = n * HW_COST_EUR_CHARGER
    civil    = CIVIL_EUR_STATION if cp['tier'] == 3 else 0
    canopy   = CANOPY_EUR_STATION
    grid_upg = GRID_CONN_EUR if cp['grid_status'] == 'Congested' else 0
    gross_capex = hw_capex + civil + canopy + grid_upg
    net_capex   = gross_capex * (1 - EU_GRANT_RATE)

    # D&A
    da_hw    = hw_capex / DEPR_HW_YRS
    da_civil = (civil + canopy + grid_upg) / DEPR_CIVIL_YRS
    da_total = da_hw + da_civil

    # Debt service (Year 1)
    debt = net_capex * DEBT_SHARE
    principal_yr = debt / LOAN_TENOR
    interest_yr1 = debt * DEBT_RATE
    ebit         = ebitda_yr - da_total
    pbt          = ebit - principal_yr - interest_yr1
    tax          = max(0, pbt * TAX_RATE)
    net_profit   = pbt - tax

    # Simple payback & NPV (10yr)
    fcf_yr1      = net_profit + da_total - net_capex * (1 - DEBT_SHARE)
    payback_yrs  = round(net_capex / max(1, ebitda_yr), 1) if ebitda_yr > 0 else 99
    npv_10yr     = round(sum(ebitda_yr / (1+WACC)**yr for yr in range(1, 11)) - net_capex, 0)

    cp['fin_revenue_yr']    = round(revenue_yr)
    cp['fin_opex_yr']       = round(total_opex_yr)
    cp['fin_ebitda_yr']     = round(ebitda_yr)
    cp['fin_ebitda_margin'] = ebitda_margin
    cp['fin_gross_capex']   = round(gross_capex)
    cp['fin_net_capex']     = round(net_capex)
    cp['fin_net_profit_yr'] = round(net_profit)
    cp['fin_payback_yrs']   = payback_yrs
    cp['fin_npv_10yr']      = int(npv_10yr)
    # Update cost_eur to reflect gross capex
    cp['cost_eur']          = round(gross_capex)

total_cost_eur = sum(cp['fin_gross_capex'] for cp in viable_points)
total_chargers = sum(cp['n_chargers_proposed'] for cp in viable_points)
print(f"  Total investment (gross capex): €{total_cost_eur/1e6:.1f}M")

# ================================================================
# 7b. AFIR / TEN-T COMPLIANCE TAGGING
# ================================================================
print("\n[7b] Tagging AFIR / TEN-T compliance...")

# TEN-T Core Network corridors in Spain (AFIR Reg. 2023/1804)
# Required: DC fast charger >=100kW every 60km by 2025; >=400kW every 60km by 2030
TENT_ROUTES = {'AP-7','A-7','A-2','A-4','A-6','A-8','AP-1','AP-68','A-3','A-62','AP-71'}

for cp in viable_points:
    cp['is_tent'] = cp['route'] in TENT_ROUTES
    cp['afir_gap_threshold_km'] = 60 if cp['is_tent'] else 100

# Detect gaps per route (sort stations along route by approximate lat/lon position)
afir_gaps = {}
total_gaps = 0
viable_routes = set(cp['route'] for cp in viable_points)
for route in viable_routes:
    is_tent = route in TENT_ROUTES
    threshold = 60 if is_tent else 100
    stn = sorted(
        [cp for cp in viable_points if cp['route'] == route],
        key=lambda c: c['snapped_lat']
    )
    route_gaps = []
    for i in range(len(stn) - 1):
        a, b = stn[i], stn[i+1]
        d = haversine_km(a['snapped_lat'], a['snapped_lon'], b['snapped_lat'], b['snapped_lon'])
        if d > threshold:
            route_gaps.append({
                'gap_km': round(d, 1),
                'lat': round((a['snapped_lat'] + b['snapped_lat']) / 2, 5),
                'lon': round((a['snapped_lon'] + b['snapped_lon']) / 2, 5),
                'threshold_km': threshold,
                'is_tent': is_tent,
            })
            total_gaps += 1
    if route_gaps:
        afir_gaps[route] = route_gaps
        print(f"  WARN {route}: {len(route_gaps)} gaps > {threshold}km {'[TEN-T]' if is_tent else ''}")

tent_compliant = sum(1 for cp in viable_points if cp['is_tent'])
print(f"  TEN-T stations: {tent_compliant}, total AFIR gaps flagged: {total_gaps}")

# ================================================================
# 8. DEMAND CLASSIFICATION + PRIORITY MATRIX
# ================================================================
print("\n[8] Building priority matrix...")

p80_values = {cp['route']: demand_by_road.get(cp['route'], {}).get('p80', 0) for cp in viable_points}
sorted_p80 = sorted(set(p80_values.values()))
thresh_hi = sorted_p80[int(len(sorted_p80) * 0.67)] if len(sorted_p80) >= 3 else 0
thresh_me = sorted_p80[int(len(sorted_p80) * 0.33)] if len(sorted_p80) >= 3 else 0

for cp in viable_points:
    p80 = p80_values.get(cp['route'], 0)
    cp['demand_level'] = 'High' if p80 >= thresh_hi else ('Medium' if p80 >= thresh_me else 'Low')

PRIORITY_MAP = {
    ('High','Sufficient'): 1, ('High','Moderate'): 2, ('Medium','Sufficient'): 3,
    ('High','Congested'): 4, ('Medium','Moderate'): 5, ('Low','Sufficient'): 6,
    ('Medium','Congested'): 7, ('Low','Moderate'): 8, ('Low','Congested'): 9,
}
ACTION_MAP = {
    ('High','Sufficient'): 'Deploy full hub (12 chargers). Top priority.',
    ('High','Moderate'): 'Deploy 4-11 chargers. Plan grid expansion.',
    ('High','Congested'): 'Grid upgrade prerequisite. Partner with DSO.',
    ('Medium','Sufficient'): 'Deploy standard (8 chargers). Monitor growth.',
    ('Medium','Moderate'): 'Deploy minimum (4 chargers). Grid constrains expansion.',
    ('Medium','Congested'): 'Defer unless strategic. Focus on grid upgrade.',
    ('Low','Sufficient'): 'Deploy minimum (4 chargers). Revisit 2028+.',
    ('Low','Moderate'): 'Only at existing Iberdrola/partner. Monitor.',
    ('Low','Congested'): 'Skip for 2027. Revisit next cycle.',
}

for cp in viable_points:
    key = (cp['demand_level'], cp['grid_status'])
    cp['priority'] = PRIORITY_MAP.get(key, 9)
    cp['priority_action'] = ACTION_MAP.get(key, '')

# Print matrix
print(f"\n  {'':>10} {'Sufficient':>12} {'Moderate':>12} {'Congested':>12}")
for d in ['High', 'Medium', 'Low']:
    row = []
    for g in ['Sufficient', 'Moderate', 'Congested']:
        c = sum(1 for cp in viable_points if cp['demand_level']==d and cp['grid_status']==g)
        row.append(c)
    print(f"  {d:>10} {row[0]:>12} {row[1]:>12} {row[2]:>12}")

# ================================================================
# 9. GENERATE DATATHON-COMPLIANT FILES
# ================================================================
print("\n[9] Generating datathon-compliant deliverables...")

# --- FILE 2: Proposed Charging Locations ---
file2_rows = []
for i, cp in enumerate(viable_points):
    file2_rows.append({
        'location_id': f'IBE_{i+1:03d}',
        'latitude': cp['snapped_lat'],
        'longitude': cp['snapped_lon'],
        'route_segment': cp['route'],
        'n_chargers_proposed': cp['n_chargers_proposed'],
        'grid_status': cp['grid_status'],
        'data_quality': cp.get('data_quality', 'unknown'),
        'daily_sessions_p80': cp.get('daily_sessions_p80', 0),
        'daily_sessions_avg': cp.get('daily_sessions_avg', 0),
        'utilization_pct': cp.get('utilization_pct', 0.0),
        'util_peak_hour_pct': cp.get('util_peak_hour_pct', 0.0),
        'chargers_floor': cp.get('chargers_floor', 4),
        'chargers_demand_p80': cp.get('chargers_demand_p80', 4),
        'chargers_peak_hr': cp.get('chargers_peak_hr', 4),
        'cost_eur': cp.get('cost_eur', 0),
        'fin_revenue_yr':    cp.get('fin_revenue_yr', 0),
        'fin_ebitda_yr':     cp.get('fin_ebitda_yr', 0),
        'fin_ebitda_margin': cp.get('fin_ebitda_margin', 0),
        'fin_net_capex':     cp.get('fin_net_capex', 0),
        'fin_payback_yrs':   cp.get('fin_payback_yrs', 99),
        'fin_npv_10yr':      cp.get('fin_npv_10yr', 0),
        'is_tent': cp.get('is_tent', False),
    })

file2_df = pd.DataFrame(file2_rows)
file2_path = os.path.join(OUT, 'File_2.csv')
file2_df.to_csv(file2_path, index=False)
print(f"  File_2.csv: {len(file2_df)} rows")
print(f"    Grid status: {file2_df['grid_status'].value_counts().to_dict()}")
print(f"    Chargers range: {file2_df['n_chargers_proposed'].min()}-{file2_df['n_chargers_proposed'].max()}")

# --- FILE 3: Friction Points (Moderate + Congested only) ---
file3_rows = []
fric_id = 1
for i, cp in enumerate(viable_points):
    if cp['grid_status'] in ('Moderate', 'Congested'):
        file3_rows.append({
            'bottleneck_id': f'FRIC_{fric_id:03d}',
            'latitude': cp['snapped_lat'],
            'longitude': cp['snapped_lon'],
            'route_segment': cp['route'],
            'distributor_network': cp.get('distributor_network', 'i-DE'),
            'estimated_demand_kw': cp['estimated_demand_kw'],
            'grid_status': cp['grid_status'],
        })
        fric_id += 1

file3_df = pd.DataFrame(file3_rows)
file3_path = os.path.join(OUT, 'File_3.csv')
file3_df.to_csv(file3_path, index=False)
print(f"  File_3.csv: {len(file3_df)} rows (Moderate + Congested only)")

# --- FILE 1: Global KPIs ---
# Count existing interurban stations (filter to A-/AP-/N- roads)
# We use our existing stations count filtered near the network
existing_near = 0
for _, row in existing.iterrows():
    for rname, geom in road_geometries.items():
        step = max(1, len(geom) // 50)
        for glat, glon in geom[::step]:
            if haversine_km(row['lat'], row['lon'], glat, glon) <= 5.0:
                existing_near += 1
                break
        else: continue
        break

file1_data = {
    'total_proposed_stations': len(file2_df),
    'total_existing_stations_baseline': existing_near,
    'total_friction_points': len(file3_df),
    'total_ev_projected_2027': BASELINE_FLEET,
}
file1_df = pd.DataFrame([file1_data])
file1_path = os.path.join(OUT, 'File_1.csv')
file1_df.to_csv(file1_path, index=False)
print(f"  File_1.csv: {file1_data}")

# ================================================================
# 10. GENERATE ENHANCED ANALYSIS FILES
# ================================================================
print("\n[10] Generating enhanced analysis files...")

# 3-tier recommendations
recs = []
for i, cp in enumerate(viable_points):
    recs.append({
        'location_id': f'IBE_{i+1:03d}',
        'latitude': cp['snapped_lat'],
        'longitude': cp['snapped_lon'],
        'route_segment': cp['route'],
        'n_chargers_proposed': cp['n_chargers_proposed'],
        'grid_status': cp['grid_status'],
        'distributor_network': cp.get('distributor_network', 'i-DE'),
        'nearest_grid_mw': cp.get('nearest_grid_mw'),
        'grid_dist_km': cp.get('grid_dist_km'),
        'tier': cp['tier'],
        'tier_label': cp['tier_label'],
        'target_name': cp.get('target_name', ''),
        'demand_level': cp['demand_level'],
        'priority': cp['priority'],
        'priority_action': cp['priority_action'],
        'estimated_demand_kw': cp['estimated_demand_kw'],
        'data_quality': cp.get('data_quality', 'unknown'),
        'daily_sessions_p80': cp.get('daily_sessions_p80', 0),
        'daily_sessions_avg': cp.get('daily_sessions_avg', 0),
        'util_peak_hour_pct': cp.get('util_peak_hour_pct', 0.0),
        'chargers_floor': cp.get('chargers_floor', 4),
        'chargers_demand_p80': cp.get('chargers_demand_p80', 4),
        'chargers_peak_hr': cp.get('chargers_peak_hr', 4),
        'cost_eur': cp.get('cost_eur', 0),
        'is_tent': cp.get('is_tent', False),
        'afir_gap_threshold_km': cp.get('afir_gap_threshold_km', 100),
        'utilization_pct': cp.get('utilization_pct', 0.0),
    })

recs_df = pd.DataFrame(recs)
recs_df.to_csv(os.path.join(OUT, 'recommendations_3tier.csv'), index=False)
print(f"  recommendations_3tier.csv: {len(recs_df)} rows")

# ── Excel export (all proposed stations with financial fields) ──────────────
try:
    import openpyxl
    xl_cols = [
        'location_id','latitude','longitude','route','route_km',
        'grid_status','distributor_network','data_quality','nearest_grid_mw',
        'demand_level','tier','tier_label','target_name',
        'n_chargers_proposed','chargers_floor','chargers_demand_p80','chargers_peak_hr',
        'daily_sessions_p80','daily_sessions_avg','utilization_pct','util_peak_hour_pct',
        'is_tent','afir_gap_threshold_km','priority','priority_action',
        'fin_revenue_yr','fin_total_opex_yr','fin_ebitda_yr','fin_ebitda_margin',
        'fin_gross_capex','fin_net_capex','fin_payback_yrs','fin_npv_10yr',
    ]
    xl_rows = []
    for i, cp in enumerate(viable_points):
        row = {'location_id': f'IBE_{i+1:03d}', 'latitude': cp['snapped_lat'], 'longitude': cp['snapped_lon']}
        for col in xl_cols:
            if col not in row:
                row[col] = cp.get(col, cp.get(col.replace('fin_',''), ''))
        xl_rows.append(row)
    xl_df = pd.DataFrame(xl_rows)[[c for c in xl_cols if c in xl_rows[0]]]
    xl_path = os.path.join(OUT, 'proposed_stations.xlsx')
    xl_df.to_excel(xl_path, index=False, engine='openpyxl')
    print(f"  proposed_stations.xlsx: {len(xl_df)} rows")
except Exception as e:
    print(f"  Excel export skipped: {e}")

# Priority matrix
matrix_rows = []
for d in ['High', 'Medium', 'Low']:
    for g in ['Sufficient', 'Moderate', 'Congested']:
        cells = [cp for cp in viable_points if cp['demand_level']==d and cp['grid_status']==g]
        matrix_rows.append({
            'demand_level': d, 'grid_status': g,
            'priority': PRIORITY_MAP.get((d,g), 9),
            'total_locations': len(cells),
            'tier1_upgrade': sum(1 for c in cells if c['tier']==1),
            'tier2_partner': sum(1 for c in cells if c['tier']==2),
            'tier3_new': sum(1 for c in cells if c['tier']==3),
            'action': ACTION_MAP.get((d,g), ''),
        })
pd.DataFrame(matrix_rows).to_csv(os.path.join(OUT, 'priority_matrix.csv'), index=False)

# ================================================================
# 11. SAVE REVISED_DATA.JSON (for dashboard)
# ================================================================
print("\n[11] Saving revised_data.json for dashboard...")

output_data = {
    'metadata': {
        'generated': '2026-04-20',
        'version': 'v7_fin_fix',
        'team': 'Electric Dragon',
        'total_routes_all': len(ALL_ROADS),
        'total_routes_with_stations': len(roads_with_stations),
        'total_recommendations': len(viable_points),
        'total_chargers': total_chargers,
        'grid_thresholds': {'Sufficient': THRESH_SUFFICIENT, 'Moderate': THRESH_MODERATE, 'Congested': 0.0},
        'grid_thresholds_basis': {
            'principle': 'Each DC fast charger requires 150 kW (fixed per datathon rules)',
            'Sufficient': f'>= {THRESH_SUFFICIENT} MW: supports 12+ chargers (full hub) without grid upgrade',
            'Moderate': f'{THRESH_MODERATE}-{THRESH_SUFFICIENT} MW: supports 4-11 chargers, grid constrains expansion',
            'Congested': f'< {THRESH_MODERATE} MW: below minimum viable 4-charger station, grid upgrade required',
        },
        'charger_kw': CHARGER_KW,
        'charge_probability': CHARGE_PROB,
        'energy_per_stop_kwh': round(ENERGY_PER_STOP, 1),
        'sessions_per_charger_day': round(SESSIONS_PER_CHARGER, 1),
        'SESSIONS_PER_CHARGER': round(SESSIONS_PER_CHARGER, 4),
    },
    'scenarios': {
        'conservative': {'evs_2027': 1_257_933, 'label': 'Conservative (60%)'},
        'baseline':     {'evs_2027': BASELINE_FLEET, 'label': 'Baseline (80%)'},
        'aggressive':   {'evs_2027': 1_828_228, 'label': 'Aggressive (100%)'},
    },
    'current_fleet': CURRENT_FLEET,
    'road_geometries': road_geometries,
    'recommendations': viable_points,
    'no_partner_stations': no_partner_pts,
    'financial_summary': {
        'total_gross_capex':   sum(cp['fin_gross_capex'] for cp in viable_points),
        'total_net_capex':     sum(cp['fin_net_capex'] for cp in viable_points),
        'total_revenue_yr':    sum(cp['fin_revenue_yr'] for cp in viable_points),
        'total_ebitda_yr':     sum(cp['fin_ebitda_yr'] for cp in viable_points),
        'avg_ebitda_margin':   round(sum(cp['fin_ebitda_margin'] for cp in viable_points)/max(1,len(viable_points)),1),
        'stations_npv_positive': sum(1 for cp in viable_points if cp['fin_npv_10yr'] > 0),
    },
    'model_params': {
        'charger_floor': CHARGER_FLOOR,
        'charger_ceiling': CHARGER_CEILING,
        'util_hours': UTIL_HOURS,
        'efficiency': EFFICIENCY,
        'peak_hour_factor': PEAK_HOUR_FACTOR,
        'tariff_eur_kwh': TARIFF_EUR_KWH,
        'energy_cost_eur_kwh': ENERGY_COST_EUR_KWH,
    },
    'demand_by_road': demand_by_road,
    'partner_sites': near_partners,
    'iberdrola_near_roads': iber_near,
    'grid_points': grid_points[:5000],
    'priority_matrix': {d: {g: {
        'count':    sum(1 for cp in viable_points if cp['demand_level']==d and cp['grid_status']==g),
        'sessions': sum(cp['daily_sessions_p80'] for cp in viable_points if cp['demand_level']==d and cp['grid_status']==g),
        'chargers': sum(cp['chargers_base'] for cp in viable_points if cp['demand_level']==d and cp['grid_status']==g),
        'cost_eur': sum(cp['cost_eur'] for cp in viable_points if cp['demand_level']==d and cp['grid_status']==g),
    } for g in ['Sufficient','Moderate','Congested']}
    for d in ['High','Medium','Low']},
    'afir_gaps': afir_gaps,
    'total_cost_eur': total_cost_eur,
    'afir_summary': {
        'tent_stations': sum(1 for cp in viable_points if cp['is_tent']),
        'tent_routes': list(TENT_ROUTES & viable_routes),
        'total_gaps': total_gaps,
    },
    'action_map': {f"{k[0]}_{k[1]}": v for k, v in ACTION_MAP.items()},
    'existing_stations': {
        'total': len(existing),
        'iberdrola': int(len(iber)),
        'other': int(len(existing) - len(iber)),
        'interurban_baseline': existing_near,
    },
    'route_traffic': all_route_traffic,
    'vehicle_types': {
        'M1 Passenger Cars': {'count': 185757, 'ev_split': {'BEV': 88588, 'PHEV': 97169}},
        'N1 Light Commercial (<3.5t)': {'count': 7710, 'ev_split': {'BEV': 7637, 'PHEV': 73}},
        'M2 Bus/Minibus': {'count': 16905, 'ev_split': {'BEV': 16905, 'PHEV': 0}},
        'N2 Medium Commercial (3.5-12t)': {'count': 667, 'ev_split': {'BEV': 643, 'PHEV': 24}},
    },
}

data_path = os.path.join(OUT, 'revised_data.json')
with open(data_path, 'w', encoding='utf-8') as f:
    json.dump(output_data, f, default=str)
print(f"  Saved: {data_path} ({os.path.getsize(data_path)//1024} KB)")

# ================================================================
# SUMMARY
# ================================================================
print("\n" + "=" * 72)
print("  DELIVERABLES COMPLETE")
print("=" * 72)
print(f"  File_1.csv: {file1_data}")
print(f"  File_2.csv: {len(file2_df)} proposed stations")
print(f"    Sufficient: {(file2_df['grid_status']=='Sufficient').sum()}")
print(f"    Moderate: {(file2_df['grid_status']=='Moderate').sum()}")
print(f"    Congested: {(file2_df['grid_status']=='Congested').sum()}")
print(f"  File_3.csv: {len(file3_df)} friction points")
print(f"  Total chargers: {total_chargers} ({total_chargers*CHARGER_KW/1000:.1f} MW)")
print(f"  Total investment: €{total_cost_eur/1e6:.1f}M (baseline scenario)")
print(f"  AFIR/TEN-T gaps: {total_gaps} segments > threshold")
print(f"")
print(f"  3-Tier Strategy:")
print(f"    Tier 1 (Upgrade Iberdrola): {sum(1 for c in viable_points if c['tier']==1)}")
print(f"    Tier 2 (Partner Co-location): {sum(1 for c in viable_points if c['tier']==2)}")
print(f"    Tier 3 (New Partner): {sum(1 for c in viable_points if c['tier']==3)}")

print(f"\n  Financial summary (viable stations):")
fs = output_data['financial_summary']
print(f"    Gross capex:    €{fs['total_gross_capex']/1e6:.1f}M")
print(f"    Net capex:      €{fs['total_net_capex']/1e6:.1f}M (after {EU_GRANT_RATE*100:.0f}% EU grants)")
print(f"    Annual revenue: €{fs['total_revenue_yr']/1e6:.1f}M")
print(f"    Annual EBITDA:  €{fs['total_ebitda_yr']/1e6:.1f}M ({fs['avg_ebitda_margin']}% margin)")
print(f"    NPV+ stations:  {fs['stations_npv_positive']} of {len(viable_points)}")
print("=" * 72)
