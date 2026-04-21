"""
Build dashboard_v2.html — April 20 enhanced EV charging network dashboard
"""
import json, math, os
import pandas as pd

BASE = r'C:\Users\mandy\Desktop\Hackathon'
OUT  = r'C:\Users\mandy\Desktop\Hackathon\April 20 Revisions'

print("Loading revised_data.json...")
with open(os.path.join(OUT, 'revised_data.json'), encoding='utf-8') as f:
    d = json.load(f)

# ----------------------------------------------------------------
# Build proposed station list
# ----------------------------------------------------------------
proposed = []
for i, r in enumerate(d['recommendations']):
    n_ch = r.get('n_chargers_proposed', 2)
    cons = max(2, math.floor(n_ch * 0.8))
    aggr = math.ceil(n_ch * 1.2)
    proposed.append({
        'id':                  f'IBE_{i+1:03d}',
        'lat':                 r['snapped_lat'],
        'lon':                 r['snapped_lon'],
        'route':               r['route'],
        'grid_status':         r['grid_status'],
        'grid_mw':             r.get('nearest_grid_mw'),
        'data_quality':        r.get('data_quality', 'unknown'),
        'distributor':         r.get('distributor_network', 'i-DE'),
        'chargers_cons':       cons,
        'chargers_base':       n_ch,
        'chargers_aggr':       aggr,
        'n_chargers_proposed': n_ch,
        'tier':                r.get('tier', 3),
        'tier_label':          r.get('tier_label', 'New Partner'),
        'target_name':         r.get('target_name', ''),
        'demand_level':        r.get('demand_level', 'Medium'),
        'priority':            r.get('priority', 9),
        'priority_action':     r.get('priority_action', ''),
        'daily_sessions_p80':  r.get('daily_sessions_p80', 0),
        'daily_sessions_avg':  r.get('daily_sessions_avg', 0),
        'utilization_pct':     r.get('utilization_pct', 0.0),
        'util_peak_hour_pct':  r.get('util_peak_hour_pct', 0.0),
        'chargers_floor':      r.get('chargers_floor', 2),
        'chargers_demand_p80': r.get('chargers_demand_p80', n_ch),
        'chargers_peak_hr':    r.get('chargers_peak_hr', n_ch),
        'cost_eur':            r.get('cost_eur', n_ch * 150000),
        'is_tent':             r.get('is_tent', False),
        'afir_gap_threshold_km': r.get('afir_gap_threshold_km', 100),
        # Financial fields (Apr 20)
        'fin_revenue_yr':      r.get('fin_revenue_yr', 0),
        'fin_ebitda_yr':       r.get('fin_ebitda_yr', 0),
        'fin_ebitda_margin':   r.get('fin_ebitda_margin', 0),
        'fin_net_capex':       r.get('fin_net_capex', 0),
        'fin_payback_yrs':     r.get('fin_payback_yrs', 0),
        'fin_npv_10yr':        r.get('fin_npv_10yr', 0),
    })

print(f"  {len(proposed)} viable proposed stations")

# ----------------------------------------------------------------
# No-partner removed stations layer
# ----------------------------------------------------------------
no_partner_raw = d.get('no_partner_stations', [])
no_partner = []
for i, r in enumerate(no_partner_raw):
    no_partner.append({
        'id':    f'NOPARTNER_{i+1:03d}',
        'lat':   r['snapped_lat'],
        'lon':   r['snapped_lon'],
        'route': r['route'],
        'grid_status': r.get('grid_status', 'Congested'),
        'daily_sessions_p80': r.get('daily_sessions_p80', 0),
        'n_chargers_proposed': r.get('n_chargers_proposed', 0),
    })
print(f"  {len(no_partner)} no-partner removed stations")

# ----------------------------------------------------------------
# Grid, partners, iberdrola, other existing
# ----------------------------------------------------------------
grid = [{'lat': g['lat'], 'lon': g['lon'], 'mw': g['capacity_mw'], 'dist': g.get('distributor', '')}
        for g in d.get('grid_points', [])[:3000]]
partners = d.get('partner_sites', [])[:3000]
iberdrola = [{'lat': s['lat'], 'lon': s['lon'], 'name': s.get('name', '')}
             for s in d.get('iberdrola_near_roads', [])]

existing = pd.read_csv(os.path.join(BASE, 'ev_charging/osm_ev_charging_spain.csv'))
other = existing[~existing['operator'].fillna('').str.contains('berdrola', case=False)]
other_list = [{'lat': float(row['lat']), 'lon': float(row['lon'])} for _, row in other.head(2000).iterrows()]

# ----------------------------------------------------------------
# Geometries & route colors
# ----------------------------------------------------------------
geom = {}
route_colors = {}
colors = ['#2563EB','#7C3AED','#DB2777','#D97706','#059669','#DC2626','#0891B2','#65A30D','#9333EA','#F59E0B',
          '#3B82F6','#8B5CF6','#EC4899','#F97316','#10B981','#EF4444','#06B6D4','#84CC16','#A855F7','#EAB308']
for ci, name in enumerate(sorted(d['road_geometries'].keys())):
    geom[name] = d['road_geometries'][name][:500]
    route_colors[name] = colors[ci % len(colors)]

# ----------------------------------------------------------------
# Demand data for DoW chart
# ----------------------------------------------------------------
DAYS = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
DOW_FACTORS = [0.87, 0.90, 0.92, 0.97, 1.13, 1.06, 1.04]
demand = {}
for route, rd in d.get('demand_by_road', {}).items():
    p80 = rd.get('p80', 0)
    avg = rd.get('avg', round(p80 * 0.87))
    n_locs = rd.get('n_locs', 1)
    demand[route] = {
        'n_stations': n_locs,
        'baseline':     {'p80': p80,           'avg': avg,           'sessions': [round(p80*f)     for f in DOW_FACTORS]},
        'conservative': {'p80': round(p80*0.6), 'avg': round(avg*0.6),'sessions': [round(p80*0.6*f) for f in DOW_FACTORS]},
        'aggressive':   {'p80': round(p80*1.2), 'avg': round(avg*1.2),'sessions': [round(p80*1.2*f) for f in DOW_FACTORS]},
        'current':      {'p80': round(p80*0.35),'avg': round(avg*0.35),'sessions': [round(p80*0.35*f) for f in DOW_FACTORS]},
    }

# ----------------------------------------------------------------
# Financial summary
# ----------------------------------------------------------------
fin_summary = d.get('financial_summary', {})
model_params = d.get('model_params', {})

# ----------------------------------------------------------------
# Priority matrix, action map, summary KPIs
# ----------------------------------------------------------------
priority_matrix   = d.get('priority_matrix', {})
action_map        = d.get('action_map', {})
measured_congested = sum(1 for s in proposed if s['grid_status']=='Congested' and s['data_quality']=='measured')
data_gap          = sum(1 for s in proposed if s['data_quality']=='unknown')
afir_gaps_data    = d.get('afir_gaps', {})
total_cost_eur    = d.get('total_cost_eur', sum(s['cost_eur'] for s in proposed))
avg_util_pct      = round(sum(s['utilization_pct'] for s in proposed) / max(1, len(proposed)), 1)
tent_stations     = sum(1 for s in proposed if s['is_tent'])

