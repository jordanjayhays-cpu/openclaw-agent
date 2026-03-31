====================================================================
CALENDAR INTEGRATION — HOW TO CONNECT OPENCLAW
====================================================================
Deep research on calendar access for OpenClaw
Last updated: 2026-03-28

====================================================================
WHY THIS MATTERS
====================================================================

Currently I work blind — I don't see your calendar.
If I had calendar access:

"Tomorrow you have the Digital Nomad meetup at 10am and a PNM
 networking event at 7pm. Want me to add them to your calendar?"

"I see you're free Thursday afternoon. Should I schedule
 research time for PISCO outreach?"

"Morning briefing: 2 meetings tomorrow, 4 hours focus time.
 Here's your day."

====================================================================
YOUR OPTIONS (From Simplest to Most Powerful)
====================================================================

=== OPTION 1: ICS FEED (SIMPLEST — READ ONLY)
====================================================================

What: Google Calendar exports a secret ICS URL. You give it to me.
I download and parse it daily.

Pros:
✅ Simplest setup — takes 2 minutes
✅ No OAuth, no complex setup
✅ Works with recurring events
✅ I can read your calendar for briefings

Cons:
❌ Read-only — I can't add events to your calendar
❌ Need to regenerate URL if you revoke it

HOW TO SET UP:

1. Open Google Calendar (calendar.google.com)
2. Click gear icon → Settings
3. Select your calendar from left sidebar
4. Scroll to "Integrate calendar"
5. Copy "Secret address in iCal format"
6. Give me that URL

WHAT I CAN DO:
- Morning briefings with your schedule
- Check conflicts before scheduling
- Remind you of upcoming events
- Surface what's on your calendar

WHAT I CAN'T DO:
- Add events to your calendar
- Modify existing events
- Send invites to others

---

=== OPTION 2: ICLOUD CALDAV (READ + WRITE)
====================================================================

What: If you use Apple/iCloud Calendar, CalDAV gives full access.
No OAuth pain. App-specific password.

Pros:
✅ Read AND write access
✅ I can add events directly to your calendar
✅ Simpler than Google (no OAuth consent screen)
✅ Works great with OpenClaw's caldav-calendar skill

Cons:
❌ Requires Apple/iCloud calendar
❌ Need app-specific password (but easy to generate)
❌ You need to be in Apple ecosystem

HOW TO SET UP:

1. Generate app-specific password:
   → appleid.apple.com → Sign in → Security → App-Specific Passwords
   → Generate one named "OpenClaw"

2. Get your CalDAV URL:
   → https://caldav.icloud.com/

3. Give me:
   - Your iCloud email
   - App-specific password
   - CalDAV URL

WHAT I CAN DO:
✅ Read your calendar
✅ Add events to your calendar
✅ Check conflicts
✅ Send invites
✅ Morning briefings
✅ Proactive scheduling

---

=== OPTION 3: GOOGLE CALDAV WITH SERVICE ACCOUNT (MOST ROBUST)
====================================================================

What: Google Workspace service account. Clean OAuth but for servers.
One-time setup, then fully automatic.

Pros:
✅ Full read + write access
✅ I can add events, send invites
✅ Fully automatic
✅ Best for power users

Cons:
❌ Requires Google Cloud Console setup
❌ One-time setup (~30 min)
❌ Requires Google Workspace (or have calendar shared with service account)

HOW TO SET UP (summary):

1. Go to console.cloud.google.com
2. Create project → Enable Calendar API
3. Create Service Account
4. Download JSON key
5. Share your calendar with the service account email
6. Give me the key

WHAT I CAN DO:
✅ Everything
✅ Read + write
✅ Send invites
✅ Check availability
✅ Proactive scheduling
✅ Full calendar management

---

=== OPTION 4: OUTLOOK / MICROSOFT 365
====================================================================

What: Microsoft Graph API for Outlook calendar.

Pros:
✅ Read + write access
✅ If you're already in Microsoft ecosystem

Cons:
❌ OAuth setup required
❌ Less common in Spain (Google/iCloud more popular)

====================================================================
RECOMMENDATION FOR JORDAN
====================================================================

Given your setup (Gmail, Railway cloud server, want simplicity):

**STEP 1 — DO THIS WEEK (5 minutes):**
Use ICS feed — I get read access to your calendar.
You can still add events manually. I can see your schedule.

**STEP 2 — DOWN THE LINE (30 min setup):**
Set up Google Service Account — I get full read/write access.
I can add events to your calendar when you ask.

**OR — IF YOU HAVE ICLOUD:**
Use iCloud CalDAV — simplest full access option.

====================================================================
WHAT I NEED FROM YOU
====================================================================

FOR OPTION 1 (ICS Feed — Do this now):
1. Open Google Calendar
2. Settings → Integrate calendar → Secret address in iCal format
3. Copy and paste the URL to me

FOR OPTION 2 (iCloud — If you use Apple):
1. Go to appleid.apple.com → App-Specific Passwords
2. Generate one called "OpenClaw"
3. Tell me your iCloud email and the password

FOR OPTION 3 (Google Service Account — Later):
1. Do you have a Google Workspace account?
   (Personal Gmail won't work for service accounts)
2. If yes, I'll guide you through setup

====================================================================
WHAT I CAN DO WITH EACH OPTION
====================================================================

| Feature | ICS Feed | iCloud | Google Service Account |
|---------|----------|--------|----------------------|
| Read calendar | ✅ | ✅ | ✅ |
| See today's events | ✅ | ✅ | ✅ |
| Check conflicts | ✅ | ✅ | ✅ |
| Morning briefing | ✅ | ✅ | ✅ |
| Add events | ❌ | ✅ | ✅ |
| Send invites | ❌ | ✅ | ✅ |
| Modify events | ❌ | ✅ | ✅ |
| Remove events | ❌ | ✅ | ✅ |

====================================================================
HOW IT WOULD WORK
====================================================================

WITH CALENDAR ACCESS, MY DAY:

Morning (8:00 AM cron):
- Check your calendar for today
- Surface: "You have X meetings, Y hours free"
- Flag: "Digital Nomad meetup at 10am — want me to add to calendar?"

When you ask:
- "Add PNM networking to my calendar for April 13 at 7pm"
- Done ✅

Before meetings:
- "Your PNM networking is in 15 minutes at Radisson RED Madrid"
- "Here's the link to the events list I sent you"

Proactive:
- "I see Thursday is clear. Good day for PISCO outreach?"
- "No events Friday afternoon — want to block for content creation?"

====================================================================
EVEN WITHOUT WRITE ACCESS
====================================================================

Even with just read access (ICS feed), I can:

✅ Morning briefings with your schedule
✅ Check before suggesting meeting times
✅ Flag conflicts
✅ Remind you of upcoming events
✅ Surface what's coming up

You still add events manually. But I tell you what to add and when.

====================================================================
NEXT STEPS
====================================================================

**THIS WEEK — 5 minutes:**
Give me your Google Calendar ICS URL:
1. calendar.google.com
2. Settings → Integrate calendar
3. Secret address in iCal format
4. Copy → paste to me

**OR — IF YOU USE ICLOUD:**
Give me your iCloud email + generate app-specific password.

**LATER — 30 minutes:**
Set up Google Service Account for full access.

====================================================================
