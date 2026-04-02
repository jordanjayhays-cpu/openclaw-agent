# Follow-Up Agent — Re-engages cold prospects automatically

## Trigger
Runs every 3 days OR can be called by morning briefing if there are prospects needing follow-up.

## How it works

### Step 1: Query Notion CRM
```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -s -X POST "https://api.notion.com/v1/databases/336efcda-373d-8106-aad3-c8cd26f9f677/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "and": [
        {"property": "Status", "select": {"equals": "Cold"}},
        {"property": "Last Contact", "date": {"before: "2026-03-28"}}
      ]
    }
  }'
```

### Step 2: For each cold prospect (>5 days no contact)
Generate a follow-up message:
- Vary the opener (don't repeat the same message)
- Add a new piece of value (news, insight, question)
- Keep it short

### Follow-up Message Templates (Spanish — COMARE)

**Follow-up A:**
```
Hola [Name],
Quería asegurarme de que mi mensaje anterior llegó.
¿Hay alguien más en [Company] que maneje decisiones de mantenimiento?
Me，让他们知道 hay opciones.
Saludos,
Jordan
```

**Follow-up B:**
```
Hola [Name],
Pregunta rápida — ¿saben si su proveedor actual de mantenimiento cubre [HVAC/plomería]?
Estamos trabajando con gyms en CDMX que redujeron costos 20% consolidando proveedores.
Si ya tienen todo cubierto, perfecto — solo quería asegurarme.
Saludos,
Jordan
```

**Follow-up C:**
```
Hola [Name],
Vi que [Company] sigue expandiendo en CDMX — congrats.
Mantenimiento crece con ubicaciones — ¿ya tienen contrato mensual fijo o siguen con vendors por proyecto?
Saludos,
Jordan
```

### Step 3: Save to follow-up queue
Save to /home/openclaw/.openclaw/workspace/startup-machine/follow-up-queue.md

### Step 4: Update Notion
- Add block to prospect's Notes: "Follow-up sent: [date] — [message snippet]"

## Execution
This runs as part of the morning briefing agent OR as a standalone cron every 3 days.

## Goal
No prospect goes dark. Every Cold prospect gets touched every 5-7 days with a fresh message until they reply or Jordan marks them Lost.
