# TOOLS.md - Local Notes

## Jordan's Setup

- **Running on:** Railway (cloud server, Linux)
- **Chat channel:** Telegram
- **AI model:** OpenRouter (minimax-m2.7)

## Email (SendGrid SMTP)

Scripts in `/data/workspace/tools/`:
- `send_email.py` — Send plain emails
- `send_calendar_invite.py` — Send calendar invites (.ics attachments)

**Usage:** Just tell me who to email, subject, and body. I handle the rest.

**Credentials:** Stored in scripts (for now — consider moving to env vars later).

## Git Backup

- **Repo:** https://github.com/jordanjayhays-cpu/openclaw-agent
- **Token:** (stored in git remote URL — consider moving to env var)

## What's Configured

| Tool | Status | Notes |
|------|--------|-------|
| Email (SendGrid) | ✅ Working | send_email.py |
| Calendar invites (.ics) | ✅ Working | send_calendar_invite.py |
| Web search (DuckDuckGo) | ✅ Working | Built-in |
| Image analysis | ⚠️ Limited | OpenRouter doesn't support vision |
| Google Calendar API | ❌ Not set up | OAuth is painful |

## Preferences

- Jordan values speed and simplicity
- Skip the corporate fluff — just get it done
- If something won't work, say so quickly and offer alternatives
- Calendar workflow: I create .ics invite → email to attendees → they add to calendar
