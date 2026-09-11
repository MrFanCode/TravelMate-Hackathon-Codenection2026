import '../models/itinerary_models.dart';

/// Stands in for the FastAPI backend. Returns data shaped exactly like
/// solo-itinerary-api-contract.md. Swap the bodies for real http calls
/// once the backend exists — nothing else in the app should need to change.
class ItineraryMockService {
  Future<ItineraryTrip> fetchTrip(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return ItineraryTrip(
      tripId: tripId,
      destination: 'Lisbon',
      tripType: 'solo',
      days: List.generate(5, (i) {
        final day = i + 1;
        if (day != 1) {
          return ItineraryDay(day: day, date: '2026-10-${13 + day}', activities: []);
        }
        return ItineraryDay(
          day: 1,
          date: '2026-10-14',
          activities: [
            Activity(
              id: 'act_01',
              time: '8:30 AM',
              title: 'Pastel de nata at Manteigaria',
              durationMin: 30,
              costUsd: 6,
              locationName: 'Manteigaria, Lisbon',
              lat: 38.7107,
              lng: -9.1425,
              description: 'A 16th-century bakery famous for warm custard tarts, steps from Rossio Square.',
            ),
            Activity(
              id: 'act_02',
              time: '10:00 AM',
              title: 'Belém Tower & riverside walk',
              durationMin: 120,
              costUsd: 8,
              locationName: 'Belém, Lisbon',
              lat: 38.6916,
              lng: -9.2160,
              description: 'A 16th-century fortress marking the mouth of the Tagus — climb the tower, then follow the riverside path back toward Jerónimos Monastery.',
            ),
            Activity(
              id: 'act_03',
              time: '1:00 PM',
              title: 'Lunch — Time Out Market',
              durationMin: 60,
              costUsd: 18,
              locationName: 'Time Out Market, Lisbon',
              lat: 38.7069,
              lng: -9.1454,
              description: 'A food hall gathering some of the city\'s best chefs under one roof.',
            ),
            Activity(
              id: 'act_04',
              time: '4:00 PM',
              title: 'Alfama viewpoint hike',
              durationMin: 90,
              costUsd: 0,
              locationName: 'Alfama, Lisbon',
              lat: 38.7128,
              lng: -9.1303,
              description: 'Lisbon\'s oldest district — narrow lanes climbing to a sweeping river viewpoint.',
            ),
            Activity(
              id: 'act_05',
              time: '7:30 PM',
              title: 'Fado dinner show',
              durationMin: 120,
              costUsd: 32,
              locationName: 'Alfama, Lisbon',
              lat: 38.7115,
              lng: -9.1290,
              description: 'Traditional Portuguese music over a multi-course dinner in a small Alfama venue.',
            ),
          ],
        );
      }),
    );
  }

  Future<List<NearbySuggestion>> fetchNearby(String tripId, int day) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      NearbySuggestion(
        id: 'sug_01',
        type: SuggestionType.attraction,
        title: 'LX Factory — creative quarter',
        lat: 38.7027,
        lng: -9.1784,
      ),
      NearbySuggestion(
        id: 'sug_02',
        type: SuggestionType.hotel,
        title: 'Hotel Alfama Rio',
        subtitle: '\$86/night',
        lat: 38.7122,
        lng: -9.1301,
      ),
    ];
  }

  Future<Activity> addFromSuggestion(String tripId, int day, String suggestionId, String time) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Activity(
      id: 'act_new_${DateTime.now().millisecondsSinceEpoch}',
      time: time,
      title: 'LX Factory — creative quarter',
      durationMin: 90,
      costUsd: 0,
      locationName: 'LX Factory, Lisbon',
      lat: 38.7027,
      lng: -9.1784,
      description: 'A converted industrial complex now full of galleries, shops, and cafés.',
    );
  }

  Future<void> removeActivity(String tripId, String activityId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // mock — real backend deletes and returns { "removed": true }
  }
}
