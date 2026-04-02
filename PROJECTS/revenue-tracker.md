# Jordan's Revenue Tracker

## Last Updated: 2026-04-02

## Pipeline Overview

| Project | Pipeline | Prob | Expected | Closed | MTD |
|---------|----------|------|----------|--------|-----|
| PISCO | €50K | 30% | €15K | - | €0 |
| COMARE | $60K | 20% | $12K | - | $0 |
| MASSAGE | $600/mo | 50% | $300/mo | - | $0 |
| PK MUSIC | - | - | - | - | $0 |
| NEUROTECH | - | - | - | - | $0 |
| **TOTAL** | **€50K + $60K** | - | **€15K + $12K** | **$0** | **$0** |

---

## Commission Calculator

### PISCO
- 1 placement = 1 month salary fee
- Typical fee: €3,000-8,000 per placement
- **Jordan's commission: 10% of deal**
- Example: 1 NH property × 10 staff × €5K avg = €50K fee → **€5K commission**

### COMARE
- $500/client/month
- 10 clients = $60K/year

### MASSAGE-PASS
- Jordan's cut: **20%**
- 100 subscribers = $600/month gross → $120 Jordan

### PK MUSIC
- ~$3 per 1,000 streams
- 100K streams = $300/month

### NEUROTECH
- $15 per 1,000 subscribers (sponsorships)
- 10K subs = $150/post

---

## Monthly Targets

| Stream | Monthly Target | Annual Target | Progress |
|--------|---------------|---------------|----------|
| PISCO | €15K | €180K | 0% |
| COMARE | $5K | $60K | 0% |
| MASSAGE | $120 | $1,440 | 0% |

---

## Active Deals

*(Populated as deals are added via revenue machines)*

---

## Quick Commands

```bash
# Initialize all revenue systems
bash tools/pisco_revenue.sh init
bash tools/comare_revenue.sh init
bash tools/masspass_revenue.sh init
bash tools/pkmusic_revenue.sh init
bash tools/neurotech_revenue.sh init

# View dashboard
bash tools/revenue_dashboard.sh daily

# Add a PISCO lead
bash tools/pisco_revenue.sh add-lead "NH Hotels" "Maria Garcia" "maria@nh.com" 50000

# Generate proposal
bash tools/proposal_generator.sh generate pisco "NH Hotels" "Staff placement" 50000 "4 weeks"

# Generate contract
bash tools/contract_generator.sh generate pisco "NH Hotels" "Staff placement terms" "" "" 50000

# Generate invoice
bash tools/invoice_generator.sh deal pisco "NH Hotels" 50000

# Alert on deal milestone
bash tools/revenue_alerter.sh deal-hot pisco "NH Hotels" 50000
```
