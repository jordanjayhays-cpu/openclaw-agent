#!/usr/bin/env python3
"""
Google OAuth flow for Calendar access.
Step 1: Generate authorization URL
Step 2: Exchange authorization code for tokens
"""

import urllib.parse
import urllib.request
import json

# Your credentials
CLIENT_ID = "263558923582-r1jhdom4aeg9gooja5mvmt7du6o82i36.apps.googleusercontent.com"
CLIENT_SECRET = "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"
REDIRECT_URI = "http://localhost"

# Scopes for calendar access
SCOPES = [
    "https://www.googleapis.com/auth/calendar",
    "https://www.googleapis.com/auth/calendar.events"
]

def get_authorization_url():
    """Generate the URL Jordan needs to visit to authorize."""
    params = {
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "response_type": "code",
        "scope": " ".join(SCOPES),
        "access_type": "offline",  # This gets us a refresh token
        "prompt": "consent"  # Force consent screen to get refresh token
    }
    
    url = "https://accounts.google.com/o/oauth2/v2/auth?" + urllib.parse.urlencode(params)
    return url

def exchange_code_for_tokens(code):
    """Exchange authorization code for access and refresh tokens."""
    data = urllib.parse.urlencode({
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "code": code,
        "grant_type": "authorization_code",
        "redirect_uri": REDIRECT_URI
    }).encode()
    
    req = urllib.request.Request(
        "https://oauth2.googleapis.com/token",
        data=data,
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read())

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        # Just generate the URL
        url = get_authorization_url()
        print("=" * 60)
        print("AUTHORIZATION URL:")
        print("=" * 60)
        print(url)
        print("=" * 60)
        print()
        print("INSTRUCTIONS:")
        print("1. Copy and paste this URL into your browser")
        print("2. Log in with your Google account if needed")
        print("3. Click 'Allow' for all permissions")
        print("4. You'll be redirected to localhost (which won't load)")
        print("5. LOOK AT THE URL BAR in your browser - it will show:")
        print("   http://localhost/?code=XXXXX...")
        print("6. Copy the ENTIRE URL from your browser and paste it here")
        print()
        print("Then run this script again with the URL as argument:")
        print("python3 google_oauth.py 'http://localhost/?code=XXXXX...'")
    else:
        # Parse the redirect URL to get the code
        redirect_url = sys.argv[1]
        parsed = urllib.parse.urlparse(redirect_url)
        query_params = urllib.parse.parse_qs(parsed.query)
        code = query_params.get("code", [None])[0]
        
        if not code:
            print("ERROR: No authorization code found in URL")
            sys.exit(1)
        
        print("Exchanging authorization code for tokens...")
        tokens = exchange_code_for_tokens(code)
        
        if "access_token" in tokens:
            print()
            print("=" * 60)
            print("SUCCESS! Tokens received:")
            print("=" * 60)
            print(json.dumps(tokens, indent=2))
            print()
            print("REFRESH TOKEN (save this!):")
            print(tokens.get("refresh_token", "NO REFRESH TOKEN - see note"))
            print()
            print("NOTE: If no refresh_token was returned, you may need to")
            print("re-run with prompt=consent or check your OAuth settings.")
        else:
            print("ERROR getting tokens:")
            print(json.dumps(tokens, indent=2))
