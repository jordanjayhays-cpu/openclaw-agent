# NeuroMatch - Brain Scan Marketplace

A modern Next.js application for booking brain scans (MRI, CT, PET) at certified facilities across Spain.

## Features

- **Patient Portal**: Book scans, view bookings, access results
- **Facility Portal**: Manage appointments, upload scan results, availability calendar
- **Radiologist Portal**: Interpret scans, submit reports, track earnings
- **Admin Panel**: Platform analytics, commission tracking, network management

## Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Icons**: Lucide React
- **Deployment**: Vercel-ready

## Getting Started

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build
```

## Project Structure

```
NEUROMATCH/
├── app/
│   ├── page.tsx              # Landing page
│   ├── patient/page.tsx      # Patient dashboard
│   ├── facility/page.tsx     # Facility dashboard
│   ├── professional/page.tsx # Radiologist dashboard
│   ├── admin/page.tsx        # Admin panel
│   └── api/
│       ├── bookings/         # Bookings API
│       ├── facilities/       # Facilities API
│       └── professionals/    # Professionals API
├── components/
│   ├── Navigation.tsx
│   └── Footer.tsx
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/bookings` | GET | List all bookings |
| `/api/bookings` | POST | Create new booking |
| `/api/bookings` | PATCH | Update booking status |
| `/api/facilities` | GET | List facilities |
| `/api/facilities` | POST | Add new facility |
| `/api/professionals` | GET | List radiologists |
| `/api/professionals` | POST | Register radiologist |

## Design System

- **Primary Color**: #2563eb (Blue)
- **Medical Accent**: #0ea5e9 (Sky)
- **Typography**: Inter font family
- **Border Radius**: Rounded corners (rounded-xl, rounded-2xl)

## License

MIT
