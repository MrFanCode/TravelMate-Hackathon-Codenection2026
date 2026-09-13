# 📋 TravelMate — Project Status Report

*Last updated: September 8, 2026*

---

## ⚠️ Major pivot: Next.js prototype, Flutter build paused

Per mentor guidance, the interactive prototype is now being built in **Next.js**
instead of continuing the Flutter app — easier to deploy (Vercel, no app store,
no emulator) and easier for judges to access via a live link. The Flutter build
(56 `.dart` files, 5 of 5 core flows working against mock data) is **not
abandoned** — it's paused, and remains the reference for the real native app
once background location/push notifications are needed for real (see the
Capacitor plan in `backend-architecture.md`).

**What changed and why**, in short:
- Frontend: Flutter → Next.js (React), for prototype/demo purposes
- Added: Google Calendar integration (freebusy check + calendar blocking)
- Considered and rejected: Life360 integration — no public developer API exists;
  kept the app's own live-location/SOS feature instead
- Everything else (Firebase, FastAPI, OR-Tools, Ollama, OpenFreeMap, Duffel,
  AeroDataBox) is unchanged — none of it depended on Flutter specifically


## Where we are, in one line

The entire frontend is built and working end-to-end — all 15 core flows exist in both Flutter (native reference) and Next.js (deployed prototype), plus several features added beyond the original scope (live location/SOS, checklist, calendar check, profile/multi-trip, offline PDF export). Backend (Firebase, FastAPI, OR-Tools, Ollama) is fully planned and documented but not yet built — that's the next phase.

---

## ✅ Done

### Product thinking
- [x] Problem defined — fragmentation across 5+ travel apps
- [x] Two user personas — solo backpacker (Maya) and group organizer (Jake)
- [x] Competitive analysis vs. Wanderlog, TripIt, Splitwise, Wonderplan.ai, Mindtrip
- [x] Key differentiator identified — adaptive replan (no competitor has this)
- [x] Feature priority matrix (MVP → Phase 4 roadmap)
- [x] Ideation history documented (3 rejected ideas, 5 iterations, mentor feedback)

### Visual design
- [x] Full design token system — palette, typography (Fraunces / Public Sans / Space Mono), signature "passport & airmail" motif
- [x] All 15 core screens mocked up at high fidelity:
  - Onboarding + trip setup (4 screens)
  - Solo itinerary flow (3 screens)
  - Group sync flow (3 screens)
  - Budget flow (3 screens)
  - Disruption & replan flow (2 screens)
- [x] Navigation model decided — linear flow for onboarding, bottom tab bar for main app
- [x] Logic/flow diagram of the whole app