MD = {
    'geometries':    geom,
    'proposed':      proposed,
    'no_partner':    no_partner,
    'iberdrola':     iberdrola,
    'other':         other_list,
    'partners':      partners,
    'grid':          grid,
    'route_colors':  route_colors,
    'afir_gaps':     afir_gaps_data,
}
CD = {
    'days':           DAYS,
    'demand':         demand,
    'scenarios':      d['scenarios'],
    'current_fleet':  d.get('current_fleet', 543337),
    'route_colors':   route_colors,
    'vehicle_types':  d.get('vehicle_types', {}),
    'priority_matrix': priority_matrix,
    'action_map':     action_map,
    'total_proposed': len(proposed),
    'total_chargers': sum(s['chargers_base'] for s in proposed),
    'tier_counts': {
        'tier1': sum(1 for s in proposed if s['tier']==1),
        'tier2': sum(1 for s in proposed if s['tier']==2),
        'tier3': sum(1 for s in proposed if s['tier']==3),
    },
    'grid_counts': {
        'Sufficient':         sum(1 for s in proposed if s['grid_status']=='Sufficient'),
        'Moderate':           sum(1 for s in proposed if s['grid_status']=='Moderate'),
        'Congested':          sum(1 for s in proposed if s['grid_status']=='Congested'),
        'measured_congested': measured_congested,
        'data_gap':           data_gap,
    },
    'meta':            d.get('metadata', {}),
    'total_cost_eur':  total_cost_eur,
    'avg_util_pct':    avg_util_pct,
    'tent_stations':   tent_stations,
    'afir_summary':    d.get('afir_summary', {}),
    'fin_summary':     fin_summary,
    'model_params':    model_params,
}

print("  Serializing JSON...")
md_json = json.dumps(MD, ensure_ascii=False, separators=(',', ':'))
cd_json = json.dumps(CD, ensure_ascii=False, separators=(',', ':'))
print(f"  MD JSON: {len(md_json)//1024} KB, CD JSON: {len(cd_json)//1024} KB")

