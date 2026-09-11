# Setup — Onboarding Flutter files

You already have an empty Flutter project in Android Studio. To drop these in:

## 1. Copy files
Copy everything inside this zip's `lib/` folder into your project's `lib/` folder,
**overwriting** the default `lib/main.dart` that `flutter create` generates.

## 2. Add dependencies
Open your project's `pubspec.yaml` and add these two lines under `dependencies:`
(keep whatever's already there — just add these):

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  google_fonts: ^6.2.1
```

## 3. Install and run
```bash
flutter pub get
flutter run
```

## What you'll see
Welcome → Trip Setup (with mock flight/hotel suggestions) → Interest Selection →
Solo/Group → Itinerary (day timeline, tap an activity for its detail card) → Map tab
(pinned stops + nearby suggestions you can add). Bottom nav bar appears starting at
the Itinerary screen — Budget and Group tabs are visible but not wired up yet.

## No backend needed yet
Everything runs on mock services (`OnboardingMockService`, `ItineraryMockService`),
which return data shaped exactly like `onboarding-api-contract.md` and
`solo-itinerary-api-contract.md`. When the real FastAPI backend exists, only those
two files need to change.
