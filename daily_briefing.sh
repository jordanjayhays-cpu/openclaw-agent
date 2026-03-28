#!/bin/bash
# Daily Briefing — Runs every morning at 8am CET
# Sends Jordan: weather, priorities, events, reminders

EMAIL="jordanjayhays@gmail.com"
DATE=$(date '+%A %B %d, %Y')
TIME=$(TZ='Europe/Madrid' date '+%I:%M %P' CET)

# Get weather
WEATHER=$(curl -s "wttr.in/Madrid?format=3")

# Get today's events from ICS if available
EVENTS="Check MISSION-CONTROL.md for today's priorities"

# Build email
cat << EMAIL > /tmp/briefing.html
<!DOCTYPE html>
<html>
<head>
<style>
body { font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; }
.header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; }
.content { padding: 20px 0; }
.item { margin: 15px 0; padding: 15px; background: #f8f9fa; border-radius: 8px; }
.weather { font-size: 24px; }
.time { color: #666; font-size: 14px; }
h2 { margin: 0; }
</style>
</head>
<body>
<div class="header">
<h2>☀️ Good Morning, Jordan</h2>
<p class="time">$DATE — $TIME CET</p>
</div>
<div class="content">
<div class="item">
<p><strong>🌤️ Weather in Madrid:</strong></p>
<p class="weather">$WEATHER</p>
</div>
<div class="item">
<p><strong>📋 Today's Top 3 Priorities:</strong></p>
<ol>
<li>Digital Nomad Meetup — 10am (tomorrow if today)</li>
<li>Connect with Javier Estrada (NH Hotel)</li>
<li>Plan week of outreach</li>
</ol>
</div>
<div class="item">
<p><strong>📅 This Week:</strong></p>
<ul>
<li>Mar 29: Digital Nomad Meetup</li>
<li>Apr 13: Business Networking PNM</li>
<li>Apr 15: HR Evolution</li>
<li>Apr 16: Foro Recursos Humanos</li>
</ul>
</div>
<div class="item">
<p><strong>💡 Quick Insight:</strong></p>
<p>You have 6 projects running. Focus on PISCO + COMARE outreach this week. The rest is research.</p>
</div>
</div>
</body>
</html>
EMAIL

echo "Briefing generated"
