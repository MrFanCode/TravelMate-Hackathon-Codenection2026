import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/onboarding_mock_service.dart';
import '../models/onboarding_data.dart';
import '../models/travel_suggestion.dart';
import '../models/trip.dart';

/// Holds onboarding state across screens 2-4, and talks to
/// OnboardingMockService (swap for a real API client later).
class OnboardingNotifier extends ChangeNotifier {
  final OnboardingMockService _service = OnboardingMockService();

  OnboardingData data = const OnboardingData();
  TravelSuggestions? suggestions;
  bool isLoadingSuggestions = false;
  bool isCreatingTrip = false;
  Trip? createdTrip;

  void updateTripBasics({
    required String destination,
    required DateTime departDate,
    required DateTime returnDate,
    required double budgetUsd,
  }) {
    data = data.copyWith(
      destination: destination,
      departDate: departDate,
      returnDate: returnDate,
      budgetUsd: budgetUsd,
    );
    notifyListeners();
  }

  Future<void> loadSuggestions() async {
    if (data.destination == null || data.departDate == null || data.returnDate == null) return;
    isLoadingSuggestions = true;
    notifyListeners();
    suggestions = await _service.fetchTravelSuggestions(
      destination: data.destination!,
      departDate: data.departDate!,
      returnDate: data.returnDate!,
      budgetUsd: data.budgetUsd,
    );
    isLoadingSuggestions = false;
    notifyListeners();
  }

  void pickFlight(String? id) {
    data = data.copyWith(selectedFlightId: id);
    notifyListeners();
  }

  void pickHotel(String? id) {
    data = data.copyWith(selectedHotelId: id);
    notifyListeners();
  }

  void toggleInterest(String tag) {
    final current = List<String>.from(data.interests);
    current.contains(tag) ? current.remove(tag) : current.add(tag);
    data = data.copyWith(interests: current);
    notifyListeners();
  }

  void setTripType(String type) {
    data = data.copyWith(tripType: type);
    notifyListeners();
  }

  Future<Trip> submitTrip() async {
    isCreatingTrip = true;
    notifyListeners();
    final trip = await _service.createTrip(data);
    createdTrip = trip;
    isCreatingTrip = false;
    notifyListeners();
    return trip;
  }
}

final onboardingProvider = ChangeNotifierProvider<OnboardingNotifier>((ref) {
  return OnboardingNotifier();
});
