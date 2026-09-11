import '../models/travel_suggestion.dart';
import '../models/trip.dart';
import '../models/onboarding_data.dart';

/// Stands in for the real backend until FastAPI exists.
/// Every method here returns data shaped EXACTLY like
/// onboarding-api-contract.md — when the real API is ready, swap the
/// body of these two methods for real http calls. Nothing else in the
/// app should need to change.
class OnboardingMockService {
  Future<TravelSuggestions> fetchTravelSuggestions({
    required String destination,
    required DateTime departDate,
    required DateTime returnDate,
    required double budgetUsd,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400)); // pretend it's a network call

    return TravelSuggestions(
      flights: [
        FlightSuggestion(
          id: 'fl_001',
          flightNumber: 'TP1358',
          departTime: departDate.add(const Duration(hours: 7, minutes: 40)),
          direct: true,
          priceUsd: 340,
        ),
      ],
      hotels: [
        HotelSuggestion(
          id: 'ht_001',
          name: 'Hotel Alfama Rio',
          distanceFromCenterMi: 0.4,
          pricePerNightUsd: 86,
        ),
      ],
    );
  }

  Future<Trip> createTrip(OnboardingData data) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return Trip(
      tripId: 'trip_9f2a',
      destination: data.destination ?? 'Unknown',
      tripType: data.tripType,
      inviteCode: data.tripType == 'group' ? 'lsb-oct14' : null,
      days: [
        TripDay(day: 1, date: '2026-10-14', activities: [
          TripActivity(
            id: 'act_01',
            time: '08:30',
            title: 'Pastel de nata at Manteigaria',
            durationMin: 30,
            costUsd: 6,
          ),
          TripActivity(
            id: 'act_02',
            time: '10:00',
            title: 'Belém Tower & riverside walk',
            durationMin: 120,
            costUsd: 8,
          ),
        ]),
      ],
    );
  }
}
