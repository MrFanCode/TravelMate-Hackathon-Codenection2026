/// Matches GET /trips/{trip_id} in solo-itinerary-api-contract.md.
/// Note: richer than the onboarding Trip model (adds location/description) —
/// this is the canonical Activity shape going forward.
class Activity {
  final String id;
  final String time;
  final String title;
  final int durationMin;
  final double costUsd;
  final String locationName;
  final double lat;
  final double lng;
  final String description;

  Activity({
    required this.id,
    required this.time,
    required this.title,
    required this.durationMin,
    required this.costUsd,
    required this.locationName,
    required this.lat,
    required this.lng,
    required this.description,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'],
        time: json['time'],
        title: json['title'],
        durationMin: json['duration_min'],
        costUsd: (json['cost_usd'] as num).toDouble(),
        locationName: json['location_name'] ?? '',
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        description: json['description'] ?? '',
      );
}

class ItineraryDay {
  final int day;
  final String date;
  final List<Activity> activities;

  ItineraryDay({required this.day, required this.date, required this.activities});

  factory ItineraryDay.fromJson(Map<String, dynamic> json) => ItineraryDay(
        day: json['day'],
        date: json['date'],
        activities: (json['activities'] as List).map((a) => Activity.fromJson(a)).toList(),
      );
}

class ItineraryTrip {
  final String tripId;
  final String destination;
  final String tripType;
  final List<ItineraryDay> days;

  ItineraryTrip({
    required this.tripId,
    required this.destination,
    required this.tripType,
    required this.days,
  });

  factory ItineraryTrip.fromJson(Map<String, dynamic> json) => ItineraryTrip(
        tripId: json['trip_id'],
        destination: json['destination'],
        tripType: json['trip_type'],
        days: (json['days'] as List).map((d) => ItineraryDay.fromJson(d)).toList(),
      );
}

/// Matches the /nearby suggestion shape — attraction or hotel pins on the map.
enum SuggestionType { attraction, hotel }

class NearbySuggestion {
  final String id;
  final SuggestionType type;
  final String title;
  final String? subtitle;
  final double lat;
  final double lng;

  NearbySuggestion({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.lat,
    required this.lng,
  });

  factory NearbySuggestion.fromJson(Map<String, dynamic> json) => NearbySuggestion(
        id: json['id'],
        type: json['type'] == 'hotel' ? SuggestionType.hotel : SuggestionType.attraction,
        title: json['title'],
        subtitle: json['subtitle'],
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
      );
}
