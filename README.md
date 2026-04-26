# Massage Pass — Improved

New features built for Jordan's Massage Pass platform. **Not just another form.**

## What's Inside

### 1. 🧘 Massage Passport (`passport.html`)
Digital loyalty stamp card with gamification:
- 5-stamp grid that fills with each visit
- Progress bar showing how close to FREE massage
- Animated stamp pop when visiting
- Bronze → Gold level progression
- Reward unlock celebration banner

### 2. ⭐ Studio Spotlight
Instagram-style studio profile cards:
- Featured studios with ratings, reviews, distance
- Beautiful card design with emoji visuals
- Studio detail modal with services & pricing
- Full studio listing with ratings

### 3. 📱 Walk-in Mode
No-booking flow for walk-in customers:
- QR code display for each customer
- "Show this at reception" flow
- Works without app download
- 4-step how-it-works explanation

### 4. 🎁 Referral Program
Social sharing mechanics:
- Unique referral link per customer
- "Give 10%, Get 10%" reward structure
- Track pending vs. completed referrals
- Copy & share functionality

### 5. 🗺️ Google Maps Integration
Ready to plug in the existing API key (`AIzaSyDx4a7iq1lt4LItVg44_kDmzvlpK7Ftldo`):
- Map container ready for embed
- Studios Near You section
- Distance indicators on studio cards

### 6. Landing Page (`index.html`)
Full landing page tying all features together with feature grid and studio carousel.

## Files
- `index.html` — Landing page
- `passport.html` — Full Passport app (tabbed interface)
- `README.md` — This file

## Tech
- Pure HTML/CSS/JS — no framework needed
- Mobile-first responsive design
- No external dependencies except Google Fonts
- Google Maps API key pre-loaded and ready

## To Deploy
Push to GitHub Pages. The existing GitHub repo is `jordanjayhays-cpu/openclaw-agent`.

## Next Steps
1. [ ] Wire up Google Maps with the existing API key
2. [ ] Connect to Supabase (or migration path) to persist stamps per user
3. [ ] Add "Claim Free Massage" button when 5 stamps reached
4. [ ] Partner portal section to let studios see their referral stats
5. [ ] First-time visitor email capture modal
