# Notion Setup Walkthrough — MASSAGE-PASS

> Jordan: follow these exact steps to unblock the Notion databases. ~10 minutes total.
> Once done, paste your API token + parent page ID and I'll build all 3 databases automatically.

---

## Step 1 — Create the Integration (~3 min)

1. Go to **[https://notion.so/my-integrations](https://notion.so/my-integrations)**
2. Click **"New integration"**
3. Fill in:
   - **Name:** `Massage Pass`
   - **Associated workspace:** your workspace
   - **Type:** Internal
   - **Logo:** optional (skip it)
4. Click **Submit**
5. **Copy the API token** — starts with `ntn_` or `secret_`

---

## Step 2 — Store the Token

On your machine, run:

```bash
mkdir -p ~/.config/notion
echo "ntn_your_token_here" > ~/.config/notion/api_key
```

> Replace `ntn_your_token_here` with the actual token from Step 1.

---

## Step 3 — Create Parent Page (~2 min)

1. Open Notion → click **New page**
2. Name it: `MASSAGE-PASS — Operations`
3. Click **"..."** (top right) → **"Add connections"** → search for **"Massage Pass"** → click it
4. Copy the **page ID** from the URL:
   ```
   https://notion.so/YOUR-NAME-HERE-[PAGE-ID-HERE]?v=...
                                     ↑ copy this part
   ```
   The page ID is the 32-char hex string (with dashes) at the end of the URL.

---

## Step 4 — Give Me the Info

Message me:
```
Notion ready:
- API token: ntn_xxx
- Parent page ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

---

## What I'll Build Immediately

Once I have those two things, I'll create all 3 databases:

| Database | Purpose |
|---|---|
| 🛒 Shops | All partner studios — status, contact, commission, signed date |
| 👥 Subscribers | All waitlist + paying members — plan, status, join date, source |
| 📅 Bookings | Every massage booking — shop, date, status, confirmations |

---

## Why This Matters Before Launch

- **Shops database** → track which studios are signed, their commission rate, contact info
- **Subscribers database** → replace the CSV tracking with a real CRM
- **Bookings database** → operational backbone of the whole business

Without this, Jordan is running the business out of a spreadsheet and localStorage — not sustainable past ~20 subscribers.