# ----------------------------------------------------------------
# HTML template
# ----------------------------------------------------------------
HTML = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>EV Charging Network — April 21</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.5.3/dist/MarkerCluster.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.5.3/dist/MarkerCluster.Default.css"/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster@1.5.3/dist/leaflet.markercluster.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root {
  --ib-green:#00A758; --ib-green-dark:#008548; --ib-green-light:#E6F6EE;
  --ib-red:#D6002F; --ib-amber:#F5A623; --ib-red-light:#FBE5EA;
  --ib-blue:#0066B3;
  --bg:#F4F6F8; --surface:#FFFFFF; --surface-2:#FAFBFC;
  --border:#E4E7EB; --border-strong:#CBD2D9;
  --text:#1F2933; --text-2:#52606D; --text-3:#7B8794; --text-muted:#9AA5B1;
}
*{margin:0;padding:0;box-sizing:border-box;}
html,body{height:100%;}
body{font-family:'Inter',-apple-system,sans-serif;background:var(--bg);color:var(--text);display:flex;height:100vh;font-size:13px;-webkit-font-smoothing:antialiased;}
.sidebar{width:420px;background:var(--surface);border-right:1px solid var(--border);overflow-y:auto;padding:20px 22px 28px;flex-shrink:0;}
.sidebar::-webkit-scrollbar{width:8px;}
.sidebar::-webkit-scrollbar-thumb{background:var(--border-strong);border-radius:4px;}
.brand{display:flex;align-items:center;gap:10px;padding-bottom:14px;margin-bottom:16px;border-bottom:1px solid var(--border);}
.brand-mark{width:32px;height:32px;border-radius:6px;background:var(--ib-green);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:15px;}
.brand-text h1{color:var(--text);font-size:15px;font-weight:600;margin:0;}
.brand-text .sub{color:var(--text-3);font-size:11px;}
.ctrl{margin-bottom:12px;}
.ctrl label{font-size:10px;font-weight:500;color:var(--text-3);display:block;margin-bottom:4px;text-transform:uppercase;letter-spacing:.5px;}
.ctrl select{background:var(--surface);color:var(--text);border:1px solid var(--border-strong);border-radius:6px;padding:7px 10px;font-size:12.5px;width:100%;font-family:inherit;cursor:pointer;transition:border-color .15s;}
.ctrl select:focus{outline:none;border-color:var(--ib-green);box-shadow:0 0 0 3px rgba(0,167,88,.12);}
.ctrl-row{display:flex;gap:10px;}
.ctrl-row .ctrl{flex:1;}
.view-toggle{display:flex;margin-bottom:16px;background:var(--surface-2);border:1px solid var(--border);border-radius:8px;padding:3px;}
.view-toggle button{flex:1;padding:7px 10px;font-size:12px;font-family:inherit;font-weight:500;border:none;background:transparent;color:var(--text-2);border-radius:6px;cursor:pointer;transition:all .15s;}
.view-toggle button.active{background:var(--ib-green);color:#fff;font-weight:600;box-shadow:0 1px 2px rgba(0,0,0,.08);}
.kpi-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:14px;}
.kpi{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:10px 12px;}
.kpi .val{font-size:20px;font-weight:700;line-height:1.1;letter-spacing:-.3px;font-variant-numeric:tabular-nums;}
.kpi .lbl{font-size:10px;color:var(--text-3);margin-top:3px;font-weight:500;}
.kpi.accent .val{color:var(--ib-green);}
.kpi.warn .val{color:var(--ib-amber);}
.kpi.danger .val{color:var(--ib-red);}
.kpi.blue .val{color:var(--ib-blue);}
.section{color:var(--text-2);font-size:10.5px;font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin:18px 0 10px;padding-bottom:6px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.section-note{font-size:10px;color:var(--text-3);font-weight:400;text-transform:none;letter-spacing:0;}
.grid-bar{display:flex;height:22px;border-radius:6px;overflow:hidden;margin-bottom:10px;border:1px solid var(--border);}
.grid-bar div{display:flex;align-items:center;justify-content:center;font-size:10px;font-weight:600;color:#fff;}
.chart-panel{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:12px 14px;margin-bottom:10px;}
.chart-panel h3{font-size:11px;color:var(--text-2);margin-bottom:10px;font-weight:600;}
canvas{max-width:100%;}
.legend{font-size:11px;color:var(--text-2);margin-bottom:8px;}
.legend-item{display:flex;align-items:center;gap:8px;margin-bottom:5px;}
.legend-dot{width:12px;height:12px;border-radius:3px;flex-shrink:0;border:1px solid rgba(0,0,0,.1);}
#map{flex:1;background:var(--surface-2);}
.thresh-table{width:100%;font-size:11.5px;border-collapse:collapse;margin-bottom:10px;}
.thresh-table td,.thresh-table th{padding:6px 8px;border-bottom:1px solid var(--border);text-align:left;}
.thresh-table th{color:var(--text-3);font-weight:500;font-size:10px;text-transform:uppercase;letter-spacing:.5px;}
.thresh-table tr:last-child td{border-bottom:none;}
#matrixTable{text-align:center;}
#matrixTable th,#matrixTable td{padding:8px 4px;font-size:11.5px;font-variant-numeric:tabular-nums;}
#matrixTable th:first-child,#matrixTable td:first-child{text-align:left;font-weight:600;color:var(--text-2);}
.matrix-cell{cursor:pointer;border-radius:5px;transition:transform .1s,box-shadow .15s;user-select:none;font-weight:600;line-height:1.3;}
.matrix-cell:hover{transform:scale(1.04);box-shadow:0 2px 6px rgba(0,0,0,.15);}
.matrix-cell.active{outline:2px solid var(--text);outline-offset:-2px;box-shadow:0 0 0 3px rgba(0,167,88,.25);}
.matrix-sub{font-size:9px;font-weight:400;opacity:.8;display:block;}
.filter-indicator{display:none;align-items:center;justify-content:space-between;background:var(--ib-green-light);border:1px solid var(--ib-green);color:var(--ib-green-dark);padding:7px 10px;border-radius:6px;margin-top:8px;font-size:11.5px;font-weight:500;}
.filter-indicator.active{display:flex;}
.filter-indicator .clear-btn{background:var(--ib-green);color:#fff;border:none;padding:3px 9px;border-radius:4px;font-size:10.5px;cursor:pointer;font-weight:600;font-family:inherit;}
.note{font-size:10.5px;color:var(--text-3);margin-bottom:10px;line-height:1.4;}
#matrixDetail{display:none;background:var(--surface-2);border:1px solid var(--border);border-radius:8px;padding:12px 14px;margin-top:8px;}
#matrixDetail.active{display:block;}
#matrixDetail h4{font-size:11px;font-weight:600;color:var(--text-2);margin-bottom:8px;border-bottom:1px solid var(--border);padding-bottom:5px;}
.detail-stat{font-size:12px;color:var(--text);margin-bottom:4px;}
.detail-demand{font-size:13px;font-weight:700;color:var(--ib-green);margin:6px 0 4px;}
.top-routes{font-size:11px;color:var(--text-3);margin-top:8px;}
.top-routes b{color:var(--text-2);}
.fin-block{background:var(--ib-green-light);border:1px solid var(--ib-green);border-radius:8px;padding:10px 12px;margin-bottom:12px;}
.fin-block .fin-title{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--ib-green-dark);margin-bottom:8px;}
.fin-row{display:flex;justify-content:space-between;font-size:11.5px;margin-bottom:4px;}
.fin-row .fv{font-weight:600;color:var(--text);}
.leaflet-container{font-family:'Inter',sans-serif!important;background:#F4F6F8!important;}
.leaflet-control-layers{background:var(--surface)!important;border:1px solid var(--border)!important;border-radius:8px!important;box-shadow:0 4px 12px rgba(0,0,0,.08)!important;padding:6px 8px!important;font-size:12px!important;}
.leaflet-popup-content-wrapper{border-radius:8px!important;box-shadow:0 4px 16px rgba(0,0,0,.12)!important;}
.leaflet-popup-content{font-family:'Inter',sans-serif!important;font-size:12px!important;margin:12px 14px!important;}
.popup-header{font-weight:700;font-size:13px;margin-bottom:3px;}
.popup-tier{font-weight:600;font-size:12px;margin-bottom:8px;}
.popup-row{display:flex;justify-content:space-between;gap:8px;margin-bottom:3px;}
.popup-label{color:#7B8794;font-size:11px;white-space:nowrap;}
.popup-val{font-weight:500;font-size:11px;text-align:right;}
.popup-section{font-size:10px;font-weight:600;color:#52606D;text-transform:uppercase;letter-spacing:.5px;margin:8px 0 4px;padding-top:6px;border-top:1px solid #E4E7EB;}
.popup-action{font-size:10px;color:#7B8794;font-style:italic;margin-top:8px;border-top:1px solid #E4E7EB;padding-top:6px;}
.popup-partners{font-size:10.5px;color:#52606D;margin-top:6px;padding:5px 6px;background:#F4F6F8;border-radius:4px;}
.util-bar-wrap{margin:4px 0;}
.util-bar-bg{background:#F4F6F8;border-radius:4px;height:6px;overflow:hidden;}
.util-bar-fill{height:6px;border-radius:4px;transition:width .3s;}
</style>
</head>
<body>

<div class="sidebar">
  <div class="brand">
    <div class="brand-mark">i</div>
    <div class="brand-text">
      <h1 id="dashTitle">EV Charging Network</h1>
      <div class="sub">Electric Dragon &middot; Iberdrola Datathon 2026 &middot; Apr 21</div>
    </div>
  </div>

  <div class="view-toggle">
    <button id="viewFocus" class="active" onclick="setView('focus')">New Stations Only</button>
    <button id="viewAll" onclick="setView('all')">Full Network</button>
  </div>

  <div class="ctrl-row">
    <div class="ctrl">
      <label>Scenario</label>
      <select id="scenarioSel" onchange="updateAll()">
        <option value="conservative">Conservative (60%)</option>
        <option value="baseline" selected>Baseline (80%)</option>
        <option value="aggressive">Aggressive (100%)</option>
      </select>
    </div>
    <div class="ctrl">
      <label>Road Filter</label>
      <select id="roadFilter" onchange="updateAll()">
        <option value="all">All Roads</option>
        <option value="A-roads">A-/AP- Highways</option>
        <option value="N-roads">N- National Roads</option>
      </select>
    </div>
  </div>
  <div class="ctrl">
    <label>Route</label>
    <select id="routeSel" onchange="updateAll()">
      <option value="__all__">All Routes (Aggregate)</option>
    </select>
  </div>

  <div class="section" id="sectionStations">RECOMMENDATIONS</div>
  <div class="kpi-grid">
    <div class="kpi accent"><div class="val" id="kpiProposed">-</div><div class="lbl">Viable Locations</div></div>
    <div class="kpi warn"><div class="val" id="kpiNoPartner">-</div><div class="lbl">No-Partner Removed</div></div>
    <div class="kpi" style="border-left:3px solid var(--ib-green)"><div class="val" id="kpiTier1">-</div><div class="lbl">Upgrade Iberdrola</div></div>
    <div class="kpi" style="border-left:3px solid #0066B3"><div class="val" id="kpiTier2">-</div><div class="lbl">Partner Co-location</div></div>
  </div>
  <div class="kpi-grid">
    <div class="kpi" style="border-left:3px solid var(--ib-amber)"><div class="val" id="kpiTier3">-</div><div class="lbl">New Partner Sites</div></div>
  </div>

  <div class="section" id="sectionChargers">CHARGERS &amp; INVESTMENT (150 kW DC)</div>
  <div class="kpi-grid">
    <div class="kpi accent"><div class="val" id="kpiChargers">-</div><div class="lbl" id="lblChargers">Total Chargers</div></div>
    <div class="kpi"><div class="val" id="kpiAvgPerStn">-</div><div class="lbl">Avg / Station</div></div>
    <div class="kpi blue"><div class="val" id="kpiCost">-</div><div class="lbl">Gross Capex (€M)</div></div>
    <div class="kpi accent"><div class="val" id="kpiNetCapex">-</div><div class="lbl">Net Capex after Grants</div></div>
  </div>

  <div class="section">FINANCIAL PERFORMANCE (P&amp;L Projection, 2027)</div>
  <div class="fin-block">
    <div class="fin-title">Network P&amp;L Summary</div>
    <div class="fin-row"><span>Annual Revenue</span><span class="fv" id="finRevenue">-</span></div>
    <div class="fin-row"><span>Annual EBITDA</span><span class="fv" id="finEbitda">-</span></div>
    <div class="fin-row"><span>EBITDA Margin</span><span class="fv" id="finMargin">-</span></div>
    <div class="fin-row"><span>Avg Payback</span><span class="fv" id="finPayback">-</span></div>
    <div class="fin-row"><span>Stations NPV+</span><span class="fv" id="finNpvPos">-</span></div>
  </div>
  <div class="note">Revenue = sessions &times; 38 kWh &times; &euro;0.58/kWh &middot; Basis: Iberdrola P&amp;L Projection model &middot; WACC 7%</div>

  <div class="section">UTILIZATION &amp; DEMAND (P80 Design Day, 2027)</div>
  <div class="kpi-grid">
    <div class="kpi accent"><div class="val" id="kpiP80">-</div><div class="lbl">P80 Daily Sessions</div></div>
    <div class="kpi"><div class="val" id="kpiAvgD">-</div><div class="lbl">Avg Daily Sessions</div></div>
    <div class="kpi"><div class="val" id="kpiNetUtil">-</div><div class="lbl">Avg Network Util %</div></div>
    <div class="kpi danger"><div class="val" id="kpiGrowth">-</div><div class="lbl">Fleet Growth vs Now</div></div>
  </div>
  <div class="note">Utilization = P80 sessions / charger capacity (20h window, 70% efficiency). Target: &le;90% at peak hour. &gt;95% = cars turned away.</div>

  <div class="section">GRID CAPACITY <span class="section-note">caps charger deployment</span></div>
  <div class="grid-bar" id="gridBar"></div>
  <div class="kpi-grid">
    <div class="kpi danger"><div class="val" id="kpiMeasuredCong">-</div><div class="lbl">Measured Congested</div></div>
    <div class="kpi warn"><div class="val" id="kpiDataGap">-</div><div class="lbl">Data Gap (est. congested)</div></div>
  </div>
  <table class="thresh-table">
    <tr><th>Status</th><th>MW Available</th><th>Notes</th><th>Count</th></tr>
    <tr><td style="color:var(--ib-green);font-weight:600">Sufficient</td><td>&ge;1.8 MW</td><td>No upgrade needed</td><td id="gridSuff">-</td></tr>
    <tr><td style="color:var(--ib-amber);font-weight:600">Moderate</td><td>0.6&ndash;1.8 MW</td><td>Constrained</td><td id="gridMod">-</td></tr>
    <tr><td style="color:var(--ib-red);font-weight:600">Congested</td><td>&lt;0.6 MW</td><td>Grid upgrade req.</td><td id="gridCong">-</td></tr>
  </table>
  <div class="note">Sources: Endesa (1,838) + Viesgo/e-Redes + i-DE (265) + Naturgy R1-002 (679). 150 kW per charger. Nearest substation within 100km — proxy only, does NOT subtract existing load.</div>

  <div class="section">PRIORITY MATRIX <span class="section-note">click cell to filter map</span></div>
  <div class="note">Cells show station count. Click any cell to see demand covered and investment breakdown.</div>
  <table class="thresh-table" id="matrixTable">
    <tr><th></th><th style="color:var(--ib-green);text-align:center">Sufficient</th><th style="color:var(--ib-amber);text-align:center">Moderate</th><th style="color:var(--ib-red);text-align:center">Congested</th></tr>
    <tr><td>High</td>
      <td class="matrix-cell" id="mHiSu" data-demand="High" data-grid="Sufficient">-</td>
      <td class="matrix-cell" id="mHiMo" data-demand="High" data-grid="Moderate">-</td>
      <td class="matrix-cell" id="mHiCo" data-demand="High" data-grid="Congested">-</td>
    </tr>
    <tr><td>Medium</td>
      <td class="matrix-cell" id="mMeSu" data-demand="Medium" data-grid="Sufficient">-</td>
      <td class="matrix-cell" id="mMeMo" data-demand="Medium" data-grid="Moderate">-</td>
      <td class="matrix-cell" id="mMeCo" data-demand="Medium" data-grid="Congested">-</td>
    </tr>
    <tr><td>Low</td>
      <td class="matrix-cell" id="mLoSu" data-demand="Low" data-grid="Sufficient">-</td>
      <td class="matrix-cell" id="mLoMo" data-demand="Low" data-grid="Moderate">-</td>
      <td class="matrix-cell" id="mLoCo" data-demand="Low" data-grid="Congested">-</td>
    </tr>
  </table>
  <div class="filter-indicator" id="matrixFilterIndicator">
    <span id="matrixFilterLabel">Filter active</span>
    <button class="clear-btn" onclick="clearMatrixFilter()">Clear filter</button>
  </div>
  <div id="matrixDetail">
    <h4 id="matrixDetailTitle">Cell detail</h4>
    <div id="matrixDetailStats"></div>
  </div>

  <div class="section">AFIR / TEN-T COMPLIANCE <span class="section-note">EU Reg. 2023/1804</span></div>
  <div class="kpi-grid">
    <div class="kpi blue"><div class="val" id="kpiAfirGaps">-</div><div class="lbl">AFIR Coverage Gaps</div></div>
    <div class="kpi"><div class="val" id="kpiPeakMW">-</div><div class="lbl">Peak Demand (MW)</div></div>
  </div>
  <div class="note">TEN-T corridors: max 60 km gap (AFIR 2025). Other roads: 100 km. Orange markers show gap midpoints.</div>

  <div class="section">VEHICLE FLEET (BEV + PHEV only)</div>
  <div class="chart-panel">
    <h3>Chargeable Fleet by Vehicle Type</h3>
    <canvas id="vtChart" height="140"></canvas>
  </div>

  <div class="section" id="sectionDow">DAY-OF-WEEK DEMAND</div>
  <div class="chart-panel">
    <h3 id="dowTitle">Daily Charging Sessions: Current vs Forecast</h3>
    <canvas id="dowChart" height="160"></canvas>
  </div>

  <div class="section">DATA SOURCES</div>
  <table class="thresh-table" style="font-size:11px;">
    <tr><th>Dataset</th><th>Provider</th><th>Use</th></tr>
    <tr><td>Road geometry (99 roads)</td><td>OSRM / OpenStreetMap</td><td>Station placement</td></tr>
    <tr><td>EV fleet forecast</td><td>datos.gob.es</td><td>Demand sizing</td></tr>
    <tr><td>Traffic counts</td><td>MITMA (DGT)</td><td>Route demand weights</td></tr>
    <tr><td>Existing EV stations (4,801)</td><td>OSM ev_charging</td><td>Tier 1 matching</td></tr>
    <tr><td>Partner sites (13,958)</td><td>OSM fuel/rest areas</td><td>Tier 2 matching</td></tr>
    <tr><td>Grid: Endesa (1,838 pts)</td><td>Endesa / Red El&eacute;ctrica</td><td>Grid capacity</td></tr>
    <tr><td>Grid: Viesgo + e-Redes</td><td>Viesgo group</td><td>Grid capacity</td></tr>
    <tr><td>Grid: i-DE (265 substations)</td><td>Iberdrola Distribuci&oacute;n</td><td>Grid capacity</td></tr>
    <tr><td>Grid: Naturgy R1-002 (679 pts)</td><td>Naturgy</td><td>Grid capacity (Galicia + Madrid)</td></tr>
    <tr><td>Financial model</td><td>Iberdrola P&amp;L template</td><td>Revenue, EBITDA, NPV</td></tr>
  </table>
  <div class="note" style="margin-top:4px">Grid: nearest substation within 100 km used as proxy. Does not subtract existing load from capacity. &rarr; <a href="methodology.html" target="_blank" style="color:var(--ib-green)">Full methodology</a></div>

  <div class="section">MAP LEGEND <span class="section-note">fill = grid status &middot; border = tier</span></div>
  <div class="legend">
    <div style="font-size:10px;color:var(--text-3);margin-bottom:6px;"><b>Marker fill = Grid Status</b></div>
    <div class="legend-item"><div class="legend-dot" style="background:#00A758"></div>Sufficient (&ge;1.8 MW)</div>
    <div class="legend-item"><div class="legend-dot" style="background:#F5A623"></div>Moderate (0.6&ndash;1.8 MW)</div>
    <div class="legend-item"><div class="legend-dot" style="background:#D6002F"></div>Congested (&lt;0.6 MW)</div>
    <div style="font-size:10px;color:var(--text-3);margin:8px 0 4px;"><b>Border/Shape = Tier</b></div>
    <div class="legend-item"><div class="legend-dot" style="background:#eee;border:2px solid #00A758;border-radius:2px"></div>Square = Tier 1 (Upgrade Iberdrola)</div>
    <div class="legend-item"><div class="legend-dot" style="background:#eee;border:2px solid #0066B3;border-radius:2px"></div>Square = Tier 2 (Partner Co-location)</div>
    <div class="legend-item"><div class="legend-dot" style="background:#eee;border:2px solid #F5A623;border-radius:50%"></div>Circle = Tier 3 (New Partner)</div>
    <div class="legend-item"><div class="legend-dot" style="border:2px dashed #888;background:transparent"></div>Dashed = Data gap (unknown grid)</div>
    <div class="legend-item"><div class="legend-dot" style="background:#9CA3AF;border-radius:50%;opacity:.7"></div>Grey X = No-partner site (removed)</div>
    <div class="legend-item"><div class="legend-dot" style="background:#FF8C00;border-radius:50%;opacity:.7"></div>Orange circle = AFIR coverage gap</div>
  </div>
</div>

<div id="map"></div>

<script>
// ============================================================
// DATA
// ============================================================
const CD = __CD_JSON__;
const MD = __MD_JSON__;
const DAYS = CD.days;

const gridStatusColors = { Sufficient:'#00A758', Moderate:'#F5A623', Congested:'#D6002F' };
const tierBorderColors = { 1:'#00A758', 2:'#0066B3', 3:'#F5A623' };
const tierColors       = { 1:'#00A758', 2:'#0066B3', 3:'#F5A623' };

let currentScenario = 'baseline';

// ============================================================
// MAP
// ============================================================
const map = L.map('map', { center:[39.5,-3.5], zoom:6, zoomControl:true });
L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
  attribution:'&copy; OpenStreetMap contributors &copy; CartoDB',
  subdomains:'abcd', maxZoom:18,
}).addTo(map);

// ============================================================
// ROAD LAYERS
// ============================================================
const roadLayers = {};
const roadGroup = L.layerGroup();
Object.entries(MD.geometries).forEach(([name, coords]) => {
  const color  = MD.route_colors[name] || '#888';
  const weight = name.startsWith('N-') ? 2 : 3;
  const dash   = name.startsWith('N-') ? '6 4' : null;
  const line   = L.polyline(coords, { color, weight, opacity:0.7, dashArray:dash });
  line.bindTooltip(name, { sticky:true });
  roadLayers[name] = line;
  roadGroup.addLayer(line);
});
roadGroup.addTo(map);

// ============================================================
// HELPER: nearby partners
// ============================================================
function nearbyPartners(lat, lon, n, maxKm) {
  const R = 6371, results = [];
  MD.partners.forEach(p => {
    const dlat = (p.lat-lat)*Math.PI/180, dlon = (p.lon-lon)*Math.PI/180;
    const a = Math.sin(dlat/2)**2 + Math.cos(lat*Math.PI/180)*Math.cos(p.lat*Math.PI/180)*Math.sin(dlon/2)**2;
    const dist = R*2*Math.atan2(Math.sqrt(a),Math.sqrt(1-a));
    if (dist <= maxKm) results.push({...p, dist});
  });
  results.sort((a,b)=>a.dist-b.dist);
  return results.slice(0,n);
}

// ============================================================
// POPUP BUILDER
// ============================================================
function utilColor(pct) {
  if (pct>=95) return '#D6002F';
  if (pct>=70) return '#F5A623';
  return '#00A758';
}

function fmtM(eur) {
  const m = eur/1e6;
  return '\u20AC' + (m>=1000 ? (m/1000).toFixed(1)+'B' : m.toFixed(1)+'M');
}

function buildPopup(s, chargers) {
  const scenario   = currentScenario;
  const gridColor  = gridStatusColors[s.grid_status] || '#888';
  const tColor     = tierColors[s.tier] || '#F59E0B';
  const dqLabel    = s.data_quality==='measured' ? 'Measured' : 'Data gap \u2014 pipeline fill';
  const floor      = s.chargers_floor || 2;
  const demandP80  = s.chargers_demand_p80 || chargers;
  const peakHr     = s.chargers_peak_hr || chargers;
  const costK      = Math.round((s.cost_eur || chargers*150000)/1000);
  const costStr    = costK>=1000 ? '\u20AC'+(costK/1000).toFixed(1)+'M' : '\u20AC'+costK+'k';

  const util       = s.utilization_pct || 0;
  const utilPeak   = s.util_peak_hour_pct || 0;
  const uColor     = utilColor(util);
  const uPeakColor = utilColor(utilPeak);
  const utilBarWidth = Math.min(100,util);
  const utilBarColor = util>=95?'#D6002F':util>=70?'#F5A623':'#00A758';

  const gridMw   = s.grid_mw!=null ? parseFloat(s.grid_mw) : 0;
  const reqMw    = chargers*0.15;
  let gridAssign = '';
  if (s.data_quality==='measured' && gridMw>0) {
    const headroom = gridMw-reqMw;
    const hColor   = headroom>=0?'#00A758':'#D6002F';
    gridAssign = `<div class="popup-row"><span class="popup-label">Grid headroom</span><span class="popup-val" style="color:${hColor};font-weight:600">${headroom>=0?'+':''}${headroom.toFixed(2)} MW</span></div>
    <div class="popup-row"><span class="popup-label">Required / Available</span><span class="popup-val">${reqMw.toFixed(2)} / ${gridMw} MW</span></div>`;
  } else {
    gridAssign = `<div class="popup-row"><span class="popup-label">Grid connection</span><span class="popup-val" style="color:#F5A623">Verify with ${s.distributor||'DSO'}</span></div>`;
  }

  const tentBadge = s.is_tent
    ? `<span style="background:#E3F0FF;color:#0066B3;padding:1px 5px;border-radius:3px;font-size:9px;font-weight:600;margin-left:6px">TEN-T 60km</span>`
    : `<span style="background:#F4F6F8;color:#7B8794;padding:1px 5px;border-radius:3px;font-size:9px;margin-left:6px">non-TEN-T 100km</span>`;

  let partnerHtml = '';
  if (s.tier===3) {
    const nearby = nearbyPartners(s.lat,s.lon,3,10);
    if (nearby.length>0) {
      partnerHtml = `<div class="popup-partners"><b>Suggested partners (Tier 3):</b><br>`+
        nearby.map(p=>`${p.name||'Unnamed'} (${p.type||'fuel'}, ${p.dist.toFixed(1)} km)`).join('<br>')+`</div>`;
    }
  }

  // Financial block
  const rev   = s.fin_revenue_yr  || 0;
  const ebd   = s.fin_ebitda_yr   || 0;
  const mgn   = s.fin_ebitda_margin|| 0;
  const netCx = s.fin_net_capex   || 0;
  const pay   = s.fin_payback_yrs || 0;
  const npv   = s.fin_npv_10yr    || 0;
  const npvColor = npv>=0 ? '#00A758':'#D6002F';
  const finHtml = (rev>0) ? `
    <div class="popup-section">Financials (P&amp;L Projection)</div>
    <div class="popup-row"><span class="popup-label">Annual Revenue</span><span class="popup-val">${fmtM(rev)}</span></div>
    <div class="popup-row"><span class="popup-label">EBITDA</span><span class="popup-val">${fmtM(ebd)} (${mgn.toFixed(0)}%)</span></div>
    <div class="popup-row"><span class="popup-label">Net Capex (post-grant)</span><span class="popup-val">${fmtM(netCx)}</span></div>
    <div class="popup-row"><span class="popup-label">Payback</span><span class="popup-val">${pay.toFixed(1)} yrs</span></div>
    <div class="popup-row"><span class="popup-label">NPV 10yr</span><span class="popup-val" style="color:${npvColor};font-weight:600">${fmtM(npv)}</span></div>` : '';

  return `<div style="font-size:12px;min-width:280px;max-width:320px;">
    <div class="popup-header">${s.id} \u2014 ${s.route}${tentBadge}</div>
    <div class="popup-tier" style="color:${tColor}">${s.tier_label}</div>
    <div class="popup-row"><span class="popup-label">Target site</span><span class="popup-val">${s.target_name||'\u2014'}</span></div>
    <div class="popup-row"><span class="popup-label">Grid status</span><span class="popup-val" style="color:${gridColor};font-weight:600">${s.grid_status} (${gridMw>0?gridMw+' MW':'N/A'})</span></div>
    <div class="popup-row"><span class="popup-label">Data quality</span><span class="popup-val">${dqLabel}</span></div>
    <div class="popup-row"><span class="popup-label">Distributor</span><span class="popup-val">${s.distributor||'\u2014'}</span></div>
    ${gridAssign}
    <div class="popup-section">Chargers \u2014 ${scenario} scenario</div>
    <div class="popup-row"><span class="popup-label">Proposed (${scenario})</span><span class="popup-val"><b>${chargers} \xd7 150 kW = ${(chargers*0.15).toFixed(2)} MW</b></span></div>
    <div class="popup-row"><span class="popup-label">Min viable floor</span><span class="popup-val">${floor} chargers</span></div>
    <div class="popup-row"><span class="popup-label">Demand-based (P80)</span><span class="popup-val">${demandP80} chargers</span></div>
    <div class="popup-row"><span class="popup-label">Peak-hour (90% target)</span><span class="popup-val">${peakHr} chargers</span></div>
    <div class="popup-row"><span class="popup-label">Est. gross capex</span><span class="popup-val"><b>${costStr}</b></span></div>
    <div class="popup-section">Demand &amp; Utilization (2027)</div>
    <div class="popup-row"><span class="popup-label">P80 daily sessions</span><span class="popup-val"><b>${s.daily_sessions_p80}</b></span></div>
    <div class="popup-row"><span class="popup-label">Avg daily sessions</span><span class="popup-val">${s.daily_sessions_avg||0}</span></div>
    <div class="popup-row"><span class="popup-label">Daily utilization</span><span class="popup-val" style="color:${uColor};font-weight:600">${util}%</span></div>
    <div class="util-bar-wrap"><div class="util-bar-bg"><div class="util-bar-fill" style="width:${utilBarWidth}%;background:${utilBarColor}"></div></div></div>
    <div class="popup-row"><span class="popup-label">Peak-hour utilization</span><span class="popup-val" style="color:${uPeakColor};font-weight:600">${utilPeak}%</span></div>
    <div style="font-size:9px;color:#9AA5B1;margin-top:2px">Target: \u226490% peak &middot; &gt;95% = cars turned away &middot; &lt;30% = overbuilt</div>
    ${finHtml}
    ${partnerHtml}
  </div>`;
}

// ============================================================
// PROPOSED STATIONS
// ============================================================
const proposedGroup   = L.layerGroup();
const proposedMarkers = [];

MD.proposed.forEach(s => {
  const gridColor  = gridStatusColors[s.grid_status] || '#888';
  const tier       = s.tier || 3;
  const tierBorder = tierBorderColors[tier] || '#F5A623';
  const isNew      = tier===3;
  const isDashed   = s.data_quality==='unknown';
  const borderStyle = isDashed ? `border:2px dashed ${tierBorder};` : `border:2px solid ${tierBorder};`;
  const borderRadius = isNew ? '50%' : '3px';
  const size = 14;

  const icon = L.divIcon({
    className:'',
    html:`<div style="width:${size}px;height:${size}px;background:${gridColor};${borderStyle}border-radius:${borderRadius};box-shadow:0 0 4px rgba(0,0,0,.4);display:flex;align-items:center;justify-content:center;font-size:7px;font-weight:700;color:#fff;">${tier}</div>`,
    iconSize:[size,size], iconAnchor:[size/2,size/2],
  });

  const marker = L.marker([s.lat,s.lon],{icon})
    .bindPopup(buildPopup(s,s.chargers_base),{maxWidth:330});
  marker._data = s;
  proposedMarkers.push(marker);
  proposedGroup.addLayer(marker);
});
proposedGroup.addTo(map);

// ============================================================
// NO-PARTNER REMOVED STATIONS
// ============================================================
const noPartnerGroup = L.layerGroup();
(MD.no_partner||[]).forEach(s => {
  const icon = L.divIcon({
    className:'',
    html:`<div style="width:14px;height:14px;background:#9CA3AF;border:2px dashed #6B7280;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:8px;font-weight:700;color:#fff;opacity:.75;">\u2715</div>`,
    iconSize:[14,14], iconAnchor:[7,7],
  });
  noPartnerGroup.addLayer(L.marker([s.lat,s.lon],{icon})
    .bindPopup(`<b>${s.id} \u2014 ${s.route}</b><br>Removed: no partner site within 10 km<br>P80 sessions/day: ${s.daily_sessions_p80}<br>Grid: ${s.grid_status}`));
});

// ============================================================
// EXISTING STATIONS
// ============================================================
const iberCluster = L.markerClusterGroup({ disableClusteringAtZoom:10, maxClusterRadius:40 });
MD.iberdrola.forEach(s => {
  iberCluster.addLayer(L.marker([s.lat,s.lon],{
    icon:L.divIcon({className:'',html:'<div style="width:6px;height:6px;background:#00A758;border-radius:50%;opacity:.6;"></div>',iconSize:[6,6],iconAnchor:[3,3]})
  }));
});

const otherCluster = L.markerClusterGroup({ disableClusteringAtZoom:10, maxClusterRadius:40 });
MD.other.forEach(s => {
  otherCluster.addLayer(L.marker([s.lat,s.lon],{
    icon:L.divIcon({className:'',html:'<div style="width:5px;height:5px;background:#9AA5B1;border-radius:50%;opacity:.7;"></div>',iconSize:[5,5],iconAnchor:[2,2]})
  }));
});
// Existing station clusters are OFF by default — toggle via layer control
// iberCluster.addTo(map);
// otherCluster.addTo(map);

// ============================================================
// PARTNER SITES
// ============================================================
const partnerGroup = L.layerGroup();
MD.partners.forEach(p => {
  partnerGroup.addLayer(L.marker([p.lat,p.lon],{
    icon:L.divIcon({className:'',html:'<div style="width:4px;height:4px;background:#D6002F;border-radius:50%;opacity:.55;"></div>',iconSize:[4,4],iconAnchor:[2,2]})
  }).bindPopup(`<b>${p.name||'Unnamed'}</b><br>${p.type||''}`));
});

// ============================================================
// GRID CAPACITY CIRCLES
// ============================================================
const gridGroup = L.layerGroup();
MD.grid.forEach(g => {
  const color  = g.mw>=1.8?'#00A758':g.mw>=0.6?'#F5A623':'#D6002F';
  const radius = Math.max(800,Math.min(5000,g.mw*800));
  gridGroup.addLayer(L.circle([g.lat,g.lon],{
    radius, color, fillColor:color, fillOpacity:0.15, weight:0.5, opacity:0.4
  }).bindPopup(`<b>${g.mw} MW</b> \u2014 ${g.dist||''}`));
});

// ============================================================
// AFIR GAP MARKERS
// ============================================================
const afirGroup = L.layerGroup();
const afirGaps  = MD.afir_gaps || {};
let totalAfirGaps = 0;
Object.entries(afirGaps).forEach(([route,gaps]) => {
  gaps.forEach(gap => {
    totalAfirGaps++;
    const color = gap.is_tent ? '#FF6B00' : '#F5A623';
    afirGroup.addLayer(L.circle([gap.lat,gap.lon],{
      radius:8000, color, fillColor:color, fillOpacity:0.25, weight:2
    }).bindPopup(`<b>AFIR gap: ${route}</b><br>${gap.gap_km} km between stations<br>Threshold: ${gap.threshold_km} km ${gap.is_tent?'(TEN-T)':''}`));
  });
});
// AFIR gap layer is OFF by default — toggle via layer control
// afirGroup.addTo(map);

// Layer control — Road Network + Proposed Stations on by default.
// Everything else is an optional overlay (unchecked = not added to map).
const overlays = {
  'Road Network':           roadGroup,       // ✓ default ON
  'Proposed Stations':      proposedGroup,   // ✓ default ON
  'AFIR Coverage Gaps':     afirGroup,       //   toggle
  'No-Partner Removed':     noPartnerGroup,  //   toggle
  'Existing — Iberdrola':   iberCluster,     //   toggle
  'Existing — Other':       otherCluster,    //   toggle
  'Partner Sites':          partnerGroup,    //   toggle
  'Grid Capacity':          gridGroup,       //   toggle
};
L.control.layers(null, overlays, { collapsed:true, position:'topright' }).addTo(map);

// ============================================================
// MATRIX FILTER
// ============================================================
let matrixFilter = { demand:null, grid:null };

function setMatrixFilter(demand, grid) {
  if (matrixFilter.demand===demand && matrixFilter.grid===grid) { clearMatrixFilter(); return; }
  matrixFilter.demand = demand; matrixFilter.grid = grid; updateAll();
}
function clearMatrixFilter() { matrixFilter.demand=null; matrixFilter.grid=null; updateAll(); }
document.querySelectorAll('.matrix-cell').forEach(cell => {
  cell.addEventListener('click', () => setMatrixFilter(cell.getAttribute('data-demand'), cell.getAttribute('data-grid')));
});

// ============================================================
// VIEW MODE
// ============================================================
let currentView = 'focus';
function setView(mode) {
  currentView = mode;
  document.getElementById('viewFocus').classList.toggle('active', mode==='focus');
  document.getElementById('viewAll').classList.toggle('active', mode==='all');
  if (mode==='all') {
    // Full Network: proposed + roads + existing Iberdrola + existing Other
    if (!map.hasLayer(roadGroup)) map.addLayer(roadGroup);
    map.addLayer(iberCluster);
    map.addLayer(otherCluster);
    document.getElementById('dashTitle').textContent = 'EV Charging Network — Full';
  } else {
    // New Stations Only (default): roads + proposed stations only
    if (!map.hasLayer(roadGroup)) map.addLayer(roadGroup);
    map.removeLayer(iberCluster);
    map.removeLayer(otherCluster);
    document.getElementById('dashTitle').textContent = 'EV Charging Network';
  }
  updateAll();
}

// ============================================================
// ROUTE DROPDOWN
// ============================================================
const routeSel  = document.getElementById('routeSel');
const allRoutes = Object.keys(MD.geometries).sort();
allRoutes.forEach(r => {
  const opt = document.createElement('option');
  opt.value = r; opt.textContent = r + (r.startsWith('N-')?' (National)':'');
  routeSel.appendChild(opt);
});

// ============================================================
// CHARTS
// ============================================================
let dowChart = null, vtChart = null;
function buildVtChart() {
  const vt = CD.vehicle_types;
  const labels = Object.keys(vt);
  vtChart = new Chart(document.getElementById('vtChart'), {
    type:'bar',
    data:{
      labels: labels.map(l=>l.replace(' (<3.5t)','').replace(' (3.5-12t)','')),
      datasets:[
        { label:'BEV',  data:labels.map(k=>vt[k].ev_split.BEV),  backgroundColor:'#00A758' },
        { label:'PHEV', data:labels.map(k=>vt[k].ev_split.PHEV), backgroundColor:'#F5A623' },
      ]
    },
    options:{
      responsive:true, indexAxis:'y',
      plugins:{ legend:{ labels:{ color:'#1F2933', font:{ size:10, family:'Inter' } } } },
      scales:{
        x:{ stacked:true, ticks:{ color:'#7B8794', font:{family:'Inter'}, callback:v=>(v/1000).toFixed(0)+'K' }, grid:{ color:'#E4E7EB' } },
        y:{ stacked:true, ticks:{ color:'#1F2933', font:{ size:10, family:'Inter' } }, grid:{ display:false } },
      },
    }
  });
}
buildVtChart();

// ============================================================
// UPDATE ALL
// ============================================================
function getScenario()  { return document.getElementById('scenarioSel').value; }
function getRoadFilter(){ return document.getElementById('roadFilter').value; }
function getRoute()     { return routeSel.value; }

function updateAll() {
  const scenario   = getScenario();
  currentScenario  = scenario;
  const roadFilter = getRoadFilter();
  const route      = getRoute();

  let activeRoutes = allRoutes;
  if (roadFilter==='A-roads') activeRoutes = allRoutes.filter(r=>!r.startsWith('N-'));
  if (roadFilter==='N-roads') activeRoutes = allRoutes.filter(r=>r.startsWith('N-'));
  if (route!=='__all__') activeRoutes = [route];

  function passesMatrix(s) {
    if (!matrixFilter.demand && !matrixFilter.grid) return true;
    return s.demand_level===matrixFilter.demand && s.grid_status===matrixFilter.grid;
  }

  // Road visibility
  allRoutes.forEach(r => {
    const vis = activeRoutes.includes(r);
    if (vis  && !roadGroup.hasLayer(roadLayers[r])) roadGroup.addLayer(roadLayers[r]);
    if (!vis &&  roadGroup.hasLayer(roadLayers[r])) roadGroup.removeLayer(roadLayers[r]);
  });

  // Station visibility + popup refresh
  proposedMarkers.forEach(m => {
    const vis = activeRoutes.includes(m._data.route) && passesMatrix(m._data);
    if (vis  && !proposedGroup.hasLayer(m)) proposedGroup.addLayer(m);
    if (!vis &&  proposedGroup.hasLayer(m)) proposedGroup.removeLayer(m);
  });

  const filtered = MD.proposed.filter(s => activeRoutes.includes(s.route) && passesMatrix(s));
  const nS = filtered.length;
  const nT1 = filtered.filter(s=>s.tier===1).length;
  const nT2 = filtered.filter(s=>s.tier===2).length;
  const nT3 = filtered.filter(s=>s.tier===3).length;

  const chargerKey  = scenario==='conservative'?'chargers_cons':scenario==='aggressive'?'chargers_aggr':'chargers_base';
  const totalChg    = filtered.reduce((a,s)=>a+(s[chargerKey]||s.chargers_base),0);
  const avgPerStn   = nS>0 ? (totalChg/nS).toFixed(1) : '0';
  const peakMW      = (totalChg*0.15).toFixed(1);
  const totalCostM  = (filtered.reduce((a,s)=>a+(s.cost_eur||0),0)/1e6).toFixed(1);
  const netCapexM   = (filtered.reduce((a,s)=>a+(s.fin_net_capex||0),0)/1e6).toFixed(1);
  const avgUtil     = nS>0 ? (filtered.reduce((a,s)=>a+s.utilization_pct,0)/nS).toFixed(1) : '0';

  // Financial totals
  const totalRev  = filtered.reduce((a,s)=>a+(s.fin_revenue_yr||0),0);
  const totalEbd  = filtered.reduce((a,s)=>a+(s.fin_ebitda_yr||0),0);
  const avgMgn    = totalRev>0 ? (totalEbd/totalRev*100).toFixed(1) : '0';
  const avgPay    = nS>0 ? (filtered.reduce((a,s)=>a+(s.fin_payback_yrs||0),0)/nS).toFixed(1) : '0';
  const npvPos    = filtered.filter(s=>(s.fin_npv_10yr||0)>=0).length;

  // Demand aggregation
  let sessions=[0,0,0,0,0,0,0], currentSessions=[0,0,0,0,0,0,0];
  activeRoutes.forEach(r => {
    const rd=CD.demand[r]; if(!rd) return;
    const sd=rd[scenario], cd=rd.current;
    if(sd) for(let i=0;i<7;i++) sessions[i]+=(sd.sessions[i]||0);
    if(cd) for(let i=0;i<7;i++) currentSessions[i]+=(cd.sessions[i]||0);
  });
  const sortedS = [...sessions].sort((a,b)=>a-b);
  const p80     = sortedS[Math.ceil(7*0.8)-1]||0;
  const avgD    = Math.round(sessions.reduce((a,b)=>a+b,0)/7);
  const fleet   = CD.scenarios[scenario].evs_2027;
  const growth  = CD.current_fleet>0 ? Math.round((fleet/CD.current_fleet-1)*100) : 0;

  // Grid counts
  const gC={};
  filtered.forEach(s=>{ gC[s.grid_status]=(gC[s.grid_status]||0)+1; });
  const measCong = filtered.filter(s=>s.grid_status==='Congested'&&s.data_quality==='measured').length;
  const dataGap  = filtered.filter(s=>s.data_quality==='unknown').length;

  // KPI updates
  document.getElementById('kpiProposed').textContent     = nS.toLocaleString();
  document.getElementById('kpiNoPartner').textContent    = (MD.no_partner||[]).length.toLocaleString();
  document.getElementById('kpiTier1').textContent        = nT1.toLocaleString();
  document.getElementById('kpiTier2').textContent        = nT2.toLocaleString();
  document.getElementById('kpiTier3').textContent        = nT3.toLocaleString();
  document.getElementById('kpiChargers').textContent     = totalChg.toLocaleString();
  document.getElementById('kpiAvgPerStn').textContent    = avgPerStn;
  document.getElementById('kpiPeakMW').textContent       = peakMW;
  document.getElementById('kpiCost').textContent         = '\u20AC'+totalCostM+'M';
  document.getElementById('kpiNetCapex').textContent     = '\u20AC'+netCapexM+'M';
  document.getElementById('kpiP80').textContent          = p80.toLocaleString();
  document.getElementById('kpiAvgD').textContent         = avgD.toLocaleString();
  document.getElementById('kpiNetUtil').textContent      = avgUtil+'%';
  document.getElementById('kpiGrowth').textContent       = '+'+growth+'%';
  document.getElementById('kpiMeasuredCong').textContent = measCong.toLocaleString();
  document.getElementById('kpiDataGap').textContent      = dataGap.toLocaleString();
  document.getElementById('kpiAfirGaps').textContent     = totalAfirGaps.toLocaleString();
  // Financial summary panel
  document.getElementById('finRevenue').textContent  = '\u20AC'+(totalRev/1e6).toFixed(1)+'M';
  document.getElementById('finEbitda').textContent   = '\u20AC'+(totalEbd/1e6).toFixed(1)+'M';
  document.getElementById('finMargin').textContent   = avgMgn+'%';
  document.getElementById('finPayback').textContent  = avgPay+' yrs';
  document.getElementById('finNpvPos').textContent   = npvPos+'/'+nS;

  const scenarioLabel = CD.scenarios[scenario].label;
  document.getElementById('sectionStations').textContent = 'STATIONS \u2014 '+scenarioLabel;
  document.getElementById('sectionChargers').textContent = 'CHARGERS & INVESTMENT (150 kW DC) \u2014 '+scenarioLabel;
  document.getElementById('lblChargers').textContent     = 'Total Chargers ('+scenario+')';

  // Grid bar
  const total  = nS||1;
  let barHtml  = '';
  ['Sufficient','Moderate','Congested'].forEach(st => {
    const c = gC[st]||0;
    if(c>0) {
      const color = gridStatusColors[st];
      barHtml += `<div style="width:${(c/total*100).toFixed(1)}%;background:${color};">${c}</div>`;
    }
  });
  document.getElementById('gridBar').innerHTML = barHtml;
  document.getElementById('gridSuff').textContent = gC['Sufficient']||0;
  document.getElementById('gridMod').textContent  = gC['Moderate']||0;
  document.getElementById('gridCong').textContent = gC['Congested']||0;

  // Priority matrix
  const pMatrix      = CD.priority_matrix||{};
  const allNetS      = MD.proposed.reduce((a,s)=>a+s.daily_sessions_p80,0);
  const idMap        = {High:'Hi',Medium:'Me',Low:'Lo',Sufficient:'Su',Moderate:'Mo',Congested:'Co'};
  const priorityRank = {High_Sufficient:3,High_Moderate:2,High_Congested:1,Medium_Sufficient:6,Medium_Moderate:5,Medium_Congested:4,Low_Sufficient:9,Low_Moderate:8,Low_Congested:7};
  ['High','Medium','Low'].forEach(d => {
    ['Sufficient','Moderate','Congested'].forEach(g => {
      const cell    = (pMatrix[d]||{})[g]||{};
      const count   = typeof cell==='object' ? (cell.count||0) : (cell||0);
      const cellS   = typeof cell==='object' ? (cell.sessions||0) : 0;
      const demPct  = allNetS>0 ? (cellS/allNetS*100).toFixed(1) : '0';
      const el      = document.getElementById('m'+idMap[d]+idMap[g]);
      if(!el) return;
      el.innerHTML  = `${count}<span class="matrix-sub">${demPct}% demand</span>`;
      const rank    = priorityRank[d+'_'+g]||9;
      const opacity = Math.max(0.08,0.95-(rank-1)*0.1);
      el.style.background = count>0 ? `rgba(0,167,88,${opacity})` : '#F4F6F8';
      el.style.color = (count>0&&opacity>0.45)?'#fff':'#1F2933';
      el.classList.toggle('active', matrixFilter.demand===d&&matrixFilter.grid===g);
    });
  });

  // Matrix filter detail panel
  const indicator  = document.getElementById('matrixFilterIndicator');
  const detailPanel= document.getElementById('matrixDetail');
  if (matrixFilter.demand && matrixFilter.grid) {
    indicator.classList.add('active');
    document.getElementById('matrixFilterLabel').textContent =
      `Showing: ${matrixFilter.demand} demand \u00d7 ${matrixFilter.grid} grid (${filtered.length} stations)`;
    detailPanel.classList.add('active');
    const cellS    = filtered.reduce((a,s)=>a+s.daily_sessions_p80,0);
    const covPct   = allNetS>0?(cellS/allNetS*100).toFixed(1):'0';
    const cellChg  = filtered.reduce((a,s)=>a+(s[chargerKey]||s.chargers_base),0);
    const cellMW   = (cellChg*0.15).toFixed(1);
    const cellCost = (filtered.reduce((a,s)=>a+(s.cost_eur||0),0)/1e6).toFixed(1);
    const cellUtil = filtered.length>0?(filtered.reduce((a,s)=>a+s.utilization_pct,0)/filtered.length).toFixed(1):'0';
    const byRoute  = {};
    filtered.forEach(s=>{ byRoute[s.route]=(byRoute[s.route]||0)+s.daily_sessions_p80; });
    const topR = Object.entries(byRoute).sort((a,b)=>b[1]-a[1]).slice(0,5);
    document.getElementById('matrixDetailTitle').textContent = `${matrixFilter.demand} demand \u00d7 ${matrixFilter.grid} grid`;
    document.getElementById('matrixDetailStats').innerHTML =
      `<div class="detail-stat"><b>${filtered.length}</b> stations</div>
       <div class="detail-demand">${cellS.toLocaleString()} sessions/day = <b>${covPct}%</b> of network demand</div>
       <div class="detail-stat">Chargers: <b>${cellChg}</b> (${cellMW} MW) &middot; Gross capex: <b>\u20AC${cellCost}M</b></div>
       <div class="detail-stat">Avg utilization: <b style="color:${utilColor(parseFloat(cellUtil))}">${cellUtil}%</b></div>
       <div class="top-routes"><b>Top 5 routes by demand:</b><br>${topR.map(([r,v])=>`${r}: ${v.toLocaleString()} sessions`).join('<br>')}</div>`;
  } else {
    indicator.classList.remove('active');
    detailPanel.classList.remove('active');
  }

  // DoW chart
  if(dowChart) dowChart.destroy();
  const dowLabel = route==='__all__'?'Aggregate':route;
  document.getElementById('dowTitle').textContent = `${dowLabel}: Current vs ${scenarioLabel}`;
  dowChart = new Chart(document.getElementById('dowChart'), {
    type:'bar',
    data:{
      labels:DAYS,
      datasets:[
        { label:'Current (2026)', data:currentSessions, backgroundColor:'rgba(123,135,148,.35)', borderColor:'rgba(123,135,148,.9)', borderWidth:1 },
        { label:scenarioLabel,    data:sessions,        backgroundColor:'rgba(0,167,88,.55)',    borderColor:'#00A758', borderWidth:1 },
      ]
    },
    options:{
      responsive:true,
      plugins:{ legend:{ labels:{ color:'#1F2933', font:{ size:10, family:'Inter' } } } },
      scales:{
        x:{ ticks:{ color:'#7B8794', font:{family:'Inter'} }, grid:{ color:'#E4E7EB' } },
        y:{ ticks:{ color:'#7B8794', font:{family:'Inter'}, callback:v=>v.toLocaleString() }, grid:{ color:'#E4E7EB' } },
      },
    }
  });

  // Popup refresh for all markers
  proposedMarkers.forEach(m => {
    const s = m._data;
    m.setPopupContent(buildPopup(s, s[chargerKey]||s.chargers_base));
  });
}

setView('focus');
</script>
</body>
</html>"""

# Substitute data
HTML = HTML.replace('__CD_JSON__', cd_json).replace('__MD_JSON__', md_json)

out_path = os.path.join(OUT, 'dashboard_v2.html')
with open(out_path, 'w', encoding='utf-8') as f:
    f.write(HTML)

size = os.path.getsize(out_path)
print(f"dashboard_v2.html written: {size:,} bytes ({size//1024} KB)")
print("Done.")
