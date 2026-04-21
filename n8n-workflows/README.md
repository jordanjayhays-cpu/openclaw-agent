# n8n Workflows for Me (OpenClaw Agent)

## Setup Instructions

### 1. Open n8n
- n8n Cloud: https://n8n.io/cloud
- Or self-hosted: https://n8n.io/docs

### 2. Import Workflows
1. Click "Workflows" → "Import"
2. Select the JSON file
3. Repeat for each workflow

### 3. Connect Credentials

**Telegram:**
- Bot Token (I already have this from OpenClaw setup)

**GitHub:**
- Personal Access Token (from github.com/settings/tokens)

**SendGrid:**
- API Key (Jordan already has this)

### 4. Activate
- Toggle each workflow to "Active"

---

## Workflows

### 01-MORNING_BRIEFING
- **Trigger:** 9am CET daily
- **What:** Check GitHub commits, send summary to Telegram
- **Use:** Jordan wakes up to what's been happening

### 02-RESEARCH_PIPELINE  
- **Trigger:** When I detect "research" in Telegram message
- **What:** Run parallel searches, aggregate findings
- **Use:** Deep research without blocking me

### 03-GITHUB_AUTO_COMMIT
- **Trigger:** HTTP webhook call
- **What:** Auto-commit and push changes
- **Use:** I dispatch commits without manual git commands

### 04-FILE_PROCESSOR
- **Trigger:** When files arrive in `/workspace/inbound`
- **What:** Detect file type, extract data, notify me
- **Use:** I handle attachments automatically

### 05-EMAIL_REPORT
- **Trigger:** 6pm CET daily
- **What:** Generate daily summary, send via SendGrid
- **Use:** Jordan gets email report of activity

---

## Quick Test

1. Open workflow
2. Click "Test workflow"
3. Should send test Telegram message

---

## What This Enables

| Task | Without n8n | With n8n |
|------|------------|----------|
| Morning briefing | I remember | Automatic 9am |
| Research | I block on it | n8n runs in background |
| GitHub commits | Manual git commands | I dispatch, n8n commits |
| File processing | Manual | Automatic on file drop |
| Email reports | None | Daily 6pm summary |

---

## Next: Extend These

- Add more Telegram commands
- Connect HubSpot for CRM updates
- Add Notion for task tracking
- Build outreach sequence workflows

