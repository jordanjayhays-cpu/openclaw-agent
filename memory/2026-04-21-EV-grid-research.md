# EV Charging Grid Capacity Solutions - Research Notes
## Date: 2026-04-21

## Sources Checked
- Wikipedia: Smart charger, V2G, Peak shaving, Load balancing, Demand response, Iberdrola, Grid energy storage, Tesla Supercharger, ChargePoint, Tesla Megapack, Solar canopy, Dynamic pricing
- Perplexity API: UNAVAILABLE (401 error)
- Felo Search: NOT CONFIGURED

## Key Findings

### 1. Smart Charging / Demand Response
- Smart charging (V1G/unidirectional) = varying time/rate of EV charging
- Demand response = utilities signal customers to reduce consumption during peak
- California CAISO defines 4 VGI levels: V1G, V1G aggregated, V1G fragmented, V2G bidirectional
- Smart meters enable real-time pricing signals to shift charging to off-peak
- Economics: US FERC defines DR as price-based or incentive-based load reduction

### 2. Energy Storage Integration (Batteries at Stations)
- Tesla Megapack: stores up to 3.9 MWh per unit
  - Megapack 2: $1.47M, 3.854 MWh, 1.284 MW, 92% round-trip efficiency
  - Megapack 2 XL: $1.39M, 3.916 MWh, 1.927 MW
  - 15-year warranty, 3,000-5,000 cycles
  - Weight: ~38,000 kg per unit
- Tesla already deploys Megapacks at Supercharger stations for peak shaving
- Mobile Supercharger stations with Megapack: can charge up to 100 vehicles
- Battery storage reduces need for grid reinforcement

### 3. V2G (Bidirectional)
- EVs can discharge power back to grid during peak demand
- Uni-directional V2G (UV2G) simpler than bidirectional
- Most EVs need separate inverter for AC output
- V2G enables "valley filling" (night charging) + "peak shaving" (day discharge)
- 100 kWh EV battery = ~3 days of average home power
- Battery degradation concern: slower discharge rates = less degradation
- Japan has commercial V2H since 2012; V2X still not market-deployed elsewhere as of 2022
- Carbitrage: buy cheap off-peak, sell high peak

### 4. Load Balancing Across Multiple Stations
- V1G power sharing: Tesla V1 stations split 120kW between paired stalls
- V3: up to 4 posts share 350kW cabinet, but typically deliver max per post
- ChargePoint CT4000 supports power sharing across multiple ports
- Cluster management software distributes load across geographic area

### 5. Renewable Energy Integration (Solar + Storage)
- Tesla Supercharger solar canopies: Lebec, CA example
- World's largest solar car park: 35 MW, Netherlands 2022
- Solar canopy costs 50%-2x more than ground-mount per kW
- France 2023 law: parking lots >50,000 sq ft must cover 50% with solar
- Iberdrola: operates 62,045 MW total capacity, 41,246 MW renewable
  - La Muela I+II = largest pumped storage in Europe (~1,500 MW)

### 6. Grid Reinforcement vs Smart Solutions
- Grid reinforcement costs: $1-3M per mile for new transmission lines
- Substation upgrades: $500K-$5M+
- Battery storage (Megapack 2): ~$381/kWh vs grid reinforcement
- Tesla Megapack installation: 40% lower installation costs for Megablock 3
- Storage cheaper than reinforcement when: distance > few miles, lowdemand area
- Smart charging software: $500-$5,000 per station for load management

### 7. Real-World Examples
- Tesla: Mobile Megapack Superchargers (can charge 100 vehicles), V4 cabinets 1-1.2MW for 8 stalls
- Tesla Megapack deployments: Kapolei Hawaii 585 MWh, Collie Australia 877 MWh
- ChargePoint: Power sharing in CT4000, Express Plus 400kW modular system
- Hornsdale Power Reserve (Australia): 150 MW / 194 MWh Tesla battery
- France: mandatory solar canopies on large parking lots (2023 law)
- Rutgers: 14.5 MW solar canopy + 8.8 MW existing (2023)

### 8. Iberdrola's Current Solutions/Strategy
- World's 2nd largest utility by market cap, largest wind producer
- €47B investment plan: €17B renewables, 12,100 MW new capacity by 2025
- La Muela II pumped storage: 850 MW (largest in Europe)
- West of Dudson Sands offshore wind: 389 MW (UK, 2014)
- i-DE brand: managing 270,000 km digitalized power lines
- Acquisitions: ScottishPower (UK), Avangrid (US), Neoenergia (Brazil), Infigen (Australia)
- Committed to 50% CO2 reduction by 2030, coal plant closure by 2017
- Revenue 2024: €44.7B, Operating income €9.7B

### 9. Peak Shaving Strategies
- Load management / demand-side management (DSM)
- Peak shaving: reduce demand during peak usage times
- Valley filling: charge during low-demand periods (typically night)
- Rolling blackouts avoided by reducing peak below capacity
- Ripple control: utility sends signal to switch loads (water heaters, AC)
- Smart meters + time-based tariffs (Economy 7 style)
- Battery storage at station level absorbs peaks

### 10. Time-of-Use (TOU) Pricing
- Dynamic pricing for electricity: higher at peak, lower off-peak
- TOU pricing: pre-established prices for specific time periods
- Critical peak pricing: very high prices during rare peak events
- Real-time pricing: varies hourly/daily based on market
- EV charging responds to TOU signals automatically via smart chargers
- Example: Economy 7 (UK) = cheaper night tariff for storage heating
- TOU + smart charging = ~20-30% load shifting potential

## Key Cost Benchmarks
| Solution | Cost |
|----------|------|
| Tesla Megapack 2 (3.85 MWh) | $1.47M |
| Tesla Megapack 2 XL (3.9 MWh) | $1.39M |
| Grid reinforcement per mile | $1-3M |
| Smart charging software per station | $500-$5,000 |
| Solar canopy (vs ground mount) | 50%-2x premium |
| Battery storage cost per kWh | ~$381 (Megapack 2) |