### Technical planning
- [x] Full tech stack finalized (see README) — Flutter, Firebase, Python/FastAPI, Ollama (Qwen3 8B), OpenFreeMap + Nominatim, OpenStreetMap, Open-Meteo, Frankfurter
- [x] Confirmed every mocked screen is buildable in Flutter with standard packages — nothing exotic needed
- [x] AI cost modeled and hosting plan set — self-hosted via Ollama on Oracle free tier first, **DigitalOcean droplet** as the concrete fallback (chosen over Hostinger for better Docker support/documentation)
- [x] Hotspot/tourist-attraction suggestions decided — folded into the Map tab as a "nearby suggestions" layer, sharing one places data source (OpenStreetMap) with the itinerary engine
- [x] Itinerary control model clarified — plan generates a first draft, every activity stays user-editable (add/remove) regardless of source
- [x] Itinerary generation logic decided — hybrid: a constraint solver (OR-Tools) handles the actual scheduling math, AI handles language and fuzzy preference matching
- [x] Hotel & flight suggestions scoped — shown during trip setup as pick-one options, discovery only, not booking
- [x] Onboarding flow built in Flutter (4 screens, mock backend, verified end-to-end)
- [x] Solo Itinerary flow built in Flutter (screens 5-7: itinerary timeline, activity detail, map view with nearby suggestions) — bottom nav bar introduced here, matching the navigation model
- [x] Fixed real bugs found during review: back buttons added (Trip Setup, Interests, Trip Type, Map), destination field made actually editable, date fields made tappable date pickers — none of these needed backend, they were frontend gaps
- [x] Group Sync flow built in Flutter (screens 8-10: invite, voting dashboard, compromise result) — group trips now route through this flow instead of straight to the itinerary; solo trips are unaffected
- [x] Budget flow built in Flutter (screens 11-13: expense logger, budget overview, cost split) — all 4 main-app tabs (Trip/Map/Budget/Group) are now cross-wired from every tab screen
- [x] Disruption/Replan flow built in Flutter (screens 14-15: flight delay alert, replan output) — **all 15 screens now exist in Flutter, frontend build is complete**
- [x] Live group location + SOS feature built in Flutter — new scope beyond the original 15 screens, added to the Map tab and Group flow. Opt-in sharing toggle, live member pins, manual "I need help" alert with a receiving screen. **Not yet backed by real device GPS** — see the flagged item below.
- [x] Group announcements built in Flutter — one-way broadcast with quick-pick presets, reusing the same alert pattern as SOS/Disruption. Considered a full attendance/check-in feature and deliberately didn't build it — a presence dot on member avatars (reusing existing location data) covers the need more cheaply. See `announcement-api-contract.md`.
- [x] `group-sync-api-contract.md` written
- [x] `budget-api-contract.md` written
- [x] `disruption-api-contract.md` written — the one contract where the trigger is external (a scheduled Cloud Function), not user navigation
- [x] `group-location-api-contract.md` written — live location sharing + SOS alert, flags the real device-permission complexity for later
- [x] `announcement-api-contract.md` written
- [x] `backend-architecture.md` written — auth flow, Firestore schema, per-endpoint service responsibilities, disruption-detection flow, and a full request-lifecycle walkthrough
- [x] `solo-itinerary-api-contract.md` written — defines the real backend shape for this flow
- [x] Problem-statement coverage checked against the original 5 pain points — see README; one deliberate partial gap (booking) called out explicitly
- [x] **Next.js prototype started** — Onboarding flow fully ported (Welcome, Trip Setup with real editable fields, Interests, Trip Type fork), landing pages for Trip and Group Invite, following the exact same contract-first/mock-first pattern as the Flutter build
- [x] **Next.js prototype completed** — all remaining flows ported: Group Voting, Compromise Result, Map (real embedded OpenStreetMap with pin overlay — see note below), Budget Overview/Expense Logger/Cost Split, Disruption Alert/Replan, SOS detail screen, Announcements (built as a modal on the Map page), **and Group Calendar availability check (fully mocked)**. Every internal link verified to resolve to a real page — no dead links, checked programmatically.
- [x] **Zero-config demo** — a placeholder `.env.local` ships with the project, so `docker compose up --build` works immediately with no setup, no real Google credentials, nothing to configure. The real Google Calendar OAuth code still exists as a reference (`app/api/auth`, `app/api/calendar`) but the actual UI runs entirely on mocked data.
- [x] **Personal checklist added** (passport, cash, packing) — new feature beyond the original scope, one per traveler (not shared with the group). AI generates a starter list based on destination/season/interests (simulated in the prototype), plus manual add/remove/check-off. See `checklist-api-contract.md`.
- [x] **Sign Up / Log In screens added** — genuinely missing before this; the Welcome screen's "Get started" went straight to onboarding with no account step at all, and "I already have an account" was a dead `href="#"` link. Both fixed: real screens now exist (fully mocked, no backend call), Welcome routes through them correctly. Real implementation is Firebase Auth, per `backend-architecture.md`.
- [x] **Real bugs fixed:** bottom nav had text labels but no icons (added real SVG icons matching the Flutter icon set); Budget ring's percentage text was off-center (was using a margin-hack instead of proper absolute positioning, now fixed)
- [x] **Profile screen + multi-trip support added** — shows account info and a "My Trips" list (planning/upcoming/completed/cancelled states), with a "+ Plan a new trip" button that resets onboarding state and starts fresh — this is the actual mechanism proving a user isn't limited to one trip at a time
- [x] **Flight/hotel comparison page added** — Trip Setup previously only showed one flight and one hotel suggestion inline; now there's a dedicated compare page (3 of each, sorted by price) reached via "Compare all flights & hotels →"
- [x] **Offline/PDF export added** — a genuinely functional feature, not faked: uses the browser's native print-to-PDF (`window.print()`) on a clean summary page (itinerary + checklist + budget), so it actually produces a real downloadable PDF with zero dependencies. Solves a real problem (spotty connectivity while traveling), not just a nice-to-have.
- [x] **Dockerized** — multi-stage Dockerfile + docker-compose.yml, runs with `docker compose up --build`, no local npm/node install needed
- [x] Google Calendar integration built — NextAuth + Google OAuth with calendar scopes, freebusy-check API route, calendar-blocking API route. Real working code, not just planned.
- [x] Life360 evaluated and rejected — no public developer API exists for third-party integration; the app's own location/SOS feature (already built) covers this need
- [x] Flight/hotel data provider decided for Phase 3 — Duffel (search + booking, pay-per-order, covers hotels too) + AeroDataBox (delay/status, from $5.35/mo). Confirmed Amadeus's free tier — the old default answer — fully shut down its self-service portal July 17, 2026, closing off what used to be the standard free option. Fits the $25/mo starting budget with room to scale (Duffel's pricing scales with bookings, not raw traffic). See `backend-architecture.md` for the full writeup and caching/webhook patterns needed to actually scale it.

---

## 🔲 Not done yet

### Decisions still open
- [ ] Exact OR-Tools constraint model (what counts as "fits" — travel time between stops, opening hours, etc.) not yet designed
- [ ] Oracle free tier availability untested — still need to try signing up before knowing if the free path works at all; DigitalOcean droplet is the confirmed fallback if not

### Design — remaining polish
- [ ] Error states, empty states, loading states (not designed for any screen yet)
- [ ] Onboarding → main app transition screen (the moment the bottom nav first appears)
- [ ] Dark mode / accessibility pass
- [ ] Tablet / larger-screen layouts (currently phone-only)

