# PISCO — Follow-Up Log

> Tracks outreach and follow-ups for warm leads.
> If no response in 3 days of outreach → follow-up reminder.
> Last updated: 2026-04-02

---

## CRM Fields for Each Lead
Each prospect in `contacts/CONTEXT.md` or `prospects/` should have:
- `first_contact_date`: YYYY-MM-DD
- `last_contact_date`: YYYY-MM-DD
- `next_followup_date`: YYYY-MM-DD (auto-set to first_contact + 3 days if no response)
- `status`: warm | contacted | following_up | converted | cold

---

## Follow-Up Schedule
| Trigger | Action |
|---------|--------|
| Outreach sent, no reply | Set `next_followup_date` = today + 3 days |
| Follow-up sent | Update `last_contact_date`, reset `next_followup_date` = + 7 days |
| Response received | Move to "warm" — set next follow-up to 14 days |
| 2 unanswered follow-ups | Mark as "cold", review strategy |

---

## Log

| Date | Lead | Action | Result | Next Follow-Up |
|------|------|--------|--------|---------------|
| | | | | |

---

## Warm Leads (Active)
_(Fill in — these need follow-up tracking)_

### Lead 1
- Company:
- Contact:
- first_contact_date:
- last_contact_date:
- next_followup_date:
- status:
- notes:

---

## Actions
- [ ] Import all existing PISCO prospects into this log
- [ ] Set next_followup_date for everyone with no response in 3+ days
- [ ] Run weekly check via heartbeat or weekly_review.sh
- [ ] When following up, log it here with date and outcome
