# MASSAGE-PASS — Notion Database Schemas

> These schemas are ready to execute. Jordan needs to:
> 1. Create a Notion integration at https://notion.so/my-integrations
> 2. Store token in `~/.config/notion/api_key`
> 3. Create a parent page in Notion, share it with the integration
> 4. Give me the parent page ID — I'll create all 3 databases

---

## Database 1: Shops

**Parent:** Jordan's Notion page (page ID needed)

**Schema:**
```json
{
  "parent": { "page_id": "<JORDAN'S_PAGE_ID>" },
  "title": [{ "text": { "content": "🛒 MASSAGE-PASS: Shops" } }],
  "properties": {
    "Name":            { "title": {} },
    "Status":          { "select": { "options": [{ "name": "Lead" }, { "name": "Contacted" }, { "name": "Interested" }, { "name": "Signed" }, { "name": "Active" }, { "name": "Inactive" }] }},
    "Location":        { "rich_text": {} },
    "Contact Name":    { "rich_text": {} },
    "Contact Email":   { "email": {} },
    "Contact Phone":   { "rich_text": {} },
    "Rate (€)":        { "number": { "format": "euro" } },
    "Commission (%)":  { "number": { "format": "percent" } },
    "Notes":           { "rich_text": {} },
    "Signed Date":     { "date": {} },
    "Website":         { "url": {} }
  }
}
```

---

## Database 2: Subscribers

**Parent:** Same Jordan page as Shops

**Schema:**
```json
{
  "parent": { "page_id": "<JORDAN'S_PAGE_ID>" },
  "title": [{ "text": { "content": "👥 MASSAGE-PASS: Subscribers" } }],
  "properties": {
    "Name":             { "title": {} },
    "Status":           { "select": { "options": [{ "name": "Waitlist" }, { "name": "Active" }, { "name": "Paused" }, { "name": "Cancelled" }] }},
    "Email":            { "email": {} },
    "Phone":            { "rich_text": {} },
    "Plan":             { "select": { "options": [{ "name": "Basic (€49/mo)" }, { "name": "Premium (€89/mo)" }] }},
    "Join Date":        { "date": {} },
    "Cancellation Date":{ "date": {} },
    "Notes":            { "rich_text": {} },
    "Source":           { "select": { "options": [{ "name": "Landing Page" }, { "name": "Waitlist Form" }, { "name": "Referral" }, { "name": "Other" }] }}
  }
}
```

---

## Database 3: Bookings

**Parent:** Same Jordan page as Shops

**Schema:**
```json
{
  "parent": { "page_id": "<JORDAN'S_PAGE_ID>" },
  "title": [{ "text": { "content": "📅 MASSAGE-PASS: Bookings" } }],
  "properties": {
    "Booking ID":       { "rich_text": {} },
    "Subscriber Name":  { "rich_text": {} },
    "Subscriber Email": { "email": {} },
    "Shop":             { "rich_text": {} },
    "Status":           { "select": { "options": [{ "name": "Pending" }, { "name": "Confirmed" }, { "name": "Completed" }, { "name": "Cancelled" }, { "name": "No-show" }] }},
    "Request Date":     { "date": {} },
    "Visit Date":       { "date": {} },
    "Visit Time":       { "rich_text": {} },
    "Shop Notified":    { "checkbox": {} },
    "Shop Confirmed":   { "checkbox": {} },
    "Subscriber Notified": { "checkbox": {} },
    "Notes":            { "rich_text": {} }
  }
}
```

---

## What I'll Build Once API is Available

1. Create all 3 databases on Jordan's Notion page
2. Record the `database_id` for each
3. Update `STATE.yaml` with Notion IDs
4. Build the form-to-Notion submission pipeline (replacing Formspree)
5. Build the booking confirmation email workflow

## Blocker

- Still waiting on Jordan to:
  1. Create Notion integration → get API token
  2. Create parent page → share with integration
  3. Give me the parent page ID + store token in `~/.config/notion/api_key`
