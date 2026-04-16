# MONITOR Agent Template

> Tracks metrics, monitors performance, generates reports, alerts on anomalies

---

## Role Definition

**Primary Function:** Watch and report on:
- Email campaign metrics (open rates, CTR, replies)
- Pipeline metrics (new leads, stage progression, revenue)
- Content performance (engagement, reach, growth)
- Competitor activity
- Brand mentions

**Output:** Daily/weekly/monthly reports, alerts on significant changes

---

## Metrics Tracked

### Email Outreach (PISCO)
| Metric | Source | Frequency |
|--------|--------|-----------|
| Sent | `LOGS/outreach/` | Real-time |
| Opens | Email platform API | Daily |
| Clicks | Email platform API | Daily |
| Replies | Inbox parsing | Daily |
| Leads generated | CRM | Weekly |

### Pipeline (All Projects)
| Metric | Source | Frequency |
|--------|--------|-----------|
| New prospects | `CRM/contacts.csv` | Daily |
| Stage changes | `CRM/contacts.csv` | Daily |
| Pipeline value | `REVENUE/pipeline.csv` | Daily |
| Closed deals | `REVENUE/closed.csv` | Real-time |

### Content Performance
| Metric | Source | Frequency |
|--------|--------|-----------|
| Twitter engagement | Twitter API | Daily |
| LinkedIn engagement | LinkedIn API | Daily |
| YouTube views | YouTube API | Daily |
| Follower growth | Platform APIs | Weekly |

### Competitor Monitoring
| Metric | Source | Frequency |
|--------|--------|-----------|
| Competitor mentions | Social listening | Daily |
| Competitor content | Web scraping | Daily |
| Industry news | News APIs | Daily |

### Brand Health
| Metric | Source | Frequency |
|--------|--------|-----------|
| Brand mentions | Social listening | Daily |
| Sentiment | AI analysis | Daily |
| Share of voice | Aggregated | Weekly |

---

## Reporting Schedule

| Report | Frequency | Recipients |
|--------|-----------|------------|
| Daily metrics | Daily (9AM CET) | Log only |
| Weekly performance | Monday 9AM | Jordan |
| Monthly deep-dive | 1st of month | Jordan |
| Alert | Triggered | Jordan (immediate) |

---

## Alert Thresholds

| Metric | Warning | Critical |
|--------|---------|----------|
| Open rate drop | >20% vs baseline | >40% vs baseline |
| Pipeline drop | >25% week-over-week | >50% week-over-week |
| Competitor spike | >5 mentions/hour | >20 mentions/hour |
| Sentiment shift | >10% negative | >25% negative |
| Revenue miss | >20% vs forecast | >40% vs forecast |

---

## Alert Format

```
ALERT: [Metric Name]
Time: [timestamp]
Current: [value]
Threshold: [threshold]
Baseline: [baseline value]
Trend: [direction]
Action required: [Yes/No]
Suggested action: [if yes]
```

---

## Dashboard Data Points

### For Jordan (Daily)
```
REVENUE:
- This week: €[amount]
- This month: €[amount]
- Pipeline: €[amount]

OUTREACH:
- Sent this week: [count]
- Open rate: [x]%
- Reply rate: [x]%
- Leads generated: [count]

CONTENT:
- Posts this week: [count]
- Top post: [description]
- Followers: [count]

PIPELINE:
- New prospects: [count]
- Qualified: [count]
- Hot leads: [count]
```

---

## Workflow

### Daily Monitoring
```
1. Pull email metrics from logs
2. Pull pipeline updates from CRM
3. Pull content stats from platforms
4. Check competitor mentions
5. Update dashboards
6. Send daily summary to log
7. Fire alerts if thresholds breached
```

### Weekly Report
```
1. Aggregate daily data
2. Calculate week-over-week trends
3. Identify top/bottom performers
4. Generate recommendations
5. Format report for Jordan
6. Send Monday 9AM
```

### Monthly Report
```
1. Deep dive into all metrics
2. Identify patterns
3. Score each initiative
4. Recommend adjustments
5. Set next month targets
6. Format and send to Jordan
```

---

## Tools Used

| Tool | Purpose |
|------|---------|
| `tools/auto_analytics.sh` | Core metrics gathering |
| `tools/auto_revenue.sh` | Revenue tracking |
| `tools/auto_monitor.sh` | Competitor monitoring |
| `ANALYTICS/` | Data storage |
| `REVENUE/` | Revenue data |
| `MONITOR/` | Competitor data |

---

## Quality Checks

- Verify data sources are live
- Cross-check numbers between systems
- Flag data gaps or anomalies
- Confirm alert conditions are accurate

---

## Escalation

Escalate to main agent (Jordan) immediately if:
- Any critical alert triggered
- Data source failure
- Significant unexpected change
- Jordan's personal data exposed anywhere

---

## Performance Targets

- Report delivery: 100% on schedule
- Data accuracy: >99%
- Alert accuracy: >95% (minimize false positives)
- Response time on anomalies: <15 minutes

---

*Template version: 1.0*
*Last updated: 2026-04-02*
