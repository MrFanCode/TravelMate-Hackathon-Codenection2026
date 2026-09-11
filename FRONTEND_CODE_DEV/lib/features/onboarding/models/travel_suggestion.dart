/// Matches the response of GET /suggestions/travel in
/// onboarding-api-contract.md.
class FlightSuggestion {
  final String id;
  final String flightNumber;
  final DateTime departTime;
  final bool direct;
  final double priceUsd;

  FlightSuggestion({
    required this.id,
    required this.flightNumber,
    required this.departTime,
    required this.direct,
    required this.priceUsd,
  });

  factory FlightSuggestion.fromJson(Map<String, dynamic> json) => FlightSuggestion(
        id: json['id'],
        flightNumber: json['flight_number'],
        departTime: DateTime.parse(json['depart_time']),
        direct: json['direct'],
        priceUsd: (json['price_usd'] as num).toDouble(),
      );
}

class HotelSuggestion {
  final String id;
  final String name;
  final double distanceFromCenterMi;
  final double pricePerNightUsd;

  HotelSuggestion({
    required this.id,
    required this.name,
    required this.distanceFromCenterMi,
    required this.pricePerNightUsd,
  });

  factory HotelSuggestion.fromJson(Map<String, dynamic> json) => HotelSuggestion(
        id: json['id'],
        name: json['name'],
        distanceFromCenterMi: (json['distance_from_center_mi'] as num).toDouble(),
        pricePerNightUsd: (json['price_per_night_usd'] as num).toDouble(),
      );
}

class TravelSuggestions {
  final List<FlightSuggestion> flights;
  final List<HotelSuggestion> hotels;

  TravelSuggestions({required this.flights, required this.hotels});
}
