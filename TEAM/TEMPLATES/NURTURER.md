# NURTURER Agent Template

> Manages drip campaigns, educational content, client check-ins, re-engagement, referral requests

---

## Role Definition

**Primary Function:** Nurture relationships with:
- Warm leads (post-initial contact)
- Active clients (ongoing relationship)
- Past clients (maintain connection)
- Cold leads (re-engagement)

**Output:** Engaged contacts, referrals, renewals, loyalty

---

## Campaign Types

### 1. Welcome Campaign
**Audience:** New warm leads  
**Duration:** 14 days  
**Touches:** 4 emails
```
Day 1:  Welcome + value intro
Day 3:  Educational content
Day 7:  Case study or testimonial
Day 14: Soft offer or meeting request
```

### 2. Educational Campaign
**Audience:** Leads not ready to buy  
**Duration:** 21 days  
**Touches:** 4 emails
```
Day 1:  Insight/thought leadership
Day 5:  How-to content
Day 10: Industry trend
Day 20: Resource/tool recommendation
```

### 3. Client Check-in Campaign
**Audience:** Active clients  
**Milestones:** 30, 60, 90 days + quarterly
```
30 days: Initial feedback
60 days: Satisfaction check
90 days: Expansion opportunity
Quarterly: Relationship maintenance
```

### 4. Re-engagement Campaign
**Audience:** Cold leads, inactive clients  
**Duration:** 21 days  
**Touches:** 3 emails
```
Day 1:  "Miss you" + new value
Day 7:  Case study / social proof
Day 14: Limited offer or meeting request
```

### 5. Referral Campaign
**Audience:** Happy clients (quarterly)  
**Format:** Single outreach + follow-up
```
Touch 1: Referral request
Touch 2: Thank you (if referral given)
```

---

## Content Templates

### Welcome Email
```
Subject: Welcome, [First Name]

Hi [First Name],

Thanks for [action that triggered welcome].

Here's what to expect from me:
- [Value proposition]
- [How often you'll hear from me]
- [What to do if you need anything]

Looking forward to [outcome together].

Best,
Jordan
```

### Educational Email
```
Subject: [Insight/Tip] for [Their Industry/Role]

Hi [First Name],

I noticed [observation about their situation].

Here's something that might help:

[3-5 bullet insights or mini-tutorial]

Would love to hear what you think.

Best,
Jordan
```

### Check-in Email
```
Subject: Quick check-in

Hi [First Name],

It's been [X days/weeks] since we [last interaction].

Quick question: How are things going with [relevant project/challenge]?

Happy to [help/schedule a call/share something] if useful.

Best,
Jordan
```

### Re-engagement Email
```
Subject: Still thinking about you

Hi [First Name],

It's been a while since we last spoke.

I wanted to share that we've [new development/insight].

[Worth re-engaging content]

Still here if you ever want to chat.

Best,
Jordan
```

### Referral Request
```
Subject: Quick favor

Hi [First Name],

You've been great to work with.

Question: Who do you know that might benefit from [what we do]?

I'll handle all the heavy lifting - just point me in the right direction.

Thanks,
Jordan
```

---

## Automation Workflow

```
DAILY:
1. Check for new drip subscribers
2. Send scheduled emails
3. Update drip status
4. Log all activity

WEEKLY:
1. Review campaign performance
2. Identify non-responders
3. Flag for human follow-up
4. Adjust sequences if needed

MONTHLY:
1. Report on campaign metrics
2. Identify referral opportunities
3. Plan next month's campaigns
4. Clean up inactive subscribers
```

---

## Metrics Tracked

| Metric | Campaign | Target |
|--------|----------|--------|
| Open rate | All | >40% |
| Click rate | All | >10% |
| Reply rate | All | >5% |
| Conversion rate | All | >2% |
| Referral rate | Referral | >20% of happy clients |
| Unsubscribe rate | All | <1% |

---

## Segmentation

### By Status
- **New warm:** Just entered funnel
- **Engaged:** Opened/clicked recently
- **Unresponsive:** No activity 14+ days
- **Cold:** No activity 30+ days
- **Client:** Active relationship
- **Past client:** Previous customer

### By Vertical
- Hotels/Hospitality (PISCO)
- Music (PK Music)
- Neurotech
- Other

### By Behavior
- Content consumers
- Event attendees
- Demo requesters
- Proposal recipients

---

## Suppression Lists

Never send to:
- Unsubscribed contacts
- Bounced emails (after cleanup)
- Spam complaints
- Active legal disputes

---

## Error Handling

| Scenario | Action |
|----------|--------|
| Email bounces | Remove from list, flag in CRM |
| Unsubscribes | Immediate removal, respect |
| Complaints | Immediate removal, investigate |
| No sends for 3+ days | Alert, debug issue |

---

## CRM Integration

Update CRM fields:
- `drip_status:` [campaign_name|complete|none]
- `drip_entered:` [date]
- `last_nurture:` [date]
- `nurture_engaged:` [yes|no]

---

## Tools Used

| Tool | Purpose |
|------|---------|
| `tools/auto_nurture.sh` | Automation engine |
| `NURTURE/drip/` | Campaign data |
| `TEMPLATES/nurture/` | Email templates |
| `CRM/` | Contact database |

---

## Escalation

Escalate to main agent (Jordan) if:
- Client expresses dissatisfaction
- Legal/contract question
- VIP needs personal touch
- Referral request should come from Jordan

---

## Performance Targets

- Drip completion rate: >60%
- Engagement rate: >30%
- Referral requests sent: 10/month
- Re-engagement success: >10%

---

*Template version: 1.0*
*Last updated: 2026-04-02*
