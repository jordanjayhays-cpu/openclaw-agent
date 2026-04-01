# Overnight Work Log

## Sprint — 2026-04-01

### Task 1: Find emails for new PISCO hot leads
**Status:** ✅ COMPLETE  
**Started:** 2026-04-01 09:58 UTC  
**Finished:** 2026-04-01 09:59 UTC

**Findings:**

| Name | Company | Title | Email | Confidence |
|------|---------|-------|-------|------------|
| Lola Chamorro López | Meliá Hotels International | Global Head of TA & Employer Branding | lola.chamorrolopez@melia.com | ⚠️ LOW — unconfirmed |
| Mª Carmen Oliver Molina | Barceló Hotel Group | Group HR Director | mariaoliver.molina@barcelo.com | Medium |
| Patricia Jaén de la Vega | Palladium Hotel Group | Corporate Talent & Culture Director | patricia.jaen@palladiumhotelgroup.com | LOW — verify |
| Virginia Garrido | Barceló Hotels & Resorts | Directora RRHH Málaga | virginia.garrido@barcelo.com | Medium |

**Sources:** LinkedIn (profiles confirmed), RocketReach (email patterns), theorg.com (Lola bio), rrhhdigital.com (Patricia appointment Oct 2024)

**Actions taken:**
- Added all 4 contacts to `PROJECTS/PISCO/pisco-crm.json` (IDs 5–8)
- Patricia's email is pattern-guessed only — needs verification before outreach
- All LinkedIn profiles confirmed

**Blockers noted:**
- Patricia Jaén de la Vega email is low-confidence — recommend verifying via Hunter.io or direct LinkedIn outreach before sending

---

### Task 2: Find emails for existing PISCO targets
**Status:** ✅ COMPLETE
**Started:** 2026-04-01 21:58 UTC
**Finished:** 2026-04-01 21:59 UTC

**Corrections (IMPORTANT):**
- Concha Pardo and Gabriel Cánaves are at **Meliá Hotels International**, NOT NH Hotels (queue had wrong company)
- NH Hotel Group was acquired by Minor Hotels but Spain operations still use @nh-hotels.com domain

**Findings:**

| Name | Company (Corrected) | Title | Email | Confidence |
|------|---------------------|-------|-------|------------|
| Javier Estrada Gomez | NH Hotel Group Spain | Director RRHH | javier.estrada@nh-hotels.com | LOW |
| Yolanda de la Plaza | Room Mate Hotels | National & International HRBP | y.delaplaza@room-matehotels.com | LOW |
| Concha Pardo Gomez | Meliá Hotels International | HR Director Madrid | concha.pardo@melia.com | LOW |
| Gabriel Cánaves | Meliá Hotels International | Chief HR Officer | gabriel.canaves@melia.com | LOW |

**Sources:**
- Javier Estrada: LinkedIn profile confirmed (NH Spain), NH now owned by Minor Hotels but corporate contacts still use @nh-hotels.com (confirmed from corporate.minor-hotels.com)
- Yolanda de la Plaza: RocketReach confirmed Room Mate email format = `[first_initial].[last]@room-matehotels.com` (64% of employees)
- Concha Pardo: LinkedIn confirmed at Meliá Hotels (NOT NH Hotels). Email pattern inferred from Lola Chamorro (`lola.chamorrolopez@melia.com`)
- Gabriel Cánaves: LinkedIn + RocketReach confirmed at Meliá Hotels (NOT NH Hotels). RocketReach lists him as Chief HR Officer at Meliá. Email pattern inferred

**Actions taken:**
- Updated Javier Estrada (ID 1) in `pisco-crm.json` with email found
- Updated Yolanda de la Plaza (ID 3) in `pisco-crm.json` with email found + LinkedIn URL added
- Added Concha Pardo Gomez (ID 9) to `pisco-crm.json`
- Added Gabriel Cánaves (ID 10) to `pisco-crm.json`
- All marked LOW confidence — all need verification before sending

**Blockers noted:**
- All 4 emails are unconfirmed — verify with Hunter.io or LinkedIn Sales Navigator before any outreach
- Recommend verifying Javier Estrada via corporate.minor-hotels.com directory or direct LinkedIn message
