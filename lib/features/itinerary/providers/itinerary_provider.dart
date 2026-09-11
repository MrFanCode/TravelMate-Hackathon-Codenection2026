import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/itinerary_mock_service.dart';
import '../models/itinerary_models.dart';

class ItineraryNotifier extends ChangeNotifier {
  final ItineraryMockService _service = ItineraryMockService();

  ItineraryTrip? trip;
  int selectedDay = 1;
  bool isLoading = false;

  List<NearbySuggestion> nearby = [];
  bool isLoadingNearby = false;

  Future<void> loadTrip(String tripId) async {
    isLoading = true;
    notifyListeners();
    trip = await _service.fetchTrip(tripId);
    isLoading = false;
    notifyListeners();
  }

  void selectDay(int day) {
    selectedDay = day;
    notifyListeners();
  }

  ItineraryDay? get currentDay =>
      trip?.days.firstWhere((d) => d.day == selectedDay, orElse: () => trip!.days.first);

  Future<void> loadNearby() async {
    if (trip == null) return;
    isLoadingNearby = true;
    notifyListeners();
    nearby = await _service.fetchNearby(trip!.tripId, selectedDay);
    isLoadingNearby = false;
    notifyListeners();
  }

  Future<void> addFromSuggestion(NearbySuggestion s) async {
    if (trip == null) return;
    final activity = await _service.addFromSuggestion(trip!.tripId, selectedDay, s.id, '4:30 PM');
    final day = trip!.days.firstWhere((d) => d.day == selectedDay);
    day.activities.add(activity);
    notifyListeners();
  }

  Future<void> removeActivity(String activityId) async {
    if (trip == null) return;
    await _service.removeActivity(trip!.tripId, activityId);
    final day = trip!.days.firstWhere((d) => d.day == selectedDay);
    day.activities.removeWhere((a) => a.id == activityId);
    notifyListeners();
  }
}

final itineraryProvider = ChangeNotifierProvider<ItineraryNotifier>((ref) {
  return ItineraryNotifier();
});
