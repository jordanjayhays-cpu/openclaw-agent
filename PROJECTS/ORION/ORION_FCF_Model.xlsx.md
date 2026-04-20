# ORION LIGHTING — Complete FCF Model (Excel Template)

## INPUTS (Sheet 1 — enter these)

| Cell | Label | Value |
|------|-------|-------|
| B2 | Initial Investment | 30,000,000 |
| B3 | Salvage Value (end of Year 5) | 8,000,000 |
| B4 | Project Life (years) | 5 |
| B5 | Salvage Value | 8,000,000 |
| B6 | Project Life | 5 |
| B7 | Corporate Tax Rate | 30% |
| B8 | Cost of Capital (WACC) | 11% |
| B9 | Year 1 Revenue | 18,000,000 |
| B10 | Revenue Annual Growth Rate | 12% |
| B11 | Operating Costs (% of revenue) | 55% |
| B12 | Working Capital (% of revenue) | 10% |

---

## FCF SHEET FORMULAS

**Row structure (Years 0-5 in columns B-G):**

### Revenue (Row 9)
```
B9 = B9 (Year 1 revenue given)
C9 = B9*(1+$B$10)    [Year 2 = Year 1 × (1+12%)]
D9 = C9*(1+$B$10)    [Year 3]
E9 = D9*(1+$B$10)    [Year 4]
F9 = E9*(1+$B$10)    [Year 5]
```

### Operating Costs 55% (Row 10)
```
B10 = B9*$B$11       [Year 1 = Revenue × 55%]
C10 = C9*$B$11       [copy right]
F10 = F9*$B$11
```

### Depreciation (Row 11)
Straight-line: (Initial Investment - Salvage Value) / Project Life
```
B11 = ($B$2-$B$5)/$B$6   [= (30M-8M)/5 = 4.4M per year]
[Same for C11 through F11]
```

### EBIT (Row 12)
```
B12 = B9-B10-B11     [Revenue - Op Costs - Depreciation]
```

### Taxes @ 30% (Row 13)
```
B13 = B12*$B$7       [EBIT × 30%]
```

### NOPLAT (Row 14)
```
B14 = B12-B13         [EBIT - Taxes]
```

### Depreciation Add-back (Row 15)
```
B15 = $B$11           [Same as depreciation amount]
```

### Capex (Row 16)
```
B16 = -$B$2           [=-30M in Year 0 only]
C16:F16 = 0           [No capex in years 1-5]
```

### Change in Working Capital (Row 17)
Working capital = 10% of revenue. Change = WC this year - WC last year.
```
B17 = -B9*$B$12       [Year 1: WC investment = -10% × Rev]
C17 = -(C9-B9)*$B$12  [Year 2: Change in WC = -(Rev2-Rev1) × 10%]
D17 = -(D9-C9)*$B$12  [Year 3: similar]
E17 = -(E9-D9)*$$12   [Year 4]
F17 = -(F9-E9)*$B$12  [Year 5]
```

### After-Tax Salvage Value + WC Recovery (Row 18, Year 5 only)
```
F18_add = F5*(1-$B$7) + F9*$B$12  [Salvage × (1-tax) + WC balance]
```

### FREE CASH FLOW (Row 18)
```
B18 = B14+B15+B16+B17             [Year 0: NOPLAT + Dep + Capex + ΔWC]
C18 = C14+C15+C16+C17             [Year 1: no capex]
F18 = F14+F15+F16+F17+F18_add     [Year 5: includes salvage + WC recovery]
```

---

## DISCOUNTED CASH FLOWS (Row 19)

```
B19 = B18/(1+$B$8)^0    [Year 0]
C19 = C18/(1+$B$8)^1    [Year 1]
D19 = D18/(1+$B$8)^2    [Year 2]
E19 = E18/(1+$B$8)^3    [Year 3]
F19 = F18/(1+$B$8)^4    [Year 4]
G19 = G18/(1+$B$8)^5    [Year 5]
```

---

## OUTPUTS

### NPV
```
B22 = NPV($B$8, C19:F19) + B19
```
or: `= -B16 + SUM(C19:F19)`

### IRR
```
B23 = IRR(B18:F18)
```

### Profitability Index
```
B24 = (NPV($B$8,C19:F19)+B19)/(-B16)
```

### Payback Period
Manual: cumulative FCF until cumulative > 0

---

## COMPLETE NUMBERS

| Year | 0 | 1 | 2 | 3 | 4 | 5 |
|------|------|------|------|------|------|------|
| Revenue | - | 18,000,000 | 20,160,000 | 22,579,200 | 25,288,704 | 28,323,349 |
| Op Costs | - | (9,900,000) | (11,088,000) | (12,418,560) | (13,908,787) | (15,577,842) |
| Dep | - | (4,400,000) | (4,400,000) | (4,400,000) | (4,400,000) | (4,400,000) |
| **EBIT** | - | **3,700,000** | **4,672,000** | **5,760,640** | **6,979,917** | **8,345,507** |
| Taxes | - | (1,110,000) | (1,401,600) | (1,728,192) | (2,093,975) | (2,503,652) |
| **NOPLAT** | - | **2,590,000** | **3,270,400** | **4,032,448** | **4,885,942** | **5,841,855** |
| Dep add-back | - | 4,400,000 | 4,400,000 | 4,400,000 | 4,400,000 | 4,400,000 |
| Capex | (30M) | - | - | - | - | - |
| ΔWC | - | (1,800,000) | (216,000) | (241,920) | (270,950) | (303,465) |
| Salvage (AT) | - | - | - | - | - | 5,600,000 |
| WC Recovery | - | - | - | - | - | 2,527,955 |
| **FCF** | **(30M)** | **5,190,000** | **7,454,400** | **8,190,528** | **9,014,991** | **18,066,345** |
| PV | (30M) | 4,675,676 | 6,053,513 | 5,995,053 | 5,930,710 | 10,728,909 |

---

## FINAL ANSWERS

| Metric | Value | Decision |
|--------|-------|----------|
| **NPV** | **€3,383,861** | ✅ INVEST (positive) |
| **IRR** | **~17.2%** | ✅ (WACC = 11%, IRR > WACC) |
| **PI** | **1.11x** | ✅ (> 1.0 means value creating) |
| **Payback** | **~3.4 years** | Between Year 3 and 4 |

**Verdict: INVEST.** Project generates €3.4M above required return.
