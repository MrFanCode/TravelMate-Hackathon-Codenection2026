/// Everything collected across onboarding screens 2-4.
/// Matches the request body of POST /trips in onboarding-api-contract.md —
/// keep this in sync with that file if the contract changes.
class OnboardingData {
  final String? destination;
  final DateTime? departDate;
  final DateTime? returnDate;
  final double budgetUsd;
  final String? selectedFlightId;
  final String? selectedHotelId;
  final List<String> interests;
  final String tripType; // 'solo' | 'group'

  const OnboardingData({
    this.destination,
    this.departDate,
    this.returnDate,
    this.budgetUsd = 750,
    this.selectedFlightId,
    this.selectedHotelId,
    this.interests = const [],
    this.tripType = 'solo',
  });

  OnboardingData copyWith({
    String? destination,
    DateTime? departDate,
    DateTime? returnDate,
    double? budgetUsd,
    String? selectedFlightId,
    String? selectedHotelId,
    List<String>? interests,
    String? tripType,
  }) {
    return OnboardingData(
      destination: destination ?? this.destination,
      departDate: departDate ?? this.departDate,
      returnDate: returnDate ?? this.returnDate,
      budgetUsd: budgetUsd ?? this.budgetUsd,
      selectedFlightId: selectedFlightId ?? this.selectedFlightId,
      selectedHotelId: selectedHotelId ?? this.selectedHotelId,
      interests: interests ?? this.interests,
      tripType: tripType ?? this.tripType,
    );
  }

  Map<String, dynamic> toJson() => {
        'destination': destination,
        'depart_date': departDate?.toIso8601String().split('T').first,
        'return_date': returnDate?.toIso8601String().split('T').first,
        'budget_usd': budgetUsd,
        'selected_flight_id': selectedFlightId,
        'selected_hotel_id': selectedHotelId,
        'interests': interests,
        'trip_type': tripType,
      };
}