### Engineering — everything is still ahead of us
- [ ] Firestore security rules not written — needed before any real deployment
- [ ] **Real map SDK still not wired** — the Next.js Map page uses a real, live embedded OpenStreetMap `<iframe>` (genuine map data, not a placeholder image) with pins overlaid via absolute positioning. It looks real and IS real map data, but it's not a full interactive SDK (no pan/zoom on the map itself — the iframe has pointer-events disabled so it doesn't interfere with the pin overlay). Swap for MapLibre + OpenFreeMap when full interactivity is needed; the pin/group/SOS logic around it doesn't change.
- [ ] **Multi-person Google Calendar (real)** — the UI flow exists and looks/feels complete (`/group/calendar`), but runs on fake data. The real Google OAuth routes exist separately (`app/api/auth`, `app/api/calendar`) but aren't wired to the UI yet. Real implementation requires every group member to individually connect their own Google account and their tokens stored (e.g. in Firestore) so the backend can loop over each of them.
- [ ] **Capacitor wrap for native features** — planned but not started. Needed once background location/push notifications must actually work, since browsers can't do true background GPS.
- [ ] **Real background location tracking** — the Flutter UI is built, but actual continuous GPS (via the `geolocator` package) plus the iOS "Always" location permission and Android background location permission aren't wired up. Both platforms scrutinize this heavily in app review and require clear in-app disclosure before you can even request the permission. This is a genuinely heavier lift than anything else built so far — budget real time for it, not a quick wire-up.
- [ ] **Budget Overview mockup is behind Flutter** — found while reorganizing mockups into solo/group journeys: the HTML mockup for screen 12 never included the "Log expense" button that the actual Flutter screen has. Unrelated to the solo/group reorganization — just a pre-existing gap noticed along the way. Not fixed yet.
- [ ] Real OpenFreeMap integration — the Map screen currently draws a stylized mock map (matching the HTML design), not real map tiles. This is deliberate, not a bug — the mock UI let the rest of the app get built without needing the map SDK wired up yet. Not a backend dependency; it's a separate library integration step (MapLibre GL for Flutter).
- [ ] Real QR code generation — Group Invite screen shows a placeholder icon, not an actual scannable QR. Needs a QR package (e.g. `qr_flutter`), unrelated to backend.
- [ ] The disruption/replan trigger is a demo-only icon button in the Itinerary screen — in production this flow opens via push notification tap, not a UI button. Fine for now, but flag it so nobody mistakes the demo button for the real trigger mechanism.
- [ ] No Firebase project set up (Firestore schema, Auth, Cloud Functions)
- [ ] No FastAPI service built — the AI/algorithm layer exists only as a plan
- [ ] No OR-Tools constraint model implemented
- [ ] No Ollama server deployed (Oracle free tier not yet tested for availability; DigitalOcean droplet confirmed as fallback)
- [ ] No real hotel/flight data wired up — screens will need mocked data until Phase 3
- [ ] No real-time group sync implementation (voting, shared dashboard are designed but not wired to a backend)
- [ ] No offline mode (architecture noted, not built)
- [ ] No authentication / user accounts
- [ ] No push notification setup (flight delay detection, etc.)
- [ ] No testing (unit, widget, integration)
- [ ] No app store setup (iOS/Android developer accounts, store listings)

### Content still needed
- [ ] Real copy pass (current screens use placeholder trip data — Lisbon, Oct 14–21, etc.)
- [ ] Real destination/activity data source (currently invented example content)
- [ ] Legal — privacy policy, terms of service (required before public beta)

---

## Suggested next steps, in order

**Frontend build is complete — all 15 screens exist in Flutter. Backend work starts now, per `backend-architecture.md`.**

1. **Set up the Firebase project** — Auth, Firestore (using the schema in `backend-architecture.md`), Cloud Functions, FCM
2. **Stand up the FastAPI service** — start with the simplest contract first (Budget — plain arithmetic, no AI/solver) to prove the auth-token-verification pattern works, before tackling Onboarding's OR-Tools + Ollama calls
3. **Deploy the Ollama container** (already built in `ai-service/`) — test Oracle free tier availability, fall back to a **DigitalOcean droplet** if unavailable
4. **Swap every flow's mock service for real API calls** — one file per flow, per the contract-first pattern already established
5. **Write Firestore security rules** before anything touches a real device
6. **Real OpenFreeMap and QR code integration** — both currently placeholders, both independent of backend work

---

## Reference: original roadmap (unchanged)

| Timeline | Milestone |
|---|---|
| Q1 2026 | Launch MVP with solo trip features (iOS + Android) |
| Q2 2026 | Add group collaboration module |
| Q3 2026 | Integrate booking APIs (Skyscanner, Booking.com) |
| Q4 2026 | Publish public beta on App Store & Play Store |

*Note: this roadmap predates the current build. Frontend work (Flutter + Next.js) is now complete, well ahead of the original Q1 2026 milestone — but backend work hasn't started, so Q1 2026 should still be re-baselined once Firebase/FastAPI development actually kicks off.*
