# MASSAGE-PASS — Subscriber Tracker

## How It Works
- **Pre-Notion:** Jordan exports Formspree submissions weekly → pastes into `subscribers.json`
- **Post-Notion:** Subscribers flow automatically into Notion DB via API
- **Backup:** This JSON file is the offline backup — always current

---

## subscribers.json Schema

```json
{
  "updated": "2026-04-18",
  "total": 0,
  "by_source": {
    "landing_page": 0,
    "waitlist_form": 0,
    "referral": 0
  },
  "by_status": {
    "waitlist": 0,
    "founding_member": 0,
    "active": 0,
    "paused": 0,
    "cancelled": 0
  },
  "founding_spots_remaining": 100,
  "members": []
}
```

### Member Entry:
```json
{
  "id": "mp-001",
  "email": "example@email.com",
  "name": "First Last",
  "phone": "+34XXXXXXXXX",
  "source": "landing_page | waitlist_form | referral",
  "status": "waitlist | founding_member | active | paused | cancelled",
  "plan": "essential | premium",
  "joined": "2026-04-18",
  "notes": ""
}
```

---

## Usage

### To add a subscriber manually:
```bash
node -e "
const fs = require('fs');
const d = JSON.parse(fs.readFileSync('subscribers.json'));
d.members.push({ id: 'mp-XXX', email: '...', ... });
d.total = d.members.length;
fs.writeFileSync('subscribers.json', JSON.stringify(d, null, 2));
"
```

### To export as CSV for email platform import:
```bash
node -e "
const fs = require('fs');
const d = JSON.parse(fs.readFileSync('subscribers.json'));
const csv = ['id,email,name,phone,source,status,plan,joined'];
d.members.forEach(m => csv.push([m.id,m.email,m.name,m.phone,m.source,m.status,m.plan,m.joined].join(',')));
console.log(csv.join('\n'));
"
```

---

## Founding Member Tracking

- Limit: 100 founding spots
- Price: €24.50/mo Essential / €44.50/mo Premium (50% off month 1)
- Remaining: calculated as `100 - members.filter(m => m.status === 'founding_member').length`

---

## Sync Instructions (Weekly)

1. Export Formspree submissions (or check Formspree dashboard)
2. Copy new emails into `subscribers.json` using format above
3. Run `updated` timestamp to today's date
4. Commit to git

---

*This file is a placeholder until Notion API is connected. Jordan to update weekly.*
