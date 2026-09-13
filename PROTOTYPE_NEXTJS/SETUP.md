# TravelMate — Next.js prototype setup

## Run it in Docker (no npm/node needed on your machine, zero setup)

```bash
docker compose up --build
```

That's genuinely it — a placeholder `.env.local` ships with the project so this
works immediately. Open http://localhost:3000.

First build takes a minute or two; after that, `docker compose up` starts
instantly using the cached image. To stop: `docker compose down`. To rebuild
after code changes: `docker compose up --build` again.

**Note on Google Calendar:** the Calendar screen in the app (`/group/calendar`)
is fully mocked — no real Google account or API key needed to try it. The
*real* Google OAuth integration also exists (`app/api/auth`, `app/api/calendar`)
as a reference for later, but nothing in the actual prototype UI calls it yet.

---

## Running it without Docker (if you prefer)

## 1. Install
```bash
npm install
```

## 2. Google Calendar (optional for now — the app runs fine without it)
1. Go to [Google Cloud Console](https://console.cloud.google.com) → create a project
2. Enable the **Google Calendar API**
3. Create an OAuth Client ID (Web application), redirect URI:
   `http://localhost:3000/api/auth/callback/google`
4. Copy `.env.example` to `.env.local` and fill in the values

## 3. Run
```bash
npm run dev
```
Open http://localhost:3000

## What's built
The complete app, all flows, running on realistic mock data — same contract-first
pattern used throughout this project:

- **Onboarding** — Welcome, Trip Setup (editable fields, real date pickers, mock
  flight/hotel suggestions), Interests, Trip Type (solo/group fork)
- **Trip** — day-by-day itinerary, clickable Activity Detail
- **Map** — a real embedded OpenStreetMap view (actual live map data, no API
  key) with itinerary pins, nearby-suggestion pins, live group-member pins,
  sharing toggle, announcement banner/composer, and the SOS button + detail screen
- **Group** — Invite (with presence dots), **Calendar availability check** (fully mocked), Voting, Compromise Result
- **Budget** — Overview (ring chart + category breakdown), Expense Logger, Cost Split
- **Disruption** — Alert screen, Replan diff output

## About the map
The map background is a real, live OpenStreetMap embed — genuine map data, not a
placeholder image. Pins are overlaid on top using absolute positioning. When
you're ready to add a real Maps SDK (Mapbox, Google Maps, or MapLibre +
OpenFreeMap for the free option already chosen elsewhere in this project), swap
out the `<iframe>` in `app/trip/map/page.tsx` for the SDK's map component — the
pin-overlay logic and all the group/announcement/SOS logic around it stays
exactly the same.

## Deploying (for judges)
Push this to GitHub, then import it at [vercel.com](https://vercel.com) —
free tier, no credit card needed, live URL in about a minute. Add the same
environment variables from `.env.local` in Vercel's project settings if using
Google Calendar.

## The honest limitation
Live background location tracking (for the SOS feature) genuinely cannot work
the same way in a browser as it does in a native app — no true background GPS
while a tab is closed or the phone is locked. This prototype is for demoing the
*interaction design*, not the real location feature. For the real product, wrap
this same React code in **Capacitor** to get native device APIs without a
second rewrite — see `backend-architecture.md` for the fuller reasoning.
